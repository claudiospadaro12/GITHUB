# Gold Reaper, Goldbot One e Prop Firm Gold EA a 80.000 EUR su 2013 SHORT, 2018 LATERALE, 2020 LONG: CRITERI (26/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (26/10): provare sui tre anni diversi gli EA candidati per le prop. Anni scelti con la regola gia scritta in `TRE_ANNI_REGIMI_5K_CRITERI_2026-10-26.md` (2013 -28%, 2018 -1,7%, 2020 +24,6%, dai soli prezzi D1 BCM).

## Cosa si fa
Una passata a conto vuoto da **80.000 EUR** per EA e anno, XAUUSD, **Modello 1 (OHLC 1 minuto, NON tick reali: l'oro li ha solo dal 10/07/2024)**, leva 1:100 (quella del tester), nessun guardiano esterno. Script `ANNO80K_TESTER.ps1` (copia di ANNO5K con deposito 80.000, pin 83a8365d). Periodi: Gold Reaper H1, Goldbot One D1, Prop Firm Gold H1 (quelli delle prove a 80K gia fatte). Input imposti = quelli delle prove a 80K gia fatte: **Gold Reaper** `TradeFrequency=2, MaxAllowedDD=9.0, PropFirmMaxDailyDD=4.0, OnlyUp=false` (il suo set; le due protezioni interne restano ACCESE: possono chiudere il flottante, intervento non verificabile dal report); **Goldbot One** `Risk=9999, MaxRiskPerStrategy=6.0, StartLots=0.01, LotPerBalance_step=6000`; **Prop Firm Gold** nessun input imposto (valori che il tester ha salvato dalle prove a default: NON VERIFICATO quali, fa fede il report).
**Calibrazione 2025** (stesso Modello 1, stesso script) contro il Modello 4 di gia disponibile: Gold Reaper e Prop Firm Gold dalle loro corse a 80K gia in repo (i primi 12 mesi di una corsa continua che parte da 80.000 il 01/01/2025 coincidono con un anno a conto vuoto); **Goldbot One**: la corsa a tick reali in repo ha solo i totali, quindi la riga fa girare anche **2025 a Modello 4** (D1). Calibrazione OK se: stesso segno della somma dei rendimenti mensili, rapporto M1/M4 fra 0,5 e 2,0, correlazione mensile >= 0,5. Se non passa, i tre anni vecchi di quell'EA sono NON ATTENDIBILI.

## PROP-ANNI (scritto ora)
Un EA e **PROP-ANNI** solo se in **tutti e tre** gli anni: netto > 0; DD equity assoluto <= **8.000 EUR** (10% di 80.000); nessuno stop out; **nessun giorno con perdita realizzata >= 5%** del saldo a inizio giorno (giorno FTMO = mezzanotte CE(S)T); E la calibrazione e OK. Altrimenti si scrive quale condizione fallisce. Informative, fuori dalla chiave: giorni con perdita >= 3% e >= 4%, peggior giorno, peggior mese, PF, operazioni. Il realizzato e un limite inferiore (FTMO misura sull'equita).
Lettore `backtest_pipeline/leggi_tre_anni_80k.py`, congelato prima dei numeri, con `--autotest`.

## Previsioni dichiarate ORA
- T1: calibrazione 2025 OK per almeno 2 EA su 3: 60%.
- T2: nessuno stop out in nessuna delle corse: 85%.
- T3: Gold Reaper PROP-ANNI: 45% (rischio: la sua protezione interna e il Modello 1 cambiano i giorni di coda).
- T4: Goldbot One PROP-ANNI: 40%. Prop Firm Gold PROP-ANNI: 40%.
- T5: l'anno peggiore per netto % e il 2018 laterale per almeno 2 EA su 3: 55% (nei 9 EA e stato cosi per 7).

## Cosa NON dice
Modello 1, prezzi molto piu bassi di oggi (1.200-2.000 USD), nessuna slippage (vedi la classifica con costi), tre anni sono tre campioni; nessun merito di acquisto, lotto o taglia.
