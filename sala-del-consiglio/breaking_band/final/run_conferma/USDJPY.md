# Breaking Band su USDJPY — risultati (generato da run_test.py)

sha256 dei risultati (JSON canonico): `4318950ce7520316b1f0cc43d42358e782c4cc4fa792d5c4d2bcc621e96c62f1`

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
  - 2015: 79b2365daf3921f8e041ea53d9ad335d7396a3f669bbce7288d54406c827b830
  - 2017: 03b662babed9c2931bafc9ef143f604b5ca36e9a9b6be5b70eba83bc286f1ace
  - 2019: 4772a92b4035fd1291896f708de8c9bf208ce7c865361cb3251179ee855bea9a
  - 2022: 8a33bc0f4279acb4533affa254c3fe8afa649e05293a132621faf66a8e572170
- **righe_csv**
  - 2015: 370855
  - 2017: 370562
  - 2019: 371473
  - 2022: 372697
- simbolo: USDJPY
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
  - ABTG_M1_USDJPY_2015.csv: True
  - ABTG_M1_USDJPY_2017.csv: True
  - ABTG_M1_USDJPY_2019.csv: True
  - ABTG_M1_USDJPY_2022.csv: True
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
- N: 9
- media_R: -0.01074
- pf_netto: 0.9539
- p_B1: 0.5052
- **ic90**
  - settimane: 8
  - media: -0.01074
  - ic90_lo: -0.3549
  - ic90_hi: 0.2721
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
  - USDJPY: ambito dichiarato dalla Guida (MAJOR/MINOR, D1/H4/H1/M30) da verificare per il simbolo; M15 non ammesso e non testato
  - Guida usata = 'versione didattica' non confermata come Guida Operativa 11 ufficiale; mancano Dichiarazione di Test e screenshot
  - stop 3 ATR, target SMA20, ricalcolo 3 ore da Guida/Protocolli; soglie 'molto/ordinato' sono interpretazioni (specifica sez. 8); pattern testati = soprainsieme dei validi
  - dati del solo simbolo USDJPY; i 4 periodi sono 4 regimi; N per cella in T2
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
| armati | 56 | - | BAND_RIDING |
| finestra | 51 | 91.07 | BAND_RIDING |
| C0_tocco_banda_opposta | 19 | 37.25 | T_MAX |
| C3_sequenza | 18 | 94.74 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 7 | 38.89 | T_MAX |
| C1b_candela_test_non_impulsiva | 3 | 42.86 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 24, "-1": 32}; fine episodi: {"BAND_RIDING": 37, "OPPOSTO": 1, "T_MAX": 18}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 10, "episodi_seq_violata_su_barra_di_tocco": 1, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 46 | 79.31 | BAND_RIDING |
| C0_tocco_banda_opposta | 21 | 45.65 | T_MAX |
| C3_sequenza | 20 | 95.24 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 9 | 45 | T_MAX |
| C1b_candela_test_non_impulsiva | 5 | 55.56 | T_MAX |
| sd<S50 | 4 | 80 | BAND_RIDING |
| sd<=sd[-3] | 3 | 75 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 1, "segnali": 3}

Armati: {"+1": 25, "-1": 33}; fine episodi: {"BAND_RIDING": 42, "OPPOSTO": 2, "T_MAX": 14}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 3, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 50 | 86.21 | BAND_RIDING |
| C0_tocco_banda_opposta | 20 | 40 | T_MAX |
| C3_sequenza | 18 | 90 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 3 | 16.67 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 1 | 33.33 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 30, "-1": 28}; fine episodi: {"BAND_RIDING": 41, "OPPOSTO": 4, "T_MAX": 13}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 9, "episodi_seq_violata_su_barra_di_tocco": 2, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 52 | 89.66 | BAND_RIDING |
| C0_tocco_banda_opposta | 17 | 32.69 | T_MAX |
| C3_sequenza | 14 | 82.35 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 5 | 35.71 | T_MAX |
| C1b_candela_test_non_impulsiva | 3 | 60 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 37, "-1": 21}; fine episodi: {"BAND_RIDING": 37, "OPPOSTO": 4, "T_MAX": 17}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 10, "episodi_seq_violata_su_barra_di_tocco": 5, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 230 | - | BAND_RIDING |
| finestra | 199 | 86.52 | BAND_RIDING |
| C0_tocco_banda_opposta | 77 | 38.69 | T_MAX |
| C3_sequenza | 70 | 90.91 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 24 | 34.29 | T_MAX |
| C1b_candela_test_non_impulsiva | 12 | 50 | T_MAX |
| sd<S50 | 11 | 91.67 | BAND_RIDING |
| sd<=sd[-3] | 10 | 90.91 | - |
| SEGNALE | 10 | 100 | - |
Segnali e trade: {"eseguiti": 9, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 1, "segnali": 10}

