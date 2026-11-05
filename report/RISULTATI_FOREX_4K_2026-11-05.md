# Risultati dei 4 EA forex di Wim a 4.000 EUR (05/11/2026)

Criteri e previsioni scritti PRIMA: `CRITERI_FOREX_4K_2026-11-05.md`. Qui i numeri: 70 passate su 70 valide (deposito 4.000 EUR, Modello 1, qualita storico 99-100%, terminale BCM, solo tester). In tutte le 70 gli input del report coincidono con i valori dei set di Wim (confronto automatico, 0 differenze). Dati grezzi e script: `FOREX_4K_dati/`.

**DD** = drawdown equity relativo massimo del report (% del picco). **Netto** in EUR su 4.000. **Peggior giorno** = peggior somma giornaliera dei profitti realizzati, in % dei 4.000 iniziali (non conta le posizioni aperte).

## Esito per set

| Set | Esito | DD% 2013/17/20/22/25 | Netto EUR 2013/17/20/22/25 | Conto finale min | Peggior giorno % (min) | Stop out / no money |
|---|---|---|---|---|---|---|
| APEX ApexConservativeGrid | CANDIDATO | 24 / 23 / 12 / 11 / 22 | 153 / 715 / 1,716 / 1,382 / 913 | 4,153 | -25 | 0 / 0 |
| APEX ApexElevatedGrid | ZONA GRIGIA | 40 / 46 / 21 / 17 / 38 | 89 / 1,554 / 3,614 / 2,600 / 1,651 | 4,089 | -45 | 0 / 0 |
| APEX ApexUltraConservativeGrid | CANDIDATO (4/5 positivi) | 26 / 29 / 13 / 12 / 25 | -3 / 483 / 1,720 / 1,408 / 1,037 | 3,997 | -27 | 0 / 0 |
| APEX Apexextremerisk | SCARTATO | 92 / 76 / 66 / 46 / 80 | -3,017 / -1,905 / 34,302 / 17,063 / -2,952 | 983 | -210 | 86 / 125412 |
| APEX Apexhighriskliveaccount | SCARTATO | 81 / 61 / 91 / 73 / 78 | -2,455 / -1,771 / 1,854 / -2,364 / -2,020 | 1,545 | -613 | 104 / 49816 |
| DTP DaytradeProMax20DDmediumrisk | CANDIDATO | 14 / 13 / 8 / 6 / 9 | 1,020 / 1,329 / 2,303 / 1,998 / 134 | 4,134 | -8 | 0 / 0 |
| DTP DaytradeProMax50DDhighrisk | CANDIDATO | 29 / 29 / 19 / 16 / 24 | 2,706 / 4,053 / 6,872 / 6,319 / 120 | 4,120 | -29 | 0 / 0 |
| DTP DaytradeProMax9DDlowrisk | CANDIDATO | 7 / 7 / 4 / 4 / 6 | 463 / 616 / 1,013 / 1,047 / 131 | 4,131 | -4 | 0 / 0 |
| LUNA Luna4DD | CANDIDATO (4/5 positivi) | 23 / 7 / 6 / 5 / 2 | -826 / 123 / 774 / 975 / 1,130 | 3,174 | -3 | 0 / 0 |
| LUNA LunaAIrecommended | SCARTATO | 90 / 49 / 44 / 35 / 14 | -3,519 / 851 / 9,179 / 15,808 / 22,478 | 481 | -56 | 0 / 0 |
| LUNA LunaAIrecommendedlowrisk | ZONA GRIGIA | 48 / 18 / 16 / 12 / 5 | -1,785 / 369 / 2,066 / 2,912 / 3,476 | 2,215 | -8 | 0 / 0 |
| STAB stabilityprohighriskset | SCARTATO | 63 / 82 / 28 / 29 / 73 | 24,496 / -1,407 / 9,142 / 6,619 / -1,992 | 2,008 | -83 | 0 / 1990 |
| STAB stabilityprolowriskset | CANDIDATO | 14 / 14 / 6 / 7 / 19 | 2,034 / 611 / 1,129 / 974 / 562 | 4,562 | -2 | 0 / 0 |
| STAB stabilitypromediumlowriskset | ZONA GRIGIA | 29 / 26 / 13 / 15 / 36 | 6,179 / 1,520 / 3,004 / 2,305 / 1,305 | 5,305 | -7 | 0 / 0 |

