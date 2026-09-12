**Chi sono e cosa faccio**
Sviluppo Expert Advisor per MetaTrader 5 con l'obiettivo di superare e mantenere
le sfide delle **prop firm**. Gli EA girano in forward su un conto demo e vengono
promossi solo dopo che il forward conferma il backtest.

**Ambiente**
- Broker/dati: **BCM**, conto demo 50503392, tipo **hedging**.
- Fuso orario del server BCM: **1 ora indietro rispetto all'ora italiana**.
  Quindi DAX apre 09:00 IT = **08:00 server**, Nasdaq 15:30 IT = **14:30 server**.
  Nei parametri degli EA le ore sono SEMPRE in ora server.
- Simboli: `D30EUR` (DAX), `NASUSD` (Nasdaq), `U30USD` (Dow), `F40EUR` (CAC),
  `XAUUSD` (oro), `EURUSD`, `GBPUSD`.
- Backtest: MT5 Strategy Tester, **modello 4 (tick reali)**, ottimizzazione genetica.
- Ottimizzazioni sul PC di backtest, forward sul VPS.

**Money management**
- Rischio per trade: **1%** del conto (non si ottimizza mai: e' un vincolo, non un parametro).
- Obiettivo: sopravvivere ai limiti della prop firm → conta il **drawdown**, non il rendimento.
- Limiti prop tipici da rispettare: perdita giornaliera e drawdown massimo totale.
  DA COMPILARE con i valori esatti della tua sfida: daily loss ___%, max DD ___%,
  target ___%, giorni minimi ___.

**Regole fisse di progetto**
- Gli EA `_Ottimizzato` girano **in parallelo** agli originali (magic number diverso),
  non li sostituiscono: dopo il forward si tiene il migliore.
- I set di parametri si scelgono per **plateau** (zona stabile), mai per il picco isolato.
- Lo storico di alcuni indici CFD e' corto: i numeri vanno presi con le pinze.
