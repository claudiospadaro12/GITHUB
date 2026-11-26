# UBS R2 (fuori campione prima del 2020) + calibrazione oro H1: criteri e previsioni scritti PRIMA dei numeri (26/11/2026)

**Passate (52, Modello 1, deposito 100.000, Risk=0, StartLots=0,1, set cosi' come sono):**
- **Oro D1 (13 set distinti di R1b):** 2004-01-01 -> 2019-12-31. I D1 a 1 minuto sono affidabili (rapporto tick/1 minuto mediana 0,92).
- **Forex D1 (29 set distinti CONFERMATI o PARZIALI in R1/R1b):** 2013-01-01 -> 2019-12-31 (BCM).
- **Calibrazione oro H1/H4 (10 set di R1b):** 2025-01-01 -> 2026-10-31 a 1 minuto, per confrontare con le stesse passate a tick di R1b: misura quanto il modello a 1 minuto gonfia i set veloci sull'oro.
Escluso l'argento (dati BCM dal 2016, 6-20 operazioni).

**Regge (R2):** PF >= 1,10 con >= 30 operazioni (criterio di R1/UBS_REPLICA_CRITERI). **Regge forte:** PF >= 1,20 e rendimento > 0 in entrambe le meta' (2004-2011 e 2012-2019: dal report per anno, se disponibile). Passano alla Fase O solo le FAMIGLIE con almeno un set che regge e che era CONFERMATO in R1/R1b; contatore e cancelli della campagna invariati.

## Previsioni (scritte ora)
- **P1 oro D1:** regge >= 60% dei 13 (GTP oro D1 2004-2012: 7/10). Probabilita' 65%. Regge forte >= 40%: 45%.
- **P2 forex D1:** regge <= 40% dei 29 (nel 2020-26 il rapporto PF e' 0,80): mediana PF 2013-19 sotto 1,10: 60%. Almeno una famiglia (stesso simbolo) con >= 2 set che reggono: 55%.
- **P3 calibrazione oro H1/H4:** mediana PF(1 minuto)/PF(tick) fra 1,05 e 1,5 (meno del forex, dove era 1,8-2,7): 60%; >= 1,5: 25%; < 1,05: 15%.
- **P4** Qualsiasi "regge" sull'oro D1 non dimostra scorrelazione da GoldenZoe: correlazione > 0,5 con GoldenZoe: 80%.

## Limiti
Set di Wim e utenti: ricerca, fuori dalla flotta prop (decisione 21/11). I numeri sono del feed BCM, un solo feed. Il periodo 2004-2019 dell'oro contiene il bull 2005-2011 e la correzione 2012-2015. I periodi sono di anni diversi per mercato (oro 2004, forex 2013) perche' i dati BCM forex M1 partono da quando partono.
