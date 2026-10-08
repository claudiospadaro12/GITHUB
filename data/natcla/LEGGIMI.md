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

- **Decisione di Claudio, 08/10/2026**: _"FAI 10 PUNTI, NON 10 PIP"_ (TP fisso = 10 punti, non 10 pip; A-R22 WA0091 "10 pip" contro WA0092 "10 punti": vince "punti"). **Da chiarire con lui**: "punto" = punto di prezzo (indici 1,0; oro 1 USD) oppure punto MT5 (`_Point`: EURUSD 0,00001 = 1/10 pip; oro 0,01)? Con il punto MT5 il TP di 10 punti vale 1 pip su EURUSD e 0,10 USD sull'oro, sotto il pedaggio (`NATCLA_SPECIFICA_2026-10-07.md` §5.3, asse "escluso per aritmetica"). Implementazione: vedi il chiarimento sotto: nessuna manopola nuova, AUTO_CLASSE gia' fa 10 punti di prezzo su indici e metalli.
- **Chiarimento di Claudio, 08/10/2026**: _"PUNTI DI PREZZO, NON MT5"_. Quindi il TP fisso = **10 punti di prezzo** (indici 10,0; oro/argento 10 USD), non 10 punti MT5 (`_Point`). **Nessuna modifica al codice**: e' gia' quello che fa `InpUnita = AUTO_CLASSE` (indici 1,0; metalli 1,0 USD; forex = pip) con `InpTPDistanza = 10`. Resta da dire solo cosa vale "10 punti di prezzo" sul forex (10,0 sul prezzo di EURUSD non ha senso): finche' Claudio non dice altro, il forex resta a 10 pip. La nuova manopola `InpTPUnita` annunciata prima NON serve.

## Risposte di Claudio del 08/10/2026 (domande residue sugli audio)
1. **Direzione: ENTRAMBI** (`InpDirezione = ENTRAMBI`, gia' il default; i test misurano comunque i due lati separati).
2. **Stop: 20 punti oltre l'EMA200, oppure 20 punti oltre il Supertrend 3,5** (lo stop sta OLTRE la linea piu' esterna: ST3,5 nei motori Supertrend, EMA200 nel motore M2). "Punti" = punti di PREZZO (indici/oro), pip sul forex. **Richiede una modifica del codice** (nuovo criterio di stop `linea estrema + 20 u`; oggi `ORDINE_PROFONDO + 5 u` o `LINEA_PIU_BUFFER` con buffer 5): prossima versione, dopo C0/lotto C.
3. **Orari: qualsiasi fascia** (nessun filtro orario).
4. **Time frame: tutti, soprattutto H1 e H4.** Nota: i TF bassi restano esclusi se sfondano il cancello del costo (`stop >= 40 x pedaggio`). **Non e' la risposta alla domanda "periodo dell'ATR" e non nomina i simboli: entrambe restano aperte.**
5. **ADX: quello di METATRADER** (`iADX`: il codice lo usa gia'; confermato anche dalla riga VERIFICA ADX 66/66 + 18/18). Periodo non detto: resta 14 [NOSTRA].
6. **EMA200: "non piatta, un po' inclinata"**: nessun numero. Resta l'asse a 3 celle (P25/P50/P75 dei setup, specifica F5): la soglia si misura, non si sceglie.
7. **Forex: target 10 pip** (confermato).
Costo dello stop a 20 u [DERIVATO da `NATCLA_SPECIFICA_2026-10-07.md` §5.3, SOLO se l'ordine e' sulla linea]: EURUSD 20/0,67 = 29,9x (sotto 40, sopra 13,3: FRAGILE), GBPUSD 23,8x, USDJPY 22x, D30EUR 12,5x / NASUSD 11,1x / U30USD 10x / 225JPY 0,9x (sotto il duro 13,3x: ESCLUSI PER COSTO), XAUUSD con u = 1 USD 80x (passa).
