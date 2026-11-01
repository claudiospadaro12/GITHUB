# Breaking Band su USDJPY — risultati (generato da run_test.py)

sha256 dei risultati (JSON canonico): `68c3c4045aa7092fe86eff3c42f97aaf1940b038cb92e3fb3775784ec2126773`

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
  - 2013: 8f78987d09f97758e39de9fc8b5deccabfc29efd4734b5eeafa6cb816b166147
  - 2018: 6d530299ee8932d9b0f34a920dcce1ab09cb96b2a047aabaaa9b1a46f196809e
  - 2020: 9bedbc8e546458c4a7c8af3cddeaaeb2a2a0cdd3807b8065e43dc0f2eec4ab1b
  - 2025-26: d10668a991fea36f7af175085f21509e9ee24d4f0430cc9a77e2250e6f39e6d1
- **righe_csv**
  - 2013: 368682
  - 2018: 371938
  - 2020: 372985
  - 2025-26: 644463
- simbolo: USDJPY
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
  - ABTG_M1_USDJPY_2013.csv: True
  - ABTG_M1_USDJPY_2018.csv: True
  - ABTG_M1_USDJPY_2020.csv: True
  - ABTG_M1_USDJPY.csv: True
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
- N: 15
- media_R: 0.2789
- pf_netto: 5.183
- p_B1: 0.01799
- **ic90**
  - settimane: 15
  - media: 0.2789
  - ic90_lo: 0.09779
  - ic90_hi: 0.424
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
### CONT_H1 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 63 | - | BAND_RIDING |
| finestra | 55 | 87.3 | BAND_RIDING |
| C0_tocco_banda_opposta | 17 | 30.91 | - |
| C3_sequenza | 17 | 100 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 7 | 41.18 | T_MAX |
| C1b_candela_test_non_impulsiva | 3 | 42.86 | - |
| sd<S50 | 3 | 100 | T_MAX |
| sd<=sd[-3] | 1 | 33.33 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 38, "-1": 25}; fine episodi: {"BAND_RIDING": 43, "OPPOSTO": 4, "T_MAX": 16}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 10, "episodi_seq_violata_su_barra_di_tocco": 1, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 55 | - | BAND_RIDING |
| finestra | 48 | 87.27 | BAND_RIDING |
| C0_tocco_banda_opposta | 24 | 50 | T_MAX |
| C3_sequenza | 22 | 91.67 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 6 | 27.27 | T_MAX |
| C1b_candela_test_non_impulsiva | 3 | 50 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 27, "-1": 28}; fine episodi: {"BAND_RIDING": 37, "OPPOSTO": 2, "T_MAX": 16}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 6, "episodi_seq_violata_su_barra_di_tocco": 3, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 59 | - | BAND_RIDING |
| finestra | 53 | 89.83 | BAND_RIDING |
| C0_tocco_banda_opposta | 27 | 50.94 | BAND_RIDING |
| C3_sequenza | 25 | 92.59 | OPPOSTO |
| C1a_ritracciamento_non_impulsivo | 9 | 36 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 6 | 66.67 | - |
| sd<S50 | 6 | 100 | T_MAX |
| sd<=sd[-3] | 5 | 83.33 | - |
| SEGNALE | 5 | 100 | - |
Segnali e trade: {"eseguiti": 5, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 5}

Armati: {"+1": 27, "-1": 32}; fine episodi: {"BAND_RIDING": 34, "FINE_DATI": 1, "OPPOSTO": 9, "T_MAX": 15}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 15, "episodi_seq_violata_su_barra_di_tocco": 2, "segnali_con_impulsiva_1.0_violata": 5, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 102 | - | BAND_RIDING |
| finestra | 93 | 91.18 | BAND_RIDING |
| C0_tocco_banda_opposta | 27 | 29.03 | T_MAX |
| C3_sequenza | 25 | 92.59 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 13 | 52 | T_MAX |
| C1b_candela_test_non_impulsiva | 7 | 53.85 | T_MAX |
| sd<S50 | 5 | 71.43 | - |
| sd<=sd[-3] | 5 | 100 | - |
| SEGNALE | 5 | 100 | - |
Segnali e trade: {"eseguiti": 5, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 5}

Armati: {"+1": 51, "-1": 51}; fine episodi: {"BAND_RIDING": 72, "OPPOSTO": 3, "T_MAX": 27}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 9, "episodi_seq_violata_su_barra_di_tocco": 2, "segnali_con_impulsiva_1.0_violata": 5, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 279 | - | BAND_RIDING |
| finestra | 249 | 89.25 | BAND_RIDING |
| C0_tocco_banda_opposta | 95 | 38.15 | T_MAX |
| C3_sequenza | 89 | 93.68 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 35 | 39.33 | T_MAX |
| C1b_candela_test_non_impulsiva | 19 | 54.29 | T_MAX |
| sd<S50 | 17 | 89.47 | T_MAX |
| sd<=sd[-3] | 14 | 82.35 | - |
| SEGNALE | 14 | 100 | - |
Segnali e trade: {"eseguiti": 14, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 14}

