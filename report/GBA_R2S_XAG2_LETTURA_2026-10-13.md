# GBA R2S -- rilancio dell'argento (XAG2): lettura dello zip del 13/10/2026

Fonte: `GBA_R2S_XAG2.zip` (PC DESKTOP-H4D7CAJ, 13/10 07:14-07:16, 2 minuti, rc 3, pin `d53493a92901b82c6b4c12c1d79ec3cb4ebfa5bb`, riga PASS 7D1F4F26). Archivio: `backtest_pipeline/risultati_archivio/GBA_R2S_XAG2_20261013/` (zip SHA256 DAD8FEA0...). Strumento: D2 v3 `leggi_gba_r2s_c3g.py` SHA256 77F1F72E... (PASS), con l'ancora del 12/10 (zip SHA 259F4BA0...). Regole: E1-E4 + ordine di E3 + R3. Un regime (T1 2026), Modello 1 (barre), lotto fisso: sonda di COSTO, nessun PF letto.
**Nessun candidato e' archiviato. La casella 4 resta "NON ANCORA MISURATO".**

## Esito
- **Il blocco del 12/10 NON si e' ripetuto.** Le due passate (M15 e M1) hanno finito in 41 e 33 secondi, con `last test passed` e il report scritto, pur con zero operazioni. CE8 [descrizione]: **H-ZERO-R SMENTITA** (zero operazioni CON report non causa lo stallo); resta lo stallo occasionale (2 su ~335 passate del PC, F5).
- **CE7 (determinismo) VERDE a tolleranza zero**: la M1 rifa' il giornale del 12/10 (6.611 segnali, 6.611 scartati per spread, 0 ingressi; C3G cella 2,40, BUY 2,50, SELL 2,30; stesse sei fasce). X6/CE1 VERDE (ancora del 12/10 verde).
- **XAGUSD M1**: n 0, 6.611 segnali TUTTI scartati dal filtro (nessuno a >= 40x); C3G **2,40x** (lati 2,50/2,30; ogni fascia sotto 4,2x). Esito di riferimento: **"ESCLUSA (Modello 1)"** (C3G < S 6,65 in cella, fasce e lati, (v) 0 righe a >= 40x), **casella 4 NON ANCORA MISURATO**: va confermata con UNA passata a tick reali della stessa cella e tranche (E3). Per l'argento la storia a tick reali sul PC e' [NON MISURATA].
- **XAGUSD M15**: n 0, 384 segnali tutti scartati; C3G **11,95x** (BUY 12,20 / SELL 11,80); sopra S 6,65 => **"n insufficiente a Modello 1 su una tranche (NON escluso)"**: non e' ESCLUSA, resta NON ANCORA MISURATO. L'attesa del piano (9,6x, [INFERITO] per scalatura) era vicina; la smentita non scatta.
- Il G0 del lettore standard dice KO per entrambe ("ZERO operazioni nel report"): e' il KO noto del driver v5 che l'eccezione n=0 di D2 copre; non e' un guasto.

## Cosa significa (e cosa NO)
L'argento e' fuori frontiera per costo a M1 con un'ampiezza grande (2,4x contro 6,65x), ma **per le regole di casa non e' "morto"**: manca la conferma a tick reali e mancano TF alti (H1 o piu': il piano dice "probabilmente H1 o piu'") e la gestione dell'uscita. Il certificato dei 5 punti resta aperto.

## Prossimi passi (decisioni di Claudio dove indicato)
1. Conferma E3 a tick reali dell'argento M1 (file prova nuovo + riga + cancello): serve prima sapere se il terminale ha i tick dell'argento (non misurato).
2. Argento a TF piu' alti (M30/H1) come misura nuova di costo.
3. Lo stadio B degli indici (riga gia' consegnata): zip non ancora arrivato.
