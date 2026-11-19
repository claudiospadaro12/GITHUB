# GoldenZoe su altri mercati (indici, energia, metalli, agricoli, crypto): criteri scritti PRIMA dei dati (19/11/2026)

**Perche:** oltre all'oro, lo scan BCM non ha trovato candidati (31 forex: solo filone JPY dipendente dalla deriva; XAG, XNG perdenti; platino/palladio senza storico; indici e petrolio BCM senza storico prima del 2024; Nasdaq/S&P `_EXT` Donchian: hold-out fallito; Bitcoin chiuso). Manca la prova su mercati con trend lunghi (indici, petrolio, rame, cereali, crypto) con **storico lungo**: lo prendiamo dal server pubblico **MetaQuotes-Demo** con `ABTG_ExportH4` (barre H4 dal 2010, orario del server MetaQuotes).
**Regola provata (simulatore Python, la stessa di GoldenZoe H4):** ingresso quando la candela H4 chiusa chiude sopra il massimo delle 55 precedenti (e, in una variante separata, sotto il minimo per le vendite), ingresso all'apertura successiva; stop iniziale 3 ATR; stop mobile Chandelier 3 ATR; una posizione; nessun altro filtro. Costi: spread del simbolo o stima 0,35 unita di prezzo dell'oro riscalata; NESSUNA ottimizzazione dei parametri (N=55, 3, 3 fissi).
**Universo:** tutti i simboli esportati (non forex, non azioni) con >= 8 anni di storico. Il numero N di mercati provati si riporta e conta come numero di prove.

## Finestre (fissate ora)
- **IS (selezione):** 2010-01-01 -> 2019-12-31. **OOS (giudizio):** 2020-01-01 -> 2024-12-31. **Hold-out:** 2025-01-01 -> fine: NON si guarda finche non e fissata la lista dei candidati.
- Long e short valutati SEPARATAMENTE (gli indici hanno deriva rialzista: un risultato solo long e "dipendente dalla tendenza").

## Previsioni (prima dei dati)
- Su N mercati, quelli che passano l'IS (PF >= 1,3, >= 30 operazioni, t >= 2): **circa 10-20%**; di questi, passano anche l'OOS (PF > 1,2, >= 15 operazioni, profitto > 0): **meno della meta**.
- Almeno un mercato long-only validato (IS + OOS): **40%**. Almeno uno validato anche in versione simmetrica (SHORT con PF >= 1,0): **10%**.
- Almeno DUE mercati della stessa classe (es. due indici, o due metalli) validati insieme: **15%**.

## Regole di esito
1. **Candidato** = passa IS e OOS nella stessa direzione, con le soglie sopra, E la classe ha almeno un altro mercato con PF OOS > 1,0 (coerenza di classe). Un mercato isolato e "da guardare", non candidato.
2. **Deriva:** se un mercato passa solo long e lo SHORT ha PF < 0,8 in OOS, esito "dipendente dalla tendenza, non validato" (come EURJPY).
3. **Hold-out** solo sui candidati fissati: un candidato regge se PF > 1,0 e profitto > 0 nel 2025-oggi con >= 8 operazioni; altrimenti chiuso.
4. **Prima di qualsiasi demo:** conversione dei costi in un tester (BCM/FTMO) e correlazione con GoldenZoe oro; l'orario H4 del MetaQuotes-Demo differisce da BCM/FTMO (le candele non coincidono): il test sul tester dello stesso broker e obbligatorio.
5. Nessun consiglio su lotti/taglie; solo tester/demo.