Armati: {"+1": 143, "-1": 136}; fine episodi: {"BAND_RIDING": 186, "FINE_DATI": 1, "OPPOSTO": 18, "T_MAX": 74}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 40, "episodi_seq_violata_su_barra_di_tocco": 8, "segnali_con_impulsiva_1.0_violata": 14, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 63 | - | BAND_RIDING |
| finestra | 55 | 87.3 | BAND_RIDING |
| I0_mediana_toccata | 29 | 52.73 | T_MAX |
| I1_banda_opposta_mai_toccata | 13 | 44.83 | T_MAX |
| retest_banda_impulso | 1 | 7.692 | T_MAX |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "retest_banda_impulso", "da": 13, "a": 1}, {"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 1, "a": 0}]

Armati: {"+1": 38, "-1": 25}; fine episodi: {"BAND_RIDING": 43, "OPPOSTO": 4, "T_MAX": 16}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 55 | - | BAND_RIDING |
| finestra | 48 | 87.27 | BAND_RIDING |
| I0_mediana_toccata | 31 | 64.58 | T_MAX |
| I1_banda_opposta_mai_toccata | 10 | 32.26 | BAND_RIDING |
| retest_banda_impulso | 3 | 30 | T_MAX |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 3, "a": 0}]

Armati: {"+1": 27, "-1": 28}; fine episodi: {"BAND_RIDING": 37, "OPPOSTO": 2, "T_MAX": 16}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 59 | - | BAND_RIDING |
| finestra | 53 | 89.83 | BAND_RIDING |
| I0_mediana_toccata | 37 | 69.81 | T_MAX |
| I1_banda_opposta_mai_toccata | 16 | 43.24 | T_MAX |
| retest_banda_impulso | 3 | 18.75 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 33.33 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 27, "-1": 32}; fine episodi: {"BAND_RIDING": 34, "FINE_DATI": 1, "OPPOSTO": 9, "T_MAX": 15}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 102 | - | BAND_RIDING |
| finestra | 93 | 91.18 | BAND_RIDING |
| I0_mediana_toccata | 53 | 56.99 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 27 | 50.94 | T_MAX |
| retest_banda_impulso | 4 | 14.81 | BAND_RIDING |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 4, "a": 0}]

Armati: {"+1": 51, "-1": 51}; fine episodi: {"BAND_RIDING": 72, "OPPOSTO": 3, "T_MAX": 27}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 279 | - | BAND_RIDING |
| finestra | 249 | 89.25 | BAND_RIDING |
| I0_mediana_toccata | 150 | 60.24 | T_MAX |
| I1_banda_opposta_mai_toccata | 66 | 44 | T_MAX |
| retest_banda_impulso | 11 | 16.67 | T_MAX |
| I2_nessuna_impulsiva | 1 | 9.091 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 11, "a": 1}]

Armati: {"+1": 143, "-1": 136}; fine episodi: {"BAND_RIDING": 186, "FINE_DATI": 1, "OPPOSTO": 18, "T_MAX": 74}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 115 | - | BAND_RIDING |
| finestra | 103 | 89.57 | BAND_RIDING |
| C0_tocco_banda_opposta | 39 | 37.86 | BAND_RIDING |
| C3_sequenza | 37 | 94.87 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 15 | 40.54 | T_MAX |
| C1b_candela_test_non_impulsiva | 9 | 60 | T_MAX |
| sd<S50 | 7 | 77.78 | T_MAX |
| sd<=sd[-3] | 6 | 85.71 | - |
| SEGNALE | 6 | 100 | - |
Segnali e trade: {"eseguiti": 6, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 6}

Armati: {"+1": 65, "-1": 50}; fine episodi: {"BAND_RIDING": 68, "FINE_DATI": 1, "OPPOSTO": 10, "T_MAX": 36}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 22, "episodi_seq_violata_su_barra_di_tocco": 3, "segnali_con_impulsiva_1.0_violata": 6, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 127 | - | BAND_RIDING |
| finestra | 117 | 92.13 | BAND_RIDING |
| C0_tocco_banda_opposta | 47 | 40.17 | T_MAX |
| C3_sequenza | 44 | 93.62 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 19 | 43.18 | T_MAX |
| C1b_candela_test_non_impulsiva | 12 | 63.16 | T_MAX |
| sd<S50 | 9 | 75 | - |
| sd<=sd[-3] | 9 | 100 | - |
| SEGNALE | 9 | 100 | - |
Segnali e trade: {"eseguiti": 9, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 9}

Armati: {"+1": 62, "-1": 65}; fine episodi: {"BAND_RIDING": 80, "OPPOSTO": 8, "T_MAX": 39}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 16, "episodi_seq_violata_su_barra_di_tocco": 6, "segnali_con_impulsiva_1.0_violata": 9, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 135 | - | BAND_RIDING |
| finestra | 112 | 82.96 | BAND_RIDING |
| C0_tocco_banda_opposta | 46 | 41.07 | T_MAX |
| C3_sequenza | 43 | 93.48 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 12 | 27.91 | T_MAX |
| C1b_candela_test_non_impulsiva | 6 | 50 | - |
| sd<S50 | 6 | 100 | T_MAX |
| sd<=sd[-3] | 5 | 83.33 | - |
| SEGNALE | 5 | 100 | - |
Segnali e trade: {"eseguiti": 5, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 5}

