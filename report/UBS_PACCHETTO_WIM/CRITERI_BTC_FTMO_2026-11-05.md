# Criteri e previsioni — test dei due Bitcoin di Wim sul terminale FTMO di prova (scritti PRIMA dei risultati) — 05/11/2026
Riga: `backtest_pipeline/righe/RIGA_LANCIA_BTC_FTMO_80K.txt` (+ bootstrap). Script: `ANNO80K_WIM_FTMO_TESTER.ps1` (da `ANNO80K_WIM_TESTER.ps1`, cambia solo il terminale). Nessun risultato visto.

## Perimetro
- EA: **Bitcoin Scalp Pro** (3 set: 1% low, 2% medium, PropFirm) e **Bitcoin Reaper** (4 set: Low, Medium, High, Prop_Firm). Tutti i set, nessuno scelto a mano. BTCUSD H1, Modello 1 (barre da 1 minuto), deposito 80.000 EUR, leva 1:100 nel tester, solo tester. **56 passate** (7 set × 8 anni).
- Dati: terminale `C:\MT5_FTMO_PROVA`, FTMO-Demo, conto 1515150476 **in sola lettura** (password investitore): il terminale non può aprire ordini. Il terminale delle sedie sul VPS non viene toccato.
- Anni scelti prima dei numeri, in ordine dal più recente: **2025, 2024, 2023, 2022, 2021, 2020, 2019, 2018**. Per BTC l'etichetta dei regimi è nota: 2018 e 2022 ribasso, 2019 e 2023 recupero/laterale, 2020, 2021, 2024 rialzo, 2025 misto. Se la storia FTMO manca per alcuni anni, quelle passate escono KO (nessun report) e lo si riporta: **non si completano con altri dati**.
- Parametri: tutti i valori del set del venditore. Nessun input forzato. `AutoGMT` non funziona nel tester: i filtri di orario/notizie del venditore restano ai valori del set (**NON VERIFICATO** che l'orario FTMO GMT+2/+3 coincida con quello atteso dagli EA).

## Costi (punto decisivo per BTC)
- FTMO applica una **commissione dello 0,0325% per lato** sul valore dell'operazione (fonte FTMO, luglio 2025) e una **leva 1:3,3** sul Bitcoin (conto Normal). Il tester potrebbe **non** applicare la commissione (dipende dal gruppo del conto, non dal simbolo): la verifico dal report (colonna commissioni). Se è assente, la **sottraggo io in analisi** (valore nozionale di ogni deal × 0,000325) e riporto **lordo e netto**.
- Margine/leva: controllo il livello di margine minimo e le righe "no money" del giornale: se i lotti calcolati dal rischio non si aprono per leva 1:3,3, lo dichiaro.

## Misure per ogni passata e per set
Operazioni, netto, PF, DD equity relativa e assoluta (80.000 − equity minima), peggior giorno realizzato, numero di giorni ≤ −4,3% e ≤ −5%, stop out, livello di margine minimo; poi correlazione dei P&L giornalieri con il trio sull'oro (anni 2020 e 2025 in comune; 2013 non ha BTC) e **peggior giorno del trio + BTC**, e simulazione del Guardian come per il pacchetto Wim (con il limite dichiarato: realizzato, senza flottante).

## Soglie di lettura (le stesse del pacchetto Wim, decise ora)
- **Da scartare** se in un anno la DD equity relativa supera il 20% o c'è stop out.
- **Filtro prop**: DD assoluta ≤ 7.440 EUR (9,3% di 80.000) e peggior giorno ≥ −4,3% (e −5% limite FTMO).
- **Sotto osservazione** se passa il filtro in almeno 5 anni su 8 (con storia disponibile) **e** non ha nessun anno scartato.
- Mai promosso su un solo anno. I numeri sono «a quel lotto»: taglie e rischio le decide Claudio.
- 56 passate: nessun "migliore" è una scoperta; riporto l'intero quadro per EA, set e anno.

## Previsioni di C0 (scritte prima, non misurate)
1. La storia di BTCUSD su FTMO copre almeno 6 anni su 8 (dal 2020 in poi): **50%**; copre tutti e 8: **25%**.
2. Il tester **non** applica la commissione dello 0,0325%: **60%** (la sottraggo io).
3. Almeno un set apre meno operazioni del previsto o mostra righe "no money" per la leva 1:3,3: **40%**.
4. Almeno un set Bitcoin Reaper `HighRisk` supera il 20% di DD relativa in un anno: **80%**.
5. I set Prop (Bitcoin Scalp Pro PropFirm, Bitcoin Reaper Prop_Firm) hanno DD relativa massima ≤ 9,3% in tutti gli anni: **40%**.
6. Bitcoin Reaper chiude in positivo i tre anni di rialzo (2020, 2021, 2024) con almeno 5 set su 7: **60%**; con almeno un anno di ribasso (2018 o 2022) in perdita per qualche set: **75%**.
7. Correlazione col trio sull'oro in valore assoluto sotto 0,15: **85%**.
8. Bitcoin Scalp Pro fa più operazioni l'anno di Bitcoin Reaper: **65%**.
Le previsioni sbagliate le riporto nel referto.

## Controlli
Nessun controllo di questo documento è già stato eseguito. Un controllo non eseguito non è superato.
