# NatCla F1 lotto P (pilota di COLLA) -- lettura del 11/10/2026

Fonte: `NATCLA_F1_P.zip` (pin f2d47079, PC `DESKTOP-H4D7CAJ`, 09:32-09:41, 9 minuti, 4 passate OK, 113 s medi a passata; compilazione EA_NatCla v1.11 **0 errori, 0 avvisi**; 100% tick reali, deposito 1.000.000, IS 2024.07.05/10 -> 2025.06.30, OOS intatto). Lettore `leggi_natcla_f1.py` 728F3489 (PASS), archivio in `backtest_pipeline/risultati_archivio/NATCLA_F1_P_20261011/`. **Questo e' un pilota di colla: un PF qui NON vale niente e non confronta le regole di stop.**

## Le tre cose da guardare per prime (scritte prima)
1. **Compilazione**: 0 errori, 0 avvisi. La v1.11 compila.
2. **Passate**: 4 su 4 OK per il driver; il lettore ne segna **1 KO** (P_003, vedi sotto).
3. **Colla (operazioni del report = riempiti dei SETUP)**: **UGUALE in tutte e 4** (232=232, 214=214, 191=191, 163=163). Il ponte ordini -> CSV funziona.
4. **Tempo**: 113 s medi a passata; la stima del lettore per le 200 passate del piano e' **377 minuti** (valida solo se il lotto e' rappresentativo: oro, forex e indici hanno quantita di tick diverse).

## Due cose trovate dal pilota (per questo si fa un pilota)
- **Invio ordini fallito**: 29 / 29 / 9 / 5 nelle 4 passate, **tutti `retcode 10018 market closed`**, alle 22:00-00:00 server (pausa/rollover). Nessun altro retcode. Gli ordini pendenti non partono quando il mercato e' chiuso: e' il comportamento previsto; da tenere presente nel conteggio degli ingressi.
- **P_003 KO per una riga SETUP incoerente**: il 2025.03.02 23:05 (apertura della domenica sera) l'EA scrive `ADOTTATO ST25: 1 posizioni senza setup in memoria (riempimento durante una cancellazione?)` e la riga SETUP ha `rischio_soldi 0.00`. E' un caso limite dell'EA (un ordine riempito mentre si cancellava), 1 riga su 110, e il lettore esclude per regola l'INTERA passata da ogni numero. **Non l'ho toccato**: o si corregge l'EA (v1.12, passa dal cancello) o si decide che il lettore tolleri la riga adottata (modifica al lettore, passa dal cancello). Decisione tecnica, non di rischio.

## I numeri (solo descrittivi, SOTTILE, merito non misurato)
| gamba | n setup | attesa | PF_R | PF_R nullo (geometria vera) | verdetto |
|---|---:|---|---:|---:|---|
| ORO AUDIO_H1 LONG GEOM | 144 | 62 (2,32x) | 1,32 | 0,93 | SOTTILE |
| ORO AUDIO_H1 LONG PIU | 134 | 62 (2,16x) | 1,13 | 0,96 | SOTTILE |
| FX7 M2_H1 SHORT GEOM (EURUSD) | 92 | 39 (2,36x) | 0,78 | 0,83 | SOTTILE |
| EURUSD AUDIO_H1 SHORT LINEA | -- | -- | (passata KO, non letta) | -- | -- |
- n e' 2,2-2,4x l'attesa in tutte e tre le gambe leggibili: la banda dell'attesa e' sbagliata (da rifare prima di aprire gli altri lotti, classe 1283).
- ORO GEOM: n 144 (a 6 operazioni dalle 150 della soglia), PF_R 1,32 contro nullo 0,93, ma media di R +0,06 con **p(>0) = 0,093**: non distinguibile da zero. GEOM contro PIU: delta -0,19 contro un delta del nullo 0,03, **nessuna differenza distinguibile**.
- Certificato: casella 3 (uscita ad asse) NO, ORO gemelli NO: **nessuna gamba e' morta**; il verdetto massimo e' NON ANCORA MISURATO.

## Prossime (non eseguite)
1. Decidere P_003: correzione EA v1.12 oppure tolleranza nel lettore (entrambe col cancello).
2. Rifare le bande n dei lotti O/FA/FB/I (attesa 2,2-2,4x piu' bassa del reale).
3. Autorizzazione di Claudio per M30 (deviazione dalla fonte).
4. Solo dopo: i lotti O, FA, FB, I (merito).
