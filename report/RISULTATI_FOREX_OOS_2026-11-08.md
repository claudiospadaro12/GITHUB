# Giro A forex fuori campione: risultati (08/11/2026)

Criteri e previsioni scritti PRIMA: `CRITERI_FOREX_TESTATO_BENE_2026-11-07.md`. Dati: 19 zip `WIM_01..19` (cartella `ANNO4K_WIM_FOREX_OOS_20261107_1903`), parser e analisi in `FOREX_OOS_dati/` (`parse_oos.py`, `analisi_oos.py`, `oos_res.json`, `oos_analisi.json`). 10 set x 7 anni nuovi (2014, 2016, 2018, 2019, 2021, 2023, 2024), deposito 4.000 EUR, Modello 1 (barre da 1 minuto), terminale BCM, solo tester.

## Validita
- **70 passate lanciate, 69 valide, 1 esclusa**: `APEX_ApexElevatedGrid_2024` e **KO** (il salvataggio del report si e bloccato oltre i 600 minuti: manifest "KO", nessun saldo finale). Per i criteri scritti e **esclusa e dichiarata, non sostituita**. Dal log: 1449 operazioni, netto +866,64, DD equity 23,77%: indizio, non risultato. Anche la passata 60 (Apex Conservative 2019) ha avuto lo stesso blocco ma si e chiusa in tempo ed e valida.
- Tutte le 69 valide: deposito 4.000, qualita storico 100%, input confermati dal report (`si` per Luna e Apex con i 3 parametri di orario; `nessuno_imposto` per Daytrade Pro e Stability, come nel 4k).
- **Peggior giorno realizzato non letto in 9 passate** (nei zip manca il report htm): Apex Cons 2023, Elevated 2014 e 2023, Ultra 2014 e 2023, DTP Max20 2023, DTP Max9 2024, Luna lowrisk 2018, Stability medium-low 2018. Netto, DD e operazioni vengono dal manifest e sono completi.
- DD "relativa" nei nuovi anni dal manifest; nei vecchi dal massimo fra report e referto (come nel 4k).

## Esito sui 12 anni (5 vecchi + 7 nuovi) con la definizione scritta prima
Regola: DD equity <= 35% in ogni anno (> 50% = scartato), netto > 0 in almeno 10 anni su 12, nessun anno con saldo finale < 3.000, nessuno stop out. Dopo il solo giro A il massimo possibile e **FUORI CAMPIONE SUPERATO**, non "TESTATO BENE" (mancano i giri B, C, E).

| Set | DD max nuovi (anno) | DD max 12 anni | Netto > 0 (12 anni) | Saldo finale min | Esito |
|---|---|---|---|---|---|
| **Daytrade Pro Max9** | 9,1% (2021) | 9,1% | 12/12 | 4.131 | **FUORI CAMPIONE SUPERATO** |
| **Daytrade Pro Max20** | 20,4% (2021) | 20,4% | 12/12 | 4.134 | **FUORI CAMPIONE SUPERATO** |
| Daytrade Pro Max50 | 45,8% (2021), 38,9% (2018) | 45,8% | 12/12 | 4.120 | **ZONA GRIGIA** (perde la qualifica di candidato) |
| **Stability Pro low risk** | 11,9% (2016) | 18,6% | 12/12 | 4.281 | **FUORI CAMPIONE SUPERATO** |
| Stability Pro medium-low | 24,6% (2016) | 35,9% (2025) | 12/12 | 4.563 | ZONA GRIGIA (solo per il 2025 vecchio) |
| **Luna 4DD** | 22,0% (2014) | 22,7% (2013) | 10/12 | 3.174 | **FUORI CAMPIONE SUPERATO** (sul filo: due perdite, 2013 e 2014) |
| Luna recommended lowrisk | 47,2% (2014) | 48,2% (2013) | 10/12 | 2.215 | ZONA GRIGIA (vicino al 50%) |
| **Apex Conservative** | 27,1% (2016) | 27,1% | 11/12 | 3.840 | **FUORI CAMPIONE SUPERATO** (con giorni da -23% del conto) |
| **Apex Ultra** | 32,9% (2016) | 32,9% | 10/12 | 3.362 | **FUORI CAMPIONE SUPERATO** (sul filo: 10/12 e 32,9%) |
| Apex Elevated | 41,3% (2014), 37,9% (2016) | 45,7% | 11/11 (2024 esclusa) | 4.089 | ZONA GRIGIA |

