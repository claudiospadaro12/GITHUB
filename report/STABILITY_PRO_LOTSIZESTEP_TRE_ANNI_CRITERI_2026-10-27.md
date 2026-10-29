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

## CORREZIONE DEL 28/10/2026 (scritta PRIMA dei numeri della riga corretta)
**Errore mio:** nella superriga le 20 passate erano KO (`input_ok = no`): imponevo `MaxAllowedDD` e `LotsizeStep`, nomi del report del venditore, che in questo EA **non esistono**. Nomi veri dal report del tester: **`MaxAllowedDD_`** e **`LotsizeStep_manually`** (default 0). Le quattro corse erano la stessa corsa (default: AutoLotMode=3, passo 0, lotti 0,41-0,53 a 80.000 EUR; 458 operazioni nel 2025, netto +14.026, DD equity 17.731 = 21,3%, DD saldo 2.703; `report/SUPERRIGA_QUATTRO_EA_RISULTATI_2026-10-28.md`). Riga corretta: `RIGA_LANCIA_STAB_80K.txt` (stesse 20 passate, nomi giusti, pin 3e43646d). Validita: il report deve elencare `LotsizeStep_manually=<valore imposto>` e i volumi devono cambiare da un livello all'altro.
**Previsioni nuove (lineare dal default, che vale circa un passo di 1.600-2.000):**
- Z1: i volumi crescono al calare del passo; lotto medio al livello 10000 fra 0,06 e 0,12: 60%.
- Z2: il livello 10000 supera PROP-ANNI (netto > 0 nei tre anni, DD equity <= 8.000, nessun giorno >= 5%, calibrazione OK): 60%.
- Z3: il livello 5000 supera PROP-ANNI: 45%.
- Z4: il livello 2000 ha DD equity > 8.000 in almeno un anno: 80%; il livello 1000 in almeno due anni: 90%.
- Z5: nel livello 10000 il DD equity del 2025 sta fra 2.000 e 5.000: 55%.
- Z6: DD equity almeno 3 volte il DD di saldo in almeno un livello (flottante): 85% (sul default e 6,6 volte).
- Z7: calibrazione OK (rapporto M1/M4 fra 0,5 e 2,0, correlazione mensile >= 0,5) per almeno 3 livelli su 4: 65% (sul default il rapporto e 1,16).

## RISULTATI della riga corretta (28/10/2026, zip `ANNO80K_STAB_20261028_2125`)
20 passate OK, `input_ok = si` (il report elenca `LotsizeStep_manually` = 10000 / 5000 / 2000 / 1000), 2013 presente (1.092 operazioni). **Ma i quattro livelli danno risultati IDENTICI al centesimo** (2025 M1: 458 operazioni, +14.026,26; 2025 M4 425 operazioni, +12.039; stessi lotti del default): **`LotsizeStep_manually` non cambia il lotto con `AutoLotMode=3` e `AutoLotsizeRisk=1`** (come `AutoLotsizeRisk` non cambiava nulla con modo 2 il 26/10). Cosa guida il lotto: NON MISURATO. Risultato unico (= default): 2013 +52.400 (DD equity 16.457), 2018 +16.137 (8.184), 2020 +28.740 (6.201), 2025 +14.026 (17.731); calibrazione OK (rapporto 1,15, correlazione 0,99); nessun giorno oltre -0,4%. **NON PROP-ANNI** per DD equity (2013 e 2018); DD equity 3-6,6 volte il DD di saldo. Previsioni: Z1 NO (i volumi non cambiano), Z2 NO, Z3 NO, Z4 NON MISURABILE (livelli uguali), Z5 NO (DD 2025 17.731), Z6 SI, Z7 SI (4 su 4 con rapporto 1,15). Per variare il rischio serve capire quale input comanda il lotto (set del venditore per Stability Pro non disponibili): lo Stability Pro non e dimensionabile con quello che sappiamo.