## Confronto con le previsioni (S1-S10)

| # | Previsione | Esito |
|---|---|---|
| S1 | Un set Apex oltre 50% DD in un anno: 60% | **Vero** (`extremerisk` e `highrisk live account`; gli altri tre restano sotto 46%) |
| S2 | A 4k il DD e' piu' alto che a 80k in almeno 3 EA su 4: 70% | **Falso**: DD piu' alto a 4k solo in Daytrade Pro (10 su 15 passate); Apex 8 su 25, Luna 4 su 15, Stability 4 su 15 |
| S3 | Daytrade Pro: Max9 80%, Max20 55%, Max50 20% (DD <= 35% in tutti gli anni) | **Vero per tutti e tre** (max 7,1% / 14,0% / 29,4%). Max50 era previsto improbabile e invece rientra |
| S4 | Luna `4DD` 45%, `recommended` 10%, `lowrisk` 10% | `4DD` **vero** (max 22,7%); `recommended` falso (90% nel 2013) e `lowrisk` falso (48,2% nel 2013): come previsto |
| S5 | Stability `low risk` 35% | **Vero** (max 18,6%) |
| S6 | Apex `UltraConservative` 25% | **Vero** (max 28,6%): la previsione era troppo pessimista |
| S7 | Almeno un candidato 60%; piu' di 4 candidati 15% | **Vero ed eccedente**: 7 candidati (Daytrade Pro x3, Stability low, Apex Conservative, Apex Ultra, Luna 4DD) |
| S8 | Nessun set cresce oltre +100% in un anno restando sotto 35% DD: 60% | **Falso**: Daytrade Pro `highrisk` +172% (2020, DD 19%) e +158% (2022, DD 16%), +101% (2017, DD 29%); Stability `mediumlow` +154% (2013, DD 29%) |
| S9 | Righe "no money" o operazioni mancate: 50% | **Vero ma solo nei set gia' scartati** (Apex `extremerisk`, `highrisk`, Stability `highrisk`) |
| S10 | 70 passate tutte valide: 75% | **Vero** |

## Letture e limiti
- 7 candidati non vuol dire 7 EA adatti al reale: vuol dire degni di 4-8 settimane di forward in demo con magic diversi. Un solo percorso storico per anno.
- **Apex Conservative e Ultra**: DD 23-29% nel 2013 e 2017, ma in un solo giorno chiudono la griglia in perdita (-20...-27% del conto). Stesso rischio dei test a 80k. Ultra e' a -3 EUR nel 2013.
- **Daytrade Pro**: tutti e tre positivi in 5 anni su 5, ma nel 2025 rendono quasi zero (+3% circa, PF 1,03-1,13). `highrisk` ha il giorno peggiore -29% nel 2022 e -18% nel 2013. Con `Max9` il lotto minimo 0,01 e' il 64-80% delle operazioni, quindi a 4k il lotto non scala.
- **Stability `mediumlow`**: ZONA GRIGIA solo per un 35,9% nel 2025 (soglia 35%). Netto positivo in tutti gli anni. `highrisk` scartato: DD 63-82% in tre anni, -35% nel 2017 e -50% nel 2025.
- **Luna `recommended`** fa +230%, +395% e +562% nel 2020-25 ma il 2013 chiude a 481 EUR (-88%) e il 2017 ha DD 49%: scartato dal criterio.
- Non misurato: correlazione col trio oro, Guardian, slippage, leva reale. Orari/GMT degli EA (Apex GMT_Offset 1 fisso) non verificati contro il BCM. Il parametro "max DD a 0,01 lotti" non e' stato ricalibrato: valori del venditore.
- Peggior giorno oltre -100% (Apex `extremerisk`/`highrisk`): perdite realizzate su saldi cresciuti, espresse sui 4.000 iniziali.
