# Breaking Band su GBPUSD — risultati (generato da run_test.py)

sha256 dei risultati (JSON canonico): `c584b01277cfe16e3c5e64227143fec7d03c7967f79b50f438becb56e4d252a5`

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
  - 2015: 364d2437e8fb8295813c744a47487633b42db7347f5682c0ac5392d601f1a120
  - 2017: 5e3c03d17de9a40df353d2f2efbbb9524dafef4ad63bac654511d96dcd538d6a
  - 2019: 6b89831c00a855ef9753045babbf84cf8bdac5314bfa98c21faca01d3f48b476
  - 2022: 99b86646c0d92d60dd75c9b6464166bddc4586aca959f579ae8df2519d5e630c
- **righe_csv**
  - 2015: 370876
  - 2017: 370247
  - 2019: 371476
  - 2022: 372704
- simbolo: GBPUSD
- punto: 1e-05
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
  - ABTG_M1_GBPUSD_2015.csv: True
  - ABTG_M1_GBPUSD_2017.csv: True
  - ABTG_M1_GBPUSD_2019.csv: True
  - ABTG_M1_GBPUSD_2022.csv: True
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
- media_R: -0.2533
- pf_netto: 0.392
- p_B1: 0.9595
- **ic90**
  - settimane: 12
  - media: -0.2533
  - ic90_lo: -0.5692
  - ic90_hi: 0.0494
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
  - GBPUSD: ambito dichiarato dalla Guida (MAJOR/MINOR, D1/H4/H1/M30) da verificare per il simbolo; M15 non ammesso e non testato
  - Guida usata = 'versione didattica' non confermata come Guida Operativa 11 ufficiale; mancano Dichiarazione di Test e screenshot
  - stop 3 ATR, target SMA20, ricalcolo 3 ore da Guida/Protocolli; soglie 'molto/ordinato' sono interpretazioni (specifica sez. 8); pattern testati = soprainsieme dei validi
  - dati del solo simbolo GBPUSD; i 4 periodi sono 4 regimi; N per cella in T2
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
| C0_tocco_banda_opposta | 18 | 35.29 | T_MAX |
| C3_sequenza | 16 | 88.89 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 7 | 43.75 | T_MAX |
| C1b_candela_test_non_impulsiva | 3 | 42.86 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 31, "-1": 25}; fine episodi: {"BAND_RIDING": 40, "FINE_DATI": 1, "OPPOSTO": 3, "T_MAX": 12}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 10, "episodi_seq_violata_su_barra_di_tocco": 2, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 62 | - | BAND_RIDING |
| finestra | 56 | 90.32 | BAND_RIDING |
| C0_tocco_banda_opposta | 23 | 41.07 | T_MAX |
| C3_sequenza | 19 | 82.61 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 10 | 52.63 | T_MAX |
| C1b_candela_test_non_impulsiva | 4 | 40 | - |
| sd<S50 | 4 | 100 | - |
| sd<=sd[-3] | 4 | 100 | - |
| SEGNALE | 4 | 100 | - |
Segnali e trade: {"eseguiti": 4, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 4}

Armati: {"+1": 34, "-1": 28}; fine episodi: {"BAND_RIDING": 39, "OPPOSTO": 3, "T_MAX": 20}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 9, "episodi_seq_violata_su_barra_di_tocco": 6, "segnali_con_impulsiva_1.0_violata": 4, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 65 | - | BAND_RIDING |
| finestra | 52 | 80 | BAND_RIDING |
| C0_tocco_banda_opposta | 26 | 50 | T_MAX |
| C3_sequenza | 20 | 76.92 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 6 | 30 | T_MAX |
| C1b_candela_test_non_impulsiva | 3 | 50 | - |
| sd<S50 | 3 | 100 | T_MAX |
| sd<=sd[-3] | 2 | 66.67 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 32, "-1": 33}; fine episodi: {"BAND_RIDING": 42, "FINE_DATI": 1, "OPPOSTO": 3, "T_MAX": 19}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 20, "episodi_seq_violata_su_barra_di_tocco": 8, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 56 | - | BAND_RIDING |
| finestra | 48 | 85.71 | BAND_RIDING |
| C0_tocco_banda_opposta | 22 | 45.83 | BAND_RIDING |
| C3_sequenza | 20 | 90.91 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 4 | 20 | OPPOSTO |
| C1b_candela_test_non_impulsiva | 2 | 50 | - |
| sd<S50 | 2 | 100 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 23, "-1": 33}; fine episodi: {"BAND_RIDING": 33, "OPPOSTO": 2, "T_MAX": 21}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 9, "episodi_seq_violata_su_barra_di_tocco": 5, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 239 | - | BAND_RIDING |
| finestra | 207 | 86.61 | BAND_RIDING |
| C0_tocco_banda_opposta | 89 | 43 | T_MAX |
| C3_sequenza | 75 | 84.27 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 27 | 36 | T_MAX |
| C1b_candela_test_non_impulsiva | 12 | 44.44 | - |
| sd<S50 | 12 | 100 | T_MAX |
| sd<=sd[-3] | 11 | 91.67 | - |
| SEGNALE | 11 | 100 | - |
Segnali e trade: {"eseguiti": 11, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 11}

