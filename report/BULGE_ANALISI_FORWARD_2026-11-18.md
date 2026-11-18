# Bulge: analisi delle 699 operazioni sul demo 50503392 (18/11/2026) e ipotesi di miglioramento
Natura: lettura di dati gia prodotti (report cronologia del 18/11; operazioni riconosciute dal commento "BULGE*", niente magic number). Nessun giudizio su lotti/taglie/acquisti. **Tutto cio che segue e IN-CAMPIONE sugli stessi dati: ipotesi, non conclusioni.**

## Natura dell'EA (dal sorgente `ABTG_Bulge.mq5`, ramo `claude/backtest-pipeline-review-et11mo`, e dai documenti della Sala del Consiglio)
Mean reversion dopo espansione delle Bollinger (BB 20/2,0, bande > 1,1 x media su 50 barre), segnali BLU (2a candela in bulge), VIOLA (post-bulge), ARANCIO spento; **SL = 3 ATR**, target breve (~0,25R in media); filtro ATR (0,5-1,8 x media), filtro ADX (soglia 30, solo sui BLU), kill switch (4 SL/giorno, 3 SL di fila, -2%/giorno). Non ha ingresso/uscita a tempo; BE, parziale e trailing esistono ma sono SPENTI. La Sala del Consiglio (01/11) aveva trovato: oro H1 **inconcludente (PF 0,51)**; forex H1 anni nuovi **NON DIMOSTRATO (PF 1,03, N 49, win 73,5% contro pareggio 75,9%)**: la geometria stop 3 ATR / target ~1 ATR richiede ~76-78% di vincenti.

## Misure sul demo (699 operazioni, 30/03-18/11)
- In EUR: netto -2.599, PF 0,76, vincenti 69%, media vincita 17,4, media perdita 52,0 (pareggio 75%). **In R** (lotti normalizzati): R medio **-0,033**, PF(R) **0,85**, vincite 0,25R, perdite 0,93R, vincenti 76% contro pareggio 79%. **Quindi vicino al pareggio, non una catastrofe**: il PF in euro peggiora perche i lotti variano (media 0,43 in MULTI, 0,17 in V520, 0,20 in AZZURRA).
- **Durata dell'operazione (R medio):** < 2 h **+0,18** (171 op, 92% vincenti); 2-8 h 0,00 (256); 8-24 h **-0,17** (232); > 24 h **-0,37** (40, 52% vincenti). Gradiente monotono: i trade che il mercato non chiude subito col target sono quelli che arrivano allo SL. **Ipotesi 1: uscita a tempo (N ore).** Non verificabile dai soli dati (serve il percorso dei prezzi) e l'EA non ha l'input: serve codice.
- **Per cross** (n >= 12 in EUR): meglio EURUSD, USDCHF, USDCAD, EURGBP, GBPUSD; peggio AUDJPY, GBPJPY, GBPCAD, AUDNZD, NZDUSD, GBPAUD, NZDJPY. **Persistenza fra periodi** (MULTI apr-giu contro V520/AZZURRA set-nov, 22 cross con n >= 6 in entrambi): correlazione di rango sull'R medio **rho = 0,28**: la classifica per cross e **in gran parte rumore**; solo EURUSD, USDCAD, USDCHF restano positivi in entrambi i periodi (campioni piccoli). **Ipotesi 2 (scelta dei cross) non e affidabile con questi dati.**
- Per ora del giorno e giorno della settimana: oscillazioni ampie (es. ora 12: PF 0,20, giovedi PF 0,61) ma con 20-50 operazioni per cella: **da non usare** per filtri senza test fuori campione.
- Direzione: buy PF 0,82, sell PF 0,71. Segnale: BLU 0,82, VIOLA 0,59, AZZURRA 0,98.

## Ipotesi da provare (criteri da scrivere PRIMA dei numeri, nessuna regola presa dai dati)
1. **Uscita a tempo** a 2, 4, 8 ore (richiede una copia `ABTG_Bulge_TS` con input nuovo; l'originale non si tocca).
2. **Geometria:** SL 2 ATR invece di 3 (input esistente) o target piu largo.
3. **Filtro ADX** anche sui VIOLA (PF 0,59, il segnale peggiore) e soglia diversa.
4. **Scelta dei cross** solo se supera una prova su un periodo NON usato per sceglierli.
Prova su MT5 tester, storico BCM forex 2013-2025 a barre da 1 minuto, nessuna ottimizzazione libera: poche varianti e porte scritte prima. Serve sapere quale versione/set di Bulge gira sul demo.
