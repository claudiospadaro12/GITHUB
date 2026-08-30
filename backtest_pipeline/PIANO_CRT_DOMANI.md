# 🌅 PIANO DI DOMANI MATTINA — CHIUDERE IL CRT NEL MIGLIORE DEI MODI

_Scritto la notte del 30/08 su richiesta di Claudio: "NON MI ARRENDO CON CRT.
Domani prima chiudo questo EA nel migliore dei modi, poi il resto."_

## DOVE SIAMO (stato al 30/08, 23:45 — tutto misurato)
- Il **gate ADX<=30 e' VALIDATO su OHLC** (+10135, ogni regime positivo, DD 2.6%).
- Il **verdetto TICK manca** per un baco AMBIENTE: il tester tick su NASUSD nativo
  non consegna le barre D1 (ne' via handle iADX/iATR, ne' via CopyRates — provato
  con soglie sempre-vere: 0 trade, gateBlk=2573, due volte, EA fresco).
- Il codice del gate e' CORRETTO (riletto riga per riga). Il muro e' l'ambiente.

## LA MOSSA NOTTURNA (in costruzione mentre Claudio dorme)
**EA v3 del gate: AUTOSUFFICIENTE.** Se il D1 non risponde, l'EA COSTRUISCE le
candele giornaliere aggregando le barre M15 del grafico (che nel tester esistono
SEMPRE, garantito: e' il TF di test). Giorno in corso escluso (no look-ahead).
Stessa scala ADX/ATR, stessa soglia 30. Piu' STRUMENTAZIONE: prime 5 failure
stampate nel Giornale ([CRTTS][GATE-DIAG]: got, GetLastError, via usata) +
contatore OPTFRAME "quale via" (D1 diretto vs fallback M15).
-> Il baco non ha piu' terreno: o passa via D1, o passa via M15. E se fallisse
ancora, il Giornale dice PERCHE' in un test manuale di 5 minuti.

## LA SEQUENZA DI DOMANI (in ordine, PC di backtest)
1. **Io (Claude)**: revisiono la build notturna, committo, gate verificatore,
   pin nuovo, consegno le stringhe. (Se la build e' gia' revisionata e pushata,
   si parte direttamente dal punto 2 con le stringhe che daro'.)
2. **DIAG (ADX<=100, riga RIGA_CRT_TICK_DIAG gia' pronta, solo pin nuovo)**:
   - Se appaiono ~2573 trade -> il fallback FUNZIONA -> punto 3.
   - Se ancora 0 -> test singolo MANUALE in MT5 (tester GUI, NASUSD M15,
     2024.09.26->2026.06.30, Modello tick, EA con gate ON): leggere nel Giornale
     le righe [CRTTS][GATE-DIAG] -> la causa e' scritta li'. Si corregge quella.
3. **GATED TICK vero (ADX<=30, riga RIGA_CRT_TICK_G, solo pin nuovo)**:
   - PF>=1, DD sotto muro, pegg.giornata <5% -> **verdetto tick VERDE** ->
     preparo il preset di deploy sul conto piccolo (come il gated short 770250:
     Guardian ON, taglia ridotta, magic 769100, contratto sedia).
   - PF<1 -> verdetto onesto: il gated nel toro non basta a tick -> il CRT resta
     candidato-chop parcheggiato (Dukascopy quando si vorra'), MA CHIUSO BENE:
     con un verdetto tick vero, non con un baco.
4. **In entrambi i casi il CRT e' CHIUSO nel migliore dei modi** -> pivot ai 5
   motori mai testati. Il primo e' **Chaos Lyapunov: riga GIA' PRONTA e
   gate-passata** (righe/RIGA_CHAOS_DA_MANDARE.md), si lancia subito dopo.

## PROMEMORIA
- Fuso: NASUSD BCM = ora SERVER (flat 21). Le prove TICK_G/TICK_DIAG sono gia'
  giuste e gia' passate dal gate: cambia SOLO il pin (post-build).
- Magic CRT: 769100 (deploy), gemelli test 7691xx. Riservati.
- Il gated short 770250 continua a girare sul conto piccolo: non si tocca.
