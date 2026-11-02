# Breaking Band su EURUSD — risultati (generato da run_test.py)

sha256 dei risultati (JSON canonico): `7d9397e3964e6d8ef94d4900166a4d9dc15df224a6a1d704acb724da5cea460c`

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
  - 2015: e502fbdfaa5bae4d43c7a82debde10604759583cd19965f6b75a33895b5b9d8f
  - 2017: 400cc929dcf9c9e7488c6321b649e5ab3c46474cf191960f50a24d800f37046e
  - 2019: e17bd81f283358818bf9045929e7d0485a5db0dd6c7dca45e198465a05e5bb03
  - 2022: 88255bbcd08738944fb698c746e825b100cf2e8849b17d74a4216a0f400cd113
- **righe_csv**
  - 2015: 370886
  - 2017: 370355
  - 2019: 371475
  - 2022: 372850
- simbolo: EURUSD
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
  - ABTG_M1_EURUSD_2015.csv: True
  - ABTG_M1_EURUSD_2017.csv: True
  - ABTG_M1_EURUSD_2019.csv: True
  - ABTG_M1_EURUSD_2022.csv: True
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
- N: 11
- media_R: 0.1303
- pf_netto: 2.126
- p_B1: 0.3073
- **ic90**
  - settimane: 11
  - media: 0.1303
  - ic90_lo: -0.09438
  - ic90_hi: 0.3231
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
### CONT_H1 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 52 | 89.66 | BAND_RIDING |
| C0_tocco_banda_opposta | 31 | 59.62 | T_MAX |
| C3_sequenza | 28 | 90.32 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 8 | 28.57 | T_MAX |
| C1b_candela_test_non_impulsiva | 5 | 62.5 | - |
| sd<S50 | 5 | 100 | T_MAX |
| sd<=sd[-3] | 4 | 80 | - |
| SEGNALE | 4 | 100 | - |
Segnali e trade: {"eseguiti": 4, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 4}

Armati: {"+1": 27, "-1": 31}; fine episodi: {"BAND_RIDING": 28, "OPPOSTO": 4, "T_MAX": 26}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 14, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 4, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 56 | - | BAND_RIDING |
| finestra | 50 | 89.29 | BAND_RIDING |
| C0_tocco_banda_opposta | 14 | 28 | BAND_RIDING |
| C3_sequenza | 13 | 92.86 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 4 | 30.77 | T_MAX |
| C1b_candela_test_non_impulsiva | 3 | 75 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 36, "-1": 20}; fine episodi: {"BAND_RIDING": 41, "OPPOSTO": 3, "T_MAX": 12}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 5, "episodi_seq_violata_su_barra_di_tocco": 3, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 55 | - | BAND_RIDING |
| finestra | 51 | 92.73 | BAND_RIDING |
| C0_tocco_banda_opposta | 20 | 39.22 | T_MAX |
| C3_sequenza | 18 | 90 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 7 | 38.89 | T_MAX |
| C1b_candela_test_non_impulsiva | 2 | 28.57 | T_MAX |
| sd<S50 | 1 | 50 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 28, "-1": 27}; fine episodi: {"BAND_RIDING": 36, "OPPOSTO": 1, "T_MAX": 18}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 9, "episodi_seq_violata_su_barra_di_tocco": 3, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 52 | - | BAND_RIDING |
| finestra | 48 | 92.31 | BAND_RIDING |
| C0_tocco_banda_opposta | 19 | 39.58 | - |
| C3_sequenza | 19 | 100 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 5 | 26.32 | T_MAX |
| C1b_candela_test_non_impulsiva | 1 | 20 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 27, "-1": 25}; fine episodi: {"BAND_RIDING": 35, "OPPOSTO": 2, "T_MAX": 15}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 4, "episodi_seq_violata_su_barra_di_tocco": 1, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 221 | - | BAND_RIDING |
| finestra | 201 | 90.95 | BAND_RIDING |
| C0_tocco_banda_opposta | 84 | 41.79 | T_MAX |
| C3_sequenza | 78 | 92.86 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 24 | 30.77 | T_MAX |
| C1b_candela_test_non_impulsiva | 11 | 45.83 | T_MAX |
| sd<S50 | 10 | 90.91 | T_MAX |
| sd<=sd[-3] | 9 | 90 | - |
| SEGNALE | 9 | 100 | - |
Segnali e trade: {"eseguiti": 9, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 9}

