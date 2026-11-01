# Breaking Band su EURUSD — risultati (generato da run_test.py)

sha256 dei risultati (JSON canonico): `7e5fe46edc2ff64b1af1fa584552612127fcad00c9962b83f1abf35e45506ae5`

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
  - PUNTO: 1e-05
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
  - 2013: 2a88f28efdbe16ca3bf4548b365d9c77872a8d926536565889ae7b81515b4743
  - 2018: 77276362b9344719f9aaf73d3c1c464b7bd6b95b341e636daa86858055c89dd3
  - 2020: d4d80a6ddb973dbf2d06963b43a8d2df7508e2e7e5090e8b7f99f7572b4c7457
  - 2025-26: 34d51cddee3b0205acd4084a5c98ec52beeddabec7660916c03d07666eee3225
- **righe_csv**
  - 2013: 368613
  - 2018: 371934
  - 2020: 373024
  - 2025-26: 645348
- simbolo: EURUSD
- punto: 1e-05
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
  - ABTG_M1_EURUSD_2013.csv: True
  - ABTG_M1_EURUSD_2018.csv: True
  - ABTG_M1_EURUSD_2020.csv: True
  - ABTG_M1_EURUSD.csv: True
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
- N: 12
- media_R: 0.2941
- pf_netto: inf
- p_B1: 0.001499
- **ic90**
  - settimane: 12
  - media: 0.2941
  - ic90_lo: 0.2295
  - ic90_hi: 0.3638
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
  - EURUSD: ambito dichiarato dalla Guida (MAJOR/MINOR, D1/H4/H1/M30) da verificare per il simbolo; M15 non ammesso e non testato
  - Guida usata = 'versione didattica' non confermata come Guida Operativa 11 ufficiale; mancano Dichiarazione di Test e screenshot
  - stop 3 ATR, target SMA20, ricalcolo 3 ore da Guida/Protocolli; soglie 'molto/ordinato' sono interpretazioni (specifica sez. 8); pattern testati = soprainsieme dei validi
  - dati del solo simbolo EURUSD; i 4 periodi sono 4 regimi; N per cella in T2
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
| armati | 62 | - | BAND_RIDING |
| finestra | 57 | 91.94 | BAND_RIDING |
| C0_tocco_banda_opposta | 34 | 59.65 | T_MAX |
| C3_sequenza | 28 | 82.35 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 14 | 50 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 4 | 28.57 | T_MAX |
| sd<S50 | 3 | 75 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 33, "-1": 29}; fine episodi: {"BAND_RIDING": 36, "OPPOSTO": 6, "T_MAX": 20}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 18, "episodi_seq_violata_su_barra_di_tocco": 9, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 57 | - | BAND_RIDING |
| finestra | 48 | 84.21 | BAND_RIDING |
| C0_tocco_banda_opposta | 16 | 33.33 | T_MAX |
| C3_sequenza | 15 | 93.75 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 5 | 33.33 | T_MAX |
| C1b_candela_test_non_impulsiva | 0 | 0 | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "C1b_candela_test_non_impulsiva", "da": 5, "a": 0}]

Armati: {"+1": 22, "-1": 35}; fine episodi: {"BAND_RIDING": 45, "OPPOSTO": 2, "T_MAX": 10}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 6, "episodi_seq_violata_su_barra_di_tocco": 3, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 57 | - | BAND_RIDING |
| finestra | 50 | 87.72 | BAND_RIDING |
| C0_tocco_banda_opposta | 17 | 34 | T_MAX |
| C3_sequenza | 15 | 88.24 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 8 | 53.33 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 3 | 37.5 | - |
| sd<S50 | 3 | 100 | T_MAX |
| sd<=sd[-3] | 2 | 66.67 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 33, "-1": 24}; fine episodi: {"BAND_RIDING": 45, "FINE_DATI": 1, "T_MAX": 11}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 6, "episodi_seq_violata_su_barra_di_tocco": 2, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 97 | - | BAND_RIDING |
| finestra | 82 | 84.54 | BAND_RIDING |
| C0_tocco_banda_opposta | 33 | 40.24 | BAND_RIDING |
| C3_sequenza | 28 | 84.85 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 8 | 28.57 | T_MAX |
| C1b_candela_test_non_impulsiva | 3 | 37.5 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 54, "-1": 43}; fine episodi: {"BAND_RIDING": 66, "FINE_DATI": 1, "OPPOSTO": 6, "T_MAX": 24}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 16, "episodi_seq_violata_su_barra_di_tocco": 6, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 273 | - | BAND_RIDING |
| finestra | 237 | 86.81 | BAND_RIDING |
| C0_tocco_banda_opposta | 100 | 42.19 | T_MAX |
| C3_sequenza | 86 | 86 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 35 | 40.7 | T_MAX |
| C1b_candela_test_non_impulsiva | 10 | 28.57 | T_MAX |
| sd<S50 | 9 | 90 | T_MAX |
| sd<=sd[-3] | 8 | 88.89 | - |
| SEGNALE | 8 | 100 | - |
Segnali e trade: {"eseguiti": 8, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 8}