Armati: {"+1": 116, "-1": 114}; fine episodi: {"BAND_RIDING": 157, "OPPOSTO": 11, "T_MAX": 62}; extra: {"episodi_consumati_tocco_precoce": 2, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 32, "episodi_seq_violata_su_barra_di_tocco": 12, "segnali_con_impulsiva_1.0_violata": 10, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 56 | - | BAND_RIDING |
| finestra | 51 | 91.07 | BAND_RIDING |
| I0_mediana_toccata | 33 | 64.71 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 11 | 33.33 | T_MAX |
| retest_banda_impulso | 1 | 9.091 | T_MAX |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "retest_banda_impulso", "da": 11, "a": 1}, {"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 1, "a": 0}]

Armati: {"+1": 24, "-1": 32}; fine episodi: {"BAND_RIDING": 37, "OPPOSTO": 1, "T_MAX": 18}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 46 | 79.31 | BAND_RIDING |
| I0_mediana_toccata | 27 | 58.7 | T_MAX |
| I1_banda_opposta_mai_toccata | 8 | 29.63 | T_MAX |
| retest_banda_impulso | 1 | 12.5 | BAND_RIDING |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 1, "a": 0}]

Armati: {"+1": 25, "-1": 33}; fine episodi: {"BAND_RIDING": 42, "OPPOSTO": 2, "T_MAX": 14}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 50 | 86.21 | BAND_RIDING |
| I0_mediana_toccata | 30 | 60 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 6 | 20 | T_MAX |
| retest_banda_impulso | 1 | 16.67 | T_MAX |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 1, "a": 0}]

Armati: {"+1": 30, "-1": 28}; fine episodi: {"BAND_RIDING": 41, "OPPOSTO": 4, "T_MAX": 13}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 52 | 89.66 | BAND_RIDING |
| I0_mediana_toccata | 30 | 57.69 | T_MAX |
| I1_banda_opposta_mai_toccata | 14 | 46.67 | T_MAX |
| retest_banda_impulso | 3 | 21.43 | T_MAX |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 3, "a": 0}]

Armati: {"+1": 37, "-1": 21}; fine episodi: {"BAND_RIDING": 37, "OPPOSTO": 4, "T_MAX": 17}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 230 | - | BAND_RIDING |
| finestra | 199 | 86.52 | BAND_RIDING |
| I0_mediana_toccata | 120 | 60.3 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 39 | 32.5 | T_MAX |
| retest_banda_impulso | 6 | 15.38 | T_MAX |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 6, "a": 0}]

Armati: {"+1": 116, "-1": 114}; fine episodi: {"BAND_RIDING": 157, "OPPOSTO": 11, "T_MAX": 62}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 133 | - | BAND_RIDING |
| finestra | 119 | 89.47 | BAND_RIDING |
| C0_tocco_banda_opposta | 48 | 40.34 | T_MAX |
| C3_sequenza | 45 | 93.75 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 17 | 37.78 | T_MAX |
| C1b_candela_test_non_impulsiva | 13 | 76.47 | T_MAX |
| sd<S50 | 12 | 92.31 | T_MAX |
| sd<=sd[-3] | 9 | 75 | - |
| SEGNALE | 9 | 100 | - |
Segnali e trade: {"eseguiti": 9, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 9}

Armati: {"+1": 66, "-1": 67}; fine episodi: {"BAND_RIDING": 72, "OPPOSTO": 13, "T_MAX": 48}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 19, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 8, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 129 | - | BAND_RIDING |
| finestra | 109 | 84.5 | BAND_RIDING |
| C0_tocco_banda_opposta | 47 | 43.12 | T_MAX |
| C3_sequenza | 45 | 95.74 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 14 | 31.11 | OPPOSTO |
| C1b_candela_test_non_impulsiva | 13 | 92.86 | T_MAX |
| sd<S50 | 11 | 84.62 | T_MAX |
| sd<=sd[-3] | 9 | 81.82 | - |
| SEGNALE | 9 | 100 | - |
Segnali e trade: {"eseguiti": 9, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 9}