Armati: {"+1": 118, "-1": 103}; fine episodi: {"BAND_RIDING": 140, "OPPOSTO": 10, "T_MAX": 71}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 32, "episodi_seq_violata_su_barra_di_tocco": 11, "segnali_con_impulsiva_1.0_violata": 9, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 52 | 89.66 | BAND_RIDING |
| I0_mediana_toccata | 40 | 76.92 | T_MAX |
| I1_banda_opposta_mai_toccata | 14 | 35 | T_MAX |
| retest_banda_impulso | 3 | 21.43 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 33.33 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 27, "-1": 31}; fine episodi: {"BAND_RIDING": 28, "OPPOSTO": 4, "T_MAX": 26}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 56 | - | BAND_RIDING |
| finestra | 50 | 89.29 | BAND_RIDING |
| I0_mediana_toccata | 29 | 58 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 8 | 27.59 | T_MAX |
| retest_banda_impulso | 2 | 25 | BAND_RIDING |
| I2_nessuna_impulsiva | 0 | 0 | - |
| I3_banda_piatta | 0 | - | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I2_nessuna_impulsiva", "da": 2, "a": 0}]

Armati: {"+1": 36, "-1": 20}; fine episodi: {"BAND_RIDING": 41, "OPPOSTO": 3, "T_MAX": 12}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 55 | - | BAND_RIDING |
| finestra | 51 | 92.73 | BAND_RIDING |
| I0_mediana_toccata | 43 | 84.31 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 13 | 30.23 | BAND_RIDING |
| retest_banda_impulso | 6 | 46.15 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 16.67 | BAND_RIDING |
| I3_banda_piatta | 0 | 0 | - |
| sd<S50 | 0 | - | - |
| sd<=sd[-3] | 0 | - | - |
| SEGNALE | 0 | - | - |
Segnali e trade: {"eseguiti": 0, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 0}

Filtro quasi auto-colpente (>90% eliminato): [{"stadio_che_elimina": "I3_banda_piatta", "da": 1, "a": 0}]

Armati: {"+1": 28, "-1": 27}; fine episodi: {"BAND_RIDING": 36, "OPPOSTO": 1, "T_MAX": 18}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 0, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 52 | - | BAND_RIDING |
| finestra | 48 | 92.31 | BAND_RIDING |
| I0_mediana_toccata | 31 | 64.58 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 13 | 41.94 | T_MAX |
| retest_banda_impulso | 2 | 15.38 | T_MAX |
| I2_nessuna_impulsiva | 1 | 50 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 27, "-1": 25}; fine episodi: {"BAND_RIDING": 35, "OPPOSTO": 2, "T_MAX": 15}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 221 | - | BAND_RIDING |
| finestra | 201 | 90.95 | BAND_RIDING |
| I0_mediana_toccata | 143 | 71.14 | T_MAX |
| I1_banda_opposta_mai_toccata | 48 | 33.57 | T_MAX |
| retest_banda_impulso | 13 | 27.08 | BAND_RIDING |
| I2_nessuna_impulsiva | 3 | 23.08 | BAND_RIDING |
| I3_banda_piatta | 2 | 66.67 | - |
| sd<S50 | 2 | 100 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 118, "-1": 103}; fine episodi: {"BAND_RIDING": 140, "OPPOSTO": 10, "T_MAX": 71}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 165 | - | BAND_RIDING |
| finestra | 152 | 92.12 | BAND_RIDING |
| C0_tocco_banda_opposta | 76 | 50 | T_MAX |
| C3_sequenza | 70 | 92.11 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 28 | 40 | T_MAX |
| C1b_candela_test_non_impulsiva | 17 | 60.71 | - |
| sd<S50 | 17 | 100 | T_MAX |
| sd<=sd[-3] | 14 | 82.35 | - |
| SEGNALE | 14 | 100 | - |
Segnali e trade: {"eseguiti": 13, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 1, "segnali": 14}

Armati: {"+1": 73, "-1": 92}; fine episodi: {"BAND_RIDING": 75, "OPPOSTO": 13, "T_MAX": 77}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 33, "episodi_seq_violata_su_barra_di_tocco": 6, "segnali_con_impulsiva_1.0_violata": 13, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 141 | - | BAND_RIDING |
| finestra | 122 | 86.52 | BAND_RIDING |
| C0_tocco_banda_opposta | 56 | 45.9 | T_MAX |
| C3_sequenza | 53 | 94.64 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 25 | 47.17 | T_MAX |
| C1b_candela_test_non_impulsiva | 19 | 76 | - |
| sd<S50 | 19 | 100 | T_MAX |
| sd<=sd[-3] | 12 | 63.16 | - |
| SEGNALE | 12 | 100 | - |
Segnali e trade: {"eseguiti": 12, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 12}