Nessun set scartato (DD > 50% o stop out o saldo < 2.000). Nessuna passata con stop out o "no money".

## Netto per anno nuovo (EUR su 4.000)
| Set | 2014 | 2016 | 2018 | 2019 | 2021 | 2023 | 2024 |
|---|---|---|---|---|---|---|---|
| DTP Max9 | 408 | 802 | 573 | 591 | 782 | 572 | 450 |
| DTP Max20 | 865 | 1.531 | 942 | 1.402 | 755 | 819 | 671 |
| DTP Max50 | 2.357 | 4.830 | 2.215 | 3.903 | 2.401 | 2.798 | 2.199 |
| Stab low | 1.551 | 1.493 | 586 | 299 | 354 | 833 | 281 |
| Stab medium-low | 4.086 | 4.608 | 1.528 | 611 | 841 | 1.987 | 563 |
| Luna 4DD | **-758** | 501 | 568 | 309 | 1.159 | 1.198 | 515 |
| Luna lowrisk | **-1.682** | 1.415 | 1.508 | 793 | 3.476 | 3.588 | 1.360 |
| Apex Cons | 961 | **-160** | 242 | 439 | 699 | 1.181 | 332 |
| Apex Ultra | 880 | **-638** | 102 | 288 | 641 | 1.177 | 271 |
| Apex Elevated | 2.487 | 1.194 | 588 | 987 | 1.675 | 2.414 | (KO) |

## DD equity relativa per anno nuovo (%)
| Set | 2014 | 2016 | 2018 | 2019 | 2021 | 2023 | 2024 |
|---|---|---|---|---|---|---|---|
| DTP Max9 | 3,7 | 4,0 | 7,8 | 5,0 | 9,1 | 4,7 | 5,1 |
| DTP Max20 | 7,7 | 7,5 | 12,9 | 8,2 | 20,4 | 8,3 | 5,3 |
| DTP Max50 | 17,6 | 19,3 | 38,9 | 19,6 | 45,8 | 13,8 | 15,6 |
| Stab low | 8,2 | 11,9 | 6,9 | 8,6 | 9,0 | 6,9 | 9,9 |
| Stab medium-low | 23,1 | 24,6 | 17,7 | 16,5 | 20,5 | 15,6 | 19,5 |
| Luna 4DD | 22,0 | 7,0 | 6,7 | 5,4 | 4,1 | 2,6 | 3,3 |
| Luna lowrisk | 47,2 | 16,0 | 16,6 | 12,6 | 10,2 | 6,2 | 8,1 |
| Apex Cons | 21,6 | 27,1 | 21,1 | 9,6 | 9,9 | 15,5 | 14,5 |
| Apex Ultra | 23,8 | 32,9 | 23,2 | 11,6 | 10,8 | 16,7 | 16,1 |
| Apex Elevated | 41,3 | 37,9 | 32,8 | 12,5 | 16,8 | 26,6 | (KO) |

## Giorni peggiori realizzati (solo dove il report htm c'e, EUR; 4.000 = 100%)
- Apex Cons: 2014 -749, 2016 **-936 (-23%)**, 2018 -791, 2019 -395, 2021 -208, 2024 -302.
- Apex Ultra: 2016 **-1.019 (-25%)**, 2018 -851, 2024 -336. Apex Elevated: 2016 **-1.722 (-43%)**, 2018 **-1.696 (-42%)**.
- DTP Max50: 2018 **-1.652 (-41%)**, 2021 -1.228. DTP Max9: al peggio -206 (-5%). Luna 4DD: -144 al peggio. Stability low: -27 al peggio (il giorno peggiore e minuscolo: griglia con stop piccolo).
- Quota di aperture al lotto minimo 0,01: Apex Cons 62-68%, Apex Elevated 40-45%, DTP Max9 61-75%, DTP Max20 2-36%; Ultra, Max50, Luna, Stability: 0%.

