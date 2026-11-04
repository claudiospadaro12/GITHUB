# Scheda EA "Bitcoin Reaper V3.6" (pacchetto Wim) — 04/11/2026
Fonte: manuale v3.1 (maggio 2026) incollato da Claudio + 4 set file. `.ex5` non aperto e non nel repository; set originali fuori dal repo.

## Cosa dichiara
- «Versione cripto di Gold Reaper» (che è il nostro Reaper sull'oro): breakout di supporti/resistenze su **BTCUSD H1**, **10 strategie interne** che girano insieme, conferme con più algoritmi, SL/TP fissi + trailing SL/TP + breakeven. «Nessuna griglia, nessuna martingala.»
- Parametri adattati in automatico al prezzo di BTC («da $10.000 a $100.000 o più») → promessa verificabile (come Bitcoin Scalp Pro).
- `TradeFrequency`: Auto (in base a saldo e rischio), Conservative, Moderate, Intense, Extreme o selezione manuale delle strategie. Lotto automatico dal **drawdown totale massimo ammesso** (`MaxAllowedDD`, in %), `OnlyUp`.
- Filtri: NFP (chiude trade e cancella pendenti 50 min prima, riprende 30 dopo; tassi e CPI opzionali), orari (venerdì fine 18:00, weekend ristretto), AutoGMT, calendario MQL5.
- Sezione **Prop Firm**: `PropFirmMaxDailyDD` (drawdown giornaliero %), **randomizzazione** di ingressi e uscite in pips «per rendere unici i trade», aggiustamenti pips, direzione unica.

## I 4 set (differenze: 2 valori)
| Set | `MaxAllowedDD` (% DD totale) | `PropFirmMaxDailyDD` |
|---|---|---|
| LowRisk | 10 | — |
| MediumRisk | 20 | — |
| HighRisk | 40 | — |
| Prop_Firm | 9 | 4 |
Comuni: magic 6500, `TradeFrequency=5` (**valore da decodificare**: nel manuale l'elenco è Auto, Conservative, Moderate, Intense, Extreme, Manuale; 5 potrebbe essere «Manuale» o «Extreme», non lo so senza aprirlo nel tester), NFP attivo, randomizzazione 0, `OnlyUp` acceso.

## Letture di C0 (non misurate)
1. **Stessa famiglia di Bitcoin Scalp Pro** (breakout H1 su BTC) e dello stesso motore UBS dell'oro: probabili correlazioni elevate tra i due prodotti BTC e, per la logica di breakout, qualche somiglianza di comportamento col nostro Reaper (oro) nelle fasi di forte trend. Da misurare.
2. Il set **Prop_Firm** (DD totale 9%, giornaliero 4%) è quasi uguale ai limiti del nostro Guardian (9,3% e 4,3%): confrontare quale scatta per primo e se si pestano i piedi.
3. «Il rischio vero lo decide `MaxAllowedDD`»: il lotto si ricalcola per far corrispondere il peggior DD storico a quel %. Se il DD storico è sottostimato, il lotto è sovrastimato. Da verificare con un test lungo (il BTC ha poca storia utile sui broker).
4. Randomizzazione anti-"copy-trading": come per UBS, non la userei per aggirare i controlli di una prop firm; da valutare solo leggendo le regole di FTMO.
5. Mercato 24/7, weekend e spread BTC dipendono dal broker (BCM/FTMO da verificare).

## Da misurare (criteri da congelare prima di guardare i risultati)
Come per Bitcoin Scalp Pro: PF, DD massimo in % e in giorni, peggior giorno/sequenza, n. trade/anno, risultati per anno e per prezzo di BTC, sensibilità a spread/slippage, effetto di NFP e fasce orarie; i 4 set più una lettura del valore `TradeFrequency`; correlazione con Reaper/Goldbot/Phantom/GTP, con Bitcoin Scalp Pro e con UBS; peggior giorno combinato col Guardian.
Stato: **nessun test eseguito**.
