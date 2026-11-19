# Donchian (TV n.23) su Nasdaq e S&P 500: filtro EMA + stop — criteri scritti PRIMA dei numeri (19/11/2026)
**Dati:** storico esterno M1 `NASUSD` e `SPXUSD`, 2015-2024 (copia in sessione: 10 anni ciascuno, aggregato a H1; non e' il file `_EXT` BCM 2010-2026 ma lo stesso tipo di storico esterno). IS = primi 70% delle barre (circa fino a fine 2021), OOS = ultimo 30% (circa 2022-2024, include il ribasso 2022). Convenzione oraria non rilevante per un sistema H1 di trend (sposta solo il confine delle barre di 30 minuti): limite dichiarato. Il 2025-26 resta fuori (hold-out).
**Stesso identico test del 19/11 su EURUSD/oro:** 32 celle (lunghezza {20,40} x EMA {nessuna,100,200,400} x stop {nessuno,2,3,4} ATR), stessi segnali, stessa regola di scelta (massimo del PF IS piu' basso tra i due indici, almeno 100 operazioni IS su entrambi, plateau: meta' dei vicini con PF >= 1,2), stesse porte (IS PF >= 1,5, DD <= 15%, >= 100 op.; VALIDATA con OOS PF > 1,2, R > 0, >= 30 op. su entrambi). **Costi all-in: Nasdaq 2,0 punti, S&P 0,7 punti** (2,0 e' il costo gia' usato nei test Nasdaq; 0,7 e' una stima per lo S&P: se i costi reali fossero diversi cambia poco su H1).
**Rischio R:** distanza dello stop; senza stop 2 ATR convenzionale (nessuno stop applicato).
## Previsioni
- Nessuna cella passa il filtro IS su entrambi: **90%**.
- Miglior PF IS (il piu' basso dei due indici) >= 1,3: **18%**.
- Base senza filtro (len 20): PF IS > 1,1 sul Nasdaq: **40%** (gli indici salgono nel lungo periodo: il long ha vento a favore).
- Il filtro EMA migliora il PF IS rispetto al base su almeno un indice: **60%**.
- Stop riduce il DD rispetto al base: **85%**.
## Limiti
Un solo periodo, 2 indici correlati fra loro (quasi un solo test); mercato in forte rialzo strutturale: un risultato positivo andrebbe separato in long e short per capire se e' solo il drift. Gap notturni gestiti con fill all'apertura peggiore (stop).

## RISULTATI (`backtest_runner/simulatore/tv_scout8_donchian_indici.py`; buy&hold 2015-2024: Nasdaq 4,95x, S&P 2,86x; taglio IS/OOS 21-23/11/2021)
- **Nessuna cella passa il filtro IS; nessuna ha PF IS >= 1,3 su entrambi gli indici.** Miglior min-PF IS = **1,14** (lunghezza 40, EMA 400, stop 4 ATR), DD IS 22% Nasdaq e 31% S&P; plateau 0 vicini su 3 con PF >= 1,2.
- **Base (len 20, senza filtri):** PF IS 0,93 Nasdaq e 0,85 S&P (DD 80-88%): perde. Per anno: 2015 buono (1,68 / 1,53), 2016-2017 e 2021 pessimi (0,55-0,76).
- **Stop** riduce il DD (80% -> 52-60% Nasdaq) e **EMA 400** e' il filtro che rende di piu' (Nasdaq len 40 PF IS 1,31-1,46; S&P 1,05-1,14), mentre EMA 100-200 aiuta poco. Stessa direzione dell'oro (EMA 400 PF IS 1,27-1,37), non su EURUSD (0,84-1,00).
- **OOS (2022-2024) della cella scelta** (len 40, EMA 400, stop 4): Nasdaq PF 1,48 (112 op., R +0,27), S&P PF 1,11 (113 op., R +0,06); la vicina con stop 3: Nasdaq 1,65 / S&P 1,23. Per anno la cella scelta e' positiva in 7 anni su 10 sul Nasdaq (2015-2016 e 2024 sotto o attorno a 1) e in 6 su 10 sull'S&P (2015-2017 sotto 1).
- **Per le regole scritte: NON VALIDATA** (IS PF 1,14 < 1,5, DD > 15%, nessun plateau). Previsioni: nessuna passa (90%) → si'; min-PF IS >= 1,3 (18%) → no (1,14); base PF IS > 1,1 sul Nasdaq (40%) → no (0,93); EMA migliora PF su almeno un indice (60%) → si'; stop riduce DD (85%) → si'.
**Lettura onesta:** c'e' un segnale debole e coerente (trend lento + stop largo, su Nasdaq e oro, OOS positivo anche nel ribasso 2022), ma e' sotto le tue soglie e non e' separato dal vento di coda del rialzo strutturale degli indici (buy&hold 5x): manca lo split long/short. Un test successivo scritto prima dovrebbe separare long e short, fissare il filtro lento (EMA 400) come ipotesi unica e provarlo su dati mai usati (2025-26 hold-out, oppure `_EXT` 2010-2014). Nessun Pine finale per ora.
