#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- il collaudo a macchina di RIGA_ROUND_LATI.txt (QUATTRO job, UNA tranche per job con la gamba OOS DEGENERE, driver con la riprova, tre cancelli: sentinella S1+S2 e gemelle T2 di
LATI-A2, gemelle T1 di LATI-A1, tolleranza di banco). Stessa forma di collaudo_riga_EMAGEM2/battery.py (round del 03/10, passato dal cancello) e di collaudo_riga_DAXAP03/battery.py.
I cancelli si collaudano con LE STESSE ~90 prove al bordo del lettore indipendente (leggi_lati.py, Python/Decimal; qui la riga e' PowerShell/[decimal]): le attese sono scritte A MANO in
leggi_lati._casi_a2 e _casi_a1 (limiti derivati col conto, non letti dal codice). In piu': in ogni scenario in cui i cancelli NON sono tutti PASS (e in ogni scenario in cui la catena di un
job e' rotta) i numeri dei job A1 NON devono comparire ne' in console ne' nel RIEPILOGO ne' nelle righe del per-trade ne' nella console del driver (classi 1090 e 1092: lo stub stampa come il driver).

Fa girare la riga VERA sotto pwsh (Linux, PowerShell 7) con un driver FINTO (stub_driver.py) che scrive, per ciascun job, il CSV IS con le DUE celle dell asse (A2: i numeri VERI di R110, scritti da MT5
il 26/08; A1: numeri sintetici), il CSV OOS degenere (0 byte), un giornale del tester UTF-16 con le righe VERE (la gamba OOS degenere come l ha scritta MT5 il 27/09), il file RIPROVE nelle righe del
driver VERO, il per-trade (uno per magic) e il REFERTO della riga RETRY (con la riga ESITO); `irm` servito da un magazzino locale (righe/RIGA_ROUND_VPS_RETRY.ps1 AL PIN, via git show); un disco C: finto.
Un'attesa che comincia con RIEP: si cerca SOLO nel RIEPILOGO scritto nella raccolta, con CONS: SOLO nella console, con CONS2: almeno DUE volte nella console.
NON prova: Windows PowerShell 5.1, MT5, il tester, il tempo vero, la rete, GitHub raw, il driver vero (per quello: riprove_veri.py contro i file scritti dal driver vero).
Uso:  python3 backtest_pipeline/collaudo_riga_LATI/battery.py [PIN] [RIGA] [nomi...]   (esce 0 se tutto come atteso). Serve: pwsh, python3, iconv, git.
"""
import json, os, re, subprocess, sys, datetime as dt
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
import leggi_lati as LG
from concurrent.futures import ThreadPoolExecutor
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
OUT = os.environ.get("HARNESS_OUT", "/tmp/lati_harness")
os.makedirs(OUT, exist_ok=True)
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = sys.argv[2] if len(sys.argv) > 2 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_LATI.txt")
PC = "DESKTOP-H4D7CAJ"
A2L, A2S, A1L, A1S = "LATIA2L", "LATIA2S", "LATIA1L", "LATIA1S"
EA = "ABTG_EMA200"
PROVE = {A2L: "LATI_A2_EMA200_U30USD_TORO_long.txt", A2S: "LATI_A2_EMA200_U30USD_TORO_short.txt", A1L: "LATI_A1_EMA200_U30USD_DISCESA_long.txt", A1S: "LATI_A1_EMA200_U30USD_DISCESA_short.txt"}
MAGIC = {A2L: "764102", A2S: "764103", A1L: "764100", A1S: "764101"}
def ST(a, b, c, d):
    return "STATO: LATIA2L=%s LATIA2S=%s LATIA1L=%s LATIA1S=%s" % (a, b, c, d)
OK4 = ST("OK", "OK", "OK", "OK")
FERMA = ["LATIA2L OK", "LATIA2L NV", "LATIA1S NV", "RACCOLTA:", "STATO: LATIA2L"]   # una riga fermata dai cancelli NON arriva agli stati ne alla raccolta
NOSTUB = "__NOSTUB__"            # lo stub NON deve essere stato chiamato
STUBARGS = "__STUBARGS__"        # lo stub deve aver ricevuto, per OGNI job, gli argomenti esatti (scadenza = T0 + 20 minuti, con lo spazio)
def RP(l):
    return "ROUND_%s\\RIPROVE_%s_U30USD_%s.txt" % (l, EA, l)
def CLOCK(lbl):
    return r"s/\$minAvv=\[int\](((Get-Date)-\$T0).TotalMinutes);/$minAvv=[int](((Get-Date)-$T0).TotalMinutes) + $(if($LBL -eq '%s'){45}else{0});/" % lbl
CA2 = "CANCELLO A2 (sentinella T1 + gemelle T2 di LATI-A2): "
CA1 = "CANCELLO A1 (gemelle T1 di LATI-A1): "
LET_OK = "LETTURA DI LATI-A1: PERMESSA (i tre cancelli sono PASS)"
LET_NO = "LETTURA DI LATI-A1: NON PERMESSA"
PASS2 = "S1 PASS (le due celle L+S riproducono 23321.47 / 1.52365 / 7.8323 / 517 di R110 DENTRO LA TOLLERANZA DI BANCO: Trades e DD esatti, Profit entro 1,00 EUR, PF entro 0,0002), S2 PASS (LONG puro e SHORT puro dentro 2 per cento su n e 0,05 su PF di 241 / 1,24103 e 302 / 1,89147) e T2 PASS (le due celle L+S dei due file uguali dentro la tolleranza su Profit, Expected Payoff, PF, Recovery Factor, Sharpe, DD e Trades)."
PASS1 = "T1 PASS (le due celle L+S dei due file LATI_A1 uguali dentro la TOLLERANZA DI BANCO su Profit, Expected Payoff, PF, Recovery Factor, Sharpe, DD e Trades)."
# I NUMERI dei job A1 non devono comparire quando i cancelli non sono PASS: ne' la tabella (console e RIEPILOGO), ne' il per-trade, ne' la console del driver, ne' i valori
NOA1 = ["LATIA1L IS   InpAllow", "LATIA1S IS   InpAllow", "PERTRADE LATIA1L ", "PERTRADE LATIA1S ", "STUBNUM LATIA1L", "STUBNUM LATIA1S"] + LG.NO_A1
NSL = "NON SI LEGGE (cancello A2 %s, cancello A1 %s)"
def spatch(job, ax, col, val):
    return {"job": job, "ax": ax, "col": col, "val": val}
def scen_da_patch(patch):
    """patch di leggi_lati {(sig, ax, col): val} -> scenario dello stub {etichetta: {'patch': [...]}}"""
    out = {}
    for (sig, ax, col), val in sorted(patch.items()):
        out.setdefault(LG.ETI[sig], {"patch": []})["patch"].append({"ax": ax, "col": col, "val": val})
    return out
T = []
def add(nome, sc, deve, nondeve, sed="", ch="ok", pc=PC, mut="", term="ok", envx=None, hide=False):
    d = list(deve); n = list(nondeve)
    if hide:
        d.append(LET_NO); n += NOA1
    T.append((nome, sc, sed, ch, pc, mut, term, envx or {}, d, n))
NOK = ["MOTIVO: ", "MANCA ", "SHA256 DIVERSO", "DIVERSO DALLA RIGA", "DIVERSI dalla", "DIVERSO dall atteso", "DIVERSA dalla", "=NV", " NV   rc", "GAMBE IS SENZA CSV", "GAMBE RIPROVATE", "=OK_RIPROVATO", "MOTORE DIVERSO DAL PIN:", "NON SI LEGGE", "FAIL",
       "STUBNUM LATIA1L", "STUBNUM LATIA1S"]
DEVE_OK = [OK4, STUBARGS, "pin numerici confrontati: _IS 78 (attesi 78 per la gamba IS, piu 2 stringhe NON confrontate e l asse)",
           "giornale: intestazioni 2 partite 1 morte 0 degeneri 1   RIPROVE: IS: PARTITA, CSV PRODOTTO; OOS: NON_VERIFICABILE, CSV PRODOTTO;",
           "[from 2025.06.10 00:00 to 2026.06.30 00:00 su U30USD: = IS dichiarata] [gamba senza finestra: DEGENERE, il tester dice set mode to math calculations]",
           "[from 2025.02.01 00:00 to 2025.04.30 00:00 su U30USD: = IS dichiarata] [gamba senza finestra: DEGENERE, il tester dice set mode to math calculations]",
           "terminale C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe, deposito 100000, modello 4, driver walkforward_generico_RETRY.ps1, riprova [MaxRiprove 1   attesa 20 s   scadenza ",
           "esito [NON MISURATO -- CSV mancanti o vuoti: OOS] = riga",
           "GUARDIA EA: grafici salvati letti 2, con un EA attaccato o illeggibili 0", "asse InpAllowShort [0/1] ok", "asse InpAllowLong [0/1] ok",
           "FILE ATTESI TROVATI: 23 su 23   NELLO ZIP: 23 su 23", "ZIP PRONTO DA MANDARE", "OK    " + RP(A2L), "OK    " + RP(A2S), "OK    " + RP(A1L), "OK    " + RP(A1S),
           "LATIA2L IS   InpAllowShort  0  InpMagic 764102   Trades   241   Profit    5670.52   PF  1.24103   Equity DD % 8.8973",
           "LATIA2L IS   InpAllowShort  1  InpMagic 764102   Trades   517   Profit   23321.47   PF  1.52365   Equity DD % 7.8323",
           "LATIA2S IS   InpAllowLong  0  InpMagic 764103   Trades   302   Profit   16948.35   PF  1.89147   Equity DD % 2.6628",
           "LATIA1L IS   InpAllowShort  0  InpMagic 764100   Trades    41   Profit   -1500.12   PF  0.80123   Equity DD % 5.4321",
           "LATIA1S IS   InpAllowLong  1  InpMagic 764101   Trades    82   Profit   -2345.67   PF  0.87654   Equity DD % 7.1234",
           "LATIA2L OOS  gamba degenere (finestra vuota): nessun numero, ATTESO", "STUBNUM LATIA2L", "STUBNUM LATIA2S",
           "CATENA COMPLETA: 4 cartelle del driver su 4 job lanciati", "motore = pin (SHA256, EA + include + walkforward_generico_RETRY + RIGA_ROUND_VPS_RETRY)", "NON ha svuotato Tester\\cache", "MARCATORE_RIGA_ROUND_LATI_v1",
           "righe con magic diverso da 764102: 0", "righe con magic diverso da 764103: 0", "righe con magic diverso da 764100: 0", "righe con magic diverso da 764101: 0",
           "ROUND LANCIATI: 4 su 4   NON LANCIATI (tetto): 0   PARTITI (rc diverso da 1): 4 su 4   MOTORE DIVERSO DAL PIN in 0 job", "=== RIEPILOGO ===",
           "direttive, input, asse, lato pinnato, rischio e magic: = riga (42 input, asse InpAllowShort, lato pinnato InpAllowLong e rischio 1, nessuna @DEPOSITO)",
           "direttive, input, asse, lato pinnato, rischio e magic: = riga (42 input, asse InpAllowLong, lato pinnato InpAllowShort e rischio 1, nessuna @DEPOSITO)",
           CA2 + "PASS   " + PASS2, "CONS2:" + CA2 + "PASS   ", "RIEP:" + CA2 + "PASS   " + PASS2, CA1 + "PASS   " + PASS1, "RIEP:" + CA1 + "PASS   " + PASS1,
           LET_OK, "RIEP:" + LET_OK, "CONSOLE_DRIVER\\CONSOLE_DRIVER_LATIA1L.txt", "CONSOLE_DRIVER\\CONSOLE_DRIVER_LATIA1S.txt",
           "PERTRADE LATIA2L abtg_trades_%s_U30USD_764102.csv: 3 deal di uscita, gamba IS, unica gamba vera" % EA, "PERTRADE LATIA1S abtg_trades_%s_U30USD_764101.csv: 3 deal di uscita, gamba IS, unica gamba vera" % EA]
add("ok", {}, DEVE_OK, NOK)
# ---- I TRE CANCELLI CON LA TOLLERANZA: LE STESSE prove al bordo del lettore indipendente
CASI_CANCELLO = []
for _i, (_nome, _patch, _att) in enumerate(LG._casi_a2()):
    _n = "CA2_%02d_%s" % (_i, re.sub(r"[^A-Za-z0-9]+", "_", _nome)[:56].strip("_"))
    if not _att:
        _deve = [OK4, CA2 + "PASS   " + PASS2, "CONS2:" + CA2 + "PASS   ", "RIEP:" + CA2 + "PASS   " + PASS2, CA1 + "PASS", LET_OK, "LATIA1L IS   InpAllowShort  0  InpMagic 764100", "PERTRADE LATIA1L abtg_trades_%s_U30USD_764100.csv" % EA]
        _non = ["NON SI LEGGE", "S1 FAIL", "S2 FAIL", "T2 FAIL", "=NV", LET_NO, "STUBNUM LATIA1L"]
        if "03/10" in _nome or "R235" in _nome:
            _non = _non + []
        add(_n, scen_da_patch(_patch), _deve, _non)
    else:
        _deve = [OK4, CA2 + "FAIL", "-> BANCO NON CONFERMATO: ROUND LATI-A1 INVALIDO secondo i file prova, i numeri di LATIA1L e LATIA1S NON SI LEGGONO", "CONS:   LATIA1L: " + NSL % ("FAIL", "PASS"), "RIEP:   LATIA1S: " + NSL % ("FAIL", "PASS")]
        for x in ("S1", "S2", "T2"):
            _deve.append("%s %s" % (x, "FAIL (" if x in _att else "PASS"))
        _add_non = ["T1 FAIL", "A2: PASS", CA2 + "PASS"]
        add(_n, scen_da_patch(_patch), _deve, _add_non, hide=True)
for _i, (_nome, _patch, _att) in enumerate(LG._casi_a1()):
    _n = "CA1_%02d_%s" % (_i, re.sub(r"[^A-Za-z0-9]+", "_", _nome)[:56].strip("_"))
    if _att == "PASS":
        add(_n, scen_da_patch(_patch), [OK4, CA2 + "PASS", CA1 + "PASS   T1 PASS", LET_OK, "LATIA1L IS   InpAllowShort  0  InpMagic 764100"], ["NON SI LEGGE", "T1 FAIL", "=NV", LET_NO])
    else:
        add(_n, scen_da_patch(_patch), [OK4, CA2 + "PASS", CA1 + "FAIL   T1 FAIL (", "solo lo scarto", "-> il banco non e deterministico: NESSUN numero di LATIA1L e LATIA1S si legge e NESSUNO si stampa",
                                       "CONS:   LATIA1L: " + NSL % ("PASS", "FAIL"), "RIEP:   LATIA1S: " + NSL % ("PASS", "FAIL")], ["T1 PASS", CA1 + "PASS"], hide=True)
# i residui entro tolleranza si ELENCANO: in A2 con i valori (il caso del 03/10), in A1 col SOLO scarto
_res = "RESIDUI DENTRO LA TOLLERANZA (4, si scrivono, nessun giudizio): LATIA2S L+S Profit [23321.46] contro R110 [23321.47] (scarto 0.01) ; gemelle L+S Profit [23321.47] contro [23321.46] (scarto 0.01) ; gemelle L+S Expected Payoff [45.10923] contro [45.10921] (scarto 0.00002) ; gemelle L+S Sharpe Ratio [8.16765] contro [8.16764] (scarto 0.00001)"
add("residui_A2_caso_0310", scen_da_patch({("A2S", "1", "Profit"): "23321.46", ("A2S", "1", "Expected Payoff"): "45.10921", ("A2S", "1", "Sharpe Ratio"): "8.16764"}), [OK4, CA2 + "PASS", "CONS:" + _res, "RIEP:" + _res], ["=NV", "NON SI LEGGE"])
_res1 = "RESIDUI DENTRO LA TOLLERANZA (2, si scrivono solo come scarto, nessun giudizio): gemelle L+S Profit scarto 0.50 ; gemelle L+S Sharpe Ratio scarto 0.00026"
add("residui_A1_solo_scarto", scen_da_patch({("A1S", "1", "Profit"): "-2345.17", ("A1S", "1", "Sharpe Ratio"): "-1.23430"}), [OK4, CA1 + "PASS", "CONS:" + _res1, "RIEP:" + _res1], ["=NV", "NON SI LEGGE", "[-2345.17]", "[-1.23430]"])
add("residuo_A1_FAIL_senza_valori", scen_da_patch({("A1S", "1", "Profit"): "-2000.00"}), [OK4, CA1 + "FAIL", "T1 FAIL (1 colonne fuori tolleranza, solo lo scarto: Profit scarto 345.67)"], ["-2000.00", "[-2345.67]"], hide=True)
# ---- la catena di ogni job
def catena(nome, sc, deve, nondeve, **kw):
    add(nome, sc, deve, nondeve, **kw)
# a un A2 non certificato: il cancello A2 NON gira (NON VERIFICABILE) e i numeri di A1 non si leggono, anche se A1 e' girato bene
add("A2L_asse_sbagliato_NV", {A2L: {"ax_vals": [0, 2]}}, [ST("NV", "OK", "OK", "OK"), CA2 + "NON VERIFICABILE   LATIA2L ha STATO NV", "-> i numeri di LATIA1L e LATIA1S NON SI LEGGONO (il cancello non ha potuto dire PASS)",
    "RIEP:" + CA2 + "NON VERIFICABILE", "asse InpAllowShort [0/2] DIVERSO dall atteso 0/1", CA1 + "PASS"], ["T1 FAIL", "S1 PASS"], hide=True)
add("A2L_due_gambe_IS_morte_KO", {A2L: {"legs": ["ko_ko", "ok"]}}, [ST("KO", "OK", "OK", "OK"), "LATIA2L KO   rc 2", CA2 + "NON VERIFICABILE   LATIA2L ha STATO KO", "giornale: intestazioni 3 partite 0 morte 2 degeneri 1",
    "GAMBE IS SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 1 (LATIA2L 1 su 1", "GAMBE RIPROVATE DAL DRIVER: 1 (LATIA2L IS)", "NON e una replica", "RIPESCATE dalla cache",
    "FrameAdd r.655 in OnTester r.643", "ExportTrades r.616 chiamata in OnTester r.645", "magic 764100-764103", "FILE ATTESI TROVATI: 21 su 23   NELLO ZIP: 21 su 23",
    "MANCA ROUND_LATIA2L\\%s_U30USD_IS_LATIA2L.csv" % EA, "MANCA PERTRADE\\abtg_trades_%s_U30USD_764102.csv" % EA, "OK    " + RP(A2L)], ["LATIA2L OK", "LATIA2L NV"], hide=True)
add("A2S_gamba_IS_morta_oltre_scadenza_KO", {A2S: {"legs": ["ko", "ok"]}}, [ST("OK", "KO", "OK", "OK"), "LATIA2S KO   rc 2", CA2 + "NON VERIFICABILE   LATIA2L ha STATO OK e LATIA2S ha STATO KO"], ["LATIA2S OK", "LATIA2S NV"], hide=True)
add("A1S_gamba_IS_morta_due_volte_KO_A2_resta_PASS", {A1S: {"legs": ["ko_ko", "ok"]}}, [ST("OK", "OK", "OK", "KO"), "LATIA1S KO   rc 2", CA2 + "PASS   " + PASS2, CA1 + "NON VERIFICABILE   LATIA1L ha STATO OK e LATIA1S ha STATO KO",
    "GAMBE IS SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 1 (LATIA1S 1 su 1", "LATIA2L IS   InpAllowShort  0  InpMagic 764102   Trades   241"], ["LATIA1S OK", "LATIA1S NV", CA1 + "PASS"], hide=True)
add("T1_A1_rc1_NV", {A1L: {"rc1": True}}, [ST("OK", "OK", "NV", "OK"), "rc 1: il driver si e fermato con un ERRORE", CA1 + "NON VERIFICABILE   LATIA1L ha STATO NV"], ["T1 PASS", "T1 FAIL"], hide=True)
add("A2L_non_lanciato", {}, [ST("NON LANCIATO", "OK", "OK", "OK"), CA2 + "NON VERIFICABILE   LATIA2L o LATIA2S NON LANCIATO (tetto): il cancello non e stato eseguito", "=== LATIA2L: NON LANCIATO (tetto di 25 minuti"], ["S1 PASS"], sed=CLOCK(A2L), hide=True)
add("A1S_non_lanciato", {}, [ST("OK", "OK", "OK", "NON LANCIATO"), CA2 + "PASS   " + PASS2, CA1 + "NON VERIFICABILE   LATIA1L o LATIA1S NON LANCIATO (tetto): il cancello non e stato eseguito", "=== LATIA1S: NON LANCIATO (tetto di 25 minuti",
    "FILE ATTESI TROVATI: 17 su 17   NELLO ZIP: 17 su 17", "ROUND LANCIATI: 3 su 4   NON LANCIATI (tetto): 1"], ["LATIA1S OK", "LATIA1S NV"], sed=CLOCK(A1S), hide=True)
add("A2S_non_lanciato", {}, [ST("OK", "NON LANCIATO", "OK", "OK"), "=== LATIA2S: NON LANCIATO (tetto di 25 minuti", "FILE ATTESI TROVATI: 18 su 18"], ["LATIA2S OK"], sed=CLOCK(A2S), hide=True)
# OK_RIPROVATO e un RILIEVO: i numeri si leggono come OK, i cancelli girano
add("A2L_riprovata_e_salvata", {A2L: {"legs": ["ko_ok", "ok"]}}, [ST("OK_RIPROVATO", "OK", "OK", "OK"), "LATIA2L OK_RIPROVATO   rc 2", "giornale: intestazioni 3 partite 1 morte 1 degeneri 1", "RIPROVE: IS: MORTA_INIT poi PARTITA RIPROVATA, CSV PRODOTTO; OOS: NON_VERIFICABILE, CSV PRODOTTO;",
    "GAMBE RIPROVATE DAL DRIVER: 1 (LATIA2L IS)", "RILIEVO, non un difetto: gamba IS", "FILE ATTESI TROVATI: 23 su 23   NELLO ZIP: 23 su 23", CA2 + "PASS", CA1 + "PASS", LET_OK], ["LATIA2L NV", "GAMBE IS SENZA CSV", "MANCA ", "NON SI LEGGE", "FAIL"])
add("A1S_riprovata_e_salvata", {A1S: {"legs": ["ko_ok", "ok"]}}, [ST("OK", "OK", "OK", "OK_RIPROVATO"), "LATIA1S OK_RIPROVATO   rc 2", "GAMBE RIPROVATE DAL DRIVER: 1 (LATIA1S IS)", CA2 + "PASS", CA1 + "PASS", LET_OK], ["LATIA1S NV", "NON SI LEGGE", "FAIL"])
add("tutti_i_job_riprovati", {A2L: {"legs": ["ko_ok", "ok"]}, A2S: {"legs": ["ko_ok", "ok"]}, A1L: {"legs": ["ko_ok", "ok"]}, A1S: {"legs": ["ko_ok", "ok"]}}, [ST("OK_RIPROVATO", "OK_RIPROVATO", "OK_RIPROVATO", "OK_RIPROVATO"),
    "GAMBE RIPROVATE DAL DRIVER: 4 (LATIA2L IS, LATIA2S IS, LATIA1L IS, LATIA1S IS)", "FILE ATTESI TROVATI: 23 su 23", CA2 + "PASS", CA1 + "PASS", LET_OK], ["=NV", "GAMBE IS SENZA CSV", "NON SI LEGGE"])
add("IS_morta_con_altra_causa", {A1L: {"legs": ["altro", "ok"]}}, [ST("OK", "OK", "NV", "OK"), "un tentativo della gamba IS con esito diverso da PARTITA o MORTA_INIT", "MORTA_ALTRO"], ["LATIA1L KO"], hide=True)
add("morta_ma_csv_IS_fresco", {A2S: {"legs": ["ko", "ok"], "csv_anyway": True}}, [ST("OK", "NV", "OK", "OK"), "contraddizione: il driver dice CSV NON PRODOTTO per la gamba IS ma esiste un CSV fresco"], ["LATIA2S KO"], hide=True)
add("giornale_e_riprove_non_tornano", {A1L: {"extra_leg": True}}, [ST("OK", "OK", "NV", "OK"), "il giornale del tester e il file RIPROVE NON TORNANO: giornale 3 intestazioni, 2 partite, 0 morte, 1 degeneri (attesa 1); RIPROVE 2 tentativi, 1 PARTITA, 0 MORTA_INIT"], ["LATIA1L OK"], hide=True)
add("riprove_assente", {A2S: {"legs": ["ko_ok", "ok"], "rp_absent": True}}, [ST("OK", "NV", "OK", "OK"), "file RIPROVE del driver ASSENTE: non so quante volte e stata lanciata ogni gamba (classe 1030)", "MANCA " + RP(A2S)], ["LATIA2S OK"], hide=True)
add("riprove_vecchio", {A1L: {"rp_stale": True}}, [ST("OK", "OK", "NV", "OK"), "file RIPROVE del driver VECCHIO (scritto prima del job)"], ["LATIA1L OK"], hide=True)
add("riprove_una_gamba", {A2S: {"rp_una_gamba": True}}, [ST("OK", "NV", "OK", "OK"), "file RIPROVE del driver con 1 righe GAMBA (attese IS e OOS una volta ciascuna)"], ["LATIA2S OK"], hide=True)
add("riprove_incoerente_IS", {A1S: {"legs": ["ko", "ok"], "rp_dice_prodotto": "IS"}}, [ST("OK", "OK", "OK", "NV"), "file RIPROVE INCOERENTE per la gamba IS"], ["LATIA1S KO"], hide=True)
add("riprove_senza_flag_RIPROVATA", {A2L: {"legs": ["ko_ok", "ok"], "rp_no_rip": "IS"}}, [ST("NV", "OK", "OK", "OK"), "file RIPROVE INCOERENTE per la gamba IS"], ["LATIA2L OK"], hide=True)
add("rp_copia_mancante_in_raccolta", {A2S: {"rp_nocopy": True}}, [OK4, "MANCA " + RP(A2S), "FILE ATTESI TROVATI: 22 su 23   NELLO ZIP: 22 su 23", CA2 + "PASS"], ["MANCA " + RP(A2L)])
# ---- LA GAMBA OOS DEGENERE (classe 647): attesa, e ogni scostamento e un NV col suo motivo
add("OOS_degenere_senza_CSV_accettata", {A1L: {"oos_csv": "none"}}, [OK4, "RIPROVE: IS: PARTITA, CSV PRODOTTO; OOS: NON_VERIFICABILE, CSV NON PRODOTTO;", "[_OOS ASSENTE: gamba OOS degenere, atteso assente o da 0 byte]", CA2 + "PASS", CA1 + "PASS", LET_OK, "FILE ATTESI TROVATI: 23 su 23"], ["=NV", "NON SI LEGGE"])
add("OOS_partita_normalmente", {A2L: {"oos": "partita"}}, [ST("NV", "OK", "OK", "OK"), "il giornale del tester e il file RIPROVE NON TORNANO: giornale 2 intestazioni, 2 partite, 0 morte, 0 degeneri (attesa 1)"], ["LATIA2L OK"], hide=True)
add("OOS_morta_in_OnTesterInit", {A1S: {"oos": "morta"}}, [ST("OK", "OK", "OK", "NV"), "NON TORNANO"], ["LATIA1S OK"], hide=True)
add("OOS_CSV_con_righe", {A2S: {"oos_csv": "righe"}}, [ST("OK", "NV", "OK", "OK"), "contraddizione: la gamba OOS e degenere ma il suo CSV ha righe"], ["LATIA2S OK"], hide=True)
add("OOS_riprovata_una_sola_intestazione", {A1L: {"rp_oos_rip": True}}, [ST("OK", "OK", "NV", "OK"), "la gamba OOS NON e come attesa per una finestra degenere (un solo tentativo NON_VERIFICABILE senza riprova)"], ["LATIA1L OK"], hide=True)
add("OOS_due_tentativi", {A2L: {"oos": "nv2"}}, [ST("NV", "OK", "OK", "OK")], ["LATIA2L OK"], hide=True)
add("OOS_senza_nessuna_riga_RIPROVE", {A1S: {"oos": "nessuna"}}, [ST("OK", "OK", "OK", "NV"), "file RIPROVE del driver con 1 righe GAMBA (attese IS e OOS una volta ciascuna)"], ["LATIA1S OK"], hide=True)
add("giornale_con_intestazione_in_piu", {A2S: {"extra_header": True}}, [ST("OK", "NV", "OK", "OK"), "il giornale del tester e il file RIPROVE NON TORNANO: giornale 3 intestazioni, 1 partite, 0 morte, 1 degeneri (attesa 1); RIPROVE 2 tentativi, 1 PARTITA, 0 MORTA_INIT"], ["LATIA2S OK"], hide=True)
add("giornale_OOS_senza_set_mode", {A1L: {"no_setmode": True}}, [ST("OK", "OK", "NV", "OK"), "il giornale del tester e il file RIPROVE NON TORNANO: giornale 2 intestazioni, 1 partite, 0 morte, 0 degeneri (attesa 1); RIPROVE 2 tentativi, 1 PARTITA, 0 MORTA_INIT"], ["LATIA1L OK"], hide=True)
add("OOS_dice_NON_PRODOTTO_ma_il_file_c_e", {A2S: {"rp_oos_dice": "nonprodotto"}}, [ST("OK", "NV", "OK", "OK"), "contraddizione: il driver dice CSV NON PRODOTTO per la gamba OOS degenere ma il file _OOS e 0 byte"], ["LATIA2S OK"], hide=True)
add("OOS_dice_PRODOTTO_ma_il_file_manca", {A1L: {"oos_csv": "none", "rp_oos_dice": "prodotto"}}, [ST("OK", "OK", "NV", "OK"), "contraddizione: il driver dice CSV PRODOTTO per la gamba OOS degenere ma il file _OOS e ASSENTE"], ["LATIA1L OK"], hide=True)
add("giornale_senza_set_mode", {A1L: {"oos": "deg"}}, [OK4], ["=NV"], mut="")   # segnaposto: sostituito sotto
T.pop()
add("rc_0_invece_di_2", {A2L: {"rc": 0}}, [ST("NV", "OK", "OK", "OK"), "rc 0 invece di 2: con la gamba OOS degenere il driver deve chiudere NON MISURATO (rc 2)"], ["LATIA2L OK"], hide=True)
add("rc_3_invece_di_2", {A1S: {"rc": 3}}, [ST("OK", "OK", "OK", "NV"), "rc 3 invece di 2"], ["LATIA1S OK"], hide=True)
add("esito_del_referto_ROUND_GIRATO", {A2L: {"ref_esito": "ROUND GIRATO"}}, [ST("NV", "OK", "OK", "OK"), "la riga ESITO del referto del driver dice [ROUND GIRATO] invece di [NON MISURATO -- CSV mancanti o vuoti: OOS]"], ["LATIA2L OK"], hide=True)
add("esito_del_referto_solo_IS", {A1L: {"ref_esito": "NON MISURATO -- CSV mancanti o vuoti: IS"}}, [ST("OK", "OK", "NV", "OK"), "invece di [NON MISURATO -- CSV mancanti o vuoti: OOS]"], ["LATIA1L OK"], hide=True)
add("esito_del_referto_KO_sbagliato", {A2S: {"legs": ["ko_ko", "ok"], "ref_esito": "NON MISURATO -- CSV mancanti o vuoti: OOS"}}, [ST("OK", "NV", "OK", "OK"), "la gamba IS non ha prodotto ma la riga ESITO del referto dice [NON MISURATO -- CSV mancanti o vuoti: OOS] invece di [NON MISURATO -- CSV mancanti o vuoti: IS, OOS]"], ["LATIA2S KO"], hide=True)
# ---- i CSV IS
add("trades_zero_in_una_cella", {A2L: {"trades0": True}}, [ST("NV", "OK", "OK", "OK"), "NON BUONO: righe 2 (attese 2), Trades>0 su 1", CA2 + "NON VERIFICABILE"], ["LATIA2L OK"], hide=True)
add("una_riga_in_meno_su_A1", {A1S: {"una_riga": True}}, [ST("OK", "OK", "OK", "NV"), "righe 1 (attese 2)"], ["LATIA1S OK"], hide=True)
add("csv_IS_0_byte", {A1L: {"csv_zero": True}}, [ST("OK", "OK", "NV", "OK"), "contraddizione: il driver dice CSV PRODOTTO per la gamba IS ma il CSV non e buono (_IS 0 byte)"], ["LATIA1L OK"], hide=True)
add("csv_IS_vecchio", {A2S: {"csv_stale": True}}, [ST("OK", "NV", "OK", "OK"), "VECCHIO (scritto prima del job)"], ["LATIA2S OK"], hide=True)
add("IS_assente", {A1S: {"no_IS": True, "rp_dice_prodotto": "IS"}}, [ST("OK", "OK", "OK", "NV"), "contraddizione: il driver dice CSV PRODOTTO per la gamba IS ma il CSV non e buono (_IS ASSENTE)"], ["LATIA1S OK"], hide=True)
add("asse_non_0_1_su_A1", {A1L: {"ax_vals": [0, 2]}}, [ST("OK", "OK", "NV", "OK"), "[0/2] DIVERSO dall atteso 0/1"], ["LATIA1L OK"], hide=True)
add("asse_ripetuto_su_A2S", {A2S: {"ax_vals": [1, 1]}}, [ST("OK", "NV", "OK", "OK"), "[1/1] DIVERSO dall atteso 0/1", "il pin dell asse NON e arrivato"], ["LATIA2S OK"], hide=True)
add("asse_non_arrivato_0_0", {A1S: {"ax_vals": [0, 0]}}, [ST("OK", "OK", "OK", "NV"), "[0/0] DIVERSO dall atteso 0/1"], ["LATIA1S OK"], hide=True)
add("pin_magic_perso_su_A1S", {A1S: {"pin_bad": "InpMagic"}}, [ST("OK", "OK", "OK", "NV"), "PIN DEL FILE PROVA NON ARRIVATI nel CSV: _IS 2 valori diversi InpMagic=[0] atteso 764101"], ["LATIA1S OK"], hide=True)
add("pin_lato_pinnato_perso_su_A2L", {A2L: {"pin_bad": "InpAllowLong"}}, [ST("NV", "OK", "OK", "OK"), "InpAllowLong=[0] atteso 1"], ["LATIA2L OK"], hide=True)
add("pin_lato_pinnato_perso_su_A1S", {A1S: {"pin_bad": "InpAllowShort"}}, [ST("OK", "OK", "OK", "NV"), "InpAllowShort=[0] atteso 1"], ["LATIA1S OK"], hide=True)
add("pin_rischio_perso_su_A1L", {A1L: {"pin_bad": "InpRiskPercent"}}, [ST("OK", "OK", "NV", "OK"), "InpRiskPercent=[0] atteso 1"], ["LATIA1L OK"], hide=True)
add("pin_TF_perso", {A2S: {"pin_bad": "InpTF"}}, [ST("OK", "NV", "OK", "OK"), "InpTF=[0] atteso 16385"], ["LATIA2S OK"], hide=True)
add("colonna_assente", {A1L: {"col_absent": "InpEmaPeriod"}}, [ST("OK", "OK", "NV", "OK"), "InpEmaPeriod=[] atteso 200"], ["LATIA1L OK"], hide=True)
add("csv_di_un_altro_job_magic", {A1L: {"pin_over": {"InpMagic": "764101"}}}, [ST("OK", "OK", "NV", "OK"), "InpMagic=[764101] atteso 764100"], ["LATIA1L OK"], hide=True)
add("finestra_IS_un_giorno_prima_su_A1", {A1L: {"win_bad": True}}, [ST("OK", "OK", "NV", "OK"), "FINESTRA GIRATA DIVERSA DALLA DICHIARATA (classe 992)", "to 2025.04.29 00:00 su U30USD: DIVERSA dalla dichiarata"], ["LATIA1L OK"], hide=True)
add("finestra_IS_un_giorno_prima_su_A2", {A2S: {"win_bad": True}}, [ST("OK", "NV", "OK", "OK"), "to 2026.06.29 00:00 su U30USD: DIVERSA dalla dichiarata"], ["LATIA2S OK"], hide=True)
add("corse_precedenti_stesso_giorno", {"prima": True}, [OK4, "(corse precedenti dello stesso giorno, non contano): 8"], ["=NV"])
add("giornale_assente", {"no_logs": True}, [ST("NV", "NV", "NV", "NV"), "GIORNALE DEL TESTER: NON VERIFICABILE (file *Tester_logs* trovati 0, leggibili 0)", CA2 + "NON VERIFICABILE"], ["LATIA2L OK"], hide=True)
add("giornale_vuoto", {"tlog": "vuoto"}, [ST("NV", "NV", "NV", "NV"), "giornale del tester NON VERIFICABILE"], ["LATIA2L OK"], hide=True)
add("gamba_di_altro_EA", {A1S: {"ea_other": "ABTG_Nightly"}}, [ST("OK", "OK", "OK", "NV"), "porta il nome di un ALTRO EA"], ["LATIA1S OK"], hide=True)
# classi 166/892, DOPO OGNI JOB: la mutazione nel SOLO terzo job deve colpire il terzo e non il primo ne il secondo
add("ea_mutato_nel_terzo_job", {A1L: {"mut_ea": True}}, [ST("OK", "OK", "NV", "OK"), "%s.mq5 SHA256 DIVERSO DAL PIN" % EA, "MOTORE DIVERSO DAL PIN in 1 job"], ["LATIA1L OK", "LATIA2L NV", "LATIA2S NV"], hide=True)
add("ea_assente_su_A2L", {A2L: {"no_ea": True}}, [ST("NV", "OK", "OK", "OK"), "%s.mq5 ASSENTE" % EA], ["LATIA2L OK"], hide=True)
add("include_mutato", {A2L: {"mut_inc": True}}, [ST("NV", "OK", "OK", "OK"), "ABTG_PausaGuardian.mqh SHA256 DIVERSO DAL PIN"], ["LATIA2L OK"], hide=True)
add("walkforward_retry_mutato", {A1S: {"mut_wf": True}}, [ST("OK", "OK", "OK", "NV"), "walkforward_generico_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["LATIA1S OK"], hide=True)
add("walkforward_retry_assente", {A2L: {"no_wf": True}}, [ST("NV", "OK", "OK", "OK"), "walkforward_generico_RETRY.ps1 ASSENTE"], ["LATIA2L OK"], hide=True)
add("walkforward_originale_col_nome_RETRY", {A2L: {"wf_originale": True}}, [ST("NV", "OK", "OK", "OK"), "walkforward_generico_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["LATIA2L OK"], hide=True)
add("riga_retry_locale_mutata_durante_il_quarto_job", {A1S: {"mut_drvloc": True}}, [ST("OK", "OK", "OK", "NV"), "RIGA_ROUND_VPS_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["LATIA1S OK", "LATIA1L NV"], hide=True)
add("riga_retry_locale_mutata_durante_il_terzo_job", {A1L: {"mut_drvloc": True}}, [ST("OK", "OK", "NV", "NV"), "RIGA_ROUND_VPS_RETRY.ps1 SHA256 DIVERSO DAL PIN", "MOTORE DIVERSO DAL PIN in 2 job"], ["LATIA1L OK", "LATIA2S NV"], hide=True)
add("prova_mutata", {A1S: {"mut_prova": True}}, [ST("OK", "OK", "OK", "NV"), "prova SHA256 DIVERSO DAL PIN"], ["LATIA1S OK"], hide=True)
# il referto del driver (classi 1019 e 1032)
add("referto_assente", {A2L: {"ref_absent": True}}, [ST("NV", "OK", "OK", "OK"), "REFERTO DEL DRIVER ASSENTE", "MANCA ROUND_LATIA2L\\REFERTO_ROUND_LATIA2L.txt"], ["LATIA2L OK"], hide=True)
add("referto_vecchio_sul_desktop", {A1L: {"ref_absent": True}}, [ST("OK", "OK", "NV", "OK"), "tolta la cartella di una corsa PRECEDENTE: ROUND_LATIA1L", "REFERTO DEL DRIVER ASSENTE"], ["LATIA1L OK"], envx={"PRE_OLD": A1L}, hide=True)
add("referto_non_riscritto", {A1S: {"ref_stale": True}}, [ST("OK", "OK", "OK", "NV"), "REFERTO DEL DRIVER VECCHIO (scritto prima del job: NON e di questa corsa)"], ["LATIA1S OK"], hide=True)
add("referto_terminale_banco_VPS", {A2L: {"ref_term": "C:\\MT5_Backtest\\terminal64.exe"}}, [ST("NV", "OK", "OK", "OK"), "terminale C:\\MT5_Backtest\\terminal64.exe", "DIVERSO DALLA RIGA"], ["LATIA2L OK"], hide=True)
add("referto_driver_originale", {A1L: {"ref_driver": "walkforward_generico.ps1"}}, [ST("OK", "OK", "NV", "OK"), "driver walkforward_generico.ps1, riprova", "DIVERSO DALLA RIGA (attesi deposito 100000"], ["LATIA1L OK"], hide=True)
add("cartella_vecchia_non_rimovibile", {}, ["NON riesco a togliere la cartella di una corsa PRECEDENTE", "ROUND_LATIA1S", NOSTUB], FERMA + ["tolta la cartella"], envx={"PRE_OLD": A1S, "NO_RM": A1S})
add("zip_senza_un_file", {}, [OK4, "FILE ATTESI TROVATI: 23 su 23   NELLO ZIP: 22 su 23", "nello zip: NO"], ["NELLO ZIP: 23 su 23"], envx={"ZIP_DROP": "RIPROVE_%s_U30USD_LATIA2S" % EA})
add("zip_vecchio", {}, [OK4, "ZIP VECCHIO (scritto prima di questa raccolta, NON e di questa corsa)", "FILE ATTESI TROVATI: 23 su 23   NELLO ZIP: 0 su 23"], ["ZIP PRONTO DA MANDARE"], envx={"ZIP_STALE": "1"})
add("zip_senza_riepilogo", {}, [OK4, "NELLO ZIP: 22 su 23"], ["NELLO ZIP: 23 su 23"], envx={"ZIP_DROP": "RIEPILOGO_ROUND_LATI"})
add("zip_senza_console_driver_A1", {}, [OK4, "NELLO ZIP: 22 su 23"], ["NELLO ZIP: 23 su 23"], envx={"ZIP_DROP": "CONSOLE_DRIVER_LATIA1L"})
add("riga_magic_diverso_dal_file", {}, [ST("OK", "OK", "NV", "OK"), "(magic atteso 764110, lato pinnato InpAllowLong a true e rischio 1 attesi, asse InpAllowShort)"], ["LATIA1L OK"],
    sed=r"s/mg='764100'; pm=@('764100')/mg='764110'; pm=@('764110')/; s/-ne '764102,764103,764100,764101'/-ne '764102,764103,764110,764101'/g", hide=True)
# gli argomenti passati al driver (classe 1019): li dice il referto, non la riga
add("deposito_non_passato", {}, [ST("NV", "NV", "NV", "NV"), "deposito 10000, modello 4", CA2 + "NON VERIFICABILE"], ["LATIA2L OK"], sed=r"s/ -Deposito \$jb.dp / /g", hide=True)
add("modello_1_passato", {"no_ohlc_sfx": True}, [ST("NV", "NV", "NV", "NV"), "modello 1, driver"], ["LATIA2L OK"], sed=r"s/-Modello \$jb.m /-Modello 1 /g", hide=True)
add("pin_diverso_passato", {}, [ST("NV", "NV", "NV", "NV"), "referto: pin lavoro,"], ["LATIA2L OK"], sed=r"s/-Pin \$PIN /-Pin lavoro /g", hide=True)
add("maxriprove_0_passato", {}, [ST("NV", "NV", "NV", "NV"), "riprova [MaxRiprove 0   attesa 20 s"], ["LATIA2L OK"], sed=r"s/-MaxRiprove \$MAXRIP /-MaxRiprove 0 /g", hide=True)
add("scadenza_non_passata", {}, [ST("NV", "NV", "NV", "NV"), "scadenza nessuna], esito [NON MISURATO -- CSV mancanti o vuoti: OOS] DIVERSO DALLA RIGA"], ["LATIA2L OK"], sed=r"s/ -RiprovaEntro \$scadTxt\( }\| 1>\)/\1/g", hide=True)
# il per-trade e INFORMATIVO (classe 455): non cambia lo stato, ma si dice cosa e
add("pertrade_vecchio_su_A2L", {A2L: {"pertrade_stale": True}}, [OK4, "PERTRADE LATIA2L abtg_trades_%s_U30USD_764102.csv: assente in Common\\Files o scritto prima del job" % EA, "MANCA PERTRADE\\abtg_trades_%s_U30USD_764102.csv" % EA, "FILE ATTESI TROVATI: 22 su 23"], ["=NV"])
add("pertrade_oltre_la_finestra_su_A1L", {A1L: {"pertrade_ct": ["2025.02.04 08:23:12", "2025.05.20 15:32:17"]}}, [OK4, "chiusure OLTRE la fine della finestra IS (dal 2025.02.04 08:23:12 al 2025.05.20 15:32:17): ANOMALO"], ["=NV"])
add("pertrade_magic_estraneo_su_A2S", {A2S: {"pertrade_mg": "763300"}}, [OK4, "righe con magic diverso da 764103: 3"], ["=NV"])
# i cancelli PRIMA del job: la riga si ferma, lo stub NON viene chiamato
def inc(nome, sed):
    add(nome, {}, ["RIGA LATI INCOERENTE", NOSTUB], FERMA, sed=sed)
inc("riga_incoerente_deposito", r"s/dp=100000; d0='2025.06.10'; me='2026.06.30'; oa='2026.07.01'; d1='2026.06.30'; fz='1.0'; ax='InpAllowShort'; av=@(0,1); nr=2; fx='InpAllowLong'; mg='764102'/dp=10000; d0='2025.06.10'; me='2026.06.30'; oa='2026.07.01'; d1='2026.06.30'; fz='1.0'; ax='InpAllowShort'; av=@(0,1); nr=2; fx='InpAllowLong'; mg='764102'/")
inc("riga_incoerente_asse_di_A1S", r"s/ax='InpAllowLong'; av=@(0,1); nr=2; fx='InpAllowShort'; mg='764101'/ax='InpAllowShort'; av=@(0,1); nr=2; fx='InpAllowShort'; mg='764101'/")
inc("riga_incoerente_valori_asse", r"s/av=@(0,1); nr=2; fx='InpAllowLong'; mg='764100'/av=@(0,2); nr=2; fx='InpAllowLong'; mg='764100'/")
inc("riga_incoerente_lato_pinnato", r"s/fx='InpAllowLong'; mg='764102'/fx='InpAllowShort'; mg='764102'/")
inc("riga_incoerente_magic", r"s/mg='764101'; pm=@('764101')/mg='764104'; pm=@('764101')/")
inc("riga_incoerente_magic_per_trade", r"s/mg='764101'; pm=@('764101')/mg='764101'; pm=@('764104')/")
inc("riga_incoerente_modello", r"s/m=4; dp=100000; d0='2025.02.01'; me='2025.04.30'; oa='2025.05.01'; d1='2025.04.30'; fz='1.0'; ax='InpAllowLong'/m=1; dp=100000; d0='2025.02.01'; me='2025.04.30'; oa='2025.05.01'; d1='2025.04.30'; fz='1.0'; ax='InpAllowLong'/")
inc("riga_incoerente_righe_attese", r"s/av=@(0,1); nr=2; fx='InpAllowShort'; mg='764101'/av=@(0,1); nr=3; fx='InpAllowShort'; mg='764101'/")
inc("riga_incoerente_input", r"s/np=42;/np=41;/")
inc("riga_incoerente_frazione", r"s/fz='1.0'; ax='InpAllowShort'; av=@(0,1); nr=2; fx='InpAllowLong'; mg='764100'/fz='0.40'; ax='InpAllowShort'; av=@(0,1); nr=2; fx='InpAllowLong'; mg='764100'/")
inc("riga_incoerente_simbolo", r"s/s='U30USD'; tf='H1'; p='LATI_A1_EMA200_U30USD_DISCESA_short.txt'/s='NASUSD'; tf='H1'; p='LATI_A1_EMA200_U30USD_DISCESA_short.txt'/")
inc("riga_incoerente_ordine_dei_job", r"s/'LATIA2L,LATIA2S,LATIA1L,LATIA1S'/'LATIA1L,LATIA2S,LATIA2L,LATIA1S'/")
inc("riga_incoerente_finestra_A1", r"s/d0='2025.02.01'; me='2025.04.30'; oa='2025.05.01'; d1='2025.04.30'; fz='1.0'; ax='InpAllowShort'/d0='2025.02.01'; me='2025.04.30'; oa='2025.05.02'; d1='2025.04.30'; fz='1.0'; ax='InpAllowShort'/")
inc("riga_incoerente_finestra_A2_fine", r"s/d0='2025.06.10'; me='2026.06.30'; oa='2026.07.01'; d1='2026.06.30'; fz='1.0'; ax='InpAllowLong'/d0='2025.06.10'; me='2026.06.30'; oa='2026.07.01'; d1='2026.06.29'; fz='1.0'; ax='InpAllowLong'/")
inc("riga_incoerente_tetto", r"s/\$TETTO=25;/$TETTO=40;/")
inc("riga_incoerente_margine", r"s/\$MARGINE=5;/$MARGINE=0;/")
inc("riga_incoerente_maxriprove", r"s/\$MAXRIP=1;/$MAXRIP=2;/")
inc("riga_incoerente_numeri_noti", r"s/nt=1; x='A2S/nt=0; x='A2S/")
inc("riga_incoerente_file_prova", r"s/p='LATI_A1_EMA200_U30USD_DISCESA_long.txt'/p='LATI_A1_EMA200_U30USD_DISCESA_short.txt'/")
add("riga_lato_pinnato_diverso_dal_file", {}, [ST("NV", "OK", "OK", "OK"), "(magic atteso 764102, lato pinnato InpAllowShort a true e rischio 1 attesi, asse InpAllowShort)"], ["LATIA2L OK"],
    sed=r"s/fx='InpAllowLong'; mg='764102'/fx='InpAllowShort'; mg='764102'/; s/-ne 'InpAllowLong,InpAllowShort,InpAllowLong,InpAllowShort'/-ne 'InpAllowShort,InpAllowShort,InpAllowLong,InpAllowShort'/", hide=True)
add("macchina_VPS", {}, ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: VMI3047753", NOSTUB], FERMA + ["GUARDIA EA"], pc="VMI3047753")
add("macchina_vuota", {}, ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ", NOSTUB], FERMA, pc="")
add("mt5_aperto", {}, ["MT5 risulta APERTO su questo PC", "Questo round gira ABTG_EMA200 (magic 764100, 764101, 764102 e 764103)", NOSTUB], FERMA + ["GUARDIA EA"], envx={"PRE_MT5": "1"})
add("terminale_assente", {}, ["TERMINALE: non trovo C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe", NOSTUB], FERMA, term="assente")
add("terminale_collegamento", {}, ["e un COLLEGAMENTO (junction o link)", NOSTUB], FERMA, term="link")
add("grafico_con_EA", {}, ["GUARDIA EA: grafici salvati letti 3, con un EA attaccato o illeggibili 1", "EA: " + EA, NOSTUB], FERMA, ch="ea")
add("grafico_illeggibile", {}, ["ILLEGGIBILE", "GUARDIA EA: nel profilo del terminale 50503392", NOSTUB], FERMA, ch="rotto")
add("zero_grafici", {}, ["GUARDIA EA: ho letto ZERO grafici salvati", NOSTUB], FERMA, ch="zero")
add("driver_mutato", {}, ["RIGA_ROUND_VPS_RETRY.ps1 scaricata con SHA256 DIVERSO", NOSTUB], FERMA, mut="drv")
add("driver_originale_col_nome_RETRY", {}, ["scaricata SENZA il marcatore RETRY_v1", NOSTUB], FERMA, mut="orig")
# classe 1051: ogni componente del confronto giornale/RIPROVE ha uno scenario in cui e' il SOLO a scattare
add("CE1_riprove_dichiara_riprova_che_il_giornale_non_ha", {A2S: {"legs": ["ko_ok", "ok"], "rp_fake_retry": "IS"}}, [ST("OK", "NV", "OK", "OK"), "NON TORNANO: giornale 2 intestazioni, 1 partite, 0 morte, 1 degeneri (attesa 1); RIPROVE 3 tentativi, 1 PARTITA, 1 MORTA_INIT"], ["LATIA2S OK"], hide=True)
add("CE2_finestra_IS_del_secondo_tentativo_sbagliata", {A1L: {"legs": ["ko_ok", "ok"], "retry_win_oos": True}}, [ST("OK", "OK", "NV", "OK"), "FINESTRA GIRATA DIVERSA DALLA DICHIARATA"], ["LATIA1L OK"], hide=True)
add("CE4_morte_senza_causa_ma_riprove_dice_INIT", {A1S: {"legs": ["ko_ok", "ok"], "dead_nocause": "IS"}}, [ST("OK", "OK", "OK", "NV"), "NON TORNANO: giornale 3 intestazioni, 1 partite, 0 morte, 1 degeneri (attesa 1); RIPROVE 3 tentativi, 1 PARTITA, 1 MORTA_INIT"], ["LATIA1S OK"], hide=True)
add("stima_tempi_console_uguale_riepilogo", {}, [OK4, "TEMPO: [STIMA] circa 7-11 minuti in tutto se nessuna gamba muore", "RIEP:dichiarato [STIMA] circa 7-11 minuti, circa 2,5 in piu per gamba riprovata, tetto 25",
    "Circa 2,5 minuti in piu per ogni gamba che muore e viene riprovata", "scadenza ", "(T0 + 25 - 5 minuti"], ["circa 1,5 in piu", "circa 80 s", "tetto 40", "10-34", "tetto 20 minuti"])

def run(nome, sc, sed, ch, pc, mut, term, envx):
    sf = os.path.join(OUT, "scen_%s.json" % nome)
    json.dump(sc, open(sf, "w"))
    env = dict(os.environ, HARNESS_OUT=OUT, RIGA_FILE=RIGA)
    env.update(envx)
    subprocess.run(["bash", os.path.join(QD, "run.sh"), nome, sf, sed, ch, PIN, pc, mut, term], env=env, capture_output=True)
    H = os.path.join(OUT, "run_%s" % nome)
    t = open(os.path.join(H, "out.txt"), encoding="utf-8", errors="replace").read()
    riep = ""
    dk = os.path.join(H, "user", "Desktop")
    if os.path.isdir(dk):
        for x in sorted(os.listdir(dk)):
            rf = os.path.join(dk, x, "RIEPILOGO_ROUND_LATI.txt")
            if x.startswith("ROUND_LATI_") and os.path.isfile(rf):
                riep += open(rf, encoding="ascii", errors="replace").read()
    t += "\n=== RIEPILOGO ===\n" + riep
    sl = os.path.join(H, "stub.log")
    stub = open(sl).read() if os.path.exists(sl) else ""
    # la console del driver dei job A1 va su file: si guarda anche che il file CI SIA (lo stub ci scrive la riga STUBNUM) e che non sia nella console
    return re.sub(r"\x1b\[[0-9;]*m", "", t), stub

def stubargs_ok(out, stub):
    m = re.search(r"data: (\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)", out)
    if not m:
        return "data della riga non trovata nell uscita"
    scad = (dt.datetime.strptime(m.group(1), "%Y-%m-%d %H:%M:%S") + dt.timedelta(minutes=20)).strftime("%Y-%m-%d %H:%M:%S")
    righe = [l for l in stub.splitlines() if l.startswith("STUB ")]
    if len(righe) != 4:
        return "lo stub doveva essere chiamato 4 volte, e invece %d" % len(righe)
    for l, lbl in zip(righe, (A2L, A2S, A1L, A1S)):
        att = ("-Expert | %s | -Prova | %s | -Etichetta | %s | -Pin | %s | -Modello | 4 | -Deposito | 100000 | -MaxRiprove | 1 | -AttesaRiprovaSec | 20 | -RiprovaEntro | %s"
               % (EA, PROVE[lbl], lbl, PIN, scad))
        if not l.rstrip().endswith(att) or "RIGA_ROUND_VPS_RETRY.ps1 | -Expert" not in l:
            return "argomenti del driver per %s diversi da: %s  --- ricevuti: %s" % (lbl, att, l)
    return ""

def check(item):
    (nome, sc, sed, ch, pc, mut, term, envx, deve, nondeve) = item
    out, stub = run(nome, sc, sed, ch, pc, mut, term, envx)
    riep = out.split("=== RIEPILOGO ===", 1)[1] if "=== RIEPILOGO ===" in out else ""
    cons = out.split("=== RIEPILOGO ===", 1)[0]
    mancano = []
    for x in deve:
        if x == NOSTUB:
            if stub != "":
                mancano.append("lo stub NON doveva essere stato chiamato, e invece: " + stub.strip()[:300])
        elif x == STUBARGS:
            e = stubargs_ok(out, stub)
            if e:
                mancano.append(e)
        elif x.startswith("RIEP:"):
            if x[5:] not in riep:
                mancano.append(x + "   (nel RIEPILOGO)")
        elif x.startswith("CONS2:"):
            if cons.count(x[6:]) < 2:
                mancano.append(x + "   (almeno 2 volte nella console)")
        elif x.startswith("CONS:"):
            if x[5:] not in cons:
                mancano.append(x + "   (nella console)")
        elif x not in out:
            mancano.append(x)
    troppo = [x for x in nondeve if x in out]
    return nome, mancano, troppo

def main():
    sel = sys.argv[3:] if len(sys.argv) > 3 else None
    items = [x for x in T if not sel or x[0] in sel]
    par = [x for x in items if "PRE_MT5" not in x[7]]; ser = [x for x in items if "PRE_MT5" in x[7]]
    with ThreadPoolExecutor(max_workers=int(os.environ.get("PAR", "6"))) as ex:
        res = list(ex.map(check, par))
    res += [check(x) for x in ser]
    ok = 0
    for nome, mancano, troppo in res:
        esito = not mancano and not troppo
        ok += 1 if esito else 0
        print(("PASS  " if esito else "FALLITO ") + nome)
        for x in mancano:
            print("      MANCA nell'uscita:", x)
        for x in troppo:
            print("      NON doveva esserci:", x)
    print("BATTERIA: %d/%d" % (ok, len(items)))
    sys.exit(0 if ok == len(items) else 1)

if __name__ == "__main__":
    main()