Armati: {"+1": 52, "-1": 77}; fine episodi: {"BAND_RIDING": 80, "OPPOSTO": 7, "T_MAX": 42}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 20, "episodi_seq_violata_su_barra_di_tocco": 5, "segnali_con_impulsiva_1.0_violata": 8, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 123 | - | BAND_RIDING |
| finestra | 113 | 91.87 | BAND_RIDING |
| C0_tocco_banda_opposta | 50 | 44.25 | T_MAX |
| C3_sequenza | 42 | 84 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 13 | 30.95 | T_MAX |
| C1b_candela_test_non_impulsiva | 6 | 46.15 | T_MAX |
| sd<S50 | 5 | 83.33 | - |
| sd<=sd[-3] | 5 | 100 | - |
| SEGNALE | 5 | 100 | - |
Segnali e trade: {"eseguiti": 5, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 5}

Armati: {"+1": 59, "-1": 64}; fine episodi: {"BAND_RIDING": 74, "OPPOSTO": 10, "T_MAX": 39}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 26, "episodi_seq_violata_su_barra_di_tocco": 8, "segnali_con_impulsiva_1.0_violata": 5, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 122 | - | BAND_RIDING |
| finestra | 103 | 84.43 | BAND_RIDING |
| C0_tocco_banda_opposta | 45 | 43.69 | T_MAX |
| C3_sequenza | 43 | 95.56 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 9 | 20.93 | T_MAX |
| C1b_candela_test_non_impulsiva | 5 | 55.56 | - |
| sd<S50 | 5 | 100 | BAND_RIDING |
| sd<=sd[-3] | 4 | 80 | - |
| SEGNALE | 4 | 100 | - |
Segnali e trade: {"eseguiti": 4, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 4}

Armati: {"+1": 69, "-1": 53}; fine episodi: {"BAND_RIDING": 74, "OPPOSTO": 8, "T_MAX": 40}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 19, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 507 | - | BAND_RIDING |
| finestra | 444 | 87.57 | BAND_RIDING |
| C0_tocco_banda_opposta | 190 | 42.79 | T_MAX |
| C3_sequenza | 175 | 92.11 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 53 | 30.29 | T_MAX |
| C1b_candela_test_non_impulsiva | 37 | 69.81 | T_MAX |
| sd<S50 | 33 | 89.19 | T_MAX |
| sd<=sd[-3] | 27 | 81.82 | - |
| SEGNALE | 27 | 100 | - |
Segnali e trade: {"eseguiti": 27, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 27}

Armati: {"+1": 246, "-1": 261}; fine episodi: {"BAND_RIDING": 300, "OPPOSTO": 38, "T_MAX": 169}; extra: {"episodi_consumati_tocco_precoce": 3, "episodi_eliminati_solo_da_SEQ": 2, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 84, "episodi_seq_violata_su_barra_di_tocco": 21, "segnali_con_impulsiva_1.0_violata": 24, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 133 | - | BAND_RIDING |
| finestra | 119 | 89.47 | BAND_RIDING |
| I0_mediana_toccata | 83 | 69.75 | T_MAX |
| I1_banda_opposta_mai_toccata | 29 | 34.94 | T_MAX |
| retest_banda_impulso | 6 | 20.69 | T_MAX |
| I2_nessuna_impulsiva | 2 | 33.33 | - |
| I3_banda_piatta | 2 | 100 | - |
| sd<S50 | 2 | 100 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 66, "-1": 67}; fine episodi: {"BAND_RIDING": 72, "OPPOSTO": 13, "T_MAX": 48}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 129 | - | BAND_RIDING |
| finestra | 109 | 84.5 | BAND_RIDING |
| I0_mediana_toccata | 74 | 67.89 | T_MAX |
| I1_banda_opposta_mai_toccata | 27 | 36.49 | T_MAX |
| retest_banda_impulso | 5 | 18.52 | BAND_RIDING |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 5, "a": 0}]

