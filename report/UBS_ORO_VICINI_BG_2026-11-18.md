# Motore in background: 64 varianti vicine al set di Wim (UBS oro D1) — dossier unico (18/11/2026)

**Natura:** tester BCM (portable), nessun ordine reale, nessun giudizio su lotti/taglie. Dati: `UBS_ORO_VICINI_BG_Live_Log_2026-11-18.csv` (64 prove, 23:25 -> 01:18).

## Criteri (scritti prima dei numeri, quelli dello script v3)
IS: PF>=1,8, DD<4%, op>=60, recovery>=1,5. OOS1/OOS2: PF>=1,2, op>=20. Varianti = 1-2 parametri cambiati di un passo dal set OPT2_ORO.

## Risultato
- **64/64 passano IS + OOS1 + OOS2** (SALVATO). Il filtro NON seleziona in questa regione: e un plateau.
- IS: PF min 1,91 / mediana 2,39 / max 2,70, op 134-146, DD max 0,47%.
- OOS1: PF 1,92 / 2,38 / 3,11, op 53-59, DD max 0,34%. OOS2: PF 2,29 / 3,13 / 4,67, op 44-50, DD max 0,33%.
- Per parametro (PF medio IS, OOS1, OOS2): MinDist 350-750 e Expiration 288/384 praticamente inerti (IS 2,30-2,46). Exit_stop 900 migliore (2,61 / 2,41 / 4,41); Exit_limit 1300 il peggiore (2,00 / 2,13 / 2,70), 2100 e 2500 simili (2,47-2,49).
- Top: Exit_limit 2100 + Exit_stop 900 (2,70 / 2,75 / 4,67). Ultime: Exit_limit 1300 + MinDist 750 (1,91 / 1,92 / 2,69) — passano comunque.

## Limiti (da dire a Gemini e a Claudio)
1. Sono quasi-copie dello stesso sistema (breakout D1 oro): **non sono EA scorrelati**, non servono per i 6-7 sistemi diversi.
2. DD% a 0,1 lotto su 100k EUR e minuscolo per qualunque set: la soglia "DD<4%" non seleziona. Il rischio vero dipende dal lotto (decisione di Claudio).
3. Dati BCM; il trasferimento BCM->FTMO ha gia mostrato DD 1,8-2,8x (ctrl. 2015-2022 e vicini FTMO).
4. Campioni OOS piccoli (44-59 operazioni): PF 3-4 e rumore, non un vantaggio misurato. Wim ha ottimizzato su 2013-2023: parte del periodo non e indipendente.
5. Nessuna delle 64 e stata provata sull'hold-out 2025-26 con queste soglie: resta chiuso.

## Lettura
Utile solo come prova di robustezza del set di Wim intorno al suo centro (conferma G2 del controllo positivo). Nessuna "scoperta". Per la diversificazione servono motori diversi (logica, orario, strumento).

## Richiesta per la revisione Gemini (una sola, non 64)
"Leggi il CSV allegato. Segnala: (a) rischio di sovra-adattamento e di plateau non informativo; (b) se i gate IS/OOS sono selettivi; (c) incoerenze tra IS e OOS; (d) cosa misureresti in piu (costi, slittamento, tick reali, FTMO). Non dare consigli su lotti/acquisti."