Armati: {"+1": 80, "-1": 61}; fine episodi: {"BAND_RIDING": 77, "OPPOSTO": 10, "T_MAX": 54}; extra: {"episodi_consumati_tocco_precoce": 2, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 26, "episodi_seq_violata_su_barra_di_tocco": 3, "segnali_con_impulsiva_1.0_violata": 11, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 147 | - | BAND_RIDING |
| finestra | 131 | 89.12 | BAND_RIDING |
| C0_tocco_banda_opposta | 61 | 46.56 | T_MAX |
| C3_sequenza | 54 | 88.52 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 33 | 61.11 | T_MAX |
| C1b_candela_test_non_impulsiva | 24 | 72.73 | T_MAX |
| sd<S50 | 22 | 91.67 | T_MAX |
| sd<=sd[-3] | 16 | 72.73 | - |
| SEGNALE | 16 | 100 | - |
Segnali e trade: {"eseguiti": 14, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 2, "segnali": 16}

Armati: {"+1": 73, "-1": 74}; fine episodi: {"BAND_RIDING": 71, "OPPOSTO": 11, "T_MAX": 65}; extra: {"episodi_consumati_tocco_precoce": 3, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 29, "episodi_seq_violata_su_barra_di_tocco": 8, "segnali_con_impulsiva_1.0_violata": 13, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 144 | - | BAND_RIDING |
| finestra | 134 | 93.06 | BAND_RIDING |
| C0_tocco_banda_opposta | 50 | 37.31 | T_MAX |
| C3_sequenza | 47 | 94 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 20 | 42.55 | T_MAX |
| C1b_candela_test_non_impulsiva | 15 | 75 | BAND_RIDING |
| sd<S50 | 13 | 86.67 | BAND_RIDING |
| sd<=sd[-3] | 11 | 84.62 | - |
| SEGNALE | 11 | 100 | - |
Segnali e trade: {"eseguiti": 11, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 11}

Armati: {"+1": 66, "-1": 78}; fine episodi: {"BAND_RIDING": 74, "OPPOSTO": 14, "T_MAX": 56}; extra: {"episodi_consumati_tocco_precoce": 3, "episodi_eliminati_solo_da_SEQ": 2, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 21, "episodi_seq_violata_su_barra_di_tocco": 3, "segnali_con_impulsiva_1.0_violata": 10, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 597 | - | BAND_RIDING |
| finestra | 539 | 90.28 | BAND_RIDING |
| C0_tocco_banda_opposta | 243 | 45.08 | T_MAX |
| C3_sequenza | 224 | 92.18 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 106 | 47.32 | T_MAX |
| C1b_candela_test_non_impulsiva | 75 | 70.75 | T_MAX |
| sd<S50 | 71 | 94.67 | T_MAX |
| sd<=sd[-3] | 53 | 74.65 | - |
| SEGNALE | 53 | 100 | - |
Segnali e trade: {"eseguiti": 50, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 3, "segnali": 53}

Armati: {"+1": 292, "-1": 305}; fine episodi: {"BAND_RIDING": 297, "OPPOSTO": 48, "T_MAX": 252}; extra: {"episodi_consumati_tocco_precoce": 8, "episodi_eliminati_solo_da_SEQ": 3, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 109, "episodi_seq_violata_su_barra_di_tocco": 20, "segnali_con_impulsiva_1.0_violata": 47, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2015
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 165 | - | BAND_RIDING |
| finestra | 152 | 92.12 | BAND_RIDING |
| I0_mediana_toccata | 124 | 81.58 | T_MAX |
| I1_banda_opposta_mai_toccata | 35 | 28.23 | T_MAX |
| retest_banda_impulso | 9 | 25.71 | BAND_RIDING |
| I2_nessuna_impulsiva | 3 | 33.33 | - |
| I3_banda_piatta | 3 | 100 | - |
| sd<S50 | 3 | 100 | BAND_RIDING |
| sd<=sd[-3] | 2 | 66.67 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 73, "-1": 92}; fine episodi: {"BAND_RIDING": 75, "OPPOSTO": 13, "T_MAX": 77}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2017
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 141 | - | BAND_RIDING |
| finestra | 122 | 86.52 | BAND_RIDING |
| I0_mediana_toccata | 89 | 72.95 | T_MAX |
| I1_banda_opposta_mai_toccata | 23 | 25.84 | T_MAX |
| retest_banda_impulso | 3 | 13.04 | T_MAX |
| I2_nessuna_impulsiva | 1 | 33.33 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 80, "-1": 61}; fine episodi: {"BAND_RIDING": 77, "OPPOSTO": 10, "T_MAX": 54}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2019
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 147 | - | BAND_RIDING |
| finestra | 131 | 89.12 | BAND_RIDING |
| I0_mediana_toccata | 105 | 80.15 | T_MAX |
| I1_banda_opposta_mai_toccata | 25 | 23.81 | T_MAX |
| retest_banda_impulso | 5 | 20 | T_MAX |
| I2_nessuna_impulsiva | 2 | 40 | - |
| I3_banda_piatta | 2 | 100 | - |
| sd<S50 | 2 | 100 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 73, "-1": 74}; fine episodi: {"BAND_RIDING": 71, "OPPOSTO": 11, "T_MAX": 65}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2022
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 144 | - | BAND_RIDING |
| finestra | 134 | 93.06 | BAND_RIDING |
| I0_mediana_toccata | 94 | 70.15 | T_MAX |
| I1_banda_opposta_mai_toccata | 22 | 23.4 | T_MAX |
| retest_banda_impulso | 7 | 31.82 | BAND_RIDING |
| I2_nessuna_impulsiva | 2 | 28.57 | - |
| I3_banda_piatta | 2 | 100 | - |
| sd<S50 | 2 | 100 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 66, "-1": 78}; fine episodi: {"BAND_RIDING": 74, "OPPOSTO": 14, "T_MAX": 56}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 597 | - | BAND_RIDING |
| finestra | 539 | 90.28 | BAND_RIDING |
| I0_mediana_toccata | 412 | 76.44 | T_MAX |
| I1_banda_opposta_mai_toccata | 105 | 25.49 | T_MAX |
| retest_banda_impulso | 24 | 22.86 | BAND_RIDING |
| I2_nessuna_impulsiva | 8 | 33.33 | - |
| I3_banda_piatta | 8 | 100 | - |
| sd<S50 | 8 | 100 | BAND_RIDING |
| sd<=sd[-3] | 7 | 87.5 | - |
| SEGNALE | 7 | 100 | - |
Segnali e trade: {"eseguiti": 7, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 7}

