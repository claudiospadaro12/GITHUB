# Breakout D1 con ordini stop e payoff asimmetrico sul Nasdaq (stesso TIPO di motore di Wim): criteri e previsioni scritti PRIMA dei numeri (18/11/2026)

**Natura:** simulatore Python su M1 NASUSD esterno (2015-2024, ora di New York), nessun ordine, nessun giudizio su lotti. Scelta di Claudio: "si".
**Onesta sul motore:** NON e una copia del codice di Wim (l'.ex5 e chiuso e non ne conosciamo la logica interna). E un motore NOSTRO con la stessa struttura (livello D1, ordine stop, SL stretto, TP largo ~2,8x, posizioni tenute giorni). Passare qui non dice nulla su Wim; serve a vedere se la struttura lenta e asimmetrica funziona anche su un secondo strumento. Il filtro Python non e calibrato sulle soglie: eventuale esito positivo va confermato su BCM (cancello D).

## 1. Regola (fissata)
- Barra D1 = dalle 18:00 NY del giorno prima alle 17:00 (sessione del future). ATR = media del true range D1 sugli ultimi 14 giorni (esclusi quello in corso).
- Livelli: massimo (minimo) delle ultime N barre D1 chiuse. All'apertura di ogni barra D1, se non c'e posizione, si piazzano **buy stop = max + 0,10 x ATR** e **sell stop = min - 0,10 x ATR** (OCO, validi per quella barra D1, rinnovati ogni giorno). SL = s x ATR dall'ingresso, TP = rr x SL. Nessuna uscita a tempo tranne la **chiusura forzata dopo 20 barre D1**. Una posizione alla volta. Fill/SL/TP al livello dell'ordine (gap_fill=False); SL e TP nella stessa barra M1: SL; TP non conteggiato nella barra di ingresso. Se in una barra M1 si toccano entrambi gli stop di ingresso: giorno saltato.
- Costo fisso **2,0 punti indice per operazione**, risultati in punti netti. **Non inclusi (limite dichiarato): swap/finanziamento notturno** del CFD sulle posizioni tenute giorni.
- **Griglia: 8 set** = N {10; 20} x s {0,4; 0,7} ATR x rr {2; 3}. Contatore looks famiglia: 8.

## 2. Porte (nessuna ritoccata)
- **Selezione 2015-2017:** netto > 0, PF netto >= 1,30, t >= 2,0, operazioni >= 40, almeno 2 anni su 3 in profitto. Max 3 candidati (t piu alto).
- **Validazione 2018-2020:** per ogni candidato stesse porte (operazioni >= 40).
- **Finalisti:** OOS 2021-2022 e 2023-2024 (PF >= 1,20 e profitto > 0 in entrambi, >= 20 operazioni ciascuno). **Solo se finalista:** correlazione con Wim (richiede la serie giornaliera di C0 da MT5: da chiedere a Claudio), vicini, cancello D su BCM. **2025-2026 non si apre.**
- Nessun candidato/finalista = famiglia chiusa, regole invariate.

## 3. Previsioni (scritte ora)
- >= 1 set passa la selezione: **30%**; candidato passa la validazione: **12%**; finalista supera OOS 2021-24: **5%**.
- Se passa qualcosa, sara a favore del lato long (il Nasdaq 2015-2024 e salito molto): **80%**; e quindi la scorrelazione con l'oro andra verificata, non assunta.

## 4. Risultato (18/11/2026; usato SOLO 2015-2017; output in `CLAU12_NASDAQ_BREAKOUT_D1_RISULTATI.txt`)
- **Selezione: 0 set su 8 passano.** PF netto 0,86-1,20, t da -0,78 a +0,77 (nessuno vicino a 2,0); 70-181 operazioni nei 3 anni. I set con rr 3 sono lievemente positivi (PF 1,01-1,20) ma statisticamente indistinguibili da zero. Validazione, OOS 2021-24 e hold-out: non toccati. **Famiglia chiusa**, regole invariate. Previsioni: >=1 set passa la selezione (30%) -> NO; candidato passa validazione (12%) -> NO; finalista (5%) -> no.
- Nota: il motore e nostro, non quello di Wim; lo stesso schema aveva gia fallito sull'oro (80 set, disegni 0-3) e poi non e un vantaggio generico della struttura "livello D1 + stop + TP largo". Il vantaggio di Wim non e quindi nella struttura ma nei suoi dettagli (non noti) o nel periodo/strumento. Contatore looks: 8 (0 passano).