## SONDA DEL 29/10/2026: quale input comanda il lotto (scritta PRIMA dei numeri)
**Perche:** i 4 livelli di `LotsizeStep_manually` hanno dato la stessa corsa (lotti 0,41-0,53, come il default). Con `AutoLotMode=2` non cambiava nemmeno `AutoLotsizeRisk`. Riga `RIGA_LANCIA_STAB_SONDA_80K.txt` (generatore `gen_riga_stab_sonda_80k.py`, pin 3e43646d): 9 passate del solo 2025 a Modello 1 (1-2 minuti l'una, 80.000 EUR), ognuna cambia UN input rispetto al controllo P1. **Ipotesi mia (non verificata):** nel modo 3 il lotto e rischio percentuale / perdita per lotto sulla distanza `HardSLDistance` (1% di 80.000 = 800 EUR su circa 1.460 EUR per lotto a 2000 punti = circa 0,55 lotti, coerente con 0,41-0,53 osservato).
Passate: P1 controllo (modo 3, rischio 1, stop 2000); P2 rischio 0,25; P3 rischio 2; P4 `ManualBalance` 20000; P5 `HardSLDistance` 4000; P6 modo 1 `StartLots` 0,01; P7 modo 1 `StartLots` 0,10; P8 `MaxAllowedDDPerc` 3; P9 `MaxAllowedDD_` 2000.
**Previsioni dichiarate ORA:**
- Q1: P1 riproduce il default (458 operazioni, +14.026,26): 90%.
- Q2: P2 ha lotto medio fra 0,2 e 0,3 volte quello di P1 (cioe `AutoLotsizeRisk` comanda il lotto in modo proporzionale): 45%; P3 fra 1,7 e 2,2 volte: 45%.
- Q3: P4 (`ManualBalance` 20000) riduce il lotto medio fra 0,2 e 0,3 volte quello di P1: 40%.
- Q4: P5 (stop 4000) dimezza il lotto (fra 0,4 e 0,6 volte): 45%.
- Q5: P6 ha lotto 0,01 su tutte le operazioni: 90%; P7 lotto 0,10: 90%.
- Q6: almeno uno fra P2, P3, P4 e P5 cambia il lotto medio di oltre il 20% rispetto a P1: 75% (se nessuno, il lotto in modo 3 e deciso da altro e non lo sappiamo).
- Q7: P8 o P9 chiudono posizioni prima (meno operazioni di P1, o DD equity piu basso): 50%.
- Q8: tutte le 9 passate valide (`input_ok = si`): 70% (rischio: un input intero invece di decimale).
Esito = quale input fa cambiare il volume. Poi si rifa la griglia dei tre anni con quell'input.

## RISULTATI DELLA SONDA (29/10/2026, zip `ANNO80K_STABSONDA_20261029_0819`, 9 passate del 2025 a Modello 1, 80.000 EUR)
**ERRORE MIO, scoperto leggendo gli input dei report:** nella riga della sonda ho imposto solo gli input che cambiavano e non tutti. Gli input non imposti **tengono l'ultimo valore usato nel tester**: in TUTTE le 9 corse `LotsizeStep_manually=1000` (residuo del giro del 28/10); `ManualBalance=20000` resta da P4 a P9; `StartLots=0,1` da P7 a P9; `MaxAllowedDDPerc=3` in P9. **Contaminate: P5, P6, P7, P8, P9** (P6 e P7 valgono solo come modo 1). Validi: P1, P2, P3, P4.
| Passata | Input (veri dal report) | Operazioni | Netto | DD equity | Lotto min / medio / max |
|---|---|---|---|---|---|
| P1 controllo | modo 3, rischio 1 | 458 | +14.026,26 (identico al default) | 17.731 (21,3%) | 0,41 / 0,629 / 4,24 |
| P2 | modo 3, rischio 0,25 | 458 | +12.363 | 15.842 (19,1%) | 0,40 / 0,553 / 3,60 |
| P3 | modo 3, rischio 2 | 458 | +16.318 | 20.074 (24,0%) | 0,46 / 0,726 / 4,96 |
| **P4** | modo 3, rischio 1, **ManualBalance 20.000** | 458 | +2.986 | **4.207 (5,2%)** | **0,10 / 0,138 / 0,88** |
| P5 (contaminata) | come P4 + HardSLDistance 4000 | 458 | +2.986 (identico a P4) | 4.207 | 0,10 / 0,138 / 0,88 |
| P6 (modo 1, contaminata da ManualBalance) | modo 1, StartLots 0,01 | 458 | +280 | 386 (0,48%) | 0,01 / 0,013 / 0,08 |
| P7 (idem) | modo 1, StartLots 0,10 | 458 | +2.825 | 3.864 (4,8%) | 0,10 / 0,129 / 0,80 |
| P8 (contaminata) | modo 3, MaxAllowedDDPerc 3 | 470 | +676 (PF 1,13) | 2.527 (3,1%) | 0,10 / 0,136 / 0,88 |
| P9 (contaminata) | come P8 + MaxAllowedDD_ 2000 | 470 | +676 (identico a P8) | 2.527 | idem |
**Lettura (solo dalle passate valide):**
- **Il lotto in modo 3 e proporzionale al saldo usato per il calcolo:** con `ManualBalance` 20.000 su un conto da 80.000 i lotti sono circa un quinto-un quarto (0,138 contro 0,629 di media; netto 2.986 contro 14.026; DD 5,2% contro 21,3%). Il lotto base di partenza e circa 0,0051 per 1.000 di saldo (0,41 a 80.000). **`ManualBalance` e la leva per ridurre il rischio.**
- **`AutoLotsizeRisk` e `LotsizeStep_manually` quasi non contano** (rischio 0,25 -> 2 cambia il lotto medio fra -12% e +15%, non in proporzione; gli step 0 e 1000 danno lo stesso lotto di partenza).
- **Modo 1 (lotto fisso):** `StartLots` x10 da 0,01 a 0,10 fa netto x10 (+280 / +2.825); la griglia moltiplica il lotto fino a x8 (0,01 -> 0,08). Il lotto fisso 0,01 su 80.000 vale +280 EUR l'anno con DD equity 386 EUR: su un conto da 3.745 EUR sarebbe circa +7,5% e DD 10%.
- **`HardSLDistance` 4000 contro 2000:** nessuna differenza in questo anno (P5 = P4 alla cifra); il DD stop di `MaxAllowedDDPerc` taglia il netto (P8 +676 contro P4 +2.986, ma P8 e contaminata): un DD stop interno non migliora il rapporto.
**Previsioni:** Q1 SI (P1 riproduce 458 / +14.026,26). Q2 NO (P2 0,88x, P3 1,15x: ne 0,2-0,3x ne 1,7-2,2x). Q3 SI (P4 0,22x). Q4 NON MISURABILE come scritto (P5 = P4, contaminata, ma HardSLDistance non cambia nulla). Q5 NO (il lotto fisso 0,01 diventa 0,01-0,08 per i livelli della griglia). Q6 SI (P4). Q7 NON MISURABILE (contaminate). Q8 NO: nominalmente 9 su 9 con `input_ok = si`, ma 5 su 9 contaminate dagli input non imposti.
**Da fare:** riga a livelli di `ManualBalance` (per esempio 40.000 / 20.000 / 10.000 / 5.000) su 2013, 2018, 2020, 2025 con **TUTTI gli input imposti** (anche `LotsizeStep_manually=0`, `StartLots=0,01`, `AutoLotsizeRisk=1`, `ManualBalance`, `HardSLDistance`, `MaxAllowedDD_`, `MaxAllowedDDPerc`).

## RIGA CORRETTA CON ManualBalance (29/10/2026, previsioni scritte PRIMA dei numeri)
Riga `RIGA_LANCIA_STAB_MB_80K.txt` (generatore `gen_riga_stab_mb_80k.py`, pin 3e43646d): 20 passate, 80.000 EUR, EURUSD M5 con OneChartSetup. **`ManualBalance` 40.000 / 30.000 / 20.000 / 10.000** (la leva del lotto, trovata dalla sonda), 16 passate a Modello 1 (2013, 2018, 2020, 2025) + 4 a tick reali del 2025. **TUTTI gli input dell'EA imposti**, anche quelli che non cambiano (`LotsizeStep_manually=0`, `StartLots`, `AutoLotsizeRisk`, `HardSLDistance`, `MaxAllowedDD_`, `MaxAllowedDDPerc`, `OnlyUp`, `BalanceSource`, ...): da verificare nei report. Riferimenti (default, ManualBalance 0 = saldo 80.000): 2013 +52.400 / DD equity 16.457; 2018 +16.137 / 8.184; 2020 +28.740 / 6.201; 2025 +14.026 / 17.731 (M4 +12.039 / 16.545); P4 della sonda (ManualBalance 20.000, 2025): +2.986 / 4.207.
- Z1: i DD di equity 2025 scalano come ManualBalance / 80.000 (lineare dal default 17.731): a 40.000 fra 7.000 e 10.500 (55%); a 30.000 fra 5.000 e 8.500 (50%); a 20.000 il 2025 riproduce P4 della sonda (458 operazioni, +2.986,47): 85%; a 10.000 fra 1.500 e 3.000 (55%).
- Z2: PROP-ANNI sui tre anni (netto > 0, DD equity <= 8.000, nessun giorno >= 5%): 40.000 passa 30% (il 2013 lineare darebbe circa 8.200); 30.000 passa 55%; 20.000 passa 80%; 10.000 passa 85%.
- Z3: DD equity almeno 3 volte il DD di saldo in almeno un livello: 85% (default: 6,6).
- Z4: calibrazione OK (rapporto Modello 1 / tick reali 0,5-2,0, correlazione mensile >= 0,5) per almeno 3 livelli su 4: 65% (default: 1,15).
- Z5: il netto scala quasi in proporzione: netto 2025 a 20.000 fra 0,4 e 0,6 volte quello a 40.000: 60%.
- Z6: lotto medio quasi proporzionale a ManualBalance (a 40.000 fra 0,25 e 0,38, a 20.000 fra 0,11 e 0,17): 60%.
- Z7: tutte le 20 passate valide (`input_ok = si`): 80%.
**Nota:** il rendimento a livelli bassi e piccolo (a 20.000 la sonda ha dato +3,7% nel 2025 su 80.000): se i DD passano ma il netto e esiguo, e una misura utile per dire che lo Stability Pro non serve a una challenge in tempi ragionevoli.

## RISULTATI DELLA RIGA CON ManualBalance (29/10/2026, zip `ANNO80K_STABMB_20261029_1453`)
20 passate OK, `input_ok = si` (tutti gli input imposti; archivio `backtest_pipeline/risultati_archivio/ANNO80K_STABMB_20261029_1453`). **Il livello 20.000 riproduce P4 della sonda** (2025 M1: 458 operazioni, +2.986,47, DD equity 4.206,70). Calibrazione 2025 OK per tutti e 4 i livelli (rapporto 1,16-1,17, correlazione 0,99).
| ManualBalance | 2013 | 2018 | 2020 | 2025 M1 (M4) | Lotto medio 2025 |
|---|---|---|---|---|---|
| 10.000 | +4.499 / DD 1.431 | +1.585 / 767 | +2.772 / 646 | +1.403 / 1.932 (+1.203 / 1.803) | 0,065 |
| 20.000 | +9.655 / 3.101 | +3.380 / 1.687 | +5.886 / 1.292 | +2.986 / 4.207 (+2.554 / 3.928) | 0,138 |
| 30.000 | +14.626 / 4.532 | +5.195 / 2.607 | +8.990 / 2.067 | +4.621 / 6.182 (+3.958 / 5.768) | 0,212 |
| 40.000 | +19.630 / 6.202 | +7.009 / 3.525 | +12.085 / 2.713 | +6.200 / **8.457** (+5.316 / 7.893) | 0,283 |
(netto EUR / DD equity EUR, su un conto da 80.000; PF 1,71-1,96; nessun giorno realizzato oltre -0,2%.) **PROP-ANNI: tutti e quattro i livelli passano i tre anni vecchi** (DD <= 8.000, nessuno stop out); il 40.000 sfora 8.000 nel 2025 (M1 8.457). DD equity del 2025 pari a 6,6 volte il DD di saldo (20.000: 4.207 contro 631; 40.000: 8.457 contro 1.284).
**Tempi da conto nuovo per +8.000 / +4.000 (giorni):** 40.000: 2013 176 / 126, 2018 non raggiunto / 170, 2020 119 / 73, 2025 non raggiunto / 138; 30.000: 2013 210 / 145, 2018 non raggiunto / 239, 2020 260 / 80, 2025 non raggiunto / 276; 20.000: raggiunge +8.000 solo nel 2013 (299 giorni). Quindi **per una challenge il rendimento e troppo basso**: il +10% non arriva in un anno in 2018 e 2025 nemmeno al livello 40.000.
**Equita giornaliera NON misurabile:** le barre M1 esportate sono dell'oro; lo Stability Pro opera su coppie AUD (il DD di equity del tester e quello del report, il giorno FTMO sull'equity non e ricostruibile). Per una prop il flottante della griglia (6-7 volte il DD di saldo) resta il punto debole.
**Previsioni:** Z1 SI (40.000 8.457 / 7.893; 30.000 6.182; 20.000 riproduce P4; 10.000 1.932). Z2 (passa i tre anni): 40.000 **SI** (prevista al 30%: il 2013 e a 6.202, meno del lineare 8.200), 30.000 SI, 20.000 SI, 10.000 SI. Z3 SI (6,6 volte). Z4 SI (4 livelli su 4). Z5 SI (netto 2025 a 20.000 / 40.000 = 0,48). Z6 SI (lotti 0,283 e 0,138). Z7 SI (20 su 20).
