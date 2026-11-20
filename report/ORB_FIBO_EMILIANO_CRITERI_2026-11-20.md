# ORB + Fibonacci (Emiliano, webinar 02/03/2026): criteri PRIMA dei numeri (20/11/2026)

Regole: `ORB_EMILIANO_WEBINAR_REGOLE_2026-11-20.md`. Script: `backtest_runner/simulatore/orb_fibo.py`. **Interpretazioni fissate ora (il webinar non le dice):**
- **Orologio:** apertura cash USA 09:30 New York. Nasdaq/S&P (M1 esterni 2015-2024): l'ora dei CSV e' New York (diagnosticata il 18/11 sullo S&P: picco 09:30). Oro/EURUSD FTMO (M1 2014-2020, riga 00:00 aggregata scartata): server = ora italiana + 1, convertito con Europe/Rome e poi America/New_York (segue l'ora legale di entrambi).
- **OR:** 09:30-10:00 NY, massimo e minimo con le ombre, barre M5 (M1 aggregate), almeno 5 barre M5 su 6.
- **Breakout valido:** prima M5 dopo le 10:00 NY, fino alle 11:30, la cui **chiusura** e' oltre il massimo (long) o minimo (short) dell'OR, **corpo >= 60% del range**, **EMA9 > EMA21 e chiusura sopra entrambe (long; viceversa short)** su M5. **Volume:** dove esiste (oro, EURUSD: tick volume) la M5 deve avere volume >= 1,5 x la media delle 20 M5 precedenti; **Nasdaq e S&P hanno volume 0: breakout senza controllo di volume (limite dichiarato)**. Per oro ed EURUSD si guardano **due varianti: con e senza filtro di volume.**
- **Fibonacci:** dal minimo di sessione (dalle 09:30 fino al momento corrente) al massimo raggiunto dalla barra del breakout in poi (aggiornato a ogni nuovo massimo finche' non scatta l'ingresso). Livelli: 50%, 61,8%, 78,6%.
- **Trigger d'ingresso (prima barra M5 dopo il breakout, entro le 11:30 NY, con tutte):** minimo della barra <= livello 50%; minimo >= livello 78,6% (zona non rotta); **barra bullish con chiusura sopra il 61,8%**; chiusura sopra EMA9 e EMA21; **MACD(12,26,9): istogramma della barra > istogramma della barra precedente ("curl")**. Se una barra rompe il 78,6% prima del trigger: **nessun trade per quel giorno**. Un solo trade al giorno. Short speculare.
- **Esecuzione:** ingresso all'**apertura della barra M5 successiva al trigger** (conservativa; il webinar dice ordini limite). Stop = livello 78,6%. **Skip se (massimo post-breakout - ingresso) / (ingresso - stop) < 2** (R/R minimo 1:2 dichiarato). **TP1 = livello 0% (massimo dopo il breakout)**: chiude il 50% della posizione; il resto (runner) esce alla **chiusura di una M5 oltre la EMA9 in direzione opposta**; uscita forzata alle 16:00 NY. Stop e TP intrabarra su M5 (SL prima se nella stessa barra). Dopo TP1 lo stop NON si sposta (il webinar non lo dice).
- **Costi:** Nasdaq 2,0 punti, S&P 0,7 punti, oro 0,66 USD/oncia, EURUSD 0,00010, per operazione. R = risultato netto / rischio iniziale (ingresso - stop).
**Prova:** 6 celle (NAS, SPX, XAU senza e con volume, EUR senza e con volume), 2015-2024 indici, 2014-11 -> 2020-12 FTMO. **IS = primo 70% dei giorni, OOS = ultimo 30%.**
## Previsioni (prima dei numeri)
- Operazioni per cella 80-400: **65%** (il pullback nella zona e' raro: molte giornate senza trade).
- R medio netto negativo in almeno 4 celle su 6 (IS): **65%**. PF pooled in IS tra 0,7 e 1,15: **70%**.
- Nessuna cella supera le porte: **90%**. Il filtro volume (oro/EUR) migliora l'R medio: **50%**.
## Regole di esito (invariate dopo i numeri)
**CANDIDATA**: IS PF >= 1,3 con >= 60 operazioni e t >= 2; OOS PF > 1,2 con >= 25 operazioni e R > 0; i due lati non entrambi dipendenti dalla deriva (gli indici salgono: lato SHORT in OOS non < 0,8 PF se il long passa); >= 2 anni su 3 non negativi per periodo. Celle singole = esplorative (6 prove). Hold-out: nessuno oltre l'OOS (nessun parametro ottimizzato). Variazioni delle interpretazioni dopo i numeri = prova nuova con criteri nuovi. Nessun consiglio di taglie.

## DIAGNOSI DEL PRIMO RUN (prima di leggere i numeri dei risultati; scritta 20/11)
Con le regole fissate sopra il run A (skip se R/R di TP1 < 1:2) produce **quasi zero operazioni** (es. Nasdaq 2016: 255 giorni con OR, 206 con breakout valido, 160 senza trigger completo, 21 con zona rotta, 20 trigger scartati per R/R < 2, **0 operazioni**). Il caso studio dello stesso webinar (S&P: ingresso 5.289, stop 5.274, TP1 5.298) ha TP1 a 0,6R e un R/R finale di 1:1,53: **il "minimo 1:2" non puo' essere applicato al TP1**, la mia interpretazione A contraddice il webinar. **Run A = come scritto sopra (si riporta, quasi sicuramente NON VALUTABILE per poche operazioni). Run B (dichiarato ora, prima dei numeri di B): stessa identica regola SENZA lo skip su R/R** (si entra comunque se la zona e' valida); tutto il resto invariato. Previsioni run B: operazioni per cella 100-500: **65%**; nessuna cella candidata: **88%**; R medio netto negativo in >= 4 celle su 6: **65%**. Regole di esito identiche.

## RISULTATI (output completo: `ORB_FIBO_EMILIANO_RISULTATI_2026-11-20.txt`)
- **Run A (R/R >= 1:2 sul TP1, come scritto):** 0 operazioni su Nasdaq, S&P ed EURUSD; oro 19 (IS) e 7 (OOS); **NON VALUTABILE**: le regole alla lettera (zona 50-61,8%, chiusura sopra il 61,8%, R/R >= 2) quasi non producono trade. Coerente con la diagnosi.
- **Run B (stessa regola senza lo skip sul R/R, dichiarata prima dei numeri):**
| Cella | IS | OOS |
|---|---|---|
| Nasdaq | n 137, R -0,12, PF 0,75 | n 43, R +0,02, PF 1,05 |
| S&P 500 | n 150, R -0,23, PF 0,56 (t -3,0) | n 67, R -0,11, PF 0,74 |
| Oro senza volume | n 473, R -0,28, PF 0,50 (t -5,7) | n 188, R -0,06, PF 0,87 |
| Oro con volume | n 105, R -0,35, PF 0,42 | n 25, R -0,37, PF 0,31 |
| EURUSD senza volume | n 167, R -0,14, PF 0,63 | n 65, R -0,15, PF 0,60 |
| EURUSD con volume | n 32, R -0,38, PF 0,22 | n 21, R -0,07, PF 0,83 |
- **Nessuna cella candidata; l'ORB + Fibonacci di Emiliano, con le interpretazioni fissate prima, perde su tutti i mercati e in IS e OOS** (6 celle su 6 con PF IS < 1; l'unica cella con PF OOS > 1 e' il Nasdaq con 43 operazioni, PF 1,05, R +0,02: nessun valore). Il filtro di volume (oro, EURUSD) non migliora, anzi peggiora (meno operazioni, PF piu' basso).
- Previsioni: operazioni per cella 80-400 (run A, 65%): no (quasi zero); run B 100-500 (65%): si' (137-473, tranne le celle con volume); nessuna candidata (88%): si'; R negativo in >= 4 celle su 6 (65%): si' (6 su 6). Filtro volume migliora (50%): no.
- **Chiusura ORB di Emiliano:** il test completo (ORB Toolkit 05, ORB + Fibonacci) non trova un vantaggio su Nasdaq, S&P, oro ed EURUSD. Limite onesto: le interpretazioni sono mie (il webinar non dice volume medio, soglie del corpo, impostazioni MACD, orario di uscita); una variante diversa e' una prova nuova. DAX 09:00 e USDJPY/GBPUSD non testati (nessun M1 qui).