Armati: {"+1": 142, "-1": 131}; fine episodi: {"BAND_RIDING": 192, "FINE_DATI": 2, "OPPOSTO": 14, "T_MAX": 65}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 46, "episodi_seq_violata_su_barra_di_tocco": 20, "segnali_con_impulsiva_1.0_violata": 7, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 62 | - | BAND_RIDING |
| finestra | 57 | 91.94 | BAND_RIDING |
| I0_mediana_toccata | 43 | 75.44 | T_MAX |
| I1_banda_opposta_mai_toccata | 19 | 44.19 | T_MAX |
| retest_banda_impulso | 6 | 31.58 | BAND_RIDING |
| I2_nessuna_impulsiva | 2 | 33.33 | - |
| I3_banda_piatta | 2 | 100 | - |
| sd<S50 | 2 | 100 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 33, "-1": 29}; fine episodi: {"BAND_RIDING": 36, "OPPOSTO": 6, "T_MAX": 20}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 57 | - | BAND_RIDING |
| finestra | 48 | 84.21 | BAND_RIDING |
| I0_mediana_toccata | 24 | 50 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 10 | 41.67 | BAND_RIDING |
| retest_banda_impulso | 0 | 0 | - |
| I2_nessuna_impulsiva | 0 | - | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "retest_banda_impulso", "da": 10, "a": 0}]

Armati: {"+1": 22, "-1": 35}; fine episodi: {"BAND_RIDING": 45, "OPPOSTO": 2, "T_MAX": 10}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 57 | - | BAND_RIDING |
| finestra | 50 | 87.72 | BAND_RIDING |
| I0_mediana_toccata | 30 | 60 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 17 | 56.67 | BAND_RIDING |
| retest_banda_impulso | 5 | 29.41 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 20 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 33, "-1": 24}; fine episodi: {"BAND_RIDING": 45, "FINE_DATI": 1, "T_MAX": 11}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 97 | - | BAND_RIDING |
| finestra | 82 | 84.54 | BAND_RIDING |
| I0_mediana_toccata | 52 | 63.41 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 19 | 36.54 | T_MAX |
| retest_banda_impulso | 5 | 26.32 | T_MAX |
| I2_nessuna_impulsiva | 1 | 20 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 54, "-1": 43}; fine episodi: {"BAND_RIDING": 66, "FINE_DATI": 1, "OPPOSTO": 6, "T_MAX": 24}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 273 | - | BAND_RIDING |
| finestra | 237 | 86.81 | BAND_RIDING |
| I0_mediana_toccata | 149 | 62.87 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 65 | 43.62 | BAND_RIDING |
| retest_banda_impulso | 16 | 24.62 | BAND_RIDING |
| I2_nessuna_impulsiva | 4 | 25 | - |
| I3_banda_piatta | 4 | 100 | - |
| sd<S50 | 4 | 100 | - |
| sd<=sd[-3] | 4 | 100 | - |
| SEGNALE | 4 | 100 | - |
Segnali e trade: {"eseguiti": 4, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 4}

Armati: {"+1": 142, "-1": 131}; fine episodi: {"BAND_RIDING": 192, "FINE_DATI": 2, "OPPOSTO": 14, "T_MAX": 65}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 4, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 156 | - | BAND_RIDING |
| finestra | 142 | 91.03 | BAND_RIDING |
| C0_tocco_banda_opposta | 80 | 56.34 | T_MAX |
| C3_sequenza | 71 | 88.75 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 39 | 54.93 | T_MAX |
| C1b_candela_test_non_impulsiva | 30 | 76.92 | T_MAX |
| sd<S50 | 29 | 96.67 | T_MAX |
| sd<=sd[-3] | 22 | 75.86 | - |
| SEGNALE | 22 | 100 | - |
Segnali e trade: {"eseguiti": 19, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 3, "segnali": 22}

Armati: {"+1": 81, "-1": 75}; fine episodi: {"BAND_RIDING": 63, "OPPOSTO": 11, "T_MAX": 82}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 41, "episodi_seq_violata_su_barra_di_tocco": 9, "segnali_con_impulsiva_1.0_violata": 18, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 169 | - | BAND_RIDING |
| finestra | 161 | 95.27 | BAND_RIDING |
| C0_tocco_banda_opposta | 71 | 44.1 | T_MAX |
| C3_sequenza | 60 | 84.51 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 24 | 40 | T_MAX |
| C1b_candela_test_non_impulsiva | 16 | 66.67 | T_MAX |
| sd<S50 | 15 | 93.75 | - |
| sd<=sd[-3] | 15 | 100 | - |
| SEGNALE | 15 | 100 | - |
Segnali e trade: {"eseguiti": 15, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 15}

