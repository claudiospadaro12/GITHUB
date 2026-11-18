# Fade del falso breakout sull'oro (proposta B): criteri e previsioni scritti PRIMA dei numeri (18/11/2026)

**Natura:** simulatore Python su M1 FTMO (2015-2020, gia in uso), nessun ordine, nessun giudizio su lotti. Scelta di Claudio: "a".
**Obiettivo:** logica OPPOSTA al breakout di Wim, per avere un motore diverso per i 6-7 EA scorrelati. Il simulatore non e calibrato sulle soglie del 2%: e un FILTRO (come per orari fissi); qualunque esito positivo andrebbe poi confermato in MT5.

## 1. Regola (fissata, non si cambia dopo aver visto i numeri)
- Livelli: **PD** = massimo/minimo del giorno precedente (barre dalle 01:05); **AS** = massimo/minimo della sessione asiatica 01:05-08:00 del giorno stesso. ATR = media del true range D1 sugli ultimi 14 giorni (esclusi quello in corso).
- Dalle 08:00 alle 20:00 (ora server) si segue il prezzo. **Breakout** = massimo (minimo) >= livello +(-) X*ATR. **Falso** = una chiusura M1 torna dentro il livello entro W minuti dal breakout. Entrata al prezzo di apertura della barra successiva, CONTRO il breakout (spread dai dati). Se W passa senza rientro: breakout valido, niente operazione su quel lato per il giorno.
- SL = estremo del breakout +(-) 0,10*ATR; rischio R = distanza SL-entrata, si scarta se R < 0,20*ATR. TP = rr*R. Uscita forzata alle 22:00 (apertura barra). Se SL e TP nella stessa barra: SL (caso peggiore). Una operazione per livello al giorno. Barre prima delle 01:05 ignorate (aggregato 00:00).
- Costi: stessi di orari_fissi (3,6 EUR/operazione + commissione -0,16, 0,1 lotti = 10 once, spread dai dati). Netto in EUR.
- **Griglia: 24 set** = livello {PD, AS} x X {0,10; 0,25} x W {30; 60; 120} x rr {1; 2}. Contatore dei looks per questa famiglia: 24.

## 2. Porte (nessuna ritoccata dopo)
- **Selezione 2015-2017:** netto > 0, PF netto >= 1,20, t >= 2,0, operazioni >= 60. Tra i set che passano, **massimo 3 candidati** (i 3 con t piu alto).
- **Validazione 2018-2020 (cieca per la scelta):** per ciascun candidato: netto > 0, PF netto >= 1,20, t >= 2,0, operazioni >= 60, almeno 2 anni su 3 in profitto.
- **Finalista** = candidato che passa la validazione. Solo allora (non prima): vicini (G2), meta 2018-2020 distinte, e richiesta a Claudio dei dati FTMO 2021-2024 per G4. **2025-2026 non si apre.**
- Se nessun set passa la selezione o la validazione: **famiglia chiusa**, nessuna variazione di regola per salvarla.

## 3. Previsioni (scritte ora)
- Almeno un set passa la selezione: **55%** (24 set, soglia t 2,0: il caso da solo ne passa ~1).
- Almeno un candidato passa la validazione: **15%**.
- Nessun finalista: **85%**. Se passa, il PF netto in validazione sara < 1,5: **75%**.
- Costo: l'oro ha ~0,66 USD/oncia a operazione; con R tipico 2-4 USD pesa 15-30% di R: e il motivo principale per cui prevedo la chiusura.
