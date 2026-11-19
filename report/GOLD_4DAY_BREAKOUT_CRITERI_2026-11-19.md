# Gold 4-Day Breakout (PDF di Massimo del 19/11): test indipendente su anni mai usati — criteri scritti PRIMA dei numeri (19/11/2026)
**Perche':** il PDF riporta PF 1,31 sul 2023-2026 ma PF 0,97-1,08 sul 2019-2023 (in pari): la costruzione non ha trovato nessun vantaggio e il "fuori campione" e' un periodo di oro volatile. Abbiamo l'oro FTMO M1 **2014-11 -> 2020-12**: il 2014-2018 NON e' stato visto da nessuno nella costruzione del PDF. Si rifa' la regola con i suoi parametri, senza ottimizzare.
**Regola (dal PDF; dove il PDF e' ambiguo, scelta fissata qui):** livelli = massimo e minimo dei 4 giorni (giorni del server FTMO) precedenti. Ordini stop: buy al massimo, sell al minimo, un long e un short al massimo per giorno, nella finestra 09:00-21:00 ora italiana = **10:00-22:00 ora server FTMO** (server = ora italiana + 1); ingresso al livello (o all'apertura se la barra apre oltre); stop **0,5 x ATR(14) giornaliero** (ATR dei 14 giorni precedenti); nessun target; **chiusura forzata alle 22:00 server**; stop-first nella stessa barra M1. Costo all-in 0,35 USD. R = distanza dello stop.
**Test:** periodo A = 2014-11 -> 2018-12 (mai visto); periodo B = 2019-2020 (sovrapposto al loro in-sample). Variazioni solo per il plateau: giorni {3,4,5,6} x stop {0,3; 0,5; 0,75; 1,0} ATR. Nessuna ottimizzazione.
**Porta (scritta ora):** CONFERMATO se nel periodo A, con i parametri base: >= 150 operazioni, PF > 1,2, R medio > 0, e sia i long sia gli short con PF > 1,0; e plateau: almeno 10 celle su 16 con PF > 1,1. Altrimenti NON CONFERMATO (e il PF 1,31 e' legato al regime 2023-26).
## Previsioni
- Periodo A, base: PF < 1,1: **70%**; CONFERMATO: **12%**.
- Periodo B (2019-2020): PF tra 0,9 e 1,15: **65%** (coerente con il loro "in pari").
- Plateau con PF > 1,1 su >= 10 celle su 16 nel periodo A: **10%**.
## Limiti
Il PDF non dice numero di operazioni, ATR (periodo), orario di chiusura, ne' se il costo e' 0,35 USD: le scelte sono mie e dichiarate. Il 2021-2026 non e' nei dati di questa sessione (il test non conferma ne' smentisce il loro 2023-26).

## RISULTATI (`backtest_runner/simulatore/gold_4day_breakout.py`; XAUUSD FTMO M1, giorni 2014-11-03 -> 2020-12-31, riga 00:00 scartata)
- **Periodo A 2014-2018 (mai visto), base 4 giorni / 0,5 ATR:** 516 operazioni, R medio -0,002, **PF 1,00**, win 47%, vincente medio 0,78R, perdente medio -0,70R (struttura simile a quella del PDF: 0,81R / -0,66R). Long PF 1,07 (248), short PF 0,93 (268). Per anno: 2015 1,08; 2016 1,50; 2017 0,84; 2018 0,69.
- **Periodo B 2019-2020:** 245 operazioni, R +0,02, **PF 1,05** (2019 0,89; 2020 1,24): coincide col loro "in pari" 0,97-1,08.
- **Plateau (periodo A, 16 celle giorni 3-6 x stop 0,3-1,0 ATR):** PF 0,95-1,11; **1 cella su 16 con PF > 1,1**. L'unico filo: piu' giorni (N=6) leggermente meglio (1,08-1,11), nulla di significativo.
- **Verdetto con la porta scritta: NON CONFERMATO.** Previsioni: A PF < 1,1 (70%) -> si'; confermato (12%) -> no; B tra 0,9 e 1,15 (65%) -> si'; plateau >= 10/16 (10%) -> no.
**Lettura:** su 2014-2020 la regola non ha vantaggio (PF 1,00-1,05); il PF 1,31 del PDF riguarda 2023-2026 (oro molto volatile) e non si e' mai visto in 6 anni di dati indipendenti da quel periodo. Non e' una conferma: e' un periodo favorevole. Il test non puo' dire nulla sul 2021-2022 (nessun dato in questa sessione). Il filtro di volatilita' proposto nel PDF e' stato pensato guardando il periodo in cui la strategia ha funzionato: se si prova va scritto prima e giudicato su anni mai visti.
