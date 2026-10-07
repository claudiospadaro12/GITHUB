# Progetto "Ea Nat&Cla" -- file ricevuti da Claudio il 06/10/2026
Regola di Claudio: l'EA si basa SOLO su questi file (audio di una sua collega + PDF). Nessuna fonte esterna.
- `PTT-20261006-WA0090.txt` (~3 min), `...WA0091.txt` (~18 s), `...WA0092.txt` (~1,5 min): trascrizioni TurboScribe degli audio (Claudio, zip eddc7641). Gli originali .opus non sono in repo (cartella upload della sessione).
- `ABTG-SUPERTREND_REVERSAL.pdf` (31 pagine, "Strategia SUPERTREND REVERSAL, Realise 04.05.2025", Alfio Bardolla Training Group): file che la collega cita come "quello che ci aveva dato Paolo".
- `ABTG-SUPERTREND_REVERSAL_testo.txt`: testo estratto dal PDF; `pdf_pagine/pNN.png`: pagine rese a 80 dpi (le immagini portano parte delle regole).
Nome dell'EA scelto da Claudio: **Ea Nat&Cla** (nome mostrato). Nome tecnico del file, confermato da Claudio il 06/10/2026: **`EA_NatCla.mq5`** (la "&" e' pericolosa in PowerShell/nomi file).

## DECISIONE DI CLAUDIO, 07/10/2026 (sera): "Di agli agenti di ignorare il pdf e di concentrarsi sugli audio"
- **Risposta alla domanda bloccante n.1 ("quale fonte comanda"): comandano GLI AUDIO della collega.** Il PDF `ABTG-SUPERTREND_REVERSAL.pdf` si IGNORA: non e' piu' fonte di regole per `EA_NatCla`.
- Conseguenze (da fare, non ancora fatte alle 07/10 sera): la modalita' `PDF` dell'EA e le righe PDF della specifica si tolgono (v1.02 solo AUDIO + motore solo-EMA200, che e' dall'audio WA0092); le divergenze audio/PDF (sez. 10.1 dell'analisi audio) smettono di essere domande; le domande che il PDF faceva nascere cadono. Il PDF resta in repo come archivio, mai come fonte.
- Il terzo lettore del codice (in corso) lavora solo sulla parte AUDIO; la rimozione del PDF e' un passaggio separato dopo di lui.
