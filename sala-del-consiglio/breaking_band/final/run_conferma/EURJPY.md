# Breaking Band su EURJPY — risultati (generato da run_test.py)

sha256 dei risultati (JSON canonico): `2fab0e366521fc6dcd7e1326e6e63038a3c0c806e259f242254d6c72ba0f5c41`

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
  - 2015: 38b0ce7b82f8865bfe23c0830322b49d779eb00702efcb8e990f1224d2e2e0f2
  - 2017: b337bc3b4b9b545c71bc8296d8fb6584cedc893f9940b758123d2960727bed0c
  - 2019: 09e4868e6f7ed59402bdc438220723f73e1ef2db66ec6ea8535f12728ad9d224
  - 2022: 88e18b85d6984850fac8efc60bedd0fdb4c1192c7178c17beb46fb0c8222f398
- **righe_csv**
  - 2015: 370894
  - 2017: 370603
  - 2019: 371490
  - 2022: 373005
- simbolo: EURJPY
- punto: 0.001
- **righe_attese_A3**
  - 2015: -
  - 2017: -
  - 2019: -
  - 2022: -
- **righe_coincidono_con_A3**
  - 2015: -
  - 2017: -
  - 2019: -
  - 2022: -
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
  - ABTG_M1_EURJPY_2015.csv: True
  - ABTG_M1_EURJPY_2017.csv: True
  - ABTG_M1_EURJPY_2019.csv: True
  - ABTG_M1_EURJPY_2022.csv: True
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
- N: 17
- media_R: 0.117
- pf_netto: 2.635
- p_B1: 0.09445
- **ic90**
  - settimane: 17
  - media: 0.117
  - ic90_lo: -0.02602
  - ic90_hi: 0.2367
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
### CONT_H1 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 49 | - | BAND_RIDING |
| finestra | 44 | 89.8 | BAND_RIDING |
| C0_tocco_banda_opposta | 21 | 47.73 | T_MAX |
| C3_sequenza | 18 | 85.71 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 8 | 44.44 | T_MAX |
| C1b_candela_test_non_impulsiva | 5 | 62.5 | - |
| sd<S50 | 5 | 100 | T_MAX |
| sd<=sd[-3] | 4 | 80 | - |
| SEGNALE | 4 | 100 | - |
Segnali e trade: {"eseguiti": 4, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 4}

Armati: {"+1": 19, "-1": 30}; fine episodi: {"BAND_RIDING": 27, "FINE_DATI": 1, "OPPOSTO": 3, "T_MAX": 18}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 7, "episodi_seq_violata_su_barra_di_tocco": 3, "segnali_con_impulsiva_1.0_violata": 4, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 50 | 86.21 | BAND_RIDING |
| C0_tocco_banda_opposta | 21 | 42 | BAND_RIDING |
| C3_sequenza | 20 | 95.24 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 8 | 40 | T_MAX |
| C1b_candela_test_non_impulsiva | 4 | 50 | - |
| sd<S50 | 4 | 100 | - |
| sd<=sd[-3] | 4 | 100 | - |
| SEGNALE | 4 | 100 | - |
Segnali e trade: {"eseguiti": 4, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 4}

Armati: {"+1": 24, "-1": 34}; fine episodi: {"BAND_RIDING": 39, "FINE_DATI": 1, "OPPOSTO": 3, "T_MAX": 15}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 8, "episodi_seq_violata_su_barra_di_tocco": 2, "segnali_con_impulsiva_1.0_violata": 4, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 61 | - | BAND_RIDING |
| finestra | 53 | 86.89 | BAND_RIDING |
| C0_tocco_banda_opposta | 28 | 52.83 | BAND_RIDING |
| C3_sequenza | 27 | 96.43 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 8 | 29.63 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 6 | 75 | - |
| sd<S50 | 6 | 100 | T_MAX |
| sd<=sd[-3] | 5 | 83.33 | - |
| SEGNALE | 5 | 100 | - |
Segnali e trade: {"eseguiti": 5, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 5}

Armati: {"+1": 29, "-1": 32}; fine episodi: {"BAND_RIDING": 36, "OPPOSTO": 3, "T_MAX": 22}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 12, "episodi_seq_violata_su_barra_di_tocco": 2, "segnali_con_impulsiva_1.0_violata": 5, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 53 | 91.38 | BAND_RIDING |
| C0_tocco_banda_opposta | 19 | 35.85 | T_MAX |
| C3_sequenza | 18 | 94.74 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 5 | 27.78 | T_MAX |
| C1b_candela_test_non_impulsiva | 2 | 40 | - |
| sd<S50 | 2 | 100 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 32, "-1": 26}; fine episodi: {"BAND_RIDING": 39, "OPPOSTO": 3, "T_MAX": 16}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 5, "episodi_seq_violata_su_barra_di_tocco": 3, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 226 | - | BAND_RIDING |
| finestra | 200 | 88.5 | BAND_RIDING |
| C0_tocco_banda_opposta | 89 | 44.5 | BAND_RIDING |
| C3_sequenza | 83 | 93.26 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 29 | 34.94 | T_MAX |
| C1b_candela_test_non_impulsiva | 17 | 58.62 | - |
| sd<S50 | 17 | 100 | T_MAX |
| sd<=sd[-3] | 15 | 88.24 | - |
| SEGNALE | 15 | 100 | - |
Segnali e trade: {"eseguiti": 15, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 15}

