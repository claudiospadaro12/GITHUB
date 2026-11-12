# UBS U2: lotto calcolato dal rischio (Risk=123, MaxRiskPerStrategy=2) con DD dichiarato (A) e DD misurato (B) — RISULTATI (12/11/2026)

**Natura: MISURA dal tester** (BCM, Modello 1, XAUUSD, 2013-01-01 -> 2025-12-31, deposito 100.000 EUR, qualita 98%). Criteri e previsioni fissati prima dei numeri in `UBS_U2_CRITERI_2026-11-11.md`. Script `D160_dati/analisi_ubs_u2.py`, dati `D160_dati/ubsu2.json`. Solo tester; reale, trial e VPS non toccati; nessun giudizio su lotti, taglie, acquisti.

## Validita
18 passate su 18 valide: report presente, deposito 100.000 in tutte, qualita 98%, nessuno stop out / no money, `Risk=123` e `MaxRiskPerStrategy_Value=2.0` confermati dal report, `HistoricalMaxDD` = dichiarato nel braccio A e = DD BCM misurato a 0,01 lotti x 1,15 nel braccio B (verificato su tutti e 9), **tutti gli altri input uguali al set** (nessuna differenza), lotti diversi da 0,1.

## Tabella (DD equity in % del deposito iniziale)
| Set | R (U1b) | Dich. | DD% **A** (dich.) | classe A | DD% **B** (misurato) | classe B | lotto medio A / B | netto A / B |
|---|---|---|---|---|---|---|---|---|
| Phantom strat8 | 0,28 | 720 | 0,73 | LONTANO | **2,39** | PRECISO | 0,08 / 0,27 | 5.035 / 17.579 |
| Phantom strat3 | 0,52 | 99 | 1,46 | FUORI | 2,63 | FUORI | 0,16 / 0,28 | 18.263 / 32.368 |
| Goldbot dailyC | 0,62 | 27 | **1,82** | PRECISO | 2,59 | FUORI | 0,67 / 0,98 | 18.292 / 26.688 |
| Gold Trade Pro E | 1,03 | 40 | 3,41 | LONTANO | 2,71 | FUORI | 1,14 / 0,93 | 47.156 / 38.297 |
| Phantom Gold_c | 1,04 | 50 | 3,23 | LONTANO | 2,63 | FUORI | 0,35 / 0,28 | 40.267 / 32.368 |
| Goldbot dailyI | 1,05 | 83 | 2,77 | FUORI | **2,24** | PRECISO | 0,27 / 0,22 | 21.376 / 17.434 |
| Gold Trade Pro a | 2,19 | 60 | 6,83 | LONTANO | **2,22** | PRECISO | 0,80 / 0,27 | 83.956 / 26.960 |
| Reaper s5 H1 | 1,37 | 110 | 3,26 | LONTANO | **2,00** | PRECISO | 0,38 / 0,23 | 32.647 / 19.623 |
| Reaper s1 D1 | 4,00 | 60 | 10,03 | LONTANO | **2,07** | PRECISO | 0,53 / 0,10 | 20.815 / 3.937 |
Classi (regola fissata): PRECISO 1,5-2,5%; LONTANO oltre 3,0 o sotto 1,0; FUORI altrimenti.
Conteggi: **A** PRECISO 1, LONTANO 6. **B** PRECISO 5, LONTANO 0; DD% di B fra **2,00 e 2,71** (media 2,39). B e piu vicino a 2% di A in **7 set su 9**.
Phantom strat3 e Gold_c nel braccio B sono la stessa strategia (stessi 634 trade, stesso DD misurato): non sono due prove indipendenti.

## Verdetti (regole fissate prima)
- **Verdetto del metodo: VALE CON LIMITI** (B PRECISO in 5 set su 9, nessun LONTANO).
- **Verdetto DD misurato vs dichiarato: MISURATO MEGLIO** (7 set su 9).

## Previsioni
| | Previsione | Esito |
|---|---|---|
| U2-1 | 16 passate su 18 valide (80%) | **18/18 valide: confermata** |
| U2-2 | A: DD% entro 25% da 2xR in >= 6 set su 9 (55%) | **FALSA**: 1 set su 9 (Reaper s5, +19%); in tutti i 9 il DD% reale e **sopra** 2xR di 1,19-1,65 volte (mediana 1,39) |
| U2-3 | B PRECISO in >= 5 set (45%) | **confermata** (5, appena) |
| U2-4 | B piu vicino a 2% in >= 7 set (70%) | **confermata** (7) |
| U2-5 | almeno un set con DD% > 3,0 in B (50%) | **FALSA** (massimo 2,71) |
| U2-6 | Reaper s1 D1: DD% > 5% in A (70%) | **confermata** (10,03) |
| U2-7 | VALE 15% / VALE CON LIMITI 40% / NON VALE 45% | **VALE CON LIMITI** (il 40%) |
| U2-8 | lotti B entro 2x di A solo per R vicino a 1 (80%) | **FALSA**: entro 2x anche per Goldbot dailyC (1,45), Phantom strat3 (1,76), Reaper s5 (0,61), oltre a GTP E, Gold_c e dailyI (0,81-0,82) |

## Letture
1. Con il DD dichiarato (A) il DD% reale va da 0,73 a 10,03: il lotto calcolato dal numero di Wim NON porta al 2%. Con il DD misurato su BCM (B) tutti i 9 set stanno fra 2,00 e 2,71.
2. Il DD% e SEMPRE sopra il 2% nominale in B (media 2,39, +20%) e sopra 2xR in A (mediana x1,39). Ipotesi (NON verificata): il lotto cresce col saldo (compounding), quindi il DD in % del deposito iniziale supera quello calcolato a lotto fisso.
3. **Limite importante**: nel braccio B il DD misurato e preso sullo STESSO periodo 2013-2025 del test: la precisione e in parte circolare (in-sample). Non dimostra che il metodo preveda il DD fuori periodo.
4. Lotti molto diversi fra A e B (da 0,2x a 3,4x): su Reaper s1 D1 (R 4,00) il lotto di B e 1/5 di quello di A e il netto crolla (3.937 contro 20.815), a parita di DD% ~2.
5. Limite di granularita: Phantom strat8 in A ha lotti 0,03-0,12 (arrotondamento a 0,01) e DD 0,73%.

## Limiti
Un percorso per set (Randomization 0); cambio EUR/USD 1,15 ipotesi; solo 2013-2025; Modello 1 (barre, non tick); DD% in % del deposito iniziale (il lotto segue il saldo); non si prova il Max Daily Drawdown dell'EA ne il Guardian; nessuna conclusione su lotti/taglie per i conti.
