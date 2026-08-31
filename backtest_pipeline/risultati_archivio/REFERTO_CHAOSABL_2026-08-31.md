# CHAOS ABLAZIONE (gate LLE al massimo VS motore nudo) — VERDETTO DA CRITERIO CONGELATO: NON PROMOSSO

_Corsa VERA: 31/08/2026 09:57, pin d227ba2. NASUSD_EXT M15 OHLC 2020->2024,
2 celle (thr 0.09 = cella top della griglia / thr 999 = gate mai bloccante).
Freschezza: cache 0/0, 2 righe con entrambe le soglie, gateKo=0 sulla 999
(il nudo e' NUDO davvero), autotest 0. Zip CHAOSABL_CORSA_20260831_0957._

## LA MISURA

| | GATED 0.09 | NUDO 999 |
|---|---|---|
| n | 71 | 395 |
| PF | 1.789 | 1.150 |
| profit | +33175 | +39724 |
| DD equity | 8.78% | 21.01% |
| peggior giornata | -2.38% | -6.79% |

## IL VERDETTO (criteri congelati PRIMA dei numeri, nel prova)
Promozione dell'ingrediente SOLO se: PF_gated >= PF_nudo+0.20 **E**
profit_gated >= profit_nudo.
- PF: 1.789 vs 1.35 richiesto -> ✅ (margine +0.64, largo)
- profit: 33175 vs 39724 -> ❌ (il nudo fa di piu' in totale)
**Una condizione su due fallisce -> per la lettera congelata: NON promosso.
La sepoltura prevista dal prova si applica.** I criteri non si cambiano dopo
i numeri (regola di casa, Emendamento: mai retroattivi).

## L'OSSERVAZIONE METODOLOGICA (registrata per il FUTURO, non per questo round)
Il gate ha fatto un lavoro per-trade ENORME: -82% dei trade, tiene l'83% del
profitto, DIMEZZA e oltre il DD (21->8.8), la peggior giornata da -6.79 a
-2.38, PF +0.64. La condizione che boccia (profit TOTALE >=) e'
**anti-filtro per costruzione**: QUALSIASI filtro che taglia trade tende a
perdere profitto totale anche quando aggiunge edge per-trade vero. E' un
difetto di DISEGNO del criterio, scoperto DOPO -> quindi NON si riapplica
qui (il verdetto sta), ma diventa lezione per le ablazioni future: le
condizioni si congelano su metriche per-trade / risk-adjusted (es.
profit/DD: qui 3779 gated vs 1891 nudo), non sul totale.

## PORTA DI RIENTRO (principio delle sedie, per analogia)
Il filtro LLE e' sepolto COME INGREDIENTE PROMOSSO. Come per le sedie spente:
rientra SOLO se una misura NUOVA gli rida' una ragione — cioe' un round
FUTURO, su un MOTORE DIVERSO (non l'EMA-cross), con criteri risk-adjusted
congelati PRIMA. Non e' questo round riletto: e' un round nuovo, se e quando
un motore lo motivera'. L'EA ABTG_ChaosLyapunov resta BOCCIATO (griglia
105 celle) e NIENTE e' deployabile. Caveat permanenti: banco OHLC ottimista,
n=71 sottile, motore ospite mediocre (nudo PF 1.15 = poco piu' del drift).
