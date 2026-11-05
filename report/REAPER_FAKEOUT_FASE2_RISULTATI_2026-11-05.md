# Gold Reaper: fake-out Fase 2 (Low contro Medium su 2015, 2019, 2022, 2023, 2024) — RISULTATI (05/11/2026)

Fonte: zip `ANNO80K_REAPER_FAKEOUT2_20261105_1708` (10 passate, 10 report, tutte STATO OK, `FakeOutFilter` confermato dal report; **i dati BCM del 2024 ci sono**). Stessa configurazione della Fase 1 (XAUUSD H1, Modello 1, 80.000 EUR, set prop MaxAllowedDD 9, limite 4, OnlyUp false, Virtual_expiration true, Randomization 0). Criteri e previsioni: `REAPER_FAKEOUT_CRITERI_2026-11-05.md` (sezione FASE 2). Dati: `REAPER_FAKEOUT_dati/fakeout2_res.json`.

## Esito in una riga
**Il Low non e' un miglioramento affidabile del Medium: e' meglio in 3 anni su 5, quasi pari in 2, e nel 2024 ha un DD molto piu' alto (+45%) con un giorno a -5,6% e DD sopra 8.000 EUR.** Sui 9 anni insieme resta **"NON DIMOSTRATO"**.

## Tabella (netto EUR / PF / DD equity massima EUR / peggior giorno / operazioni)
| Anno | F1 Low | F2 Medium | F1 contro F2 (netto; DD equity; netto/DD) |
|---|---|---|---|
| 2015 | +16.136 / 1,54 / 6.023 / -3,2% / 546 | +13.031 / 1,45 / 6.398 / -3,6% / 547 | +23,8%; -5,9%; 2,68 contro 2,04 (Low meglio) |
| 2019 | +21.021 / 1,69 / 6.029 / -3,9% / 522 | +21.356 / 1,74 / 5.725 / -3,2% / 522 | -1,6%; +5,3%; 3,49 contro 3,73 (Medium meglio) |
| 2022 | +15.616 / 1,57 / 5.636 / -4,4% / 530 | +11.492 / 1,43 / 6.058 / -4,1% / 530 | +35,9%; -7,0%; 2,77 contro 1,90 (Low meglio) |
| 2023 | +31.085 / 2,57 / 5.512 / -3,0% / 560 | +21.535 / 2,03 / 5.351 / -3,2% / 560 | +44,3%; +3,0%; 5,64 contro 4,02 (Low meglio) |
| 2024 | +23.645 / 1,82 / **9.301** / **-5,6%** / 512 | +24.235 / 1,97 / 6.410 / -3,8% / 516 | -2,4%; **+45,1% (+2.891 EUR)**; 2,54 contro 3,78 (Medium meglio) |

- **PROP-ANNI:** F2 passa tutti i 5 anni. **F1 fallisce nel 2024** (DD equity 9.301 > 8.000 e un giorno realizzato a -5,6%, oltre il -5%). Nel 2022 F1 ha un giorno a -4,4% (sopra il 4,3% del Guardian).
- Le uscite senza SL ne' TP (filtro) sono piu' numerose con il Medium in tutti e 5 gli anni (2015: 61 contro 115; 2019: 54 contro 90; 2022: 60 contro 103; 2023: 56 contro 125; 2024: 66 contro 114), coerente con Low = solo M1 e Medium = M1+M15.

## Regola dei 9 anni insieme (scritta prima)
"Candidato" se: (a) netto F1 >= F2 in almeno N-1 anni; (b) netto/DD piu' alto in almeno 7 anni su 9; (c) nessun anno con DD di F1 peggiore di oltre 1.000 EUR; (d) PROP-ANNI come F2.
- (a) netto F1 >= F2 in **7 anni su 9** (Fase 1: 4/4; Fase 2: 3/5): **non basta** (servono 8 su 9).
- (b) netto/DD piu' alto in **5 anni su 9** (Fase 1: 2013, 2018; Fase 2: 2015, 2022, 2023): **non basta** (servono 7).
- (c) 2024: DD +2.891 EUR: **fallisce**.
- (d) 2024: F1 non passa PROP-ANNI: **fallisce**.
**Quindi F1 NON e' un candidato: NON DIMOSTRATO.** Media del rapporto netto F1/F2 sui 9 anni: circa 1,17 (+17%), ma con un DD che va da -7% a +45% e con un anno (2024) fuori dai filtri prop.

## Previsioni della Fase 2: giuste o sbagliate
- P1 F1 con netto > F2 in >= 4 anni su 5 (55%): **SBAGLIATA** (3 su 5).
- P2 F1 con DD equity > F2 in >= 4 anni su 5 (60%): **SBAGLIATA** (3 su 5: 2019, 2023, 2024).
- P3 F1 con netto/DD > F2 in >= 3 anni su 5 (40%): **GIUSTA** (3 su 5).
- P4 F1 con netto > +10% su F2 in >= 2 anni su 5 (45%): **GIUSTA** (3 su 5: +24%, +36%, +44%).
- P5 dati 2024 presenti (80%): **GIUSTA**.
- P6 F1 "candidato" sui 9 anni (15%): **non lo e'** (previsione di bassa probabilita' confermata).
- P7 nessun anno con DD equity > 8.000 per F1 o F2 (85%): **SBAGLIATA** (F1 2024: 9.301).

## Cosa NON dice (limiti)
- Un percorso per anno, OHLC a 1 minuto, nessuno slippage; non sappiamo se gli anni nuovi sono fuori dall'ottimizzazione del venditore.
- La differenza nel 2024 (DD +45%) puo' dipendere da un singolo episodio: non ho analizzato giorno per giorno (NON MISURATO).
- Nessuna modifica ai set live o al VPS. Se Claudio vuole un set "Low" come `_Ottimizzato` (magic diverso, in parallelo), lo decide lui: i dati non lo spingono.
