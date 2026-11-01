# Breaking Band su GBPUSD — risultati (generato da run_test.py)

sha256 dei risultati (JSON canonico): `b2e2dd33a3da71012202eaefcd0d712d635c2a505d296ecf5d8c74670634a35a`

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
  - 2013: 132b4f38eee687386d43bfed3ada5e5c1acbe60e6a59327a6094a1d941a0169e
  - 2018: 4b3ae8d1a78cedf39578141760ff403206bcc07bc09ff8a7fd40f2ebb255229b
  - 2020: 44c2df54f3dcda10d744bc4b88fcda34d4e734a539ac961201d0d1f048d8fb4e
  - 2025-26: f0c75656fb85214ee87977d21eb903bb4519036e1f07e612ab3663d6234742be
- **righe_csv**
  - 2013: 368682
  - 2018: 371927
  - 2020: 372994
  - 2025-26: 644977
- simbolo: GBPUSD
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
  - ABTG_M1_GBPUSD_2013.csv: True
  - ABTG_M1_GBPUSD_2018.csv: True
  - ABTG_M1_GBPUSD_2020.csv: True
  - ABTG_M1_GBPUSD.csv: True
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
- N: 24
- media_R: 0.1433
- pf_netto: 2.146
- p_B1: 0.05897
- **ic90**
  - settimane: 22
  - media: 0.1433
  - ic90_lo: -0.02459
  - ic90_hi: 0.2834
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
### CONT_H1 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 62 | - | BAND_RIDING |
| finestra | 51 | 82.26 | BAND_RIDING |
| C0_tocco_banda_opposta | 20 | 39.22 | BAND_RIDING |
| C3_sequenza | 19 | 95 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 8 | 42.11 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 4 | 50 | - |
| sd<S50 | 4 | 100 | - |
| sd<=sd[-3] | 4 | 100 | - |
| SEGNALE | 4 | 100 | - |
Segnali e trade: {"eseguiti": 4, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 4}

Armati: {"+1": 29, "-1": 33}; fine episodi: {"BAND_RIDING": 47, "OPPOSTO": 2, "T_MAX": 13}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 13, "episodi_seq_violata_su_barra_di_tocco": 2, "segnali_con_impulsiva_1.0_violata": 4, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 61 | - | BAND_RIDING |
| finestra | 53 | 86.89 | BAND_RIDING |
| C0_tocco_banda_opposta | 18 | 33.96 | T_MAX |
| C3_sequenza | 15 | 83.33 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 4 | 26.67 | T_MAX |
| C1b_candela_test_non_impulsiva | 0 | 0 | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "C1b_candela_test_non_impulsiva", "da": 4, "a": 0}]

Armati: {"+1": 26, "-1": 35}; fine episodi: {"BAND_RIDING": 42, "FINE_DATI": 1, "OPPOSTO": 3, "T_MAX": 15}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 9, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 54 | - | BAND_RIDING |
| finestra | 45 | 83.33 | BAND_RIDING |
| C0_tocco_banda_opposta | 21 | 46.67 | T_MAX |
| C3_sequenza | 20 | 95.24 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 12 | 60 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 7 | 58.33 | - |
| sd<S50 | 7 | 100 | - |
| sd<=sd[-3] | 7 | 100 | - |
| SEGNALE | 7 | 100 | - |
Segnali e trade: {"eseguiti": 7, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 7}

Armati: {"+1": 27, "-1": 27}; fine episodi: {"BAND_RIDING": 40, "OPPOSTO": 1, "T_MAX": 13}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 12, "episodi_seq_violata_su_barra_di_tocco": 5, "segnali_con_impulsiva_1.0_violata": 7, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 111 | - | BAND_RIDING |
| finestra | 92 | 82.88 | BAND_RIDING |
| C0_tocco_banda_opposta | 43 | 46.74 | T_MAX |
| C3_sequenza | 39 | 90.7 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 17 | 43.59 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 11 | 64.71 | - |
| sd<S50 | 11 | 100 | - |
| sd<=sd[-3] | 11 | 100 | - |
| SEGNALE | 11 | 100 | - |
Segnali e trade: {"eseguiti": 10, "riconciliato": true, "scartati_gap_ingresso": 1, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 11}

Armati: {"+1": 61, "-1": 50}; fine episodi: {"BAND_RIDING": 74, "OPPOSTO": 5, "T_MAX": 32}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 21, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 10, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 288 | - | BAND_RIDING |
| finestra | 241 | 83.68 | BAND_RIDING |
| C0_tocco_banda_opposta | 102 | 42.32 | T_MAX |
| C3_sequenza | 93 | 91.18 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 41 | 44.09 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 22 | 53.66 | - |
| sd<S50 | 22 | 100 | - |
| sd<=sd[-3] | 22 | 100 | - |
| SEGNALE | 22 | 100 | - |
Segnali e trade: {"eseguiti": 21, "riconciliato": true, "scartati_gap_ingresso": 1, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 22}

Armati: {"+1": 143, "-1": 145}; fine episodi: {"BAND_RIDING": 203, "FINE_DATI": 1, "OPPOSTO": 11, "T_MAX": 73}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 55, "episodi_seq_violata_su_barra_di_tocco": 15, "segnali_con_impulsiva_1.0_violata": 21, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 62 | - | BAND_RIDING |
| finestra | 51 | 82.26 | BAND_RIDING |
| I0_mediana_toccata | 29 | 56.86 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 10 | 34.48 | BAND_RIDING |
| retest_banda_impulso | 2 | 20 | BAND_RIDING |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 2, "a": 0}]

