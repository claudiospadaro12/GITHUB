# SomaGold: test a fondo a 80.000 EUR, risultati (25/10/2026)
**Natura: MISURA + LETTURA.** Criteri e previsioni scritti prima: `MARKET_SOMAGOLD_2IPOTESI_RISULTATO_E_DEEP_CRITERI_2026-10-25.md` e `MARKET_TEST_80K_NUOVI_ATTESE_2026-10-25.md`. Lettore congelato `leggi_deep80k_nuovi.py`. Archivio: `backtest_pipeline/risultati_archivio/DEEP80K_SOMAGOLD_20261025` (report compresso .gz; log del tester non archiviati: nello zip erano parziali). Corsa continua 01/01/2025-01/10/2026, XAUUSD H1, tick reali 100%, 80.000 EUR, leva 1:100, input imposti confermati dal report: `AutoGMT=false`, offset GMT 1 e 1, `MarginCallProtection=false`. Durata 72 minuti.

## Esito per le soglie (lettore, nessuna soglia ritoccata)
**Non passa: S-DD e S-NOSCALA.** Passano S-N (1.067 operazioni), S-M (16/21 mesi positivi, somma +680.162), S-H (+323.628 / +356.534; 2026 da solo +477.328), S-COSTO (media 637 EUR per operazione).
- Netto **+680.162 EUR** (saldo finale 9,5x), PF 3,66, 1.067 operazioni, nessuno stop out.
- **S-DD: NO.** DD equity dal picco 78.658 EUR (21,7% del picco); tetto scritto 8.000 EUR. Nei primi 6 mesi (post-hoc, solo realizzato) +81.098 con DD 8.559 EUR (10,7% di 80.000). Peggior mese in % del saldo di inizio mese: -10,7% (solo realizzato; l'indicatore in EUR del lettore dava -26,7% di 80.000 sul 2026-02, -21.369).
- **S-NOSCALA: NO.** Lotto massimo/minimo 172,6 (min 0,07, max 12,08), lotto medio 0,43 nei primi tre mesi contro 2,72 negli ultimi tre; **fino a 31 posizioni aperte insieme** (il limite era 10). Il lotto dopo una perdita rispetto a quello dopo una vincita e' 0,79: non c'e' martingala nel senso del lotto.
- **Ordini rifiutati per margine: 92 righe "not enough money"** (conteggio dello script sui giornali interi; nei 19.062 righe del giornale dello zip ne vedo 46, tutte su ordini pendenti buy stop da 0,11-1,08 lotti, in sei giorni: 21/01, 19/02, 13/03, 14/05, 29/08/2025 e 24/06/2026). Con la protezione spenta SomaGold piazza molti pendenti insieme e il margine del tester a 1:100 non basta sempre: **una parte degli ordini non e stata eseguita e il risultato dipende da quali**. Il lettore non corregge per questo.
- Input contro il setaccio: diversi in 4 voci, quelle imposte (previsto).

## Previsioni scritte prima
Corsa valida 85%: SI (stato OK; 92 rifiuti per margine da leggere). S-N passa 80%: SI. S-NOSCALA non passa 85%: SI. S-DD non passa 60%: SI. Esito "candidato" 15%: NO (non e candidato). PF a 21 mesi inferiore a 3,03 80%: **NO** (3,66, sopra quello del setaccio). 4 su 5.

## Cosa significa e cosa no
- E' lo stesso quadro degli altri EA ad auto-lotto: guadagna molto componendo, e la soglia in EUR assoluti sul DD e il limite sui lotti non passano per costruzione. In piu': ha **31 posizioni insieme** e **rifiuti di margine**, e per operare ha richiesto di **spegnere la protezione contro il margin call**. Un lotto massimo di 12 e un saldo di 9,5x sono fuori da cio che il tester sa dire su slippage, liquidita e regole di una prop.
- Il DD relativo (14,6% sul solo saldo realizzato, 21,7% equity dal picco) e' piu alto di quello degli altri EA ad auto-lotto (8,9-13,7%): a parita di metro e' il piu "scosso" fra quelli che compongono, con Vortex a parte.
- Niente su acquisti, taglie, lotti: decisioni di Claudio. La leva effettiva dei conti FTMO sull'oro non e verificata, e SomaGold con protezione accesa non opera in questo tester.