Armati: {"+1": 292, "-1": 305}; fine episodi: {"BAND_RIDING": 297, "OPPOSTO": 48, "T_MAX": 252}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 7, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

## T2 Risultati per variante x TF x periodo
| cella | n | win_pct | pf_lordo | pf_netto | attesa_R | mediana_R | netto_R | dd_max_R | costo_spread_medio_R | D_medio_atr | pareggio_atteso_medio_pct | wr0_pct | durata_mediana_barre | durata_max_barre | quota_long |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CONT_H1_2015 | 4 | 100 | inf | inf | 0.3741 | 0.2877 | 1.496 | 0 | 0.01583 | 1.256 | 72.6 | 71.47 | 4 | 5 | 0 |
| CONT_H1_2017 | 3 | 66.67 | 2.329 | 2.102 | 0.1001 | 0.2763 | 0.3003 | 0.2724 | 0.01504 | 0.9429 | 77.3 | 76.16 | 3 | 13 | 0.6667 |
| CONT_H1_2019 | 1 | 100 | inf | inf | 0.116 | 0.116 | 0.116 | 0 | 0.01077 | 1.281 | 70.83 | 70.07 | 8 | 8 | 0 |
| CONT_H1_2022 | 1 | 100 | inf | inf | 0.02736 | 0.02736 | 0.02736 | 0 | 0.002895 | 1.483 | 67.12 | 66.92 | 19 | 19 | 0 |
| CONT_H1_TOTALE | 9 | 88.89 | 8.932 | 8.12 | 0.2155 | 0.2513 | 1.94 | 0.2724 | 0.01357 | 1.18 | 73.36 | 72.37 | 5 | 19 | 0.2222 |
| INV_H1_2015 | 1 | 0 | 0 | 0 | -1 | -1 | -1 | 1 | 0.03217 | 0.547 | 87.69 | 84.58 | 1 | 1 | 0 |
| INV_H1_2017 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2019 | 0 | - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| INV_H1_2022 | 1 | 100 | inf | inf | 0.4931 | 0.4931 | 0.4931 | 0 | 0.001806 | 1.631 | 64.89 | 64.78 | 5 | 5 | 0 |
| INV_H1_TOTALE | 2 | 50 | 0.5114 | 0.4931 | -0.2534 | -0.2534 | -0.5069 | 1 | 0.01699 | 1.089 | 76.29 | 74.68 | 3 | 5 | 0 |
| POOLED_H1 | 11 | 81.82 | 2.294 | 2.126 | 0.1303 | 0.2513 | 1.433 | 1 | 0.01419 | 1.163 | 73.89 | 72.79 | 5 | 19 | 0.1818 |
| CONT_M30_2015 | 13 | 76.92 | 1.184 | 1.043 | 0.007394 | 0.1606 | 0.09612 | 1.71 | 0.02302 | 1.137 | 75.53 | 73.55 | 9 | 19 | 0.3846 |
| CONT_M30_2017 | 12 | 83.33 | 1.129 | 0.9553 | -0.007448 | 0.1016 | -0.08938 | 2 | 0.02824 | 0.8446 | 81.04 | 78.87 | 4.5 | 18 | 0.5833 |
| CONT_M30_2019 | 14 | 85.71 | 1.647 | 1.459 | 0.06553 | 0.2258 | 0.9174 | 2 | 0.02368 | 1.048 | 76.55 | 74.62 | 7.5 | 17 | 0.4286 |
| CONT_M30_2022 | 11 | 72.73 | 0.6877 | 0.6765 | -0.08821 | 0.1205 | -0.9704 | 1.703 | 0.003371 | 1.249 | 71.27 | 71.03 | 8 | 17 | 0.8182 |
| CONT_M30_TOTALE | 50 | 80 | 1.107 | 0.995 | -0.0009249 | 0.1647 | -0.04624 | 3.164 | 0.02014 | 1.066 | 76.2 | 74.57 | 7.5 | 19 | 0.54 |
| INV_M30_2015 | 2 | 100 | inf | inf | 0.4191 | 0.4191 | 0.8383 | 0 | 0.0223 | 1.257 | 73.76 | 71.53 | 3.5 | 4 | 0.5 |
| INV_M30_2017 | 1 | 100 | inf | inf | 0.1598 | 0.1598 | 0.1598 | 0 | 0.06003 | 0.4795 | 91.4 | 86.22 | 2 | 2 | 1 |
| INV_M30_2019 | 2 | 100 | inf | inf | 0.3224 | 0.3224 | 0.6448 | 0 | 0.01314 | 1.056 | 75.11 | 74.14 | 6 | 8 | 0 |
| INV_M30_2022 | 2 | 50 | 0.1438 | 0.1394 | -0.4303 | -0.4303 | -0.8606 | 1 | 0.0034 | 0.7981 | 80.06 | 79.79 | 8 | 15 | 0 |
| INV_M30_TOTALE | 7 | 85.71 | 1.923 | 1.782 | 0.1117 | 0.2462 | 0.7822 | 1 | 0.01967 | 0.9574 | 78.47 | 76.73 | 4 | 15 | 0.2857 |
| POOLED_M30 | 57 | 80.7 | 1.188 | 1.072 | 0.01291 | 0.1687 | 0.736 | 3.164 | 0.02008 | 1.053 | 76.48 | 74.84 | 7 | 19 | 0.5088 |