Armati: {"+1": 29, "-1": 33}; fine episodi: {"BAND_RIDING": 47, "OPPOSTO": 2, "T_MAX": 13}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 61 | - | BAND_RIDING |
| finestra | 53 | 86.89 | BAND_RIDING |
| I0_mediana_toccata | 28 | 52.83 | T_MAX |
| I1_banda_opposta_mai_toccata | 11 | 39.29 | T_MAX |
| retest_banda_impulso | 2 | 18.18 | T_MAX |
| I2_nessuna_impulsiva | 1 | 50 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 26, "-1": 35}; fine episodi: {"BAND_RIDING": 42, "FINE_DATI": 1, "OPPOSTO": 3, "T_MAX": 15}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 54 | - | BAND_RIDING |
| finestra | 45 | 83.33 | BAND_RIDING |
| I0_mediana_toccata | 30 | 66.67 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 16 | 53.33 | BAND_RIDING |
| retest_banda_impulso | 1 | 6.25 | BAND_RIDING |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "retest_banda_impulso", "da": 16, "a": 1}, {"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 1, "a": 0}]

Armati: {"+1": 27, "-1": 27}; fine episodi: {"BAND_RIDING": 40, "OPPOSTO": 1, "T_MAX": 13}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 111 | - | BAND_RIDING |
| finestra | 92 | 82.88 | BAND_RIDING |
| I0_mediana_toccata | 68 | 73.91 | T_MAX |
| I1_banda_opposta_mai_toccata | 40 | 58.82 | BAND_RIDING |
| retest_banda_impulso | 10 | 25 | BAND_RIDING |
| I2_nessuna_impulsiva | 2 | 20 | - |
| I3_banda_piatta | 2 | 100 | - |
| sd<S50 | 2 | 100 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 61, "-1": 50}; fine episodi: {"BAND_RIDING": 74, "OPPOSTO": 5, "T_MAX": 32}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 288 | - | BAND_RIDING |
| finestra | 241 | 83.68 | BAND_RIDING |
| I0_mediana_toccata | 155 | 64.32 | T_MAX |
| I1_banda_opposta_mai_toccata | 77 | 49.68 | BAND_RIDING |
| retest_banda_impulso | 15 | 19.48 | BAND_RIDING |
| I2_nessuna_impulsiva | 3 | 20 | - |
| I3_banda_piatta | 3 | 100 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 143, "-1": 145}; fine episodi: {"BAND_RIDING": 203, "FINE_DATI": 1, "OPPOSTO": 11, "T_MAX": 73}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 158 | - | BAND_RIDING |
| finestra | 148 | 93.67 | BAND_RIDING |
| C0_tocco_banda_opposta | 62 | 41.89 | T_MAX |
| C3_sequenza | 52 | 83.87 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 25 | 48.08 | T_MAX |
| C1b_candela_test_non_impulsiva | 18 | 72 | - |
| sd<S50 | 18 | 100 | - |
| sd<=sd[-3] | 18 | 100 | - |
| SEGNALE | 18 | 100 | - |
Segnali e trade: {"eseguiti": 18, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 18}

