# Prop Firm Gold EA v2.5 sul server FundedNext (GMT+2/+3): criteri e attese scritti PRIMA dei numeri (22/10/2026)

**Non controllata da agenti.** Segue `PROPFIRM_RISCHIO_BASSO_LETTURA_2026-10-22.md` (PF3, server BCM = UTC+1 fisso). Domanda di Claudio: il venditore vuole un broker GMT+2/+3: cambia qualcosa su un server a quell'orario? Claudio ha autorizzato il 22/10/2026 l'uso del terminale `C:\FundedNext_Manuale` (conto 12061434, `FundedNext-Server`) SOLO per il tester.

## Cosa si fa
Stesso EA, stesso simbolo (XAUUSD), M30, modello 1 (OHLC 1 minuto), leva 1:100, Use Starting Balance, rischio manuale con protezione 4% accesa. **6 passate**: W1 2025.01.01-2026.10.01 (T1-T3) e W2 2018.01.01-2026.10.01 (T4-T6), rischio 0,25% / 0,5% / 0,75%. Riferimenti BCM (PF3, EUR): W2 0,25% +7.789 / PF 1,08 / DD 5,28% / mesi+ 53%; 0,5% +17.284 / 1,09 / 9,46% / 52%; 0,75% +22.118 / 1,07 / 15,58% / 52%; W1 0,25% +5.462 / 2,06%; 0,5% +11.272 / 4,52%; 0,75% +18.308 / 6,17%.

## Deviazioni DICHIARATE dal PF3 (non si leggono come "solo il fuso")
1. **Il feed e diverso**: prezzi, spread, orari delle candele e profondita dello storico sono quelli di FundedNext. La differenza col PF3 NON e solo il fuso: **non si puo separare l'effetto del fuso da quello del feed** con questo giro.
2. **Valuta del tester = USD** (deposito 80.000 USD, non EUR) per non dipendere dallo storico EURUSD del broker. Si confrontano percentuali, non euro.
3. Il fuso di FundedNext (GMT+3 d'estate, GMT+2 d'inverno) e **[LETTO nei regolamenti, NON misurato]**: lo si misura qui dagli orari dei deal (G2).
4. Lo storico M1 di FundedNext puo non arrivare al 2018: se il primo affare di W2 e dopo il 15/01/2018 la passata e TRONCATA e si dice.
5. Solo le 3 celle con protezione accesa; niente ripetizione.

## Previsioni dichiarate ORA
- **G1 esecuzione**: tutte e 6 le passate escono OK con input confermati e W1 intera (primo affare entro il 15/01/2025): 80%.
- **G1b storico**: W2 intera (primo affare entro il 15/01/2018): **45%** (non so quanto indietro arrivi lo storico FundedNext).
- **G2 fuso misurato**: nei deal di FundedNext **non c'e nessun affare datato domenica**, mentre nei report BCM (PF3) la domenica 23:xx c'e: 85%. Orari d'ingresso piu frequenti spostati di +1/+2 ore rispetto a BCM: 85%.
- **G3 numero di affari**: W2 entro +/-20% di 3.828: 60%; W1 entro +/-20% di 673: 70%.
- **G4 DD (W2, 0,5%)**: DD di equity/80.000 fuori dalla banda +/-10% del PF3 (9,46%, cioe fuori da 8,5-10,4%): **70%** (feed e fuso diversi), direzione 50/50.
- **G5 edge**: PF W2 fra 1,00 e 1,20 in tutte le celle: 85%. Mesi positivi W2 sotto il 60% in tutte le celle: 80%. Almeno 2 anni su 3 fra 2018, 2019 e 2021 negativi allo 0,5%: 65% (solo se W2 e intera).
- **G6 W1**: rendimento in % del deposito entro +/-30% di quello PF3 a pari rischio: 60%.
- **G7 durata**: il primo giro scarica storico dal server: T1 oltre 10 minuti: 50%; nessun TIMEOUT (45 min x 4 = 180 minuti a passata): 85%.

## Criteri di lettura (congelati ora)
- **Valido** solo se: input confermati dal report, EA/simbolo/periodo/deposito giusti, first/last deal letti, nessun KO. Altrimenti NON MISURATO.
- **"Il fuso conta"** solo se DD, PF o mesi positivi di W2 escono dalla banda +/-10% del PF3 (rumore misurato nella ripetizione del PF3) con W2 INTERA. Anche in quel caso resta confuso col feed: va detto, non si afferma una causa.
- Nessuna taglia e nessun consiglio di acquisto.

## Cosa NON dice
Non e un forward. Non prova il comportamento sul conto reale. Una sola prop (FundedNext) rappresenta "GMT+2/+3" solo per l'orario; le sue regole di challenge non sono simulate.
