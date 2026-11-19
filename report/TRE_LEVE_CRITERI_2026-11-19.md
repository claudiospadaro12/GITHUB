# Le tre leve contro costo e laterale (richiesta di Claudio "1, 2 e 3") — criteri scritti PRIMA dei numeri (19/11/2026)
Mercati: XAUUSD ed EURUSD (FTMO 2014-2020), NASUSD e SPXUSD (2015-2024); costi come nei test precedenti (oro 0,35 USD, EURUSD 1 pip, Nasdaq 2, S&P 0,7). In-Sample = primo 70% delle barre, Out-of-Sample = ultimo 30%. **Porte (di Claudio, immutate):** IS PF >= 1,5, DD <= 15%, >= 100 operazioni; VALIDATA se OOS PF > 1,2, R > 0, >= 30 operazioni. Nessuna soglia ottimizzata: i valori sono fissati qui.
## Leva 1 — filtro movimento/costo (incrocio EMA 9/21 + ADX > 12, uscita B2: stop 1,5 ATR + uscita sul segnale opposto)
Si opera solo se il costo in R del segnale, `costo / (1,5 x ATR)`, e' **<= 0,10, <= 0,06 o <= 0,04** (tre soglie fisse). TF M15, M30, H1. 4 x 3 x 3 = **36 test**. Il filtro e' deterministico (ATR e costo noti al segnale), non e' una stima di regime.
- Previsione: il filtro riduce le operazioni di oltre il 40% a soglia 0,06 su M15 e porta il R medio netto verso 0 senza renderlo positivo di piu' di +0,03: **75%**; una combinazione con OOS PF > 1,2 e >= 100 operazioni: **10%**; validata: **2%**.
## Leva 2 — timeframe piu' alti (stesso segnale e uscita B2)
TF **H2, H4, H8, D1** (H1 gia' misurato: PF IS mediano 0,88; H4: 0,85). 16 test.
- Previsione: PF netto mediano sopra 0,95 ma sotto 1,1 (costo piccolo, segnale lordo ~1,1): **60%**; validata: **3%**.
## Leva 3 — trend following con uscita che lascia correre (Chandelier)
(a) **Breakout N barre** (N = 20 e 55, long e short, ingresso all'apertura dopo la chiusura oltre il massimo/minimo delle N barre precedenti), stop iniziale 3 ATR, **stop mobile = massimo (minimo) dall'ingresso - (+) 3 ATR**, uscita intrabarra, una posizione alla volta, R = stop iniziale; TF H1, H4, D1. 2 x 3 x 4 = **24 test**. (b) **Incrocio EMA 9/21 con ADX > 12 come ingresso, stesso stop mobile 3 ATR**; TF H1, H4, D1; 12 test.
- Previsione: R medio positivo ma PF IS < 1,3 in tutti i test: **70%**; almeno un test con PF IS >= 1,5 e >= 100 operazioni: **8%**; validata: **3%**; il risultato migliore e' sul D1 o H4 e sugli indici (rialzo strutturale): **60%**.
## Confronti multipli
**In tutto 88 test** (36 + 16 + 36): per solo caso qualcuno superera' una soglia; **conta solo la porta di Claudio con OOS e piu' mercati concordi**. Per un indice vale l'avvertenza gia' vista (trascinamento del rialzo): separare long e short se un test passa.
## Limiti
Stessi dati e costi assunti dei test precedenti; il 2025-26 degli indici non e' usato qui (hold-out per un eventuale finalista).
