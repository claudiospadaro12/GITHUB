# Orari fissi sull'oro (proposta A): criteri e previsioni scritti PRIMA dei numeri (18/11/2026)

**Natura:** prova con il simulatore Python (strumento di filtro; conferma finale su MT5). Nessun giudizio su lotti, conti o acquisti. Scelta di Claudio (18/11): "A". Ipotesi: in certe fasce orarie del giorno l'oro ha una deriva (sale o scende) stabile e abbastanza grande da coprire i costi.

## 1. Regola (nessun indicatore)
Ogni giorno feriale, per ciascuna delle **4 fasce** (ora del SERVER FTMO = ora italiana + 1): **F1 01:05-10:00, F2 10:00-15:30, F3 15:30-19:00, F4 19:00-23:30**. Si entra all'apertura della prima barra M1 della fascia e si esce alla chiusura dell'ultima barra prima della fine, in UNA direzione fissa per fascia (long o short). Una posizione per fascia, lotto 0,1, niente stop/target, niente swap (chiusa nello stesso giorno). Giorni con la prima barra a piu di 5 minuti dall'inizio o l'ultima a piu di 5 minuti dalla fine: saltati.
**Costi:** spread della barra (long: entra all'ask = apertura + spread, esce al bid; short: entra al bid, esce all'ask = chiusura + spread), commissione -0,16 EUR a operazione completa e **-3,6 EUR a operazione** (come tutte le prove della campagna). P&L in dollari x 10 once / EURUSD alla chiusura.

## 2. Dati e finestre
FTMO XAUUSD ed EURUSD M1 (export del 17/11): **scelta della direzione: 2015-2017**; **validazione: 2018-2020**; **fuori campione: 2021-2024 (dati ancora da esportare; si apre SOLO se la validazione e superata)**. Le barre delle 00:00 (riassuntive) non si usano (nessuna fascia le contiene).

## 3. Procedura e porte (tutte scritte ora)
1. **Scelta (2015-2017):** per ogni fascia, deriva lorda media (uscita - entrata a prezzo di mezzo, in dollari per oncia) e statistica t su un trade al giorno. **Fascia candidata** se **|t| >= 2,3** (4 fasce guardate: soglia di Bonferroni 5%/4 unilaterale ~2,24, arrotondata). Direzione = segno della deriva. Nessun'altra scelta.
2. **Validazione (2018-2020), solo per le candidate, direzione e fasce NON modificabili:** profitto netto > 0, **PF netto >= 1,20**, **t >= 2,0** (sulla serie dei netti per giorno; soglia piu bassa perche la fascia e gia preselezionata e non cercata), **>= 150 operazioni**, profitto netto > 0 in almeno 2 anni su 3.
3. **Fuori campione 2021-2022 e 2023-2024:** PF netto >= 1,20 e profitto > 0 in ENTRAMBI, >= 100 operazioni ciascuno. Poi conferma su MT5 (Modello 1) prima di qualunque uso.
4. **Descrittivo (non porte):** deriva lorda e netta di tutte e 4 le fasce su 2015-2020, per anno.

## 4. Previsioni (scritte ora)
- Almeno una fascia candidata (|t| >= 2,3) nel 2015-2017: **50%**.
- Una candidata supera la validazione al netto dei costi: **12%** (il costo totale e circa 0,6-0,7 dollari per oncia a operazione: la deriva di una fascia di 4-9 ore deve superarlo).
- Passa anche il fuori campione: **5%**. Una candidata correlata con il breakout di Wim oltre 0,3: **15%** (condizionato a esistere).

## 5. Regole d'arresto
Se nessuna fascia supera la validazione: **"nessun candidato"** per la famiglia "orari fissi sull'oro a 4 fasce"; non si cambiano ne fasce ne soglie. Contatore dei "looks": +4 fasce, +4 direzioni (ognuna fascia contata una volta).

## 6. Risultato
*(da compilare; ora nessun numero)*