Uscite per motivo e altri conteggi:
- CONT_H1_2015: motivi {"TP": 4}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2017: motivi {"TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2019: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2022: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- CONT_H1_TOTALE: motivi {"TP": 9}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- INV_H1_2015: motivi {"SL": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2017: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2019: motivi {}; SL+TP stesso minuto -; spread0 -; fine_dati/mkt -
- INV_H1_2022: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- INV_H1_TOTALE: motivi {"SL": 1, "TP": 1}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- POOLED_H1: motivi {"SL": 1, "TP": 10}; SL+TP stesso minuto 0; spread0 2; fine_dati/mkt 0
- CONT_M30_2015: motivi {"MKT": 1, "SL": 2, "TP": 10}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_M30_2017: motivi {"SL": 2, "TP": 10}; SL+TP stesso minuto 0; spread0 3; fine_dati/mkt 0
- CONT_M30_2019: motivi {"MKT": 1, "SL": 2, "TP": 11}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_M30_2022: motivi {"SL": 3, "TP": 8}; SL+TP stesso minuto 0; spread0 9; fine_dati/mkt 0
- CONT_M30_TOTALE: motivi {"MKT": 2, "SL": 9, "TP": 39}; SL+TP stesso minuto 0; spread0 12; fine_dati/mkt 2
- INV_M30_2015: motivi {"TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2017: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2019: motivi {"TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2022: motivi {"SL": 1, "TP": 1}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- INV_M30_TOTALE: motivi {"SL": 1, "TP": 6}; SL+TP stesso minuto 0; spread0 1; fine_dati/mkt 0
- POOLED_M30: motivi {"MKT": 2, "SL": 10, "TP": 45}; SL+TP stesso minuto 0; spread0 13; fine_dati/mkt 2

## T3 Fasce (stratificazione, descrittori)
- **pooled**
  - **fascia**
    - **Buono**
      - n: 3
      - vincite: 1
      - long: 1
    - **Medio**
      - n: 5
      - vincite: 5
      - long: 1
    - **Ottimo**
      - n: 3
      - vincite: 3
      - long: 0
  - **fascia_accorpata**
    - **<70**
      - n: 5
      - vincite: 5
      - long: 1
    - **>=70**
      - n: 6
      - vincite: 4
      - long: 1
  - **n_prev**
    - **0**
      - n: 7
      - vincite: 6
      - long: 0
    - **1**
      - n: 1
      - vincite: 1
      - long: 0
    - **>=2**
      - n: 3
      - vincite: 2
      - long: 2
  - **congestione_valida**
    - **no**
      - n: 8
      - vincite: 6
      - long: 2
    - **si**
      - n: 3
      - vincite: 3
      - long: 0
  - **checklist_stretta**
    - **no**
      - n: 9
      - vincite: 7
      - long: 2
    - **si**
      - n: 2
      - vincite: 2
      - long: 0
  - **lato**
    - **long**
      - n: 2
      - vincite: 1
      - long: 2
    - **short**
      - n: 9
      - vincite: 8
      - long: 0
  - **periodo**
    - **2015**
      - n: 5
      - vincite: 4
      - long: 0
    - **2017**
      - n: 3
      - vincite: 2
      - long: 2
    - **2019**
      - n: 1
      - vincite: 1
      - long: 0
    - **2022**
      - n: 2
      - vincite: 2
      - long: 0
  - **fascia_oraria_server**
    - **8-15**
      - n: 11
      - vincite: 9
      - long: 2
      - wr_pct: 81.82
      - media_R: 0.1303
      - wr0_pct: 72.79
      - nota: N<30: solo descrittivo
- **CONT**
  - **fascia**
    - **Buono**
      - n: 2
      - vincite: 1
      - long: 1
    - **Medio**
      - n: 4
      - vincite: 4
      - long: 1
    - **Ottimo**
      - n: 3
      - vincite: 3
      - long: 0
  - **fascia_accorpata**
    - **<70**
      - n: 4
      - vincite: 4
      - long: 1
    - **>=70**
      - n: 5
      - vincite: 4
      - long: 1
  - **n_prev**
    - **0**
      - n: 5
      - vincite: 5
      - long: 0
    - **1**
      - n: 1
      - vincite: 1
      - long: 0
    - **>=2**
      - n: 3
      - vincite: 2
      - long: 2
  - **congestione_valida**
    - **no**
      - n: 6
      - vincite: 5
      - long: 2
    - **si**
      - n: 3
      - vincite: 3
      - long: 0
  - **checklist_stretta**
    - **no**
      - n: 7
      - vincite: 6
      - long: 2
    - **si**
      - n: 2
      - vincite: 2
      - long: 0
  - **lato**
    - **long**
      - n: 2
      - vincite: 1
      - long: 2
    - **short**
      - n: 7
      - vincite: 7
      - long: 0
  - **periodo**
    - **2015**
      - n: 4
      - vincite: 4
      - long: 0
    - **2017**
      - n: 3
      - vincite: 2
      - long: 2
    - **2019**
      - n: 1
      - vincite: 1
      - long: 0
    - **2022**
      - n: 1
      - vincite: 1
      - long: 0
  - **fascia_oraria_server**
    - **8-15**
      - n: 9
      - vincite: 8
      - long: 2
- **INV**
  - **fascia**
    - **Buono**
      - n: 1
      - vincite: 0
      - long: 0
    - **Medio**
      - n: 1
      - vincite: 1
      - long: 0
  - **fascia_accorpata**
    - **<70**
      - n: 1
      - vincite: 1
      - long: 0
    - **>=70**
      - n: 1
      - vincite: 0
      - long: 0
  - **n_prev**
    - **0**
      - n: 2
      - vincite: 1
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 2
      - vincite: 1
      - long: 0
  - **checklist_stretta**
    - **no**
      - n: 2
      - vincite: 1
      - long: 0
  - **lato**
    - **short**
      - n: 2
      - vincite: 1
      - long: 0
  - **periodo**
    - **2015**
      - n: 1
      - vincite: 0
      - long: 0
    - **2022**
      - n: 1
      - vincite: 1
      - long: 0
  - **fascia_oraria_server**
    - **8-15**
      - n: 2
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
    - n_trade: 11
    - n_abbinati: 11
    - media_osservata_R: 0.1303
    - media_nulla: 0.04463
    - p5: -0.2191
    - p50: 0.05314
    - p95: 0.2841
    - percentile_osservato: 0.693
    - p_B: 0.3073
    - pf_nullo_p50: 1.291
    - pf_osservato: 2.126
  - **variante_CONT**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: 0.2155
    - media_nulla: 0.04602
    - p5: -0.2576
    - p50: 0.04839
    - p95: 0.3022
    - percentile_osservato: 0.835
    - p_B: 0.1654
    - pf_nullo_p50: 1.268
    - pf_osservato: 8.12
  - **variante_INV**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.2534
    - media_nulla: 0.03839
    - p5: -0.504
    - p50: 0.2
    - p95: 0.3645
    - percentile_osservato: 0.2515
    - p_B: 0.7486
    - pf_nullo_p50: -
    - pf_osservato: 0.4931
  - **periodo_2015**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.09924
    - media_nulla: 0.03462
    - p5: -0.3392
    - p50: 0.04678
    - p95: 0.3332
    - percentile_osservato: 0.6275
    - p_B: 0.3728
    - pf_nullo_p50: 1.234
    - pf_osservato: 1.496
  - **periodo_2017**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.1001
    - media_nulla: -0.009348
    - p5: -0.5754
    - p50: 0.08237
    - p95: 0.2941
    - percentile_osservato: 0.5175
    - p_B: 0.4828
    - pf_nullo_p50: 2.4
    - pf_osservato: 2.102
  - **periodo_2019**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.116
    - media_nulla: 0.04513
    - p5: -1
    - p50: 0.2802
    - p95: 0.4544
    - percentile_osservato: 0.327
    - p_B: 0.6732
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2022**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.2602
    - media_nulla: 0.1504
    - p5: -0.4564
    - p50: 0.2916
    - p95: 0.5078
    - percentile_osservato: 0.455
    - p_B: 0.5452
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **lato_long**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.001925
    - media_nulla: -0.005974
    - p5: -0.5186
    - p50: 0.1239
    - p95: 0.3152
    - percentile_osservato: 0.3605
    - p_B: 0.6397
    - pf_nullo_p50: -
    - pf_osservato: 1.014
  - **lato_short**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: 0.1588
    - media_nulla: 0.05588
    - p5: -0.2437
    - p50: 0.06328
    - p95: 0.3168
    - percentile_osservato: 0.699
    - p_B: 0.3013
    - pf_nullo_p50: 1.339
    - pf_osservato: 2.429
- **B0**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 11
    - n_abbinati: 11
    - media_osservata_R: 0.1303
    - media_nulla: 0.03327
    - p5: -0.2171
    - p50: 0.04581
    - p95: 0.2399
    - percentile_osservato: 0.7325
    - p_B: 0.2679
    - pf_nullo_p50: 1.298
    - pf_osservato: 2.126
  - **variante_CONT**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: 0.2155
    - media_nulla: 0.03069
    - p5: -0.2429
    - p50: 0.04854
    - p95: 0.2605
    - percentile_osservato: 0.885
    - p_B: 0.1154
    - pf_nullo_p50: 1.351
    - pf_osservato: 8.12
  - **variante_INV**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.2534
    - media_nulla: 0.04486
    - p5: -0.4787
    - p50: 0.1618
    - p95: 0.3624
    - percentile_osservato: 0.228
    - p_B: 0.7721
    - pf_nullo_p50: -
    - pf_osservato: 0.4931
  - **periodo_2015**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.09924
    - media_nulla: 0.008781
    - p5: -0.3443
    - p50: 0.01344
    - p95: 0.2938
    - percentile_osservato: 0.622
    - p_B: 0.3783
    - pf_nullo_p50: 1.071
    - pf_osservato: 1.496
  - **periodo_2017**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.1001
    - media_nulla: 0.01791
    - p5: -0.4041
    - p50: 0.106
    - p95: 0.2955
    - percentile_osservato: 0.4895
    - p_B: 0.5107
    - pf_nullo_p50: 4.211
    - pf_osservato: 2.102
  - **periodo_2019**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.116
    - media_nulla: 0.04932
    - p5: -1
    - p50: 0.2297
    - p95: 0.4433
    - percentile_osservato: 0.356
    - p_B: 0.6442
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2022**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.2602
    - media_nulla: 0.1095
    - p5: -0.5124
    - p50: 0.215
    - p95: 0.4929
    - percentile_osservato: 0.571
    - p_B: 0.4293
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **lato_long**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.001925
    - media_nulla: 0.03546
    - p5: -0.4887
    - p50: 0.1466
    - p95: 0.3229
    - percentile_osservato: 0.2845
    - p_B: 0.7156
    - pf_nullo_p50: -
    - pf_osservato: 1.014
  - **lato_short**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: 0.1588
    - media_nulla: 0.03278
    - p5: -0.2476
    - p50: 0.04483
    - p95: 0.2678
    - percentile_osservato: 0.7725
    - p_B: 0.2279
    - pf_nullo_p50: 1.311
    - pf_osservato: 2.429
- **B2**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 11
    - n_abbinati: 11
    - media_osservata_R: 0.1303
    - media_nulla: 0.02424
    - p5: -0.216
    - p50: 0.03331
    - p95: 0.2332
    - percentile_osservato: 0.771
    - p_B: 0.2294
    - pf_nullo_p50: 1.212
    - pf_osservato: 2.126
  - **variante_CONT**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: 0.2155
    - media_nulla: 0.02527
    - p5: -0.235
    - p50: 0.03716
    - p95: 0.2491
    - percentile_osservato: 0.902
    - p_B: 0.09845
    - pf_nullo_p50: 1.285
    - pf_osservato: 8.12
  - **variante_INV**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: -0.2534
    - media_nulla: 0.01962
    - p5: -0.4913
    - p50: 0.1671
    - p95: 0.3455
    - percentile_osservato: 0.286
    - p_B: 0.7141
    - pf_nullo_p50: -
    - pf_osservato: 0.4931
  - **periodo_2015**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.09924
    - media_nulla: 0.09544
    - p5: -0.26
    - p50: 0.1569
    - p95: 0.2927
    - percentile_osservato: 0.404
    - p_B: 0.5962
    - pf_nullo_p50: 15.6
    - pf_osservato: 1.496
  - **periodo_2017**
    - n_trade: 3
    - n_abbinati: 3
    - media_osservata_R: 0.1001
    - media_nulla: -0.07247
    - p5: -0.599
    - p50: -0.09951
    - p95: 0.2981
    - percentile_osservato: 0.6315
    - p_B: 0.3688
    - pf_nullo_p50: 0.653
    - pf_osservato: 2.102
  - **periodo_2019**
    - n_trade: 1
    - n_abbinati: 1
    - media_osservata_R: 0.116
    - media_nulla: 0.07426
    - p5: -1
    - p50: 0.223
    - p95: 0.4681
    - percentile_osservato: 0.346
    - p_B: 0.6542
    - pf_nullo_p50: -
    - pf_osservato: inf
  - **periodo_2022**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.2602
    - media_nulla: -0.0337
    - p5: -1
    - p50: 0.1306
    - p95: 0.4301
    - percentile_osservato: 0.7015
    - p_B: 0.2989
    - pf_nullo_p50: 7.112
    - pf_osservato: inf
  - **lato_long**
    - n_trade: 2
    - n_abbinati: 2
    - media_osservata_R: 0.001925
    - media_nulla: -0.02695
    - p5: -0.5262
    - p50: 0.0987
    - p95: 0.3273
    - percentile_osservato: 0.3795
    - p_B: 0.6207
    - pf_nullo_p50: 8.871
    - pf_osservato: 1.014
  - **lato_short**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: 0.1588
    - media_nulla: 0.03561
    - p5: -0.2283
    - p50: 0.0511
    - p95: 0.2558
    - percentile_osservato: 0.7815
    - p_B: 0.2189
    - pf_nullo_p50: 1.404
    - pf_osservato: 2.429
- **pool_barre_simulate**
  - **2015**
    - long: 2950
    - short: 2935
  - **2017**
    - long: 2807
    - short: 3079
  - **2019**
    - long: 2965
    - short: 2878
  - **2022**
    - long: 3097
    - short: 2846

## T5 Robustezza della primaria
- **bootstrap_settimane**
  - settimane: 11
  - media: 0.1303
  - ic90_lo: -0.09438
  - ic90_hi: 0.3231
  - n_replicati: 10000
- **senza_i_migliori_3**
  - n: 8
  - media_R: -0.01143
  - pf_netto: 0.9282
- **con_tutti**
  - n: 11
  - media_R: 0.1303
  - pf_netto: 2.126
- **leave_one_period_out**
  - **2015**
    - n: 6
    - media_R: 0.1561
    - pf_netto: 4.439
  - **2017**
    - n: 8
    - media_R: 0.1416
    - pf_netto: 2.133
  - **2019**
    - n: 10
    - media_R: 0.1317
    - pf_netto: 2.035
  - **2022**
    - n: 9
    - media_R: 0.1014
    - pf_netto: 1.717
- **quota_profitto_per_periodo**
  - 2015: 0.3463
  - 2017: 0.2096
  - 2019: 0.08095
  - 2022: 0.3632
- **spread_x1.5**
  - n: 11
  - media_R: 0.129
  - pf_netto: 2.11
- **escluso_spread0**
  - n: 9
  - media_R: 0.1014
  - pf_netto: 1.717

## T6 Sensibilita (riportate per intero, non selezionabili)
| sens | segnali | n | win_pct | pf_netto | attesa_R | netto_R | dd_max_R |
|---|---|---|---|---|---|---|---|
| Sa | 12 | 12 | 75 | 1.999 | 0.1127 | 1.352 | 1 |
| Sb | 9 | 9 | 88.89 | 8.12 | 0.2155 | 1.94 | 0.2724 |
| Sc | 11 | 11 | 81.82 | 2.126 | 0.1303 | 1.433 | 1 |
| Sd | 11 | 11 | 81.82 | 2.11 | 0.129 | 1.419 | 1 |
| Se20 | 10 | 10 | 90 | 9.93 | 0.2433 | 2.433 | 0.2724 |
| Se50 | 11 | 11 | 81.82 | 2.126 | 0.1303 | 1.433 | 1 |
| Sf | 10 | 10 | 80 | 1.835 | 0.1063 | 1.063 | 1 |
| Sg | 13 | 13 | 84.62 | 2.372 | 0.1343 | 1.746 | 1 |

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
  - buy_and_hold_in_ATR: -56.1
  - atr_mediana_prezzo: 0.002129
  - **long**
    - n: 0
    - media_R: -
  - **short**
    - n: 5
    - media_R: 0.09924
- **2017**
  - buy_and_hold_in_ATR: 108
  - atr_mediana_prezzo: 0.001377
  - **long**
    - n: 2
    - media_R: 0.001925
  - **short**
    - n: 1
    - media_R: 0.2965
- **2019**
  - buy_and_hold_in_ATR: -23.8
  - atr_mediana_prezzo: 0.0009593
  - **long**
    - n: 0
    - media_R: -
  - **short**
    - n: 1
    - media_R: 0.116
- **2022**
  - buy_and_hold_in_ATR: -36.62
  - atr_mediana_prezzo: 0.001843
  - **long**
    - n: 0
    - media_R: -
  - **short**
    - n: 2
    - media_R: 0.2602

## T9 Dati / esecuzione
- **spread0_sostituiti_per_periodo**
  - 2015: 70
  - 2017: 50781
  - 2019: 2
  - 2022: 259172
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
  - trade_spread0_ingresso: 2
  - trade_spread0_uscita: 2
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
    - scartati_gap_ingresso: 0
  - segnali_totali: 11
  - tocchi_penetrazione_lt_spread_sui_segnali: 0
  - coppie_CONT_INV_stesso_episodio: 0

## Log dei trade
Schedule completa dei target per ogni trade nel JSON (chiave tabelle.LOG_TRADE).
