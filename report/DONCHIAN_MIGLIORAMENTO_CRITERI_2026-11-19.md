# Donchian 20 (TV_SCOUT_8 n.23): filtro di trend + stop — criteri scritti PRIMA dei numeri (19/11/2026)
**Obiettivo:** vedere se un filtro di trend e uno stop (assenti nello script) portano il Donchian ai filtri di Claudio. Dati e costi come TV_SCOUT_8 (EURUSD/oro H1, 2014-11/2020-12, IS fino al 27/02/2019, OOS dopo).
**Griglia (32 celle, scritta ora, non si allarga dopo):** lunghezza canale {20, 40} x filtro trend EMA {nessuno, 100, 200, 400} (long solo se close > EMA, short solo se sotto; filtro sull'ingresso) x stop ATR(14) dall'ingresso {nessuno, 2, 3, 4}. Conferma doppia attiva, long+short, ingresso all'apertura della barra dopo il segnale, uscita = inversione (come lo script) o stop. Dopo uno stop la posizione resta flat e riparte al prossimo segnale valido. R = distanza dello stop (2 ATR convenzionale se senza stop).
**Scelta della cella (solo in-sample, stessi parametri su entrambi i mercati):** tra le celle con >= 100 operazioni IS su entrambi i mercati, quella col PF IS piu' alto del peggiore dei due mercati (min EURUSD, oro); si richiede plateau: almeno meta' dei vicini (un passo su un asse) con PF IS minimo >= 1,2. Poi si guarda l'OOS UNA volta.
**Porte (immutate):** filtro IS PF >= 1,5, DD <= 15%, >= 100 operazioni; VALIDATA se in OOS PF > 1,2, R medio > 0, >= 30 operazioni, su entrambi i mercati.
## Previsioni
- Nessuna cella con PF IS >= 1,5 e DD <= 15% su entrambi i mercati: **93%**.
- Miglior min-PF IS della griglia < 1,3: **80%**.
- Lo stop riduce il DD rispetto al base senza stop: **85%**; il filtro EMA alza il PF IS EURUSD rispetto al base: **50%** (testa o croce).
- La cella scelta in IS ha OOS PF > 1,2 su entrambi: **15%**.
## Limiti
Solo 6 anni e 2 mercati: l'OOS e' 2019-2020 (anni di trend). 32 celle = il migliore e' gonfiato dal caso (circa +0,1-0,2 di PF atteso sul rumore). Nessun altro periodo disponibile in questa sessione.

## RISULTATI (`backtest_runner/simulatore/tv_scout8_donchian_ext.py`; la cella base riproduce il test precedente: 504 / 461 operazioni IS)
- **Nessuna delle 32 celle passa il filtro IS** (PF >= 1,5, DD <= 15%): nessuna ha nemmeno PF IS >= 1,3 su entrambi i mercati. Miglior min-PF IS = **1,01** (lunghezza 20, EMA 100, stop 2 ATR); plateau: 0 vicini su 5 con PF >= 1,2.
- **Stop:** funziona come difesa: DD IS EURUSD da 60% a 31-41% (stop 2-4 ATR), oro da 63% a 28-46%; il PF IS sale solo da 1,06 a 1,09-1,14 su EURUSD e da 0,91 a 0,91-0,99 sull'oro. Meno perdite grosse, ma il vantaggio non compare.
- **Filtro EMA:** non aiuta. Su EURUSD abbassa il PF IS (0,81-1,01 contro 1,06). Sull'oro con EMA 400 sale a 1,27-1,37 (n 131-215), ma su EURUSD la stessa cella e' 0,84-1,00: non regge su entrambi e dipende da pochi anni (celle isolate, non plateau).
- **Cella scelta dalla regola** (len 20, EMA 100, stop 2): IS PF EURUSD 1,01 / oro 1,06; OOS EURUSD PF 1,60 (170 op.), oro 1,29 (189 op.). **Per le regole scritte e' NON VALIDATA: fallisce il filtro IS, e un OOS buono non salva una cella piatta in IS.**
- **Osservazione:** quasi tutte le varianti Donchian hanno PF OOS 1,3-1,6 e IS ~1,0: e' un effetto del periodo 2019-2020 (trend forti: rialzo oro, COVID), non della scelta dei parametri. Il sistema segue i trend e in 2014-2018 (laterale) non guadagna.
- Previsioni: nessuna cella >= 1,5 (93%) → si'; miglior min-PF IS < 1,3 (80%) → si'; stop riduce DD (85%) → si'; EMA alza PF IS EURUSD (50%) → no; cella scelta con OOS > 1,2 su entrambi (15%) → **si' (e' successo, ma con IS piatto: non conta)**.
**Verdetto: Donchian non validato, nessun Pine finale.** Per dargli una vera possibilita' servono anni diversi (altri trend/laterali): su BCM `_EXT` Nasdaq/S&P (2010-2026) o BTC FTMO (2016-2026), con la convenzione oraria da diagnosticare per blocco. Non fatto: peso medio (caricare i dati e rifare il test), da decidere.
