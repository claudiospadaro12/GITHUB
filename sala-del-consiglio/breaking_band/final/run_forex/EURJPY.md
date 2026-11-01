# Breaking Band su EURJPY — risultati (generato da run_test.py)

sha256 dei risultati (JSON canonico): `55f76afbafdbd276f08c961f1079dc183a362616eee2bdd2c348b245dcfad0e7`

## Intestazione: parametri, file letti, hash
- **parametri**
  - ATR_METODO: wilder
  - ATR_N: 14
  - B1_W: 2
  - B3_ATR: 1.5
  - B4_ER: 0.5
  - B5_ATR: 2
  - B6_BARRE: 20
  - BANDA_FINESTRA: 3
  - BANDA_TOL_ATR: 0.1
  - BB_K: 2
  - BB_N: 20
  - FILL_TARGET_MIGLIORE: False
  - I1_SOLO_RIENTRO: False
  - IMPULSIVA_ATR: 1.5
  - MAXHOLD: 1000
  - MAX_GAP_INGRESSO_MIN: 180
  - MIN_RETR: 3
  - PUNTO: 0.001
  - REF_BARRE: 15
  - RICALCOLO_ORE: 3
  - S50_N: 50
  - SD_DDOF: 0
  - SD_GATE_S50: True
  - SD_LAG: 3
  - SPREAD_MOLT: 1
  - STOP_ATR: 3
  - TF_ESPLORATIVO: 30
  - TF_PRIMARIO: 60
  - TOCCO_PEN_SPREAD: 0
  - T_MAX: 30
  - UNA_POSIZIONE_PER_VARIANTE: True
  - UN_SEGNALE_PER_EPISODIO: True
  - WARMUP: 200
  - WIN_IMPULSO: 20
- **disegno**
  - B1_D_MAX: 1.15
  - B1_D_MIN: 0.85
  - DIAGNOSTICA_QUASI_AUTOCOLPENTE: 0.9
  - EPS_R: 0.1
  - **FASCE_ORA**
    - [0, 7]
    - [8, 15]
    - [16, 23]
  - GARCH_ALPHA: 0.08
  - GARCH_BETA: 0.9
  - IC_ALPHA: 0.05
  - N_BOOTSTRAP: 10000
  - N_ESTRAZIONI: 2000
  - N_INCONCLUSIVO: 30
  - N_PIENO: 100
  - PF_MIN: 1.15
  - PLACEBO_BLOCCO: 1440
  - PLACEBO_MAX_ANNI: 300
  - PLACEBO_MIN_PER_ANNO: 350000
  - PLACEBO_N_MIN: 100
  - PLACEBO_PREZZO_PUNTI: 2e+05
  - PLACEBO_RIMESCOLAMENTI: 200
  - PLACEBO_SOTTOPASSI: 4
  - PLACEBO_SPREAD_PUNTI: 25
  - PLACEBO_TARGET_SEGNALI: 1500
  - PLACEBO_VOL_H_PUNTI: 150
  - PLACEBO_Z_MAX: 3
  - **PROB_CHECKLIST**
    - **Ottimo**
      - 65
      - 75
    - **Buono**
      - 55
      - 65
    - **Medio**
      - 45
      - 55
    - **Debole**
      - 0
      - 45
  - P_B1_MAX: 0.05
  - SEED: 20261101
  - SOLIDITA_ACCORPATA: 70
  - TOP_TRADE_ESCLUSI: 3
  - WILSON_Z90: 1.645
- **sensibilita**
  - **Sa**
    - SD_GATE_S50: False
  - **Sb**
    - IMPULSIVA_ATR_INV: 1
  - **Sc**
    - MAXHOLD: 150
  - **Sd**
    - SPREAD_MOLT: 1.5
  - **Se20**
    - T_MAX: 20
  - **Se50**
    - T_MAX: 50
  - **Sf**
    - TOCCO_PEN_SPREAD: 1
  - **Sg**
    - I1_SOLO_RIENTRO: True
- **tf**
  - H1
  - M30
- **sha256_csv**
  - 2013: 812e80e6e5d164a85267e00b4661ac2993960fb4d42fba23c704f44aecc799bd
  - 2018: 72b4419b041f520496dee9ea45fa5ca2f86bb3e12d5d5e986e51088134a11d42
  - 2020: 6401cf063a11f1261ea634682d65c38a314f681d9e95204471deeff8409a59e4
  - 2025-26: 4fa5815bcfa5359a97b942dbccf35bfb6c45f5ffca370a7451c70592f564bf90
- **righe_csv**
  - 2013: 368696
  - 2018: 371969
  - 2020: 373040
  - 2025-26: 645391
- simbolo: EURJPY
- punto: 0.001
- **righe_attese_A3**
  - 2013: -
  - 2018: -
  - 2020: -
  - 2025-26: -
- **righe_coincidono_con_A3**
  - 2013: -
  - 2018: -
  - 2020: -
  - 2025-26: -
- **sha256_codice**
  - engine.py: 932c4a5aeb1ba0ee180b6514953521b9a0e4e6bc3504b493c6e621b29672fd2f
  - signals.py: 9bd9264d75f304fa6ae55515a47f365f5c8ef4359cb9e7274e5efba6acec1319
  - params.py: 114de57657686a403c3b59156c892b7b55fb08726c1e66f0bc195b4b2e4d077f
  - run_test.py: f07c16202d2707620ed8be3bf6495d47e1ff8b8c89f15fff35ba139226edfbad
- **sha256_documenti_congelati**
  - specifica_v1.md: 4da8af64af86d216c592f5ba95166a3d72d072a7be09dc734915d09bdbb60a92
  - disegno_test_v1.md: 4cde9896e944c657d09165169a9f70cca04140830bbf8eaa61b545f555a0b022
  - criteri_previsioni_v1.md: 83750badbf0cbf488ef5f5579517d5cc719a8d4bbeddf7f3007e3d3e6a7730a8