Armati: {"+1": 75, "-1": 83}; fine episodi: {"BAND_RIDING": 68, "OPPOSTO": 14, "T_MAX": 76}; extra: {"episodi_consumati_tocco_precoce": 2, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 29, "episodi_seq_violata_su_barra_di_tocco": 11, "segnali_con_impulsiva_1.0_violata": 15, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 166 | - | BAND_RIDING |
| finestra | 160 | 96.39 | BAND_RIDING |
| C0_tocco_banda_opposta | 57 | 35.62 | T_MAX |
| C3_sequenza | 45 | 78.95 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 19 | 42.22 | T_MAX |
| C1b_candela_test_non_impulsiva | 15 | 78.95 | - |
| sd<S50 | 15 | 100 | T_MAX |
| sd<=sd[-3] | 14 | 93.33 | - |
| SEGNALE | 14 | 100 | - |
Segnali e trade: {"eseguiti": 13, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 1, "segnali": 14}

Armati: {"+1": 77, "-1": 89}; fine episodi: {"BAND_RIDING": 79, "FINE_DATI": 1, "OPPOSTO": 13, "T_MAX": 73}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 3, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 24, "episodi_seq_violata_su_barra_di_tocco": 12, "segnali_con_impulsiva_1.0_violata": 12, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 154 | - | BAND_RIDING |
| finestra | 137 | 88.96 | BAND_RIDING |
| C0_tocco_banda_opposta | 51 | 37.23 | T_MAX |
| C3_sequenza | 49 | 96.08 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 23 | 46.94 | T_MAX |
| C1b_candela_test_non_impulsiva | 19 | 82.61 | - |
| sd<S50 | 19 | 100 | T_MAX |
| sd<=sd[-3] | 18 | 94.74 | - |
| SEGNALE | 18 | 100 | - |
Segnali e trade: {"eseguiti": 18, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 18}

Armati: {"+1": 77, "-1": 77}; fine episodi: {"BAND_RIDING": 91, "OPPOSTO": 6, "T_MAX": 57}; extra: {"episodi_consumati_tocco_precoce": 2, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 16, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 14, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 231 | - | BAND_RIDING |
| finestra | 199 | 86.15 | BAND_RIDING |
| C0_tocco_banda_opposta | 83 | 41.71 | T_MAX |
| C3_sequenza | 77 | 92.77 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 35 | 45.45 | T_MAX |
| C1b_candela_test_non_impulsiva | 28 | 80 | T_MAX |
| sd<S50 | 27 | 96.43 | T_MAX |
| sd<=sd[-3] | 25 | 92.59 | - |
| SEGNALE | 25 | 100 | - |
Segnali e trade: {"eseguiti": 24, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 1, "segnali": 25}

Armati: {"+1": 117, "-1": 114}; fine episodi: {"BAND_RIDING": 126, "FINE_DATI": 1, "OPPOSTO": 12, "T_MAX": 92}; extra: {"episodi_consumati_tocco_precoce": 2, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 31, "episodi_seq_violata_su_barra_di_tocco": 7, "segnali_con_impulsiva_1.0_violata": 22, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 709 | - | BAND_RIDING |
| finestra | 644 | 90.83 | BAND_RIDING |
| C0_tocco_banda_opposta | 253 | 39.29 | T_MAX |
| C3_sequenza | 223 | 88.14 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 102 | 45.74 | T_MAX |
| C1b_candela_test_non_impulsiva | 80 | 78.43 | T_MAX |
| sd<S50 | 79 | 98.75 | T_MAX |
| sd<=sd[-3] | 75 | 94.94 | - |
| SEGNALE | 75 | 100 | - |
Segnali e trade: {"eseguiti": 73, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 2, "segnali": 75}

Armati: {"+1": 346, "-1": 363}; fine episodi: {"BAND_RIDING": 364, "FINE_DATI": 2, "OPPOSTO": 45, "T_MAX": 298}; extra: {"episodi_consumati_tocco_precoce": 6, "episodi_eliminati_solo_da_SEQ": 5, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 100, "episodi_seq_violata_su_barra_di_tocco": 34, "segnali_con_impulsiva_1.0_violata": 63, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 158 | - | BAND_RIDING |
| finestra | 148 | 93.67 | BAND_RIDING |
| I0_mediana_toccata | 117 | 79.05 | T_MAX |
| I1_banda_opposta_mai_toccata | 31 | 26.5 | T_MAX |
| retest_banda_impulso | 8 | 25.81 | T_MAX |
| I2_nessuna_impulsiva | 4 | 50 | - |
| I3_banda_piatta | 4 | 100 | - |
| sd<S50 | 4 | 100 | T_MAX |
| sd<=sd[-3] | 2 | 50 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 75, "-1": 83}; fine episodi: {"BAND_RIDING": 68, "OPPOSTO": 14, "T_MAX": 76}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 166 | - | BAND_RIDING |
| finestra | 160 | 96.39 | BAND_RIDING |
| I0_mediana_toccata | 116 | 72.5 | T_MAX |
| I1_banda_opposta_mai_toccata | 25 | 21.55 | T_MAX |
| retest_banda_impulso | 7 | 28 | T_MAX |
| I2_nessuna_impulsiva | 1 | 14.29 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 77, "-1": 89}; fine episodi: {"BAND_RIDING": 79, "FINE_DATI": 1, "OPPOSTO": 13, "T_MAX": 73}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 154 | - | BAND_RIDING |
| finestra | 137 | 88.96 | BAND_RIDING |
| I0_mediana_toccata | 102 | 74.45 | T_MAX |
| I1_banda_opposta_mai_toccata | 29 | 28.43 | T_MAX |
| retest_banda_impulso | 8 | 27.59 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 12.5 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | T_MAX |
| sd<=sd[-3] | 0 | 0 | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "sd<=sd[-3]", "da": 1, "a": 0}]

Armati: {"+1": 77, "-1": 77}; fine episodi: {"BAND_RIDING": 91, "OPPOSTO": 6, "T_MAX": 57}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 231 | - | BAND_RIDING |
| finestra | 199 | 86.15 | BAND_RIDING |
| I0_mediana_toccata | 150 | 75.38 | T_MAX |
| I1_banda_opposta_mai_toccata | 43 | 28.67 | T_MAX |
| retest_banda_impulso | 10 | 23.26 | T_MAX |
| I2_nessuna_impulsiva | 4 | 40 | - |
| I3_banda_piatta | 4 | 100 | - |
| sd<S50 | 4 | 100 | BAND_RIDING |
| sd<=sd[-3] | 3 | 75 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 1, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 117, "-1": 114}; fine episodi: {"BAND_RIDING": 126, "FINE_DATI": 1, "OPPOSTO": 12, "T_MAX": 92}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 709 | - | BAND_RIDING |
| finestra | 644 | 90.83 | BAND_RIDING |
| I0_mediana_toccata | 485 | 75.31 | T_MAX |
| I1_banda_opposta_mai_toccata | 128 | 26.39 | T_MAX |
| retest_banda_impulso | 33 | 25.78 | T_MAX |
| I2_nessuna_impulsiva | 10 | 30.3 | - |
| I3_banda_piatta | 10 | 100 | - |
| sd<S50 | 10 | 100 | T_MAX |
| sd<=sd[-3] | 6 | 60 | - |
| SEGNALE | 6 | 100 | - |
Segnali e trade: {"eseguiti": 5, "riconciliato": true, "scartati_gap_ingresso": 1, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 6}

Armati: {"+1": 346, "-1": 363}; fine episodi: {"BAND_RIDING": 364, "FINE_DATI": 2, "OPPOSTO": 45, "T_MAX": 298}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 5, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

