# Breaking Band su XAUUSD — risultati (generato da run_test.py)

sha256 dei risultati (JSON canonico): `367e6d67b990c1ba1764ce9911f806aae0e095593d63188d6633965f0c484bd7`

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
  - PUNTO: 0.01
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
  - PLACEBO_PREZZO: 2000
  - PLACEBO_RIMESCOLAMENTI: 200
  - PLACEBO_SOTTOPASSI: 4
  - PLACEBO_SPREAD_PUNTI: 25
  - PLACEBO_TARGET_SEGNALI: 1500
  - PLACEBO_VOL_H: 1.5
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
  - 2013: 3549536a712f023878dad95b61d856d458d6976f9be63e98e7d4f2ef04995c2e
  - 2018: e5ade9bfbaa14ca6d547c6e5cd7fd2e089d5f5b8f66cd7a5053d924852e3151a
  - 2020: f9b04c31f3dbbc2ed63d5aed97535e0b4e533f3a8bda5c8ddbaf67824b939134
  - 2025-26: e64d8af3d1e34a29c0744000995b3df08ce642d388b1b5bba7facd2cb1596d20
- **righe_csv**
  - 2013: 348647
  - 2018: 349730
  - 2020: 351258
  - 2025-26: 611062
- **righe_attese_A3**
  - 2013: 348647
  - 2018: 349730
  - 2020: 351258
  - 2025-26: 611062
- **righe_coincidono_con_A3**
  - 2013: True
  - 2018: True
  - 2020: True
  - 2025-26: True
- **sha256_codice**
  - engine.py: e3167ea27fae2f3bd560a056719f21dcb50e5f436f605f3bc0c694fd0a811a71
  - signals.py: 30e24db798e73bdc6f140faa2f45248be60e61eef1aae3e4173e50dd3c74d50e
  - params.py: 3f3b8a6ace455cc306b262aba40a73a48ea47e3f67e90ac7d23da6e26770d166
  - run_test.py: fa468833db8c312d2158ace6046387fb6d0d67343186a8b9832ff4cc302ac9a6
- **sha256_documenti_congelati**
  - specifica_v1.md: 4da8af64af86d216c592f5ba95166a3d72d072a7be09dc734915d09bdbb60a92
  - disegno_test_v1.md: 4cde9896e944c657d09165169a9f70cca04140830bbf8eaa61b545f555a0b022
  - criteri_previsioni_v1.md: 83750badbf0cbf488ef5f5579517d5cc719a8d4bbeddf7f3007e3d3e6a7730a8
- **hash_dati_coincidono**
  - ABTG_M1_XAUUSD_2013.csv: True
  - ABTG_M1_XAUUSD_2018.csv: True
  - ABTG_M1_XAUUSD_2020.csv: True
  - ABTG_M1_XAUUSD.csv: True
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
- N: 25
- media_R: -0.16
- pf_netto: 0.5072
- p_B1: 0.932
- **ic90**
  - settimane: 25
  - media: -0.16
  - ic90_lo: -0.3559
  - ic90_hi: 0.02866
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
  - XAUUSD fuori dallo scopo dichiarato dalla Guida (MAJOR/MINOR, D1/H4/H1/M30); M15 non ammesso e non testato
  - Guida usata = 'versione didattica' non confermata come Guida Operativa 11 ufficiale; mancano Dichiarazione di Test e screenshot
  - stop 3 ATR, target SMA20, ricalcolo 3 ore da Guida/Protocolli; soglie 'molto/ordinato' sono interpretazioni (specifica sez. 8); pattern testati = soprainsieme dei validi
  - nessun dato EURUSD; i 4 periodi sono 4 regimi; N per cella in T2
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
| armati | 66 | - | BAND_RIDING |
| finestra | 58 | 87.88 | BAND_RIDING |
| C0_tocco_banda_opposta | 27 | 46.55 | T_MAX |
| C3_sequenza | 25 | 92.59 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 9 | 36 | T_MAX |
| C1b_candela_test_non_impulsiva | 8 | 88.89 | - |
| sd<S50 | 8 | 100 | - |
| sd<=sd[-3] | 8 | 100 | - |
| SEGNALE | 8 | 100 | - |
Segnali e trade: {"eseguiti": 8, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 8}

Armati: {"+1": 28, "-1": 38}; fine episodi: {"BAND_RIDING": 42, "OPPOSTO": 3, "T_MAX": 21}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 19, "episodi_seq_violata_su_barra_di_tocco": 2, "segnali_con_impulsiva_1.0_violata": 8, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 55 | - | BAND_RIDING |
| finestra | 47 | 85.45 | BAND_RIDING |
| C0_tocco_banda_opposta | 26 | 55.32 | T_MAX |
| C3_sequenza | 24 | 92.31 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 8 | 33.33 | OPPOSTO |
| C1b_candela_test_non_impulsiva | 6 | 75 | - |
| sd<S50 | 6 | 100 | BAND_RIDING |
| sd<=sd[-3] | 5 | 83.33 | - |
| SEGNALE | 5 | 100 | - |
Segnali e trade: {"eseguiti": 5, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 5}

Armati: {"+1": 23, "-1": 32}; fine episodi: {"BAND_RIDING": 34, "OPPOSTO": 4, "T_MAX": 17}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 14, "episodi_seq_violata_su_barra_di_tocco": 3, "segnali_con_impulsiva_1.0_violata": 5, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 52 | 89.66 | BAND_RIDING |
| C0_tocco_banda_opposta | 15 | 28.85 | T_MAX |
| C3_sequenza | 14 | 93.33 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 7 | 50 | T_MAX |
| C1b_candela_test_non_impulsiva | 6 | 85.71 | T_MAX |
| sd<S50 | 4 | 66.67 | - |
| sd<=sd[-3] | 4 | 100 | - |
| SEGNALE | 4 | 100 | - |
Segnali e trade: {"eseguiti": 4, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 4}

