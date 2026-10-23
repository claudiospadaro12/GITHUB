# R286 -- sedia 770250 (Nasdaq Apertura, breakdown solo short): gate EMA acceso contro spento (23/10/2026)
Fonte: `ROUND_R286_2026-10-23.zip` (PC DESKTOP-H4D7CAJ, pin 3e2a49f6, motore = pin SHA256, 2 round rc 0, catena completa, per-trade 4 su 4; compila 0 errori 0 avvisi). Lettore congelato `r286_giudizio.py`.

| Braccio | Leg | Profit | PF | DD% | Operazioni (deal) |
|---|---|---|---|---|---|
| a CON gate (la sedia) | IS | 1052,03 | 1,253 | 2,45 | 57 |
| a CON gate | OOS | -192,82 | 0,955 | 1,94 | 47 |
| b SENZA gate | IS | 3053,29 | 1,359 | 2,10 | 131 |
| b SENZA gate | OOS | -1393,86 | 0,940 | 5,21 | 256 |

- **Coerenza con la misura storica: ENTRO.** Operazioni con gate IS+OOS = 104 = le 104 storiche (30/08); anche la divisione combacia con quella citata in `PIANO_SCHIERAMENTO` (IS 1,257 su 57, OOS 0,948 su 47) contro 1,253 e 0,955 di oggi. **Ritiro quindi quanto avevo scritto nel criterio ("non riproducibile oggi"): la misura storica si riproduce, entro differenze piccole.**
- dPF (senza - con gate): IS +0,105, OOS -0,015: segni opposti, quindi in ogni caso MISTO.
- **Verdetto congelato: DESCRITTIVO** (il braccio con gate ha 57 e 47 operazioni, sotto 100 per gamba): nessun verdetto, come atteso.
- Il gate toglie circa il 73% delle operazioni (104 su 387): senza gate la sedia spara su quasi tutte le aperture, anche nel toro.
- **Senza gate il DD in OOS sale** da 1,94% a 5,21% (con profit peggiore: -1394 contro -193); in IS invece il DD e' leggermente piu' basso senza gate (2,10% contro 2,45%) e il profit piu' alto (3053 contro 1052). Il gate non vince in entrambe le gambe.
- **Entrambe le versioni sono circa a pareggio in OOS (PF 0,955 e 0,940).** Su tutta la finestra: con gate +859, senza gate +1659, su un deposito di 80000 a rischio 0,35% (circa +1,1% e +2,1% del deposito in 21 mesi): non e' una misura di quanto vale la sedia sul piccolo, dove lotti e parziali non sono misurati.
- Attese dichiarate prima: P1 si', P2 si' (104 su 104), P3 si', P4 NO (senza gate il PF in IS e' piu' alto), P5 si', P6 NO (il DD senza gate e' piu' basso in IS).
**Cosa NON dice:** niente sull'orso (il feed e' tutto toro: la funzione del gate nasce li' e resta provata solo in OHLC 2020-24, PF 1,84 con crollo e orso = circa 97% del netto); niente sul gate 50x200 rispetto ad altre scelte; niente sui lotti del piccolo. Non promuove niente.
