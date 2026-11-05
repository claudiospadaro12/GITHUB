# Gold Reaper: filtro Fake Breakout (Off / Low / Medium / High) — CRITERI e PREVISIONI (05/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, non ancora lanciato.** Richiesta di Claudio (05/11): "testiamola coi nostri anni... facciamo il test del fake-out", dopo i test Bitcoin. Nessuna modifica al live, al VPS o ai set in uso.

## Origine dell'ipotesi (NON verificata)
- dinocon9 (#all-gold-eas, 04/07/2026): nei suoi backtest, filtro su Low invece di Medium = "circa il doppio del profitto con DD relativo quasi identico". Immagini non lette, nessun periodo, nessun broker, nessuna conferma di Wim.
- Come funziona il filtro (manuale/market, da `MARKET_GOLD_REAPER_2026-10-10.md`): dopo l'apertura controlla se la candela su cui e' entrato ha chiuso a favore; se ha chiuso contro, chiude subito il trade invece di lasciarlo arrivare allo SL; livelli piu' forti = stesso controllo su piu' timeframe. Opzioni: OFF, Low, Medium, High. Default nostro: `FakeOutFilter=2` (Medium).
- Mappatura numero -> livello: **DERIVATA** (0 = Off, 1 = Low, 2 = Medium, 3 = High), dall'ordine del manuale e dal fatto che il nostro default 2 e' Medium. NON VERIFICATA sul report. Controllo prima di leggere i numeri: i valori devono comparire nel report come imposti e l'effetto deve essere ordinato (piu' basso = meno chiusure anticipate).

## Cosa si testa
Gold Reaper, XAUUSD H1, Modello 1 (OHLC 1 min), deposito 80.000 EUR, terminale BCM (conto demo 50503392), stesso set prop di sempre (MaxAllowedDD 9, limite giornaliero 4, OnlyUp false, Virtual_expiration true, Randomization 0), stessa macchina di test del 29/10. Si cambia SOLO `FakeOutFilter`.
- **F0** = 0 (Off), **F1** = 1 (Low), **F2** = 2 (Medium, il riferimento), **F3** = 3 (High).
- Anni (gli stessi dei test precedenti, per confrontare con i riferimenti): **2013, 2018, 2020, 2025**. Regimi oro: 2013 ribasso, 2018 laterale, 2020 e 2025 rialzo. Orari: AutoGMT dell'EA, non toccato.
- 16 passate (4 configurazioni x 4 anni). F2 viene RIFATTO (non si riusano i vecchi numeri) e poi confrontato con i riferimenti del 29/10 (netto 2013 +21.757, 2018 +13.535, 2020 +20.388, 2025 +30.457; DD equity 5.621 / 5.504 / 3.839 / 3.077) per verificare che il motore sia riproducibile.

## Cosa si misura
Per ogni passata: netto, PF, numero operazioni, DD equity assoluta e relativa, peggior giorno realizzato, giorni <= -3/-4/-5%, stop out, lotto medio/massimo, quante operazioni chiuse in anticipo dal filtro se il giornale lo mostra. Confronto F0/F1/F3 contro F2 anno per anno.

## Criteri di lettura (fissati ora)
- **PROP-ANNI** (come per gli altri): netto > 0, DD equity <= 8.000, nessuno stop out, nessun giorno realizzato <= -5%.
- **Una configurazione e' "migliore del Medium" SOLO se**: netto >= F2 in almeno 3 anni su 4 **e** nel quarto anno la perdita rispetto a F2 e' < 10%, **e** la DD equity non peggiora di oltre il 10% (o 500 EUR) in nessun anno, **e** passa PROP-ANNI in tutti gli anni in cui lo passa F2. Altrimenti: "NON DIMOSTRATO".
- Un solo giro di 4 anni NON basta per promuovere niente. Se F1 (o altra) passa la regola sopra, si fa la **Fase 2** su 4 anni diversi, scelti ora: **2015, 2019, 2022, 2024** (se i dati BCM li hanno; se no, lo dichiaro e uso altri anni scelti prima di vedere i numeri). Solo se passa anche la Fase 2 propongo un set "_Ottimizzato" separato (magic diverso, in parallelo agli originali).
- Se il vantaggio sta in un solo regime (es. solo i rialzi), lo riporto cosi', non come "migliore".

## Previsioni dichiarate ORA (non misurate)
- **R1** F2 rifatto riproduce i vecchi netti entro +-3% in tutti e 4 gli anni: 85%.
- **R2** F1 (Low) ha un netto diverso da F2 di oltre +-10% in almeno 3 anni su 4: 70%.
- **R3** F1 ha netto > F2 in almeno 3 anni su 4: 45%.
- **R4** F1 ha DD equity > F2 in almeno 3 anni su 4 (meno uscite anticipate, piu' SL pieni): 70%.
- **R5** Il "doppio del profitto" (F1 >= 1,8 x F2) in almeno un anno: 15%; in almeno 3 anni: 3%.
- **R6** F0 (Off) peggiore di F2 per DD equity in almeno 3 anni su 4: 75%.
- **R7** F3 (High) ha DD equity <= F2 in almeno 3 anni su 4 ma netto piu' basso in almeno 3 anni su 4: 55%.
- **R8** Nessuna configurazione e' "migliore del Medium" secondo la regola sopra: 60%.
- **R9** Tutte le 16 passate valide (input confermati dal report): 80%.
- **R10** Il numero di operazioni e' monotono con il livello (piu' filtro = piu' chiusure anticipate = piu' trade registrati o meno SL): non dichiaro direzione, la riporto.

## Cosa NON dice (limiti dichiarati)
- Un solo percorso per anno; OHLC a 1 minuto; nessuno slippage (Wim: lo slippage e' il vero nemico dell'EA oro sui broker reali).
- 2013, 2018 e 2020 sono probabilmente dentro l'ottimizzazione del venditore ("in-sample"): per questo la Fase 2.
- Filtro news: Wim dice (12/08/2026) che in backtest le date sono scritte nel codice e funziona, mentre nelle nostre note del 29/10 risultava "non simulato": **NON VERIFICATO** nei nostri report.
- L'oro a ~5.000 contro ~1.200 nel 2013: il lotto minimo 0.01 pesa diversamente; i DD in $ non sono confrontabili tra anni senza guardare il prezzo.
- AutoGMT sul BCM non verificato. Mappatura Off/Low/Medium/High derivata, non verificata.
- Un buon risultato di backtest non dimostra un vantaggio dal vivo. Nessun giudizio su acquisto, lotto o taglia, che decide Claudio.