Armati: {"+1": 32, "-1": 26}; fine episodi: {"BAND_RIDING": 38, "OPPOSTO": 2, "T_MAX": 18}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 6, "episodi_seq_violata_su_barra_di_tocco": 2, "segnali_con_impulsiva_1.0_violata": 4, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 88 | - | BAND_RIDING |
| finestra | 74 | 84.09 | BAND_RIDING |
| C0_tocco_banda_opposta | 22 | 29.73 | BAND_RIDING |
| C3_sequenza | 19 | 86.36 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 8 | 42.11 | BAND_RIDING |
| C1b_candela_test_non_impulsiva | 3 | 37.5 | BAND_RIDING |
| sd<S50 | 2 | 66.67 | - |
| sd<=sd[-3] | 2 | 100 | - |
| SEGNALE | 2 | 100 | - |
Segnali e trade: {"eseguiti": 2, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 2}

Armati: {"+1": 48, "-1": 40}; fine episodi: {"BAND_RIDING": 67, "OPPOSTO": 2, "T_MAX": 19}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 11, "episodi_seq_violata_su_barra_di_tocco": 4, "segnali_con_impulsiva_1.0_violata": 2, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 267 | - | BAND_RIDING |
| finestra | 231 | 86.52 | BAND_RIDING |
| C0_tocco_banda_opposta | 90 | 38.96 | T_MAX |
| C3_sequenza | 82 | 91.11 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 32 | 39.02 | T_MAX |
| C1b_candela_test_non_impulsiva | 23 | 71.88 | T_MAX |
| sd<S50 | 20 | 86.96 | BAND_RIDING |
| sd<=sd[-3] | 19 | 95 | - |
| SEGNALE | 19 | 100 | - |
Segnali e trade: {"eseguiti": 19, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 19}

Armati: {"+1": 131, "-1": 136}; fine episodi: {"BAND_RIDING": 181, "OPPOSTO": 11, "T_MAX": 75}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 50, "episodi_seq_violata_su_barra_di_tocco": 11, "segnali_con_impulsiva_1.0_violata": 19, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 66 | - | BAND_RIDING |
| finestra | 58 | 87.88 | BAND_RIDING |
| I0_mediana_toccata | 37 | 63.79 | T_MAX |
| I1_banda_opposta_mai_toccata | 19 | 51.35 | T_MAX |
| retest_banda_impulso | 4 | 21.05 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 25 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 28, "-1": 38}; fine episodi: {"BAND_RIDING": 42, "OPPOSTO": 3, "T_MAX": 21}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 55 | - | BAND_RIDING |
| finestra | 47 | 85.45 | BAND_RIDING |
| I0_mediana_toccata | 36 | 76.6 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 16 | 44.44 | T_MAX |
| retest_banda_impulso | 4 | 25 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 25 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 23, "-1": 32}; fine episodi: {"BAND_RIDING": 34, "OPPOSTO": 4, "T_MAX": 17}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 58 | - | BAND_RIDING |
| finestra | 52 | 89.66 | BAND_RIDING |
| I0_mediana_toccata | 29 | 55.77 | T_MAX |
| I1_banda_opposta_mai_toccata | 8 | 27.59 | T_MAX |
| retest_banda_impulso | 3 | 37.5 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 33.33 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 32, "-1": 26}; fine episodi: {"BAND_RIDING": 38, "OPPOSTO": 2, "T_MAX": 18}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 88 | - | BAND_RIDING |
| finestra | 74 | 84.09 | BAND_RIDING |
| I0_mediana_toccata | 47 | 63.51 | BAND_RIDING |
| I1_banda_opposta_mai_toccata | 22 | 46.81 | T_MAX |
| retest_banda_impulso | 6 | 27.27 | BAND_RIDING |
| I2_nessuna_impulsiva | 3 | 50 | - |
| I3_banda_piatta | 3 | 100 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 48, "-1": 40}; fine episodi: {"BAND_RIDING": 67, "OPPOSTO": 2, "T_MAX": 19}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_H1 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 267 | - | BAND_RIDING |
| finestra | 231 | 86.52 | BAND_RIDING |
| I0_mediana_toccata | 149 | 64.5 | T_MAX |
| I1_banda_opposta_mai_toccata | 65 | 43.62 | T_MAX |
| retest_banda_impulso | 17 | 26.15 | BAND_RIDING |
| I2_nessuna_impulsiva | 6 | 35.29 | - |
| I3_banda_piatta | 6 | 100 | - |
| sd<S50 | 6 | 100 | - |
| sd<=sd[-3] | 6 | 100 | - |
| SEGNALE | 6 | 100 | - |
Segnali e trade: {"eseguiti": 6, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 6}

Armati: {"+1": 131, "-1": 136}; fine episodi: {"BAND_RIDING": 181, "OPPOSTO": 11, "T_MAX": 75}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 6, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 150 | - | BAND_RIDING |
| finestra | 133 | 88.67 | BAND_RIDING |
| C0_tocco_banda_opposta | 59 | 44.36 | T_MAX |
| C3_sequenza | 49 | 83.05 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 26 | 53.06 | T_MAX |
| C1b_candela_test_non_impulsiva | 20 | 76.92 | T_MAX |
| sd<S50 | 19 | 95 | T_MAX |
| sd<=sd[-3] | 17 | 89.47 | - |
| SEGNALE | 17 | 100 | - |
Segnali e trade: {"eseguiti": 17, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 17}

