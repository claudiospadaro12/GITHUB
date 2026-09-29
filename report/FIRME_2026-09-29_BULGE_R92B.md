# Firma di Claudio, 29/09/2026 (sera tardi): criteri di R92b e partenza dal passo 0

Testuale: "FIRMO, PARTI DAL PASSO 0".

## Cosa firma
**R92b = prima misura di `ABTG_Bulge` v5.20** (Signal_Bar_Offset=1, barre chiuse; commit del file `c4426c53`, SHA256 `ED4E88B1...`), H1, cesto dei 22 cross.

**Domanda unica**: quali filtri costano piu' segnali, e con che PF / win rate per cella. NON "quale simbolo promuoviamo".

**Celle**: 24 passate sul cesto dei 22 cross = ATR {acceso, spento} x Bulge_Multi {1,0 / 1,1 / 1,2} x ADX {spento, acceso} x Arancio {spento, acceso}; **piu' 1 passata di controllo** con `Signal_Bar_Offset=0` che deve riprodurre R92 (n=106 sulla cella base): se non lo riproduce, il banco e' rotto e nessun numero vale. Sono assi di MECCANISMO, non una griglia fitta.

**Criteri, invariati rispetto a R92 (`backtest_pipeline/risultati_archivio/R92_CRITERI.md`, firma del 21/08)**: S1 n >= 30 - S2 PF >= 1,30 - S3 win rate >= 65% e profitto > 0. **In piu'**: drawdown alla taglia dentro il 10%, stop >= 40 x (spread + commissione), scelta al CENTRO DELL'ALTOPIANO (mai il picco), rumore A3 10,5% relativo. Rischio della prova 0,80% (come R92). I criteri non si cambiano dopo i numeri: se un numero suggerisse un criterio migliore, vale dal round dopo.

**Passo 0 (firmato, si parte da qui)**: misura della PROFONDITA' dei dati (barre M1) dei 22 cross a BCM sul PC di backtest `DESKTOP-H4D7CAJ`, senza tick, PRIMA di qualunque passata. Da li' dipende se esiste una finestra fuori campione piu' vecchia del 2022.

**Costo in tempo macchina**: [NON MISURATO], dichiarato dopo il passo 0 e prima delle 25 passate.

## Cosa NON firma
Nessun preset, nessuna taglia, nessuna sedia, nessun conto. Le sedie sul piccolo (BULGE V520, ampio) sono un'altra decisione. Il perimetro del runner resta sola lettura.
