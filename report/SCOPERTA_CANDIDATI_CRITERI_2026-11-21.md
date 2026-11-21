# Scoperta di altri candidati: quattro famiglie nuove sui 33 mercati D1: criteri PRIMA dei numeri (21/11/2026)

**Richiesta di Claudio (21/11): "prima dobbiamo trovare altri candidati".** Famiglie con una base documentata e mai provate da noi (a parte il trend long, gia noto). Script `backtest_runner/simulatore/scoperta_candidati.py`. **Dati:** D1 Yahoo dei 33 mercati scaricati il 19/11 (indici, energia, metalli, agricoli, cripto, tassi, dollaro; apertura/massimo/minimo/chiusura giornalieri). **IS = primo 70% delle barre di ogni mercato, OOS = ultimo 30%.** Costi: **0,03% a operazione (andata e ritorno) per tutto; nelle posizioni tenute la notte si aggiunge uno swap di 0,04% per notte sui long (stima dagli swap BCM sugli indici e sull'oro, 10-14% annuo) e nessuno swap sugli short**. Nessun parametro ottimizzato: tutti fissati qui. Conteggio prove dichiarato per famiglia (per caso qualche cella sembrera' buona).
## A. Deriva overnight contro intraday (chiusura -> apertura contro apertura -> chiusura)
Per mercato: rendimento medio per trade di "long chiusura->apertura successiva" (overnight) e di "long apertura->chiusura" (intraday), netti di costi e swap (swap solo sull'overnight). 33 mercati x 2 = 66 prove.
## B. Effetti di calendario
Per mercato e per giorno della settimana (5) il rendimento chiusura(t-1)->chiusura(t) nei giorni di quel giorno; e **turn-of-month** (long dalla chiusura dell'ultimo giorno del mese alla chiusura del 3o giorno del mese dopo). 33 x 6 = 198 prove. Costo 0,03% a trade (+ 0,04% per notte sui long per ogni notte tenuta).
## C. Mean reversion D1 stile Connors (RSI(2))
LONG se RSI(2, Wilder) < 10 e chiusura > SMA200; ingresso all'apertura successiva; uscita alla prima chiusura sopra la SMA5 (massimo 10 barre). Short speculare (RSI(2) > 90 e chiusura < SMA200). Costi come sopra. 33 mercati x 2 lati = 66 prove.
## D. Momentum cross-sectional mensile
Ogni 21 giorni di borsa: classifica i mercati disponibili per rendimento a 252 giorni escluso l'ultimo mese; **LONG i 5 migliori, SHORT i 5 peggiori, pesi uguali, tenuta 21 giorni**; costi 0,03% a gamba a ogni ribilanciamento piu' swap 0,04% per notte sui long. Una sola prova (portafoglio), reso in serie mensile.
## Previsioni (prima dei numeri)
- A: nessun mercato con t >= 2 in IS e OOS nello stesso segno (netto di costi e swap): **85%**. L'overnight lordo e' positivo su piu' della meta' degli indici ma il netto con lo swap no: **70%**.
- B: delle 198 prove, in IS+OOS stesso segno con |t| >= 2 in IS: **al piu' 6 (caso)**; nessuna con coerenza fra almeno 3 mercati della stessa classe: **85%**.
- C: gli indici hanno PF IS > 1,3 con >= 50 operazioni e OOS PF > 1,2: **35%** (e' una strategia nota che negli ultimi anni ha perso efficacia); altre classi no: **85%**.
- D: serie mensile con t >= 2 in IS e OOS stesso segno: **20%**; media mensile netta OOS > 0: **40%**.
## Regole di esito (invariate dopo i numeri)
- **A/B:** CANDIDATO solo se, netto dei costi, t >= 2 in IS e OOS, stesso segno, >= 100 operazioni IS e >= 40 OOS, e coerente su almeno 3 mercati della stessa classe. Una prova isolata = rumore.
- **C:** CANDIDATO per classe se IS PF >= 1,3 (>= 50 operazioni) e OOS PF > 1,2 (>= 20) in almeno 3 mercati della classe, con lato long separato dal short (deriva).
- **D:** CANDIDATO se IS e OOS hanno media mensile netta > 0 con t >= 2 in IS e t >= 1 in OOS, e meno di meta' del profitto da un solo anno. Nessuna promozione senza conferma su dati nuovi. Nessun consiglio di taglie.