Armati: {"+1": 120, "-1": 119}; fine episodi: {"BAND_RIDING": 154, "FINE_DATI": 2, "OPPOSTO": 11, "T_MAX": 72}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 48, "episodi_seq_violata_su_barra_di_tocco": 21, "segnali_con_impulsiva_1.0_violata": 10, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 56 | - | BAND_RIDING |
| finestra | 51 | 91.07 | BAND_RIDING |
| I0_mediana_toccata | 36 | 70.59 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 11 | 30.56 | BAND_RIDING |
| retest_banda_impulso | 2 | 18.18 | T_MAX |
| I2_nessuna_impulsiva | 1 | 50 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 31, "-1": 25}; fine episodi: {"BAND_RIDING": 40, "FINE_DATI": 1, "OPPOSTO": 3, "T_MAX": 12}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 62 | - | BAND_RIDING |
| finestra | 56 | 90.32 | BAND_RIDING |
| I0_mediana_toccata | 42 | 75 | T_MAX |
| I1_banda_opposta_mai_toccata | 12 | 28.57 | T_MAX |
| retest_banda_impulso | 4 | 33.33 | BAND_RIDING |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 4, "a": 0}]

Armati: {"+1": 34, "-1": 28}; fine episodi: {"BAND_RIDING": 39, "OPPOSTO": 3, "T_MAX": 20}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 65 | - | BAND_RIDING |
| finestra | 52 | 80 | BAND_RIDING |
| I0_mediana_toccata | 34 | 65.38 | T_MAX |
| I1_banda_opposta_mai_toccata | 11 | 32.35 | BAND_RIDING |
| retest_banda_impulso | 5 | 45.45 | T_MAX |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 5, "a": 0}]

Armati: {"+1": 32, "-1": 33}; fine episodi: {"BAND_RIDING": 42, "FINE_DATI": 1, "OPPOSTO": 3, "T_MAX": 19}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 56 | - | BAND_RIDING |
| finestra | 48 | 85.71 | BAND_RIDING |
| I0_mediana_toccata | 34 | 70.83 | T_MAX |
| I1_banda_opposta_mai_toccata | 15 | 44.12 | T_MAX |
| retest_banda_impulso | 8 | 53.33 | BAND_RIDING |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 8, "a": 0}]

Armati: {"+1": 23, "-1": 33}; fine episodi: {"BAND_RIDING": 33, "OPPOSTO": 2, "T_MAX": 21}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 239 | - | BAND_RIDING |
| finestra | 207 | 86.61 | BAND_RIDING |
| I0_mediana_toccata | 146 | 70.53 | T_MAX |
| I1_banda_opposta_mai_toccata | 49 | 33.56 | T_MAX |
| retest_banda_impulso | 19 | 38.78 | T_MAX |
| I2_nessuna_impulsiva | 1 | 5.263 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 19, "a": 1}]

Armati: {"+1": 120, "-1": 119}; fine episodi: {"BAND_RIDING": 154, "FINE_DATI": 2, "OPPOSTO": 11, "T_MAX": 72}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 162 | - | BAND_RIDING |
| finestra | 147 | 90.74 | BAND_RIDING |
| C0_tocco_banda_opposta | 71 | 48.3 | T_MAX |
| C3_sequenza | 60 | 84.51 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 33 | 55 | T_MAX |
| C1b_candela_test_non_impulsiva | 25 | 75.76 | - |
| sd<S50 | 25 | 100 | T_MAX |
| sd<=sd[-3] | 24 | 96 | - |
| SEGNALE | 24 | 100 | - |
Segnali e trade: {"eseguiti": 23, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 1, "segnali": 24}

Armati: {"+1": 73, "-1": 89}; fine episodi: {"BAND_RIDING": 69, "FINE_DATI": 1, "OPPOSTO": 13, "T_MAX": 79}; extra: {"episodi_consumati_tocco_precoce": 2, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 17, "episodi_seq_violata_su_barra_di_tocco": 13, "segnali_con_impulsiva_1.0_violata": 23, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 1}

### CONT_M30 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 153 | - | BAND_RIDING |
| finestra | 141 | 92.16 | BAND_RIDING |
| C0_tocco_banda_opposta | 64 | 45.39 | T_MAX |
| C3_sequenza | 55 | 85.94 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 21 | 38.18 | T_MAX |
| C1b_candela_test_non_impulsiva | 15 | 71.43 | - |
| sd<S50 | 15 | 100 | T_MAX |
| sd<=sd[-3] | 12 | 80 | - |
| SEGNALE | 12 | 100 | - |
Segnali e trade: {"eseguiti": 12, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 12}

