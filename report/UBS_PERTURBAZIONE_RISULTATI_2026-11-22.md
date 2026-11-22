# Perturbazione dei parametri dei set US30 (g, c, a): risultati (22/11/2026)
Sorgente: `ANNO_ORO_GRADINI_UBSPT_20261122_1210.zip` (51 passate, clone `U30USD_T` a tick reali, 01/01/2025-13/11/2026, lotto 0,1; criteri `UBS_PERTURBAZIONE_CRITERI_2026-11-22.md`, scritti prima). Le passate risultano KO solo per il controllo formale dei tick (qualita 99%, il 01/01 non ha tick); input confermati in tutte.

| Set (centro PF tick) | Varianti | PF > 1,0 | PF minimo / mediano / massimo | PF >= 0,8 x centro | Verdetto (soglia 70%) |
|---|---|---|---|---|---|
| **`US30_VOL_M15_g`** (1,88) | 17 | **17 su 17 = 100%** | 1,52 / 1,88 / 2,69 | 17 su 17 | **PASSA** (vincolante) |
| `US30_VOL_M15_c` (1,18) | 17 | 17 su 17 = 100% | 1,06 / 1,18 / 1,28 | 17 su 17 | passa la perturbazione (informativa; il verdetto V3 "non passa per 0,003 sul DD" NON cambia) |
| `US30_VOL_M15_a` (1,60) | 17 | 17 su 17 = 100% | 1,40 / 1,58 / 1,78 | 17 su 17 | passa la perturbazione (informativa; il verdetto G2 "segmento P < 1" NON cambia) |

**Previsioni scritte prima:** P-1 `g` passa: **si** (65%). P-2 `c` passa: **si** (55%). P-3 `a` passa: **si** (50%). P-4 PF mediano di `g` >= 1,5: **si** (1,88). P-5 almeno un parametro con PF < 1 in entrambe le direzioni per `g`: **no**.
**Cautele:** (1) **diversi parametri sono inerti nella finestra**: `Exit_TrailTP_size`/`Start` non cambiano nulla (stesse 113 operazioni e stesso PF del centro in g; lo stesso per c e a), e `minSize` di `c` con un passo di 500 non cambia le operazioni: la perturbazione di un passo li lascia di fatto non testati. (2) un passo solo, 22 mesi, un solo indice, regime di rialzo. (3) i parametri piu sensibili in `g`: `Exit_stop` meno un passo (PF 1,52, DD +22%), `Exit_TrailSL_Start` piu un passo (1,59), `DevFactor` (2,03 / 2,69, ma con 127 / 97 operazioni).
**Non ancora fatto (guida di Wim):** hold-out (2024-09/12, serve rifare barre e tick del clone da prima del 2025); stress su altro simbolo (g su `SPXUSD_T`, `NASUSD_T`); correlazione con gli altri candidati; ottimizzazione.
