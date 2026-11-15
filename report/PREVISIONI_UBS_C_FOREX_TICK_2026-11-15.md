# UBS C forex a tick reali: previsioni scritte PRIMA dei numeri (15/11/2026)

Riga: `RIGA_LANCIA_UBS_CFT.txt` (pin `3954dfe2`). 7 set (scalper EURUSD SL17 e SL22, GBPUSD H1, USDJPY H1 e H4; VOL_f, VOL_o), 2025, lotto 0,1, Modello 1 e Modello 4 sulla stessa finestra: 14 passate. Confronto: PF tick / PF M1 >= 0,7, DD tick <= 1,5 x M1 (soglie del piano), operazioni +-10%, % vincenti +-10 punti. Riferimento: sull'oro i tick hanno dato netto x0,83-0,92 e DD x1,02-1,35 (`RISULTATI_TICK_P3_2026-11-14.md`); gli scalper forex hanno stop e target corti, quindi sono piu sensibili.

**Perche ci aspettiamo un peggioramento:** il Modello 1 inventa i tick dentro la barra (ordine di tocco di SL e TP, spread fisso). Con target di pochi pip, lo spread vero e il tocco reale dei livelli pesano di piu che sull'oro D1.

- **T-1** Tutte le 14 passate valide (stato OK, qualita storico >= 98%): 55%. Almeno una passata a tick con qualita sotto 98% (tick forex 2025 incompleti sul BCM): 30%. Passate a tick KO per mancanza di dati: 15%.
- **T-2** PF tick / PF M1 degli scalper, mediana dei 5: fra 0,6 e 0,95: 60%; >= 0,95 (nessun peggioramento): 15%; < 0,6: 25%.
- **T-3** Almeno 1 dei 5 scalper sotto la soglia PF tick / PF M1 < 0,7: 55%.
- **T-4** Almeno 3 dei 5 scalper hanno ancora PF tick >= 1,30: 60%. Nessuno scalper ha PF tick >= 1,30: 15%.
- **T-5** Il DD a tick e <= 1,5 x M1 in almeno 3 dei 5 scalper: 55% (DD minuscoli e rumorosi: un solo evento cambia il rapporto).
- **T-6** VOL_f e VOL_o: PF tick / PF M1 fra 0,85 e 1,10 per entrambi: 65% (poche operazioni, stop larghi, meno sensibili al tick).
- **T-7** Il numero di operazioni cambia piu del 10% in almeno uno scalper: 55%.
- **T-8** Dei 5 scalper ne resta almeno 1 che supera tutte le soglie del piano (PF >= 0,7 x M1, DD <= 1,5 x M1, operazioni +-10%, win rate +-10 punti): 50%; nessuno: 25%; tutti e 5: 10%.
- **T-9** Durata di una passata a tick: 10-60 minuti: 50%; oltre 60: 30%; sotto 10: 20% (non misurata sul forex).

**Cosa NON si deduce:** un anno (2025) e un percorso per set; spread e commissioni del tester non sono quelli FTMO; il risultato su 2025 non dice nulla sugli anni 2013-2024 (i tick reali di quegli anni sul BCM sono NON VERIFICATI).
