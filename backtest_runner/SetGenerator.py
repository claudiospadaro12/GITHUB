#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""SetGenerator.py - genera i set (.set) di Template_EA_Wim.mq5 per 3 profili di rischio.

Profili (sono PROFILI DI PROVA, non consigli di taglia: lotti/rischio li decide Claudio):
  Wim_PropFirm_LowRisk.set  rischio basso, tetti stretti (sfida prop firm)
  Wim_Real_MidRisk.set      rischio medio (conto reale, tetti medi)
  Wim_Aggressive.set        rischio alto (solo per vedere i limiti, mai per un conto vero senza decisione tua)

Cosa copia da Wim (fonte: i suoi set nei nostri file, vedi REGOLE_WIM.md):
  - lotto fisso per CONFRONTARE i test, % di rischio per il conto vero;
  - tetti di perdita giornaliera/totale come negli esempi PropFirm (giornaliero 2-4 %, totale 8-9 %);
  - struttura degli input: livelli con forza L/R e countback, distanza minima, offset, scadenza,
    break-even, trailing, filtro spread/sessione/trend.
Cosa NON e di Wim: l'EA, i valori esatti dei suoi set (non li ha pubblicati tutti), le modalita RETEST e LIMIT.

Uso:
  python3 SetGenerator.py                       # 3 set in ./Set_profili
  python3 SetGenerator.py --modalita-tutte      # 3 profili x 3 ingressi (BREAKOUT/RETEST/LIMIT) = 9 set
  python3 SetGenerator.py --simbolo XAUUSD      # adatta i punti fissi al simbolo (oro / EURUSD / indici)
