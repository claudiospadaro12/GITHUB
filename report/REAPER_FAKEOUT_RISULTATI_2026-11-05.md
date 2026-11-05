# Gold Reaper: filtro Fake Breakout 0/1/2/3 — RISULTATI (05/11/2026)

Fonte: zip `ANNO80K_REAPER_FAKEOUT_20261105_1546` (16 passate, 16 report, tutte STATO OK, input `FakeOutFilter` confermati dal report). XAUUSD H1, Modello 1, 80.000 EUR, terminale BCM, set prop (MaxAllowedDD 9, limite giornaliero 4, OnlyUp false, Virtual_expiration true, Randomization 0). Criteri e previsioni: `REAPER_FAKEOUT_CRITERI_2026-11-05.md`. Dati: `REAPER_FAKEOUT_dati/fakeout_res.json`.

## Esito in una riga
**Nessuna configurazione e' "migliore del Medium" secondo la regola scritta prima.** Low (F1) da' piu' profitto in tutti e 4 gli anni, ma con piu' DD di equity (+6% / +13% / +16% / +30%); Off (F0) da' piu' profitto e molto piu' DD; High (F3) riduce il profitto. Il "doppio del profitto con DD quasi uguale" di dinocon9 NON si conferma.

## Tabella (netto EUR / PF / DD equity massima EUR / peggior giorno / operazioni)
| Anno | F0 Off | F1 Low | F2 Medium (rif.) | F3 High |
|---|---|---|---|---|
| 2013 | +27.092 / 1,74 / 7.120 / -4,4% / 491 | +29.394 / 1,86 / 5.975 / -4,5% / 500 | +22.289 / 1,64 / 5.633 / -4,6% / 506 | +20.477 / 1,60 / 5.598 / -4,3% / 511 |
| 2018 | +16.548 / 1,57 / 6.930 / -4,0% / 546 | +14.797 / 1,54 / 6.163 / -3,1% / 546 | +12.936 / 1,49 / 5.466 / -2,3% / 547 | +11.758 / 1,48 / 4.789 / -2,2% / 549 |
| 2020 | +23.317 / 1,84 / 4.566 / -2,1% / 459 | +22.574 / 1,91 / 4.452 / -2,1% / 459 | +20.465 / 1,87 / 3.841 / -2,2% / 460 | +15.688 / 1,68 / 3.720 / -2,1% / 460 |
| 2025 | +31.600 / 2,51 / 4.255 / -2,7% / 495 | +29.567 / 2,63 / 4.001 / -1,9% / 495 | +29.474 / 2,73 / 3.076 / -1,9% / 497 | +28.239 / 2,63 / 3.900 / -1,9% / 497 |

(F0 2018 netto 16.548 contro F1 14.797: l'Off e' il piu' alto in 2018, 2020, 2025; nel 2013 il piu' alto e' F1.)

## Confronti con il Medium (anno per anno)
- **F1 (Low) contro F2:** netto +31,9% / +14,4% / +10,3% / +0,3%; DD equity +343 EUR (+6%) / +697 (+13%) / +611 (+16%) / +924 (+30%). Netto/DD: F1 meglio nel 2013 (4,9 contro 4,0), pari nel 2018 (2,4 contro 2,4), peggio nel 2020 (5,1 contro 5,3) e nel 2025 (7,4 contro 9,6): **a parita' di DD il Low non e' superiore.**
- **F0 (Off) contro F2:** netto +21,6% / +27,9% / +13,9% / +7,2%; DD equity +26% / +27% / +19% / +38%.
- **F3 (High) contro F2:** netto -8,1% / -9,1% / -23,3% / -4,2%; DD equity -1% / -12% / -3% / +27%.
- Tutte le 16 passate passano PROP-ANNI (netto > 0, DD equity <= 8.000, nessuno stop out, nessun giorno <= -5%). Nel 2013 F0, F1 e F2 hanno un giorno a -4,4% / -4,5% / -4,6% (sopra il limite del 4,3% del Guardian).
- **Mappatura verificata sul report (indiretta):** le uscite senza SL ne' TP crescono con il livello (2013: 29 / 76 / 103 / 123; 2018: 7 / 56 / 84 / 140; 2020: 10 / 54 / 85 / 119; 2025: 2 / 53 / 85 / 101): coerente con 0 = Off, 1 = Low, 2 = Medium, 3 = High (e con Wim: Low = M1, Medium = M1+M15, High = M1+M15+H1).

## Applicazione della regola scritta prima
"Migliore del Medium" = netto >= F2 in >= 3 anni su 4 **e** DD equity non peggiore di oltre il 10% (o 500 EUR) in nessun anno **e** PROP-ANNI come F2. **F1 passa il netto (4/4) ma NON la DD** (peggiora di oltre 500 EUR o 10% in 3 anni su 4). **F0 non passa la DD in nessun anno. F3 non passa il netto.** Quindi: **NON DIMOSTRATO per tutti.** La Fase 2 (2015, 2019, 2022, 2024) non scatta secondo i criteri; se Claudio la vuole lo stesso, e' una scelta sua con criteri nuovi scritti prima.

## Previsioni: giuste o sbagliate
- R1 F2 rifatto entro +-3% dei vecchi netti in tutti e 4 gli anni (85%): **SBAGLIATA** (+2,4% / -4,4% / +0,4% / -3,2%); le DD invece coincidono (5.633/5.621, 5.466/5.504, 3.841/3.839, 3.076/3.077). Il motore e' riproducibile sulle DD, meno sul netto nel 2018 e 2025.
- R2 F1 diverso da F2 di oltre +-10% in >= 3 anni su 4 (70%): **GIUSTA** (3 su 4, nel 2020 per poco: +10,3%).
- R3 F1 con netto > F2 in >= 3 anni su 4 (45%): **GIUSTA** (4 su 4).
- R4 F1 con DD equity > F2 in >= 3 anni su 4 (70%): **GIUSTA** (4 su 4).
- R5 "doppio del profitto" (F1 >= 1,8 x F2) in almeno un anno (15%): **SBAGLIATA** (massimo 1,32 x).
- R6 F0 peggiore di F2 per DD in >= 3 anni su 4 (75%): **GIUSTA** (4 su 4).
- R7 F3 con DD equity <= F2 in >= 3 anni su 4 e netto piu' basso in >= 3 anni su 4 (55%): **GIUSTA** (DD in EUR: 5.598 contro 5.633, 4.789 contro 5.466, 3.720 contro 3.841, quindi <= F2 in 3 anni; nel 2025 3.900 contro 3.076; netto piu' basso in 4 anni su 4).
- R8 Nessuna configurazione "migliore del Medium" (60%): **GIUSTA**.
- R9 Tutte le 16 passate valide (80%): **GIUSTA**.
- R10 Operazioni monotone con il livello: riportato, il numero di operazioni cresce di poco con il livello (491 -> 511 nel 2013).

## Limiti (da non dimenticare)
- Un solo percorso per anno; OHLC a 1 minuto; nessuno slippage; 2013/2018/2020 probabilmente in-sample del venditore.
- Il filtro news e `AutoGMT` non verificati nel tester (nelle note del giornale c'e' l'offset GMT del broker impostato; non verificato rispetto al BCM GMT+1 fisso).
- I numeri sono "a quel lotto" (set prop 9% DD); nessun giudizio su acquisto, lotto o taglia.
- F0, F1, F3 non sono in uso: nessuna modifica ai set live o al VPS.