Armati: {"+1": 104, "-1": 122}; fine episodi: {"BAND_RIDING": 141, "FINE_DATI": 2, "OPPOSTO": 12, "T_MAX": 71}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 32, "episodi_seq_violata_su_barra_di_tocco": 10, "segnali_con_impulsiva_1.0_violata": 15, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 49 | - | BAND_RIDING |
| finestra | 44 | 89.8 | BAND_RIDING |
| I0_mediana_toccata | 34 | 77.27 | T_MAX |
| I1_banda_opposta_mai_toccata | 15 | 44.12 | BAND_RIDING |
| retest_banda_impulso | 3 | 20 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 33.33 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 19, "-1": 30}; fine episodi: {"BAND_RIDING": 27, "FINE_DATI": 1, "OPPOSTO": 3, "T_MAX": 18}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 50 | 86.21 | BAND_RIDING |
| I0_mediana_toccata | 31 | 62 | T_MAX |
| I1_banda_opposta_mai_toccata | 9 | 29.03 | T_MAX |
| retest_banda_impulso | 2 | 22.22 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 50 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 24, "-1": 34}; fine episodi: {"BAND_RIDING": 39, "FINE_DATI": 1, "OPPOSTO": 3, "T_MAX": 15}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 61 | - | BAND_RIDING |
| finestra | 53 | 86.89 | BAND_RIDING |
| I0_mediana_toccata | 36 | 67.92 | T_MAX |
| I1_banda_opposta_mai_toccata | 10 | 27.78 | T_MAX |
| retest_banda_impulso | 1 | 10 | - |
| I2_nessuna_impulsiva | 1 | 100 | - |
| I3_banda_piatta | 1 | 100 | BAND_RIDING |
| sd<S50 | 0 | 0 | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "sd<S50", "da": 1, "a": 0}]

Armati: {"+1": 29, "-1": 32}; fine episodi: {"BAND_RIDING": 36, "OPPOSTO": 3, "T_MAX": 22}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 53 | 91.38 | BAND_RIDING |
| I0_mediana_toccata | 35 | 66.04 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 16 | 45.71 | BAND_RIDING |
| retest_banda_impulso | 1 | 6.25 | T_MAX |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "retest_banda_impulso", "da": 16, "a": 1}, {"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 1, "a": 0}]

Armati: {"+1": 32, "-1": 26}; fine episodi: {"BAND_RIDING": 39, "OPPOSTO": 3, "T_MAX": 16}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 226 | - | BAND_RIDING |
| finestra | 200 | 88.5 | BAND_RIDING |
| I0_mediana_toccata | 136 | 68 | T_MAX |
| I1_banda_opposta_mai_toccata | 50 | 36.76 | T_MAX |
| retest_banda_impulso | 7 | 14 | BAND_RIDING |
| I2_nessuna_impulsiva | 3 | 42.86 | - |
| I3_banda_piatta | 3 | 100 | BAND_RIDING |
| sd<S50 | 2 | 66.67 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 104, "-1": 122}; fine episodi: {"BAND_RIDING": 141, "FINE_DATI": 2, "OPPOSTO": 12, "T_MAX": 71}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 134 | - | BAND_RIDING |
| finestra | 122 | 91.04 | BAND_RIDING |
| C0_tocco_banda_opposta | 52 | 42.62 | T_MAX |
| C3_sequenza | 45 | 86.54 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 16 | 35.56 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 14 | 87.5 | BAND_RIDING |
| sd<S50 | 13 | 92.86 | BAND_RIDING |
| sd<=sd[-3] | 11 | 84.62 | - |
| SEGNALE | 11 | 100 | - |
Segnali e trade: {"eseguiti": 11, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 11}

Armati: {"+1": 60, "-1": 74}; fine episodi: {"BAND_RIDING": 81, "FINE_DATI": 1, "OPPOSTO": 1, "T_MAX": 51}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 26, "episodi_seq_violata_su_barra_di_tocco": 7, "segnali_con_impulsiva_1.0_violata": 9, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 120 | - | BAND_RIDING |
| finestra | 111 | 92.5 | BAND_RIDING |
| C0_tocco_banda_opposta | 45 | 40.54 | T_MAX |
| C3_sequenza | 41 | 91.11 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 14 | 34.15 | T_MAX |
| C1b_candela_test_non_impulsiva | 8 | 57.14 | T_MAX |
| sd<S50 | 7 | 87.5 | - |
| sd<=sd[-3] | 7 | 100 | - |
| SEGNALE | 7 | 100 | - |
Segnali e trade: {"eseguiti": 7, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 7}