Armati: {"+1": 80, "-1": 89}; fine episodi: {"BAND_RIDING": 90, "OPPOSTO": 16, "T_MAX": 63}; extra: {"episodi_consumati_tocco_precoce": 3, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 25, "episodi_seq_violata_su_barra_di_tocco": 11, "segnali_con_impulsiva_1.0_violata": 13, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 152 | - | BAND_RIDING |
| finestra | 138 | 90.79 | BAND_RIDING |
| C0_tocco_banda_opposta | 45 | 32.61 | T_MAX |
| C3_sequenza | 38 | 84.44 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 22 | 57.89 | T_MAX |
| C1b_candela_test_non_impulsiva | 16 | 72.73 | - |
| sd<S50 | 16 | 100 | T_MAX |
| sd<=sd[-3] | 13 | 81.25 | - |
| SEGNALE | 13 | 100 | - |
Segnali e trade: {"eseguiti": 13, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 13}

Armati: {"+1": 80, "-1": 72}; fine episodi: {"BAND_RIDING": 81, "OPPOSTO": 12, "T_MAX": 59}; extra: {"episodi_consumati_tocco_precoce": 2, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 15, "episodi_seq_violata_su_barra_di_tocco": 8, "segnali_con_impulsiva_1.0_violata": 13, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 227 | - | BAND_RIDING |
| finestra | 210 | 92.51 | BAND_RIDING |
| C0_tocco_banda_opposta | 92 | 43.81 | T_MAX |
| C3_sequenza | 80 | 86.96 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 44 | 55 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 32 | 72.73 | T_MAX |
| sd<S50 | 29 | 90.62 | T_MAX |
| sd<=sd[-3] | 26 | 89.66 | - |
| SEGNALE | 26 | 100 | - |
Segnali e trade: {"eseguiti": 25, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 1, "segnali": 26}

Armati: {"+1": 121, "-1": 106}; fine episodi: {"BAND_RIDING": 120, "OPPOSTO": 19, "T_MAX": 88}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 2, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 33, "episodi_seq_violata_su_barra_di_tocco": 12, "segnali_con_impulsiva_1.0_violata": 23, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 704 | - | BAND_RIDING |
| finestra | 651 | 92.47 | BAND_RIDING |
| C0_tocco_banda_opposta | 288 | 44.24 | T_MAX |
| C3_sequenza | 249 | 86.46 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 129 | 51.81 | T_MAX |
| C1b_candela_test_non_impulsiva | 94 | 72.87 | T_MAX |
| sd<S50 | 89 | 94.68 | T_MAX |
| sd<=sd[-3] | 76 | 85.39 | - |
| SEGNALE | 76 | 100 | - |
Segnali e trade: {"eseguiti": 72, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 4, "segnali": 76}

Armati: {"+1": 362, "-1": 342}; fine episodi: {"BAND_RIDING": 354, "OPPOSTO": 58, "T_MAX": 292}; extra: {"episodi_consumati_tocco_precoce": 7, "episodi_eliminati_solo_da_SEQ": 4, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 114, "episodi_seq_violata_su_barra_di_tocco": 40, "segnali_con_impulsiva_1.0_violata": 67, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 156 | - | BAND_RIDING |
| finestra | 142 | 91.03 | BAND_RIDING |
| I0_mediana_toccata | 114 | 80.28 | T_MAX |
| I1_banda_opposta_mai_toccata | 26 | 22.81 | T_MAX |
| retest_banda_impulso | 8 | 30.77 | BAND_RIDING |
| I2_nessuna_impulsiva | 4 | 50 | T_MAX |
| I3_banda_piatta | 3 | 75 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 81, "-1": 75}; fine episodi: {"BAND_RIDING": 63, "OPPOSTO": 11, "T_MAX": 82}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 169 | - | BAND_RIDING |
| finestra | 161 | 95.27 | BAND_RIDING |
| I0_mediana_toccata | 113 | 70.19 | T_MAX |
| I1_banda_opposta_mai_toccata | 21 | 18.58 | T_MAX |
| retest_banda_impulso | 6 | 28.57 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 16.67 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 80, "-1": 89}; fine episodi: {"BAND_RIDING": 90, "OPPOSTO": 16, "T_MAX": 63}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 152 | - | BAND_RIDING |
| finestra | 138 | 90.79 | BAND_RIDING |
| I0_mediana_toccata | 106 | 76.81 | T_MAX |
| I1_banda_opposta_mai_toccata | 25 | 23.58 | BAND_RIDING |
| retest_banda_impulso | 8 | 32 | T_MAX |
| I2_nessuna_impulsiva | 2 | 25 | - |
| I3_banda_piatta | 2 | 100 | - |
| sd<S50 | 2 | 100 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 80, "-1": 72}; fine episodi: {"BAND_RIDING": 81, "OPPOSTO": 12, "T_MAX": 59}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 227 | - | BAND_RIDING |
| finestra | 210 | 92.51 | BAND_RIDING |
| I0_mediana_toccata | 151 | 71.9 | T_MAX |
| I1_banda_opposta_mai_toccata | 50 | 33.11 | T_MAX |
| retest_banda_impulso | 9 | 18 | T_MAX |
| I2_nessuna_impulsiva | 1 | 11.11 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 121, "-1": 106}; fine episodi: {"BAND_RIDING": 120, "OPPOSTO": 19, "T_MAX": 88}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 704 | - | BAND_RIDING |
| finestra | 651 | 92.47 | BAND_RIDING |
| I0_mediana_toccata | 484 | 74.35 | T_MAX |
| I1_banda_opposta_mai_toccata | 122 | 25.21 | T_MAX |
| retest_banda_impulso | 31 | 25.41 | T_MAX |
| I2_nessuna_impulsiva | 8 | 25.81 | T_MAX |
| I3_banda_piatta | 7 | 87.5 | - |
| sd<S50 | 7 | 100 | - |
| sd<=sd[-3] | 7 | 100 | - |
| SEGNALE | 7 | 100 | - |
Segnali e trade: {"eseguiti": 7, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 7}

