# Bulge: prove di miglioramento nel tester — criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Natura: solo tester (BCM portable, Modello 1 = barre da 1 minuto), nessun ordine, nessun giudizio su lotti/taglie. Richiesta di Claudio: "voglio che proviamo a migliorare Bulge". Quella richiesta supera il vincolo scritto nell'EA ("non si aggiusta il rapporto rischio/rendimento senza una decisione di Claudio"). Analisi di partenza: `BULGE_ANALISI_FORWARD_2026-11-18.md`.

## Cosa si prova (poche varianti, nessuna ottimizzazione libera)
- **Copia di prova `ABTG_Bulge_TS.mq5`** (l'originale non si tocca): unica differenza = input `Time_Stop_Hours` (0 = spento, identico all'originale), che chiude a mercato le posizioni aperte da piu di N ore. Include del Guardian incluso nella stessa cartella; nel tester `InpUsaGuardian=false`, `InpVerbose=false`, `InpAutoTest=false`. Tutto il resto = valori di default del sorgente.
- **Varianti (5):** V0 = default; TS2, TS4, TS8 = uscita a tempo a 2, 4, 8 ore; SL2 = `SL_ATR_Mult` 2,0 (invece di 3,0).
- **Paniere:** i 6 cross del backtest di riferimento di Claudio (GBPUSD, GBPJPY, NZDJPY, AUDUSD, CADJPY, NZDCAD), UN cross alla volta (`Symbols_List` = quel cross; regola della Guida Test: MT5 modella male i simboli diversi dal grafico). **Scelti da Claudio, non dai miei numeri del demo.**
- **Anni:** 2016, 2019, 2022, 2025 (anni interi, H1). 5 x 6 x 4 = **120 passate**. Deposito 10.000 EUR, rischio % di default (0,8): il PF e i R sono confrontabili, gli euro no.

## Come si decide (regole scritte ora, nessuna ritoccata)
Su tutte le 24 celle (6 cross x 4 anni) per ogni variante si sommano le operazioni: PF aggregato (somma vincite / somma perdite del tester in euro, a rischio costante), numero di operazioni, PF per anno.
- **MIGLIORA** (rispetto a V0) se: (a) PF aggregato >= PF(V0) + 0,15; (b) PF aggregato > 1,00; (c) migliora in almeno 3 anni su 4 (PF dell'anno, tutti i cross sommati); (d) operazioni >= 60% di V0.
- **MIGLIORA MA RESTA SOTTO 1:** (a), (c), (d) vere ma PF aggregato <= 1,00.
- **NON MIGLIORA:** altrimenti. Nessuna combinazione di varianti, nessuna scelta dei cross a posteriori. Se una variante passa, solo allora: vicini (2,5 e 3,5 ore ecc.) e un anno NON usato (2014, 2017, 2021, 2024).
- **Riferimento onesto:** V0 va guardato da solo: se il PF aggregato di V0 e < 1,00 anche nel tester, Bulge non ha vantaggio nemmeno in condizioni ideali.

## Previsioni (scritte ora)
- PF aggregato di V0 < 1,00: **50%** (Sala 01/11: forex PF 1,03; demo: PF in R 0,85).
- Almeno una variante TS "MIGLIORA" per le regole sopra: **35%**; "MIGLIORA MA RESTA SOTTO 1": **25%**; nessuna migliora: **40%**.
- SL2 "MIGLIORA": **15%**. Qualsiasi variante con PF aggregato >= 1,20: **12%**.
- Le uscite a tempo riducono il numero di vincenti (taglio di vincite lente): **70%**.
## Limiti da dichiarare
Barre da 1 minuto (non tick), un percorso per anno, 6 cross su 22, la Guardian spenta, ADX/ATR/kill switch come da default (non necessariamente uguali al set sul demo), spread e commissioni del tester.