Armati: {"+1": 68, "-1": 67}; fine episodi: {"BAND_RIDING": 81, "FINE_DATI": 1, "OPPOSTO": 12, "T_MAX": 41}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 26, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 5, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 209 | - | BAND_RIDING |
| finestra | 169 | 80.86 | BAND_RIDING |
| C0_tocco_banda_opposta | 70 | 41.42 | BAND_RIDING |
| C3_sequenza | 66 | 94.29 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 26 | 39.39 | T_MAX |
| C1b_candela_test_non_impulsiva | 15 | 57.69 | OPPOSTO |
| sd<S50 | 13 | 86.67 | T_MAX |
| sd<=sd[-3] | 11 | 84.62 | - |
| SEGNALE | 11 | 100 | - |
Segnali e trade: {"eseguiti": 11, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 11}

Armati: {"+1": 109, "-1": 100}; fine episodi: {"BAND_RIDING": 137, "OPPOSTO": 9, "T_MAX": 63}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 25, "episodi_seq_violata_su_barra_di_tocco": 5, "segnali_con_impulsiva_1.0_violata": 11, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 586 | - | BAND_RIDING |
| finestra | 501 | 85.49 | BAND_RIDING |
| C0_tocco_banda_opposta | 202 | 40.32 | T_MAX |
| C3_sequenza | 190 | 94.06 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 72 | 37.89 | T_MAX |
| C1b_candela_test_non_impulsiva | 42 | 58.33 | T_MAX |
| sd<S50 | 35 | 83.33 | T_MAX |
| sd<=sd[-3] | 31 | 88.57 | - |
| SEGNALE | 31 | 100 | - |
Segnali e trade: {"eseguiti": 31, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 31}

Armati: {"+1": 304, "-1": 282}; fine episodi: {"BAND_RIDING": 366, "FINE_DATI": 2, "OPPOSTO": 39, "T_MAX": 179}; extra: {"episodi_consumati_tocco_precoce": 3, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 89, "episodi_seq_violata_su_barra_di_tocco": 18, "segnali_con_impulsiva_1.0_violata": 31, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 115 | - | BAND_RIDING |
| finestra | 103 | 89.57 | BAND_RIDING |
| I0_mediana_toccata | 65 | 63.11 | T_MAX |
| I1_banda_opposta_mai_toccata | 25 | 38.46 | T_MAX |
| retest_banda_impulso | 4 | 16 | BAND_RIDING |
| I2_nessuna_impulsiva | 2 | 50 | BAND_RIDING |
| I3_banda_piatta | 1 | 50 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 65, "-1": 50}; fine episodi: {"BAND_RIDING": 68, "FINE_DATI": 1, "OPPOSTO": 10, "T_MAX": 36}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 127 | - | BAND_RIDING |
| finestra | 117 | 92.13 | BAND_RIDING |
| I0_mediana_toccata | 78 | 66.67 | T_MAX |
| I1_banda_opposta_mai_toccata | 28 | 35.9 | T_MAX |
| retest_banda_impulso | 7 | 25 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 14.29 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 62, "-1": 65}; fine episodi: {"BAND_RIDING": 80, "OPPOSTO": 8, "T_MAX": 39}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 135 | - | BAND_RIDING |
| finestra | 112 | 82.96 | BAND_RIDING |
| I0_mediana_toccata | 80 | 71.43 | T_MAX |
| I1_banda_opposta_mai_toccata | 26 | 32.5 | T_MAX |
| retest_banda_impulso | 7 | 26.92 | T_MAX |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 7, "a": 0}]

Armati: {"+1": 68, "-1": 67}; fine episodi: {"BAND_RIDING": 81, "FINE_DATI": 1, "OPPOSTO": 12, "T_MAX": 41}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 209 | - | BAND_RIDING |
| finestra | 169 | 80.86 | BAND_RIDING |
| I0_mediana_toccata | 114 | 67.46 | T_MAX |
| I1_banda_opposta_mai_toccata | 51 | 44.74 | T_MAX |
| retest_banda_impulso | 12 | 23.53 | T_MAX |
| I2_nessuna_impulsiva | 1 | 8.333 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 12, "a": 1}]

Armati: {"+1": 109, "-1": 100}; fine episodi: {"BAND_RIDING": 137, "OPPOSTO": 9, "T_MAX": 63}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 586 | - | BAND_RIDING |
| finestra | 501 | 85.49 | BAND_RIDING |
| I0_mediana_toccata | 337 | 67.27 | T_MAX |
| I1_banda_opposta_mai_toccata | 130 | 38.58 | T_MAX |
| retest_banda_impulso | 30 | 23.08 | T_MAX |
| I2_nessuna_impulsiva | 4 | 13.33 | BAND_RIDING |
| I3_banda_piatta | 3 | 75 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 304, "-1": 282}; fine episodi: {"BAND_RIDING": 366, "FINE_DATI": 2, "OPPOSTO": 39, "T_MAX": 179}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