Armati: {"+1": 52, "-1": 77}; fine episodi: {"BAND_RIDING": 80, "OPPOSTO": 7, "T_MAX": 42}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 123 | - | BAND_RIDING |
| finestra | 113 | 91.87 | BAND_RIDING |
| I0_mediana_toccata | 75 | 66.37 | T_MAX |
| I1_banda_opposta_mai_toccata | 30 | 40 | T_MAX |
| retest_banda_impulso | 8 | 26.67 | T_MAX |
| I2_nessuna_impulsiva | 1 | 12.5 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 59, "-1": 64}; fine episodi: {"BAND_RIDING": 74, "OPPOSTO": 10, "T_MAX": 39}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 122 | - | BAND_RIDING |
| finestra | 103 | 84.43 | BAND_RIDING |
| I0_mediana_toccata | 78 | 75.73 | T_MAX |
| I1_banda_opposta_mai_toccata | 30 | 38.46 | T_MAX |
| retest_banda_impulso | 5 | 16.67 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 20 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 69, "-1": 53}; fine episodi: {"BAND_RIDING": 74, "OPPOSTO": 8, "T_MAX": 40}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 507 | - | BAND_RIDING |
| finestra | 444 | 87.57 | BAND_RIDING |
| I0_mediana_toccata | 310 | 69.82 | T_MAX |
| I1_banda_opposta_mai_toccata | 116 | 37.42 | T_MAX |
| retest_banda_impulso | 24 | 20.69 | BAND_RIDING |
| I2_nessuna_impulsiva | 4 | 16.67 | - |
| I3_banda_piatta | 4 | 100 | - |
| sd<S50 | 4 | 100 | - |
| sd<=sd[-3] | 4 | 100 | - |
| SEGNALE | 4 | 100 | - |
Segnali e trade: {"eseguiti": 4, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 4}

Armati: {"+1": 246, "-1": 261}; fine episodi: {"BAND_RIDING": 300, "OPPOSTO": 38, "T_MAX": 169}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 4, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

## T2 Risultati per variante x TF x periodo
| cella | n | win_pct | pf_lordo | pf_netto | attesa_R | mediana_R | netto_R | dd_max_R | costo_spread_medio_R | D_medio_atr | pareggio_atteso_medio_pct | wr0_pct | durata_mediana_barre | durata_max_barre | quota_long |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CONT_H1_2015 | 3 | 100 | inf | inf | 0.3244 | 0.3278 | 0.9731 | 0 | 0.01716 | 1.178 | 73.75 | 72.52 | 10 | 11 | 0.3333 |
| CONT_H1_2017 | 2 | 0 | 0 | 0 | -0.548 | -0.548 | -1.096 | 1.096 | 0.0143 | 1.385 | 70.17 | 69.17 | 17 | 17 | 0 |
| CONT_H1_2019 | 1 | 100 | inf | inf | 0.3077 | 0.3077 | 0.3077 | 0 | 0.0197 | 1.048 | 75.57 | 74.11 | 7 | 7 | 1 |
| CONT_H1_2022 | 3 | 66.67 | 0.7246 | 0.7184 | -0.09386 | 0.3385 | -0.2816 | 1 | 0.002183 | 1.207 | 71.47 | 71.32 | 4 | 27 | 0.3333 |
| CONT_H1_TOTALE | 9 | 66.67 | 1.005 | 0.9539 | -0.01074 | 0.3077 | -0.09668 | 1.45 | 0.01181 | 1.219 | 72.4 | 71.55 | 10 | 27 | 0.3333 |
| INV_H1_2015 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2017 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2019 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2022 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_TOTALE | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| POOLED_H1 | 9 | 66.67 | 1.005 | 0.9539 | -0.01074 | 0.3077 | -0.09668 | 1.45 | 0.01181 | 1.219 | 72.4 | 71.55 | 10 | 27 | 0.3333 |
| CONT_M30_2015 | 9 | 44.44 | 0.9729 | 0.7592 | -0.03866 | -0.04267 | -0.3479 | 1.22 | 0.03487 | 1.059 | 78.46 | 75.79 | 9 | 27 | 0.4444 |
| CONT_M30_2017 | 9 | 77.78 | 1.291 | 1.151 | 0.03347 | 0.2722 | 0.3012 | 1.085 | 0.02887 | 1.003 | 78.23 | 76 | 4 | 10 | 0 |
| CONT_M30_2019 | 5 | 40 | 0.1927 | 0.1729 | -0.3583 | -0.1661 | -1.792 | 2 | 0.01667 | 0.9743 | 77.38 | 75.8 | 5 | 21 | 0.6 |
| CONT_M30_2022 | 4 | 100 | inf | inf | 0.3823 | 0.3805 | 1.529 | 0 | 0.01197 | 1.18 | 74.75 | 71.98 | 5.5 | 11 | 0.25 |
| CONT_M30_TOTALE | 27 | 62.96 | 1.075 | 0.9449 | -0.01144 | 0.2043 | -0.309 | 2.812 | 0.02611 | 1.042 | 77.63 | 75.3 | 6 | 27 | 0.2963 |
| INV_M30_2015 | 2 | 100 | inf | inf | 0.2497 | 0.2497 | 0.4994 | 0 | 0.0311 | 0.7491 | 82.8 | 80.33 | 4.5 | 6 | 0.5 |
| INV_M30_2017 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_M30_2019 | 1 | 0 | 0 | 0 | -1 | -1 | -1 | 1 | 0.01795 | 1.034 | 76.37 | 74.37 | 4 | 4 | 0 |
| INV_M30_2022 | 1 | 100 | inf | inf | 0.1624 | 0.1624 | 0.1624 | 0 | 0.007313 | 1.092 | 73.85 | 73.31 | 13 | 13 | 0 |
| INV_M30_TOTALE | 4 | 75 | 0.7446 | 0.6617 | -0.08456 | 0.1672 | -0.3383 | 1 | 0.02187 | 0.9061 | 78.95 | 77.08 | 5 | 13 | 0.25 |
| POOLED_M30 | 31 | 64.52 | 1.023 | 0.9021 | -0.02088 | 0.188 | -0.6472 | 3.808 | 0.02556 | 1.025 | 77.8 | 75.53 | 6 | 27 | 0.2903 |

