# Momentum 30 min con filtri - RISULTATI (27/11/2026) - 0 candidate
Criteri: `MOMENTUM_FILTRI_CRITERI_2026-11-27.md` (F2 = |apertura 16:00 ieri - apertura 09:30 ieri| >= mediana dei 60 giorni precedenti, come implementato in `momentum_filtri.py`). 12 celle (F1 mossa grande, F2 volatilita' alta, F4 trend D1) x V1/V2 x Nasdaq/S&P, 2015-26, ~650-730 operazioni IS per cella.
- **Costi stimati:** PF IS 0,59-0,82, OOS 0,58-0,96, hold-out 0,76-1,08. Anni positivi 1-3 su 12. Controllo casuale con lo stesso filtro 0,80-0,86.
- **Costo zero:** PF IS 0,77-1,04, OOS 0,67-1,07, hold-out 0,85-1,17; anni positivi 2-7 su 12; controllo casuale 0,97-1,01. Il filtro che migliora di piu' (F4 trend) ha IS 0,86-0,91 e OOS 0,86-1,07: sotto il caso in campione.
- Nessuna cella supera il cancello (IS >= 1,30). I filtri non creano un vantaggio dove non c'e': il segnale grezzo ha lordo negativo.
- Momentum intraday 2015-26 sugli indici USA: chiuso in tutte le forme provate (regola del paper 6 celle, griglia 300 x 2, 12 con filtri). Resta aperto solo il controllo 2011-14 (effetto del paper decaduto?) in attesa dei dati.
