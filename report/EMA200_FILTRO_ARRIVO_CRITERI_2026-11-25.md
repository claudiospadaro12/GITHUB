# Media 200 rimbalzo: filtro "come arriva la candela" (criteri scritti PRIMA dei numeri, 25/11/2026)

**Base:** `EMA200_RIMBALZO_RISULTATI_2026-11-25.md`: senza filtro il rimbalzo di 10 pip riesce nell'86% dei casi, pareggio 83-87%, PF con M1 0,70 / 0,49 / 0,68. Lezioni 23-24: *"se la candela arriva con uno spike nella prima mezz'ora c'e' piu' probabilita' che tocchi il livello e ritorni"*; *"se arriva con grande forza il rischio e' che venga superato"*. Qui si traduce in regole CAUSALI (note nel momento in cui l'ordine viene toccato), non usando il massimo/minimo dell'ora intera.

## Regola
Stessa strategia e stessi dati del test M1 (TP 10 pip, SL 2 ATR, ordini A/B a EMA200 +-10 pip, 10 coppie, 2005-2026). Quando l'ordine viene toccato (primo minuto M1 in cui scatta) si valuta il filtro; se NON passa l'ordine viene **cancellato** (nessun ingresso, e non si rientra piu' quel giorno su quell'ordine). Tre grandezze, tutte note a quel minuto:
- **m** = minuto dell'ora H1 in cui scatta l'ordine (0-59).
- **S** = forza di arrivo = distanza in pip fra il massimo (minimo per i sell) toccato dall'inizio di QUELL'ora fino al minuto di scatto e il livello dell'ordine.
- **ATRh** = ATR(14) dell'H1 sull'ultima barra H1 chiusa (in pip).

Celle (4, piu' la base senza filtro come riferimento):
| cella | condizione per entrare |
|---|---|
| FA "spike nella prima mezz'ora" | m < 30 |
| FB "arrivo lento" | S <= 1,0 x ATRh |
| FC "arrivo lento stretto" | S <= 0,5 x ATRh |
| FD | m < 30 **e** S <= 1,0 x ATRh |
Nessuna soglia viene ottimizzata (1,0 / 0,5 / 30 minuti fissati ora).

## Soglie (invariate)
Aggregato 10 coppie. IS 2005-2015 PF >= 1,3 con >= 150 setup; OOS 2016-2021 PF > 1,2 con >= 80; hold-out 2022-2026 PF > 1,0 con >= 50. Con il filtro il numero di setup cala: se non raggiunge il minimo la cella NON passa (campione insufficiente). Si riportano anche: tasso di rimbalzo degli ordini che passano il filtro e di quelli scartati (descrittivo), e il tasso di pareggio.

## Previsione (scritta ora)
Il filtro alza il tasso di rimbalzo di pochi punti (86% -> 88-90% nel migliore dei casi) togliendo circa la meta' degli ordini. Il pareggio resta circa 85%, quindi PF 0,8-1,1, nessuna candidata. Probabilita' di candidata: circa 10%.
