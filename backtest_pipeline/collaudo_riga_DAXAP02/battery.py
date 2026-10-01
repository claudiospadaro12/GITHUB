#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- il collaudo a macchina di RIGA_ROUND_DAXAP02.txt (stessa forma di collaudo_riga_R92BAB/battery.py).

Fa girare la riga VERA sotto pwsh (Linux, PowerShell 7) con un driver FINTO (stub_driver.py) che scrive CSV IS/OOS nel formato di OptFrame (asse prima,
poi tutti gli input, bool 1/0, InpNewsCurrencies in piu'), un giornale del tester UTF-16 con le righe VERE, il per-trade in Common\\Files e il
REFERTO del driver nelle sue righe vere; `irm` servito da un magazzino locale (il driver AL PIN, via git show); un disco C: finto con la cartella
programma del solo terminale ammesso. Due scenari usano i CSV VERI di R270e (28/09).
Verifica che OK / KO / NV scattino quando devono e NON scattino quando non devono, e che i cancelli della riga reggano (macchina, MT5 aperto,
terminale assente o collegamento, grafici con EA, driver mutato, riga incoerente, deposito/modello/terminale letti dal referto).
NON prova: Windows PowerShell 5.1, MT5, il tester, il tempo, la rete, GitHub raw.
Uso:  python3 backtest_pipeline/collaudo_riga_DAXAP02/battery.py [PIN] [RIGA] [nomi...]   (esce 0 se tutto come atteso). Serve: pwsh, python3, iconv, git.
"""
import json, os, subprocess, sys, re
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
OUT = os.environ.get("HARNESS_OUT", "/tmp/daxap02_harness")
os.makedirs(OUT, exist_ok=True)
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = sys.argv[2] if len(sys.argv) > 2 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_DAXAP02.txt")
PC = "DESKTOP-H4D7CAJ"
OK_ = "STATO: DAXAP02=OK"
NV_ = "STATO: DAXAP02=NV"
KO_ = "STATO: DAXAP02=KO"
FERMA = ["DAXAP02 OK", "DAXAP02 NV", "DAXAP02 KO", "RACCOLTA:"]          # una riga fermata dai cancelli NON arriva allo stato ne alla raccolta
NOSTUB = "__NOSTUB__"                                                     # marcatore: lo stub NON deve essere stato chiamato
STUBARGS = "__STUBARGS__"                                                 # marcatore: lo stub deve aver ricevuto -Modello 4 -Deposito 100000
# (nome, scenario, sed, grafici, macchina, mutazione servita, terminale, env extra, [DEVE esserci], [NON deve esserci])
T = [
 ("ok", {}, "", "ok", PC, "", "ok", {},
  [OK_, STUBARGS, "pin numerici confrontati: _IS 348 _OOS 348 (attesi 348 per gamba, piu 2 stringhe NON confrontate e l asse)",
   "[from 2024.09.26 00:00 to 2025.06.09 00:00 su D30EUR: = IS dichiarata] [from 2025.06.10 00:00 to 2026.06.30 00:00 su D30EUR: = OOS dichiarata]",
   "terminale C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe, deposito 100000, modello 4 = riga", "GUARDIA EA: grafici salvati letti 2, con un EA attaccato o illeggibili 0",
   "asse InpCloseHour [11/13/15/17] ok", "FILE ATTESI TROVATI: 6 su 6   NELLO ZIP: 6 su 6", "ZIP PRONTO DA MANDARE", "gamba OOS, chiusure dal 2025.06.11 10:23:12 al 2026.06.25 09:19:38",
   "IS   InpCloseHour  11", "OOS  InpCloseHour  17", "motore = pin (SHA256, EA + include + driver di walk-forward)", "NON ha svuotato Tester\\cache", "MARCATORE_RIGA_ROUND_DAXAP02_v1"],
  ["MOTIVO", "MANCA ", "DIVERSO", "DIVERSA", NV_, KO_, "GAMBE MORTE"]),
 # i CSV VERI di R270e portati alla forma attesa: il parser regge l intestazione vera (101 colonne, InpNewsCurrencies vuota, 0.0 scritto 0)
 ("csv_veri_R270e_corretti", {"real_csv": "patch"}, "", "ok", PC, "", "ok", {}, [OK_, "pin numerici confrontati: _IS 348 _OOS 348", "Profit    3789.36   PF  1.12634"], ["MOTIVO", NV_]),
 # i CSV VERI di R270e COSI COME SONO = il caso "pin perso" (InpCloseHour 17 dappertutto, InpTP1_R ad asse): deve dire NV, non OK
 ("csv_veri_R270e_pin_perso", {"real_csv": "raw"}, "", "ok", PC, "", "ok", {}, [NV_, "asse InpCloseHour [17/17/17/17] DIVERSO dall atteso 11/13/15/17", "il pin dell asse NON e arrivato"], [OK_]),
 ("ko_due_gambe_morte", {"legs": ["ko", "ko"], "rc": 2, "pertrade": False}, "", "ok", PC, "", "ok", {},
  [KO_, "gambe viste 2 partite 0 morte 2", "OnTesterInit works too long: 12 righe", "MANCA ROUND_DAXAP02\\ABTG_DAX_Apertura_EU_D30EUR_IS_DAXAP02.csv", "MANCA PERTRADE\\abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_798102.csv",
   "OK    ROUND_DAXAP02\\REFERTO_ROUND_DAXAP02.txt", "GAMBE MORTE: 2 su 2 (Tester cannot be initialized)", "NON rilanciare di tua iniziativa"], [OK_, NV_]),
 ("misto", {"legs": ["ok", "ko"], "rc": 2}, "", "ok", PC, "", "ok", {}, [NV_, "gambe ne partite ne morte in modo leggibile (viste 2, partite 1, morte 1)", "GAMBE MORTE: 1 su 2", "RIPESCA dalla cache"], [OK_, KO_]),
 ("ko_ma_csv_fresco", {"legs": ["ko", "ko"], "csv_anyway": True, "rc": 2}, "", "ok", PC, "", "ok", {}, [NV_, "il giornale dice 2 gambe morte ma esiste un CSV fresco"], [OK_, KO_]),
 ("trades_zero_in_una_cella", {"trades0": True, "rc": 3}, "", "ok", PC, "", "ok", {}, [NV_, "NON BUONO: righe 4 (attese 4), Trades>0 su 3"], [OK_]),
 ("tre_righe", {"una_riga": True}, "", "ok", PC, "", "ok", {}, [NV_, "righe 3 (attese 4)"], [OK_]),
 ("csv_0_byte", {"csv_zero": True}, "", "ok", PC, "", "ok", {}, [NV_, "contraddizione: il giornale dice 2 gambe partite ma i CSV non sono buoni (_IS 0 byte ; _OOS 0 byte)"], [OK_]),
 ("csv_vecchio", {"csv_stale": True}, "", "ok", PC, "", "ok", {}, [NV_, "VECCHIO (scritto prima del job)"], [OK_]),
 ("oos_assente", {"no_OOS": True, "rc": 2}, "", "ok", PC, "", "ok", {}, [NV_, "_OOS ASSENTE", "MANCA ROUND_DAXAP02\\ABTG_DAX_Apertura_EU_D30EUR_OOS_DAXAP02.csv"], [OK_]),
 ("asse_sbagliato", {"ax_vals": [11, 13, 15, 19]}, "", "ok", PC, "", "ok", {}, [NV_, "[11/13/15/19] DIVERSO dall atteso"], [OK_]),
 ("asse_ripetuto", {"ax_vals": [11, 11, 15, 17]}, "", "ok", PC, "", "ok", {}, [NV_, "[11/11/15/17] DIVERSO dall atteso"], [OK_]),
 ("pin_closemin_perso", {"pin_bad": "InpCloseMin"}, "", "ok", PC, "", "ok", {}, [NV_, "PIN DEL FILE PROVA NON ARRIVATI nel CSV: _IS 4 valori diversi InpCloseMin=[0] atteso 30"], [OK_]),
 ("pin_bool_perso", {"pin_bad": "InpAllowShort"}, "", "ok", PC, "", "ok", {}, [NV_, "InpAllowShort=[1] atteso 0"], [OK_]),
 ("pin_tp1r_perso", {"pin_bad": "InpTP1_R"}, "", "ok", PC, "", "ok", {}, [NV_, "InpTP1_R=[0] atteso 1"], [OK_]),
 ("colonna_assente", {"col_absent": "InpTP1_R"}, "", "ok", PC, "", "ok", {}, [NV_, "InpTP1_R=[] atteso 1"], [OK_]),
 ("finestra_oos_un_giorno_prima", {"win_bad": True}, "", "ok", PC, "", "ok", {}, [NV_, "FINESTRA GIRATA DIVERSA DALLA DICHIARATA (classe 992)", "to 2026.06.29 00:00 su D30EUR: DIVERSA dalla dichiarata"], [OK_]),
 ("corse_precedenti_stesso_giorno", {"prima": True}, "", "ok", PC, "", "ok", {}, [OK_, "(corse precedenti dello stesso giorno, non contano): 2"], [NV_, KO_]),
 ("giornale_assente", {"no_logs": True}, "", "ok", PC, "", "ok", {}, [NV_, "GIORNALE DEL TESTER: NON VERIFICABILE (file *Tester_logs* trovati 0, leggibili 0)"], [OK_]),
 ("giornale_vuoto", {"tlog": "vuoto"}, "", "ok", PC, "", "ok", {}, [NV_, "giornale del tester NON VERIFICABILE", "leggibili 0"], [OK_]),
 ("terza_gamba", {"extra_leg": True}, "", "ok", PC, "", "ok", {}, [NV_, "gambe attribuite a questo job: 3 (attese 2)"], [OK_]),
 ("gamba_di_altro_EA", {"ea_other": "ABTG_EMA200"}, "", "ok", PC, "", "ok", {}, [NV_, "porta il nome di un ALTRO EA"], [OK_]),
 ("rc1", {"rc1": True}, "", "ok", PC, "", "ok", {}, [NV_, "rc 1: il driver non e partito", "motore NON VERIFICATO", "MANCA ROUND_DAXAP02\\REFERTO_ROUND_DAXAP02.txt"], [OK_]),
 ("ea_mutato", {"mut_ea": True}, "", "ok", PC, "", "ok", {}, [NV_, "ABTG_DAX_Apertura_EU.mq5 SHA256 DIVERSO DAL PIN"], [OK_]),
 ("ea_assente", {"no_ea": True}, "", "ok", PC, "", "ok", {}, [NV_, "ABTG_DAX_Apertura_EU.mq5 ASSENTE"], [OK_]),
 ("include_mutato", {"mut_inc": True}, "", "ok", PC, "", "ok", {}, [NV_, "ABTG_PausaGuardian.mqh SHA256 DIVERSO DAL PIN"], [OK_]),
 ("walkforward_mutato", {"mut_wf": True}, "", "ok", PC, "", "ok", {}, [NV_, "walkforward_generico.ps1 SHA256 DIVERSO DAL PIN"], [OK_]),
 ("walkforward_assente", {"no_wf": True}, "", "ok", PC, "", "ok", {}, [NV_, "walkforward_generico.ps1 ASSENTE"], [OK_]),
 ("prova_mutata", {"mut_prova": True}, "", "ok", PC, "", "ok", {}, [NV_, "prova SHA256 DIVERSO DAL PIN"], [OK_]),
 # il referto del driver: e la sola prova, a corsa fatta, di QUALE terminale, deposito e modello hanno girato
 ("referto_assente", {"ref_absent": True}, "", "ok", PC, "", "ok", {}, [NV_, "REFERTO DEL DRIVER ASSENTE", "MANCA ROUND_DAXAP02\\REFERTO_ROUND_DAXAP02.txt"], [OK_]),
 ("referto_vecchio_sul_desktop", {"ref_absent": True}, "", "ok", PC, "", "ok", {"PRE_OLD": "1"}, [NV_, "tolta la cartella di una corsa PRECEDENTE: ROUND_DAXAP02", "REFERTO DEL DRIVER ASSENTE"], [OK_]),
 ("referto_terminale_banco_VPS", {"ref_term": "C:\\MT5_Backtest\\terminal64.exe"}, "", "ok", PC, "", "ok", {}, [NV_, "terminale C:\\MT5_Backtest\\terminal64.exe", "DIVERSO DALLA RIGA"], [OK_]),
 ("deposito_non_passato", {}, r"s/ -Deposito \$jb.dp;/;/", "ok", PC, "", "ok", {}, [NV_, "deposito 10000, modello 4 DIVERSO DALLA RIGA"], [OK_]),
 ("modello_1_passato", {}, r"s/-Modello \$jb.m /-Modello 1 /", "ok", PC, "", "ok", {}, [NV_, "modello 1 DIVERSO DALLA RIGA"], [OK_]),
 ("pin_diverso_passato", {}, r"s/-Pin \$PIN /-Pin lavoro /", "ok", PC, "", "ok", {}, [NV_, "referto: pin lavoro,"], [OK_]),
 # il per-trade e INFORMATIVO (classe 455): non cambia lo stato, ma si dice cosa e
 ("pertrade_vecchio", {"pertrade_stale": True}, "", "ok", PC, "", "ok", {}, [OK_, "assente in Common\\Files o scritto prima del job", "MANCA PERTRADE\\abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_798102.csv"], [NV_]),
 ("pertrade_solo_IS", {"pertrade_ct": ["2024.10.01 10:00:00", "2025.06.09 16:00:00"]}, "", "ok", PC, "", "ok", {}, [OK_, "2 deal di uscita, gamba IS (ultima chiusura 2025.06.09 16:00:00)"], [NV_, "gamba OOS"]),
 ("pertrade_magic_estraneo", {"pertrade_mg": "786325"}, "", "ok", PC, "", "ok", {}, [OK_, "righe con magic diverso da 798102: 3"], [NV_]),
 # i cancelli PRIMA del job: la riga si ferma, lo stub NON viene chiamato
 ("riga_incoerente_deposito", {}, r"s/dp=100000;/dp=10000;/", "ok", PC, "", "ok", {}, ["RIGA DAXAP02 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_frazione", {}, r"s/fz='0.40';/fz='0.50';/", "ok", PC, "", "ok", {}, ["RIGA DAXAP02 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_input", {}, r"s/np=90;/np=89;/", "ok", PC, "", "ok", {}, ["RIGA DAXAP02 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_modello", {}, r"s/m=4; dp=/m=1; dp=/", "ok", PC, "", "ok", {}, ["RIGA DAXAP02 INCOERENTE", NOSTUB], FERMA),
 ("macchina_VPS", {}, "", "ok", "VMI3047753", "", "ok", {}, ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: VMI3047753", NOSTUB], FERMA + ["GUARDIA EA"]),
 ("macchina_vuota", {}, "", "ok", "", "", "ok", {}, ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ", NOSTUB], FERMA),
 ("mt5_aperto", {}, "", "ok", PC, "", "ok", {"PRE_MT5": "1"}, ["MT5 risulta APERTO su questo PC", NOSTUB], FERMA + ["GUARDIA EA"]),
 ("terminale_assente", {}, "", "ok", PC, "", "assente", {}, ["TERMINALE: non trovo C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe", NOSTUB], FERMA),
 ("terminale_collegamento", {}, "", "ok", PC, "", "link", {}, ["e un COLLEGAMENTO (junction o link)", NOSTUB], FERMA),
 ("grafico_con_EA", {}, "", "ea", PC, "", "ok", {}, ["GUARDIA EA: grafici salvati letti 3, con un EA attaccato o illeggibili 1", "EA: ABTG_DAX_Apertura_EU", NOSTUB], FERMA),
 ("grafico_illeggibile", {}, "", "rotto", PC, "", "ok", {}, ["ILLEGGIBILE", "GUARDIA EA: nel profilo del terminale 50503392", NOSTUB], FERMA),
 ("zero_grafici", {}, "", "zero", PC, "", "ok", {}, ["GUARDIA EA: ho letto ZERO grafici salvati", NOSTUB], FERMA),
 ("driver_mutato", {}, "", "ok", PC, "drv", "ok", {}, ["RIGA_ROUND_VPS.ps1 scaricata con SHA256 DIVERSO", NOSTUB], FERMA),
]

def run(nome, sc, sed, ch, pc, mut, term, envx):
    sf = os.path.join(OUT, "scen_%s.json" % nome)
    json.dump(sc, open(sf, "w"))
    env = dict(os.environ, HARNESS_OUT=OUT, RIGA_FILE=RIGA)
    env.update(envx)
    subprocess.run(["bash", os.path.join(QD, "run.sh"), nome, sf, sed, ch, PIN, pc, mut, term], env=env, capture_output=True)
    H = os.path.join(OUT, "run_%s" % nome)
    t = open(os.path.join(H, "out.txt"), encoding="utf-8", errors="replace").read()
    sl = os.path.join(H, "stub.log")
    stub = open(sl).read() if os.path.exists(sl) else ""
    return re.sub(r"\x1b\[[0-9;]*m", "", t), stub

def main():
    ok = 0
    sel = sys.argv[3:] if len(sys.argv) > 3 else None
    n = 0
    for (nome, sc, sed, ch, pc, mut, term, envx, deve, nondeve) in T:
        if sel and nome not in sel:
            continue
        n += 1
        out, stub = run(nome, sc, sed, ch, pc, mut, term, envx)
        mancano = []
        for x in deve:
            if x == NOSTUB:
                if stub != "":
                    mancano.append("lo stub NON doveva essere chiamato, e invece: " + stub.strip())
            elif x == STUBARGS:
                if "-Expert ABTG_DAX_Apertura_EU -Prova PRV_DAXAP_02_closehour_770101_D30EUR.txt -Etichetta DAXAP02 -Pin " + PIN + " -Modello 4 -Deposito 100000" not in stub:
                    mancano.append("argomenti del driver diversi da -Expert/-Prova/-Etichetta/-Pin/-Modello 4/-Deposito 100000: " + stub.strip())
            elif x not in out:
                mancano.append(x)
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