## T2 Risultati per variante x TF x periodo
| cella | n | win_pct | pf_lordo | pf_netto | attesa_R | mediana_R | netto_R | dd_max_R | costo_spread_medio_R | D_medio_atr | pareggio_atteso_medio_pct | wr0_pct | durata_mediana_barre | durata_max_barre | quota_long |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CONT_H1_2013 | 4 | 75 | 0.6901 | 0.6424 | -0.08939 | 0.1482 | -0.3576 | 1 | 0.01307 | 0.735 | 81.51 | 80.67 | 2 | 4 | 0.75 |
| CONT_H1_2018 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| CONT_H1_2020 | 7 | 85.71 | 2.218 | 2.174 | 0.1677 | 0.4192 | 1.174 | 1 | 0.005883 | 1.15 | 73.59 | 73.02 | 1 | 11 | 0.5714 |
| CONT_H1_2025-26 | 10 | 100 | inf | inf | 0.3218 | 0.2961 | 3.218 | 0 | 0.005838 | 1.102 | 74.37 | 74.05 | 2 | 8 | 0.6 |
| CONT_H1_TOTALE | 21 | 90.48 | 3.112 | 3.017 | 0.1921 | 0.308 | 4.034 | 2 | 0.00723 | 1.048 | 75.47 | 74.96 | 2 | 11 | 0.619 |
| INV_H1_2013 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2018 | 1 | 100 | inf | inf | 0.1 | 0.1 | 0.1 | 0 | 0.006971 | 0.3001 | 91.54 | 90.91 | 1 | 1 | 1 |
| INV_H1_2020 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2025-26 | 2 | 50 | 0.3084 | 0.3048 | -0.3476 | -0.3476 | -0.6952 | 1 | 0.002819 | 1.089 | 73.66 | 73.5 | 10.5 | 19 | 0 |
| INV_H1_TOTALE | 3 | 66.67 | 0.4157 | 0.4048 | -0.1984 | 0.1 | -0.5952 | 1 | 0.004203 | 0.8262 | 79.62 | 79.3 | 2 | 19 | 0.3333 |
| POOLED_H1 | 24 | 87.5 | 2.209 | 2.146 | 0.1433 | 0.2878 | 3.439 | 1.9 | 0.006852 | 1.02 | 75.99 | 75.51 | 2 | 19 | 0.5833 |
| CONT_M30_2013 | 18 | 50 | 0.4972 | 0.4416 | -0.167 | -0.004921 | -3.006 | 4.857 | 0.02068 | 0.9298 | 79.43 | 77.34 | 9.5 | 24 | 0.3333 |
| CONT_M30_2018 | 13 | 92.31 | 26.8 | 18.67 | 0.1668 | 0.1612 | 2.168 | 0.1227 | 0.02834 | 0.8486 | 81.64 | 79.23 | 8 | 13 | 0.3077 |
| CONT_M30_2020 | 18 | 83.33 | 1.254 | 1.167 | 0.02784 | 0.1326 | 0.5011 | 2.187 | 0.0141 | 0.9374 | 79.2 | 77.98 | 3.5 | 25 | 0.5556 |
| CONT_M30_2025-26 | 24 | 75 | 1.061 | 1.019 | 0.003971 | 0.2025 | 0.09529 | 2.418 | 0.00884 | 0.9874 | 77.07 | 76.32 | 6.5 | 21 | 0.5 |
| CONT_M30_TOTALE | 73 | 73.97 | 1.072 | 0.9822 | -0.003307 | 0.1413 | -0.2414 | 4.857 | 0.01653 | 0.9362 | 78.99 | 77.5 | 7 | 25 | 0.4384 |
| INV_M30_2013 | 2 | 100 | inf | inf | 0.1083 | 0.1083 | 0.2166 | 0 | 0.03852 | 0.3249 | 93.76 | 90.3 | 1 | 1 | 1 |
| INV_M30_2018 | 1 | 100 | inf | inf | 0.06628 | 0.06628 | 0.06628 | 0 | 0.01326 | 0.3072 | 93.42 | 90.71 | 8 | 8 | 0 |
| INV_M30_2020 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_M30_2025-26 | 2 | 50 | 0.1886 | 0.1814 | -0.4093 | -0.4093 | -0.8186 | 1 | 0.00547 | 0.7567 | 80.73 | 80.11 | 4.5 | 8 | 0 |
| INV_M30_TOTALE | 5 | 80 | 0.5635 | 0.4642 | -0.1072 | 0.07679 | -0.5358 | 1 | 0.02025 | 0.4941 | 88.48 | 86.31 | 1 | 8 | 0.4 |
| POOLED_M30 | 78 | 74.36 | 1.037 | 0.9466 | -0.009964 | 0.1338 | -0.7772 | 4.684 | 0.01677 | 0.9078 | 79.6 | 78.06 | 7 | 25 | 0.4359 |

