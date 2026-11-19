# Domande per Massimo (versione aggiornata con il filtro di volatilita') - 19/11/2026
Ciao Massimo, grazie per i due PDF. Ho rifatto la regola e il filtro sull'oro FTMO 2014-2020 (anni che voi non avete usato): 4 giorni senza filtro 2014-2018 PF 1,00 (516 op.), 2019-2020 PF 1,05. Il filtro A (ATR14 > soglia x ATR100) peggiora il 2014-2018 (PF 0,52-0,88) e migliora un poco il 2019-2020 (1,10-1,14): nessun effetto stabile; le varianti piu' selettive hanno 2-33 operazioni. Sto aspettando i dati FTMO 2021-2026 per rifare il vostro 2023-26. Per replicare con le vostre regole e non con le mie ipotesi mi servono:

**Regole esatte**
1. ATR giornaliero (14?): media semplice o di Wilder? "ATR(100)" e' la media del vero range a 100 giorni o la media dell'ATR(14)?
2. "Ultimi 4 giorni": giorni del server o sessioni 24h? Includono il giorno corrente?
3. Orario di ingresso e di chiusura forzata (io ho usato 10:00-22:00 server FTMO = 09:00-21:00 italiane).
4. Ingresso con ordine stop al livello o a mercato? Gap oltre il livello? Lo stop vale nella stessa barra d'ingresso? Se tocca livello e stop insieme, come lo contate?
5. Il R del PDF e' la distanza dello stop (0,5 ATR)?

**Numeri**
6. Operazioni totali e per anno (2019-2026), con PF e R per anno.
7. La "robustezza" (3-6 giorni, stop diversi, PF 1,21-1,36) e' misurata sul 2023-26 o sul 2019-23? I parametri sono stati scelti su quale periodo?
8. Il 2023-26 l'avevate guardato prima di fissare i parametri e di pensare al filtro?
9. Costi usati (spread, commissioni, slippage), dati (broker, tick reali o M1), terminale (MT4/MT5) e orario del server.

**Filtro di volatilita'**
10. Avete gia' provato il filtro A, B o C? Su quale periodo e con quali risultati (PF, operazioni, per anno)?
11. Nel 2019-2023 con il filtro il PF sale sopra 1,1 con quante operazioni?

**Forward e correlazione**
12. Demo da settembre: operazioni, PF, drawdown. Potete esportare i trade?
13. Rendimento giornaliero dal 2023 a oggi, per misurare la correlazione con Reaper, Phantom e Goldbot.
14. Come va nei giorni di notizie forti e il venerdi'?

Grazie! Se mi mandate i file qui sotto rifaccio i test fino a oggi.