Ogni chiave viene confrontata con gli input di Template_EA_Wim.mq5: se manca o e di troppo, il programma si ferma.
"""
import argparse
import os
import re
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
EA = os.path.join(AQUI, "Template_EA_Wim.mq5")

# valori numerici degli enum del template
ENTRY = {"BREAKOUT": 0, "RETEST": 1, "LIMIT": 2}
SLM = {"ATR": 0, "FIXED_PTS": 1, "LEVEL": 2}
TPM = {"RR": 0, "ATR": 1, "FIXED_PTS": 2}
TF = {"M15": 15, "M30": 30, "H1": 16385, "H2": 16386, "H4": 16388, "D1": 16408}

# punti fissi per simbolo (usati solo se SL/TP sono in punti fissi; con ATR non contano)
PUNTI = {
    "XAUUSD": {"sl": 400, "tp": 800, "be": 20},
    "EURUSD": {"sl": 300, "tp": 600, "be": 10},
    "DEFAULT": {"sl": 300, "tp": 600, "be": 10},
}

# parte comune: struttura del trade (uguale per i tre profili, cosi il confronto e solo sul rischio)
COMUNE = {
    "InpMagic": 880001,
    "InpComment": "TPL_WIM",
    "InpDebug": "false",
    "InpRearm": "true",
    "InpLevelTF": TF["H1"],
    "InpCountback": 24,
    "InpUsePivots": "false",
    "InpHLStrengthL": 3,
    "InpHLStrengthR": 2,
    "InpMinDistLevelAtr": 0.20,
    "InpOffsetAtr": 0.10,
    "InpEntryMode": ENTRY["BREAKOUT"],
    "InpExpirationBars": 24,
    "InpRetestMaxBars": 6,
    "InpRetestTolAtr": 0.15,
    "InpSLMode": SLM["ATR"],
    "InpSLAtr": 1.5,
    "InpTPMode": TPM["RR"],
    "InpTP_RR": 2.0,
    "InpTPAtr": 3.0,
    "InpUseBE": "true",
    "InpBEStartR": 1.0,
    "InpUseTrail": "false",
    "InpTrailStartR": 1.5,
    "InpTrailAtr": 1.0,
    "InpFixedLot": "false",
    "InpLot": 0.10,
    "InpATRPeriod": 14,
    "InpATRTF": TF["H1"],
    "InpMaxSpreadPts": 0,
    "InpUseSession": "false",
    "InpSessionStartHour": 7,
    "InpSessionEndHour": 21,
    "InpUseEmaFilter": "false",
    "InpEmaPeriod": 200,
    "InpEmaTF": TF["H1"],
    "InpCloseOnBreach": "true",
    "InpMaxOpenPos": 1,
}

# parte che cambia: SOLO il rischio (e, per l'aggressivo, il trailing e un'operazione in piu al giorno)
PROFILI = {
    "Wim_PropFirm_LowRisk": {
        "InpRiskPct": 0.5, "InpMaxDailyLossPct": 2.0, "InpMaxTotalDDPct": 4.0, "InpMaxTradesPerDay": 1,
        "dd_max_pct_validazione": 4.0,
        "nota": "tetto giornaliero 2% come PropFirmMaxDailyDD=2.0 di Goldbot_PropFirm; tetto totale 4% (piu stretto del 9% del Gold Phantom PropFirm)",
    },
    "Wim_Real_MidRisk": {
        "InpRiskPct": 1.0, "InpMaxDailyLossPct": 3.0, "InpMaxTotalDDPct": 8.0, "InpMaxTradesPerDay": 2,
        "dd_max_pct_validazione": 8.0,
        "nota": "rischio 1% per operazione, tetti 3% giornaliero e 8% totale",
    },
    "Wim_Aggressive": {
        "InpRiskPct": 2.0, "InpMaxDailyLossPct": 5.0, "InpMaxTotalDDPct": 15.0, "InpMaxTradesPerDay": 3,
        "InpUseTrail": "true",
        "dd_max_pct_validazione": 15.0,
        "nota": "rischio 2% per operazione, trailing attivo; serve solo a vedere dove si rompe",
    },
}


def input_dal_template(percorso):
    """Legge i nomi degli input dal .mq5 (righe 'input TIPO NOME = valore;')."""
    nomi = []
    with open(percorso, encoding="utf-8") as f:
        for riga in f:
            m = re.match(r"\s*input\s+[A-Za-z_0-9]+\s+(\w+)\s*=", riga)
            if m:
                nomi.append(m.group(1))
    return nomi


def valore_set(v):
    return v if isinstance(v, str) else (repr(v) if isinstance(v, float) else str(v))


def scrivi_set(cartella, nome, valori, nomi_input, nota):
    mancanti = [n for n in nomi_input if n not in valori]
    di_troppo = [n for n in valori if n not in nomi_input and not n.startswith("dd_") and n != "nota"]
    if mancanti or di_troppo:
        sys.exit("ERRORE %s: input mancanti %s, chiavi sconosciute %s" % (nome, mancanti, di_troppo))
    righe = ["; %s.set - generato da SetGenerator.py per Template_EA_Wim.mq5" % nome,
             "; %s" % nota,
             "; PROFILO DI PROVA per il tester/demo: non e un consiglio di taglia."]
    for n in nomi_input:  # stesso ordine degli input del template
        righe.append("%s=%s" % (n, valore_set(valori[n])))
    percorso = os.path.join(cartella, nome + ".set")
    with open(percorso, "w", encoding="ascii", newline="") as f:
        f.write("\r\n".join(righe) + "\r\n")
    return percorso


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--uscita", default=os.path.join(AQUI, "Set_profili"))
    ap.add_argument("--simbolo", default="XAUUSD")
    ap.add_argument("--modalita-tutte", action="store_true", help="3 profili x BREAKOUT/RETEST/LIMIT")
    a = ap.parse_args()

    nomi = input_dal_template(EA)
    if len(nomi) < 30:
        sys.exit("Letti solo %d input da %s: file diverso dal previsto" % (len(nomi), EA))
    os.makedirs(a.uscita, exist_ok=True)
    pt = PUNTI.get(a.simbolo.upper(), PUNTI["DEFAULT"])
    base = dict(COMUNE)
    base.update({"InpSLPts": pt["sl"], "InpTPPts": pt["tp"], "InpBEExtraPts": pt["be"]})

    modalita = ENTRY if a.modalita_tutte else {"BREAKOUT": 0}
    catalogo = ["set;profilo;ingresso;rischio_pct;tetto_giorno_pct;tetto_totale_pct;dd_max_validazione_pct"]
    for pn, prof in PROFILI.items():
        for mn, mv in modalita.items():
            v = dict(base)
            v.update({k: x for k, x in prof.items() if k.startswith("Inp")})
            v["InpEntryMode"] = mv
            nome = pn if not a.modalita_tutte else "%s_%s" % (pn, mn)
            p = scrivi_set(a.uscita, nome, v, nomi, prof["nota"])
            catalogo.append("%s;%s;%s;%s;%s;%s;%s" % (nome, pn, mn, v["InpRiskPct"], v["InpMaxDailyLossPct"], v["InpMaxTotalDDPct"], prof["dd_max_pct_validazione"]))
            print("scritto", p)
    with open(os.path.join(a.uscita, "profili.csv"), "w", encoding="ascii") as f:
        f.write("\n".join(catalogo) + "\n")
    print("OK: %d input del template, %d set. Soglie di DD per profilo in profili.csv" % (len(nomi), len(catalogo) - 1))


if __name__ == "__main__":
    main()
