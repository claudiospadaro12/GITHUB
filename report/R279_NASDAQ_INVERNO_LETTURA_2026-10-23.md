# R279: la regola di Emiliano sul Nasdaq d'INVERNO con apertura 15:30 server, lettura (23/10/2026)

Fonte: `ROUND_R279_2026-10-22.zip` (4 file x 4 passate, tick reali, NASUSD M5, deposito 80.000, rischio 2%, pin eec5e0f6). Archivio `risultati_archivio/R279_20261022`. Lettore congelato `r279_giudizio.py`. Non controllata da agenti. Gemelle identiche in tutti e 4, motore = pin, 8 per-trade su 8. rc 2 di tutti i job = atteso (gamba IS di @FRAZIONEIS 0.001 vuota); si legge l'_OOS = finestra intera.

## Risultati (apertura 15:30 server, candela PRE 15:25-15:30, flat 18:30)
| finestra | filtro 17-38 ACCESO: n / PF / DD / profitto | SPENTO: n / PF / DD / profitto |
|---|---|---|
| W1 2024.11.04-2025.03.07 | 79 / **1,32** / 6,2% / +8.554 | 138 / 1,12 / 10,9% / +6.199 |
| W2 2025.11.03-2026.03.06 | 103 / **0,84** / 13,8% / -6.097 | 139 / 0,88 / 20,2% / -6.343 |
- **Filtro d'inverno: NON DIMOSTRATO.** In W1 sale (dPF +0,20, DD e conteggio entro soglia); in W2 no (dPF -0,04).
- Messe insieme (per posizione, esplorativo): **acceso PF 1,04, 111 posizioni, +2.457; spento PF 1,00, 169 posizioni, -143.**
- Trades < 150 per gamba: nessun verdetto di merito (atteso).

## Contro le previsioni
W1 gemelle: CENTRATA. W2 acceso con meno di 150 affari: CENTRATA. W3 PF dello spento fra 0,85 e 1,15 in entrambe: **CENTRATA** (1,12 e 0,88). **W4 PF acceso > spento in entrambe: FALLITA** (W2 0,84 contro 0,88). W5 filtro utile in entrambe (prevista 20%): non avvenuta. W6 PF acceso insieme > 1,0: CENTRATA di poco (1,04).

## Lettura
- Con l'**orologio giusto** d'inverno la regola dei 5 minuti sul Nasdaq **non mostra un'edge**: PF 1,04 (acceso) e 1,00 (spento) su due inverni. Il primo inverno e buono, il secondo in perdita.
- **Confronto con l'estate** (R277, mesi allineati, solo OOS): PRE acceso PF 1,48 su 95 posizioni. **Non si replica d'inverno** (1,04 su 111). Quindi o l'estate 2025-26 era un caso fortunato, o la regola dipende dalla stagione: con questi campioni non si distingue.
- Limiti: otto mesi in tutto, due inverni, soglie 17-38 prese da una frase del webinar, "15:30 = apertura giusta" e un ragionamento sull'orologio. Nessuna taglia e nessun consiglio.
