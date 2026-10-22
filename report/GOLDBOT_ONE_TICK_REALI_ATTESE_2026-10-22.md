# Goldbot One a TICK REALI con i lotti scalati (step 3000 e 6000): attese scritte PRIMA dei numeri (22/10/2026)

**Non controllata da agenti.** Perche: il Gold Reaper e gia a tick reali al 100% (GR80K e GRLAT, qualita 100%, 146 milioni di tick). Goldbot One a tick reali e stato fatto SOLO con lotto fisso 0,01 (GBO T1-T3: 449 operazioni, +1.426,37, PF 1,57, DD 0,88%). Tutte le prove con i lotti scalati (sonde 2, 3, 4: step 3000 e 6000 inclusi) sono in OHLC a 1 minuto (99%). Il confronto stesso fra i due modelli a lotto 0,01: OHLC +1.675,28 / PF 1,71 contro tick +1.426,37 / PF 1,57 (netto -15%, PF -0,14, operazioni 451 contro 449). I numeri di S-DD, S-NOSCALA e del portafoglio con Gold Reaper vengono dalla versione OHLC.

## Cosa si fa
Due passate continue 01/01/2025-01/10/2026, XAUUSD D1, **modello 4 (tick reali)**, deposito 80.000, leva 1:100, Risk=9999 (LotsizeStep, mappa probabile), MaxRiskPerStrategy=6.0, StartLots=0.01, **LotPerBalance_step 3000 (TRANCHE1) e 6000 (TRANCHE2)**: gli stessi quattro input imposti della sonda 4. Cambia SOLO il modello (1 -> 4). Riferimento OHLC: step 3000 +25.156,86 / PF 1,83 / DD equity 7.281,90 (9,10% di 80K); step 6000 +11.173,35 / PF 1,84 / DD 3.213,10 (4,0%); 451 operazioni.

## Previsioni dichiarate ORA
- **TK1** operazioni 440-460 in entrambe: 85%.
- **TK2** netto sotto il riferimento OHLC del 5-25% (step 3000: +18.900..+23.900; step 6000: +8.400..+10.600): 60%. Netto positivo in entrambe: 95%.
- **TK3** PF fra 1,5 e 1,8 in entrambe: 65%.
- **TK4** DD equity: step 6000 <= 10% di 80K: 90%. Step 3000 **supera il 10%** di 80K (S-DD fallito): 40%; meno del 10%: 60%.
- **TK5** rapporto lotti max/min <= 3 in entrambe (S-NOSCALA): 45% (il valore OHLC era 2,9 e 3,0, sul bordo).
- **TK6** durata 2,5-3,2 ore a passata (GBO a lotto 0,01: 160-175 minuti), nessun timeout (tetto 360 minuti a passata): 85%. Un timeout e una misura mancante. In GBO la T4 e rimasta appesa (KO): rischio di un blocco circa 10%.

## Come si legge (congelato ora)
Si ricalcolano con i numeri a tick: S-DD (<= 10% dal deposito, <= 15,2% dal picco), S-NOSCALA (rapporto lotti <= 3), PF, e il portafoglio con Gold Reaper (DD, correlazione). Se TK2 e TK4 sono centrate, le conclusioni OHLC reggono; se step 3000 supera il 10%, step 3000 non passa S-DD e resta solo step 6000. Nessuna taglia e nessuna promozione: la scelta e di Claudio. Limite: stesso periodo, stesso rialzo 2025-26.

## Aggiunta del 22/10, ore 12:30: la TRANCHE1 (step 3000) del primo giro e KO
Dalla schermata del PC di Claudio: la TRANCHE1 e partita alle 06:47 e finita alle 11:52 con KO, zero operazioni, report vuoto (periodo 1970.01.01, deposito 0, leva 1:0), input non applicati, giornale "last test passed with result some error after pass finished in 0:00:00.000". Il tester non ha simulato niente e lo script ha atteso circa 5 ore. **E una misura mancante, non un risultato**: le previsioni TK1-TK6 per lo step 3000 restano da verificare e NON cambiano. Causa [NON TROVATA]. Precedente: T4 di GBO del 20/10 (stesso sintomo, 40.465 s). La TRANCHE2 (step 6000) e partita alle 11:52 e il tester mostrava 00:11:44 su 02:16:26 stimati. Riga di rifacimento della sola TRANCHE1: `righe/RIGA_LANCIA_GOLDBOT_TICK_REALI_STEP3000.txt` (stesso script e stesso pin 27ad8db5; timeout ridotto a 240 minuti).
