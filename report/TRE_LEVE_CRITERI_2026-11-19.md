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

## RISULTATI (`backtest_runner/simulatore/tre_leve.py`, log in `TRE_LEVE_risultati.txt`; 88 test)
| Leva | Test (con >= 100 op. IS) | PF IS mediano / massimo | R IS > 0 |
|---|---|---|---|
| 1 movimento/costo | 36 (31) | 0,93 / 1,75 | 11 |
| 2 TF alti (H2, H4, H8, D1) | 16 (12) | 0,92 / 1,22 | 5 |
| 3a breakout + Chandelier | 24 (16) | 0,96 / 1,33 | 7 |
| 3b incrocio EMA + Chandelier | 12 (8) | 0,96 / 1,15 | 3 |
- **PF IS >= 1,2 con >= 100 operazioni: 3 test su 88; nessuna VALIDATA.** Per solo caso se ne attendono alcuni. I tre: EURUSD M15 costo <= 0,04 R (IS PF 1,75, n 112, DD 9%; **OOS PF 1,06**, n 43); **oro H4 breakout 55 + Chandelier (IS PF 1,33, n 121, DD 4%, R +0,11; OOS PF 2,12, n 46, R +0,36)**; EURUSD H4 EMA B2 (IS 1,22, DD 22%; OOS 1,41).
- **Leva 1:** il filtro costo riduce molto le operazioni (EURUSD M15 da 4.316 a 690 a soglia 0,06; oro M15 da 4.030 a 13) e porta il R netto verso lo zero (EURUSD M15 0,06: R +0,019, OOS PF 1,11) ma non crea un vantaggio; nell'oro il filtro dipende dal regime di volatilita' (IS 227 contro OOS 689 operazioni). Previsioni: riduzione > 40% e R <= +0,03 (75%) -> si'; OOS PF > 1,2 con >= 100 op. (10%) -> no.
- **Leva 2:** il PF mediano e' 0,92 (previsione > 0,95: 60% -> no); l'esito e' instabile tra TF vicini (EURUSD: H2 IS 0,84 / OOS 1,79, H4 1,22 / 1,41, H8 0,77 / 0,54): rumore.
- **Leva 3:** unico filo coerente: **breakout + stop mobile su H4**, OOS PF > 1 in 7 casi su 8 (oro 1,32 / 2,12; EURUSD 1,31 / 1,19; Nasdaq 1,11 / 1,64; S&P 0,93 / 1,15), ma IS misto (EURUSD 0,83 / 0,67; S&P 0,92 / 0,92) e il fuori campione degli indici e' un periodo di rialzo. Previsioni: PF IS < 1,3 ovunque (70%) -> no (oro H4 55: 1,33); PF IS >= 1,5 con >= 100 op. (8%) -> no.
**Verdetto: nessuna validazione.** Le tre leve da sole non portano un incrocio EMA o un breakout a PF 1,5. L'unico candidato da guardare e' **oro H4 breakout 55 barre con stop mobile 3 ATR** (positivo in IS e OOS, DD 4%).
## SEGUITO: candidato congelato (scritto ora, prima di nuovi dati)
Oro XAUUSD H4: breakout 55 barre (long e short), stop iniziale 3 ATR, stop mobile Chandelier 3 ATR, costo 0,35 USD; vicino di controllo: breakout 20. Da giudicare su **oro FTMO 2021-2026 (mai usato)** quando arriva `EXPORT_M1_FTMO_*` (riga `RIGA_EXPORT_M1_FTMO_ORO_2021_26.txt`). **Porta:** >= 30 operazioni, PF > 1,2, R > 0 per 55 barre e PF > 1,1 per il vicino a 20; nessun parametro toccato. Previsioni: PF 2021-26 > 1,2: **35%** (e' un regime di trend forte per l'oro: favorevole, ma e' il quarto test con questo esito su 88); PF tra 1,0 e 1,2: 30%; < 1,0: 35%.

## ESITO DEL CANDIDATO CONGELATO su oro FTMO 2021-2026 (zip `EXPORT_M1_FTMO_20261119_150508`: 6 anni completi, 0 errori; la copia FTMO ha lo storico dal 2004.06.11)
- **Oro H4, breakout 55 + Chandelier 3 ATR, 2021-01 -> 2026-11 (9.102 barre H4, oro x1,96):** 188 operazioni, PF **1,23**, R +0,078, DD 8,3%, t 1,0, win 36%; per anno PF 0,60 / 1,18 / 2,06 / 1,43 / 1,32 / 0,99. **Vicino breakout 20: 273 operazioni, PF 1,32, DD 8,9%, t 1,6.**
- **Porta scritta (>= 30 op., PF > 1,2, R > 0; vicino PF > 1,1): superata, di poco** (previsione PF > 1,2: 35% -> si').
- **Long e short:** i **long** hanno PF 1,75 (108 op., t 1,9); gli **short** PF 0,62 (80 op.). Sul 2014-2020 (periodo del test iniziale): long PF 1,89 (98 op.), short 1,12 (69 op.). **I long sono positivi in entrambi i periodi (t circa 2); gli short no.** Periodo intero 2014-2026: 357 operazioni, PF 1,38, R +0,124, DD 8,3%, t 2,0.
- **Cautele:** (1) il candidato e' uscito da 88 test (selezione); (2) l'oro e' raddoppiato nel 2021-26: gli short perdono perche' il prezzo sale; la parte che regge e' la tendenza rialzista; (3) il PF 1,23 e' appena sopra la soglia e t = 1,0 non e' significativo; (4) la versione solo-long non era stata congelata: e' **esplorativa**.
## Gold 4-Day Breakout su FTMO 2021-2026 (criteri `GOLD_4DAY_2021_26_CRITERI`, regola congelata)
2021-22 PF 1,04 (252 op.); **2023-2026 PF 1,26 (484 op.), tutti e 4 gli anni sopra 1 (1,23 / 1,23 / 1,31 / 1,32)**: **replica il loro 1,31 con i dati FTMO** (porta: PF >= 1,15, >= 150 op., 3 anni su 4 positivi: superata). **Periodo intero 2014-2026: 1.460 operazioni, PF 1,09, R +0,033** (coerente col PF 1,05 di Massimo sul 2013-26): il vantaggio e' concentrato negli anni di oro volatile, non persistente. Verdetto invariato: chiuso come EA sempre attivo.
## SEGUITO: test su anni mai visti (2004-2014), criteri scritti ora
Dati: oro FTMO 2004-06 -> 2014-11 (riga `RIGA_EXPORT_M1_FTMO_ORO_2004_2014.txt`; se la cache non ha tutti gli anni si usa quello che c'e'). **Congelati:** oro H4, breakout 55 (long+short) e breakout 20, stop iniziale 3 ATR e Chandelier 3 ATR; esplorativa: **solo long**. Costo 0,35 USD. **Porta:** long+short: >= 100 operazioni, PF > 1,2, R > 0; solo long: >= 60 operazioni, PF > 1,3, R > 0; vicino breakout 20 PF > 1,1. Previsioni: long+short PF > 1,2: **40%**; solo long PF > 1,3: **45%**; gli short PF < 1,0: **55%**.

## RISULTATI su oro FTMO 2004-06 -> 2014-10 (zip `EXPORT_M1_FTMO_20261119_150924`: 11 file annuali, 1 errore di lettura nel 2004; oro da 384 a 1.172, x3,05)
| Variante (costo 0,35 USD) | Operazioni | PF | R medio | DD | t |
|---|---|---|---|---|---|
| Breakout 55, long+short | 325 | **1,21** | +0,067 | 9,7% | 1,3 |
| Breakout 55, solo long | 188 | **1,45** | +0,123 | 6,2% | 2,0 |
| Breakout 55, solo short | 137 | 0,97 | -0,010 | 18,1% | -0,1 |
| Breakout 20, long+short / solo long / solo short | 492 / 268 / 235 | 1,29 / **1,68** / 1,00 | +0,089 / +0,173 / +0,001 | 7,7% / 8,9% / 21,2% | 2,0 / 3,2 / 0,0 |
Con costo doppio (0,70 USD): 55 long+short PF 1,13; 55 solo long 1,34; 20 solo long 1,56. Per anno (55, long+short): PF da 0,80 a 2,47, 4 anni su 11 sotto 1.
- **Porta scritta superata:** long+short >= 100 op., PF 1,21 > 1,2, R > 0; vicino a 20 PF 1,29 > 1,1; solo long PF 1,45 > 1,3 con 188 op.; short PF 0,97 < 1. Previsioni: long+short PF > 1,2 (40%) -> si' (di poco); solo long PF > 1,3 (45%) -> si'; short PF < 1,0 (55%) -> si' (0,97 / 1,00).
- **Tre periodi indipendenti, tutti positivi per i long:** 2004-2014 PF 1,45; 2014-2020 PF 1,89; 2021-2026 PF 1,77. **Periodo intero 2004-06 -> 2026-11 (23 anni, oro da 384 a 3.723):** 55 long+short 685 operazioni PF 1,32, t 2,4, 16 anni positivi su 23; **55 solo long 396 operazioni PF 1,66, R +0,194, DD 8,1%, t 3,3, 17 anni su 23**; solo short 289 operazioni PF 0,94. Anni negativi dei long (somma di R): 2004 -0,5; 2012 -1,4; 2013 -1,7; 2014 -2,8 (oro in calo 1.900 -> 1.050); 2018 -2,8; 2021 -6,0.
- **Cautele:** (1) e' una strategia con bias rialzista su un mercato che e' salito di 9,7 volte: il vantaggio e' "seguire la tendenza dell'oro al rialzo"; gli short non aggiungono nulla; (2) costi storici dello spread nel 2004-2010 probabilmente piu' alti di 0,35 USD (con costo doppio il vantaggio resta: PF 1,34); (3) barre H4 da M1, nessun tick, nessun flottante intraday; (4) il candidato e' uscito da 88 test, ma ora ha passato due periodi nuovi congelati; (5) FTMO: regole di rischio e di tenuta delle posizioni da verificare.
## Correlazione con gli EA di Wim sull'oro (solo 2025-2026, unici anni delle serie `ANNO_ORO_GRADINI_R21`; P&L realizzato per giorno di uscita)
Candidato (55, long+short e solo long) contro Goldbot One, Reaper, Phantom (M1/M4, L1/L3): correlazione giornaliera tra **-0,06 e +0,07** (giorni attivi del candidato 39-64). **Limite forte:** P&L realizzato, non flottante; un sistema di trend a tenuta pluri-giornaliera e uno intraday risultano scorrelati a questa misura anche se nei grandi movimenti dell'oro possono perdere o guadagnare insieme. Campione di 2 anni.
## Prossimo passo
EA MQL5 per il tester BCM e FTMO (costi, swap e spread veri, tick nel 2025): oro H4, breakout 55, stop iniziale 3 ATR + Chandelier 3 ATR, **versione solo long come principale** (e long+short come confronto). Un test del tester con le stesse regole di porta prima di qualunque uso reale.
