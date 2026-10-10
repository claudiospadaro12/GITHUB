# Bulge telemetria - P0 (accettazione della copia di banco) - lettura del 10/10/2026

Fonte: `BULGE_TEL_P0.zip` (PC DESKTOP-H4D7CAJ, 10/10 09:46, pin a1d8f381, script 1A9DF2BB). Archivio: `backtest_pipeline/risultati_archivio/BULGE_TEL_P0_20261010/`.
Domanda: la copia ABTG_Bulge_Telemetria (SHA 96502AE5) fa le STESSE operazioni di ABTG_Bulge v5.20? NZDCHF H1 con cross EURGBP,NZDCHF,CADJPY, 2026.01.01-06.30, Modello 1.

## Verdetto: P0 PASSA [MISURATO]
- Compilazione 0 errori, 0 avvisi. Precondizioni p1-p5 tutte vere (12 passate, motore = commit, input arrivati, telemetria accesa solo in TEL1).
- ORIG, TEL1 (telemetria accesa), TEL0 (spenta), per entrambi i magic: IS Trades 95, Profit 183.06, PF 1.15671, DD 4.8036%; OOS Trades 94, Profit 85.58, PF 1.05837, DD 6.2640%. Confronto a stringhe esatte: IDENTICHE in tutte le 8 coppie.
- Per-trade (94 deal OOS): ORIG = TEL0 = TEL1 riga per riga. Ricontrollato da me sui file grezzi: l'UNICA colonna che differisce e' `magic`. (Gli SHA dei file differiscono per quello e per il nome.)
- TEL0 non scrive nessun file di telemetria (atteso). TEL1: gemelle 775111/775161 con telemetria IDENTICA (SHA256).
- Telemetria TEL1 OOS: 120 segnali = 94 OPENED + 18 BLOCK_HASOPEN + 8 SKIP_TP; somma net OPENED 85.58 = Profit OOS (scarto 0.00).
- Il "rc 3" dei tre job nel RIEPILOGO e' il codice del driver per job (la riga globale dice rc 0/LETTURA MECCANICA: P0 PASSA); non e' un errore del test.

## Cosa NON dice
Il P0 prova che la telemetria non altera le operazioni in questa finestra e su questi 3 cross. NON misura il merito del Bulge e NON dice nulla sul VIOLA da migliorare.

## Il controllo --controlla (sim_bulge_viola_uscite.py): invariante 3c VIOLATA 3 volte, ora SPIEGATA
- Autotest 17/17 OK. OPENED 94, rigioco coincidente 88 (93,6%). Invarianti 3a, 3b, 4, 6 OK.
- **3c**: il primo M1 del percorso non e' a k=0 per i sig_id 20, 96, 119 (tutti EURGBP, barra delle **22:00 server**; primo M1 alle 22:05, k=5).
- Spiegazione [DERIVATA, con prova]: a 22:00-22:04 server il forex BCM ha la **pausa di rollover** (5 minuti senza quotazioni; `report/OROLOGIO_BCM_2026-09-24.md` r.49, 0 affari su 82 in estate). Prova contro l'ipotesi alternativa "bug del telemetria": nei segnali dell'ora 22 le violazioni sono **3 su 3**, e in tutte le altre 23 ore sono **0 su 117**. Un difetto di scrittura non sceglierebbe l'ora della pausa.
- Righe M1 per segnale: media 175,5 (OPENED), 164,2 (SKIP_TP), 179,2 (BLOCK); max 180 = 3 ore. Il "~297 attese" del RIEPILOGO era una stima derivata sbagliata (le posizioni escono presto): [NON bloccante].
- **Conseguenza**: il file si legge, ma l'invariante 3c va letta cosi': k=0 ovunque, k=5 ammesso SOLO alle 22:00 server su forex. Il controllo NON e' stato modificato. Proposta (da far passare dal cancello PRIMA di usarla su corse vere): eccezione esplicita a `hour==22` con controesempio "k=5 alle 14:00 resta VIOLATA". Resta [NON MISURATO] il comportamento d'inverno (UTC+1 fisso: la pausa slitta alle 23:00).

## Prossimo passo
Il P0 sblocca la corsa lunga di telemetria sul VIOLA (15 cross): proiezione file path ~218 MB (OOS) + ~582 MB (IS) [DERIVATA, lineare]. Costo e disco da dichiarare prima del lancio. Il merito del VIOLA resta da misurare con `sim_bulge_viola_uscite.py` (parametri invariati, criteri congelati in `report/MIGLIORA_BULGE_VIOLA_2026-10-08.md`).
