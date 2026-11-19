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