## T2 Risultati per variante x TF x periodo
| cella | n | win_pct | pf_lordo | pf_netto | attesa_R | mediana_R | netto_R | dd_max_R | costo_spread_medio_R | D_medio_atr | pareggio_atteso_medio_pct | wr0_pct | durata_mediana_barre | durata_max_barre | quota_long |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CONT_H1_2013 | 1 | 100 | inf | inf | 0.5336 | 0.5336 | 0.5336 | 0 | 0.007724 | 1.601 | 65.77 | 65.21 | 3 | 3 | 0 |
| CONT_H1_2018 | 3 | 100 | inf | inf | 0.309 | 0.3055 | 0.927 | 0 | 0.01627 | 1.47 | 69.08 | 67.98 | 8 | 13 | 0.3333 |
| CONT_H1_2020 | 5 | 100 | inf | inf | 0.4417 | 0.3962 | 2.208 | 0 | 0.009575 | 1.403 | 69.9 | 69.21 | 2 | 5 | 0.6 |
| CONT_H1_2025-26 | 5 | 80 | 0.8915 | 0.8647 | -0.02706 | 0.09317 | -0.1353 | 1 | 0.005391 | 1.107 | 74.1 | 73.89 | 9 | 12 | 0.4 |
| CONT_H1_TOTALE | 14 | 92.86 | 4.671 | 4.534 | 0.2524 | 0.3439 | 3.534 | 1 | 0.009383 | 1.326 | 70.93 | 70.33 | 4.5 | 13 | 0.4286 |
| INV_H1_2013 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2018 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2020 | 1 | 100 | inf | inf | 0.6497 | 0.6497 | 0.6497 | 0 | 0.008028 | 1.949 | 61.1 | 60.62 | 3 | 3 | 1 |
| INV_H1_2025-26 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_TOTALE | 1 | 100 | inf | inf | 0.6497 | 0.6497 | 0.6497 | 0 | 0.008028 | 1.949 | 61.1 | 60.62 | 3 | 3 | 1 |
| POOLED_H1 | 15 | 93.33 | 5.33 | 5.183 | 0.2789 | 0.3822 | 4.183 | 1 | 0.009293 | 1.367 | 70.27 | 69.68 | 4 | 13 | 0.4667 |
| CONT_M30_2013 | 6 | 66.67 | 5.867 | 5.236 | 0.1698 | 0.1406 | 1.019 | 0.2405 | 0.01384 | 0.9333 | 78.43 | 77.69 | 8 | 17 | 0.6667 |
| CONT_M30_2018 | 9 | 66.67 | 1.679 | 1.49 | 0.07976 | 0.2513 | 0.7178 | 1 | 0.02528 | 1.339 | 71.19 | 69.57 | 8 | 24 | 0.4444 |
| CONT_M30_2020 | 5 | 80 | 1.077 | 1.004 | 0.0008775 | 0.1232 | 0.004387 | 1 | 0.01416 | 1.051 | 75.78 | 74.69 | 5 | 10 | 0.6 |
| CONT_M30_2025-26 | 11 | 54.55 | 0.4512 | 0.4307 | -0.1766 | 0.08672 | -1.943 | 1.944 | 0.007597 | 1.39 | 69.57 | 68.99 | 12 | 24 | 0.5455 |
| CONT_M30_TOTALE | 31 | 64.52 | 1.044 | 0.967 | -0.006517 | 0.158 | -0.202 | 1.944 | 0.015 | 1.232 | 72.76 | 71.76 | 8 | 24 | 0.5484 |
| INV_M30_2013 | 1 | 100 | inf | inf | 0.201 | 0.201 | 0.201 | 0 | 0.001962 | 0.603 | 83.43 | 83.26 | 2 | 2 | 1 |
| INV_M30_2018 | 1 | 100 | inf | inf | 0.1547 | 0.1547 | 0.1547 | 0 | 0.003687 | 1.083 | 73.75 | 73.48 | 10 | 10 | 0 |
| INV_M30_2020 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_M30_2025-26 | 1 | 0 | 0 | 0 | -1 | -1 | -1 | 1 | 0.005721 | 0.3308 | 90.58 | 90.07 | 3 | 3 | 1 |
| INV_M30_TOTALE | 3 | 66.67 | 0.3634 | 0.3556 | -0.2148 | 0.1547 | -0.6444 | 1 | 0.00379 | 0.6722 | 82.59 | 82.27 | 3 | 10 | 0.6667 |
| POOLED_M30 | 34 | 64.71 | 0.9469 | 0.8811 | -0.02489 | 0.1563 | -0.8464 | 2.943 | 0.01401 | 1.183 | 73.63 | 72.69 | 8 | 24 | 0.5588 |