Armati: {"+1": 58, "-1": 62}; fine episodi: {"BAND_RIDING": 72, "FINE_DATI": 1, "OPPOSTO": 5, "T_MAX": 42}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 18, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 7, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 133 | - | BAND_RIDING |
| finestra | 118 | 88.72 | BAND_RIDING |
| C0_tocco_banda_opposta | 52 | 44.07 | - |
| C3_sequenza | 52 | 100 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 19 | 36.54 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 10 | 52.63 | T_MAX |
| sd<S50 | 9 | 90 | - |
| sd<=sd[-3] | 9 | 100 | - |
| SEGNALE | 9 | 100 | - |
Segnali e trade: {"eseguiti": 9, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 9}

Armati: {"+1": 62, "-1": 71}; fine episodi: {"BAND_RIDING": 79, "OPPOSTO": 9, "T_MAX": 45}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 18, "episodi_seq_violata_su_barra_di_tocco": 1, "segnali_con_impulsiva_1.0_violata": 7, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 140 | - | BAND_RIDING |
| finestra | 112 | 80 | BAND_RIDING |
| C0_tocco_banda_opposta | 46 | 41.07 | T_MAX |
| C3_sequenza | 39 | 84.78 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 16 | 41.03 | T_MAX |
| C1b_candela_test_non_impulsiva | 8 | 50 | T_MAX |
| sd<S50 | 6 | 75 | - |
| sd<=sd[-3] | 6 | 100 | - |
| SEGNALE | 6 | 100 | - |
Segnali e trade: {"eseguiti": 6, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 6}

Armati: {"+1": 73, "-1": 67}; fine episodi: {"BAND_RIDING": 91, "OPPOSTO": 10, "T_MAX": 39}; extra: {"episodi_consumati_tocco_precoce": 5, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 20, "episodi_seq_violata_su_barra_di_tocco": 7, "segnali_con_impulsiva_1.0_violata": 5, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 527 | - | BAND_RIDING |
| finestra | 463 | 87.86 | BAND_RIDING |
| C0_tocco_banda_opposta | 195 | 42.12 | T_MAX |
| C3_sequenza | 177 | 90.77 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 65 | 36.72 | T_MAX |
| C1b_candela_test_non_impulsiva | 40 | 61.54 | T_MAX |
| sd<S50 | 35 | 87.5 | BAND_RIDING |
| sd<=sd[-3] | 33 | 94.29 | - |
| SEGNALE | 33 | 100 | - |
Segnali e trade: {"eseguiti": 33, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 33}

Armati: {"+1": 253, "-1": 274}; fine episodi: {"BAND_RIDING": 323, "FINE_DATI": 2, "OPPOSTO": 25, "T_MAX": 177}; extra: {"episodi_consumati_tocco_precoce": 5, "episodi_eliminati_solo_da_SEQ": 3, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 82, "episodi_seq_violata_su_barra_di_tocco": 19, "segnali_con_impulsiva_1.0_violata": 28, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 134 | - | BAND_RIDING |
| finestra | 122 | 91.04 | BAND_RIDING |
| I0_mediana_toccata | 85 | 69.67 | T_MAX |
| I1_banda_opposta_mai_toccata | 24 | 28.24 | T_MAX |
| retest_banda_impulso | 5 | 20.83 | T_MAX |
| I2_nessuna_impulsiva | 1 | 20 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 60, "-1": 74}; fine episodi: {"BAND_RIDING": 81, "FINE_DATI": 1, "OPPOSTO": 1, "T_MAX": 51}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 120 | - | BAND_RIDING |
| finestra | 111 | 92.5 | BAND_RIDING |
| I0_mediana_toccata | 75 | 67.57 | T_MAX |
| I1_banda_opposta_mai_toccata | 27 | 36 | T_MAX |
| retest_banda_impulso | 6 | 22.22 | BAND_RIDING |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 6, "a": 0}]

Armati: {"+1": 58, "-1": 62}; fine episodi: {"BAND_RIDING": 72, "FINE_DATI": 1, "OPPOSTO": 5, "T_MAX": 42}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 133 | - | BAND_RIDING |
| finestra | 118 | 88.72 | BAND_RIDING |
| I0_mediana_toccata | 87 | 73.73 | T_MAX |
| I1_banda_opposta_mai_toccata | 28 | 32.18 | T_MAX |
| retest_banda_impulso | 7 | 25 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 14.29 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 62, "-1": 71}; fine episodi: {"BAND_RIDING": 79, "OPPOSTO": 9, "T_MAX": 45}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 140 | - | BAND_RIDING |
| finestra | 112 | 80 | BAND_RIDING |
| I0_mediana_toccata | 76 | 67.86 | T_MAX |
| I1_banda_opposta_mai_toccata | 25 | 32.89 | T_MAX |
| retest_banda_impulso | 5 | 20 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 20 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 73, "-1": 67}; fine episodi: {"BAND_RIDING": 91, "OPPOSTO": 10, "T_MAX": 39}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 527 | - | BAND_RIDING |
| finestra | 463 | 87.86 | BAND_RIDING |
| I0_mediana_toccata | 323 | 69.76 | T_MAX |
| I1_banda_opposta_mai_toccata | 104 | 32.2 | T_MAX |
| retest_banda_impulso | 23 | 22.12 | BAND_RIDING |
| I2_nessuna_impulsiva | 3 | 13.04 | - |
| I3_banda_piatta | 3 | 100 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 253, "-1": 274}; fine episodi: {"BAND_RIDING": 323, "FINE_DATI": 2, "OPPOSTO": 25, "T_MAX": 177}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

