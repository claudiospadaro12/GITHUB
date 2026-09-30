#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- il collaudo a macchina di RIGA_ROUND_R92BAB.txt.

Fa girare la riga VERA sotto pwsh (Linux, PowerShell 7) con un driver FINTO (stub_driver.py) che scrive CSV IS/OOS (con la colonna Symbols_List) e un
giornale del tester UTF-16 nel formato VERO (righe copiate dal giornale del 30/09: gamba morta con 5 'works too long...' + 'Tester cannot be initialized';
gamba partita con 'Experts\\EA.ex5 on SIMBOLO,TF from ... to ...'), con `irm` servito da un magazzino locale (il driver AL PIN, via git show).
Verifica che ogni stato (OK, OK_TRONCATO, KO, MISTO, NV, NON LANCIATO) scatti quando deve e NON scatti quando non deve, e che i cancelli della riga reggano.
NON prova: Windows PowerShell 5.1, MT5, il tester, il tempo, l'attribuzione di un giornale VERO con orologi reali.
Uso:  python3 backtest_pipeline/collaudo_riga_R92BAB/battery.py [PIN] [RIGA]   (esce 0 se tutto come atteso). Serve: pwsh, python3, iconv, git.
"""
import json, os, subprocess, sys, re
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
OUT = os.environ.get("HARNESS_OUT", "/tmp/r92bab_harness")
os.makedirs(OUT, exist_ok=True)
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = sys.argv[2] if len(sys.argv) > 2 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_R92BAB.txt")
P, A, B, C, D, A2 = ["R92BAB_" + x for x in ("P", "A", "B", "C", "D", "A2")]
KO2 = {"legs": ["ko", "ko"], "rc": 2}
def st(**kw):
    d = dict(P="OK", A="OK", B="OK", C="OK", D="OK", A2="OK"); d.update(kw)
    return "STATI: " + " ".join("%s=%s" % (k, d[k]) for k in ("P", "A", "B", "C", "D", "A2"))
SAN = "SED_SHA"
# (nome, scenario, sed, grafici, macchina, mutazione servita, [DEVE esserci], [NON deve esserci])
T = [
 ("ok_tutti", {}, "", "ok", "DESKTOP-H4D7CAJ", "",
  [st(), "CONTROLLO POSITIVO P: OK", "ROUND LANCIATI: 6 su 6", "FILE ATTESI TROVATI: 25 su 25", "ZIP PRONTO DA MANDARE", "CATENA COMPLETA", "OnTesterInit works too long: 0 righe",
   "GUARDIA EA: grafici salvati letti 2, con un EA attaccato o illeggibili 0", "CLASSE 166/892: il motore compilato e quello del pin in tutti i 6 round partiti",
   "Symbols_List nel CSV: _IS 153 e _OOS 153 caratteri (dichiarati 153)", "Symbols_List nel CSV: _IS 55 e _OOS 55 caratteri (dichiarati 55)", "Symbols_List nel CSV: _IS 6 e _OOS 6 caratteri (dichiarati 6)",
   "from 2026.03.02 00:00 to 2026.05.01 00:00 su GBPUSD: = IS dichiarata", "from 2026.05.02 00:00 to 2026.06.30 00:00 su GBPUSD: = OOS dichiarata",
   "from 2026.08.03 00:00 to 2026.08.17 00:00 su D30EUR: = IS dichiarata", "from 2026.08.18 00:00 to 2026.09.01 00:00 su D30EUR: = OOS dichiarata", "NON ha svuotato Tester\\cache"],
  ["KO", "NV", "MISTO", "TRONCATO", "DIVERSA dalla dichiarata", "MANCA ", "RIGA FERMATA"]),
 # i tre guasti alla volta, come il 30/09 (2 gambe su 2 morte): il guasto si attribuisce al job per nome e il vicino resta OK
 ("A_guasto", {A: KO2}, "", "ok", "DESKTOP-H4D7CAJ", "",
  [st(A="KO"), "gambe viste 2 partite 0 morte 2", "OnTesterInit works too long: 12 righe", "MANCA ROUND_R92BAB_A\\ABTG_Bulge_GBPUSD_IS_ohlc_R92BAB_A.csv", "FILE ATTESI TROVATI: 23 su 25", "CONTROLLO POSITIVO P: OK"],
  ["R92BAB_B   KO", "R92BAB_A2  KO", "NV", "MANCA ROUND_R92BAB_A\\REFERTO"]),
 ("B_guasto", {B: KO2}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(B="KO"), "FILE ATTESI TROVATI: 23 su 25"], ["R92BAB_A   KO", "NV"]),
 ("C_guasto", {C: KO2}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(C="KO")], ["NV"]),
 ("H_STR_D_A_A2_guasto", {D: KO2, A: KO2, A2: KO2}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(D="KO", A="KO", A2="KO"), "FILE ATTESI TROVATI: 19 su 25"], ["NV"]),
 ("tutti_guasto_P_compreso", {k: KO2 for k in (P, A, B, C, D, A2)}, "", "ok", "DESKTOP-H4D7CAJ", "",
  [st(P="KO", A="KO", B="KO", C="KO", D="KO", A2="KO"), "CONTROLLO POSITIVO P: NON OK (stato KO)", "il banco NON vale"], ["CONTROLLO POSITIVO P: OK"]),
 ("gamba_mista", {A: {"legs": ["ok", "ko"], "rc": 2}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="MISTO"), "gambe viste 2 partite 1 morte 1"], ["NV"]),
 # un solo zero-operazioni NON e un guasto: B con Trades=0 e rc 2 del driver e OK se il tester e partito
 ("B_zero_operazioni", {B: {"trades": 0, "rc": 2}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(), "Trades>0: _IS su 0 di 2 righe, _OOS su 0 di 2 righe"], ["KO", "NV"]),
 # il troncamento del forum MQL5: partito ma col cesto tagliato, e lo stesso se MT5 collassa gli spazi del job D
 ("A_troncato_63", {A: {"sym_len": 63}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="OK_TRONCATO"), "PARTITO ma col cesto TAGLIATO: Symbols_List nel CSV 63/63 caratteri contro 153 dichiarati"], ["A=OK ", "NV"]),
 ("D_spazi_collassati", {D: {"sym_len": 55}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(D="OK_TRONCATO"), "Symbols_List nel CSV 55/55 caratteri contro 153 dichiarati"], ["NV"]),
 ("symbols_piu_lunga_della_dichiarata", {A: {"sym_plus": 4}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="NV"), "PIU LUNGA della dichiarata (157/157 contro 153)"], ["OK_TRONCATO"]),
 ("colonna_symbols_assente", {A: {"sym_col_absent": True}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="NV"), "colonna Symbols_List assente nel CSV"], ["OK_TRONCATO"]),
 # classe 992: finestra girata letta dal giornale
 ("finestra_OOS_un_giorno_prima", {B: {"win_bad": True}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(), "from 2026.05.02 00:00 to 2026.06.29 00:00 su GBPUSD: DIVERSA dalla dichiarata"], ["NV"]),
 # classe 940: il giornale e UNO PER GIORNO e porta le corse PRECEDENTI
 ("guasto_corsa_precedente", {A: {"prima": True}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(), "PRIMA dell avvio di questa riga (di corse precedenti dello stesso giorno, non contano): 1"], ["KO", "NV"]),
 ("giornale_assente", {k: {"no_logs": True} for k in (P, A, B, C, D, A2)}, "", "ok", "DESKTOP-H4D7CAJ", "",
  [st(P="NV", A="NV", B="NV", C="NV", D="NV", A2="NV"), "GIORNALE DEL TESTER: NON VERIFICABILE (file *Tester_logs* trovati 0, leggibili 0)", "CONTROLLO POSITIVO P: NON OK"], ["=OK", "=KO"]),
 ("giornale_vuoto", {k: {"tlog": "vuoto"} for k in (P, A, B, C, D, A2)}, "", "ok", "DESKTOP-H4D7CAJ", "",
  [st(P="NV", A="NV", B="NV", C="NV", D="NV", A2="NV"), "giornale del tester NON VERIFICABILE", "leggibili 0"], ["=OK", "=KO"]),
 # contraddizioni fra giornale e CSV: nessuna "partita" se il CSV non c'e, nessuna "morta" se il CSV c'e
 ("file_nullo_0_byte", {A: {"csv_zero": True}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="NV"), "contraddizione: il giornale dice 2 gambe partite ma i CSV non sono freschi con 2 righe ciascuno (_IS 0 byte ; _OOS 0 byte)"], ["A=OK"]),
 ("csv_non_fresco", {A: {"csv_stale": True}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="NV"), "VECCHIO (scritto prima del job)"], ["A=OK"]),
 ("csv_una_riga_sola", {A: {"una_riga": True}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="NV"), "righe 1 (attese 2)"], ["A=OK"]),
 ("gamba_morta_ma_csv_presente", {A: {"legs": ["ko", "ko"], "csv_anyway": True, "rc": 2}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="NV"), "contraddizione: il giornale dice 2 gambe morte ma esiste un CSV fresco"], ["A=KO"]),
 ("terza_gamba", {A: {"extra_leg": True}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="NV"), "gambe attribuite a questo job: 3 (attese 2)"], ["A=OK"]),
 ("gamba_di_un_altro_EA", {A: {"ea_other": "ABTG_EMA200"}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="NV"), "porta il nome di un ALTRO EA"], ["A=OK"]),
 # cancelli del motore e del driver
 ("rc1_su_B", {B: {"rc1": True}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(B="NV"), "rc 1: il driver non e partito", "PARTITI (rc diverso da 1): 5 su 6"], ["B=OK"]),
 ("EA_mutato", {A: {"mut_ea": True}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="NV"), "ABTG_Bulge.mq5 SHA256 DIVERSO DAL PIN", "MOTORE DIVERSO DAL PIN in 1 round"], ["A=OK"]),
 ("prova_mutata", {C: {"mut_prova": True}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(C="NV"), "prova SHA256 DIVERSO DAL PIN"], ["C=OK"]),
 ("walkforward_mutato", {A: {"mut_wf": True}}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(A="NV"), "walkforward_generico.ps1 SHA256 DIVERSO DAL PIN"], ["A=OK"]),
 ("walkforward_assente", {k: {"no_wf": True} for k in (P, A, B, C, D, A2)}, "", "ok", "DESKTOP-H4D7CAJ", "", [st(P="NV", A="NV", B="NV", C="NV", D="NV", A2="NV"), "walkforward_generico.ps1 ASSENTE"], ["=OK"]),
 ("tetto_45_minuti", {}, r"s/\$minAvv -ge \$TETTO/$minAvv -ge 0/", "ok", "DESKTOP-H4D7CAJ", "",
  [st(P="NON LANCIATO", A="NON LANCIATO", B="NON LANCIATO", C="NON LANCIATO", D="NON LANCIATO", A2="NON LANCIATO"), "NON LANCIATI (tetto): 6", "CONTROLLO POSITIVO P: NON OK"], ["ROUND LANCIATI: 6 su 6"]),
 ("riga_incoerente_frazione", {}, r"s/fz='0.5'; sl=6;/fz='0.6'; sl=6;/", "ok", "DESKTOP-H4D7CAJ", "", ["RIGA R92BAB INCOERENTE"], ["ROUND LANCIATI", "STATI:"]),
 ("riga_incoerente_lunghezze", {}, r"s/sl=55;/sl=56;/", "ok", "DESKTOP-H4D7CAJ", "", ["RIGA R92BAB INCOERENTE"], ["ROUND LANCIATI", "STATI:"]),
 ("macchina_sbagliata", {}, "", "ok", "VMI3047753", "", ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ"], ["ROUND LANCIATI", "GUARDIA EA"]),
 ("grafico_con_EA", {}, "", "ea", "DESKTOP-H4D7CAJ", "", ["GUARDIA EA: grafici salvati letti 3, con un EA attaccato o illeggibili 1", "GUARDIA EA: nel profilo del terminale 50503392"], ["ROUND LANCIATI"]),
 ("grafico_illeggibile", {}, "", "rotto", "DESKTOP-H4D7CAJ", "", ["ILLEGGIBILE", "GUARDIA EA: nel profilo del terminale 50503392"], ["ROUND LANCIATI"]),
 ("zero_grafici", {}, "", "zero", "DESKTOP-H4D7CAJ", "", ["GUARDIA EA: ho letto ZERO grafici salvati"], ["ROUND LANCIATI"]),
 ("driver_mutato_sha", {}, "", "ok", "DESKTOP-H4D7CAJ", "drv", ["RIGA_ROUND_VPS.ps1 scaricata con SHA256 DIVERSO"], ["ROUND LANCIATI"]),
]

def run(nome, sc, sed, ch, pc, mut):
    sf = os.path.join(OUT, "scen_%s.json" % nome)
    json.dump(sc, open(sf, "w"))
    env = dict(os.environ, HARNESS_OUT=OUT, RIGA_FILE=RIGA)
    subprocess.run(["bash", os.path.join(QD, "run.sh"), nome, sf, sed, ch, PIN, pc, mut], env=env, capture_output=True)
    t = open(os.path.join(OUT, "run_%s" % nome, "out.txt"), encoding="utf-8", errors="replace").read()
    return re.sub(r"\x1b\[[0-9;]*m", "", t)

def main():
    ok = 0
    sel = sys.argv[3:] if len(sys.argv) > 3 else None
    n = 0
    for (nome, sc, sed, ch, pc, mut, deve, nondeve) in T:
        if sel and nome not in sel:
            continue
        n += 1
        out = run(nome, sc, sed, ch, pc, mut)
        mancano = [x for x in deve if x not in out]
        troppo = [x for x in nondeve if x in out]
        esito = not mancano and not troppo
        ok += 1 if esito else 0
        print(("PASS  " if esito else "FALLITO ") + nome)
        for x in mancano:
            print("      MANCA nell'uscita:", x)
        for x in troppo:
            print("      NON doveva esserci:", x)
    print("BATTERIA: %d/%d" % (ok, n))
    sys.exit(0 if ok == n else 1)

if __name__ == "__main__":
    main()
