# Tick reali 2025 per Reaper, Goldbot One e Phantom: criteri e previsioni scritti PRIMA dei numeri (31/10/2026)
Non controllata da agenti. Richiesta di Claudio: "prova i tre EA a tick reali nel 2024-2025". **Limite:** i tick reali del tester BCM partono dal 10/07/2024 e lo script ANNO80K scarta una finestra che inizia prima (riga 510: "ticks data begins from ..."); lo script accetta solo date di inizio a inizio anno. Quindi: **solo il 2025 completo** (01/01/2025-01/01/2026), che e anche l anno in cui abbiamo i test a candele per il confronto diretto. Il secondo semestre del 2024 richiederebbe una nuova versione dello script (-Inizio) con nuovo pin: da decidere.

## Passate (riga `RIGA_LANCIA_TICK_2025_80K.txt`, script ANNO80K v5, pin 3e43646d)
Tre corse sul 2025 a **Modello 4 (tick reali)**, XAUUSD, 80.000 EUR, stessi input dei test a candele (Reaper D9: set completo come il controllo 2013; Goldbot PF525; Phantom D4). Tempo stimato: circa 4-5 ore in tutto (21 mesi a 3.745 hanno richiesto 3,3 / 2,5 / 1,4 ore).

## Riferimenti 2025, Modello 1 (80.000 EUR)
Reaper D9: +30.457, DD equity 3.077 (2.464 saldo). Goldbot PF525: +8.999, DD 1.637. Phantom D4: +5.560 (707 operazioni, PF 3,11), DD 804.

## Criteri
Validita: stato OK, `input_ok = si`, qualita 100% tick reali, finestra 2025.01.01-2026.01.01, stop out 0. Misure: netto, DD equity, operazioni, peggior giorno realizzato, rendimento/DD (netto / DD equity), per ogni EA, a Modello 4 contro Modello 1.

## Previsioni (probabilita)
- **T1** Le tre corse valide: 85%.
- **T2** Il netto a tick reali e **minore** di quello a candele per ciascuna: Reaper 70%, Goldbot 75%, Phantom 70%.
- **T3** Il DD equity a tick reali e **maggiore o uguale** a quello a candele: Reaper 70%, Goldbot 65%, Phantom 70%.
- **T4** Il rapporto netto/DD a tick reali e almeno il 10% inferiore a quello a candele (un utente ha misurato circa -17% su un portafoglio ORB): Reaper 60%, Goldbot 60%, Phantom 55%.
- **T5** Tutti e tre restano positivi a tick reali: 92%.
- **T6** Nessun giorno realizzato >= 4.000 (5% di 80.000): Reaper 90%, Goldbot 95%, Phantom 95%.
- **T7** Il numero di operazioni a tick reali e entro +-10% di quello a candele: 60% per ciascuna.

## Cosa NON dice
Solo 2025 (l unico anno intero con tick reali), un percorso, 80.000 fissi (lotti a inizio anno), tester senza slippage e gap, il margine del tester per l oro e fisso. Non sono i tick reali del 2024. Nessun giudizio su acquisti, lotti o taglie.