Armati: {"+1": 81, "-1": 72}; fine episodi: {"BAND_RIDING": 80, "OPPOSTO": 13, "T_MAX": 60}; extra: {"episodi_consumati_tocco_precoce": 3, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 27, "episodi_seq_violata_su_barra_di_tocco": 9, "segnali_con_impulsiva_1.0_violata": 10, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 157 | - | BAND_RIDING |
| finestra | 148 | 94.27 | BAND_RIDING |
| C0_tocco_banda_opposta | 65 | 43.92 | T_MAX |
| C3_sequenza | 59 | 90.77 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 21 | 35.59 | T_MAX |
| C1b_candela_test_non_impulsiva | 11 | 52.38 | - |
| sd<S50 | 11 | 100 | T_MAX |
| sd<=sd[-3] | 8 | 72.73 | - |
| SEGNALE | 8 | 100 | - |
Segnali e trade: {"eseguiti": 7, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 1, "segnali": 8}

Armati: {"+1": 77, "-1": 80}; fine episodi: {"BAND_RIDING": 70, "FINE_DATI": 1, "OPPOSTO": 18, "T_MAX": 68}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 2, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 29, "episodi_seq_violata_su_barra_di_tocco": 10, "segnali_con_impulsiva_1.0_violata": 8, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 145 | - | BAND_RIDING |
| finestra | 126 | 86.9 | BAND_RIDING |
| C0_tocco_banda_opposta | 56 | 44.44 | T_MAX |
| C3_sequenza | 51 | 91.07 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 29 | 56.86 | T_MAX |
| C1b_candela_test_non_impulsiva | 24 | 82.76 | BAND_RIDING |
| sd<S50 | 22 | 91.67 | T_MAX |
| sd<=sd[-3] | 20 | 90.91 | - |
| SEGNALE | 20 | 100 | - |
Segnali e trade: {"eseguiti": 20, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 20}

Armati: {"+1": 66, "-1": 79}; fine episodi: {"BAND_RIDING": 79, "OPPOSTO": 5, "T_MAX": 61}; extra: {"episodi_consumati_tocco_precoce": 3, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 23, "episodi_seq_violata_su_barra_di_tocco": 6, "segnali_con_impulsiva_1.0_violata": 15, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 617 | - | BAND_RIDING |
| finestra | 562 | 91.09 | BAND_RIDING |
| C0_tocco_banda_opposta | 256 | 45.55 | T_MAX |
| C3_sequenza | 225 | 87.89 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 104 | 46.22 | T_MAX |
| C1b_candela_test_non_impulsiva | 75 | 72.12 | BAND_RIDING |
| sd<S50 | 73 | 97.33 | T_MAX |
| sd<=sd[-3] | 64 | 87.67 | - |
| SEGNALE | 64 | 100 | - |
Segnali e trade: {"eseguiti": 62, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 2, "segnali": 64}

Armati: {"+1": 297, "-1": 320}; fine episodi: {"BAND_RIDING": 298, "FINE_DATI": 2, "OPPOSTO": 49, "T_MAX": 268}; extra: {"episodi_consumati_tocco_precoce": 9, "episodi_eliminati_solo_da_SEQ": 3, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 96, "episodi_seq_violata_su_barra_di_tocco": 38, "segnali_con_impulsiva_1.0_violata": 56, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 1}

### INV_M30 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 162 | - | BAND_RIDING |
| finestra | 147 | 90.74 | BAND_RIDING |
| I0_mediana_toccata | 120 | 81.63 | T_MAX |
| I1_banda_opposta_mai_toccata | 16 | 13.33 | T_MAX |
| retest_banda_impulso | 3 | 18.75 | BAND_RIDING |
| I2_nessuna_impulsiva | 2 | 66.67 | - |
| I3_banda_piatta | 2 | 100 | - |
| sd<S50 | 2 | 100 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 1, "segnali": 2}

Armati: {"+1": 73, "-1": 89}; fine episodi: {"BAND_RIDING": 69, "FINE_DATI": 1, "OPPOSTO": 13, "T_MAX": 79}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 1}

### INV_M30 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 153 | - | BAND_RIDING |
| finestra | 141 | 92.16 | BAND_RIDING |
| I0_mediana_toccata | 103 | 73.05 | T_MAX |
| I1_banda_opposta_mai_toccata | 22 | 21.36 | T_MAX |
| retest_banda_impulso | 3 | 13.64 | T_MAX |
| I2_nessuna_impulsiva | 1 | 33.33 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 81, "-1": 72}; fine episodi: {"BAND_RIDING": 80, "OPPOSTO": 13, "T_MAX": 60}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 157 | - | BAND_RIDING |
| finestra | 148 | 94.27 | BAND_RIDING |
| I0_mediana_toccata | 108 | 72.97 | T_MAX |
| I1_banda_opposta_mai_toccata | 17 | 15.74 | T_MAX |
| retest_banda_impulso | 4 | 23.53 | T_MAX |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 4, "a": 0}]

