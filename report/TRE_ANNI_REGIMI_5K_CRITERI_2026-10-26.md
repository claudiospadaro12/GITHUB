# Tre anni dello storico dell'oro (LONG, SHORT, LATERALE) per i 9 EA a 5.000 EUR: criteri scritti PRIMA dei numeri (26/10/2026)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (26/10): i 21 mesi misurati sono quasi tutti con l'oro al rialzo; vuole **3 anni dello storico dell'oro, anche non consecutivi**, uno per regime (long, short, laterale), per vedere **se gli EA sono solidi**. Acquisti, lotti e taglie sono decisioni sue.

## Che storico c'e (letto nel repo, `LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`)
- **Nativo BCM: XAUUSD dal 11/06/2004 (22 anni)**, barre (nel repo i 22 anni sono gia stati girati con il Modello "OHLC 1 minuto", R100 del 23/08, 11 motori oro). **Un solo feed per tutto** (la mappa misura che cambiare feed puo cambiare il segno dei risultati: R80, quattro cambi di segno): quindi uso SOLO il nativo, non l'esterno.
- Altri: `XAUUSD_EXT` HistData 2018-2024 (importato); OANDA 2006-2020 (cache cloud perduta, mai importato). **Dukascopy sull'oro: NON TROVATO nel repo** (Dukascopy e li solo per il Dow, tick 2024-10/2025-06, e per gli indici); se Claudio ha CSV Dukascopy dell'oro sul PC o altrove non li ho visti.
- I **tick reali** BCM dell'oro iniziano il 10/07/2024: **prima il tester genera i tick dalle barre**. I test sugli anni vecchi sono quindi a **qualita ridotta**: non confrontabili tel quel con i 21 mesi a tick reali.

## Scelta dei tre anni (regola scritta ORA, dalle sole barre D1 BCM `XAUUSD_D1_BCM_2004-06-11_2026-10-21.csv`, mai dai risultati)
Pool: anni completi **2013-2023** (11 anni: moderni, senza sovrapposizione col periodo gia misurato). Rendimento annuo = chiusura dell'ultimo giorno dell'anno / chiusura dell'ultimo giorno dell'anno prima.
- **SHORT** = anno col rendimento piu basso -> **2013 (-28,0%)**.
- **LONG** = anno col rendimento piu alto -> **2020 (+24,6%)** (2019 +18,7%, 2023 +13,1% seguono).
- **LATERALE** = fra gli anni con |rendimento| < 3%, quello col minor range massimo-minimo -> **2018 (-1,7%, range 17,7%)** (2022 -0,3% range 28,2; 2014 -1,5% range 22,8; 2021 -3,5% escluso).
Avvertenza: ogni anno ha mesi di regime diverso (2013: 7 mesi SHORT, 2 LONG, 3 LATERALI; 2018: 9 LATERALI; 2020: 4 LONG, 2 SHORT, 6 LATERALI): l'anno e un'etichetta, i mesi dentro si leggono col lettore dei regimi mensili.

## Problemi dichiarati (la lettura deve tenerne conto)
1. **Modello del tester:** **Modello 1 (OHLC 1 minuto)** per i tre anni, come R100. NON e tick reale: gli scalper e gli EA sensibili allo spread (Gold Snap tiene 4 minuti, SixtyNine) possono comportarsi diversamente. Spread storico delle barre: NON VERIFICATO.
2. **Prezzo dell'oro:** nel 2013-2020 l'oro valeva 1.200-2.000 USD (oggi 4.000): gli EA con SL/TP in **punti fissi** (Microedge 3.000/700, Umbra 3.000/750) hanno stop relativamente piu larghi. Non e un errore del test, e un confondente.
3. **Taratura:** parametri del venditore ottimizzati su periodi non dichiarati; negli anni vecchi i default possono essere fuori taratura.
4. **Calibrazione obbligatoria:** si rifa **il 2025** (12 mesi, di cui abbiamo gia il Modello 4) con lo stesso Modello 1 e lo stesso script: per ogni EA si confronta con il Modello 4. **Calibrazione OK** se: stesso segno del netto, rapporto netto Modello 1 / Modello 4 fra 0,5 e 2,0, e correlazione dei rendimenti mensili >= 0,5. Se un EA non passa, i suoi numeri sugli anni vecchi sono **NON ATTENDIBILI** e lo si scrive.

## Cosa si fa
9 EA (Rocket, Entry Points, ORB Revolution, Umbra, Microedge, Vortex, Gold Snap, SomaGold, SixtyNine), H1, **5.000 EUR**, leva 1:100, **Modello 1**, input default (con gli stessi input imposti dell'ultimo giro: Umbra e Microedge con la guardia spenta, SomaGold col suo set), **nessun guardiano**. Finestre: 2025 (calibrazione), 2013, 2018, 2020. Una corsa per EA e anno, a conto vuoto. Script `ANNO5K_TESTER.ps1` (copia di `ARENA5K_MESE_TESTER.ps1` con `-Anno` e `-Modello`, controlli di qualita al 100% tick reali sospesi per il Modello 1).
Arena NON e inclusa (M1, troppo lenta).

## Cosa si misura e "SOLIDO" (scritto ora)
Per EA e anno: netto, % del deposito, PF, DD equity (assoluto e relativo), stop out, righe no money, peggior mese realizzato. **SOLIDO-ANNI**: netto > 0 in **tutti e tre** gli anni, DD equity relativo <= 25% in ciascuno, nessuno stop out, peggior mese >= -10% del saldo di inizio mese, E calibrazione OK. Altrimenti si scrive quale condizione fallisce. Lettore `backtest_pipeline/leggi_tre_anni_5k.py`, congelato prima dei numeri, con `--autotest`.

## Previsioni dichiarate ORA
- C1: la calibrazione passa per almeno 6 EA su 9: 50%.
- Y1: almeno un EA con stop out in uno dei tre anni vecchi: 40%.
- Y2: il 2013 (SHORT) e l'anno peggiore (netto % piu basso) per almeno 5 EA su 9: 55%.
- Y3: il 2018 (LATERALE) ha netto positivo per almeno 5 EA su 9: 55%.
- Y4: almeno 2 EA su 9 risultano SOLIDO-ANNI: 35%.