Uscite per motivo e altri conteggi:
- CONT_H1_2013: motivi {"SL": 1, "TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2018: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- CONT_H1_2020: motivi {"SL": 1, "TP": 6}; SL+TP stesso minuto 0; spread0 2; fine_dati/mkt 0
- CONT_H1_2025-26: motivi {"TP": 10}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_TOTALE: motivi {"SL": 2, "TP": 19}; SL+TP stesso minuto 0; spread0 2; fine_dati/mkt 0
- INV_H1_2013: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2018: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2020: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2025-26: motivi {"SL": 1, "TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_TOTALE: motivi {"SL": 1, "TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- POOLED_H1: motivi {"SL": 3, "TP": 21}; SL+TP stesso minuto 0; spread0 2; fine_dati/mkt 0
- CONT_M30_2013: motivi {"SL": 5, "TP": 13}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2018: motivi {"TP": 13}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2020: motivi {"SL": 3, "TP": 15}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 0
- CONT_M30_2025-26: motivi {"SL": 5, "TP": 19}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_TOTALE: motivi {"SL": 13, "TP": 60}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 0
- INV_M30_2013: motivi {"TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2018: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2020: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_M30_2025-26: motivi {"SL": 1, "TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_TOTALE: motivi {"SL": 1, "TP": 4}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- POOLED_M30: motivi {"SL": 14, "TP": 64}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 0

## T3 Fasce (stratificazione, descrittori)
- **pooled**
  - **fascia**
    - **Buono**
      - n: 10
      - vincite: 9
      - long: 6
      - wr_pct: 90
      - media_R: 0.1716
      - wr0_pct: 75.96
      - nota: N<30: solo descrittivo
    - **Medio**
      - n: 9
      - vincite: 7
      - long: 7
    - **Ottimo**
      - n: 5
      - vincite: 5
      - long: 1
  - **fascia_accorpata**
    - **<70**
      - n: 9
      - vincite: 7
      - long: 7
    - **>=70**
      - n: 15
      - vincite: 14
      - long: 7
      - wr_pct: 93.33
      - media_R: 0.2253
      - wr0_pct: 75.32
      - nota: N<30: solo descrittivo
  - **n_prev**
    - **0**
      - n: 12
      - vincite: 11
      - long: 8
      - wr_pct: 91.67
      - media_R: 0.2167
      - wr0_pct: 74.32
      - nota: N<30: solo descrittivo
    - **1**
      - n: 11
      - vincite: 9
      - long: 5
      - wr_pct: 81.82
      - media_R: 0.05575
      - wr0_pct: 76.24
      - nota: N<30: solo descrittivo
    - **>=2**
      - n: 1
      - vincite: 1
      - long: 1
  - **congestione_valida**
    - **no**
      - n: 19
      - vincite: 16
      - long: 13
      - wr_pct: 84.21
      - media_R: 0.09345
      - wr0_pct: 75.9
      - nota: N<30: solo descrittivo
    - **si**
      - n: 5
      - vincite: 5
      - long: 1
  - **checklist_stretta**
    - **no**
      - n: 24
      - vincite: 21
      - long: 14
      - wr_pct: 87.5
      - media_R: 0.1433
      - wr0_pct: 75.51
      - nota: N<30: solo descrittivo
  - **lato**
    - **long**
      - n: 14
      - vincite: 13
      - long: 14
      - wr_pct: 92.86
      - media_R: 0.2173
      - wr0_pct: 76.3
      - nota: N<30: solo descrittivo
    - **short**
      - n: 10
      - vincite: 8
      - long: 0
      - wr_pct: 80
      - media_R: 0.03964
      - wr0_pct: 74.39
      - nota: N<30: solo descrittivo
  - **periodo**
    - **2013**
      - n: 4
      - vincite: 3
      - long: 3
    - **2018**
      - n: 1
      - vincite: 1
      - long: 1
    - **2020**
      - n: 7
      - vincite: 6
      - long: 4
    - **2025-26**
      - n: 12
      - vincite: 11
      - long: 6
      - wr_pct: 91.67
      - media_R: 0.2102
      - wr0_pct: 73.96
      - nota: N<30: solo descrittivo
  - **fascia_oraria_server**
    - **0-7**
      - n: 3
      - vincite: 2
      - long: 2
    - **16-23**
      - n: 1
      - vincite: 0
      - long: 0
    - **8-15**
      - n: 20
      - vincite: 19
      - long: 12
      - wr_pct: 95
      - media_R: 0.2511
      - wr0_pct: 75.04
      - nota: N<30: solo descrittivo
- **CONT**
  - **fascia**
    - **Buono**
      - n: 9
      - vincite: 8
      - long: 6
    - **Medio**
      - n: 7
      - vincite: 6
      - long: 6
    - **Ottimo**
      - n: 5
      - vincite: 5
      - long: 1
  - **fascia_accorpata**
    - **<70**
      - n: 7
      - vincite: 6
      - long: 6
    - **>=70**
      - n: 14
      - vincite: 13
      - long: 7
      - wr_pct: 92.86
      - media_R: 0.2196
      - wr0_pct: 75.22
      - nota: N<30: solo descrittivo
  - **n_prev**
    - **0**
      - n: 10
      - vincite: 10
      - long: 7
      - wr_pct: 100
      - media_R: 0.35
      - wr0_pct: 73.06
      - nota: N<30: solo descrittivo
    - **1**
      - n: 10
      - vincite: 8
      - long: 5
      - wr_pct: 80
      - media_R: 0.03085
      - wr0_pct: 76.2
      - nota: N<30: solo descrittivo
    - **>=2**
      - n: 1
      - vincite: 1
      - long: 1
  - **congestione_valida**
    - **no**
      - n: 16
      - vincite: 14
      - long: 12
      - wr_pct: 87.5
      - media_R: 0.1482
      - wr0_pct: 75.26
      - nota: N<30: solo descrittivo
    - **si**
      - n: 5
      - vincite: 5
      - long: 1
  - **checklist_stretta**
    - **no**
      - n: 21
      - vincite: 19
      - long: 13
      - wr_pct: 90.48
      - media_R: 0.1921
      - wr0_pct: 74.96
      - nota: N<30: solo descrittivo
  - **lato**
    - **long**
      - n: 13
      - vincite: 12
      - long: 13
      - wr_pct: 92.31
      - media_R: 0.2263
      - wr0_pct: 75.18
      - nota: N<30: solo descrittivo
    - **short**
      - n: 8
      - vincite: 7
      - long: 0
  - **periodo**
    - **2013**
      - n: 4
      - vincite: 3
      - long: 3
    - **2020**
      - n: 7
      - vincite: 6
      - long: 4
    - **2025-26**
      - n: 10
      - vincite: 10
      - long: 6
      - wr_pct: 100
      - media_R: 0.3218
      - wr0_pct: 74.05
      - nota: N<30: solo descrittivo
  - **fascia_oraria_server**
    - **0-7**
      - n: 3
      - vincite: 2
      - long: 2
    - **8-15**
      - n: 18
      - vincite: 17
      - long: 11
      - wr_pct: 94.44
      - media_R: 0.2565
      - wr0_pct: 74.07
      - nota: N<30: solo descrittivo
- **INV**
  - **fascia**
    - **Buono**
      - n: 1
      - vincite: 1
      - long: 0
    - **Medio**
      - n: 2
      - vincite: 1
      - long: 1
  - **fascia_accorpata**
    - **<70**
      - n: 2
      - vincite: 1
      - long: 1
    - **>=70**
      - n: 1
      - vincite: 1
      - long: 0
  - **n_prev**
    - **0**
      - n: 2
      - vincite: 1
      - long: 1
    - **1**
      - n: 1
      - vincite: 1
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 3
      - vincite: 2
      - long: 1
  - **checklist_stretta**
    - **no**
      - n: 3
      - vincite: 2
      - long: 1
  - **lato**
    - **long**
      - n: 1
      - vincite: 1
      - long: 1
    - **short**
      - n: 2
      - vincite: 1
      - long: 0
  - **periodo**
    - **2018**
      - n: 1
      - vincite: 1
      - long: 1
    - **2025-26**
      - n: 2
      - vincite: 1
      - long: 0
  - **fascia_oraria_server**
    - **16-23**
      - n: 1
      - vincite: 0
      - long: 0
    - **8-15**
      - n: 2
      - vincite: 2
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
    - n_trade: 24
    - n_abbinati: 24
    - media_osservata_R: 0.1433
    - media_nulla: -0.01316
    - p5: -0.1978
    - p50: -0.01025
    - p95: 0.1485
    - percentile_osservato: 0.9415
    - p_B: 0.05897
    - pf_nullo_p50: 0.946
    - pf_osservato: 2.146
  - **variante_CONT**
    - n_trade: 21
    - n_abbinati: 21
    - media_osservata_R: 0.1921
    - media_nulla: -0.009482
    - p5: -0.202
    - p50: -0.009297
    - p95: 0.1648
    - percentile_osservato: 0.97
    - p_B: 0.03048
    - pf_nullo_p50: 0.9546
    - pf_osservato: 3.017
  - **variante_INV**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: -0.1984
    - media_nulla: -0.03887
    - p5: -0.5759
    - p50: 0.03025
    - p95: 0.2671
    - percentile_osservato: 0.3005
    - p_B: 0.6997
    - pf_nullo_p50: 1.427
    - pf_osservato: 0.4048
  - **periodo_2013**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: -0.08939
    - media_nulla: -0.04284
    - p5: -0.4361
    - p50: -0.07538
    - p95: 0.2357
    - percentile_osservato: 0.447
    - p_B: 0.5532
    - pf_nullo_p50: 0.6978
    - pf_osservato: 0.6424
  - **periodo_2018**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.1
    - media_nulla: -0.1562
    - p5: -1
    - p50: 0.08966
    - p95: 0.1128
    - percentile_osservato: 0.712
    - p_B: 0.2884
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 7
    - n_abbinati: 7
    - media_osservata_R: 0.1677
    - media_nulla: -0.03249
    - p5: -0.4077
    - p50: -0.03044
    - p95: 0.2952
    - percentile_osservato: 0.839
    - p_B: 0.1614
    - pf_nullo_p50: 0.8693
    - pf_osservato: 2.174
  - **periodo_2025-26**
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: 0.2102
    - media_nulla: 0.01994
    - p5: -0.2316
    - p50: 0.03091
    - p95: 0.2452
    - percentile_osservato: 0.9215
    - p_B: 0.07896
    - pf_nullo_p50: 1.179
    - pf_osservato: 3.523
  - **lato_long**
    - n_trade: 14
    - n_abbinati: 14
    - media_osservata_R: 0.2173
    - media_nulla: -0.02085
    - p5: -0.2565
    - p50: -0.01477
    - p95: 0.184
    - percentile_osservato: 0.9745
    - p_B: 0.02599
    - pf_nullo_p50: 0.9255
    - pf_osservato: 4.043
  - **lato_short**
    - n_trade: 10
    - n_abbinati: 10
    - media_osservata_R: 0.03964
    - media_nulla: -0.002381
    - p5: -0.2733
    - p50: 0.0004981
    - p95: 0.2503
    - percentile_osservato: 0.587
    - p_B: 0.4133
    - pf_nullo_p50: 1.003
    - pf_osservato: 1.198
- **B0**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 24
    - n_abbinati: 24
    - media_osservata_R: 0.1433
    - media_nulla: -0.01936
    - p5: -0.1855
    - p50: -0.01393
    - p95: 0.1321
    - percentile_osservato: 0.963
    - p_B: 0.03748
    - pf_nullo_p50: 0.9259
    - pf_osservato: 2.146
  - **variante_CONT**
    - n_trade: 21
    - n_abbinati: 21
    - media_osservata_R: 0.1921
    - media_nulla: -0.01482
    - p5: -0.1971
    - p50: -0.008279
    - p95: 0.1516
    - percentile_osservato: 0.9845
    - p_B: 0.01599
    - pf_nullo_p50: 0.9547
    - pf_osservato: 3.017
  - **variante_INV**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: -0.1984
    - media_nulla: -0.0511
    - p5: -0.63
    - p50: 0.03687
    - p95: 0.268
    - percentile_osservato: 0.325
    - p_B: 0.6752
    - pf_nullo_p50: 1.441
    - pf_osservato: 0.4048
  - **periodo_2013**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: -0.08939
    - media_nulla: -0.02754
    - p5: -0.418
    - p50: -0.01829
    - p95: 0.2282
    - percentile_osservato: 0.422
    - p_B: 0.5782
    - pf_nullo_p50: 0.8726
    - pf_osservato: 0.6424
  - **periodo_2018**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.1
    - media_nulla: -0.09122
    - p5: -1
    - p50: 0.09041
    - p95: 0.1138
    - percentile_osservato: 0.706
    - p_B: 0.2944
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 7
    - n_abbinati: 7
    - media_osservata_R: 0.1677
    - media_nulla: -0.04491
    - p5: -0.3927
    - p50: -0.02467
    - p95: 0.2589
    - percentile_osservato: 0.851
    - p_B: 0.1494
    - pf_nullo_p50: 0.8623
    - pf_osservato: 2.174
  - **periodo_2025-26**
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: 0.2102
    - media_nulla: 0.004264
    - p5: -0.2423
    - p50: 0.01193
    - p95: 0.216
    - percentile_osservato: 0.942
    - p_B: 0.05847
    - pf_nullo_p50: 1.07
    - pf_osservato: 3.523
  - **lato_long**
    - n_trade: 14
    - n_abbinati: 14
    - media_osservata_R: 0.2173
    - media_nulla: -0.001454
    - p5: -0.211
    - p50: 0.004844
    - p95: 0.1906
    - percentile_osservato: 0.977
    - p_B: 0.02349
    - pf_nullo_p50: 1.029
    - pf_osservato: 4.043
  - **lato_short**
    - n_trade: 10
    - n_abbinati: 10
    - media_osservata_R: 0.03964
    - media_nulla: -0.04443
    - p5: -0.3226
    - p50: -0.03231
    - p95: 0.2078
    - percentile_osservato: 0.6745
    - p_B: 0.3258
    - pf_nullo_p50: 0.8378
    - pf_osservato: 1.198
- **B2**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 24
    - n_abbinati: 24
    - media_osservata_R: 0.1433
    - media_nulla: 0.0288
    - p5: -0.1262
    - p50: 0.03432
    - p95: 0.1668
    - percentile_osservato: 0.9055
    - p_B: 0.09495
    - pf_nullo_p50: 1.227
    - pf_osservato: 2.146
  - **variante_CONT**
    - n_trade: 21
    - n_abbinati: 21
    - media_osservata_R: 0.1921
    - media_nulla: 0.03081
    - p5: -0.1387
    - p50: 0.03395
    - p95: 0.1814
    - percentile_osservato: 0.9645
    - p_B: 0.03598
    - pf_nullo_p50: 1.221
    - pf_osservato: 3.017
  - **variante_INV**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: -0.1984
    - media_nulla: 0.01474
    - p5: -0.351
    - p50: 0.1045
    - p95: 0.2675
    - percentile_osservato: 0.2635
    - p_B: 0.7366
    - pf_nullo_p50: 5.371
    - pf_osservato: 0.4048
  - **periodo_2013**
    - n_trade: 4
    - n_abbinati: 4
    - media_osservata_R: -0.08939
    - media_nulla: -0.05367
    - p5: -0.434
    - p50: -0.0943
    - p95: 0.2226
    - percentile_osservato: 0.515
    - p_B: 0.4853
    - pf_nullo_p50: 0.6226
    - pf_osservato: 0.6424
  - **periodo_2018**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.1
    - media_nulla: 0.08792
    - p5: 0.035
    - p50: 0.09158
    - p95: 0.1144
    - percentile_osservato: 0.729
    - p_B: 0.2714
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2020**
    - n_trade: 7
    - n_abbinati: 7
    - media_osservata_R: 0.1677
    - media_nulla: 0.07187
    - p5: -0.2403
    - p50: 0.08756
    - p95: 0.314
    - percentile_osservato: 0.6655
    - p_B: 0.3348
    - pf_nullo_p50: 1.609
    - pf_osservato: 2.174
  - **periodo_2025-26**
    - n_trade: 12
    - n_abbinati: 12
    - media_osservata_R: 0.2102
    - media_nulla: 0.02624
    - p5: -0.2113
    - p50: 0.03727
    - p95: 0.226
    - percentile_osservato: 0.9285
    - p_B: 0.07196
    - pf_nullo_p50: 1.231
    - pf_osservato: 3.523
  - **lato_long**
    - n_trade: 14
    - n_abbinati: 14
    - media_osservata_R: 0.2173
    - media_nulla: 0.03881
    - p5: -0.1633
    - p50: 0.04102
    - p95: 0.2197
    - percentile_osservato: 0.9465
    - p_B: 0.05397
    - pf_nullo_p50: 1.281
    - pf_osservato: 4.043
  - **lato_short**
    - n_trade: 10
    - n_abbinati: 10
    - media_osservata_R: 0.03964
    - media_nulla: 0.01478
    - p5: -0.2185
    - p50: 0.02118
    - p95: 0.2258
    - percentile_osservato: 0.5435
    - p_B: 0.4568
    - pf_nullo_p50: 1.128
    - pf_osservato: 1.198
- **pool_barre_simulate**
  - **2013**
    - long: 2849
    - short: 2996
  - **2018**
    - long: 2965
    - short: 2917
  - **2020**
    - long: 2667
    - short: 3262
  - **2025-26**
    - long: 5155
    - short: 5298

## T5 Robustezza della primaria
- **bootstrap_settimane**
  - settimane: 22
  - media: 0.1433
  - ic90_lo: -0.02459
  - ic90_hi: 0.2834
  - n_replicati: 10000
- **senza_i_migliori_3**
  - n: 21
  - media_R: 0.08753
  - pf_netto: 1.613
- **con_tutti**
  - n: 24
  - media_R: 0.1433
  - pf_netto: 2.146
- **leave_one_period_out**
  - **2013**
    - n: 20
    - media_R: 0.1898
    - pf_netto: 2.898
  - **2018**
    - n: 23
    - media_R: 0.1452
    - pf_netto: 2.113
  - **2020**
    - n: 17
    - media_R: 0.1332
    - pf_netto: 2.133
  - **2025-26**
    - n: 12
    - media_R: 0.07635
    - pf_netto: 1.458
- **quota_profitto_per_periodo**
  - 2013: -0.104
  - 2018: 0.02909
  - 2020: 0.3413
  - 2025-26: 0.7336
- **spread_x1.5**
  - n: 24
  - media_R: 0.1412
  - pf_netto: 2.13
- **escluso_spread0**
  - n: 22
  - media_R: 0.1157
  - pf_netto: 1.848

## T6 Sensibilita (riportate per intero, non selezionabili)
| sens | segnali | n | win_pct | pf_netto | attesa_R | netto_R | dd_max_R |
|---|---|---|---|---|---|---|---|
| Sa | 25 | 24 | 87.5 | 2.146 | 0.1433 | 3.439 | 1.9 |
| Sb | 22 | 21 | 90.48 | 3.017 | 0.1921 | 4.034 | 2 |
| Sc | 25 | 24 | 87.5 | 2.146 | 0.1433 | 3.439 | 1.9 |
| Sd | 25 | 24 | 87.5 | 2.13 | 0.1412 | 3.39 | 1.903 |
| Se20 | 24 | 24 | 87.5 | 2.146 | 0.1433 | 3.439 | 1.9 |
| Se50 | 24 | 23 | 86.96 | 2.102 | 0.1438 | 3.307 | 1.9 |
| Sf | 23 | 23 | 91.3 | 3.192 | 0.1906 | 4.385 | 1 |
| Sg | 27 | 26 | 88.46 | 2.278 | 0.1475 | 3.834 | 1.9 |

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
  - buy_and_hold_in_ATR: 16.74
  - atr_mediana_prezzo: 0.001873
  - **long**
    - n: 3
    - media_R: 0.2141
  - **short**
    - n: 1
    - media_R: -1
- **2018**
  - buy_and_hold_in_ATR: -41.13
  - atr_mediana_prezzo: 0.001879
  - **long**
    - n: 1
    - media_R: 0.1
  - **short**
    - n: 0
    - media_R: -
- **2020**
  - buy_and_hold_in_ATR: 21.2
  - atr_mediana_prezzo: 0.002205
  - **long**
    - n: 4
    - media_R: 0.0367
  - **short**
    - n: 3
    - media_R: 0.3423
- **2025-26**
  - buy_and_hold_in_ATR: 47.25
  - atr_mediana_prezzo: 0.001575
  - **long**
    - n: 6
    - media_R: 0.3589
  - **short**
    - n: 6
    - media_R: 0.06157

## T9 Dati / esecuzione
- **spread0_sostituiti_per_periodo**
  - 2013: 0
  - 2018: 6
  - 2020: 14313
  - 2025-26: 1825
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
  - trade_spread0_ingresso: 1
  - trade_spread0_uscita: 1
  - gap_ingresso_max_min: 0
  - trade_con_gap_ingresso_gt_0: 0
  - trade_chiusi_fine_dati: 0
  - uscite_a_mercato_target_superato: 0
  - ricalcoli_target_totali: 15
  - eventi_sl_tp_stesso_minuto: 0
  - **segnali_scartati**
    - scartati_posizione_aperta: 0
    - scartati_target_oltre_ingresso: 0
    - scartati_indicatori_non_pronti: 0
    - scartati_no_barra_successiva: 0
    - scartati_gap_ingresso: 1
  - segnali_totali: 25
  - tocchi_penetrazione_lt_spread_sui_segnali: 0
  - coppie_CONT_INV_stesso_episodio: 0

## Log dei trade
Schedule completa dei target per ogni trade nel JSON (chiave tabelle.LOG_TRADE).
