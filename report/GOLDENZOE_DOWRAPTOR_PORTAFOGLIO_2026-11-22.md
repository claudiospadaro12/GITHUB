# GoldenZoe + DowRaptor insieme: simulazione di challenge con partenze diverse (22/11/2026)
Script `backtest_runner/simulatore/gz_dow_portafoglio.py`; uscita completa `GOLDENZOE_DOWRAPTOR_PORTAFOGLIO_dati.txt`. Conto 80.000 condiviso, oro = GoldenZoe base (simulatore FTMO M1, minimi di equity al minuto, rischio % sull'equity totale), Dow = **127 operazioni vere del tester a tick** (set `g`, 0,1 lotti: 14 dal 26/09 al 31/12/2024 + 113 dal 02/01/2025 al 13/11/2026), poi **moltiplicate linearmente** per i profili (PROP x15,5, MEDIO x31, ALTO x51,6 = DD 3/6/10% su 80.000 dal DD massimo di 155 a 0,1 lotti: STIMA LINEARE, la misura a 4 taglie non e ancora stata fatta). Regole assunte (non verificate): +10% fase 1, +5% fase 2, perdita giornaliera 5%, totale 10% dal capitale iniziale. 90 partenze settimanali dal 26/09/2024 (finestra di soli 26 mesi: e tutto lo storico a tick del Dow).
**Correlazione oro-Dow:** P&L giornaliero chiuso 0,01; mensile 0,13: praticamente scorrelati (campione piccolo).
**Limiti:** il Dow e contato al saldo chiuso (non c'e il flottante nel report): le perdite del giorno sono messe al minimo del giorno (prudente), ma le escursioni intraday non chiuse non si vedono; 127 operazioni, una sola finestra, un solo regime; gli stessi giorni di partenza per tutte le combinazioni; partenze sovrapposte (non indipendenti).
## Fase 1 (+10%): % partenze passate / mediana giorni di chi passa / fallite per perdita giornaliera 5% (le altre sono "non concluse entro novembre 2026")
| Oro \ Dow | nessuno | PROP | MEDIO | ALTO |
|---|---|---|---|---|
| PROP 0,5% | 0% / - / 0 | 30% / 629 / 0 | 56% / 364 / 0 | 42% / 185 / **46** |
| MEDIO 0,9% | 46% / 350 / 0 | 54% / 287 / 0 | 67% / 267 / 0 | 51% / 161 / **42** |
| ALTO 1,3% | 60% / 273 / 0 | 61% / 253 / 0 | **72% / 218 / 0** | 51% / 154 / **42** |
## Fase 2 (+5%)
| Oro \ Dow | nessuno | PROP | MEDIO | ALTO |
|---|---|---|---|---|
| PROP | 49% / 335 / 0 | 67% / 256 / 0 | 100% / 188 / 0 | 54% / 88 / 41 |
| MEDIO | 66% / 238 / 0 | 77% / 196 / 0 | **100% / 146 / 0** | 58% / 78 / 38 |
| ALTO | 77% / 134 / 0 | 80% / 118 / 0 | **100% / 112 / 0** | 60% / 77 / 36 |
**Lettura:** (1) aggiungere il Dow fa passare di piu e piu in fretta (es. oro ALTO: 60% -> 72% in fase 1, mediana 273 -> 218 giorni). (2) **Il Dow ALTO (10% da solo) non va: fallisce per perdita giornaliera in circa il 45% delle partenze** perche il suo giorno peggiore (11/12/2025: -108 a 0,1 lotti) a x51,6 = -5.594 = -7% del conto in una sola giornata. A MEDIO sarebbe -3.360 (4,2%): gia vicino al 5%; a PROP -1.680 (2,1%). (3) La combinazione che passa di piu senza fallimenti nella finestra e oro ALTO + Dow MEDIO, ma il DD dei due insieme e la somma delle code: da misurare. (4) Un terzo EA (richiesto) riduce ancora il peso di ciascuno. Nessun consiglio su taglie.