- **hash_dati_coincidono**
  - ABTG_M1_EURJPY_2013.csv: True
  - ABTG_M1_EURJPY_2018.csv: True
  - ABTG_M1_EURJPY_2020.csv: True
  - ABTG_M1_EURJPY.csv: True
- python: 3.11.17
- numpy: 2.4.6
- PARAMETRI_NON_CONGELATI_PROVA: False
- parte_A: NON_VALUTATA
- baseline_su: H1 (primaria)
- sensibilita_eseguite_su: H1 pooled CONT+INV
- placebo_blocchi_rimescolamenti: 0
- convenzioni: prezzi BID, ask=bid+spread; stop 3 ATR da fill; target SMA20 ricalcolato ogni 3 ore; fill target AL LIVELLO, stop all'apertura se peggiore; stop prima del target; ingresso all'apertura della barra dopo; max gap 180 min; maxhold 1000; spread0->mediana periodo/ora

## VERDETTO (criteri_previsioni_v1.md, Parte B)
- esito: INCONCLUSIVO
- livello: -
- N: 13
- media_R: -0.04656
- pf_netto: 0.8122
- p_B1: 0.4548
- **ic90**
  - settimane: 12
  - media: -0.04656
  - ic90_lo: -0.283
  - ic90_hi: 0.1942
  - n_replicati: 10000
- eps_R: 0.1
- parte_A: NON_VALUTATA
- condizionale_a_parte_A: True
- **note**
- **n_configurazioni_esaminate**
  - primaria: 1
  - M30_sottoviste: 3
  - sensibilita: 8
  - nota: le esplorative non selezionano; clausole obbligatorie di criteri_previsioni_v1.md Parte C da riportare
- **clausole_Parte_C**
  - EURJPY: ambito dichiarato dalla Guida (MAJOR/MINOR, D1/H4/H1/M30) da verificare per il simbolo; M15 non ammesso e non testato
  - Guida usata = 'versione didattica' non confermata come Guida Operativa 11 ufficiale; mancano Dichiarazione di Test e screenshot
  - stop 3 ATR, target SMA20, ricalcolo 3 ore da Guida/Protocolli; soglie 'molto/ordinato' sono interpretazioni (specifica sez. 8); pattern testati = soprainsieme dei validi
  - dati del solo simbolo EURJPY; i 4 periodi sono 4 regimi; N per cella in T2
  - criteri non misurabili: news, giudizio visivo
  - trade a FINE_DATI, SL+TP stesso minuto, target oltre ingresso, spread=0: quantificati in T2/T9
  - configurazioni esaminate: vedi n_configurazioni_esaminate; le esplorative non selezionano
  - probabilita della Checklist non confermate/smentite per classi con campione < 30
  - parole vietate: 'la strategia funziona/non funziona', 'validata', 'pronta per EA'
  - non misurati: slippage, commissioni, swap, drawdown/regole prop, spread FTMO

## T1 Imbuto
### CONT_H1 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 49 | 84.48 | BAND_RIDING |
| C0_tocco_banda_opposta | 18 | 36.73 | - |
| C3_sequenza | 18 | 100 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 8 | 44.44 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 4 | 50 | - |
| sd<S50 | 4 | 100 | - |
| sd<=sd[-3] | 4 | 100 | - |
| SEGNALE | 4 | 100 | - |
Segnali e trade: {"eseguiti": 4, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 4}

Armati: {"+1": 30, "-1": 28}; fine episodi: {"BAND_RIDING": 41, "OPPOSTO": 4, "T_MAX": 13}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 8, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 4, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 48 | - | BAND_RIDING |
| finestra | 40 | 83.33 | BAND_RIDING |
| C0_tocco_banda_opposta | 19 | 47.5 | T_MAX |
| C3_sequenza | 17 | 89.47 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 2 | 11.76 | - |
| C1b_candela_test_non_impulsiva | 2 | 100 | - |
| sd<S50 | 2 | 100 | BAND_RIDING |
| sd<=sd[-3] | 1 | 50 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 23, "-1": 25}; fine episodi: {"BAND_RIDING": 33, "OPPOSTO": 1, "T_MAX": 14}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 11, "episodi_seq_violata_su_barra_di_tocco": 3, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 54 | - | BAND_RIDING |
| finestra | 44 | 81.48 | BAND_RIDING |
| C0_tocco_banda_opposta | 13 | 29.55 | OPPOSTO |
| C3_sequenza | 11 | 84.62 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 4 | 36.36 | T_MAX |
| C1b_candela_test_non_impulsiva | 3 | 75 | OPPOSTO |
| sd<S50 | 2 | 66.67 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 28, "-1": 26}; fine episodi: {"BAND_RIDING": 39, "OPPOSTO": 4, "T_MAX": 11}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 2, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 88 | - | BAND_RIDING |
| finestra | 72 | 81.82 | BAND_RIDING |
| C0_tocco_banda_opposta | 26 | 36.11 | T_MAX |
| C3_sequenza | 25 | 96.15 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 10 | 40 | T_MAX |
| C1b_candela_test_non_impulsiva | 5 | 50 | - |
| sd<S50 | 5 | 100 | - |
| sd<=sd[-3] | 5 | 100 | - |
| SEGNALE | 5 | 100 | - |
Segnali e trade: {"eseguiti": 5, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 5}

Armati: {"+1": 44, "-1": 44}; fine episodi: {"BAND_RIDING": 58, "OPPOSTO": 5, "T_MAX": 25}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 12, "episodi_seq_violata_su_barra_di_tocco": 2, "segnali_con_impulsiva_1.0_violata": 5, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 248 | - | BAND_RIDING |
| finestra | 205 | 82.66 | BAND_RIDING |
| C0_tocco_banda_opposta | 76 | 37.07 | T_MAX |
| C3_sequenza | 71 | 93.42 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 24 | 33.8 | T_MAX |
| C1b_candela_test_non_impulsiva | 14 | 58.33 | OPPOSTO |
| sd<S50 | 13 | 92.86 | BAND_RIDING |
| sd<=sd[-3] | 12 | 92.31 | - |
| SEGNALE | 12 | 100 | - |
Segnali e trade: {"eseguiti": 12, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 12}

