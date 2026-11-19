# Donchian su Nasdaq/S&P, hold-out 2025-2026 — criteri scritti PRIMA di vedere i dati (19/11/2026)
**Ipotesi unica, congelata ora** (dal test 2015-2024, `DONCHIAN_INDICI_CRITERI_2026-11-19.md`): canale 40, filtro EMA 400, stop 3 ATR (la cella scelta con stop 4 ATR e quella con stop 3 sono le due vicine migliori; si valutano ENTRAMBE, senza scegliere dopo), conferma doppia, long+short, H1, ingresso all'apertura successiva, stesse regole di costo (Nasdaq 2,0 / S&P 0,7 punti). Dati: `NASUSD_M1` e `SPXUSD_M1` 2025-2026 dallo stesso storico esterno (EST fissa) del test 2015-2024. Nessun parametro viene toccato.
**Porte:** il periodo 2025-26 e' una conferma, non un'ottimizzazione. CONFERMATA se su ENTRAMBI gli indici: >= 30 operazioni, R medio netto > 0, PF > 1,2. Separare long e short: se il PF dei soli long e' > 1,2 e quello dei soli short < 1,0 su entrambi gli indici, il risultato e' **trascinamento del rialzo**, non un vantaggio del sistema (declassato).
## Previsioni
- Conferma su entrambi gli indici (PF > 1,2 con entrambe le varianti di stop): **25%**.
- Almeno un indice con PF > 1,0 (una variante): **55%**.
- Nel caso di conferma, i soli short hanno PF < 1,0 su entrambi: **60%** (il vento di coda degli indici).
## Limiti
~1,5 anni (2025 + parte del 2026): ~25-60 operazioni a indice per variante; un periodo breve non basta a un verdetto definitivo (si legge solo se i segni sono coerenti col 2015-2024). Il file sorgente potrebbe finire prima della fine del 2026: si usa quello che c'e'.

## RISULTATI (`backtest_runner/simulatore/tv_scout8_donchian_holdout.py`; dati 2025-01-01 -> 2026-07-31, 9.300 barre H1 per indice, buy&hold Nasdaq x1,34, S&P x1,27)
Deviazione dichiarata: l'EMA 400 e i canali sono scaldati con il 2024 (stesso file), ma si contano solo le operazioni con ingresso dal 2025.
| Indice | Variante | Operazioni | R netto | PF | DD | Solo long (n / PF) | Solo short (n / PF) |
|---|---|---|---|---|---|---|---|
| Nasdaq | len40 EMA400 stop 3 | 77 | -0,18 | **0,77** | 28% | 38 / 1,11 | 39 / 0,46 |
| Nasdaq | stop 4 | 71 | -0,07 | **0,89** | 22% | 35 / 1,42 | 36 / 0,45 |
| S&P 500 | stop 3 | 89 | -0,34 | **0,56** | 34% | 44 / 0,72 | 45 / 0,44 |
| S&P 500 | stop 4 | 77 | -0,25 | **0,64** | 25% | 38 / 0,95 | 39 / 0,41 |
Riferimento Donchian nudo (canale 20): PF 0,64 / 0,59. Per anno (stop 3): Nasdaq 2025 PF 1,22, 2026 0,38; S&P 2025 0,89, 2026 0,25.
**Verdetto con le regole scritte: NON CONFERMATO** (nessuna variante ha PF > 1,2 su entrambi; tutte < 1,0). Il segnale debole del 2015-2024 non regge sul periodo mai visto. Gli short perdono sempre (PF 0,41-0,46, win 9-11%) e solo i long del Nasdaq sono vicini al pareggio: coerente con la lettura "trascinamento del rialzo", non un vantaggio del sistema. Previsioni: conferma (25%) → no; almeno un indice con PF > 1,0 (55%) → **no (sbagliata)**; short con PF < 1,0 (60%) → si'.
**Donchian chiuso.** Chiusa anche la caccia ai Pine pronti di TradingView.
