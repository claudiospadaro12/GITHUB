"""UNICA fonte dei valori numerici del test Breaking Band (A4, fase 3).

PARAMS replica la tabella di specifica_v1.md sezione 9 (congelata). Nessun altro file
(engine.py, signals.py, run_test.py) contiene soglie numeriche: le leggono da qui.
Le costanti 0, 1, -1 e gli indici di confronto strutturali (es. "barra precedente") restano nel
codice perche' sono parte della definizione, non soglie.

DESCRITTORI_A2: soglie di A2 (agents/A2/specifica.md sez. 1) usate SOLO per i descrittori
(congestione, solidita, bonus, invalidazioni A2). Non entrano mai in un filtro di ingresso.
DISEGNO: valori di disegno_test_v1.md / criteri_previsioni_v1.md (linee di base, bootstrap, verdetto).
SENSIBILITA: overrides di PARAMS, una alla volta (specifica sez. 9, riga SENSIBILITA).
"""
from __future__ import annotations

PARAMS = {
    # --- indicatori
    "BB_N": 20, "BB_K": 2.0, "SD_DDOF": 0, "S50_N": 50, "ATR_N": 14, "ATR_METODO": "wilder", "WARMUP": 200,
    # --- timeframe
    "TF_PRIMARIO": 60, "TF_ESPLORATIVO": 30, "RICALCOLO_ORE": 3,
    # --- bulge (B1..B6)
    "WIN_IMPULSO": 20, "REF_BARRE": 15, "B1_W": 2.0, "B3_ATR": 1.5, "B4_ER": 0.50, "B5_ATR": 2.0, "B6_BARRE": 20,
    # --- test del pattern
    "MIN_RETR": 3, "T_MAX": 30, "IMPULSIVA_ATR": 1.5, "SD_GATE_S50": True, "SD_LAG": 3,
    "BANDA_TOL_ATR": 0.10, "BANDA_FINESTRA": 3,
    # --- esecuzione
    "STOP_ATR": 3.0, "MAXHOLD": 1000, "MAX_GAP_INGRESSO_MIN": 180, "FILL_TARGET_MIGLIORE": False,
    "SPREAD_MOLT": 1.0, "TOCCO_PEN_SPREAD": 0.0, "PUNTO": 0.01,
    "I1_SOLO_RIENTRO": False,
    "UN_SEGNALE_PER_EPISODIO": True, "UNA_POSIZIONE_PER_VARIANTE": True,
}

# Sensibilita: una alla volta, tutte riportate, non selezionabili (specifica sez. 9).
SENSIBILITA = {
    "Sa": {"SD_GATE_S50": False},            # gate sd<S50 spento (resta sd<=sd[-3])
    "Sb": {"IMPULSIVA_ATR_INV": 1.0},         # INV con candela impulsiva 1,0 ATR (Checklist letterale)
    "Sc": {"MAXHOLD": 150},                   # chiusura forzata a 150 barre
    "Sd": {"SPREAD_MOLT": 1.5},               # spread x1,5
    "Se20": {"T_MAX": 20},
    "Se50": {"T_MAX": 50},
    "Sf": {"TOCCO_PEN_SPREAD": 1.0},          # tocco di banda valido solo con penetrazione >= 1 spread
    "Sg": {"I1_SOLO_RIENTRO": True},          # D007: INV, I1 valutata solo da p a tau (esplorativa)
}

# Soglie A2 per i soli descrittori (agents/A2/specifica.md sez. 1.1, 1.4, 1.5, 1.6, 1.7, 1.9; sez. 7 della specifica)
DESCRITTORI_A2 = {
    "N_CONG": 15,                 # finestra della congestione (barre che terminano in s)
    "CS_MIN": 4,                  # CS valida se >= 4/5
    "CS1_W": 0.85, "CS2_TR": 0.90, "CS2_CV": 0.60, "CS2_PREC": 50, "CS3_ER": 0.30, "CS4_Z": 1.5,
    "CS5_STAB": 0.5, "CS5_FIN": 10,
    "CDA1_FIN": 12, "CDA1_MIN": 10, "CDA3_W": 0.85, "CDA4_Z": 1.5, "CDA5_R2": 0.50, "CDA5_CORPO_ATR": 1.0,
    "A1_RAPP": 0.70, "A2_Z": 1.5, "A3_OMBRE": 1.5, "A4_OMBRA_ATR": 1.0, "A4_ENGULF_ATR": 0.75,
    "B1_CORPO_ATR": 1.0, "B2C_ER": 0.40,
    "C1_W_MAX": 0.90, "C1_LAG": 3, "C3_SD": 1.05,
    "T2_Z": 1.5, "T5_LAG": 3,
    "K1_DISC": 2, "K3_LAG": 5, "K3_N": 50,
    "RIENTRO_VALIDO": 0.80,
    "SPIKE_NEWS_ATR": 3.0,        # barre > 3 ATR nel bulge (solo conteggio)
    "N_PREV_FINESTRA": 200,
    "SOL_PESI": {"cong": 25.0, "bulge": 25.0, "rientro": 20.0, "bande": 15.0, "test": 10.0, "conferme": 5.0},
    "SOL_FASCE": {"Ottimo": 85.0, "Buono": 70.0, "Medio": 55.0},
    # invalidazioni
    "X2_Z": 1.0, "X3_TOL": 0.10, "X4_SD": 1.05, "X7_SD2": 1.10,
    # bonus
    "BN_A1_Z": 1.0, "BN_A1_CORPO": 0.3, "BN_A1_OMBRA": 2.0, "BN_A1_TERZO": 3.0, "BN_A1_ENG": 0.75,
    "BN_A3_Z": 1.0, "BN_B2_TOL": 0.10, "BN_B3_OMBRA": 1.0, "BN_C1_CV": 0.75, "BN_C2_Z": 1.5, "BN_C2_N": 3, "BN_C3_N": 5,
    "BN_D1": 5, "BN_D2_FIN": 4, "BN_D2_ATR": 1.0, "BN_D3_CORPO": 0.40, "BN_D3_OMBRA": 1.0,
    "BN_E1_TOL": 0.05, "BN_E2_LUN": 5, "BN_E2_Z": 0.75, "BN_E3_OMBRA": 1.5,
}