Armati: {"+1": 77, "-1": 80}; fine episodi: {"BAND_RIDING": 70, "FINE_DATI": 1, "OPPOSTO": 18, "T_MAX": 68}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 145 | - | BAND_RIDING |
| finestra | 126 | 86.9 | BAND_RIDING |
| I0_mediana_toccata | 98 | 77.78 | T_MAX |
| I1_banda_opposta_mai_toccata | 32 | 32.65 | T_MAX |
| retest_banda_impulso | 9 | 28.12 | T_MAX |
| I2_nessuna_impulsiva | 3 | 33.33 | - |
| I3_banda_piatta | 3 | 100 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 66, "-1": 79}; fine episodi: {"BAND_RIDING": 79, "OPPOSTO": 5, "T_MAX": 61}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 617 | - | BAND_RIDING |
| finestra | 562 | 91.09 | BAND_RIDING |
| I0_mediana_toccata | 429 | 76.33 | T_MAX |
| I1_banda_opposta_mai_toccata | 87 | 20.28 | T_MAX |
| retest_banda_impulso | 19 | 21.84 | T_MAX |
| I2_nessuna_impulsiva | 6 | 31.58 | - |
| I3_banda_piatta | 6 | 100 | - |
| sd<S50 | 6 | 100 | - |
| sd<=sd[-3] | 6 | 100 | - |
| SEGNALE | 6 | 100 | - |
Segnali e trade: {"eseguiti": 5, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 1, "segnali": 6}

Armati: {"+1": 297, "-1": 320}; fine episodi: {"BAND_RIDING": 298, "FINE_DATI": 2, "OPPOSTO": 49, "T_MAX": 268}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 6, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 1}

## T2 Risultati per variante x TF x periodo
| cella | n | win_pct | pf_lordo | pf_netto | attesa_R | mediana_R | netto_R | dd_max_R | costo_spread_medio_R | D_medio_atr | pareggio_atteso_medio_pct | wr0_pct | durata_mediana_barre | durata_max_barre | quota_long |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CONT_H1_2015 | 3 | 66.67 | 0.7052 | 0.6294 | -0.1235 | 0.1729 | -0.3706 | 1 | 0.02891 | 1.532 | 68.93 | 66.86 | 5 | 8 | 0.3333 |
| CONT_H1_2017 | 4 | 25 | 0.169 | 0.1413 | -0.6441 | -1 | -2.576 | 2.576 | 0.0868 | 0.9753 | 80.92 | 77.36 | 4.5 | 10 | 0.25 |
| CONT_H1_2019 | 2 | 100 | inf | inf | 0.2693 | 0.2693 | 0.5387 | 0 | 0.03571 | 0.9219 | 79.76 | 76.5 | 5 | 8 | 0 |
| CONT_H1_2022 | 2 | 50 | 0.2271 | 0.2237 | -0.3882 | -0.3882 | -0.7763 | 1 | 0.002818 | 1.552 | 68.62 | 68.47 | 6.5 | 12 | 0 |
| CONT_H1_TOTALE | 11 | 54.55 | 0.4241 | 0.3631 | -0.2895 | 0.1729 | -3.184 | 3.357 | 0.04645 | 1.222 | 75.21 | 72.72 | 5 | 12 | 0.1818 |
| INV_H1_2015 | 1 | 100 | inf | inf | 0.1446 | 0.1446 | 0.1446 | 0 | 0.0322 | 0.4339 | 90.18 | 87.36 | 1 | 1 | 0 |
| INV_H1_2017 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2019 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2022 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_TOTALE | 1 | 100 | inf | inf | 0.1446 | 0.1446 | 0.1446 | 0 | 0.0322 | 0.4339 | 90.18 | 87.36 | 1 | 1 | 0 |
| POOLED_H1 | 12 | 58.33 | 0.4622 | 0.392 | -0.2533 | 0.1588 | -3.04 | 3.357 | 0.04526 | 1.157 | 76.45 | 73.94 | 4.5 | 12 | 0.1667 |
| CONT_M30_2015 | 23 | 78.26 | 1.656 | 1.363 | 0.05531 | 0.2248 | 1.272 | 1.574 | 0.0394 | 1.036 | 79.08 | 75.75 | 8 | 23 | 0.3478 |
| CONT_M30_2017 | 12 | 91.67 | 3.132 | 2.578 | 0.1315 | 0.2183 | 1.578 | 1 | 0.03723 | 0.7639 | 83.46 | 80.15 | 5 | 12 | 0.5 |
| CONT_M30_2019 | 7 | 71.43 | 1.314 | 0.987 | -0.001887 | 0.08613 | -0.01321 | 1 | 0.04566 | 0.8121 | 84.21 | 79.83 | 7 | 11 | 0.2857 |
| CONT_M30_2022 | 20 | 70 | 1.279 | 1.112 | 0.01508 | 0.1458 | 0.3015 | 2.438 | 0.0194 | 1.025 | 77.81 | 75.91 | 7.5 | 21 | 0.7 |
| CONT_M30_TOTALE | 62 | 77.42 | 1.674 | 1.382 | 0.05062 | 0.1715 | 3.138 | 3.009 | 0.03324 | 0.9543 | 80.1 | 77.11 | 7 | 23 | 0.4839 |
| INV_M30_2015 | 1 | 100 | inf | inf | 0.3044 | 0.3044 | 0.3044 | 0 | 0.02537 | 0.9132 | 78.61 | 76.66 | 2 | 2 | 0 |
| INV_M30_2017 | 1 | 100 | inf | inf | 0.1913 | 0.1913 | 0.1913 | 0 | 0.07682 | 0.5739 | 84.4 | 83.94 | 1 | 1 | 0 |
| INV_M30_2019 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_M30_2022 | 3 | 66.67 | 7.172 | 6.726 | 0.1199 | 0.086 | 0.3597 | 0.06282 | 0.003682 | 1.005 | 76.51 | 74.92 | 11 | 17 | 0.3333 |
| INV_M30_TOTALE | 5 | 80 | 17.13 | 14.62 | 0.1711 | 0.1913 | 0.8554 | 0.06282 | 0.02265 | 0.9001 | 78.51 | 77.07 | 4 | 17 | 0.2 |
| POOLED_M30 | 67 | 77.61 | 1.793 | 1.482 | 0.05961 | 0.1776 | 3.994 | 2.735 | 0.03245 | 0.9502 | 79.98 | 77.11 | 7 | 23 | 0.4627 |