Armati: {"+1": 125, "-1": 123}; fine episodi: {"BAND_RIDING": 171, "OPPOSTO": 14, "T_MAX": 63}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 33, "episodi_seq_violata_su_barra_di_tocco": 9, "segnali_con_impulsiva_1.0_violata": 12, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 49 | 84.48 | BAND_RIDING |
| I0_mediana_toccata | 27 | 55.1 | T_MAX |
| I1_banda_opposta_mai_toccata | 9 | 33.33 | BAND_RIDING |
| retest_banda_impulso | 1 | 11.11 | - |
| I2_nessuna_impulsiva | 1 | 100 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 30, "-1": 28}; fine episodi: {"BAND_RIDING": 41, "OPPOSTO": 4, "T_MAX": 13}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 48 | - | BAND_RIDING |
| finestra | 40 | 83.33 | BAND_RIDING |
| I0_mediana_toccata | 29 | 72.5 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 17 | 58.62 | T_MAX |
| retest_banda_impulso | 2 | 11.76 | BAND_RIDING |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 2, "a": 0}]

Armati: {"+1": 23, "-1": 25}; fine episodi: {"BAND_RIDING": 33, "OPPOSTO": 1, "T_MAX": 14}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 54 | - | BAND_RIDING |
| finestra | 44 | 81.48 | BAND_RIDING |
| I0_mediana_toccata | 26 | 59.09 | T_MAX |
| I1_banda_opposta_mai_toccata | 13 | 50 | BAND_RIDING |
| retest_banda_impulso | 6 | 46.15 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 16.67 | - |
| I3_banda_piatta | 1 | 100 | OPPOSTO |
| sd<S50 | 0 | 0 | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "sd<S50", "da": 1, "a": 0}]

Armati: {"+1": 28, "-1": 26}; fine episodi: {"BAND_RIDING": 39, "OPPOSTO": 4, "T_MAX": 11}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 88 | - | BAND_RIDING |
| finestra | 72 | 81.82 | BAND_RIDING |
| I0_mediana_toccata | 50 | 69.44 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 12 | 24 | T_MAX |
| retest_banda_impulso | 4 | 33.33 | T_MAX |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 4, "a": 0}]

Armati: {"+1": 44, "-1": 44}; fine episodi: {"BAND_RIDING": 58, "OPPOSTO": 5, "T_MAX": 25}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 248 | - | BAND_RIDING |
| finestra | 205 | 82.66 | BAND_RIDING |
| I0_mediana_toccata | 132 | 64.39 | T_MAX |
| I1_banda_opposta_mai_toccata | 51 | 38.64 | T_MAX |
| retest_banda_impulso | 13 | 25.49 | T_MAX |
| I2_nessuna_impulsiva | 2 | 15.38 | - |
| I3_banda_piatta | 2 | 100 | OPPOSTO |
| sd<S50 | 1 | 50 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 125, "-1": 123}; fine episodi: {"BAND_RIDING": 171, "OPPOSTO": 14, "T_MAX": 63}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 125 | - | BAND_RIDING |
| finestra | 115 | 92 | BAND_RIDING |
| C0_tocco_banda_opposta | 45 | 39.13 | T_MAX |
| C3_sequenza | 41 | 91.11 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 15 | 36.59 | T_MAX |
| C1b_candela_test_non_impulsiva | 10 | 66.67 | - |
| sd<S50 | 10 | 100 | - |
| sd<=sd[-3] | 10 | 100 | - |
| SEGNALE | 10 | 100 | - |
Segnali e trade: {"eseguiti": 10, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 10}

Armati: {"+1": 74, "-1": 51}; fine episodi: {"BAND_RIDING": 75, "OPPOSTO": 7, "T_MAX": 43}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 18, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 10, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 123 | - | BAND_RIDING |
| finestra | 111 | 90.24 | BAND_RIDING |
| C0_tocco_banda_opposta | 46 | 41.44 | T_MAX |
| C3_sequenza | 42 | 91.3 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 16 | 38.1 | T_MAX |
| C1b_candela_test_non_impulsiva | 9 | 56.25 | - |
| sd<S50 | 9 | 100 | - |
| sd<=sd[-3] | 9 | 100 | - |
| SEGNALE | 9 | 100 | - |
Segnali e trade: {"eseguiti": 8, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 1, "segnali": 9}

Armati: {"+1": 49, "-1": 74}; fine episodi: {"BAND_RIDING": 70, "FINE_DATI": 1, "OPPOSTO": 7, "T_MAX": 45}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 21, "episodi_seq_violata_su_barra_di_tocco": 5, "segnali_con_impulsiva_1.0_violata": 7, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 119 | - | BAND_RIDING |
| finestra | 107 | 89.92 | BAND_RIDING |
| C0_tocco_banda_opposta | 42 | 39.25 | T_MAX |
| C3_sequenza | 37 | 88.1 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 14 | 37.84 | T_MAX |
| C1b_candela_test_non_impulsiva | 9 | 64.29 | T_MAX |
| sd<S50 | 7 | 77.78 | T_MAX |
| sd<=sd[-3] | 5 | 71.43 | - |
| SEGNALE | 5 | 100 | - |
Segnali e trade: {"eseguiti": 5, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 5}

Armati: {"+1": 58, "-1": 61}; fine episodi: {"BAND_RIDING": 73, "OPPOSTO": 5, "T_MAX": 41}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 12, "episodi_seq_violata_su_barra_di_tocco": 5, "segnali_con_impulsiva_1.0_violata": 4, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 206 | - | BAND_RIDING |
| finestra | 175 | 84.95 | BAND_RIDING |
| C0_tocco_banda_opposta | 74 | 42.29 | T_MAX |
| C3_sequenza | 64 | 86.49 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 25 | 39.06 | T_MAX |
| C1b_candela_test_non_impulsiva | 16 | 64 | OPPOSTO |
| sd<S50 | 15 | 93.75 | OPPOSTO |
| sd<=sd[-3] | 13 | 86.67 | - |
| SEGNALE | 13 | 100 | - |
Segnali e trade: {"eseguiti": 11, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 2, "segnali": 13}

