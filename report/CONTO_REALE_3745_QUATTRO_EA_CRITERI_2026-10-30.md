# Gold Trade Pro, Goldbot One, Reaper e Phantom sul conto reale (3.745 EUR, leva 1:500): criteri e previsioni scritti PRIMA dei numeri (30/10/2026)
Non controllata da agenti. Richiesta di Claudio (30/10): "preparami la riga a 3.500, ricorda che ho leva 1:500"; poi: saldo 3.745,38 + 2.500 di bonus. Scopo: misurare cosa fa il lotto minimo 0,01 sui set prop/combo a un capitale piccolo e avere le liste affari per sommare le combinazioni al capitale reale. Confronto con le corse a 80.000 (percentuali).

## Passate (riga `RIGA_LANCIA_REALE3745.txt`, script `ANNO3745L500_TESTER.ps1` = ANNO80K con deposito 3.745 e leva 1:500, pin 10dd23af)
Cinque corse continue 01/01/2025-01/10/2026, XAUUSD, tick reali (Modello 4), deposito **3.745 EUR**, **leva 1:500** (il report deve confermarla o la passata e KO), nessun guardiano. **Il bonus di 2.500 non e simulato**: gli EA dimensionano sul saldo (UseEquity spento), il bonus conta solo su equity e margine: il tester a saldo puro e conservativo sul margine, ma l equity del reale e 6.245.
Input come nei test a 80.000 (stessi della classifica dei set): Gold Trade Pro (D1) `Risk=3, MaxRiskPerStrategy 1,0 con limite 4` (PROP) e `0,5 con limite 4` (COMBO); Goldbot One (D1) PF525 (`Risk=3`, MaxRisk 1,0, limite 2, tutti gli input imposti come nel test del 30/10); Reaper (H1) `TradeFrequency=2, MaxAllowedDD=9, limite 4, OnlyUp false`; Phantom (H1) PROPCOMBO D4 (`MaxAllowedDD 4`, limite 4, OnlyUp false, Randomization 0).

## Riferimenti a 80.000 (21 mesi, % del deposito)
Gold Trade Pro PROPFIRM: +47,5% netto, DD equity 5.588 (7,0%); Reaper 9: +74,7%, DD 3.854 (4,8%); Phantom D4: da leggere dai report (D9: +26,4%); Goldbot PF525: +18,0% (14.406 a Modello 1), DD 2.479 (3,1%).

## Previsioni (probabilita)
- **V1** 5/5 valide (deposito 3.745 e leva 1:500 nel report, `input_ok = si`): 85%. **V2** nessuno stop out: 80%. **V3** nessuna riga "no money": 85%.
- **M1** Per ogni EA il netto in % del deposito e almeno 1,2 volte quello a 80.000 (il lotto minimo 0,01 pesa di piu a un conto piccolo): Gold Trade Pro PROP 70%, Reaper 60%, Goldbot PF525 75%.
- **M2** **Phantom D4 almeno 2 volte il netto % di 80.000 e DD % almeno 2 volte**: 75% (a 80.000 apre 0,02-0,05 lotti: a 3.745 scenderebbe a 0,0009-0,002 e il broker arrotonda a 0,01).
- **M3** Gold Trade Pro COMBO (0,5) a 3.745 ha netto e DD % simili al PROP (rapporto fra 0,7 e 1,4), cioe il combo non dimezza il rischio a questo capitale: 60%.
- **M4** Il DD equity % del Gold Trade Pro PROP e almeno 1,3 volte quello a 80.000 (7,0%): 60%.
- **M5** Nessun EA perde in 21 mesi: 90%.

## Cosa NON dice
21 mesi di oro in forte rialzo, un percorso; bonus non simulato; margine e stop out del broker non verificati; tester senza slippage e gap; lotto minimo e arrotondamenti del tester BCM; nessun giudizio su acquisti, lotti o taglie.