## T2 Risultati per variante x TF x periodo
| cella | n | win_pct | pf_lordo | pf_netto | attesa_R | mediana_R | netto_R | dd_max_R | costo_spread_medio_R | D_medio_atr | pareggio_atteso_medio_pct | wr0_pct | durata_mediana_barre | durata_max_barre | quota_long |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CONT_H1_2015 | 4 | 100 | inf | inf | 0.1524 | 0.1163 | 0.6098 | 0 | 0.01411 | 1.332 | 71.27 | 70.25 | 9 | 17 | 0 |
| CONT_H1_2017 | 4 | 100 | inf | inf | 0.3729 | 0.3725 | 1.491 | 0 | 0.007948 | 1.189 | 73.22 | 72.33 | 2 | 9 | 0.25 |
| CONT_H1_2019 | 5 | 80 | 28.61 | 11.85 | 0.1604 | 0.1539 | 0.8018 | 0.07388 | 0.02443 | 0.9498 | 78.71 | 76.85 | 4 | 14 | 1 |
| CONT_H1_2022 | 2 | 50 | 1.47 | 1.37 | 0.02642 | 0.02642 | 0.05284 | 0.1428 | 0.005979 | 0.4642 | 87.22 | 86.71 | 7.5 | 13 | 0.5 |
| CONT_H1_TOTALE | 15 | 86.67 | 19.57 | 14.64 | 0.1971 | 0.1854 | 2.956 | 0.1428 | 0.01482 | 1.051 | 76.4 | 75.2 | 4 | 17 | 0.4667 |
| INV_H1_2015 | 1 | 100 | inf | inf | 0.03313 | 0.03313 | 0.03313 | 0 | 0.01183 | 0.09939 | 97.94 | 96.79 | 1 | 1 | 1 |
| INV_H1_2017 | 1 | 0 | 0 | 0 | -1 | -1 | -1 | 1 | 0.02276 | 0.3029 | 92.9 | 90.83 | 15 | 15 | 1 |
| INV_H1_2019 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2022 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_TOTALE | 2 | 50 | 0.04601 | 0.03313 | -0.4834 | -0.4834 | -0.9669 | 1 | 0.0173 | 0.2011 | 95.42 | 93.81 | 8 | 15 | 1 |
| POOLED_H1 | 17 | 82.35 | 2.956 | 2.635 | 0.117 | 0.1832 | 1.989 | 1 | 0.01511 | 0.9508 | 78.64 | 77.39 | 4 | 17 | 0.5294 |
| CONT_M30_2015 | 11 | 81.82 | 1.637 | 1.381 | 0.0427 | 0.1544 | 0.4697 | 1 | 0.02636 | 0.7946 | 82.53 | 79.49 | 6 | 19 | 0.6364 |
| CONT_M30_2017 | 7 | 57.14 | 0.7379 | 0.6411 | -0.106 | 0.2083 | -0.7423 | 2 | 0.03204 | 0.9103 | 80.39 | 77.63 | 6 | 13 | 0.1429 |
| CONT_M30_2019 | 9 | 88.89 | 25.42 | 15.48 | 0.123 | 0.09749 | 1.107 | 0.07642 | 0.03852 | 0.715 | 85.11 | 81.62 | 4 | 15 | 0.5556 |
| CONT_M30_2022 | 6 | 33.33 | 0.2001 | 0.1908 | -0.4163 | -0.5434 | -2.498 | 2.498 | 0.01379 | 0.9418 | 78.53 | 76.87 | 7 | 12 | 0.3333 |
| CONT_M30_TOTALE | 33 | 69.7 | 0.8847 | 0.7426 | -0.05041 | 0.114 | -1.664 | 2.742 | 0.0286 | 0.8242 | 82.05 | 79.2 | 6 | 19 | 0.4545 |
| INV_M30_2015 | 1 | 100 | inf | inf | 0.03006 | 0.03006 | 0.03006 | 0 | 0.02283 | 0.09017 | 99.3 | 97.08 | 1 | 1 | 1 |
| INV_M30_2017 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_M30_2019 | 1 | 0 | 0 | 0 | -0.05125 | -0.05125 | -0.05125 | 0.05125 | 0.05057 | 0.44 | 91.62 | 87.21 | 8 | 8 | 1 |
| INV_M30_2022 | 1 | 100 | inf | inf | 0.1453 | 0.1453 | 0.1453 | 0 | 0.01061 | 0.436 | 88.24 | 87.31 | 1 | 1 | 0 |
| INV_M30_TOTALE | 3 | 66.67 | 309.7 | 3.422 | 0.04138 | 0.03006 | 0.1241 | 0.05125 | 0.02801 | 0.322 | 93.05 | 90.53 | 1 | 8 | 0.6667 |
| POOLED_M30 | 36 | 69.44 | 0.9181 | 0.7637 | -0.04277 | 0.1058 | -1.54 | 2.763 | 0.02855 | 0.7824 | 82.97 | 80.15 | 6 | 19 | 0.4722 |