Armati: {"+1": 99, "-1": 107}; fine episodi: {"BAND_RIDING": 122, "OPPOSTO": 9, "T_MAX": 75}; extra: {"episodi_consumati_tocco_precoce": 3, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 36, "episodi_seq_violata_su_barra_di_tocco": 14, "segnali_con_impulsiva_1.0_violata": 13, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 573 | - | BAND_RIDING |
| finestra | 508 | 88.66 | BAND_RIDING |
| C0_tocco_banda_opposta | 207 | 40.75 | T_MAX |
| C3_sequenza | 184 | 88.89 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 70 | 38.04 | T_MAX |
| C1b_candela_test_non_impulsiva | 44 | 62.86 | T_MAX |
| sd<S50 | 41 | 93.18 | T_MAX |
| sd<=sd[-3] | 37 | 90.24 | - |
| SEGNALE | 37 | 100 | - |
Segnali e trade: {"eseguiti": 34, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 3, "segnali": 37}

Armati: {"+1": 280, "-1": 293}; fine episodi: {"BAND_RIDING": 340, "FINE_DATI": 1, "OPPOSTO": 28, "T_MAX": 204}; extra: {"episodi_consumati_tocco_precoce": 3, "episodi_eliminati_solo_da_SEQ": 2, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 87, "episodi_seq_violata_su_barra_di_tocco": 28, "segnali_con_impulsiva_1.0_violata": 34, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 125 | - | BAND_RIDING |
| finestra | 115 | 92 | BAND_RIDING |
| I0_mediana_toccata | 79 | 68.7 | T_MAX |
| I1_banda_opposta_mai_toccata | 30 | 37.97 | T_MAX |
| retest_banda_impulso | 8 | 26.67 | T_MAX |
| I2_nessuna_impulsiva | 3 | 37.5 | - |
| I3_banda_piatta | 3 | 100 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 74, "-1": 51}; fine episodi: {"BAND_RIDING": 75, "OPPOSTO": 7, "T_MAX": 43}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 123 | - | BAND_RIDING |
| finestra | 111 | 90.24 | BAND_RIDING |
| I0_mediana_toccata | 77 | 69.37 | T_MAX |
| I1_banda_opposta_mai_toccata | 22 | 28.57 | T_MAX |
| retest_banda_impulso | 4 | 18.18 | T_MAX |
| I2_nessuna_impulsiva | 1 | 25 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 49, "-1": 74}; fine episodi: {"BAND_RIDING": 70, "FINE_DATI": 1, "OPPOSTO": 7, "T_MAX": 45}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 119 | - | BAND_RIDING |
| finestra | 107 | 89.92 | BAND_RIDING |
| I0_mediana_toccata | 77 | 71.96 | T_MAX |
| I1_banda_opposta_mai_toccata | 24 | 31.17 | T_MAX |
| retest_banda_impulso | 4 | 16.67 | T_MAX |
| I2_nessuna_impulsiva | 1 | 25 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 58, "-1": 61}; fine episodi: {"BAND_RIDING": 73, "OPPOSTO": 5, "T_MAX": 41}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 206 | - | BAND_RIDING |
| finestra | 175 | 84.95 | BAND_RIDING |
| I0_mediana_toccata | 130 | 74.29 | T_MAX |
| I1_banda_opposta_mai_toccata | 38 | 29.23 | T_MAX |
| retest_banda_impulso | 8 | 21.05 | T_MAX |
| I2_nessuna_impulsiva | 1 | 12.5 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 99, "-1": 107}; fine episodi: {"BAND_RIDING": 122, "OPPOSTO": 9, "T_MAX": 75}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 573 | - | BAND_RIDING |
| finestra | 508 | 88.66 | BAND_RIDING |
| I0_mediana_toccata | 363 | 71.46 | T_MAX |
| I1_banda_opposta_mai_toccata | 114 | 31.4 | T_MAX |
| retest_banda_impulso | 24 | 21.05 | T_MAX |
| I2_nessuna_impulsiva | 6 | 25 | - |
| I3_banda_piatta | 6 | 100 | - |
| sd<S50 | 6 | 100 | - |
| sd<=sd[-3] | 6 | 100 | - |
| SEGNALE | 6 | 100 | - |
Segnali e trade: {"eseguiti": 6, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 6}

Armati: {"+1": 280, "-1": 293}; fine episodi: {"BAND_RIDING": 340, "FINE_DATI": 1, "OPPOSTO": 28, "T_MAX": 204}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 6, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

