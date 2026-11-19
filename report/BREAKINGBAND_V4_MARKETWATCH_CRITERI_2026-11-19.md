# BreakingBand_MT5_v4 su tutti i simboli del Market Watch (baseline, parametri di default): criteri scritti PRIMA dei numeri (19/11/2026)
Estende la Fase 0 del piano (`BREAKINGBAND_V4_AUDIT_E_PIANO_2026-11-19.md`) da EURUSD a **tutti i simboli selezionati nel Market Watch** del terminale portabile BCM (modalita' del tester "tutti i simboli", `Optimization=3`), H1, Modello 1 (barre da 1 minuto), deposito 10.000 EUR, rischio 0,5%, **parametri = default del file, nessuna ottimizzazione**. Finestre: **IS 2013-2020** (selezione) e **OOS 2021-2024** (giudizio); 2025-2026 intatto. Riga: `RIGA_BB_V4_MARKETWATCH.txt`; per ogni finestra il tester produce una tabella con un passaggio per simbolo (da esportare in XML: lo script raccoglie i file; se non ci sono, esportazione manuale dalla scheda Ottimizzazione).
**Attenzione ai confronti multipli:** N simboli = N tentativi; correlati tra loro (cross forex). Un simbolo "buono" va letto sul fuori campione, non sul dentro campione.
## Porte (scritte ora)
- **Simbolo selezionato in IS:** >= 30 operazioni, PF >= 1,3, DD <= 15%.
- **Simbolo VALIDATO:** selezionato in IS e in OOS >= 15 operazioni, PF > 1,2, profitto > 0.
- **Portafoglio:** somma delle operazioni dei simboli validati in OOS: PF > 1,2 e >= 50 operazioni. Con N simboli ci si attende per solo caso circa il 5-10% di simboli "selezionati": se i validati sono <= 3 su N >= 20, e' compatibile col caso.
- Il numero di operazioni per simbolo e' la prima misura: **se il mediano dei simboli e' < 20 operazioni IS, il campione non basta per nessun verdetto.**
## Previsioni
- Mediana delle operazioni per simbolo in IS (2013-2020, 8 anni) < 30: **85%** (EURUSD fa 2-3 operazioni l'anno con questi filtri).
- Simboli selezionati in IS (n >= 30, PF >= 1,3, DD <= 15%): **0 o 1: 75%**.
- Validati in OOS: **0: 85%**; 1-2: 13%; 3 o piu': 2%.
- PF mediano dei simboli con >= 15 operazioni in OOS < 1,1: **70%**.
## Limiti
Il Market Watch del terminale portabile puo' contenere pochi simboli o simboli senza storico (0 operazioni): si dichiara il numero effettivo. Se l'esportazione in XML non si genera da sola serve l'esportazione manuale. Soglia di 30 operazioni IS = limite di Claudio (150 non raggiungibile con questo codice).

## RISULTATI (zip `BB_V4_MARKETWATCH_20261119_1420`: XML dei 2 passaggi con `Optimization=3`, file in `BREAKINGBAND_V4_MARKETWATCH_dati/`; default del file, H1, Modello 1, 10.000 EUR, rischio 0,5%)
Il tester ha provato **22 simboli** del Market Watch (17 con operazioni in ciascuna finestra: gli indici D30EUR/E35EUR/E50EUR/F40EUR non hanno storico 2013-2020, AUDNZD e altri 0 operazioni).
| Simbolo | IS 2013-2020: n / PF / profitto EUR | OOS 2021-2024: n / PF / profitto EUR |
|---|---|---|
| EURCAD | 15 / 80,7 / +359 | 3 / 0,75 / -13 |
| EURCHF | 14 / 3,05 / +218 | 7 / 0,64 / -56 |
| EURUSD | 17 / 2,56 / +230 | 3 / 0,70 / -17 |
| USDCAD | 8 / 3,59 / +133 | 2 / 59 / +49 |
| AUDUSD | 21 / 1,64 / +159 | 1 / 189 / +30 |
| EURJPY | 14 / 1,30 / +60 | 5 / 0,71 / -25 |
| EURAUD | 21 / 1,23 / +69 | 11 / 0,78 / -33 |
| EURGBP | 20 / 0,95 / -16 | 8 / 1,84 / +85 |
| EURNZD, GBPUSD, XAUUSD | 26 / 1,01; 13 / 1,08; 14 / 1,00 | 9 / 0,93; 1 / 0; 0 |
| USDJPY, USDCHF | 17 / 0,89; 10 / 0,55 | 2 / 200; 0 |
| CADJPY, NZDJPY, EURPLN, EURSEK | PF 0,14-0,63 (n 8-19), perdite -64..-491 | 0 operazioni |
**Totale:** 264 operazioni IS, profitto netto **+141 EUR** su 10.000 in 8 anni (circa +0,5 EUR a operazione, circa +0,01 R con rischio 50 EUR); OOS 53 operazioni, **+38 EUR** (circa +0,01 R). **Mediana operazioni per simbolo: 15 in IS, 2 in OOS.**
- **Nessun simbolo supera la porta di selezione IS** (>= 30 operazioni): il massimo e' 26 (EURNZD, PF 1,01). Nessun simbolo validato. Quindi **non si procede alla passata di ottimizzazione** (regola di arresto scritta: sotto soglia di operazioni non si ottimizza).
- **Lettura esplorativa (ignorando il minimo di 30 operazioni):** i simboli con PF IS >= 1,3 (EURCAD, EURCHF, EURUSD, USDCAD, AUDUSD, EURJPY) hanno in OOS 21 operazioni totali e **-32 EUR**: la selezione sul dentro campione non si trasferisce. I PF OOS di 59, 189, 200 hanno 1-2 operazioni: rumore.
- **EURUSD** (il simbolo del riepilogo di Massimo) ripete il suo risultato dentro campione (17 operazioni, PF 2,56) e perde fuori campione (3 operazioni, PF 0,70).
- Previsioni: mediana operazioni IS < 30 (85%) -> si' (15); simboli selezionati 0 o 1 (75%) -> si' (0); validati 0 (85%) -> si'; PF mediano dei simboli con >= 15 operazioni OOS < 1,1 (70%) -> non valutabile (nessun simbolo ha 15 operazioni in OOS).
**Verdetto: il BreakingBand v4 con parametri di default NON e' validato come EA su nessun simbolo; moltiplicare i mercati non crea un reddito (33 operazioni all'anno in tutto, a circa +0,01 R).** Il PF 1,69 su 30 operazioni era un campione troppo piccolo.