Uscite per motivo e altri conteggi:
- CONT_H1_2013: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2018: motivi {"MKT": 1, "TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_H1_2020: motivi {"TP": 5}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2025-26: motivi {"SL": 1, "TP": 4}; SL+TP stesso minuto 0; spread0 2; fine_dati/mkt 0
- CONT_H1_TOTALE: motivi {"MKT": 1, "SL": 1, "TP": 12}; SL+TP stesso minuto 0; spread0 2; fine_dati/mkt 1
- INV_H1_2013: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2018: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2020: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2025-26: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_TOTALE: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- POOLED_H1: motivi {"MKT": 1, "SL": 1, "TP": 13}; SL+TP stesso minuto 0; spread0 2; fine_dati/mkt 1
- CONT_M30_2013: motivi {"MKT": 1, "TP": 5}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_M30_2018: motivi {"MKT": 1, "SL": 1, "TP": 7}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_M30_2020: motivi {"SL": 1, "TP": 4}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2025-26: motivi {"SL": 3, "TP": 8}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 0
- CONT_M30_TOTALE: motivi {"MKT": 2, "SL": 5, "TP": 24}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 2
- INV_M30_2013: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2018: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2020: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_M30_2025-26: motivi {"SL": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_TOTALE: motivi {"SL": 1, "TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- POOLED_M30: motivi {"MKT": 2, "SL": 6, "TP": 26}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 2

## T3 Fasce (stratificazione, descrittori)
- **pooled**
  - **fascia**
    - **Buono**
      - n: 2
      - vincite: 1
      - long: 1
    - **Medio**
      - n: 12
      - vincite: 12
      - long: 5
      - wr_pct: 100
      - media_R: 0.3876
      - wr0_pct: 69.39
      - nota: N<30: solo descrittivo
    - **Ottimo**
      - n: 1
      - vincite: 1
      - long: 1
  - **fascia_accorpata**
    - **<70**
      - n: 12
      - vincite: 12
      - long: 5
      - wr_pct: 100
      - media_R: 0.3876
      - wr0_pct: 69.39
      - nota: N<30: solo descrittivo
    - **>=70**
      - n: 3
      - vincite: 2
      - long: 2
  - **n_prev**
    - **0**
      - n: 12
      - vincite: 11
      - long: 6
      - wr_pct: 91.67
      - media_R: 0.3018
      - wr0_pct: 67.2
      - nota: N<30: solo descrittivo
    - **1**
      - n: 3
      - vincite: 3
      - long: 1
  - **congestione_valida**
    - **no**
      - n: 14
      - vincite: 13
      - long: 6
      - wr_pct: 92.86
      - media_R: 0.2922
      - wr0_pct: 68.43
      - nota: N<30: solo descrittivo
    - **si**
      - n: 1
      - vincite: 1
      - long: 1
  - **checklist_stretta**
    - **no**
      - n: 15
      - vincite: 14
      - long: 7
      - wr_pct: 93.33
      - media_R: 0.2789
      - wr0_pct: 69.68
      - nota: N<30: solo descrittivo
  - **lato**
    - **long**
      - n: 7
      - vincite: 6
      - long: 7
    - **short**
      - n: 8
      - vincite: 8
      - long: 0
  - **periodo**
    - **2013**
      - n: 1
      - vincite: 1
      - long: 0
    - **2018**
      - n: 3
      - vincite: 3
      - long: 1
    - **2020**
      - n: 6
      - vincite: 6
      - long: 4
    - **2025-26**
      - n: 5
      - vincite: 4
      - long: 2
  - **fascia_oraria_server**
    - **0-7**
      - n: 3
      - vincite: 2
      - long: 1
    - **16-23**
      - n: 2
      - vincite: 2
      - long: 0
    - **8-15**
      - n: 10
      - vincite: 10
      - long: 6
      - wr_pct: 100
      - media_R: 0.3878
      - wr0_pct: 69.78
      - nota: N<30: solo descrittivo
- **CONT**
  - **fascia**
    - **Buono**
      - n: 2
      - vincite: 1
      - long: 1
    - **Medio**
      - n: 11
      - vincite: 11
      - long: 4
      - wr_pct: 100
      - media_R: 0.3638
      - wr0_pct: 70.19
      - nota: N<30: solo descrittivo
    - **Ottimo**
      - n: 1
      - vincite: 1
      - long: 1
  - **fascia_accorpata**
    - **<70**
      - n: 11
      - vincite: 11
      - long: 4
      - wr_pct: 100
      - media_R: 0.3638
      - wr0_pct: 70.19
      - nota: N<30: solo descrittivo
    - **>=70**
      - n: 3
      - vincite: 2
      - long: 2
  - **n_prev**
    - **0**
      - n: 11
      - vincite: 10
      - long: 5
      - wr_pct: 90.91
      - media_R: 0.2702
      - wr0_pct: 67.8
      - nota: N<30: solo descrittivo
    - **1**
      - n: 3
      - vincite: 3
      - long: 1
  - **congestione_valida**
    - **no**
      - n: 13
      - vincite: 12
      - long: 5
      - wr_pct: 92.31
      - media_R: 0.2646
      - wr0_pct: 69.03
      - nota: N<30: solo descrittivo
    - **si**
      - n: 1
      - vincite: 1
      - long: 1
  - **checklist_stretta**
    - **no**
      - n: 14
      - vincite: 13
      - long: 6
      - wr_pct: 92.86
      - media_R: 0.2524
      - wr0_pct: 70.33
      - nota: N<30: solo descrittivo
  - **lato**
    - **long**
      - n: 6
      - vincite: 5
      - long: 6
    - **short**
      - n: 8
      - vincite: 8
      - long: 0
  - **periodo**
    - **2013**
      - n: 1
      - vincite: 1
      - long: 0
    - **2018**
      - n: 3
      - vincite: 3
      - long: 1
    - **2020**
      - n: 5
      - vincite: 5
      - long: 3
    - **2025-26**
      - n: 5
      - vincite: 4
      - long: 2
  - **fascia_oraria_server**
    - **0-7**
      - n: 3
      - vincite: 2
      - long: 1
    - **16-23**
      - n: 2
      - vincite: 2
      - long: 0
    - **8-15**
      - n: 9
      - vincite: 9
      - long: 5
- **INV**
  - **fascia**
    - **Medio**
      - n: 1
      - vincite: 1
      - long: 1
  - **fascia_accorpata**
    - **<70**
      - n: 1
      - vincite: 1
      - long: 1
  - **n_prev**
    - **0**
      - n: 1
      - vincite: 1
      - long: 1
  - **congestione_valida**
    - **no**
      - n: 1
      - vincite: 1
      - long: 1
  - **checklist_stretta**
    - **no**
      - n: 1
      - vincite: 1
      - long: 1
  - **lato**
    - **long**
      - n: 1
      - vincite: 1
      - long: 1
  - **periodo**
    - **2020**
      - n: 1
      - vincite: 1
      - long: 1
  - **fascia_oraria_server**
    - **8-15**
      - n: 1
      - vincite: 1
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
    - n_trade: 15
    - n_abbinati: 15
    - media_osservata_R: 0.2789
    - media_nulla: 0.01619
    - p5: -0.2259
    - p50: 0.02255
    - p95: 0.2244
    - percentile_osservato: 0.9825
    - p_B: 0.01799
    - pf_nullo_p50: 1.117
    - pf_osservato: 5.183
  - **variante_CONT**
    - n_trade: 14
    - n_abbinati: 14
    - media_osservata_R: 0.2524
    - media_nulla: 0.0212
    - p5: -0.2147
    - p50: 0.02551
    - p95: 0.229
    - percentile_osservato: 0.971
    - p_B: 0.02949
    - pf_nullo_p50: 1.139
    - pf_osservato: 4.534
  - **variante_INV**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.6497
    - media_nulla: -0.05404
    - p5: -1
    - p50: 0.2573
    - p95: 0.6273
    - percentile_osservato: 0.9715
    - p_B: 0.02899
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2013**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.5336
    - media_nulla: 0.05589
    - p5: -1
    - p50: 0.2534
    - p95: 0.5391
    - percentile_osservato: 0.9485
    - p_B: 0.05197
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2018**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.309
    - media_nulla: -0.001685
    - p5: -0.5671
    - p50: 0.03554
    - p95: 0.3765
    - percentile_osservato: 0.8605
    - p_B: 0.1399
    - pf_nullo_p50: 1.488
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: 0.4763
    - media_nulla: 0.04063
    - p5: -0.3696
    - p50: 0.06849
    - p95: 0.3675
    - percentile_osservato: 1
    - p_B: 0.0004998
    - pf_nullo_p50: 1.401
    - pf_osservato: inf
  - **periodo_2025-26**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: -0.02706
    - media_nulla: -0.01037
    - p5: -0.4577
    - p50: 0.0002635
    - p95: 0.3108
    - percentile_osservato: 0.4265
    - p_B: 0.5737
    - pf_nullo_p50: 1.001
    - pf_osservato: 0.8647
  - **lato_long**
    - n_trade: 7
    - n_abbinati: 7
    - media_osservata_R: 0.2112
    - media_nulla: -0.01431
    - p5: -0.3716
    - p50: -0.003265
    - p95: 0.3213
    - percentile_osservato: 0.843
    - p_B: 0.1574
    - pf_nullo_p50: 0.9834
    - pf_osservato: 2.478
  - **lato_short**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: 0.3381
    - media_nulla: 0.04287
    - p5: -0.2635
    - p50: 0.05991
    - p95: 0.2976
    - percentile_osservato: 0.985
    - p_B: 0.01549
    - pf_nullo_p50: 1.417
    - pf_osservato: inf
- **B0**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 15
    - n_abbinati: 15
    - media_osservata_R: 0.2789
    - media_nulla: -0.02828
    - p5: -0.2549
    - p50: -0.02656
    - p95: 0.1869
    - percentile_osservato: 0.993
    - p_B: 0.007496
    - pf_nullo_p50: 0.8877
    - pf_osservato: 5.183
  - **variante_CONT**
    - n_trade: 14
    - n_abbinati: 14
    - media_osservata_R: 0.2524
    - media_nulla: -0.02572
    - p5: -0.2566
    - p50: -0.02374
    - p95: 0.1953
    - percentile_osservato: 0.9845
    - p_B: 0.01599
    - pf_nullo_p50: 0.8945
    - pf_osservato: 4.534
  - **variante_INV**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.6497
    - media_nulla: -0.06407
    - p5: -1
    - p50: 0.2047
    - p95: 0.6158
    - percentile_osservato: 0.97
    - p_B: 0.03048
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2013**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.5336
    - media_nulla: 0.00601
    - p5: -1
    - p50: 0.2065
    - p95: 0.5414
    - percentile_osservato: 0.9365
    - p_B: 0.06397
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2018**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.309
    - media_nulla: -0.05171
    - p5: -0.612
    - p50: -0.06441
    - p95: 0.3948
    - percentile_osservato: 0.8555
    - p_B: 0.1449
    - pf_nullo_p50: 0.7877
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: 0.4763
    - media_nulla: -0.03358
    - p5: -0.4217
    - p50: -0.01879
    - p95: 0.3234
    - percentile_osservato: 1
    - p_B: 0.0004998
    - pf_nullo_p50: 0.9168
    - pf_osservato: inf
  - **periodo_2025-26**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: -0.02706
    - media_nulla: -0.01471
    - p5: -0.3873
    - p50: -0.002355
    - p95: 0.2975
    - percentile_osservato: 0.439
    - p_B: 0.5612
    - pf_nullo_p50: 0.9871
    - pf_osservato: 0.8647
  - **lato_long**
    - n_trade: 7
    - n_abbinati: 7
    - media_osservata_R: 0.2112
    - media_nulla: -0.04129
    - p5: -0.3884
    - p50: -0.03376
    - p95: 0.2814
    - percentile_osservato: 0.8935
    - p_B: 0.1069
    - pf_nullo_p50: 0.8507
    - pf_osservato: 2.478
  - **lato_short**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: 0.3381
    - media_nulla: -0.01689
    - p5: -0.3496
    - p50: -0.00617
    - p95: 0.2715
    - percentile_osservato: 0.988
    - p_B: 0.01249
    - pf_nullo_p50: 0.9723
    - pf_osservato: inf
- **B2**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 15
    - n_abbinati: 15
    - media_osservata_R: 0.2789
    - media_nulla: 0.002332
    - p5: -0.2243
    - p50: 0.005204
    - p95: 0.2082
    - percentile_osservato: 0.9935
    - p_B: 0.006997
    - pf_nullo_p50: 1.027
    - pf_osservato: 5.183
  - **variante_CONT**
    - n_trade: 14
    - n_abbinati: 14
    - media_osservata_R: 0.2524
    - media_nulla: -0.00344
    - p5: -0.2357
    - p50: -0.001585
    - p95: 0.2126
    - percentile_osservato: 0.983
    - p_B: 0.01749
    - pf_nullo_p50: 0.9919
    - pf_osservato: 4.534
  - **variante_INV**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.6497
    - media_nulla: 0.08313
    - p5: -1
    - p50: 0.2164
    - p95: 0.5791
    - percentile_osservato: 1
    - p_B: 0.0004998
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2013**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.5336
    - media_nulla: 0.04578
    - p5: -1
    - p50: 0.2304
    - p95: 0.5095
    - percentile_osservato: 0.974
    - p_B: 0.02649
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2018**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.309
    - media_nulla: -0.05593
    - p5: -0.609
    - p50: -0.06862
    - p95: 0.4056
    - percentile_osservato: 0.8425
    - p_B: 0.1579
    - pf_nullo_p50: 0.7812
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: 0.4763
    - media_nulla: 0.02866
    - p5: -0.3234
    - p50: 0.04487
    - p95: 0.3232
    - percentile_osservato: 1
    - p_B: 0.0004998
    - pf_nullo_p50: 1.261
    - pf_osservato: inf
  - **periodo_2025-26**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: -0.02706
    - media_nulla: -0.002987
    - p5: -0.3795
    - p50: 0.004868
    - p95: 0.2906
    - percentile_osservato: 0.427
    - p_B: 0.5732
    - pf_nullo_p50: 1.024
    - pf_osservato: 0.8647
  - **lato_long**
    - n_trade: 7
    - n_abbinati: 7
    - media_osservata_R: 0.2112
    - media_nulla: 0.01528
    - p5: -0.311
    - p50: 0.03402
    - p95: 0.2878
    - percentile_osservato: 0.8425
    - p_B: 0.1579
    - pf_nullo_p50: 1.231
    - pf_osservato: 2.478
  - **lato_short**
    - n_trade: 8
    - n_abbinati: 8
    - media_osservata_R: 0.3381
    - media_nulla: -0.008994
    - p5: -0.3232
    - p50: -0.001118
    - p95: 0.2711
    - percentile_osservato: 0.989
    - p_B: 0.01149
    - pf_nullo_p50: 0.9945
    - pf_osservato: inf
- **pool_barre_simulate**
  - **2013**
    - long: 2741
    - short: 3133
  - **2018**
    - long: 2766
    - short: 3113
  - **2020**
    - long: 3087
    - short: 2827
  - **2025-26**
    - long: 4672
    - short: 5816

## T5 Robustezza della primaria
- **bootstrap_settimane**
  - settimane: 15
  - media: 0.2789
  - ic90_lo: 0.09779
  - ic90_hi: 0.424
  - n_replicati: 10000
- **senza_i_migliori_3**
  - n: 12
  - media_R: 0.1909
  - pf_netto: 3.29
- **con_tutti**
  - n: 15
  - media_R: 0.2789
  - pf_netto: 5.183
- **leave_one_period_out**
  - **2013**
    - n: 14
    - media_R: 0.2607
    - pf_netto: 4.65
  - **2018**
    - n: 12
    - media_R: 0.2714
    - pf_netto: 4.256
  - **2020**
    - n: 9
    - media_R: 0.1473
    - pf_netto: 2.325
  - **2025-26**
    - n: 10
    - media_R: 0.4319
    - pf_netto: inf
- **quota_profitto_per_periodo**
  - 2013: 0.1276
  - 2018: 0.2216
  - 2020: 0.6832
  - 2025-26: -0.03234
- **spread_x1.5**
  - n: 15
  - media_R: 0.2768
  - pf_netto: 5.153
- **escluso_spread0**
  - n: 13
  - media_R: 0.2955
  - pf_netto: 4.841

## T6 Sensibilita (riportate per intero, non selezionabili)
| sens | segnali | n | win_pct | pf_netto | attesa_R | netto_R | dd_max_R |
|---|---|---|---|---|---|---|---|
| Sa | 16 | 16 | 93.75 | 5.683 | 0.2927 | 4.683 | 1 |
| Sb | 14 | 14 | 92.86 | 4.534 | 0.2524 | 3.534 | 1 |
| Sc | 15 | 15 | 93.33 | 5.183 | 0.2789 | 4.183 | 1 |
| Sd | 15 | 15 | 93.33 | 5.153 | 0.2768 | 4.153 | 1 |
| Se20 | 13 | 13 | 100 | inf | 0.3791 | 4.928 | 0 |
| Se50 | 15 | 15 | 93.33 | 5.183 | 0.2789 | 4.183 | 1 |
| Sf | 14 | 14 | 92.86 | 4.878 | 0.277 | 3.878 | 1 |
| Sg | 17 | 16 | 87.5 | 3.659 | 0.2354 | 3.767 | 1 |

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
  - buy_and_hold_in_ATR: 99.35
  - atr_mediana_prezzo: 0.1861
  - **long**
    - n: 0
    - media_R: -
  - **short**
    - n: 1
    - media_R: 0.5336
- **2018**
  - buy_and_hold_in_ATR: -22.83
  - atr_mediana_prezzo: 0.1307
  - **long**
    - n: 1
    - media_R: 0.3055
  - **short**
    - n: 2
    - media_R: 0.3107
- **2020**
  - buy_and_hold_in_ATR: -49.33
  - atr_mediana_prezzo: 0.1112
  - **long**
    - n: 4
    - media_R: 0.5199
  - **short**
    - n: 2
    - media_R: 0.3892
- **2025-26**
  - buy_and_hold_in_ATR: -1.255
  - atr_mediana_prezzo: 0.2151
  - **long**
    - n: 2
    - media_R: -0.4534
  - **short**
    - n: 3
    - media_R: 0.2572

## T9 Dati / esecuzione
- **spread0_sostituiti_per_periodo**
  - 2013: 1
  - 2018: 10
  - 2020: 18072
  - 2025-26: 83552
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
  - trade_spread0_ingresso: 2
  - trade_spread0_uscita: 0
  - gap_ingresso_max_min: 0
  - trade_con_gap_ingresso_gt_0: 0
  - trade_chiusi_fine_dati: 0
  - uscite_a_mercato_target_superato: 1
  - ricalcoli_target_totali: 16
  - eventi_sl_tp_stesso_minuto: 0
  - **segnali_scartati**
    - scartati_posizione_aperta: 0
    - scartati_target_oltre_ingresso: 0
    - scartati_indicatori_non_pronti: 0
    - scartati_no_barra_successiva: 0
    - scartati_gap_ingresso: 0
  - segnali_totali: 15
  - tocchi_penetrazione_lt_spread_sui_segnali: 0
  - coppie_CONT_INV_stesso_episodio: 0

## Log dei trade
Schedule completa dei target per ogni trade nel JSON (chiave tabelle.LOG_TRADE).