## T2 Risultati per variante x TF x periodo
| cella | n | win_pct | pf_lordo | pf_netto | attesa_R | mediana_R | netto_R | dd_max_R | costo_spread_medio_R | D_medio_atr | pareggio_atteso_medio_pct | wr0_pct | durata_mediana_barre | durata_max_barre | quota_long |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CONT_H1_2013 | 4 | 100 | inf | inf | 0.2973 | 0.3459 | 1.189 | 0 | 0.008575 | 1.044 | 77.28 | 76.48 | 2.5 | 10 | 0.5 |
| CONT_H1_2018 | 1 | 100 | inf | inf | 0.4351 | 0.4351 | 0.4351 | 0 | 0.03115 | 1.599 | 67.27 | 65.24 | 4 | 4 | 0 |
| CONT_H1_2020 | 2 | 100 | inf | inf | 0.2215 | 0.2215 | 0.443 | 0 | 0.01675 | 0.7534 | 82.44 | 81.06 | 4.5 | 6 | 1 |
| CONT_H1_2025-26 | 5 | 40 | 0.1902 | 0.1835 | -0.4899 | -1 | -2.45 | 2.798 | 0.008388 | 1.281 | 71.35 | 70.75 | 7 | 20 | 0.8 |
| CONT_H1_TOTALE | 12 | 75 | 0.9188 | 0.8726 | -0.03186 | 0.2569 | -0.3823 | 2.798 | 0.01174 | 1.14 | 74.84 | 73.92 | 4 | 20 | 0.6667 |
| INV_H1_2013 | 1 | 0 | 0 | 0 | -0.223 | -0.223 | -0.223 | 0.223 | 0.00947 | 0.783 | 80.05 | 79.3 | 17 | 17 | 0 |
| INV_H1_2018 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2020 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2025-26 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_TOTALE | 1 | 0 | 0 | 0 | -0.223 | -0.223 | -0.223 | 0.223 | 0.00947 | 0.783 | 80.05 | 79.3 | 17 | 17 | 0 |
| POOLED_H1 | 13 | 69.23 | 0.8572 | 0.8122 | -0.04656 | 0.2024 | -0.6053 | 2.798 | 0.01157 | 1.113 | 75.24 | 74.33 | 4 | 20 | 0.6154 |
| CONT_M30_2013 | 10 | 80 | 1.79 | 1.638 | 0.07709 | 0.177 | 0.7709 | 1.208 | 0.01714 | 0.9506 | 78.65 | 77.14 | 3.5 | 24 | 0.5 |
| CONT_M30_2018 | 8 | 62.5 | 7.063 | 4.307 | 0.1187 | 0.09088 | 0.9497 | 0.1225 | 0.03359 | 0.9229 | 80.45 | 77.65 | 9 | 16 | 0.625 |
| CONT_M30_2020 | 5 | 60 | 0.4535 | 0.4161 | -0.2336 | 0.09582 | -1.168 | 2 | 0.0202 | 1.025 | 77.03 | 75.36 | 3 | 5 | 0.6 |
| CONT_M30_2025-26 | 11 | 63.64 | 0.9281 | 0.8414 | -0.02495 | 0.1364 | -0.2744 | 1.541 | 0.01408 | 1.11 | 74.98 | 73.99 | 5 | 19 | 0.3636 |
| CONT_M30_TOTALE | 34 | 67.65 | 1.195 | 1.053 | 0.008185 | 0.1555 | 0.2783 | 2.779 | 0.02047 | 1.007 | 77.65 | 75.98 | 5 | 24 | 0.5 |
| INV_M30_2013 | 3 | 66.67 | 0.5789 | 0.5372 | -0.1543 | 0.1044 | -0.4628 | 1 | 0.01686 | 0.7588 | 82.31 | 80.96 | 5 | 10 | 0.6667 |
| INV_M30_2018 | 1 | 0 | 0 | 0 | -1 | -1 | -1 | 1 | 0.04488 | 0.5771 | 87.63 | 83.87 | 4 | 4 | 1 |
| INV_M30_2020 | 1 | 100 | inf | inf | 0.1035 | 0.1035 | 0.1035 | 0 | 0.01934 | 0.5105 | 87.11 | 85.46 | 7 | 7 | 0 |
| INV_M30_2025-26 | 1 | 100 | inf | inf | 0.4508 | 0.4508 | 0.4508 | 0 | 0.00909 | 1.353 | 71.22 | 68.93 | 2 | 2 | 0 |
| INV_M30_TOTALE | 6 | 66.67 | 0.5943 | 0.5458 | -0.1514 | 0.1039 | -0.9085 | 1.463 | 0.02065 | 0.7861 | 82.15 | 80.19 | 4.5 | 10 | 0.5 |
| POOLED_M30 | 40 | 67.5 | 1.027 | 0.9128 | -0.01575 | 0.1438 | -0.6302 | 2.328 | 0.0205 | 0.9736 | 78.32 | 76.61 | 5 | 24 | 0.5 |

