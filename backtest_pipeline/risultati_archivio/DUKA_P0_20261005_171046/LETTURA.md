# DUKA P0 -- referto del 05/10/2026 17:10:46 (PC di backtest DESKTOP-H4D7CAJ), letto il 05/10

Fatti MISURATI (dal referto; la riga e' di sola lettura, bootstrap aec4f899, pin c8cad0c3):
- Disco C: 326,69 GB liberi (soglia F1 12 GB; nucleo ~8,4 GB). Anche E: 848,8 GB e F: 808,5 GB.
- Cache `raw\USA30IDXUSD`: 222 giorni su 222 COMPLETI, 0 buchi, 0 doppi; 1172 slot a zero byte (ore vuote o troncate, non distinguibili da qui); i 9 giorni della sonda (4 nuovi inclusi 2025.03.12) sono tutti in cache. 22 file fuori dai 222 giorni (es. 2015\06\15).
- CSV `U30USD_DK_ticks_*` in tick\: 9 file, 20.753.611 righe, 0,85 GB, scritti il 03/09, calendario DST `usa` (referto v2).
- MT5 chiuso; 103 grafici .chr, 0 con EA; conto 50503392; MaxBars del terminale PC = 100000000.
- Tick nativi `U30USD`: 27 file mensili (202409..202610); mesi della sonda presenti 7 su 7 (presenza del MESE, non del giorno 2024.11.20).
- Custom U30USD_DK presente (TICK + barre M1); nessun residuo DKNEG. Python 3.14 e curl presenti (non eseguiti).
Non misurato da P0: validita' dei .bi5 (la conta dukascopy_tick.py --solo-cache), giorno 2024.11.20 nei tick nativi, tempo di import, ritmo di download (canarino P3).