Uscite per motivo e altri conteggi:
- CONT_H1_2015: motivi {"SL": 1, "TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2017: motivi {"SL": 3, "TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2019: motivi {"TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2022: motivi {"SL": 1, "TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_TOTALE: motivi {"SL": 5, "TP": 6}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2015: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2017: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2019: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2022: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_TOTALE: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- POOLED_H1: motivi {"SL": 5, "TP": 7}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2015: motivi {"MKT": 1, "SL": 3, "TP": 19}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_M30_2017: motivi {"SL": 1, "TP": 11}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- CONT_M30_2019: motivi {"SL": 1, "TP": 6}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2022: motivi {"SL": 2, "TP": 18}; SL+TP stesso minuto 0; spread0 7; fine_dati/mkt 0
- CONT_M30_TOTALE: motivi {"MKT": 1, "SL": 7, "TP": 54}; SL+TP stesso minuto 0; spread0 8; fine_dati/mkt 1
- INV_M30_2015: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2017: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2019: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_M30_2022: motivi {"TP": 3}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 0
- INV_M30_TOTALE: motivi {"TP": 5}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 0
- POOLED_M30: motivi {"MKT": 1, "SL": 7, "TP": 59}; SL+TP stesso minuto 0; spread0 11; fine_dati/mkt 1

## T3 Fasce (stratificazione, descrittori)
- **pooled**
  - **fascia**
    - **Buono**
      - n: 4
      - vincite: 3
      - long: 1
    - **Medio**
      - n: 6
      - vincite: 4
      - long: 1
    - **Ottimo**
      - n: 2
      - vincite: 0
      - long: 0
  - **fascia_accorpata**
    - **<70**
      - n: 6
      - vincite: 4
      - long: 1
    - **>=70**
      - n: 6
      - vincite: 3
      - long: 1
  - **n_prev**
    - **0**
      - n: 7
      - vincite: 4
      - long: 0
    - **1**
      - n: 4
      - vincite: 3
      - long: 2
    - **>=2**
      - n: 1
      - vincite: 0
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 10
      - vincite: 7
      - long: 2
      - wr_pct: 70
      - media_R: -0.104
      - wr0_pct: 76.61
      - nota: N<30: solo descrittivo
    - **si**
      - n: 2
      - vincite: 0
      - long: 0
  - **checklist_stretta**
    - **no**
      - n: 11
      - vincite: 7
      - long: 2
      - wr_pct: 63.64
      - media_R: -0.1854
      - wr0_pct: 74.66
      - nota: N<30: solo descrittivo
    - **si**
      - n: 1
      - vincite: 0
      - long: 0
  - **lato**
    - **long**
      - n: 2
      - vincite: 1
      - long: 2
    - **short**
      - n: 10
      - vincite: 6
      - long: 0
      - wr_pct: 60
      - media_R: -0.2213
      - wr0_pct: 73.99
      - nota: N<30: solo descrittivo
  - **periodo**
    - **2015**
      - n: 4
      - vincite: 3
      - long: 1
    - **2017**
      - n: 4
      - vincite: 1
      - long: 1
    - **2019**
      - n: 2
      - vincite: 2
      - long: 0
    - **2022**
      - n: 2
      - vincite: 1
      - long: 0
  - **fascia_oraria_server**
    - **0-7**
      - n: 6
      - vincite: 3
      - long: 1
    - **8-15**
      - n: 6
      - vincite: 4
      - long: 1
- **CONT**
  - **fascia**
    - **Buono**
      - n: 3
      - vincite: 2
      - long: 1
    - **Medio**
      - n: 6
      - vincite: 4
      - long: 1
    - **Ottimo**
      - n: 2
      - vincite: 0
      - long: 0
  - **fascia_accorpata**
    - **<70**
      - n: 6
      - vincite: 4
      - long: 1
    - **>=70**
      - n: 5
      - vincite: 2
      - long: 1
  - **n_prev**
    - **0**
      - n: 6
      - vincite: 3
      - long: 0
    - **1**
      - n: 4
      - vincite: 3
      - long: 2
    - **>=2**
      - n: 1
      - vincite: 0
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 9
      - vincite: 6
      - long: 2
    - **si**
      - n: 2
      - vincite: 0
      - long: 0
  - **checklist_stretta**
    - **no**
      - n: 10
      - vincite: 6
      - long: 2
      - wr_pct: 60
      - media_R: -0.2184
      - wr0_pct: 73.39
      - nota: N<30: solo descrittivo
    - **si**
      - n: 1
      - vincite: 0
      - long: 0
  - **lato**
    - **long**
      - n: 2
      - vincite: 1
      - long: 2
    - **short**
      - n: 9
      - vincite: 5
      - long: 0
  - **periodo**
    - **2015**
      - n: 3
      - vincite: 2
      - long: 1
    - **2017**
      - n: 4
      - vincite: 1
      - long: 1
    - **2019**
      - n: 2
      - vincite: 2
      - long: 0
    - **2022**
      - n: 2
      - vincite: 1
      - long: 0
  - **fascia_oraria_server**
    - **0-7**
      - n: 6
      - vincite: 3
      - long: 1
    - **8-15**
      - n: 5
      - vincite: 3
      - long: 1
- **INV**
  - **fascia**
    - **Buono**
      - n: 1
      - vincite: 1
      - long: 0
  - **fascia_accorpata**
    - **>=70**
      - n: 1
      - vincite: 1
      - long: 0
  - **n_prev**
    - **0**
      - n: 1
      - vincite: 1
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 1
      - vincite: 1
      - long: 0
  - **checklist_stretta**
    - **no**
      - n: 1
      - vincite: 1
      - long: 0
  - **lato**
    - **short**
      - n: 1
      - vincite: 1
      - long: 0
  - **periodo**
    - **2015**
      - n: 1
      - vincite: 1
      - long: 0
  - **fascia_oraria_server**
    - **8-15**
      - n: 1
      - vincite: 1
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
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: -0.2533
    - media_nulla: 0.01682
    - p5: -0.2373
    - p50: 0.02854
    - p95: 0.2442
    - percentile_osservato: 0.0405
    - p_B: 0.9595
    - pf_nullo_p50: 1.165
    - pf_osservato: 0.392
  - **variante_CONT**
    - n_trade: 11
    - n_abbinati: 11
    - media_osservata_R: -0.2895
    - media_nulla: 0.01792
    - p5: -0.2563
    - p50: 0.02702
    - p95: 0.2593
    - percentile_osservato: 0.0345
    - p_B: 0.9655
    - pf_nullo_p50: 1.145
    - pf_osservato: 0.3631
  - **variante_INV**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.1446
    - media_nulla: 0.004724
    - p5: -1
    - p50: 0.1356
    - p95: 0.1625
    - percentile_osservato: 0.7315
    - p_B: 0.2689
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2015**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: -0.05648
    - media_nulla: 0.007802
    - p5: -0.4486
    - p50: 0.01451
    - p95: 0.3682
    - percentile_osservato: 0.375
    - p_B: 0.6252
    - pf_nullo_p50: 1.071
    - pf_osservato: 0.7741
  - **periodo_2017**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: -0.6441
    - media_nulla: -0.009443
    - p5: -0.4333
    - p50: -0.04689
    - p95: 0.3022
    - percentile_osservato: 0.01
    - p_B: 0.99
    - pf_nullo_p50: 0.8057
    - pf_osservato: 0.1413
  - **periodo_2019**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.2693
    - media_nulla: -0.04131
    - p5: -0.6528
    - p50: 0.1483
    - p95: 0.3168
    - percentile_osservato: 0.7755
    - p_B: 0.2249
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2022**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.3882
    - media_nulla: 0.1455
    - p5: -0.3451
    - p50: 0.2632
    - p95: 0.481
    - percentile_osservato: 0.042
    - p_B: 0.958
    - pf_nullo_p50: -
    - pf_osservato: 0.2237
  - **lato_long**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.4135
    - media_nulla: 0.05759
    - p5: -0.5077
    - p50: 0.2252
    - p95: 0.3573
    - percentile_osservato: 0.0735
    - p_B: 0.9265
    - pf_nullo_p50: -
    - pf_osservato: 0.1729
  - **lato_short**
    - n_trade: 10
    - n_abbinati: 10
    - media_osservata_R: -0.2213
    - media_nulla: 0.008663
    - p5: -0.2639
    - p50: 0.01783
    - p95: 0.2594
    - percentile_osservato: 0.087
    - p_B: 0.913
    - pf_nullo_p50: 1.097
    - pf_osservato: 0.4468
- **B0**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: -0.2533
    - media_nulla: 0.004613
    - p5: -0.2345
    - p50: 0.01194
    - p95: 0.2159
    - percentile_osservato: 0.0335
    - p_B: 0.9665
    - pf_nullo_p50: 1.067
    - pf_osservato: 0.392
  - **variante_CONT**
    - n_trade: 11
    - n_abbinati: 11
    - media_osservata_R: -0.2895
    - media_nulla: 0.008308
    - p5: -0.2527
    - p50: 0.01692
    - p95: 0.233
    - percentile_osservato: 0.026
    - p_B: 0.974
    - pf_nullo_p50: 1.113
    - pf_osservato: 0.3631
  - **variante_INV**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.1446
    - media_nulla: -0.03604
    - p5: -1
    - p50: 0.1337
    - p95: 0.1631
    - percentile_osservato: 0.699
    - p_B: 0.3013
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2015**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: -0.05648
    - media_nulla: 0.007964
    - p5: -0.4203
    - p50: 0.02046
    - p95: 0.3186
    - percentile_osservato: 0.3945
    - p_B: 0.6057
    - pf_nullo_p50: 1.108
    - pf_osservato: 0.7741
  - **periodo_2017**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: -0.6441
    - media_nulla: 0.001216
    - p5: -0.4399
    - p50: 0.0344
    - p95: 0.282
    - percentile_osservato: 0.0075
    - p_B: 0.9925
    - pf_nullo_p50: 1.614
    - pf_osservato: 0.1413
  - **periodo_2019**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.2693
    - media_nulla: -0.06847
    - p5: -0.6555
    - p50: 0.09671
    - p95: 0.3072
    - percentile_osservato: 0.8495
    - p_B: 0.1509
    - pf_nullo_p50: 19.14
    - pf_osservato: inf
  - **periodo_2022**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.3882
    - media_nulla: 0.07779
    - p5: -0.4846
    - p50: 0.184
    - p95: 0.4662
    - percentile_osservato: 0.1415
    - p_B: 0.8586
    - pf_nullo_p50: -
    - pf_osservato: 0.2237
  - **lato_long**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.4135
    - media_nulla: 0.05178
    - p5: -0.4637
    - p50: 0.1606
    - p95: 0.3424
    - percentile_osservato: 0.089
    - p_B: 0.911
    - pf_nullo_p50: -
    - pf_osservato: 0.1729
  - **lato_short**
    - n_trade: 10
    - n_abbinati: 10
    - media_osservata_R: -0.2213
    - media_nulla: -0.00482
    - p5: -0.267
    - p50: 0.001129
    - p95: 0.2303
    - percentile_osservato: 0.0875
    - p_B: 0.9125
    - pf_nullo_p50: 1.006
    - pf_osservato: 0.4468
- **B2**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: -0.2533
    - media_nulla: 0.04099
    - p5: -0.1799
    - p50: 0.04868
    - p95: 0.2204
    - percentile_osservato: 0.0125
    - p_B: 0.9875
    - pf_nullo_p50: 1.435
    - pf_osservato: 0.392
  - **variante_CONT**
    - n_trade: 11
    - n_abbinati: 11
    - media_osservata_R: -0.2895
    - media_nulla: 0.04654
    - p5: -0.1762
    - p50: 0.05851
    - p95: 0.2355
    - percentile_osservato: 0.008
    - p_B: 0.992
    - pf_nullo_p50: 1.523
    - pf_osservato: 0.3631
  - **variante_INV**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.1446
    - media_nulla: -0.02016
    - p5: -1
    - p50: 0.1313
    - p95: 0.1654
    - percentile_osservato: 0.6265
    - p_B: 0.3738
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2015**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: -0.05648
    - media_nulla: -0.01249
    - p5: -0.4394
    - p50: 0.008936
    - p95: 0.3023
    - percentile_osservato: 0.4215
    - p_B: 0.5787
    - pf_nullo_p50: 1.042
    - pf_osservato: 0.7741
  - **periodo_2017**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: -0.6441
    - media_nulla: 0.01321
    - p5: -0.3377
    - p50: 0.06864
    - p95: 0.2576
    - percentile_osservato: 0
    - p_B: 1
    - pf_nullo_p50: 2.641
    - pf_osservato: 0.1413
  - **periodo_2019**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.2693
    - media_nulla: 0.08593
    - p5: -0.4557
    - p50: 0.1635
    - p95: 0.3122
    - percentile_osservato: 0.7895
    - p_B: 0.2109
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2022**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.3882
    - media_nulla: 0.1585
    - p5: -0.4213
    - p50: 0.2575
    - p95: 0.4711
    - percentile_osservato: 0.0785
    - p_B: 0.9215
    - pf_nullo_p50: -
    - pf_osservato: 0.2237
  - **lato_long**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.4135
    - media_nulla: 0.02251
    - p5: -0.4913
    - p50: 0.1171
    - p95: 0.3325
    - percentile_osservato: 0.118
    - p_B: 0.8821
    - pf_nullo_p50: -
    - pf_osservato: 0.1729
  - **lato_short**
    - n_trade: 10
    - n_abbinati: 10
    - media_osservata_R: -0.2213
    - media_nulla: 0.04468
    - p5: -0.194
    - p50: 0.05719
    - p95: 0.24
    - percentile_osservato: 0.0335
    - p_B: 0.9665
    - pf_nullo_p50: 1.529
    - pf_osservato: 0.4468
- **pool_barre_simulate**
  - **2015**
    - long: 2995
    - short: 2823
  - **2017**
    - long: 2716
    - short: 3118
  - **2019**
    - long: 3130
    - short: 2705
  - **2022**
    - long: 3134
    - short: 2800

## T5 Robustezza della primaria
- **bootstrap_settimane**
  - settimane: 12
  - media: -0.2533
  - ic90_lo: -0.5692
  - ic90_hi: 0.0494
  - n_replicati: 10000
- **senza_i_migliori_3**
  - n: 9
  - media_R: -0.471
  - pf_netto: 0.1522
- **con_tutti**
  - n: 12
  - media_R: -0.2533
  - pf_netto: 0.392
- **leave_one_period_out**
  - **2015**
    - n: 8
    - media_R: -0.3517
    - pf_netto: 0.2965
  - **2017**
    - n: 8
    - media_R: -0.05795
    - pf_netto: 0.7682
  - **2019**
    - n: 10
    - media_R: -0.3578
    - pf_netto: 0.2843
  - **2022**
    - n: 10
    - media_R: -0.2264
    - pf_netto: 0.4341
- **quota_profitto_per_periodo**
  - 2015: -
  - 2017: -
  - 2019: -
  - 2022: -
- **spread_x1.5**
  - n: 12
  - media_R: -0.2641
  - pf_netto: 0.3808
- **escluso_spread0**
  - n: 12
  - media_R: -0.2533
  - pf_netto: 0.392

## T6 Sensibilita (riportate per intero, non selezionabili)
| sens | segnali | n | win_pct | pf_netto | attesa_R | netto_R | dd_max_R |
|---|---|---|---|---|---|---|---|
| Sa | 12 | 12 | 58.33 | 0.392 | -0.2533 | -3.04 | 3.357 |
| Sb | 11 | 11 | 54.55 | 0.3631 | -0.2895 | -3.184 | 3.357 |
| Sc | 12 | 12 | 58.33 | 0.392 | -0.2533 | -3.04 | 3.357 |
| Sd | 12 | 12 | 58.33 | 0.3808 | -0.2641 | -3.169 | 3.476 |
| Se20 | 12 | 12 | 58.33 | 0.392 | -0.2533 | -3.04 | 3.357 |
| Se50 | 12 | 12 | 58.33 | 0.392 | -0.2533 | -3.04 | 3.357 |
| Sf | 8 | 8 | 62.5 | 0.4369 | -0.2112 | -1.689 | 2.007 |
| Sg | 14 | 14 | 64.29 | 0.5332 | -0.1667 | -2.334 | 3.357 |

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
  - buy_and_hold_in_ATR: -38.38
  - atr_mediana_prezzo: 0.002102
  - **long**
    - n: 1
    - media_R: 0.1729
  - **short**
    - n: 3
    - media_R: -0.133
- **2017**
  - buy_and_hold_in_ATR: 65.83
  - atr_mediana_prezzo: 0.001779
  - **long**
    - n: 1
    - media_R: -1
  - **short**
    - n: 3
    - media_R: -0.5254
- **2019**
  - buy_and_hold_in_ATR: 30.46
  - atr_mediana_prezzo: 0.001678
  - **long**
    - n: 0
    - media_R: -
  - **short**
    - n: 2
    - media_R: 0.2693
- **2022**
  - buy_and_hold_in_ATR: -61.96
  - atr_mediana_prezzo: 0.00232
  - **long**
    - n: 0
    - media_R: -
  - **short**
    - n: 2
    - media_R: -0.3882

## T9 Dati / esecuzione
- **spread0_sostituiti_per_periodo**
  - 2015: 63
  - 2017: 11877
  - 2019: 359
  - 2022: 123030
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
  - trade_spread0_ingresso: 0
  - trade_spread0_uscita: 0
  - gap_ingresso_max_min: 0
  - trade_con_gap_ingresso_gt_0: 0
  - trade_chiusi_fine_dati: 0
  - uscite_a_mercato_target_superato: 0
  - ricalcoli_target_totali: 13
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
