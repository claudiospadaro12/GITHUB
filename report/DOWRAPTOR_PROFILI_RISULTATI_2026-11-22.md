# Set `g` sul Dow (motore UBS di Wim): misura del drawdown a 4 taglie — risultati (22/11/2026)
Zip `ANNO_ORO_GRADINI_UBSDR_20261122_1713.zip`. Clone `U30USD_T`, tick reali (Modello 4), M15, 26/09/2024 -> 13/11/2026, deposito 80.000 EUR, lotto fisso (StartLots), 129 operazioni a ogni taglia. Flag KO e qualita 74% = formali (primi mesi senza tick). Criteri: `DOWRAPTOR_PROFILI_CRITERI_2026-11-22.md`.
| StartLots | Profitto | PF | DD equity (valuta / % del picco) | DD per lotto | Profitto per lotto |
|---|---|---|---|---|---|
| 0,1 | 318,64 | 2,00 | 155,00 / 0,19% | 1.550 | 3.186 |
| 1,5 | 2.996,05 | 2,01 | 1.395,20 / 1,70% | 930 | 1.997 |
| 3 | 6.067,30 | 1,98 | 2.898,77 / 3,43% | 966 | 2.022 |
| 5 | 10.342,26 | 2,00 | 4.757,97 / 5,42% | 952 | 2.068 |
**Cancelli:** linearita (1,5 / 3 / 5 entro +-15% della media 949,5 per lotto): **superato** (-2%, +2%, 0%). No money / stop out: nessuno. Previsioni: P-1 (linearita) si; **P-2 (lotti PROP 1,2-2,0, MEDIO 2,4-4,0, ALTO 4,0-6,5) NO**; P-3 si; P-4 si (DD a 0,1 lotti = 155,00 come il solo 2025-26).
**Risultato:** a 0,1 lotti il DD per lotto e sovrastimato di 1,6 volte (arrotondamento del lotto minimo): la stima lineare da 0,1 era sbagliata. Lotti per il DD obiettivo su 80.000 (interpolati dalle misure): **PROP 3% (2.400): circa 2,5 lotti; MEDIO 6% (4.800): circa 5,05 lotti; ALTO 10% (8.000): circa 8,5 lotti (ESTRAPOLATO oltre i 5 lotti misurati)**. Profitto atteso su 26 mesi a quelle taglie (circa 2.000 per lotto): circa 5.000 / 10.400 / 17.600.
**La simulazione di portafoglio oro + Dow resta valida:** scalava profitti e perdite del Dow per il DD obiettivo con il rapporto profitto/DD di 0,1 lotti (2,06); il rapporto misurato e 2,09-2,17 (stabile): conservativa di circa il 3-5%. Da qui: i profili Dow sono definiti dal DD obiettivo, non dai lotti dell'ipotesi iniziale.
**Limiti:** estrapolazione a 8,5 lotti (margine non verificato); e il set `g` di Wim (motore UBS), non il nostro EA; 26 mesi, un regime. Nessun consiglio su taglie.