Uscite per motivo e altri conteggi:
- CONT_H1_2015: motivi {"MKT": 1, "TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_H1_2017: motivi {"SL": 1, "TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2019: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2022: motivi {"SL": 1, "TP": 2}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 0
- CONT_H1_TOTALE: motivi {"MKT": 1, "SL": 2, "TP": 6}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 1
- INV_H1_2015: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2017: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2019: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2022: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_TOTALE: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- POOLED_H1: motivi {"MKT": 1, "SL": 2, "TP": 6}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 1
- CONT_M30_2015: motivi {"MKT": 1, "SL": 1, "TP": 7}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_M30_2017: motivi {"SL": 2, "TP": 7}; SL+TP stesso minuto 0; spread0 2; fine_dati/mkt 0
- CONT_M30_2019: motivi {"SL": 2, "TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2022: motivi {"TP": 4}; SL+TP stesso minuto 0; spread0 2; fine_dati/mkt 0
- CONT_M30_TOTALE: motivi {"MKT": 1, "SL": 5, "TP": 21}; SL+TP stesso minuto 0; spread0 4; fine_dati/mkt 1
- INV_M30_2015: motivi {"TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2017: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_M30_2019: motivi {"SL": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2022: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- INV_M30_TOTALE: motivi {"SL": 1, "TP": 3}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- POOLED_M30: motivi {"MKT": 1, "SL": 6, "TP": 24}; SL+TP stesso minuto 0; spread0 5; fine_dati/mkt 1

## T3 Fasce (stratificazione, descrittori)
- **pooled**
  - **fascia**
    - **Buono**
      - n: 5
      - vincite: 3
      - long: 2
    - **Medio**
      - n: 3
      - vincite: 2
      - long: 1
    - **Ottimo**
      - n: 1
      - vincite: 1
      - long: 0
  - **fascia_accorpata**
    - **<70**
      - n: 3
      - vincite: 2
      - long: 1
    - **>=70**
      - n: 6
      - vincite: 4
      - long: 2
  - **n_prev**
    - **0**
      - n: 5
      - vincite: 4
      - long: 2
    - **1**
      - n: 3
      - vincite: 2
      - long: 1
    - **>=2**
      - n: 1
      - vincite: 0
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 8
      - vincite: 5
      - long: 3
    - **si**
      - n: 1
      - vincite: 1
      - long: 0
  - **checklist_stretta**
    - **no**
      - n: 8
      - vincite: 5
      - long: 3
    - **si**
      - n: 1
      - vincite: 1
      - long: 0
  - **lato**
    - **long**
      - n: 3
      - vincite: 3
      - long: 3
    - **short**
      - n: 6
      - vincite: 3
      - long: 0
  - **periodo**
    - **2015**
      - n: 3
      - vincite: 3
      - long: 1
    - **2017**
      - n: 2
      - vincite: 0
      - long: 0
    - **2019**
      - n: 1
      - vincite: 1
      - long: 1
    - **2022**
      - n: 3
      - vincite: 2
      - long: 1
  - **fascia_oraria_server**
    - **16-23**
      - n: 2
      - vincite: 0
      - long: 0
    - **8-15**
      - n: 7
      - vincite: 6
      - long: 3
- **CONT**
  - **fascia**
    - **Buono**
      - n: 5
      - vincite: 3
      - long: 2
    - **Medio**
      - n: 3
      - vincite: 2
      - long: 1
    - **Ottimo**
      - n: 1
      - vincite: 1
      - long: 0
  - **fascia_accorpata**
    - **<70**
      - n: 3
      - vincite: 2
      - long: 1
    - **>=70**
      - n: 6
      - vincite: 4
      - long: 2
  - **n_prev**
    - **0**
      - n: 5
      - vincite: 4
      - long: 2
    - **1**
      - n: 3
      - vincite: 2
      - long: 1
    - **>=2**
      - n: 1
      - vincite: 0
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 8
      - vincite: 5
      - long: 3
    - **si**
      - n: 1
      - vincite: 1
      - long: 0
  - **checklist_stretta**
    - **no**
      - n: 8
      - vincite: 5
      - long: 3
    - **si**
      - n: 1
      - vincite: 1
      - long: 0
  - **lato**
    - **long**
      - n: 3
      - vincite: 3
      - long: 3
    - **short**
      - n: 6
      - vincite: 3
      - long: 0
  - **periodo**
    - **2015**
      - n: 3
      - vincite: 3
      - long: 1
    - **2017**
      - n: 2
      - vincite: 0
      - long: 0
    - **2019**
      - n: 1
      - vincite: 1
      - long: 1
    - **2022**
      - n: 3
      - vincite: 2
      - long: 1
  - **fascia_oraria_server**
    - **16-23**
      - n: 2
      - vincite: 0
      - long: 0
    - **8-15**
      - n: 7
      - vincite: 6
      - long: 3
- **INV**
  - **fascia**
  - **fascia_accorpata**
  - **n_prev**
  - **congestione_valida**
  - **checklist_stretta**
  - **lato**
  - **periodo**
  - **fascia_oraria_server**
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
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: -0.01074
    - media_nulla: -0.01649
    - p5: -0.3053
    - p50: -0.008954
    - p95: 0.2511
    - percentile_osservato: 0.495
    - p_B: 0.5052
    - pf_nullo_p50: 0.9573
    - pf_osservato: 0.9539
  - **variante_CONT**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: -0.01074
    - media_nulla: -0.01649
    - p5: -0.3053
    - p50: -0.008954
    - p95: 0.2511
    - percentile_osservato: 0.495
    - p_B: 0.5052
    - pf_nullo_p50: 0.9573
    - pf_osservato: 0.9539
  - **variante_INV**
    - n_trade: 0
    - n_abbinati: 0
  - **periodo_2015**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.3244
    - media_nulla: 0.02255
    - p5: -0.5612
    - p50: 0.08799
    - p95: 0.3552
    - percentile_osservato: 0.8915
    - p_B: 0.1089
    - pf_nullo_p50: 2.226
    - pf_osservato: inf
  - **periodo_2017**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.548
    - media_nulla: -0.05266
    - p5: -0.7426
    - p50: 0.07176
    - p95: 0.416
    - percentile_osservato: 0.09
    - p_B: 0.91
    - pf_nullo_p50: 2.474
    - pf_osservato: 0
  - **periodo_2019**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.3077
    - media_nulla: -0.05167
    - p5: -1
    - p50: 0.2037
    - p95: 0.398
    - percentile_osservato: 0.631
    - p_B: 0.3693
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2022**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: -0.09386
    - media_nulla: -0.01968
    - p5: -0.5986
    - p50: -0.0597
    - p95: 0.3693
    - percentile_osservato: 0.448
    - p_B: 0.5522
    - pf_nullo_p50: 0.8078
    - pf_osservato: 0.7184
  - **lato_long**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.2546
    - media_nulla: -0.02928
    - p5: -0.6144
    - p50: 0.0575
    - p95: 0.3167
    - percentile_osservato: 0.7795
    - p_B: 0.2209
    - pf_nullo_p50: 2.082
    - pf_osservato: inf
  - **lato_short**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: -0.1434
    - media_nulla: -0.01009
    - p5: -0.3941
    - p50: 0.02366
    - p95: 0.3151
    - percentile_osservato: 0.2615
    - p_B: 0.7386
    - pf_nullo_p50: 1.125
    - pf_osservato: 0.5895
- **B0**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: -0.01074
    - media_nulla: -0.03201
    - p5: -0.3408
    - p50: -0.02142
    - p95: 0.2417
    - percentile_osservato: 0.5225
    - p_B: 0.4778
    - pf_nullo_p50: 0.9007
    - pf_osservato: 0.9539
  - **variante_CONT**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: -0.01074
    - media_nulla: -0.03201
    - p5: -0.3408
    - p50: -0.02142
    - p95: 0.2417
    - percentile_osservato: 0.5225
    - p_B: 0.4778
    - pf_nullo_p50: 0.9007
    - pf_osservato: 0.9539
  - **variante_INV**
    - n_trade: 0
    - n_abbinati: 0
  - **periodo_2015**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.3244
    - media_nulla: -0.001113
    - p5: -0.5852
    - p50: 0.06935
    - p95: 0.3513
    - percentile_osservato: 0.918
    - p_B: 0.08246
    - pf_nullo_p50: 2.181
    - pf_osservato: inf
  - **periodo_2017**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.548
    - media_nulla: -0.04779
    - p5: -0.7491
    - p50: 0.06771
    - p95: 0.4284
    - percentile_osservato: 0.084
    - p_B: 0.916
    - pf_nullo_p50: 1.871
    - pf_osservato: 0
  - **periodo_2019**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.3077
    - media_nulla: -0.07086
    - p5: -1
    - p50: 0.1835
    - p95: 0.3802
    - percentile_osservato: 0.7175
    - p_B: 0.2829
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2022**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: -0.09386
    - media_nulla: -0.03942
    - p5: -0.5965
    - p50: -0.07068
    - p95: 0.3583
    - percentile_osservato: 0.46
    - p_B: 0.5402
    - pf_nullo_p50: 0.7772
    - pf_osservato: 0.7184
  - **lato_long**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.2546
    - media_nulla: -0.02
    - p5: -0.5952
    - p50: 0.07539
    - p95: 0.3021
    - percentile_osservato: 0.827
    - p_B: 0.1734
    - pf_nullo_p50: 2.27
    - pf_osservato: inf
  - **lato_short**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: -0.1434
    - media_nulla: -0.03801
    - p5: -0.4179
    - p50: -0.01261
    - p95: 0.3039
    - percentile_osservato: 0.3085
    - p_B: 0.6917
    - pf_nullo_p50: 0.9401
    - pf_osservato: 0.5895
- **B2**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: -0.01074
    - media_nulla: -0.1044
    - p5: -0.4061
    - p50: -0.09322
    - p95: 0.1689
    - percentile_osservato: 0.6845
    - p_B: 0.3158
    - pf_nullo_p50: 0.6233
    - pf_osservato: 0.9539
  - **variante_CONT**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: -0.01074
    - media_nulla: -0.1044
    - p5: -0.4061
    - p50: -0.09322
    - p95: 0.1689
    - percentile_osservato: 0.6845
    - p_B: 0.3158
    - pf_nullo_p50: 0.6233
    - pf_osservato: 0.9539
  - **variante_INV**
    - n_trade: 0
    - n_abbinati: 0
  - **periodo_2015**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.3244
    - media_nulla: -0.06022
    - p5: -0.5902
    - p50: -0.02689
    - p95: 0.2955
    - percentile_osservato: 0.976
    - p_B: 0.02449
    - pf_nullo_p50: 0.8439
    - pf_osservato: inf
  - **periodo_2017**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.548
    - media_nulla: -0.228
    - p5: -1
    - p50: -0.3125
    - p95: 0.3823
    - percentile_osservato: 0.189
    - p_B: 0.8111
    - pf_nullo_p50: 0.3238
    - pf_osservato: 0
  - **periodo_2019**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.3077
    - media_nulla: -0.1832
    - p5: -1
    - p50: 0.03436
    - p95: 0.3727
    - percentile_osservato: 0.815
    - p_B: 0.1854
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2022**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: -0.09386
    - media_nulla: -0.03997
    - p5: -0.6092
    - p50: -0.07054
    - p95: 0.3586
    - percentile_osservato: 0.4635
    - p_B: 0.5367
    - pf_nullo_p50: 0.7853
    - pf_osservato: 0.7184
  - **lato_long**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.2546
    - media_nulla: -0.04086
    - p5: -0.589
    - p50: 0.0322
    - p95: 0.2933
    - percentile_osservato: 0.895
    - p_B: 0.1054
    - pf_nullo_p50: 1.604
    - pf_osservato: inf
  - **lato_short**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: -0.1434
    - media_nulla: -0.1362
    - p5: -0.5311
    - p50: -0.1298
    - p95: 0.2251
    - percentile_osservato: 0.474
    - p_B: 0.5262
    - pf_nullo_p50: 0.5611
    - pf_osservato: 0.5895
- **pool_barre_simulate**
  - **2015**
    - long: 2722
    - short: 3092
  - **2017**
    - long: 2853
    - short: 3023
  - **2019**
    - long: 2738
    - short: 3108
  - **2022**
    - long: 2503
    - short: 3442

## T5 Robustezza della primaria
- **bootstrap_settimane**
  - settimane: 8
  - media: -0.01074
  - ic90_lo: -0.3549
  - ic90_hi: 0.2721
  - n_replicati: 10000
- **senza_i_migliori_3**
  - n: 6
  - media_R: -0.2307
  - pf_netto: 0.3395
- **con_tutti**
  - n: 9
  - media_R: -0.01074
  - pf_netto: 0.9539
- **leave_one_period_out**
  - **2015**
    - n: 6
    - media_R: -0.1783
    - pf_netto: 0.4896
  - **2017**
    - n: 7
    - media_R: 0.1428
    - pf_netto: 1.999
  - **2019**
    - n: 8
    - media_R: -0.05055
    - pf_netto: 0.8071
  - **2022**
    - n: 6
    - media_R: 0.03082
    - pf_netto: 1.169
- **quota_profitto_per_periodo**
  - 2015: -
  - 2017: -
  - 2019: -
  - 2022: -
- **spread_x1.5**
  - n: 9
  - media_R: -0.03095
  - pf_netto: 0.8671
- **escluso_spread0**
  - n: 6
  - media_R: 0.03082
  - pf_netto: 1.169

## T6 Sensibilita (riportate per intero, non selezionabili)
| sens | segnali | n | win_pct | pf_netto | attesa_R | netto_R | dd_max_R |
|---|---|---|---|---|---|---|---|
| Sa | 11 | 10 | 70 | 1.094 | 0.0196 | 0.196 | 1.157 |
| Sb | 10 | 9 | 66.67 | 0.9539 | -0.01074 | -0.09668 | 1.45 |
| Sc | 10 | 9 | 66.67 | 0.9539 | -0.01074 | -0.09668 | 1.45 |
| Sd | 10 | 9 | 66.67 | 0.8671 | -0.03095 | -0.2785 | 1.46 |
| Se20 | 10 | 9 | 66.67 | 0.9539 | -0.01074 | -0.09668 | 1.45 |
| Se50 | 10 | 9 | 66.67 | 0.9539 | -0.01074 | -0.09668 | 1.45 |
| Sf | 9 | 7 | 57.14 | 0.5355 | -0.1391 | -0.9736 | 1.757 |
| Sg | 11 | 9 | 66.67 | 0.9539 | -0.01074 | -0.09668 | 1.45 |

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
  - buy_and_hold_in_ATR: -1.454
  - atr_mediana_prezzo: 0.1589
  - **long**
    - n: 1
    - media_R: 0.07608
  - **short**
    - n: 2
    - media_R: 0.4485
- **2017**
  - buy_and_hold_in_ATR: -25.26
  - atr_mediana_prezzo: 0.1617
  - **long**
    - n: 0
    - media_R: -
  - **short**
    - n: 2
    - media_R: -0.548
- **2019**
  - buy_and_hold_in_ATR: -7.135
  - atr_mediana_prezzo: 0.1022
  - **long**
    - n: 1
    - media_R: 0.3077
  - **short**
    - n: 0
    - media_R: -
- **2022**
  - buy_and_hold_in_ATR: 70.03
  - atr_mediana_prezzo: 0.2284
  - **long**
    - n: 1
    - media_R: 0.3799
  - **short**
    - n: 2
    - media_R: -0.3307

## T9 Dati / esecuzione
- **spread0_sostituiti_per_periodo**
  - 2015: 4738
  - 2017: 39211
  - 2019: 0
  - 2022: 220114
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
  - trade_spread0_ingresso: 3
  - trade_spread0_uscita: 3
  - gap_ingresso_max_min: 0
  - trade_con_gap_ingresso_gt_0: 0
  - trade_chiusi_fine_dati: 0
  - uscite_a_mercato_target_superato: 1
  - ricalcoli_target_totali: 27
  - eventi_sl_tp_stesso_minuto: 0
  - **segnali_scartati**
    - scartati_posizione_aperta: 0
    - scartati_target_oltre_ingresso: 1
    - scartati_indicatori_non_pronti: 0
    - scartati_no_barra_successiva: 0
    - scartati_gap_ingresso: 0
  - segnali_totali: 10
  - tocchi_penetrazione_lt_spread_sui_segnali: 0
  - coppie_CONT_INV_stesso_episodio: 0

## Log dei trade
Schedule completa dei target per ogni trade nel JSON (chiave tabelle.LOG_TRADE).