# Disegno del test / criteri (disegno_test_v1.md, criteri_previsioni_v1.md)
DISEGNO = {
    "SEED": 20261101, "N_ESTRAZIONI": 2000, "N_BOOTSTRAP": 10000,
    "B1_D_MIN": 0.85, "B1_D_MAX": 1.15,
    "N_INCONCLUSIVO": 30, "N_PIENO": 100, "EPS_R": 0.10, "P_B1_MAX": 0.05, "PF_MIN": 1.15,
    "IC_ALPHA": 0.05,                       # IC90 = percentili 5 e 95
    "WILSON_Z90": 1.6448536269514722,
    "PROB_CHECKLIST": {"Ottimo": (65.0, 75.0), "Buono": (55.0, 65.0), "Medio": (45.0, 55.0), "Debole": (0.0, 45.0)},
    "SOLIDITA_ACCORPATA": 70.0,
    "TOP_TRADE_ESCLUSI": 3, "DIAGNOSTICA_QUASI_AUTOCOLPENTE": 0.90,
    "FASCE_ORA": ((0, 7), (8, 15), (16, 23)),
    # placebo
    "PLACEBO_TARGET_SEGNALI": 1500, "PLACEBO_MAX_ANNI": 300, "PLACEBO_Z_MAX": 3.0, "PLACEBO_N_MIN": 100,
    "PLACEBO_MIN_PER_ANNO": 350000, "PLACEBO_PREZZO_PUNTI": 200000.0, "PLACEBO_SPREAD_PUNTI": 25.0,
    "GARCH_ALPHA": 0.08, "GARCH_BETA": 0.90, "PLACEBO_VOL_H_PUNTI": 150.0,
    "PLACEBO_SOTTOPASSI": 4, "PLACEBO_BLOCCO": 1440, "PLACEBO_RIMESCOLAMENTI": 200,
}

# Strumenti: dimensione del punto (spread del CSV in punti -> prezzo) e file. SOLO modifiche strumentali (ciclo 1).
# PUNTO e' un argomento di run_test.py (--punto); se omesso si usa quello noto del simbolo (--simbolo, default XAUUSD).
PUNTI_NOTI = {"XAUUSD": 0.01, "EURUSD": 0.00001, "GBPUSD": 0.00001, "USDJPY": 0.001, "EURJPY": 0.001}
SIMBOLO_DEFAULT = "XAUUSD"
# Righe attese per file (audit A3, solo oro)
ATTESE_RIGHE = {"2013": 348647, "2018": 349730, "2020": 351258, "2025-26": 611062}


def file_periodi(simbolo):
    """Nomi dei 4 file: ABTG_M1_<SIMBOLO>_2013/_2018/_2020.csv e ABTG_M1_<SIMBOLO>.csv (gen 2025 - set 2026)."""
    return {"2013": "ABTG_M1_%s_2013.csv" % simbolo, "2018": "ABTG_M1_%s_2018.csv" % simbolo,
            "2020": "ABTG_M1_%s_2020.csv" % simbolo, "2025-26": "ABTG_M1_%s.csv" % simbolo}


FILE_PERIODI = file_periodi(SIMBOLO_DEFAULT)      # compatibilita: i nomi dell'oro


def parametri(**override):
    """Copia di PARAMS con override (usato dalle sensibilita)."""
    p = dict(PARAMS)
    p.update(override)
    return p


def ricalcolo_barre(tf_min, prm=None):
    """Ricalcolo del target ogni RICALCOLO_ORE ore: H1 = 3 barre, M30 = 6 barre."""
    prm = prm or PARAMS
    return int(prm["RICALCOLO_ORE"] * 60 // tf_min)
