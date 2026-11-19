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

---
## VARIANTE D1 (screening, 19/11/2026): dati giornalieri gratuiti da Yahoo Finance, PRIMA dei dati
Scelta di Claudio: strada "dati D1 da internet" (nessuna installazione di MT5). **Non e GoldenZoe H4:** e la stessa famiglia di regola su barre giornaliere. Serve a capire **quali classi di mercato seguono il trend**; non produce da sola un EA (un candidato andrebbe poi riscalato e ritestato su H4 con dati del broker).
**Dati:** circa 33 mercati: indici (S&P 500, Nasdaq 100, Dow, Russell 2000, DAX, FTSE, Nikkei, CAC, EuroStoxx 50, Hang Seng, ASX 200), energia (WTI, Brent, gas, gasolio, benzina), metalli (oro, argento, rame, platino, palladio), agricoli (mais, grano, soia, caffe, zucchero, cacao, cotone), Treasury 10 e 30 anni, Bitcoin, Ethereum, indice dollaro. **Limite:** i futures sono serie continue NON corrette per i roll (salti al cambio contratto) e gli indici sono spot/indice: si segna per classe.
**Regola:** come GoldenZoe (chiusura sopra il massimo delle N barre precedenti, ingresso all'apertura successiva, stop iniziale 3 ATR(14), Chandelier 3 ATR, una posizione), **solo due varianti pre-registrate: N=20 e N=55** barre giornaliere, long e short separati. Costo: 0,05% del prezzo per giro. Nessun altro parametro.
**Finestre:** IS dall'inizio dello storico al 2014-12-31 (>= 8 anni richiesti); OOS 2015-01-01 -> 2024-12-31; hold-out 2025 in poi (non si guarda prima di fissare i candidati).
**Previsioni:** su circa 33 mercati x 2 varianti x 2 direzioni (circa 130 prove): quelli che superano l'IS (PF >= 1,3, >= 30 operazioni, t >= 2): 10-20%; passano anche l'OOS (PF > 1,2, >= 15 operazioni, profitto > 0): meno della meta. Almeno una classe (indici, energia, metalli, agricoli, obbligazioni, crypto) con 2 o piu mercati validati in entrambe le varianti N: **15%**. Oro D1 long: gia chiuso senza candidati (non si riapre).
**Regola di esito:** "classe che segue il trend" solo se >= 2 mercati della classe passano IS+OOS con N=20 E N=55 nella stessa direzione; un singolo mercato = "da guardare". Short valutato come controllo di deriva (SHORT PF < 0,8 con LONG valido = dipendente dalla tendenza). Se emerge una classe: passo successivo = H4 del broker (BCM/FTMO) o MetaQuotes-Demo, mai direttamente un demo.

---
## RISULTATO D1 (19/11/2026, zip DATI_D1_20261119_2108: 33 mercati scaricati su 33; script `backtest_runner/simulatore/d1_trend_screen.py`, tabella in `GOLDENZOE_ALTRI_MERCATI_dati/risultati_D1_screen.txt`)
- **Prove valide: 116** (mercati con >= 8 anni prima del 2015; Brent, EuroStoxx 50, Bitcoin ed Ethereum esclusi per storico IS corto). **Passano IS (PF >= 1,3, n >= 30, t >= 2): 13 (11%); passano IS+OOS: 6 (5%).** Previsione IS 10-20%: in linea.
- **Classe che segue il trend (regola: >= 2 mercati della classe passano IS+OOS con N=20 E N=55, stessa direzione): INDICI, LONG: Hang Seng e Nikkei 225.** Previsione "una classe validata" 15%: si e verificata. Nessun'altra classe (energia, metalli, agricoli, obbligazioni, crypto, valute) ha mercati validati in entrambe le N. Oro long: N=20 passa IS+OOS (PF 2,52 / 1,82), N=55 manca l'IS per il t (1,9 contro 2,0): non e un nuovo candidato.
- **Mercati vicini ma sotto soglia:** Nasdaq 100 (N20 passa; N55 IS PF 1,67 t circa 2,0), S&P 500, Dow (OOS PF 1,8-2,2 ma IS t < 2), DAX (IS ok, OOS PF 1,14), Russell 2000 (IS PF 3,0-3,5, OOS PF 0,6-1,2). **Europa e Australia (FTSE, CAC, ASX) non seguono il trend** in OOS (PF 0,6-0,9). Quindi non e "gli indici in generale".
- **Controllo deriva (SHORT):** SHORT OOS PF 0,74 / 0,95 (Hang Seng N20 / N55) e 0,69 / 0,40 (Nikkei N20 / N55): 3 su 4 sotto 0,8 = **dipendente dalla tendenza rialzista degli indici** (come EURJPY): il long-only e esposizione azionaria con stop, non un vantaggio simmetrico.
- **Hold-out 2025+ sui due candidati fissati:** **Nikkei 225: N20 long 9 operazioni PF 2,99 (+4,6 R); N55 long 9 operazioni PF 1,87 (+2,4 R): regge.** **Hang Seng: N20 long 11 operazioni PF 0,76 (-1,0 R): non regge; N55 solo 5 operazioni: non valutabile -> chiuso** (regola: PF > 1 e >= 8 operazioni).
- **Esito:** un solo candidato, **Nikkei 225 long-only (N=20 e N=55), dipendente dalla deriva**, 52 operazioni in 10 anni di OOS con N=20. Da fare prima di qualsiasi demo: (1) conversione in un tester su CFD JP225 del broker (BCM `225JPY` ha storico dal 2024; FTMO `JP225.cash`) con spread e swap; (2) correlazione con GoldenZoe oro; (3) decisione sul rischio di deriva (nessun consiglio su taglie). Limiti: indice spot di Yahoo (no spread/swap/orari CFD), 116 prove, solo 9 operazioni nell'hold-out, 2025 e anno di forte rialzo del Nikkei.