Uscite per motivo e altri conteggi:
- CONT_H1_2013: motivi {"TP": 4}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2018: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2020: motivi {"TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2025-26: motivi {"SL": 3, "TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_TOTALE: motivi {"SL": 3, "TP": 9}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2013: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2018: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2020: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2025-26: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_TOTALE: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- POOLED_H1: motivi {"SL": 3, "TP": 10}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2013: motivi {"SL": 1, "TP": 9}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2018: motivi {"TP": 8}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2020: motivi {"SL": 2, "TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2025-26: motivi {"SL": 1, "TP": 10}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_TOTALE: motivi {"SL": 4, "TP": 30}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2013: motivi {"SL": 1, "TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2018: motivi {"SL": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2020: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2025-26: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_TOTALE: motivi {"SL": 2, "TP": 4}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- POOLED_M30: motivi {"SL": 6, "TP": 34}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0

## T3 Fasce (stratificazione, descrittori)
- **pooled**
  - **fascia**
    - **Buono**
      - n: 4
      - vincite: 3
      - long: 1
    - **Medio**
      - n: 4
      - vincite: 2
      - long: 3
    - **Ottimo**
      - n: 5
      - vincite: 4
      - long: 4
  - **fascia_accorpata**
    - **<70**
      - n: 4
      - vincite: 2
      - long: 3
    - **>=70**
      - n: 9
      - vincite: 7
      - long: 5
  - **n_prev**
    - **0**
      - n: 8
      - vincite: 5
      - long: 6
    - **1**
      - n: 4
      - vincite: 3
      - long: 2
    - **>=2**
      - n: 1
      - vincite: 1
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 8
      - vincite: 5
      - long: 4
    - **si**
      - n: 5
      - vincite: 4
      - long: 4
  - **checklist_stretta**
    - **no**
      - n: 13
      - vincite: 9
      - long: 8
      - wr_pct: 69.23
      - media_R: -0.04656
      - wr0_pct: 74.33
      - nota: N<30: solo descrittivo
  - **lato**
    - **long**
      - n: 8
      - vincite: 5
      - long: 8
    - **short**
      - n: 5
      - vincite: 4
      - long: 0
  - **periodo**
    - **2013**
      - n: 5
      - vincite: 4
      - long: 2
    - **2018**
      - n: 1
      - vincite: 1
      - long: 0
    - **2020**
      - n: 2
      - vincite: 2
      - long: 2
    - **2025-26**
      - n: 5
      - vincite: 2
      - long: 4
  - **fascia_oraria_server**
    - **0-7**
      - n: 5
      - vincite: 3
      - long: 4
    - **16-23**
      - n: 2
      - vincite: 2
      - long: 1
    - **8-15**
      - n: 6
      - vincite: 4
      - long: 3
- **CONT**
  - **fascia**
    - **Buono**
      - n: 3
      - vincite: 3
      - long: 1
    - **Medio**
      - n: 4
      - vincite: 2
      - long: 3
    - **Ottimo**
      - n: 5
      - vincite: 4
      - long: 4
  - **fascia_accorpata**
    - **<70**
      - n: 4
      - vincite: 2
      - long: 3
    - **>=70**
      - n: 8
      - vincite: 7
      - long: 5
  - **n_prev**
    - **0**
      - n: 7
      - vincite: 5
      - long: 6
    - **1**
      - n: 4
      - vincite: 3
      - long: 2
    - **>=2**
      - n: 1
      - vincite: 1
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 7
      - vincite: 5
      - long: 4
    - **si**
      - n: 5
      - vincite: 4
      - long: 4
  - **checklist_stretta**
    - **no**
      - n: 12
      - vincite: 9
      - long: 8
      - wr_pct: 75
      - media_R: -0.03186
      - wr0_pct: 73.92
      - nota: N<30: solo descrittivo
  - **lato**
    - **long**
      - n: 8
      - vincite: 5
      - long: 8
    - **short**
      - n: 4
      - vincite: 4
      - long: 0
  - **periodo**
    - **2013**
      - n: 4
      - vincite: 4
      - long: 2
    - **2018**
      - n: 1
      - vincite: 1
      - long: 0
    - **2020**
      - n: 2
      - vincite: 2
      - long: 2
    - **2025-26**
      - n: 5
      - vincite: 2
      - long: 4
  - **fascia_oraria_server**
    - **0-7**
      - n: 4
      - vincite: 3
      - long: 4
    - **16-23**
      - n: 2
      - vincite: 2
      - long: 1
    - **8-15**
      - n: 6
      - vincite: 4
      - long: 3
- **INV**
  - **fascia**
    - **Buono**
      - n: 1
      - vincite: 0
      - long: 0
  - **fascia_accorpata**
    - **>=70**
      - n: 1
      - vincite: 0
      - long: 0
  - **n_prev**
    - **0**
      - n: 1
      - vincite: 0
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 1
      - vincite: 0
      - long: 0
  - **checklist_stretta**
    - **no**
      - n: 1
      - vincite: 0
      - long: 0
  - **lato**
    - **short**
      - n: 1
      - vincite: 0
      - long: 0
  - **periodo**
    - **2013**
      - n: 1
      - vincite: 0
      - long: 0
  - **fascia_oraria_server**
    - **0-7**
      - n: 1
      - vincite: 0
      - long: 0
- **prob_checklist_pct**
  - **Ottimo**
    - 65
    - 75
  - **Buono**
    - 55
    - 65
  - **Medio**
    - 45
    - 55
  - **Debole**
    - 0
    - 45

## T4 Linee di base (B1 primaria; B0, B2 esplorative)
- nota: H1, trade primari CONT+INV; B1 primaria (ipotesi nulla), B0 e B2 esplorative; estrazioni 2000, seed 20261101
- **B1**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 13
    - n_abbinati: 13
    - media_osservata_R: -0.04656
    - media_nulla: -0.07146
    - p5: -0.3322
    - p50: -0.06271
    - p95: 0.1691
    - percentile_osservato: 0.5455
    - p_B: 0.4548
    - pf_nullo_p50: 0.7351
    - pf_osservato: 0.8122
  - **variante_CONT**
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: -0.03186
    - media_nulla: -0.07578
    - p5: -0.3561
    - p50: -0.068
    - p95: 0.172
    - percentile_osservato: 0.588
    - p_B: 0.4123
    - pf_nullo_p50: 0.7267
    - pf_osservato: 0.8726
  - **variante_INV**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: -0.223
    - media_nulla: -0.01957
    - p5: -1
    - p50: 0.222
    - p95: 0.2931
    - percentile_osservato: 0.2045
    - p_B: 0.7956
    - pf_nullo_p50: -
    - pf_osservato: 0
  - **periodo_2013**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1932
    - media_nulla: -0.0642
    - p5: -0.5136
    - p50: -0.0445
    - p95: 0.2742
    - percentile_osservato: 0.8155
    - p_B: 0.1849
    - pf_nullo_p50: 0.7798
    - pf_osservato: 5.332
  - **periodo_2018**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.4351
    - media_nulla: 0.08329
    - p5: -1
    - p50: 0.2847
    - p95: 0.5416
    - percentile_osservato: 0.768
    - p_B: 0.2324
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.2215
    - media_nulla: 0.007079
    - p5: -0.4609
    - p50: 0.1569
    - p95: 0.2678
    - percentile_osservato: 0.716
    - p_B: 0.2844
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2025-26**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: -0.4899
    - media_nulla: -0.1411
    - p5: -0.5936
    - p50: -0.1442
    - p95: 0.3187
    - percentile_osservato: 0.1215
    - p_B: 0.8786
    - pf_nullo_p50: 0.5782
    - pf_osservato: 0.1835
  - **lato_long**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: -0.1897
    - media_nulla: -0.1046
    - p5: -0.4699
    - p50: -0.08066
    - p95: 0.2035
    - percentile_osservato: 0.343
    - p_B: 0.6572
    - pf_nullo_p50: 0.6998
    - pf_osservato: 0.4942
  - **lato_short**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1824
    - media_nulla: -0.0185
    - p5: -0.3766
    - p50: -0.01445
    - p95: 0.2784
    - percentile_osservato: 0.7695
    - p_B: 0.2309
    - pf_nullo_p50: 0.92
    - pf_osservato: 5.089
- **B0**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 13
    - n_abbinati: 13
    - media_osservata_R: -0.04656
    - media_nulla: -0.02228
    - p5: -0.2576
    - p50: -0.01329
    - p95: 0.1911
    - percentile_osservato: 0.4125
    - p_B: 0.5877
    - pf_nullo_p50: 0.927
    - pf_osservato: 0.8122
  - **variante_CONT**
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: -0.03186
    - media_nulla: -0.01986
    - p5: -0.2695
    - p50: -0.01374
    - p95: 0.2079
    - percentile_osservato: 0.4585
    - p_B: 0.5417
    - pf_nullo_p50: 0.9305
    - pf_osservato: 0.8726
  - **variante_INV**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: -0.223
    - media_nulla: -0.05134
    - p5: -1
    - p50: 0.1976
    - p95: 0.2916
    - percentile_osservato: 0.2075
    - p_B: 0.7926
    - pf_nullo_p50: -
    - pf_osservato: 0
  - **periodo_2013**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1932
    - media_nulla: -0.04976
    - p5: -0.4447
    - p50: -0.0373
    - p95: 0.2675
    - percentile_osservato: 0.8265
    - p_B: 0.1739
    - pf_nullo_p50: 0.8073
    - pf_osservato: 5.332
  - **periodo_2018**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.4351
    - media_nulla: 0.08921
    - p5: -1
    - p50: 0.2851
    - p95: 0.5578
    - percentile_osservato: 0.755
    - p_B: 0.2454
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.2215
    - media_nulla: -0.01602
    - p5: -0.4996
    - p50: 0.1211
    - p95: 0.2665
    - percentile_osservato: 0.7635
    - p_B: 0.2369
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2025-26**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: -0.4899
    - media_nulla: -0.01959
    - p5: -0.4842
    - p50: 0.006134
    - p95: 0.3215
    - percentile_osservato: 0.047
    - p_B: 0.953
    - pf_nullo_p50: 1.03
    - pf_osservato: 0.1835
  - **lato_long**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: -0.1897
    - media_nulla: -0.02646
    - p5: -0.3548
    - p50: -0.01646
    - p95: 0.2617
    - percentile_osservato: 0.2055
    - p_B: 0.7946
    - pf_nullo_p50: 0.927
    - pf_osservato: 0.4942
  - **lato_short**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1824
    - media_nulla: -0.01558
    - p5: -0.3785
    - p50: -0.01261
    - p95: 0.2704
    - percentile_osservato: 0.7825
    - p_B: 0.2179
    - pf_nullo_p50: 0.9344
    - pf_osservato: 5.089
- **B2**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 13
    - n_abbinati: 13
    - media_osservata_R: -0.04656
    - media_nulla: -0.02483
    - p5: -0.2552
    - p50: -0.01727
    - p95: 0.1816
    - percentile_osservato: 0.42
    - p_B: 0.5802
    - pf_nullo_p50: 0.9013
    - pf_osservato: 0.8122
  - **variante_CONT**
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: -0.03186
    - media_nulla: -0.03704
    - p5: -0.2858
    - p50: -0.02782
    - p95: 0.1852
    - percentile_osservato: 0.4905
    - p_B: 0.5097
    - pf_nullo_p50: 0.86
    - pf_osservato: 0.8726
  - **variante_INV**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: -0.223
    - media_nulla: 0.1217
    - p5: -0.2515
    - p50: 0.1818
    - p95: 0.2892
    - percentile_osservato: 0.058
    - p_B: 0.942
    - pf_nullo_p50: -
    - pf_osservato: 0
  - **periodo_2013**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1932
    - media_nulla: -0.04554
    - p5: -0.3873
    - p50: -0.03679
    - p95: 0.215
    - percentile_osservato: 0.91
    - p_B: 0.09045
    - pf_nullo_p50: 0.7731
    - pf_osservato: 5.332
  - **periodo_2018**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.4351
    - media_nulla: 0.04875
    - p5: -1
    - p50: 0.2431
    - p95: 0.5245
    - percentile_osservato: 0.794
    - p_B: 0.2064
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.2215
    - media_nulla: 0.06593
    - p5: -0.4545
    - p50: 0.1857
    - p95: 0.2587
    - percentile_osservato: 0.643
    - p_B: 0.3573
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2025-26**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: -0.4899
    - media_nulla: -0.05515
    - p5: -0.5123
    - p50: -0.01599
    - p95: 0.3421
    - percentile_osservato: 0.065
    - p_B: 0.935
    - pf_nullo_p50: 0.9256
    - pf_osservato: 0.1835
  - **lato_long**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: -0.1897
    - media_nulla: -0.0634
    - p5: -0.393
    - p50: -0.05732
    - p95: 0.24
    - percentile_osservato: 0.2545
    - p_B: 0.7456
    - pf_nullo_p50: 0.7614
    - pf_osservato: 0.4942
  - **lato_short**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1824
    - media_nulla: 0.03687
    - p5: -0.3047
    - p50: 0.07309
    - p95: 0.2615
    - percentile_osservato: 0.7775
    - p_B: 0.2229
    - pf_nullo_p50: 2.549
    - pf_osservato: 5.089
- **pool_barre_simulate**
  - **2013**
    - long: 2634
    - short: 3219
  - **2018**
    - long: 2770
    - short: 3088
  - **2020**
    - long: 2937
    - short: 2955
  - **2025-26**
    - long: 4584
    - short: 5808

## T5 Robustezza della primaria
- **bootstrap_settimane**
  - settimane: 12
  - media: -0.04656
  - ic90_lo: -0.283
  - ic90_hi: 0.1942
  - n_replicati: 10000
- **senza_i_migliori_3**
  - n: 10
  - media_R: -0.1892
  - pf_netto: 0.4128
- **con_tutti**
  - n: 13
  - media_R: -0.04656
  - pf_netto: 0.8122
- **leave_one_period_out**
  - **2013**
    - n: 8
    - media_R: -0.1964
    - pf_netto: 0.4762
  - **2018**
    - n: 12
    - media_R: -0.0867
    - pf_netto: 0.6772
  - **2020**
    - n: 11
    - media_R: -0.0953
    - pf_netto: 0.6747
  - **2025-26**
    - n: 8
    - media_R: 0.2305
    - pf_netto: 9.27
- **quota_profitto_per_periodo**
  - 2013: -
  - 2018: -
  - 2020: -
  - 2025-26: -
- **spread_x1.5**
  - n: 13
  - media_R: -0.04893
  - pf_netto: 0.8026
- **escluso_spread0**
  - n: 13
  - media_R: -0.04656
  - pf_netto: 0.8122

## T6 Sensibilita (riportate per intero, non selezionabili)
| sens | segnali | n | win_pct | pf_netto | attesa_R | netto_R | dd_max_R |
|---|---|---|---|---|---|---|---|
| Sa | 15 | 15 | 66.67 | 0.7141 | -0.0805 | -1.207 | 3.007 |
| Sb | 12 | 12 | 75 | 0.8726 | -0.03186 | -0.3823 | 2.798 |
| Sc | 13 | 13 | 69.23 | 0.8122 | -0.04656 | -0.6053 | 2.798 |
| Sd | 13 | 13 | 69.23 | 0.8026 | -0.04893 | -0.6361 | 2.798 |
| Se20 | 9 | 9 | 77.78 | 1.5 | 0.06798 | 0.6118 | 1 |
| Se50 | 12 | 12 | 66.67 | 0.6772 | -0.0867 | -1.04 | 2.798 |
| Sf | 13 | 13 | 69.23 | 0.8122 | -0.04656 | -0.6053 | 2.798 |
| Sg | 13 | 13 | 69.23 | 0.8122 | -0.04656 | -0.6053 | 2.798 |

## T7 Placebo
- **CONT_H1**
  - n: 748
  - anni_sintetici: 300
  - lordo_medio_R: -0.001566
  - z_lordo: -0.07783
  - netto_medio_R: -0.04222
  - costo_medio_R: 0.04065
  - esito: SUPERATO
- **INV_H1**
  - n: 90
  - anni_sintetici: 300
  - lordo_medio_R: 0.07302
  - z_lordo: 1.659
  - netto_medio_R: 0.03222
  - costo_medio_R: 0.0408
  - esito: NON_CONCLUSIVO_N<100
- **CONT_M30**
  - n: 1384
  - anni_sintetici: 300
  - lordo_medio_R: 0.0142
  - z_lordo: 0.9253
  - netto_medio_R: -0.04362
  - costo_medio_R: 0.05782
  - esito: SUPERATO
- **INV_M30**
  - n: 147
  - anni_sintetici: 300
  - lordo_medio_R: -0.0008937
  - z_lordo: -0.02038
  - netto_medio_R: -0.05996
  - costo_medio_R: 0.05906
  - esito: SUPERATO
- blocchi_esplorativo: non eseguito (opzionale, --placebo-blocchi N)

## T8 Deriva
- **2013**
  - buy_and_hold_in_ATR: 115.9
  - atr_mediana_prezzo: 0.2636
  - **long**
    - n: 2
    - media_R: 0.3459
  - **short**
    - n: 3
    - media_R: 0.09149
- **2018**
  - buy_and_hold_in_ATR: -50.34
  - atr_mediana_prezzo: 0.192
  - **long**
    - n: 0
    - media_R: -
  - **short**
    - n: 1
    - media_R: 0.4351
- **2020**
  - buy_and_hold_in_ATR: 26.71
  - atr_mediana_prezzo: 0.1618
  - **long**
    - n: 2
    - media_R: 0.2215
  - **short**
    - n: 0
    - media_R: -
- **2025-26**
  - buy_and_hold_in_ATR: 72.35
  - atr_mediana_prezzo: 0.2092
  - **long**
    - n: 4
    - media_R: -0.663
  - **short**
    - n: 1
    - media_R: 0.2024

## T9 Dati / esecuzione
- **spread0_sostituiti_per_periodo**
  - 2013: 0
  - 2018: 7
  - 2020: 2380
  - 2025-26: 19
- **righe_csv_scartate_o_incoerenti**
  - **2013**
    - righe_scartate_formato: 0
    - duplicati_rimossi: 0
    - salti_indietro_nel_tempo: 0
    - righe_ohlc_incoerenti: 0
  - **2018**
    - righe_scartate_formato: 0
    - duplicati_rimossi: 0
    - salti_indietro_nel_tempo: 0
    - righe_ohlc_incoerenti: 0
  - **2020**
    - righe_scartate_formato: 0
    - duplicati_rimossi: 0
    - salti_indietro_nel_tempo: 0
    - righe_ohlc_incoerenti: 0
  - **2025-26**
    - righe_scartate_formato: 0
    - duplicati_rimossi: 0
    - salti_indietro_nel_tempo: 0
    - righe_ohlc_incoerenti: 0
- **primaria_H1**
  - trade_spread0_ingresso: 0
  - trade_spread0_uscita: 0
  - gap_ingresso_max_min: 0
  - trade_con_gap_ingresso_gt_0: 0
  - trade_chiusi_fine_dati: 0
  - uscite_a_mercato_target_superato: 0
  - ricalcoli_target_totali: 23
  - eventi_sl_tp_stesso_minuto: 0
  - **segnali_scartati**
    - scartati_posizione_aperta: 0
    - scartati_target_oltre_ingresso: 0
    - scartati_indicatori_non_pronti: 0
    - scartati_no_barra_successiva: 0
    - scartati_gap_ingresso: 0
  - segnali_totali: 13
  - tocchi_penetrazione_lt_spread_sui_segnali: 0
  - coppie_CONT_INV_stesso_episodio: 0

## Log dei trade
Schedule completa dei target per ogni trade nel JSON (chiave tabelle.LOG_TRADE).