Armati: {"+1": 362, "-1": 342}; fine episodi: {"BAND_RIDING": 354, "OPPOSTO": 58, "T_MAX": 292}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 7, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

## T2 Risultati per variante x TF x periodo
| cella | n | win_pct | pf_lordo | pf_netto | attesa_R | mediana_R | netto_R | dd_max_R | costo_spread_medio_R | D_medio_atr | pareggio_atteso_medio_pct | wr0_pct | durata_mediana_barre | durata_max_barre | quota_long |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CONT_H1_2013 | 3 | 100 | inf | inf | 0.3885 | 0.3173 | 1.166 | 0 | 0.01067 | 1.181 | 73.27 | 72.56 | 3 | 4 | 0.3333 |
| CONT_H1_2018 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| CONT_H1_2020 | 2 | 100 | inf | inf | 0.4469 | 0.4469 | 0.8939 | 0 | 0.003688 | 1.462 | 67.67 | 67.23 | 2.5 | 4 | 0 |
| CONT_H1_2025-26 | 3 | 100 | inf | inf | 0.1929 | 0.138 | 0.5786 | 0 | 0.005375 | 0.7098 | 81.81 | 81.49 | 5 | 5 | 0 |
| CONT_H1_TOTALE | 8 | 100 | inf | inf | 0.3298 | 0.3327 | 2.638 | 0 | 0.006939 | 1.075 | 75.07 | 74.58 | 3.5 | 5 | 0.125 |
| INV_H1_2013 | 2 | 100 | inf | inf | 0.2282 | 0.2282 | 0.4565 | 0 | 0.008182 | 0.6847 | 82.49 | 81.71 | 2 | 3 | 0 |
| INV_H1_2018 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2020 | 1 | 100 | inf | inf | 0.2604 | 0.2604 | 0.2604 | 0 | 0.001866 | 0.7812 | 79.49 | 79.34 | 1 | 1 | 1 |
| INV_H1_2025-26 | 1 | 100 | inf | inf | 0.1742 | 0.1742 | 0.1742 | 0 | 0.001834 | 0.5227 | 85.32 | 85.16 | 3 | 3 | 0 |
| INV_H1_TOTALE | 4 | 100 | inf | inf | 0.2228 | 0.2173 | 0.8911 | 0 | 0.005016 | 0.6683 | 82.45 | 81.98 | 2 | 3 | 0.25 |
| POOLED_H1 | 12 | 100 | inf | inf | 0.2941 | 0.2812 | 3.529 | 0 | 0.006298 | 0.9392 | 77.53 | 77.05 | 3 | 5 | 0.1667 |
| CONT_M30_2013 | 19 | 73.68 | 1.07 | 0.9832 | -0.002805 | 0.176 | -0.0533 | 1.217 | 0.01419 | 0.8323 | 80.1 | 78.83 | 7 | 16 | 0.5789 |
| CONT_M30_2018 | 15 | 86.67 | 1.775 | 1.599 | 0.0799 | 0.1977 | 1.198 | 1.888 | 0.01994 | 1.066 | 76.08 | 74.48 | 7 | 13 | 0.2667 |
| CONT_M30_2020 | 13 | 69.23 | 0.7472 | 0.714 | -0.088 | 0.2424 | -1.144 | 2.41 | 0.01053 | 1.083 | 74.92 | 74.07 | 6 | 19 | 0.2308 |
| CONT_M30_2025-26 | 25 | 76 | 0.9881 | 0.9642 | -0.007211 | 0.1626 | -0.1803 | 2.023 | 0.004838 | 1.152 | 73.63 | 73.24 | 7 | 18 | 0.52 |
| CONT_M30_TOTALE | 72 | 76.39 | 1.046 | 0.9874 | -0.002487 | 0.192 | -0.1791 | 4.117 | 0.01148 | 1.037 | 76.08 | 75.13 | 6.5 | 19 | 0.4306 |
| INV_M30_2013 | 3 | 100 | inf | inf | 0.1465 | 0.129 | 0.4396 | 0 | 0.008786 | 0.6322 | 83.65 | 82.69 | 7 | 8 | 0.6667 |
| INV_M30_2018 | 1 | 100 | inf | inf | 0.07949 | 0.07949 | 0.07949 | 0 | 0.009607 | 0.2385 | 93.53 | 92.64 | 1 | 1 | 1 |
| INV_M30_2020 | 2 | 100 | inf | inf | 0.2276 | 0.2276 | 0.4552 | 0 | 0.008256 | 0.7726 | 80.69 | 79.99 | 6.5 | 12 | 0 |
| INV_M30_2025-26 | 1 | 100 | inf | inf | 0.1739 | 0.1739 | 0.1739 | 0 | 0.00751 | 0.5216 | 85.83 | 85.19 | 1 | 1 | 1 |
| INV_M30_TOTALE | 7 | 100 | inf | inf | 0.164 | 0.161 | 1.148 | 0 | 0.00857 | 0.6003 | 84.52 | 83.7 | 1 | 12 | 0.5714 |
| POOLED_M30 | 79 | 78.48 | 1.132 | 1.068 | 0.01227 | 0.176 | 0.9691 | 3.662 | 0.01122 | 0.9987 | 76.83 | 75.89 | 6 | 19 | 0.443 |

