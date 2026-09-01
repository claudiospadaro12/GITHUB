# NOTA MISURATA -- Pavimento dei TICK REALI BCM sul forex: 2024.07.05

**Misurato il 01/09/2026 ore 20:03** dal Diario del tester MT5 (terminale BCM,
conto 50503392), durante la corsa della cella 03 della SONDA DELL'OROLOGIO
(pin f81eb70). Righe verbatim del Diario (screenshot di Claudio in chat):

    GBPUSD: ticks data begins from 2024.07.05 00:00
    EURUSD: ticks data begins from 2024.07.05 00:00
    EURGBP: ticks data begins from 2024.07.05 00:00

**Cosa significa:**
- Il tick NATIVO BCM sul forex parte dal **2024.07.05** (sugli indici il
  pavimento misurato e' 2024.09.26, R109 par. D2 / R97 -- due mesi e mezzo
  dopo).
- Prima di quella data, a Modello 4 MT5 **genera i tick dalle barre M1**
  (fallback silenzioso, non un errore): lordo bid->bid leggibile, SPREAD
  ricostruito -- la sonda dell'orologio lo dichiara gia' nei RILIEVI.
- La colonna spread della sonda e' quindi VERA solo dal 2024.07.05 in poi
  (dentro la gamba OOS 2017-2026, ultimo quarto circa).
- XAUUSD non e' ancora stato misurato (la cella 05 lo dira': cercare la riga
  "ticks data begins from" nel Diario).

**Contesto della serata (per il verbale):** la prima corsa della cella 03 e'
stata uccisa da "no memory for ticks generating" (pass falliti, 16 GB RAM
saturi con 8 agenti + swap); rimedio: riavvio del PC + 4 agenti. Dopo il
riavvio: ~1 minuto a passata contro ~1 ora prima. Lezione operativa: su
questa macchina le corse a tick generati su finestre lunghe vogliono RAM
pulita e max 4 agenti.