## Previsioni F1-F11 contro i risultati
| # | Previsione | Esito |
|---|---|---|
| F1 | DTP DD <= 35% in tutti i 7 anni: Max9 90%, Max20 80%, Max50 40% | Max9 **vero** (9,1%), Max20 **vero** (20,4%), Max50 **falso** (45,8%) |
| F2 | DTP netto > 0 in >= 6/7 anni: 75% / 70% / 60% | **Vero per tutti** (7/7) |
| F3 | Apex DD <= 35% in tutti i 7: Cons 45%, Ultra 50%, Elevated 10% | Cons **vero** (27,1%), Ultra **vero** (32,9%), Elevated **falso** (41,3%) |
| F4 | Luna 4DD DD <= 35%: 55%; lowrisk 15%; Luna 4DD negativa in almeno un anno: 55% | 4DD **vero** (22,0%); lowrisk **falso** (47,2%); negativa **vero** (2014: -758) |
| F5 | Stability low DD <= 35%: 55%; medium-low 25% | **Entrambe vere** (11,9% e 24,6%); il medium-low resta grigio solo per il 2025 vecchio (35,9%) |
| F6 | Almeno uno dei 7 candidati perde la qualifica: 80%; tutti e 7 la mantengono: 5% | **Vero**: Daytrade Pro Max50 la perde. Gli altri 6 restano |
| F7 | Un anno nuovo con >= 3 candidati in perdita: 50% | **Falso**: al massimo 2 (2016: Apex Cons e Ultra); 2014: solo Luna 4DD |
| F8 | Un set Apex con un giorno <= -20% in un anno nuovo: 60% | **Vero** (Cons 2016 -23%, Ultra 2016 -25%, Elevated 2016 e 2018 oltre -40%) |
| F9 | Almeno una coppia esclusa per dati: 40% | **Falso per i dati** (qualita 100% ovunque); 1 esclusa per KO (blocco del salvataggio) |
| F10 | Tutte le 70 passate valide (meno le escluse per dati): 80% | **Vero** per le 69 valide; la KO e dichiarata |
| F11 | Le etichette dei nuovi anni mostrano i peggiori DD delle griglie negli anni direzionali sui cross AUD/NZD: 55% | **NON MISURATO** (etichette degli anni nuovi non calcolate) |

## Letture
- **Le griglie soffrono nel 2014, 2016 e 2018, vanno bene dal 2019 in poi**: Apex Cons/Ultra/Elevated e Luna lowrisk hanno i DD alti nel 2014-2018, mentre 2019-2024 sono tutti sotto il 17% (Elevated sotto il 27%). Per le sole griglie il campione di 12 anni e dominato da pochi anni difficili. **Non e causale e non e verificata**: nessuna etichetta degli anni nuovi calcolata.
- **Il Daytrade Pro Max9 e Max20 sono i piu solidi**: 12/12 anni positivi, DD <= 20,4%. Max50 non regge: 45,8% e 38,9% in due anni nuovi, giorni da -41%.
- **Stability low** e il piu stabile sulla coppia DD-giorno peggiore, ma con rendimenti piccoli negli ultimi anni (2019-2024: +281...+833).
- **Luna 4DD**: a posto sul DD, ma con due perdite negli anni vecchi 2013-2014 (-19% e -19% del conto). Il passaggio e per 10/12 anni, al limite della regola.
- **Apex Conservative e Ultra**: passano il criterio, ma un singolo giorno puo costare -23%/-25% del conto (2016): su un conto prop con limite giornaliero 5% sono comunque inutilizzabili senza protezione (come gia scritto il 05/11).
- Rimane **non verificato**: OHLC contro tick (giro B), orari (giro C), flottante, commissioni FTMO, correlazione, taglia prop 80k (giro D/E), etichette degli anni.
- Un percorso per anno e un backtest a barre da 1 minuto: nessun giudizio su acquisto, lotto o taglia.

## Cosa resta per "TESTATO BENE (forex)"
Giri B (tick reali 2025), C (orari GMT), D (80k a lotto proporzionato) ed E (flottante giornaliero, commissioni FTMO, correlazione, Guardian). Da rifare: Apex Elevated 2024 (passata KO).