Armati: {"+1": 72, "-1": 78}; fine episodi: {"BAND_RIDING": 76, "FINE_DATI": 1, "OPPOSTO": 9, "T_MAX": 64}; extra: {"episodi_consumati_tocco_precoce": 2, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 35, "episodi_seq_violata_su_barra_di_tocco": 14, "segnali_con_impulsiva_1.0_violata": 15, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 135 | - | BAND_RIDING |
| finestra | 122 | 90.37 | BAND_RIDING |
| C0_tocco_banda_opposta | 60 | 49.18 | T_MAX |
| C3_sequenza | 55 | 91.67 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 23 | 41.82 | T_MAX |
| C1b_candela_test_non_impulsiva | 14 | 60.87 | - |
| sd<S50 | 14 | 100 | T_MAX |
| sd<=sd[-3] | 13 | 92.86 | - |
| SEGNALE | 13 | 100 | - |
Segnali e trade: {"eseguiti": 13, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 13}

Armati: {"+1": 73, "-1": 62}; fine episodi: {"BAND_RIDING": 66, "OPPOSTO": 12, "T_MAX": 57}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 23, "episodi_seq_violata_su_barra_di_tocco": 6, "segnali_con_impulsiva_1.0_violata": 12, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 124 | - | BAND_RIDING |
| finestra | 110 | 88.71 | BAND_RIDING |
| C0_tocco_banda_opposta | 47 | 42.73 | T_MAX |
| C3_sequenza | 46 | 97.87 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 24 | 52.17 | T_MAX |
| C1b_candela_test_non_impulsiva | 19 | 79.17 | - |
| sd<S50 | 19 | 100 | - |
| sd<=sd[-3] | 19 | 100 | - |
| SEGNALE | 19 | 100 | - |
Segnali e trade: {"eseguiti": 19, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 19}

Armati: {"+1": 71, "-1": 53}; fine episodi: {"BAND_RIDING": 75, "OPPOSTO": 9, "T_MAX": 40}; extra: {"episodi_consumati_tocco_precoce": 1, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 20, "episodi_seq_violata_su_barra_di_tocco": 1, "segnali_con_impulsiva_1.0_violata": 17, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 191 | - | BAND_RIDING |
| finestra | 160 | 83.77 | BAND_RIDING |
| C0_tocco_banda_opposta | 67 | 41.88 | T_MAX |
| C3_sequenza | 61 | 91.04 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 19 | 31.15 | T_MAX |
| C1b_candela_test_non_impulsiva | 11 | 57.89 | T_MAX |
| sd<S50 | 10 | 90.91 | T_MAX |
| sd<=sd[-3] | 8 | 80 | - |
| SEGNALE | 8 | 100 | - |
Segnali e trade: {"eseguiti": 8, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 8}

Armati: {"+1": 105, "-1": 86}; fine episodi: {"BAND_RIDING": 115, "FINE_DATI": 1, "OPPOSTO": 10, "T_MAX": 65}; extra: {"episodi_consumati_tocco_precoce": 2, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 21, "episodi_seq_violata_su_barra_di_tocco": 9, "segnali_con_impulsiva_1.0_violata": 8, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### CONT_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 600 | - | BAND_RIDING |
| finestra | 525 | 87.5 | BAND_RIDING |
| C0_tocco_banda_opposta | 233 | 44.38 | T_MAX |
| C3_sequenza | 211 | 90.56 | T_MAX |
| C1a_ritracciamento_non_impulsivo | 92 | 43.6 | T_MAX |
| C1b_candela_test_non_impulsiva | 64 | 69.57 | T_MAX |
| sd<S50 | 62 | 96.88 | T_MAX |
| sd<=sd[-3] | 57 | 91.94 | - |
| SEGNALE | 57 | 100 | - |
Segnali e trade: {"eseguiti": 57, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 57}

Armati: {"+1": 321, "-1": 279}; fine episodi: {"BAND_RIDING": 332, "FINE_DATI": 2, "OPPOSTO": 40, "T_MAX": 226}; extra: {"episodi_consumati_tocco_precoce": 5, "episodi_eliminati_solo_da_SEQ": 1, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 99, "episodi_seq_violata_su_barra_di_tocco": 30, "segnali_con_impulsiva_1.0_violata": 52, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2013
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 150 | - | BAND_RIDING |
| finestra | 133 | 88.67 | BAND_RIDING |
| I0_mediana_toccata | 98 | 73.68 | T_MAX |
| I1_banda_opposta_mai_toccata | 23 | 23.47 | T_MAX |
| retest_banda_impulso | 8 | 34.78 | T_MAX |
| I2_nessuna_impulsiva | 1 | 12.5 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 72, "-1": 78}; fine episodi: {"BAND_RIDING": 76, "FINE_DATI": 1, "OPPOSTO": 9, "T_MAX": 64}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2018
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 135 | - | BAND_RIDING |
| finestra | 122 | 90.37 | BAND_RIDING |
| I0_mediana_toccata | 89 | 72.95 | T_MAX |
| I1_banda_opposta_mai_toccata | 26 | 29.21 | T_MAX |
| retest_banda_impulso | 7 | 26.92 | T_MAX |
| I2_nessuna_impulsiva | 3 | 42.86 | - |
| I3_banda_piatta | 3 | 100 | - |
| sd<S50 | 3 | 100 | - |
| sd<=sd[-3] | 3 | 100 | - |
| SEGNALE | 3 | 100 | - |
Segnali e trade: {"eseguiti": 3, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 3}

Armati: {"+1": 73, "-1": 62}; fine episodi: {"BAND_RIDING": 66, "OPPOSTO": 12, "T_MAX": 57}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 3, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2020
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 124 | - | BAND_RIDING |
| finestra | 110 | 88.71 | BAND_RIDING |
| I0_mediana_toccata | 82 | 74.55 | T_MAX |
| I1_banda_opposta_mai_toccata | 22 | 26.83 | T_MAX |
| retest_banda_impulso | 4 | 18.18 | BAND_RIDING |
| I2_nessuna_impulsiva | 1 | 25 | - |
| I3_banda_piatta | 1 | 100 | - |
| sd<S50 | 1 | 100 | - |
| sd<=sd[-3] | 1 | 100 | - |
| SEGNALE | 1 | 100 | - |
Segnali e trade: {"eseguiti": 1, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 1}

Armati: {"+1": 71, "-1": 53}; fine episodi: {"BAND_RIDING": 75, "OPPOSTO": 9, "T_MAX": 40}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 1, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — 2025-26
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 191 | - | BAND_RIDING |
| finestra | 160 | 83.77 | BAND_RIDING |
| I0_mediana_toccata | 116 | 72.5 | T_MAX |
| I1_banda_opposta_mai_toccata | 49 | 42.24 | T_MAX |
| retest_banda_impulso | 14 | 28.57 | T_MAX |
| I2_nessuna_impulsiva | 5 | 35.71 | - |
| I3_banda_piatta | 5 | 100 | - |
| sd<S50 | 5 | 100 | - |
| sd<=sd[-3] | 5 | 100 | - |
| SEGNALE | 5 | 100 | - |
Segnali e trade: {"eseguiti": 5, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 5}

Armati: {"+1": 105, "-1": 86}; fine episodi: {"BAND_RIDING": 115, "FINE_DATI": 1, "OPPOSTO": 10, "T_MAX": 65}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 5, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

### INV_M30 — TOTALE
| stadio | n | pct_cond_stadio_prec | causa_principale |
|---|---|---|---|
| armati | 600 | - | BAND_RIDING |
| finestra | 525 | 87.5 | BAND_RIDING |
| I0_mediana_toccata | 385 | 73.33 | T_MAX |
| I1_banda_opposta_mai_toccata | 120 | 31.17 | T_MAX |
| retest_banda_impulso | 33 | 27.5 | T_MAX |
| I2_nessuna_impulsiva | 10 | 30.3 | - |
| I3_banda_piatta | 10 | 100 | - |
| sd<S50 | 10 | 100 | - |
| sd<=sd[-3] | 10 | 100 | - |
| SEGNALE | 10 | 100 | - |
Segnali e trade: {"eseguiti": 10, "riconciliato": true, "scartati_gap_ingresso": 0, "scartati_indicatori_non_pronti": 0, "scartati_no_barra_successiva": 0, "scartati_posizione_aperta": 0, "scartati_target_oltre_ingresso": 0, "segnali": 10}

Armati: {"+1": 321, "-1": 279}; fine episodi: {"BAND_RIDING": 332, "FINE_DATI": 2, "OPPOSTO": 40, "T_MAX": 226}; extra: {"episodi_consumati_tocco_precoce": 0, "episodi_eliminati_solo_da_SEQ": 0, "episodi_ritorno_banda_senza_mediana_su_barra_di_tocco": 0, "episodi_seq_violata_su_barra_di_tocco": 0, "segnali_con_impulsiva_1.0_violata": 10, "segnali_penetrazione_lt_spread": 0, "tocchi_banda_opposta_prima_armamento": 0}

## T2 Risultati per variante x TF x periodo
| cella | n | win_pct | pf_lordo | pf_netto | attesa_R | mediana_R | netto_R | dd_max_R | costo_spread_medio_R | D_medio_atr | pareggio_atteso_medio_pct | wr0_pct | durata_mediana_barre | durata_max_barre | quota_long |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CONT_H1_2013 | 8 | 25 | 0.07306 | 0.0526 | -0.6058 | -1 | -4.846 | 5.038 | 0.03761 | 0.9702 | 79.13 | 76.61 | 6 | 16 | 0.625 |
| CONT_H1_2018 | 5 | 60 | 0.4636 | 0.4048 | -0.2381 | 0.0781 | -1.19 | 2 | 0.03251 | 1.139 | 76.15 | 73.57 | 4 | 8 | 0.2 |
| CONT_H1_2020 | 4 | 100 | inf | inf | 0.3588 | 0.4104 | 1.435 | 0 | 0.00697 | 1.184 | 73.08 | 72.38 | 3.5 | 5 | 0.5 |
| CONT_H1_2025-26 | 2 | 100 | inf | inf | 0.2349 | 0.2349 | 0.4698 | 0 | 0.006061 | 0.871 | 79.91 | 79.47 | 2.5 | 4 | 0 |
| CONT_H1_TOTALE | 19 | 57.89 | 0.468 | 0.4193 | -0.2175 | 0.0781 | -4.132 | 6.306 | 0.02649 | 1.049 | 77.15 | 75.22 | 4 | 16 | 0.4211 |
| INV_H1_2013 | 1 | 100 | inf | inf | 0.1087 | 0.1087 | 0.1087 | 0 | 0.02457 | 0.326 | 92.41 | 90.2 | 2 | 2 | 1 |
| INV_H1_2018 | 1 | 100 | inf | inf | 0.4013 | 0.4013 | 0.4013 | 0 | 0.02683 | 1.204 | 73.57 | 71.36 | 3 | 3 | 0 |
| INV_H1_2020 | 1 | 0 | 0 | 0 | -1 | -1 | -1 | 1 | 0.01025 | 0.8844 | 77.91 | 77.23 | 3 | 3 | 0 |
| INV_H1_2025-26 | 3 | 100 | inf | inf | 0.2074 | 0.2227 | 0.6222 | 0 | 0.003018 | 0.633 | 83.31 | 83.07 | 3 | 4 | 0.6667 |
| INV_H1_TOTALE | 6 | 83.33 | 1.205 | 1.132 | 0.02203 | 0.1657 | 0.1322 | 1 | 0.01178 | 0.7189 | 82.3 | 81.33 | 3 | 4 | 0.5 |
| POOLED_H1 | 25 | 64 | 0.5614 | 0.5072 | -0.16 | 0.089 | -4 | 6.197 | 0.02296 | 0.9699 | 78.39 | 76.69 | 4 | 16 | 0.44 |
| CONT_M30_2013 | 17 | 76.47 | 0.9201 | 0.7115 | -0.06788 | 0.2069 | -1.154 | 2.33 | 0.04988 | 0.9398 | 80.95 | 77.25 | 7 | 21 | 0.5294 |
| CONT_M30_2018 | 13 | 53.85 | 0.5294 | 0.4021 | -0.1863 | 0.06087 | -2.422 | 3.613 | 0.04781 | 1.088 | 78.13 | 74.46 | 7 | 14 | 0.6154 |
| CONT_M30_2020 | 19 | 73.68 | 0.8436 | 0.7923 | -0.05465 | 0.2127 | -1.038 | 1.873 | 0.01406 | 1.07 | 75.47 | 74.24 | 8 | 20 | 0.4211 |
| CONT_M30_2025-26 | 8 | 87.5 | 2.091 | 1.997 | 0.1246 | 0.2593 | 0.9965 | 1 | 0.009947 | 1.004 | 76.38 | 75.69 | 3 | 13 | 0.75 |
| CONT_M30_TOTALE | 57 | 71.93 | 0.8673 | 0.7425 | -0.06347 | 0.196 | -3.618 | 5.578 | 0.03187 | 1.026 | 77.84 | 75.39 | 7 | 21 | 0.5439 |
| INV_M30_2013 | 1 | 100 | inf | inf | 0.411 | 0.411 | 0.411 | 0 | 0.04522 | 1.233 | 75.53 | 70.87 | 5 | 5 | 0 |
| INV_M30_2018 | 3 | 33.33 | 0.05268 | 0.02242 | -0.6517 | -1 | -1.955 | 2 | 0.0478 | 0.5403 | 89.5 | 85.36 | 4 | 8 | 0.6667 |
| INV_M30_2020 | 1 | 0 | 0 | 0 | -1 | -1 | -1 | 1 | 0.01526 | 0.9053 | 78.06 | 76.82 | 8 | 8 | 0 |
| INV_M30_2025-26 | 5 | 80 | 1.178 | 1.136 | 0.02717 | 0.1765 | 0.1359 | 1 | 0.008128 | 0.9095 | 78.42 | 77.84 | 1 | 6 | 0.4 |
| INV_M30_TOTALE | 10 | 60 | 0.4438 | 0.3979 | -0.2408 | 0.06396 | -2.408 | 2.955 | 0.02445 | 0.8307 | 81.42 | 79.3 | 3 | 8 | 0.4 |
| POOLED_M30 | 67 | 70.15 | 0.7729 | 0.6662 | -0.08994 | 0.1765 | -6.026 | 8.123 | 0.03076 | 0.9968 | 78.37 | 75.98 | 7 | 21 | 0.5224 |

Uscite per motivo e altri conteggi:
- CONT_H1_2013: motivi {"SL": 5, "TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2018: motivi {"SL": 2, "TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_2020: motivi {"MKT": 1, "TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_H1_2025-26: motivi {"TP": 2}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_H1_TOTALE: motivi {"MKT": 1, "SL": 7, "TP": 11}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- INV_H1_2013: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2018: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2020: motivi {"SL": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_2025-26: motivi {"TP": 3}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_H1_TOTALE: motivi {"SL": 1, "TP": 5}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- POOLED_H1: motivi {"MKT": 1, "SL": 8, "TP": 16}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_M30_2013: motivi {"SL": 4, "TP": 13}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2018: motivi {"SL": 4, "TP": 9}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_2020: motivi {"MKT": 1, "SL": 5, "TP": 13}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- CONT_M30_2025-26: motivi {"SL": 1, "TP": 7}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- CONT_M30_TOTALE: motivi {"MKT": 1, "SL": 14, "TP": 42}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1
- INV_M30_2013: motivi {"TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2018: motivi {"SL": 2, "TP": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2020: motivi {"SL": 1}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_2025-26: motivi {"SL": 1, "TP": 4}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- INV_M30_TOTALE: motivi {"SL": 4, "TP": 6}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 0
- POOLED_M30: motivi {"MKT": 1, "SL": 18, "TP": 48}; SL+TP stesso minuto 0; spread0 0; fine_dati/mkt 1

## T3 Fasce (stratificazione, descrittori)
- **pooled**
  - **fascia**
    - **Buono**
      - n: 7
      - vincite: 4
      - long: 3
    - **Medio**
      - n: 12
      - vincite: 7
      - long: 7
      - wr_pct: 58.33
      - media_R: -0.2008
      - wr0_pct: 76.12
      - nota: N<30: solo descrittivo
    - **Ottimo**
      - n: 6
      - vincite: 5
      - long: 1
  - **fascia_accorpata**
    - **<70**
      - n: 12
      - vincite: 7
      - long: 7
      - wr_pct: 58.33
      - media_R: -0.2008
      - wr0_pct: 76.12
      - nota: N<30: solo descrittivo
    - **>=70**
      - n: 13
      - vincite: 9
      - long: 4
      - wr_pct: 69.23
      - media_R: -0.1223
      - wr0_pct: 77.21
      - nota: N<30: solo descrittivo
  - **n_prev**
    - **0**
      - n: 19
      - vincite: 13
      - long: 10
      - wr_pct: 68.42
      - media_R: -0.1125
      - wr0_pct: 77.64
      - nota: N<30: solo descrittivo
    - **1**
      - n: 3
      - vincite: 1
      - long: 1
    - **>=2**
      - n: 3
      - vincite: 2
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 19
      - vincite: 11
      - long: 10
      - wr_pct: 57.89
      - media_R: -0.2281
      - wr0_pct: 76.81
      - nota: N<30: solo descrittivo
    - **si**
      - n: 6
      - vincite: 5
      - long: 1
  - **checklist_stretta**
    - **no**
      - n: 21
      - vincite: 13
      - long: 10
      - wr_pct: 61.9
      - media_R: -0.1894
      - wr0_pct: 77.14
      - nota: N<30: solo descrittivo
    - **si**
      - n: 4
      - vincite: 3
      - long: 1
  - **lato**
    - **long**
      - n: 11
      - vincite: 8
      - long: 11
      - wr_pct: 72.73
      - media_R: -0.07057
      - wr0_pct: 80.83
      - nota: N<30: solo descrittivo
    - **short**
      - n: 14
      - vincite: 8
      - long: 0
      - wr_pct: 57.14
      - media_R: -0.2302
      - wr0_pct: 73.43
      - nota: N<30: solo descrittivo
  - **periodo**
    - **2013**
      - n: 9
      - vincite: 3
      - long: 6
    - **2018**
      - n: 6
      - vincite: 4
      - long: 1
    - **2020**
      - n: 5
      - vincite: 4
      - long: 2
    - **2025-26**
      - n: 5
      - vincite: 5
      - long: 2
  - **fascia_oraria_server**
    - **0-7**
      - n: 3
      - vincite: 2
      - long: 0
    - **16-23**
      - n: 2
      - vincite: 2
      - long: 2
    - **8-15**
      - n: 20
      - vincite: 12
      - long: 9
      - wr_pct: 60
      - media_R: -0.1828
      - wr0_pct: 75.75
      - nota: N<30: solo descrittivo
- **CONT**
  - **fascia**
    - **Buono**
      - n: 6
      - vincite: 4
      - long: 3
    - **Medio**
      - n: 7
      - vincite: 2
      - long: 4
    - **Ottimo**
      - n: 6
      - vincite: 5
      - long: 1
  - **fascia_accorpata**
    - **<70**
      - n: 7
      - vincite: 2
      - long: 4
    - **>=70**
      - n: 12
      - vincite: 9
      - long: 4
      - wr_pct: 75
      - media_R: -0.0492
      - wr0_pct: 77.21
      - nota: N<30: solo descrittivo
  - **n_prev**
    - **0**
      - n: 15
      - vincite: 10
      - long: 7
      - wr_pct: 66.67
      - media_R: -0.1039
      - wr0_pct: 75.66
      - nota: N<30: solo descrittivo
    - **1**
      - n: 2
      - vincite: 0
      - long: 1
    - **>=2**
      - n: 2
      - vincite: 1
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 13
      - vincite: 6
      - long: 7
      - wr_pct: 46.15
      - media_R: -0.3435
      - wr0_pct: 74.72
      - nota: N<30: solo descrittivo
    - **si**
      - n: 6
      - vincite: 5
      - long: 1
  - **checklist_stretta**
    - **no**
      - n: 15
      - vincite: 8
      - long: 7
      - wr_pct: 53.33
      - media_R: -0.2739
      - wr0_pct: 75.47
      - nota: N<30: solo descrittivo
    - **si**
      - n: 4
      - vincite: 3
      - long: 1
  - **lato**
    - **long**
      - n: 8
      - vincite: 5
      - long: 8
    - **short**
      - n: 11
      - vincite: 6
      - long: 0
      - wr_pct: 54.55
      - media_R: -0.2668
      - wr0_pct: 73.01
      - nota: N<30: solo descrittivo
  - **periodo**
    - **2013**
      - n: 8
      - vincite: 2
      - long: 5
    - **2018**
      - n: 5
      - vincite: 3
      - long: 1
    - **2020**
      - n: 4
      - vincite: 4
      - long: 2
    - **2025-26**
      - n: 2
      - vincite: 2
      - long: 0
  - **fascia_oraria_server**
    - **0-7**
      - n: 3
      - vincite: 2
      - long: 0
    - **16-23**
      - n: 1
      - vincite: 1
      - long: 1
    - **8-15**
      - n: 15
      - vincite: 8
      - long: 7
      - wr_pct: 53.33
      - media_R: -0.2377
      - wr0_pct: 73.88
      - nota: N<30: solo descrittivo
- **INV**
  - **fascia**
    - **Buono**
      - n: 1
      - vincite: 0
      - long: 0
    - **Medio**
      - n: 5
      - vincite: 5
      - long: 3
  - **fascia_accorpata**
    - **<70**
      - n: 5
      - vincite: 5
      - long: 3
    - **>=70**
      - n: 1
      - vincite: 0
      - long: 0
  - **n_prev**
    - **0**
      - n: 4
      - vincite: 3
      - long: 3
    - **1**
      - n: 1
      - vincite: 1
      - long: 0
    - **>=2**
      - n: 1
      - vincite: 1
      - long: 0
  - **congestione_valida**
    - **no**
      - n: 6
      - vincite: 5
      - long: 3
  - **checklist_stretta**
    - **no**
      - n: 6
      - vincite: 5
      - long: 3
  - **lato**
    - **long**
      - n: 3
      - vincite: 3
      - long: 3
    - **short**
      - n: 3
      - vincite: 2
      - long: 0
  - **periodo**
    - **2013**
      - n: 1
      - vincite: 1
      - long: 1
    - **2018**
      - n: 1
      - vincite: 1
      - long: 0
    - **2020**
      - n: 1
      - vincite: 0
      - long: 0
    - **2025-26**
      - n: 3
      - vincite: 3
      - long: 2
  - **fascia_oraria_server**
    - **16-23**
      - n: 1
      - vincite: 1
      - long: 1
    - **8-15**
      - n: 5
      - vincite: 4
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
    - n_trade: 25
    - n_abbinati: 25
    - media_osservata_R: -0.16
    - media_nulla: -0.00929
    - p5: -0.1779
    - p50: -0.001311
    - p95: 0.1463
    - percentile_osservato: 0.068
    - p_B: 0.932
    - pf_nullo_p50: 0.9926
    - pf_osservato: 0.5072
  - **variante_CONT**
    - n_trade: 19
    - n_abbinati: 19
    - media_osservata_R: -0.2175
    - media_nulla: 0.0008809
    - p5: -0.202
    - p50: 0.005074
    - p95: 0.1799
    - percentile_osservato: 0.0395
    - p_B: 0.9605
    - pf_nullo_p50: 1.029
    - pf_osservato: 0.4193
  - **variante_INV**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: 0.02203
    - media_nulla: -0.0415
    - p5: -0.3972
    - p50: -0.02614
    - p95: 0.2057
    - percentile_osservato: 0.6475
    - p_B: 0.3528
    - pf_nullo_p50: 0.846
    - pf_osservato: 1.132
  - **periodo_2013**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: -0.5264
    - media_nulla: -0.09064
    - p5: -0.3951
    - p50: -0.07495
    - p95: 0.1975
    - percentile_osservato: 0.0105
    - p_B: 0.9895
    - pf_nullo_p50: 0.6708
    - pf_osservato: 0.07384
  - **periodo_2018**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: -0.1315
    - media_nulla: 0.06578
    - p5: -0.2709
    - p50: 0.06884
    - p95: 0.3214
    - percentile_osservato: 0.188
    - p_B: 0.8121
    - pf_nullo_p50: 1.41
    - pf_osservato: 0.6054
  - **periodo_2020**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.08704
    - media_nulla: 0.05515
    - p5: -0.3068
    - p50: 0.05594
    - p95: 0.3255
    - percentile_osservato: 0.552
    - p_B: 0.4483
    - pf_nullo_p50: 1.283
    - pf_osservato: 1.435
  - **periodo_2025-26**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.2184
    - media_nulla: -0.01739
    - p5: -0.3525
    - p50: -0.02393
    - p95: 0.23
    - percentile_osservato: 0.9185
    - p_B: 0.08196
    - pf_nullo_p50: 0.8735
    - pf_osservato: inf
  - **lato_long**
    - n_trade: 11
    - n_abbinati: 11
    - media_osservata_R: -0.07057
    - media_nulla: -0.05656
    - p5: -0.3005
    - p50: -0.04757
    - p95: 0.1745
    - percentile_osservato: 0.42
    - p_B: 0.5802
    - pf_nullo_p50: 0.747
    - pf_osservato: 0.633
  - **lato_short**
    - n_trade: 14
    - n_abbinati: 14
    - media_osservata_R: -0.2302
    - media_nulla: 0.02785
    - p5: -0.2094
    - p50: 0.03813
    - p95: 0.2348
    - percentile_osservato: 0.0365
    - p_B: 0.9635
    - pf_nullo_p50: 1.234
    - pf_osservato: 0.4628
- **B0**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 25
    - n_abbinati: 25
    - media_osservata_R: -0.16
    - media_nulla: -0.01202
    - p5: -0.1714
    - p50: -0.006604
    - p95: 0.1299
    - percentile_osservato: 0.06
    - p_B: 0.94
    - pf_nullo_p50: 0.9596
    - pf_osservato: 0.5072
  - **variante_CONT**
    - n_trade: 19
    - n_abbinati: 19
    - media_osservata_R: -0.2175
    - media_nulla: -0.009774
    - p5: -0.191
    - p50: -0.005377
    - p95: 0.1527
    - percentile_osservato: 0.034
    - p_B: 0.966
    - pf_nullo_p50: 0.9713
    - pf_osservato: 0.4193
  - **variante_INV**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: 0.02203
    - media_nulla: -0.01915
    - p5: -0.3176
    - p50: -0.01298
    - p95: 0.2083
    - percentile_osservato: 0.597
    - p_B: 0.4033
    - pf_nullo_p50: 0.9214
    - pf_osservato: 1.132
  - **periodo_2013**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: -0.5264
    - media_nulla: -0.06523
    - p5: -0.3701
    - p50: -0.05897
    - p95: 0.1894
    - percentile_osservato: 0.0065
    - p_B: 0.9935
    - pf_nullo_p50: 0.7149
    - pf_osservato: 0.07384
  - **periodo_2018**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: -0.1315
    - media_nulla: 0.07676
    - p5: -0.2471
    - p50: 0.09409
    - p95: 0.3059
    - percentile_osservato: 0.1375
    - p_B: 0.8626
    - pf_nullo_p50: 1.665
    - pf_osservato: 0.6054
  - **periodo_2020**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.08704
    - media_nulla: -0.01081
    - p5: -0.364
    - p50: -0.001009
    - p95: 0.2811
    - percentile_osservato: 0.6445
    - p_B: 0.3558
    - pf_nullo_p50: 0.9952
    - pf_osservato: 1.435
  - **periodo_2025-26**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.2184
    - media_nulla: -0.024
    - p5: -0.3526
    - p50: -0.03107
    - p95: 0.2219
    - percentile_osservato: 0.94
    - p_B: 0.06047
    - pf_nullo_p50: 0.8384
    - pf_osservato: inf
  - **lato_long**
    - n_trade: 11
    - n_abbinati: 11
    - media_osservata_R: -0.07057
    - media_nulla: -0.05641
    - p5: -0.2916
    - p50: -0.05396
    - p95: 0.164
    - percentile_osservato: 0.4355
    - p_B: 0.5647
    - pf_nullo_p50: 0.7126
    - pf_osservato: 0.633
  - **lato_short**
    - n_trade: 14
    - n_abbinati: 14
    - media_osservata_R: -0.2302
    - media_nulla: 0.02285
    - p5: -0.1982
    - p50: 0.03361
    - p95: 0.2046
    - percentile_osservato: 0.0335
    - p_B: 0.9665
    - pf_nullo_p50: 1.212
    - pf_osservato: 0.4628
- **B2**
  - mancanti_senza_abbinamento: 0
  - **pooled**
    - n_trade: 25
    - n_abbinati: 25
    - media_osservata_R: -0.16
    - media_nulla: -0.009136
    - p5: -0.1541
    - p50: -0.004161
    - p95: 0.1224
    - percentile_osservato: 0.0445
    - p_B: 0.9555
    - pf_nullo_p50: 0.9709
    - pf_osservato: 0.5072
  - **variante_CONT**
    - n_trade: 19
    - n_abbinati: 19
    - media_osservata_R: -0.2175
    - media_nulla: -0.002359
    - p5: -0.169
    - p50: 0.00266
    - p95: 0.142
    - percentile_osservato: 0.0235
    - p_B: 0.9765
    - pf_nullo_p50: 1.017
    - pf_osservato: 0.4193
  - **variante_INV**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: 0.02203
    - media_nulla: -0.03059
    - p5: -0.3661
    - p50: -0.02208
    - p95: 0.2038
    - percentile_osservato: 0.6185
    - p_B: 0.3818
    - pf_nullo_p50: 0.8701
    - pf_osservato: 1.132
  - **periodo_2013**
    - n_trade: 9
    - n_abbinati: 9
    - media_osservata_R: -0.5264
    - media_nulla: -0.04753
    - p5: -0.2884
    - p50: -0.03836
    - p95: 0.1728
    - percentile_osservato: 0
    - p_B: 1
    - pf_nullo_p50: 0.7699
    - pf_osservato: 0.07384
  - **periodo_2018**
    - n_trade: 6
    - n_abbinati: 6
    - media_osservata_R: -0.1315
    - media_nulla: 0.01241
    - p5: -0.3078
    - p50: 0.0301
    - p95: 0.2714
    - percentile_osservato: 0.2155
    - p_B: 0.7846
    - pf_nullo_p50: 1.205
    - pf_osservato: 0.6054
  - **periodo_2020**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.08704
    - media_nulla: 0.1008
    - p5: -0.182
    - p50: 0.1437
    - p95: 0.2928
    - percentile_osservato: 0.3805
    - p_B: 0.6197
    - pf_nullo_p50: 6.542
    - pf_osservato: 1.435
  - **periodo_2025-26**
    - n_trade: 5
    - n_abbinati: 5
    - media_osservata_R: 0.2184
    - media_nulla: -0.07577
    - p5: -0.4262
    - p50: -0.07183
    - p95: 0.2135
    - percentile_osservato: 0.9625
    - p_B: 0.03798
    - pf_nullo_p50: 0.6453
    - pf_osservato: inf
  - **lato_long**
    - n_trade: 11
    - n_abbinati: 11
    - media_osservata_R: -0.07057
    - media_nulla: -0.04273
    - p5: -0.2402
    - p50: -0.0366
    - p95: 0.1453
    - percentile_osservato: 0.3965
    - p_B: 0.6037
    - pf_nullo_p50: 0.7714
    - pf_osservato: 0.633
  - **lato_short**
    - n_trade: 14
    - n_abbinati: 14
    - media_osservata_R: -0.2302
    - media_nulla: 0.01726
    - p5: -0.1895
    - p50: 0.02282
    - p95: 0.1988
    - percentile_osservato: 0.026
    - p_B: 0.974
    - pf_nullo_p50: 1.148
    - pf_osservato: 0.4628
- **pool_barre_simulate**
  - **2013**
    - long: 2776
    - short: 2672
  - **2018**
    - long: 2738
    - short: 2737
  - **2020**
    - long: 2411
    - short: 3169
  - **2025-26**
    - long: 4432
    - short: 5505

## T5 Robustezza della primaria
- **bootstrap_settimane**
  - settimane: 25
  - media: -0.16
  - ic90_lo: -0.3559
  - ic90_hi: 0.02866
  - n_replicati: 10000
- **senza_i_migliori_3**
  - n: 22
  - media_R: -0.2421
  - pf_netto: 0.3438
- **con_tutti**
  - n: 25
  - media_R: -0.16
  - pf_netto: 0.5072
- **leave_one_period_out**
  - **2013**
    - n: 16
    - media_R: 0.04612
    - pf_netto: 1.246
  - **2018**
    - n: 19
    - media_R: -0.169
    - pf_netto: 0.475
  - **2020**
    - n: 20
    - media_R: -0.2217
    - pf_netto: 0.3767
  - **2025-26**
    - n: 20
    - media_R: -0.2546
    - pf_netto: 0.3726
- **quota_profitto_per_periodo**
  - 2013: -
  - 2018: -
  - 2020: -
  - 2025-26: -
- **spread_x1.5**
  - n: 25
  - media_R: -0.1633
  - pf_netto: 0.4976
- **escluso_spread0**
  - n: 25
  - media_R: -0.16
  - pf_netto: 0.5072

## T6 Sensibilita (riportate per intero, non selezionabili)
| sens | segnali | n | win_pct | pf_netto | attesa_R | netto_R | dd_max_R |
|---|---|---|---|---|---|---|---|
| Sa | 27 | 27 | 62.96 | 0.5274 | -0.1426 | -3.851 | 6.197 |
| Sb | 19 | 19 | 57.89 | 0.4193 | -0.2175 | -4.132 | 6.306 |
| Sc | 25 | 25 | 64 | 0.5072 | -0.16 | -4 | 6.197 |
| Sd | 25 | 25 | 64 | 0.4976 | -0.1633 | -4.084 | 6.273 |
| Se20 | 23 | 23 | 60.87 | 0.4663 | -0.1883 | -4.331 | 6.306 |
| Se50 | 25 | 25 | 64 | 0.5072 | -0.16 | -4 | 6.197 |
| Sf | 23 | 23 | 65.22 | 0.5827 | -0.1291 | -2.97 | 4.856 |
| Sg | 31 | 30 | 63.33 | 0.4695 | -0.1789 | -5.366 | 5.986 |

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
  - buy_and_hold_in_ATR: -111.6
  - atr_mediana_usd: 4.16
  - **long**
    - n: 6
    - media_R: -0.2896
  - **short**
    - n: 3
    - media_R: -1
- **2018**
  - buy_and_hold_in_ATR: -12.96
  - atr_mediana_usd: 2.242
  - **long**
    - n: 1
    - media_R: 0.0781
  - **short**
    - n: 5
    - media_R: -0.1735
- **2020**
  - buy_and_hold_in_ATR: 69.54
  - atr_mediana_usd: 5.382
  - **long**
    - n: 2
    - media_R: 0.2857
  - **short**
    - n: 3
    - media_R: -0.04544
- **2025-26**
  - buy_and_hold_in_ATR: 101.2
  - atr_mediana_usd: 15.13
  - **long**
    - n: 2
    - media_R: 0.1558
  - **short**
    - n: 3
    - media_R: 0.2601

## T9 Dati / esecuzione
- **spread0_sostituiti_per_periodo**
  - 2013: 439
  - 2018: 94
  - 2020: 144
  - 2025-26: 0
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
  - uscite_a_mercato_target_superato: 1
  - ricalcoli_target_totali: 25
  - eventi_sl_tp_stesso_minuto: 0
  - **segnali_scartati**
    - scartati_posizione_aperta: 0
    - scartati_target_oltre_ingresso: 0
    - scartati_indicatori_non_pronti: 0
    - scartati_no_barra_successiva: 0
    - scartati_gap_ingresso: 0
  - segnali_totali: 25
  - tocchi_penetrazione_lt_spread_sui_segnali: 0
  - coppie_CONT_INV_stesso_episodio: 0

## Log dei trade
Schedule completa dei target per ogni trade nel JSON (chiave tabelle.LOG_TRADE).