Uscite per motivo e altri conteggi:
- CONT_H1_2015: motivi {"TP": 4}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2017: motivi {"TP": 4}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- CONT_H1_2019: motivi {"TP": 5}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2022: motivi {"TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_TOTALE: motivi {"TP": 15}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- INV_H1_2015: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2017: motivi {"SL": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2019: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2022: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_TOTALE: motivi {"SL": 1, "TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- POOLED_H1: motivi {"SL": 1, "TP": 16}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- CONT_M30_2015: motivi {"MKT": 1, "SL": 1, "TP": 9}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_M30_2017: motivi {"SL": 2, "TP": 5}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2019: motivi {"TP": 9}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2022: motivi {"SL": 3, "TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_TOTALE: motivi {"MKT": 1, "SL": 6, "TP": 26}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- INV_M30_2015: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2017: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_M30_2019: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2022: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_TOTALE: motivi {"TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- POOLED_M30: motivi {"MKT": 1, "SL": 6, "TP": 29}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1

## T3 Fasce (stratificazione, descrittori)
- **pooled**
  - **fascia**
    - **Buono**
      - n: 3
      - vincite: 3
      - long: 1
    - **Medio**
      - n: 14
      - vincite: 11
      - long: 8
      - wr_pct: 78.57
      - media_R: 0.09611
      - wr0_pct: 77.8
      - nota: N<30: solo descrittivo
  - **fascia_accorpata**
    - **<70**
      - n: 14
      - vincite: 11
      - long: 8
      - wr_pct: 78.57
      - media_R: 0.09611
      - wr0_pct: 77.8
      - nota: N<30: solo descrittivo
    - **>=70**
      - n: 3
      - vincite: 3
      - long: 1
  - **n_prev**
    - **0**
      - n: 7
      - vincite: 7
      - long: 6
    - **1**
      - n: 6
      - vincite: 4
      - long: 2
    - **>=2**
      - n: 4
      - vincite: 3
      - long: 1
  - **congestione_valida**
    - **no**
      - n: 17
      - vincite: 14
      - long: 9
      - wr_pct: 82.35
      - media_R: 0.117
      - wr0_pct: 77.39
      - nota: N<30: solo descrittivo
  - **checklist_stretta**
    - **no**
      - n: 17
      - vincite: 14
      - long: 9
      - wr_pct: 82.35
      - media_R: 0.117
      - wr0_pct: 77.39
      - nota: N<30: solo descrittivo
  - **lato**
    - **long**
      - n: 9
      - vincite: 6
      - long: 9
    - **short**
      - n: 8
      - vincite: 8
      - long: 0
  - **periodo**
    - **2015**
      - n: 5
      - vincite: 5
      - long: 1
    - **2017**
      - n: 5
      - vincite: 4
      - long: 2
    - **2019**
      - n: 5
      - vincite: 4
      - long: 5
    - **2022**
      - n: 2
      - vincite: 1
      - long: 1
  - **fascia_oraria_server**
    - **0-7**
      - n: 4
      - vincite: 4
      - long: 2
    - **16-23**
      - n: 1
      - vincite: 1
      - long: 1
    - **8-15**
      - n: 12
      - vincite: 9
      - long: 6
      - wr_pct: 75
      - media_R: 0.03313
      - wr0_pct: 80.06
      - nota: N<30: solo descrittivo
- **CONT**
  - **fascia**
    - **Buono**
      - n: 2
      - vincite: 2
      - long: 0
    - **Medio**
      - n: 13
      - vincite: 11
      - long: 7
      - wr_pct: 84.62
      - media_R: 0.1804
      - wr0_pct: 76.8
      - nota: N<30: solo descrittivo
  - **fascia_accorpata**
    - **<70**
      - n: 13
      - vincite: 11
      - long: 7
      - wr_pct: 84.62
      - media_R: 0.1804
      - wr0_pct: 76.8
      - nota: N<30: solo descrittivo
    - **>=70**
      - n: 2
      - vincite: 2
      - long: 0
  - **n_prev**
    - **0**
      - n: 6
      - vincite: 6
      - long: 5
    - **1**
      - n: 6
      - vincite: 4
      - long: 2
    - **>=2**
      - n: 3
      - vincite: 3
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 15
      - vincite: 13
      - long: 7
      - wr_pct: 86.67
      - media_R: 0.1971
      - wr0_pct: 75.2
      - nota: N<30: solo descrittivo
  - **checklist_stretta**
    - **no**
      - n: 15
      - vincite: 13
      - long: 7
      - wr_pct: 86.67
      - media_R: 0.1971
      - wr0_pct: 75.2
      - nota: N<30: solo descrittivo
  - **lato**
    - **long**
      - n: 7
      - vincite: 5
      - long: 7
    - **short**
      - n: 8
      - vincite: 8
      - long: 0
  - **periodo**
    - **2015**
      - n: 4
      - vincite: 4
      - long: 0
    - **2017**
      - n: 4
      - vincite: 4
      - long: 1
    - **2019**
      - n: 5
      - vincite: 4
      - long: 5
    - **2022**
      - n: 2
      - vincite: 1
      - long: 1
  - **fascia_oraria_server**
    - **0-7**
      - n: 4
      - vincite: 4
      - long: 2
    - **16-23**
      - n: 1
      - vincite: 1
      - long: 1
    - **8-15**
      - n: 10
      - vincite: 8
      - long: 4
      - wr_pct: 80
      - media_R: 0.1364
      - wr0_pct: 77.31
      - nota: N<30: solo descrittivo
- **INV**
  - **fascia**
    - **Buono**
      - n: 1
      - vincite: 1
      - long: 1
    - **Medio**
      - n: 1
      - vincite: 0
      - long: 1
  - **fascia_accorpata**
    - **<70**
      - n: 1
      - vincite: 0
      - long: 1
    - **>=70**
      - n: 1
      - vincite: 1
      - long: 1
  - **n_prev**
    - **0**
      - n: 1
      - vincite: 1
      - long: 1
    - **>=2**
      - n: 1
      - vincite: 0
      - long: 1
  - **congestione_valida**
    - **no**
      - n: 2
      - vincite: 1
      - long: 2
  - **checklist_stretta**
    - **no**
      - n: 2
      - vincite: 1
      - long: 2
  - **lato**
    - **long**
      - n: 2
      - vincite: 1
      - long: 2
  - **periodo**
    - **2015**
      - n: 1
      - vincite: 1
      - long: 1
    - **2017**
      - n: 1
      - vincite: 0
      - long: 1
  - **fascia_oraria_server**
    - **8-15**
      - n: 2
      - vincite: 1
      - long: 2
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
    - n_trade: 17
    - n_abbinati: 17
    - media_osservata_R: 0.117
    - media_nulla: -0.03153
    - p5: -0.2417
    - p50: -0.02365
    - p95: 0.1483
    - percentile_osservato: 0.906
    - p_B: 0.09445
    - pf_nullo_p50: 0.8735
    - pf_osservato: 2.635
  - **variante_CONT**
    - n_trade: 15
    - n_abbinati: 15
    - media_osservata_R: 0.1971
    - media_nulla: -0.02791
    - p5: -0.2507
    - p50: -0.01939
    - p95: 0.1641
    - percentile_osservato: 0.9805
    - p_B: 0.01999
    - pf_nullo_p50: 0.9053
    - pf_osservato: 14.64
  - **variante_INV**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.4834
    - media_nulla: -0.05869
    - p5: -0.4843
    - p50: 0.06284
    - p95: 0.07482
    - percentile_osservato: 0.068
    - p_B: 0.932
    - pf_nullo_p50: -
    - pf_osservato: 0.03313
  - **periodo_2015**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1286
    - media_nulla: 0.07807
    - p5: -0.2665
    - p50: 0.1056
    - p95: 0.311
    - percentile_osservato: 0.54
    - p_B: 0.4603
    - pf_nullo_p50: 3.229
    - pf_osservato: inf
  - **periodo_2017**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.09828
    - media_nulla: -0.08127
    - p5: -0.5244
    - p50: -0.0543
    - p95: 0.2735
    - percentile_osservato: 0.752
    - p_B: 0.2484
    - pf_nullo_p50: 0.7424
    - pf_osservato: 1.491
  - **periodo_2019**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1604
    - media_nulla: -0.09617
    - p5: -0.5248
    - p50: -0.04792
    - p95: 0.2696
    - percentile_osservato: 0.814
    - p_B: 0.1864
    - pf_nullo_p50: 0.7655
    - pf_osservato: 11.85
  - **periodo_2022**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.02642
    - media_nulla: -0.01959
    - p5: -0.4667
    - p50: 0.1328
    - p95: 0.1671
    - percentile_osservato: 0.2885
    - p_B: 0.7116
    - pf_nullo_p50: -
    - pf_osservato: 1.37
  - **lato_long**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: 0.002081
    - media_nulla: -0.06723
    - p5: -0.3558
    - p50: -0.06778
    - p95: 0.1907
    - percentile_osservato: 0.6185
    - p_B: 0.3818
    - pf_nullo_p50: 0.6836
    - pf_osservato: 1.015
  - **lato_short**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: 0.2463
    - media_nulla: 0.008632
    - p5: -0.2942
    - p50: 0.02331
    - p95: 0.2741
    - percentile_osservato: 0.9135
    - p_B: 0.08696
    - pf_nullo_p50: 1.136
    - pf_osservato: inf
- **B0**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 17
    - n_abbinati: 17
    - media_osservata_R: 0.117
    - media_nulla: -0.04751
    - p5: -0.252
    - p50: -0.03916
    - p95: 0.1307
    - percentile_osservato: 0.9335
    - p_B: 0.06697
    - pf_nullo_p50: 0.7946
    - pf_osservato: 2.635
  - **variante_CONT**
    - n_trade: 15
    - n_abbinati: 15
    - media_osservata_R: 0.1971
    - media_nulla: -0.04945
    - p5: -0.2789
    - p50: -0.0403
    - p95: 0.1435
    - percentile_osservato: 0.982
    - p_B: 0.01849
    - pf_nullo_p50: 0.8003
    - pf_osservato: 14.64
  - **variante_INV**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.4834
    - media_nulla: -0.03292
    - p5: -0.4841
    - p50: 0.06396
    - p95: 0.0754
    - percentile_osservato: 0.0605
    - p_B: 0.9395
    - pf_nullo_p50: -
    - pf_osservato: 0.03313
  - **periodo_2015**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1286
    - media_nulla: 0.005455
    - p5: -0.3413
    - p50: 0.009668
    - p95: 0.2857
    - percentile_osservato: 0.661
    - p_B: 0.3393
    - pf_nullo_p50: 1.048
    - pf_osservato: inf
  - **periodo_2017**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.09828
    - media_nulla: -0.03574
    - p5: -0.4114
    - p50: -0.02665
    - p95: 0.2756
    - percentile_osservato: 0.69
    - p_B: 0.3103
    - pf_nullo_p50: 0.8714
    - pf_osservato: 1.491
  - **periodo_2019**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1604
    - media_nulla: -0.1218
    - p5: -0.5309
    - p50: -0.09175
    - p95: 0.233
    - percentile_osservato: 0.865
    - p_B: 0.1354
    - pf_nullo_p50: 0.5737
    - pf_osservato: 11.85
  - **periodo_2022**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.02642
    - media_nulla: -0.02356
    - p5: -0.4689
    - p50: 0.1125
    - p95: 0.1666
    - percentile_osservato: 0.312
    - p_B: 0.6882
    - pf_nullo_p50: -
    - pf_osservato: 1.37
  - **lato_long**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: 0.002081
    - media_nulla: -0.0783
    - p5: -0.3577
    - p50: -0.07296
    - p95: 0.1685
    - percentile_osservato: 0.671
    - p_B: 0.3293
    - pf_nullo_p50: 0.637
    - pf_osservato: 1.015
  - **lato_short**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: 0.2463
    - media_nulla: -0.01286
    - p5: -0.3057
    - p50: -0.00256
    - p95: 0.2469
    - percentile_osservato: 0.9495
    - p_B: 0.05097
    - pf_nullo_p50: 0.9879
    - pf_osservato: inf
- **B2**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 17
    - n_abbinati: 17
    - media_osservata_R: 0.117
    - media_nulla: -0.01071
    - p5: -0.2167
    - p50: -0.003612
    - p95: 0.1574
    - percentile_osservato: 0.883
    - p_B: 0.1174
    - pf_nullo_p50: 0.9786
    - pf_osservato: 2.635
  - **variante_CONT**
    - n_trade: 15
    - n_abbinati: 15
    - media_osservata_R: 0.1971
    - media_nulla: -0.01723
    - p5: -0.244
    - p50: -0.008057
    - p95: 0.1717
    - percentile_osservato: 0.973
    - p_B: 0.02749
    - pf_nullo_p50: 0.9614
    - pf_osservato: 14.64
  - **variante_INV**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.4834
    - media_nulla: 0.03819
    - p5: -0.4813
    - p50: 0.06969
    - p95: 0.07643
    - percentile_osservato: 0.01
    - p_B: 0.99
    - pf_nullo_p50: -
    - pf_osservato: 0.03313
  - **periodo_2015**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1286
    - media_nulla: 0.08938
    - p5: -0.2625
    - p50: 0.1362
    - p95: 0.3073
    - percentile_osservato: 0.4885
    - p_B: 0.5117
    - pf_nullo_p50: 4.935
    - pf_osservato: inf
  - **periodo_2017**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.09828
    - media_nulla: 8.243e-05
    - p5: -0.3653
    - p50: -0.005471
    - p95: 0.2836
    - percentile_osservato: 0.636
    - p_B: 0.3643
    - pf_nullo_p50: 0.9726
    - pf_osservato: 1.491
  - **periodo_2019**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.1604
    - media_nulla: -0.1044
    - p5: -0.5255
    - p50: -0.07804
    - p95: 0.2284
    - percentile_osservato: 0.868
    - p_B: 0.1324
    - pf_nullo_p50: 0.6332
    - pf_osservato: 11.85
  - **periodo_2022**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.02642
    - media_nulla: -0.05375
    - p5: -0.5198
    - p50: 0.09778
    - p95: 0.1711
    - percentile_osservato: 0.364
    - p_B: 0.6362
    - pf_nullo_p50: -
    - pf_osservato: 1.37
  - **lato_long**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: 0.002081
    - media_nulla: -0.05373
    - p5: -0.3157
    - p50: -0.04114
    - p95: 0.1668
    - percentile_osservato: 0.6115
    - p_B: 0.3888
    - pf_nullo_p50: 0.7613
    - pf_osservato: 1.015
  - **lato_short**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: 0.2463
    - media_nulla: 0.03768
    - p5: -0.2495
    - p50: 0.06096
    - p95: 0.279
    - percentile_osservato: 0.894
    - p_B: 0.1064
    - pf_nullo_p50: 1.436
    - pf_osservato: inf
- **pool_barre_simulate**
  - **2015**
    - long: 2905
    - short: 2946
  - **2017**
    - long: 2688
    - short: 3204
  - **2019**
    - long: 2848
    - short: 2958
  - **2022**
    - long: 2682
    - short: 3230

## T5 Robustezza della primaria
- **bootstrap_settimane**
  - settimane: 17
  - media: 0.117
  - ic90_lo: -0.02602
  - ic90_hi: 0.2367
  - n_replicati: 10000
- **senza_i_migliori_3**
  - n: 14
  - media_R: 0.04556
  - pf_netto: 1.524
- **con_tutti**
  - n: 17
  - media_R: 0.117
  - pf_netto: 2.635
- **leave_one_period_out**
  - **2015**
    - n: 12
    - media_R: 0.1122
    - pf_netto: 2.106
  - **2017**
    - n: 12
    - media_R: 0.1248
    - pf_netto: 7.913
  - **2019**
    - n: 12
    - media_R: 0.09893
    - pf_netto: 2.039
  - **2022**
    - n: 15
    - media_R: 0.1291
    - pf_netto: 2.803
- **quota_profitto_per_periodo**
  - 2015: 0.3232
  - 2017: 0.2471
  - 2019: 0.4031
  - 2022: 0.02656
- **spread_x1.5**
  - n: 17
  - media_R: 0.1127
  - pf_netto: 2.546
- **escluso_spread0**
  - n: 16
  - media_R: 0.1127
  - pf_netto: 2.482

## T6 Sensibilita (riportate per intero, non selezionabili)
| sens | segnali | n | win_pct | pf_netto | attesa_R | netto_R | dd_max_R |
|---|---|---|---|---|---|---|---|
| Sa | 18 | 18 | 83.33 | 2.831 | 0.1237 | 2.227 | 1 |
| Sb | 15 | 15 | 86.67 | 14.64 | 0.1971 | 2.956 | 0.1428 |
| Sc | 17 | 17 | 82.35 | 2.635 | 0.117 | 1.989 | 1 |
| Sd | 17 | 17 | 82.35 | 2.546 | 0.1127 | 1.916 | 1 |
| Se20 | 17 | 17 | 82.35 | 2.635 | 0.117 | 1.989 | 1 |
| Se50 | 17 | 17 | 82.35 | 2.635 | 0.117 | 1.989 | 1 |
| Sf | 16 | 16 | 81.25 | 2.35 | 0.1115 | 1.784 | 1 |
| Sg | 18 | 17 | 82.35 | 2.635 | 0.117 | 1.989 | 1 |

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
- **2015**
  - buy_and_hold_in_ATR: -60.77
  - atr_mediana_prezzo: 0.2407
  - **long**
    - n: 1
    - media_R: 0.03313
  - **short**
    - n: 4
    - media_R: 0.1524
- **2017**
  - buy_and_hold_in_ATR: 66.2
  - atr_mediana_prezzo: 0.1847
  - **long**
    - n: 2
    - media_R: -0.3367
  - **short**
    - n: 3
    - media_R: 0.3883
- **2019**
  - buy_and_hold_in_ATR: -24.75
  - atr_mediana_prezzo: 0.134
  - **long**
    - n: 5
    - media_R: 0.1604
  - **short**
    - n: 0
    - media_R: -
- **2022**
  - buy_and_hold_in_ATR: 34.14
  - atr_mediana_prezzo: 0.2749
  - **long**
    - n: 1
    - media_R: -0.1428
  - **short**
    - n: 1
    - media_R: 0.1956

## T9 Dati / esecuzione
- **spread0_sostituiti_per_periodo**
  - 2015: 96
  - 2017: 15731
  - 2019: 1
  - 2022: 17338
- **righe_csv_scartate_o_incoerenti**
  - **2015**
    - righe_scartate_formato: 0
    - duplicati_rimossi: 0
    - salti_indietro_nel_tempo: 0
    - righe_ohlc_incoerenti: 0
  - **2017**
    - righe_scartate_formato: 0
    - duplicati_rimossi: 0
    - salti_indietro_nel_tempo: 0
    - righe_ohlc_incoerenti: 0
  - **2019**
    - righe_scartate_formato: 0
    - duplicati_rimossi: 0
    - salti_indietro_nel_tempo: 0
    - righe_ohlc_incoerenti: 0
  - **2022**
    - righe_scartate_formato: 0
    - duplicati_rimossi: 0
    - salti_indietro_nel_tempo: 0
    - righe_ohlc_incoerenti: 0
- **primaria_H1**
  - trade_spread0_ingresso: 1
  - trade_spread0_uscita: 0
  - gap_ingresso_max_min: 0
  - trade_con_gap_ingresso_gt_0: 0
  - trade_chiusi_fine_dati: 0
  - uscite_a_mercato_target_superato: 0
  - ricalcoli_target_totali: 29
  - eventi_sl_tp_stesso_minuto: 0
  - **segnali_scartati**
    - scartati_posizione_aperta: 0
    - scartati_target_oltre_ingresso: 0
    - scartati_indicatori_non_pronti: 0
    - scartati_no_barra_successiva: 0
    - scartati_gap_ingresso: 0
  - segnali_totali: 17
  - tocchi_penetrazione_lt_spread_sui_segnali: 0
  - coppie_CONT_INV_stesso_episodio: 0

## Log dei trade
Schedule completa dei target per ogni trade nel JSON (chiave tabelle.LOG_TRADE).