Uscite per motivo e altri conteggi:
- CONT_H1_2013: motivi {"TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2018: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- CONT_H1_2020: motivi {"TP": 2}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- CONT_H1_2025-26: motivi {"TP": 3}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 0
- CONT_H1_TOTALE: motivi {"TP": 8}; SL+TP stesso minuto 0; spread0 4; fine_dati/mkt 0
- INV_H1_2013: motivi {"TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2018: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2020: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- INV_H1_2025-26: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- INV_H1_TOTALE: motivi {"TP": 4}; SL+TP stesso minuto 0; spread0 2; fine_dati/mkt 0
- POOLED_H1: motivi {"TP": 12}; SL+TP stesso minuto 0; spread0 6; fine_dati/mkt 0
- CONT_M30_2013: motivi {"SL": 3, "TP": 16}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2018: motivi {"MKT": 1, "SL": 2, "TP": 12}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_M30_2020: motivi {"SL": 4, "TP": 9}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2025-26: motivi {"SL": 5, "TP": 20}; SL+TP stesso minuto 0; spread0 20; fine_dati/mkt 0
- CONT_M30_TOTALE: motivi {"MKT": 1, "SL": 14, "TP": 57}; SL+TP stesso minuto 0; spread0 20; fine_dati/mkt 1
- INV_M30_2013: motivi {"TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2018: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2020: motivi {"TP": 2}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- INV_M30_2025-26: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- INV_M30_TOTALE: motivi {"TP": 7}; SL+TP stesso minuto 0; spread0 2; fine_dati/mkt 0
- POOLED_M30: motivi {"MKT": 1, "SL": 14, "TP": 64}; SL+TP stesso minuto 0; spread0 22; fine_dati/mkt 1

## T3 Fasce (stratificazione, descrittori)
- **pooled**
  - **fascia**
    - **Buono**
      - n: 4
      - vincite: 4
      - long: 0
    - **Medio**
      - n: 7
      - vincite: 7
      - long: 2
    - **Ottimo**
      - n: 1
      - vincite: 1
      - long: 0
  - **fascia_accorpata**
    - **<70**
      - n: 7
      - vincite: 7
      - long: 2
    - **>=70**
      - n: 5
      - vincite: 5
      - long: 0
  - **n_prev**
    - **0**
      - n: 6
      - vincite: 6
      - long: 2
    - **1**
      - n: 6
      - vincite: 6
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 10
      - vincite: 10
      - long: 2
      - wr_pct: 100
      - media_R: 0.2917
      - wr0_pct: 76.89
      - nota: N<30: solo descrittivo
    - **si**
      - n: 2
      - vincite: 2
      - long: 0
  - **checklist_stretta**
    - **no**
      - n: 11
      - vincite: 11
      - long: 2
      - wr_pct: 100
      - media_R: 0.3083
      - wr0_pct: 76.06
      - nota: N<30: solo descrittivo
    - **si**
      - n: 1
      - vincite: 1
      - long: 0
  - **lato**
    - **long**
      - n: 2
      - vincite: 2
      - long: 2
    - **short**
      - n: 10
      - vincite: 10
      - long: 0
      - wr_pct: 100
      - media_R: 0.2679
      - wr0_pct: 78.29
      - nota: N<30: solo descrittivo
  - **periodo**
    - **2013**
      - n: 5
      - vincite: 5
      - long: 1
    - **2020**
      - n: 3
      - vincite: 3
      - long: 1
    - **2025-26**
      - n: 4
      - vincite: 4
      - long: 0
  - **fascia_oraria_server**
    - **0-7**
      - n: 3
      - vincite: 3
      - long: 0
    - **8-15**
      - n: 9
      - vincite: 9
      - long: 2
- **CONT**
  - **fascia**
    - **Buono**
      - n: 3
      - vincite: 3
      - long: 0
    - **Medio**
      - n: 4
      - vincite: 4
      - long: 1
    - **Ottimo**
      - n: 1
      - vincite: 1
      - long: 0
  - **fascia_accorpata**
    - **<70**
      - n: 4
      - vincite: 4
      - long: 1
    - **>=70**
      - n: 4
      - vincite: 4
      - long: 0
  - **n_prev**
    - **0**
      - n: 4
      - vincite: 4
      - long: 1
    - **1**
      - n: 4
      - vincite: 4
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 6
      - vincite: 6
      - long: 1
    - **si**
      - n: 2
      - vincite: 2
      - long: 0
  - **checklist_stretta**
    - **no**
      - n: 7
      - vincite: 7
      - long: 1
    - **si**
      - n: 1
      - vincite: 1
      - long: 0
  - **lato**
    - **long**
      - n: 1
      - vincite: 1
      - long: 1
    - **short**
      - n: 7
      - vincite: 7
      - long: 0
  - **periodo**
    - **2013**
      - n: 3
      - vincite: 3
      - long: 1
    - **2020**
      - n: 2
      - vincite: 2
      - long: 0
    - **2025-26**
      - n: 3
      - vincite: 3
      - long: 0
  - **fascia_oraria_server**
    - **0-7**
      - n: 2
      - vincite: 2
      - long: 0
    - **8-15**
      - n: 6
      - vincite: 6
      - long: 1
- **INV**
  - **fascia**
    - **Buono**
      - n: 1
      - vincite: 1
      - long: 0
    - **Medio**
      - n: 3
      - vincite: 3
      - long: 1
  - **fascia_accorpata**
    - **<70**
      - n: 3
      - vincite: 3
      - long: 1
    - **>=70**
      - n: 1
      - vincite: 1
      - long: 0
  - **n_prev**
    - **0**
      - n: 2
      - vincite: 2
      - long: 1
    - **1**
      - n: 2
      - vincite: 2
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 4
      - vincite: 4
      - long: 1
  - **checklist_stretta**
    - **no**
      - n: 4
      - vincite: 4
      - long: 1
  - **lato**
    - **long**
      - n: 1
      - vincite: 1
      - long: 1
    - **short**
      - n: 3
      - vincite: 3
      - long: 0
  - **periodo**
    - **2013**
      - n: 2
      - vincite: 2
      - long: 0
    - **2020**
      - n: 1
      - vincite: 1
      - long: 1
    - **2025-26**
      - n: 1
      - vincite: 1
      - long: 0
  - **fascia_oraria_server**
    - **0-7**
      - n: 1
      - vincite: 1
      - long: 0
    - **8-15**
      - n: 3
      - vincite: 3
      - long: 1
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
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: 0.2941
    - media_nulla: -0.006725
    - p5: -0.2611
    - p50: 0.006337
    - p95: 0.2182
    - percentile_osservato: 0.999
    - p_B: 0.001499
    - pf_nullo_p50: 1.038
    - pf_osservato: inf
  - **variante_CONT**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: 0.3298
    - media_nulla: -0.006831
    - p5: -0.3515
    - p50: -0.00568
    - p95: 0.2826
    - percentile_osservato: 0.9955
    - p_B: 0.004998
    - pf_nullo_p50: 0.9759
    - pf_osservato: inf
  - **variante_INV**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: 0.2228
    - media_nulla: -0.006514
    - p5: -0.4153
    - p50: 0.01775
    - p95: 0.2215
    - percentile_osservato: 0.9555
    - p_B: 0.04498
    - pf_nullo_p50: 1.255
    - pf_osservato: inf
  - **periodo_2013**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.3244
    - media_nulla: -0.06455
    - p5: -0.5158
    - p50: -0.02386
    - p95: 0.294
    - percentile_osservato: 0.9935
    - p_B: 0.006997
    - pf_nullo_p50: 0.8831
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.3848
    - media_nulla: 0.02266
    - p5: -0.5867
    - p50: 0.08605
    - p95: 0.3747
    - percentile_osservato: 0.9615
    - p_B: 0.03898
    - pf_nullo_p50: 2.074
    - pf_osservato: inf
  - **periodo_2025-26**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: 0.1882
    - media_nulla: 0.04352
    - p5: -0.3462
    - p50: 0.125
    - p95: 0.2274
    - percentile_osservato: 0.721
    - p_B: 0.2794
    - pf_nullo_p50: 15.87
    - pf_osservato: inf
  - **lato_long**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.4253
    - media_nulla: 0.05157
    - p5: -0.4706
    - p50: 0.2435
    - p95: 0.4369
    - percentile_osservato: 0.9215
    - p_B: 0.07896
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **lato_short**
    - n_trade: 10
    - n_abbinati: 10
    - media_osservata_R: 0.2679
    - media_nulla: -0.01838
    - p5: -0.2829
    - p50: -0.01557
    - p95: 0.2224
    - percentile_osservato: 0.996
    - p_B: 0.004498
    - pf_nullo_p50: 0.9216
    - pf_osservato: inf
- **B0**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: 0.2941
    - media_nulla: -0.02521
    - p5: -0.2521
    - p50: -0.0201
    - p95: 0.1855
    - percentile_osservato: 0.9995
    - p_B: 0.0009995
    - pf_nullo_p50: 0.8926
    - pf_osservato: inf
  - **variante_CONT**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: 0.3298
    - media_nulla: -0.02675
    - p5: -0.3345
    - p50: -0.01743
    - p95: 0.2405
    - percentile_osservato: 0.998
    - p_B: 0.002499
    - pf_nullo_p50: 0.9017
    - pf_osservato: inf
  - **variante_INV**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: 0.2228
    - media_nulla: -0.02213
    - p5: -0.4282
    - p50: 0.02139
    - p95: 0.2176
    - percentile_osservato: 0.9685
    - p_B: 0.03198
    - pf_nullo_p50: 1.271
    - pf_osservato: inf
  - **periodo_2013**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.3244
    - media_nulla: -0.03951
    - p5: -0.4487
    - p50: -0.02653
    - p95: 0.2685
    - percentile_osservato: 0.996
    - p_B: 0.004498
    - pf_nullo_p50: 0.8674
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.3848
    - media_nulla: -0.06071
    - p5: -0.6019
    - p50: -0.09222
    - p95: 0.3535
    - percentile_osservato: 0.981
    - p_B: 0.01949
    - pf_nullo_p50: 0.7067
    - pf_osservato: inf
  - **periodo_2025-26**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: 0.1882
    - media_nulla: 0.01929
    - p5: -0.3539
    - p50: 0.09108
    - p95: 0.2186
    - percentile_osservato: 0.825
    - p_B: 0.1754
    - pf_nullo_p50: 5.268
    - pf_osservato: inf
  - **lato_long**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.4253
    - media_nulla: 0.03493
    - p5: -0.5098
    - p50: 0.1761
    - p95: 0.423
    - percentile_osservato: 0.9515
    - p_B: 0.04898
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **lato_short**
    - n_trade: 10
    - n_abbinati: 10
    - media_osservata_R: 0.2679
    - media_nulla: -0.03724
    - p5: -0.2853
    - p50: -0.03423
    - p95: 0.1972
    - percentile_osservato: 0.999
    - p_B: 0.001499
    - pf_nullo_p50: 0.8249
    - pf_osservato: inf
- **B2**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: 0.2941
    - media_nulla: -0.01111
    - p5: -0.228
    - p50: -0.004339
    - p95: 0.1795
    - percentile_osservato: 0.9995
    - p_B: 0.0009995
    - pf_nullo_p50: 0.9719
    - pf_osservato: inf
  - **variante_CONT**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: 0.3298
    - media_nulla: -0.02383
    - p5: -0.2995
    - p50: -0.007342
    - p95: 0.2196
    - percentile_osservato: 0.999
    - p_B: 0.001499
    - pf_nullo_p50: 0.9457
    - pf_osservato: inf
  - **variante_INV**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: 0.2228
    - media_nulla: 0.01432
    - p5: -0.3991
    - p50: 0.09576
    - p95: 0.2266
    - percentile_osservato: 0.9335
    - p_B: 0.06697
    - pf_nullo_p50: 7.015
    - pf_osservato: inf
  - **periodo_2013**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.3244
    - media_nulla: 0.01719
    - p5: -0.3232
    - p50: 0.01294
    - p95: 0.2732
    - percentile_osservato: 0.9925
    - p_B: 0.007996
    - pf_nullo_p50: 1.069
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.3848
    - media_nulla: -0.09517
    - p5: -0.6211
    - p50: -0.08119
    - p95: 0.2866
    - percentile_osservato: 0.9865
    - p_B: 0.01399
    - pf_nullo_p50: 0.6982
    - pf_osservato: inf
  - **periodo_2025-26**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: 0.1882
    - media_nulla: 0.01656
    - p5: -0.4144
    - p50: 0.0962
    - p95: 0.2233
    - percentile_osservato: 0.8075
    - p_B: 0.1929
    - pf_nullo_p50: 7.453
    - pf_osservato: inf
  - **lato_long**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.4253
    - media_nulla: -0.0179
    - p5: -0.4981
    - p50: 0.1217
    - p95: 0.4255
    - percentile_osservato: 0.9495
    - p_B: 0.05097
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **lato_short**
    - n_trade: 10
    - n_abbinati: 10
    - media_osservata_R: 0.2679
    - media_nulla: -0.009753
    - p5: -0.2435
    - p50: -0.0009862
    - p95: 0.1911
    - percentile_osservato: 0.9985
    - p_B: 0.001999
    - pf_nullo_p50: 0.9927
    - pf_osservato: inf
- **pool_barre_simulate**
  - **2013**
    - long: 2727
    - short: 3131
  - **2018**
    - long: 2941
    - short: 2964
  - **2020**
    - long: 2794
    - short: 3142
  - **2025-26**
    - long: 5378
    - short: 5144

## T5 Robustezza della primaria
- **bootstrap_settimane**
  - settimane: 12
  - media: 0.2941
  - ic90_lo: 0.2295
  - ic90_hi: 0.3638
  - n_replicati: 10000
- **senza_i_migliori_3**
  - n: 9
  - media_R: 0.2272
  - pf_netto: inf
- **con_tutti**
  - n: 12
  - media_R: 0.2941
  - pf_netto: inf
- **leave_one_period_out**
  - **2013**
    - n: 7
    - media_R: 0.2724
    - pf_netto: inf
  - **2018**
    - n: 12
    - media_R: 0.2941
    - pf_netto: inf
  - **2020**
    - n: 9
    - media_R: 0.2639
    - pf_netto: inf
  - **2025-26**
    - n: 8
    - media_R: 0.347
    - pf_netto: inf
- **quota_profitto_per_periodo**
  - 2013: 0.4596
  - 2018: 0
  - 2020: 0.3271
  - 2025-26: 0.2133
- **spread_x1.5**
  - n: 12
  - media_R: 0.29
  - pf_netto: inf
- **escluso_spread0**
  - n: 6
  - media_R: 0.3402
  - pf_netto: inf

## T6 Sensibilita (riportate per intero, non selezionabili)
| sens | segnali | n | win_pct | pf_netto | attesa_R | netto_R | dd_max_R |
|---|---|---|---|---|---|---|---|
| Sa | 13 | 13 | 92.31 | 8.584 | 0.2399 | 3.118 | 0.4111 |
| Sb | 8 | 8 | 100 | inf | 0.3298 | 2.638 | 0 |
| Sc | 12 | 12 | 100 | inf | 0.2941 | 3.529 | 0 |
| Sd | 12 | 12 | 100 | inf | 0.29 | 3.48 | 0 |
| Se20 | 12 | 12 | 100 | inf | 0.2951 | 3.541 | 0 |
| Se50 | 12 | 12 | 100 | inf | 0.2941 | 3.529 | 0 |
| Sf | 11 | 11 | 100 | inf | 0.305 | 3.355 | 0 |
| Sg | 16 | 16 | 100 | inf | 0.2761 | 4.417 | 0 |

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
  - buy_and_hold_in_ATR: 34.85
  - atr_mediana_prezzo: 0.001671
  - **long**
    - n: 1
    - media_R: 0.5903
  - **short**
    - n: 4
    - media_R: 0.258
- **2018**
  - buy_and_hold_in_ATR: -37.04
  - atr_mediana_prezzo: 0.001506
  - **long**
    - n: 0
    - media_R: -
  - **short**
    - n: 0
    - media_R: -
- **2020**
  - buy_and_hold_in_ATR: 69.98
  - atr_mediana_prezzo: 0.00145
  - **long**
    - n: 1
    - media_R: 0.2604
  - **short**
    - n: 2
    - media_R: 0.4469
- **2025-26**
  - buy_and_hold_in_ATR: 77.69
  - atr_mediana_prezzo: 0.001261
  - **long**
    - n: 0
    - media_R: -
  - **short**
    - n: 4
    - media_R: 0.1882

## T9 Dati / esecuzione
- **spread0_sostituiti_per_periodo**
  - 2013: 0
  - 2018: 14
  - 2020: 37104
  - 2025-26: 379230
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
  - trade_spread0_ingresso: 4
  - trade_spread0_uscita: 4
  - gap_ingresso_max_min: 0
  - trade_con_gap_ingresso_gt_0: 0
  - trade_chiusi_fine_dati: 0
  - uscite_a_mercato_target_superato: 0
  - ricalcoli_target_totali: 4
  - eventi_sl_tp_stesso_minuto: 0
  - **segnali_scartati**
    - scartati_posizione_aperta: 0
    - scartati_target_oltre_ingresso: 0
    - scartati_indicatori_non_pronti: 0
    - scartati_no_barra_successiva: 0
    - scartati_gap_ingresso: 0
  - segnali_totali: 12
  - tocchi_penetrazione_lt_spread_sui_segnali: 0
  - coppie_CONT_INV_stesso_episodio: 0

## Log dei trade
Schedule completa dei target per ogni trade nel JSON (chiave tabelle.LOG_TRADE).
