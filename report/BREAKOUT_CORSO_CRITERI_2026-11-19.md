# Test Breakout del corso ABTG: criteri PRIMA dei numeri (19/11/2026)

**Domanda:** la strategia Breakout spiegata nel corso (lezioni 34-40, riepilogo 40) ha un vantaggio sui cross con lo yen e sull'oro, come dichiarato (+133% in 2 anni a rischio 1%, 2022-2024, senza fuori campione)? Regole nel file `CORSO_FOREX_REGOLE_STRATEGIE_2026-11-19.md`; EA `mql5/Experts/ABTG_BreakoutCorso.mq5` (ingresso al mercato dopo la chiusura, stop 1 pip oltre il rettangolo, TP 3 volte la distanza dalla chiusura del segnale, stop a pari a 1R, uscita su segnale opposto, ingresso solo se rischio/rendimento >= 1:2).

**Parametri non dichiarati nel corso (scelti ora, non toccati dopo):** Supertrend (10; 3,0) = valori comuni degli indicatori; fascia di segnale valida al massimo 100 barre dopo l'ultima barra in area Williams; rischio 1% per operazione (solo per leggere il rendimento; si ragiona in R). Williams ipercomprato > -20, ipervenduto < -80, linea -50 come da corso.
**Dati:** BCM portabile, Modello 1, M15, 2013-01-01 -> 2024-12-31 (2025-26 NON si usa: hold-out), 8 simboli (USDJPY, EURJPY, GBPJPY, CHFJPY, NZDJPY, AUDJPY, CADJPY, XAUUSD), spread del tester. 16 passate: modo rettangolo 1 (primario: dal primo ingresso del Williams in area, max 20 barre) e modo 0 (ultime 20 barre; variante, riportata ma NON usata per scegliere).
**IS 2013-2020 / OOS 2021-2024** per data di ingresso. Hedging, una posizione per simbolo.

## Previsioni (prima dei numeri)
- Operazioni per simbolo in 12 anni (modo 1): 150-800: **60%**.
- Win rate 22-35% (pareggio ~25% prima dei costi per TP 3R con BE a 1R): **65%**.
- PF su rendimenti dell'insieme dei 7 cross JPY (modo 1) tra 0,85 e 1,15: **65%**; sopra 1,15: **20%**; sotto 0,85: **15%**.
- Oro: stesso esito dei JPY: **55%**.
- Un gruppo (JPY o oro) supera tutte le soglie sotto: **10%**.

## Regole di esito (invariate dopo i numeri)
Un gruppo (7 JPY insieme; oro da solo; analisi sul modo 1) e **CANDIDATO** solo se:
1. IS (2013-2020) PF >= 1,3 con almeno 200 operazioni; OOS (2021-2024) PF > 1,2 con almeno 80 operazioni;
2. R medio per operazione con IC90 inferiore > 0 su IS+OOS;
3. almeno 8 anni su 12 non negativi nel gruppo OPPURE nessun anno con piu' del 35% del profitto totale;
4. **prova di deriva**: il lato SHORT da solo (sui JPY il lungo e favorito dalla deriva dello yen) non negativo in OOS; leave-one-out (togliere un simbolo o un anno: PF sempre > 1,0);
5. il risultato non dipende dal 2022-2024 soltanto (periodo dichiarato dal corso): IS da solo deve passare.
Nessun candidato = Breakout chiuso. Si riportano sempre: operazioni, win rate, R medio con IC90, PF, per anno, IS/OOS, lato. Non si cambiano parametri dopo i numeri; una variante (es. orario, Supertrend diverso) e' una prova nuova con criteri nuovi. Nessun consiglio di taglie. Limite dichiarato: orario server GMT+1 fisso, nessun filtro orario nell'EA.
