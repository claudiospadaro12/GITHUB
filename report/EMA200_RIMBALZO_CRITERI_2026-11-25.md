# Media 200: rimbalzo corto di 10 pip (idea di Claudio), criteri scritti PRIMA dei numeri (25/11/2026)

**Idea di Claudio (25/11):** "il prezzo rimbalza sempre sulla EMA 200 in H4: due ordini, uno sopra e uno sotto la EMA, e si prende un piccolo rimbalzo (10 pip) con il lotto giusto." Il test precedente (`FIBO_H4_MEDIA200_*`) usava TP1 alla EMA14 (circa 50 pip) con SL 2 ATR: e' un'altra strategia.

## Regola simulata
- Come nel test precedente: scansione 08:00 server lun-gio, H4 su H1 BCM, 10 coppie 2005-2026, EMA200 H4; modo long se prezzo >= EMA200 + 50 pip e pendenza positiva (short speculare); ordini cancellati alle 18:00 server; chiusura venerdi 20:00 server; spread fisso per coppia; slippage 0,5 pip solo sullo SL.
- Ordini limite A = EMA200 + 10 pip (1/3 della size) e B = EMA200 - 10 pip (2/3), **ciascuno con TP a +10 pip dal proprio ingresso** (nessun BE, nessun parziale), SL comune = B - **2 ATR(14,H4)** (lezione 23).
- **Varianti di sensibilita':** TP 15 pip; SL 1 ATR; SL fisso 30 pip.
- **Conservativo vs ottimistico (necessario perche' l'H1 non dice cosa succede dentro la barra):** *pessimistico* = nella barra di scatto conta solo lo SL (come V1); *ottimistico* = nella barra di scatto il TP e' accreditato se il massimo lo raggiunge e lo SL no. Il vero risultato sta fra i due.
- Esito in R = pip / distanza SL, pesato 1/3-2/3; PF(R); si riporta anche la **percentuale di ordini che rimbalzano di 10 pip** e quella di pareggio (SL / (SL+TP)).

## Soglie (invariate)
Cella primaria = aggregato 10 coppie. IS 2005-2015 PF >= 1,3 con >= 150 setup; OOS 2016-2021 PF > 1,2 con >= 80; hold-out 2022-2026 PF > 1,0 con >= 50.
- **Se il limite ottimistico NON passa: chiuso definitivamente.** Se il pessimistico non passa ma l'ottimistico si': non e' candidata, serve l'M1 (export dedicato) per decidere.

## Previsione (scritta ora)
Il rimbalzo c'e' ma l'asimmetria lo uccide: con TP 10 e SL 2 ATR (circa 30-35 pip) servono circa 77% di rimbalzi per il pareggio. Previsione: percentuale di rimbalzi 60-75%, PF(R) 0,8-1,05 sul limite ottimistico, nessuna candidata. Probabilita' di candidata: circa 10%.

## Aggiunta (25/11, prima di vedere i dati M1): risoluzione della barra di scatto
Risultato H1: limite pessimistico PF 0,60 / 0,42 / 0,50 (IS/OOS/HO), limite ottimistico 4,35 / 2,93 / 2,01; il "rigoroso" (chiusura oltre TP) coincide col pessimistico. Il pareggio sta a circa 83-87% di rimbalzi, il pessimistico ne da' 84%, l'ottimistico 97%: la risposta e' dentro la barra di scatto. Si esportano le barre M1 delle sole 2.253 ore (coppia, ora) in cui scatta un ordine (`report/EMA200_RIMBALZO_dati/barre_di_scatto_H1.csv`, tutte le varianti hanno le stesse barre di scatto). Con l'M1 la barra di scatto si risolve minuto per minuto (spread reale M1, SL prima di TP dentro lo stesso minuto). Verdetto sulle stesse soglie; se mancano M1 per una parte delle barre si usa il limite pessimistico su quelle e si dichiara la copertura.
