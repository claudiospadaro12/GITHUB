# Scheda EA "Stability Pro WSC V2.0" (pacchetto Wim) — 04/11/2026
Fonte: manuale v1.8 (maggio 2026) incollato da Claudio + 3 set file. `.ex5` non aperto e non nel repository; set originali fuori dal repo.

## Cosa dichiara
- Griglia a distanze variabili ("Smart Variable Grid", SVG) su **AUDCAD, AUDNZD, NZDCAD**, grafico **EURUSD M5** (OneChartSetup). MT5 **hedging**.
- Dichiara: «profittevole in ogni singolo mese dal 2007», «nessuna martingala o averaging rischioso», «non sensibile a spread e slippage», recupero veloce. Sono **affermazioni del venditore, non prove**; i punti da verificare sono quelli (mese per mese, coda, sensibilità ai costi).
- Protezioni: Safety SL (storico max DD), tetto di DD in valuta o in %, `UseEADrawdownOnly`, `HardSLDistance`. Lotto: `AutoLotMode`, rischio automatico 1–10, `OnlyUp`, `MaxLotsBroker`.
- Il manuale consiglia solo AUDCAD;NZDCAD («AUDNZD è meno stabile»), ma tutti e 3 i set hanno le tre coppie.

## I 3 set (differenze: solo 2 valori)
| Set | `AutoLotsizeRisk` | `SafetyClosing` |
|---|---|---|
| low risk | 1 | 500 |
| medium-low risk | 5 | 500 |
| high risk | 7 | 350 |
Comuni: `AutoLotMode=3`, magic 151999, spread max 18, `HardSLDistance=2000`, `UseEADrawdownOnly=1`, `MaxAllowedDD`=0 e `MaxAllowedDDPerc`=0 (**tetti di DD disattivati nei set**, mentre il manuale consiglia ad es. 60%), **`OnlyUp=0` nei set (il manuale raccomanda 1)**, `MaxLotsBroker=100`.

## Letture di C0 (non misurate)
1. È **un'altra griglia sulle stesse tre coppie di Apex, dello stesso sviluppatore** (Profalgo): attesa correlazione alta tra i due; tenerli entrambi non diversifica tra loro.
2. «Nessuna martingala» ma esiste «Lotsize multiplication values»: i lotti crescono nella griglia. La differenza con Apex va misurata dal numero di livelli e dai lotti al picco.
3. I tetti di DD nei set sono a zero: l'unico freno è il Safety SL/HardSL (in punti, da leggere sul grafico) → il **peggior caso dipende da quel valore**, da misurare.
4. «Profittevole in ogni mese dal 2007» è una frase che il test deve poter smentire: si controlla mese per mese con tick reali (peggior mese, mesi in perdita, crolli nel 2008/2015/2020).
5. Tre set che cambiano solo rischio e Safety: il test dirà come scalano drawdown e coda (relazione lotti–DD non lineare in una griglia).

## Da misurare (criteri da congelare prima di guardare i risultati)
Come per Apex: profit factor, drawdown massimo in % e in giorni, peggior giorno/mese, tempo di recupero, livelli di griglia al picco, mesi in perdita, sensibilità a spread/slippage (il venditore dice «non sensibile»: testarlo con costi maggiorati), correlazione dei P&L giornalieri con Reaper/Goldbot/Phantom/GTP **e con Apex**, peggior giorno combinato col Guardian. Test: EURUSD M5, OneChartSetup, tick reali BCM più lungo possibile; tutti e 3 i set; una variante senza AUDNZD (consigliata dal manuale).
Stato: **nessun test eseguito**.
