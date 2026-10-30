# Gold Reaper con Randomization 75 e 100: criteri e previsioni scritti PRIMA dei numeri (30/10/2026)
Non controllata da agenti. Origine: Wim (messaggio MQL5 del 30/10) consiglia per FTMO "Randomization 75 to 100"; noi abbiamo misurato solo 0 e 50 (`REAPER_SET_LIVE_E_RANDOMIZATION_RISULTATI_2026-10-29.md`: a 50 operazioni +24-29%, DD 2013 7.688-7.790 contro 5.621, giorno -4,9/-5,0%, corse non ripetibili fino al 16%). Claudio: "mettimi la riga quando ti postero lo zip" (la riga a 3.745).

## Passate (riga `RIGA_LANCIA_REAPER_RANDOM_80K.txt`, script ANNO80K v5, pin 3e43646d; 80.000 EUR, XAUUSD H1, Modello 1)
Il set prop del Reaper (stessi input della corsa R50A del 29/10: TradeFrequency 2, MaxAllowedDD 9, limite giornaliero 4, OnlyUp false, Virtual_expiration true, tutti gli altri input imposti) con **Randomization 75** e **100**: 2013, 2018, 2020, 2025 (8 passate) + **2013 e 2020 ripetute** per ogni valore (4 passate) per misurare la ripetibilita = 12 passate **piu 5 passate su TradeFrequency**: **TradeFrequency AUTO (valore 5)** con Randomization 0 sui quattro anni (4) e un **controllo 2013 con moderate (2)**, stessi input (1) = **17 passate**. Origine: Wim scrive "Trade Frequency Auto", ma il suo file prop ha 2 (nella finestra: "moderate"; nel Phantom 5 = Auto). Riferimenti: Randomization 0 (set prop: 2013 +21.757 / DD 5.621; 2018 +13.535 / 5.504; 2020 +20.388 / 3.839; 2025 +30.457 / 3.077) e 50 (R50A: 2013 +21.095 / 7.790; 2018 +16.197 / 5.908; 2020 +21.283 / 5.232; 2025 +35.966 / 4.498).

## Criteri
Validita: 12/12 OK, `input_ok = si`. PROP-ANNI: netto > 0 nei tre anni vecchi; DD equity <= 8.000; nessun giorno realizzato >= 5%; nessuno stop out. Ripetibilita: scarto relativo del netto fra le due passate identiche.

## Previsioni (probabilita)
- **A1** Operazioni crescenti con il valore (0 < 50 < 75 < 100) in ogni anno: 80%.
- **A2** DD equity 2013 >= 8.000: a 75 55%, a 100 70%. Giorno peggiore realizzato >= 5% in almeno un anno: a 75 40%, a 100 55%.
- **A3** PROP-ANNI: Randomization 75 passa 35%, 100 passa 25%.
- **A4** Ripetibilita: almeno una coppia di passate identiche differisce di piu del 10% nel netto, sia a 75 sia a 100: 75%.
- **A5** Netto medio sui quattro anni entro +-25% di quello a Randomization 0, sia a 75 sia a 100: 70%.

## Criteri e previsioni su TradeFrequency Auto (aggiunte 30/10, prima dei numeri)
Controllo: il 2013 a moderate con gli stessi input riproduce il riferimento (+21.757, DD 5.621) entro +-5%: **B0 90%**. Confronto Auto contro moderate (Randomization 0): PROP-ANNI come sopra.
- **B1** Le operazioni di Auto differiscono da quelle di moderate di almeno il 10% in almeno 3 anni su 4: 70%. **B2** Auto ha piu operazioni di moderate (in almeno 3 anni su 4): 60%.
- **B3** DD equity 2013 di Auto > 5.621 (quello di moderate): 55%. **B4** Auto passa PROP-ANNI: 50%.
- **B5** Il netto medio di Auto sui quattro anni e entro +-25% di moderate: 65%.

## Cosa NON dice
Un percorso per anno, Modello 1, 2013/2018/2020 probabilmente dentro l ottimizzazione del venditore, la Randomization del tester puo non rappresentare quella dal vivo, margine a leva FTMO non simulato. Nessun giudizio su acquisti, lotti o taglie.
