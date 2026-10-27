# Stability Pro (Profalgo) con AutoLotMode=3 a quattro livelli: CRITERI e PREVISIONI (27/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (27/10): "ma di Stability Pro non hai nulla?". Materiale: pagina del Market (prodotto 105030, v1.9, pubblicato 11/09/2023, 1.330 demo scaricate, affitto 249 / 349 / 399 USD per 3 / 6 / 12 mesi, saldo minimo 200 $, consigliato 500 $) e `Stability_Pro_2.zip` (lo stesso file di `Stability_Pro.zip`: stesso md5): report del tester del venditore.

## Fatti (DICHIARATO dal venditore, non misurato da noi, salvo dove scritto)
- **Griglia "Smart Variable Grid" con mediazione**: solo AUDCAD, AUDNZD, NZDCAD; si esegue da UN grafico EURUSD M5 con `RunOneChartSetup` acceso; usa solo prezzi di apertura delle candele (il venditore: basta il Modello 1, OHLC 1 minuto); consigliato il broker Alpari per lo storico; hedging MT5; "alto fattore di recupero"; SL "nel peggiore dei casi" configurabili.
- **Report del venditore (broker Alpari, 3 coppie, M1)**: (a) "2007-2023 fixed lotsize": deposito 1.000.000 USD, lotto 0,01, `AutoLotMode=1`, `MaxAllowedDD=650` con `UseEADrawdownOnly=true`: +17.053 in 17 anni, PF 2,08, 17.741 operazioni, 82,9% vincenti, vincita media 2,23 contro perdita media -5,11, **posizione piu lunga 597 ore (25 giorni)**; (b) "2020-2023 very high risk": deposito **200 USD**, leva 1:500, **`AutoLotMode=3`, `LotsizeStep=200`**, `MaxAllowedDD=0`, `HardSLDistance=2000`: +238.669, PF 1,69, 2.223 operazioni, 81% vincenti, vincita media 323 contro perdita media -803, **DD equity 59,64%** (DD di saldo 12,96%); (c) MT4 2012-2023 per coppia: PF 1,79 / 1,55 / 1,92, DD 0,98% / 6,80% / 1,38%.
- **Cosa risolve**: il modo di lotto del rischio e **AutoLotMode=3 che usa LotsizeStep** (0,01 lotti ogni LotsizeStep di saldo; con 200 a 200 USD = 0,01), come Luna e Apex; `AutoLotMode=1` e il lotto fisso StartLots. Il nostro test del 26/10 usava `AutoLotMode=2` con `AutoLotsizeRisk`: i lotti non cambiavano (rischio 5 e rischio 1 identici, +875, DD 1,5%): **quel test non era valido** e non si cita come misura di Stability Pro.

## Passate (riga `RIGA_LANCIA_STAB_80K.txt`, script ANNO80K v5, pin 3e43646d)
20 passate, 80.000 EUR, EURUSD M5 con OneChartSetup (AUDCAD+AUDNZD+NZDCAD): 16 a Modello 1 (4 livelli x 2013, 2018, 2020, 2025), poi 4 a tick reali del 2025 (calibrazione). Livelli `LotsizeStep` 10000 / 5000 / 2000 / 1000 (circa 0,08 / 0,16 / 0,4 / 0,8 lotti per gradino a 80.000). Imposti: `RunOneChartSetup=true`, coppie, `AutoLotMode=3`, `LotsizeStep`, `OnlyUp=true`, `MaxAllowedDD=0` (nessuno stop di sicurezza: e il default; con un valore diverso il rischio cambierebbe), `HardSLDistance=2000`. Orologio: AutoGMT lasciato al default (il rollover filter e in ora del server, nessun filtro news), non verificato su BCM.

## Criteri
PROP-ANNI come per gli altri EA (netto > 0 in 2013, 2018, 2020; DD equity <= 8.000 EUR; nessuno stop out; nessun giorno con perdita realizzata >= 5%; calibrazione 2025 OK: stesso segno, rapporto Modello 1 / tick reali 0,5-2,0, correlazione mensile >= 0,5). Lettore `leggi_tre_anni_80k.py` (uno per livello, dal nome della cartella). **Griglia: classe di rischio a parte**; oltre ai cancelli si riportano a mano dal report: posizioni contemporanee massime, permanenza massima di una posizione, rapporto DD equity / DD di saldo, righe "no money". **Un livello che passa PROP-ANNI non e un via libera**: per una prop contano anche i giorni oltre il 3% sull'equity (da barre M1 per le coppie: non esportate, da fare se un livello supera i cancelli).

## Previsioni dichiarate ORA
- S1: almeno un livello supera PROP-ANNI: 20%.
- S2: il livello 1000 ha DD equity > 8.000 o stop out in almeno un anno: 90%.
- S3: il livello 10000 ha netto > 0 in tutti e tre gli anni vecchi: 55%.
- S4: nel livello 10000 il DD equity del 2025 resta <= 8.000: 60%.
- S5: calibrazione OK per almeno 3 livelli su 4: 55%.
- S6: almeno un livello ha una posizione tenuta piu di 10 giorni: 75%; almeno 10 posizioni insieme: 70%.
- S7: il 2013 ha operazioni (lo storico M1 delle tre coppie esiste): 60%.
- S8: DD equity almeno 3 volte il DD di saldo in almeno un livello (flottante grosso): 70%.

## Cosa NON dice
Un percorso per anno; Modello 1 sui tre anni vecchi (le coppie AUD sono poco liquide: slippage non misurata); un solo broker (BCM) contro l'Alpari del venditore; nessun filtro news (non ce n'e); AutoGMT/orologio non verificato; MaxAllowedDD come stop di sicurezza (che il venditore usa nel test a lotto fisso) non provato; nessun giudizio su acquisto, lotto o taglia.
