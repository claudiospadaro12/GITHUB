#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- il collaudo a macchina di RIGA_ROUND_R280.txt (DUE job, driver con la riprova, cancello G0 + G1 con la tolleranza congelata il 03/10). Stessa forma di
collaudo_riga_EMAGEM2/battery.py (consegnata il 04/10), con il job e (R280e: ancora H4/220, due gemelle sul magic = il GATE) al posto di EMAGEM2a e il job a (R280a: filtro
H1, asse InpEmaSlow, 6 celle) al posto di EMAGEM2b e EMAGEM2c.
Il cancello con la tolleranza si collauda con LE STESSE ~30 prove al bordo del lettore indipendente (leggi_r280.py, Python/Decimal; qui la riga e' PowerShell/[decimal]):
le attese sono scritte A MANO in leggi_r280._casi_cancello (limiti derivati col conto dalla tolleranza congelata, non letti dal codice). In piu': in ogni scenario in cui il
cancello NON e' PASS i numeri di R280a NON devono comparire ne' in console ne' nel RIEPILOGO ne' nelle righe PERTRADE ne' nella console del driver (classi 1090 e 1092).

Fa girare la riga VERA sotto pwsh (Linux, PowerShell 7) con un driver FINTO (stub_driver.py) che scrive, per ciascun job, CSV IS/OOS nel formato di OptFrame (per e: la riga
VERA di R262b, scritta da MT5 il 27/09, duplicata come due gemelle col magic 798711/798721; per a: la stessa intestazione con sei righe sintetiche), un giornale del tester
UTF-16 con le righe VERE e UNA intestazione per tentativo, il file RIPROVE nelle righe di walkforward_generico_RETRY.ps1, il per-trade in Common\\Files (uno per magic) e il
REFERTO della riga RETRY; e che STAMPA IN CONSOLE il blocco "I NUMERI, COSI' COME SONO USCITI" come il driver vero (classe 1092: uno stub muto rende verde per costruzione ogni
test di assenza); `irm` servito da un magazzino locale (righe/RIGA_ROUND_VPS_RETRY.ps1 AL PIN, via git show); un disco C: finto.
Verifica che OK / OK_RIPROVATO / KO / MISTO / NV / NON LANCIATO scattino job per job quando devono e NON scattino quando non devono, che il CANCELLO G0 + G1 di e dica PASS solo
sui numeri veri e FAIL / NON VERIFICABILE altrimenti (con R280a "NON SI LEGGE"), e che i cancelli della riga reggano. Un'attesa che comincia con RIEP: si cerca SOLO nel RIEPILOGO
scritto nella raccolta, con CONS: SOLO nella console, con CONS2: almeno DUE volte nella console.
NON prova: Windows PowerShell 5.1, MT5, il tester, il tempo vero, la rete, GitHub raw, il driver vero.
Uso:  python3 backtest_pipeline/collaudo_riga_R280/battery.py [PIN] [RIGA] [nomi...]   (esce 0 se tutto come atteso). Serve: pwsh, python3, iconv, git.
"""
import json, os, re, subprocess, sys, datetime as dt
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
import leggi_r280 as LG
from concurrent.futures import ThreadPoolExecutor
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
OUT = os.environ.get("HARNESS_OUT", "/tmp/r280_harness")
os.makedirs(OUT, exist_ok=True)
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = sys.argv[2] if len(sys.argv) > 2 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_R280.txt")
PC = "DESKTOP-H4D7CAJ"
E, A = "R280e", "R280a"
EA = "ABTG_Nasdaq_Apertura_US"
def ST(e, a):
    return "STATO: R280e=%s R280a=%s" % (e, a)
OK2 = ST("OK", "OK")
FERMA = ["R280e OK", "R280e NV", "R280a NV", "RACCOLTA:", "STATO: R280e"]   # una riga fermata dai cancelli NON arriva agli stati ne alla raccolta
NOSTUB = "__NOSTUB__"            # lo stub NON deve essere stato chiamato
STUBARGS = "__STUBARGS__"        # lo stub deve aver ricevuto, per OGNI job, gli argomenti esatti (scadenza = T0 + 20 minuti, con lo spazio)
RPE = "ROUND_R280e\\RIPROVE_%s_U30USD_R280e.txt" % EA
RPA = "ROUND_R280a\\RIPROVE_%s_U30USD_R280a.txt" % EA
PTE1 = "abtg_trades_%s_U30USD_798711.csv" % EA
PTE2 = "abtg_trades_%s_U30USD_798721.csv" % EA
PTA = "abtg_trades_%s_U30USD_798701.csv" % EA
def CLOCK(lbl):
    return r"s/\$minAvv=\[int\](((Get-Date)-\$T0).TotalMinutes);/$minAvv=[int](((Get-Date)-$T0).TotalMinutes) + $(if($LBL -eq '%s'){45}else{0});/" % lbl
CAN = "CANCELLO G0 + G1 (R280e): "
PASSTXT = ("G0 PASS (IS 1249.94 / 1.25920 / 7.1736 / 157 e OOS 2974.09 / 1.48133 / 6.6241 / 199 riprodotti DENTRO LA TOLLERANZA su tutte e due le celle gemelle: Trades esatti, "
           "Profit entro 0,05 EUR, PF entro 0,00005, DD entro 0,01) e G1 PASS (le due celle gemelle uguali dentro la stessa tolleranza su Profit, PF, DD e Trades).")
# I NUMERI di R280a non devono comparire quando il cancello non e' PASS: ne' la tabella (console e RIEPILOGO), ne' le righe del per-trade, ne' la console del driver (STUBNUM)
NOA = ["R280a IS   InpEmaSlow", "R280a OOS  InpEmaSlow", "PERTRADE R280a ", "STUBNUM R280a"]
NSL = "NON SI LEGGE (cancello G0 + G1 %s)"
# un file CHE NON ESISTEVA e' stato letto? i valori sintetici dello stub per R280a (Profit 1264.00 della cella 1320, 1044.00 della 220) sono il segno che i numeri sono usciti
NUMA = ["1264.00", "1044.00"]
def patch2(col, val, fase="OOS"):
    return [{"fase": fase, "riga": 0, "col": col, "val": val}, {"fase": fase, "riga": 1, "col": col, "val": val}]
_hp = re.findall(r"hp='([0-9A-F]{64})'", open(RIGA, encoding="ascii").read())
assert len(_hp) == 2 and _hp[0] != _hp[1], _hp
_SED_HP_UGUALI = "s/hp='%s'/hp='%s'/" % (_hp[1], _hp[0])      # le due impronte di prova uguali: due job sullo stesso file
# (nome, scenario, sed, grafici, macchina, mutazione servita, terminale, env extra, [DEVE esserci], [NON deve esserci])
T = [
 ("ok", {}, "", "ok", PC, "", "ok", {},
  [OK2, STUBARGS, "pin numerici confrontati: _IS 188 _OOS 188 (attesi 188 per gamba, piu 2 stringhe NON confrontate e l asse)",
   "pin numerici confrontati: _IS 564 _OOS 564 (attesi 564 per gamba", "giornale: intestazioni 2 partite 2 morte 0   RIPROVE: IS: PARTITA, CSV PRODOTTO; OOS: PARTITA, CSV PRODOTTO;",
   "[from 2024.09.26 00:00 to 2025.06.30 00:00 su U30USD: = IS dichiarata] [from 2025.07.01 00:00 to 2026.06.30 00:00 su U30USD: = OOS dichiarata]",
   "terminale C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe" + ", deposito 10000, modello 4, driver walkforward_generico_RETRY.ps1, riprova [MaxRiprove 1   attesa 20 s   scadenza ",
   "GUARDIA EA: grafici salvati letti 2, con un EA attaccato o illeggibili 0", "asse InpMagic [798711/798721] ok", "asse InpEmaSlow [220/440/660/880/1100/1320] ok",
   "FILE ATTESI TROVATI: 15 su 15   NELLO ZIP: 15 su 15", "ZIP PRONTO DA MANDARE", "OK    " + RPE, "OK    " + RPA,
   "R280e OOS  InpMagic 798711  InpMagic 798711   Trades   199   Profit    2974.09   PF  1.48133   Equity DD % 6.6241",
   "R280e IS   InpMagic 798721  InpMagic 798721   Trades   157   Profit    1249.94   PF  1.25920   Equity DD % 7.1736",
   "R280a IS   InpEmaSlow   1320  InpMagic 798701   Trades   156   Profit    1264.00   PF  1.26600   Equity DD % 7.3960",
   "R280a OOS  InpEmaSlow    220  InpMagic 798701   Trades   196   Profit    1044.00   PF  1.21100   Equity DD % 7.0660",
   "CATENA COMPLETA: 2 cartelle del driver su 2 job lanciati",
   "motore = pin (SHA256, EA + include + walkforward_generico_RETRY + RIGA_ROUND_VPS_RETRY)", "NON ha svuotato Tester\\cache", "MARCATORE_RIGA_ROUND_R280_v1",
   "righe con magic diverso da 798711: 0", "righe con magic diverso da 798721: 0", "righe con magic diverso da 798701: 0",
   "ROUND LANCIATI: 2 su 2   NON LANCIATI (tetto): 0   PARTITI (rc diverso da 1): 2 su 2   MOTORE DIVERSO DAL PIN in 0 job", "=== RIEPILOGO ===",
   "direttive, input, asse, due lati, rischio e magic: = riga (97 input, asse InpMagic, due lati e rischio 1, nessuna @DEPOSITO)",
   "direttive, input, asse, due lati, rischio e magic: = riga (97 input, asse InpEmaSlow, due lati e rischio 1, nessuna @DEPOSITO)",
   CAN + "PASS   " + PASSTXT, "CONS2:" + CAN + "PASS   ", "RIEP:" + CAN + "PASS   " + PASSTXT,
   # classe 1092: la console del driver di R280a va su FILE e il file va nella raccolta; quella di R280e (la cella nota) resta a video
   "STUBNUM R280e", "CONS:La console del driver di R280a va nel file ", "OK    CONSOLE_DRIVER\\CONSOLE_DRIVER_R280a.txt"],
  ["MOTIVO: ", "MANCA ", "SHA256 DIVERSO", "DIVERSO DALLA RIGA", "DIVERSI dalla", "DIVERSO dall atteso", "DIVERSA dalla", "=NV", " NV   rc", "GAMBE SENZA CSV", "GAMBE RIPROVATE", "=OK_RIPROVATO",
   "MOTORE DIVERSO DAL PIN:", "NON SI LEGGE", "FAIL", "STUBNUM R280a"]),
 # ---- IL CANCELLO G0 + G1 CON LA TOLLERANZA. e gira la riga VERA di R262b duplicata; i casi al bordo sono QUELLI del lettore indipendente (stessa lista, attese scritte a mano)
 # (generati sotto, dopo la lista T: CASI_CANCELLO)
 # e non e' certificato dalla catena: il cancello NON gira (NON VERIFICABILE) e R280a non si legge
 ("G_e_asse_sbagliato_NV", {E: {"ax_vals": [798711, 798731]}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK"), CAN + "NON VERIFICABILE   R280e ha STATO NV", "-> R280a NON SI LEGGE (il cancello non ha potuto dire PASS)", "R280a: " + NSL % "NON VERIFICABILE",
   "RIEP:" + CAN + "NON VERIFICABILE", "asse InpMagic [798711/798731] DIVERSO dall atteso 798711/798721"], ["G0 PASS", "G0 FAIL", ": PASS"] + NOA + NUMA),
 ("G_e_due_gambe_morte_KO", {E: {"legs": ["ko_ko", "ko_ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("KO", "OK"), CAN + "NON VERIFICABILE   R280e ha STATO KO", "R280a: " + NSL % "NON VERIFICABILE"], ["G0 PASS", "G0 FAIL", ": PASS"] + NOA + NUMA),
 ("G_e_gamba_morta_MISTO", {E: {"legs": ["ko_ko", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("MISTO", "OK"), CAN + "NON VERIFICABILE   R280e ha STATO MISTO", "R280a: " + NSL % "NON VERIFICABILE"], ["G0 PASS", "G0 FAIL"] + NOA + NUMA),
 ("G_e_rc1_NV", {E: {"rc1": True}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK"), "rc 1: il driver si e fermato con un ERRORE", CAN + "NON VERIFICABILE   R280e ha STATO NV", "R280a: " + NSL % "NON VERIFICABILE"], ["G0 PASS", "G0 FAIL"] + NOA + NUMA),
 ("G_e_non_lanciato", {}, CLOCK(E), "ok", PC, "", "ok", {},
  [ST("NON LANCIATO", "OK"), CAN + "NON VERIFICABILE   R280e NON LANCIATO (tetto): il cancello non e stato eseguito", "R280a: " + NSL % "NON VERIFICABILE", "=== R280e: NON LANCIATO (tetto di 30 minuti"],
  ["G0 PASS", "G0 FAIL"] + NOA + NUMA),
 # OK_RIPROVATO e un RILIEVO, non un difetto: i numeri si leggono come OK, e il cancello gira
 ("G_e_riprovata_PASS", {E: {"legs": ["ko_ok", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK_RIPROVATO", "OK"), CAN + "PASS   " + PASSTXT, "giornale: intestazioni 3 partite 2 morte 1", "GAMBE RIPROVATE DAL DRIVER: 1 (R280e IS)"], ["NON SI LEGGE", "G0 FAIL", "G1 FAIL"]),
 # le pietre del cancello: se R280a ha un problema suo (NV), il cancello di e resta PASS e e si legge
 ("G_pass_ma_a_NV", {A: {"trades0": True}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV"), CAN + "PASS   " + PASSTXT, "NON BUONO: righe 6 (attese 6), Trades>0 su 5"], ["NON SI LEGGE", "R280e NV"]),
 # e: la riga VERA di R262b col pin dell asse non arrivato (due righe con lo stesso magic)
 ("e_csv_veri_pin_perso", {E: {"ax_vals": [798711, 798711]}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK"), "asse InpMagic [798711/798711] DIVERSO dall atteso 798711/798721", "il pin dell asse NON e arrivato"], ["R280e OK"]),
 # ---- gambe morte, riprove (portati da EMAGEM2 e DAXAP03)
 ("job_a_gamba_morta", {A: {"legs": ["ok", "ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "MISTO"), "R280a MISTO   rc 2", "giornale: intestazioni 2 partite 1 morte 1   RIPROVE: IS: PARTITA, CSV PRODOTTO; OOS: MORTA_INIT, CSV NON PRODOTTO;",
   "gamba OOS MORTA in OnTesterInit e non salvata dalla riprova", "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 1 (R280a 1 su 2", "NON e una replica", "RIPESCATE dalla cache",
   "FrameAdd r.2608 in OnTester r.2591", "ExportTrades r.2564 chiamata in OnTester r.2593", "i 7987xx sarebbero bruciati",
   "MANCA ROUND_R280a\\%s_U30USD_OOS_R280a.csv" % EA, "OK    " + RPA, "FILE ATTESI TROVATI: 14 su 15   NELLO ZIP: 14 su 15", CAN + "PASS"], ["R280e NV", "R280a OK", "GAMBE RIPROVATE", "ABTG_MaxMinNotte"]),
 ("job_a_gamba_riprovata_e_salvata", {A: {"legs": ["ko_ok", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK_RIPROVATO"), "R280a OK_RIPROVATO   rc 3", "giornale: intestazioni 3 partite 2 morte 1", "RIPROVE: IS: MORTA_INIT poi PARTITA RIPROVATA, CSV PRODOTTO;",
   "GAMBE RIPROVATE DAL DRIVER: 1 (R280a IS)", "RILIEVO, non un difetto: gamba IS", "FILE ATTESI TROVATI: 15 su 15   NELLO ZIP: 15 su 15", "asse InpEmaSlow [220/440/660/880/1100/1320] ok", CAN + "PASS"],
  ["R280a NV", "GAMBE SENZA CSV", "MANCA ", "NON SI LEGGE"]),
 ("job_e_due_gambe_riprovate_e_salvate", {E: {"legs": ["ko_ok", "ko_ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK_RIPROVATO", "OK"), "giornale: intestazioni 4 partite 2 morte 2", "GAMBE RIPROVATE DAL DRIVER: 2 (R280e IS,OOS)", "gamba IS e OOS morta in OnTesterInit", CAN + "PASS"], ["R280e NV", "GAMBE SENZA CSV", "NON SI LEGGE"]),
 ("job_a_gamba_morta_due_volte", {A: {"legs": ["ko_ko", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "MISTO"), "giornale: intestazioni 3 partite 1 morte 2", "RIPROVE: IS: MORTA_INIT poi MORTA_INIT RIPROVATA, CSV NON PRODOTTO;", "GAMBE RIPROVATE DAL DRIVER: 1 (R280a IS)",
   "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 1 (R280a 1 su 2"], ["R280a NV", "R280a OK"]),
 ("ko_quattro_tentativi_morti_su_a", {A: {"legs": ["ko_ko", "ko_ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "KO"), "R280a KO   rc 2", "giornale: intestazioni 4 partite 0 morte 4", "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 2 (R280a 2 su 2",
   "MANCA PERTRADE\\%s" % PTA, "OK    ROUND_R280a\\REFERTO_ROUND_R280a.txt", "OK    " + RPA, "FILE ATTESI TROVATI: 12 su 15"], ["R280a NV", "R280a OK"]),
 ("ko_ma_csv_fresco", {A: {"legs": ["ko", "ko"], "csv_anyway": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "il driver dice CSV NON PRODOTTO per IS e OOS ma esiste un CSV fresco"], ["R280a KO"]),
 ("misto_ma_csv_morto_fresco", {A: {"legs": ["ok", "ko"], "csv_anyway": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "il driver dice CSV NON PRODOTTO per la gamba OOS ma il suo CSV e fresco"], ["R280a MISTO"]),
 ("riprove_assente_con_gamba_riprovata", {A: {"legs": ["ko_ok", "ok"], "rp_absent": True}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV"), "file RIPROVE del driver ASSENTE: non so quante volte e stata lanciata ogni gamba (classe 1030)", "MANCA " + RPA], ["R280a OK"]),
 ("riprove_vecchio", {A: {"rp_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "file RIPROVE del driver VECCHIO (scritto prima del job)"], ["R280a OK"]),
 ("riprove_una_gamba", {A: {"rp_una_gamba": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "file RIPROVE del driver con 1 righe GAMBA"], ["R280a OK"]),
 ("riprove_incoerente", {A: {"legs": ["ko", "ok"], "rp_dice_prodotto": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "file RIPROVE INCOERENTE"], ["R280a MISTO"]),
 ("giornale_e_riprove_non_tornano", {A: {"extra_leg": True}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV"), "il giornale del tester e il file RIPROVE NON TORNANO: giornale 3 intestazioni, 3 partite, 0 morte; RIPROVE 2 tentativi, 2 PARTITA, 0 MORTA_INIT"], ["R280a OK"]),
 ("morta_con_altra_causa", {A: {"legs": ["altro", "ok"]}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "un tentativo con esito diverso da PARTITA o MORTA_INIT", "MORTA_ALTRO"], ["R280a MISTO", "R280a KO"]),
 ("rp_copia_mancante_in_raccolta", {A: {"rp_nocopy": True}}, "", "ok", PC, "", "ok", {}, [OK2, "MANCA " + RPA, "FILE ATTESI TROVATI: 14 su 15   NELLO ZIP: 14 su 15"], ["MANCA " + RPE]),
 ("trades_zero_in_una_cella_di_e", {E: {"trades0": True}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK"), "NON BUONO: righe 2 (attese 2), Trades>0 su 1", CAN + "NON VERIFICABILE   R280e ha STATO NV"], ["R280e OK"] + NOA + NUMA),
 ("una_riga_in_meno_su_a", {A: {"una_riga": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "righe 5 (attese 6)"], ["R280a OK"]),
 ("csv_0_byte", {A: {"csv_zero": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "contraddizione: il driver dice CSV PRODOTTO per IS e OOS ma i CSV non sono buoni (_IS 0 byte ; _OOS 0 byte)"], ["R280a OK"]),
 ("csv_vecchio", {A: {"csv_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "VECCHIO (scritto prima del job)"], ["R280a OK"]),
 ("oos_assente", {A: {"no_OOS": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "MANCA ROUND_R280a\\%s_U30USD_OOS_R280a.csv" % EA], ["R280a OK"]),
 ("asse_EmaSlow_sbagliato", {A: {"ax_vals": [220, 440, 660, 880, 1100, 1321]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV"), "[220/440/660/880/1100/1321] DIVERSO dall atteso 220/440/660/880/1100/1320"], ["R280a OK"]),
 ("asse_EmaSlow_ripetuto", {A: {"ax_vals": [220, 440, 660, 660, 1100, 1320]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV"), "[220/440/660/660/1100/1320] DIVERSO dall atteso 220/440/660/880/1100/1320"], ["R280a OK"]),
 # l asse non arrivato: MT5 gira sei volte la cella 220
 ("asse_EmaSlow_non_arrivato", {A: {"ax_vals": [220, 220, 220, 220, 220, 220]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV"), "[220/220/220/220/220/220] DIVERSO dall atteso 220/440/660/880/1100/1320", "il pin dell asse NON e arrivato"], ["R280a OK"]),
 ("pin_magic_perso_su_a", {A: {"pin_bad": "InpMagic"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "PIN DEL FILE PROVA NON ARRIVATI nel CSV: _IS 6 valori diversi InpMagic=[0] atteso 798701"], ["R280a OK"]),
 ("pin_lato_short_perso_su_a", {A: {"pin_bad": "InpAllowShort"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "InpAllowShort=[0] atteso 1"], ["R280a OK"]),
 ("pin_lato_long_perso_su_e", {E: {"pin_bad": "InpAllowLong"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "InpAllowLong=[0] atteso 1", CAN + "NON VERIFICABILE"], ["R280e OK"]),
 ("pin_rischio_perso_su_a", {A: {"pin_bad": "InpRiskPercent"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "InpRiskPercent=[0] atteso 1"], ["R280a OK"]),
 ("pin_FilterTF_H1_perso_su_a", {A: {"pin_over": {"InpFilterTF": "16388"}}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "InpFilterTF=[16388] atteso 16385"], ["R280a OK"]),
 ("pin_FilterTF_H4_perso_su_e", {E: {"pin_over": {"InpFilterTF": "16385"}}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "InpFilterTF=[16385] atteso 16388", CAN + "NON VERIFICABILE"], ["R280e OK"]),
 ("pin_EmaSlow_220_perso_su_e", {E: {"pin_over": {"InpEmaSlow": "880"}}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "InpEmaSlow=[880] atteso 220", CAN + "NON VERIFICABILE"], ["R280e OK"]),
 ("colonna_assente_su_a", {A: {"col_absent": "InpEmaFast"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "InpEmaFast=[] atteso 1"], ["R280a OK"]),
 ("finestra_oos_un_giorno_prima_su_a", {A: {"win_bad": True}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV"), "FINESTRA GIRATA DIVERSA DALLA DICHIARATA (classe 992)", "to 2026.06.29 00:00 su U30USD: DIVERSA dalla dichiarata"], ["R280a OK"]),
 ("corse_precedenti_stesso_giorno", {"prima": True}, "", "ok", PC, "", "ok", {}, [OK2, "(corse precedenti dello stesso giorno, non contano): 4"], ["=NV"]),
 ("giornale_assente", {"no_logs": True}, "", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "GIORNALE DEL TESTER: NON VERIFICABILE (file *Tester_logs* trovati 0, leggibili 0)", CAN + "NON VERIFICABILE"], ["R280e OK"] + NOA + NUMA),
 ("giornale_vuoto", {"tlog": "vuoto"}, "", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "giornale del tester NON VERIFICABILE"], ["R280e OK"] + NOA + NUMA),
 ("gamba_di_altro_EA", {A: {"ea_other": "ABTG_Nightly"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "porta il nome di un ALTRO EA"], ["R280a OK"]),
 # classi 166/892, DOPO OGNI JOB: la mutazione nel SOLO secondo job deve colpire il secondo e non il primo
 ("ea_mutato_nel_secondo_job", {A: {"mut_ea": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "%s.mq5 SHA256 DIVERSO DAL PIN" % EA, "MOTORE DIVERSO DAL PIN in 1 job"], ["R280a OK", "R280e NV"]),
 ("ea_assente_su_e", {E: {"no_ea": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "%s.mq5 ASSENTE" % EA], ["R280e OK"] + NOA + NUMA),
 ("include_mutato", {E: {"mut_inc": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "ABTG_PausaGuardian.mqh SHA256 DIVERSO DAL PIN"], ["R280e OK"] + NOA + NUMA),
 ("walkforward_retry_mutato", {A: {"mut_wf": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "walkforward_generico_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["R280a OK"]),
 ("walkforward_retry_assente", {E: {"no_wf": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "walkforward_generico_RETRY.ps1 ASSENTE"], ["R280e OK"] + NOA + NUMA),
 # classe 1028: l ORIGINALE (senza riprova) salvato col nome della copia porta i marcatori vecchi ma non lo SHA del pin
 ("walkforward_originale_col_nome_RETRY", {E: {"wf_originale": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "walkforward_generico_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["R280e OK"] + NOA + NUMA),
 ("riga_retry_locale_mutata_durante_il_secondo_job", {A: {"mut_drvloc": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "RIGA_ROUND_VPS_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["R280a OK", "R280e NV"]),
 # mutata durante il PRIMO job: la copia locale resta mutata, quindi il primo la vede e anche il secondo (non la riscarica nessuno): e voluto
 ("riga_retry_locale_mutata_durante_il_primo_job", {E: {"mut_drvloc": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "RIGA_ROUND_VPS_RETRY.ps1 SHA256 DIVERSO DAL PIN", "MOTORE DIVERSO DAL PIN in 2 job"], ["R280e OK", "R280a OK"] + NOA + NUMA),
 ("prova_mutata", {A: {"mut_prova": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "prova SHA256 DIVERSO DAL PIN"], ["R280a OK"]),
 ("prova_mutata_su_e", {E: {"mut_prova": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "prova SHA256 DIVERSO DAL PIN", CAN + "NON VERIFICABILE"], ["R280e OK"] + NOA + NUMA),
 # il referto del driver (classi 1019 e 1032)
 ("referto_assente", {E: {"ref_absent": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "REFERTO DEL DRIVER ASSENTE", "MANCA ROUND_R280e\\REFERTO_ROUND_R280e.txt"], ["R280e OK"]),
 ("referto_vecchio_sul_desktop", {E: {"ref_absent": True}}, "", "ok", PC, "", "ok", {"PRE_OLD": E}, [ST("NV", "OK"), "tolta la cartella di una corsa PRECEDENTE: ROUND_R280e", "REFERTO DEL DRIVER ASSENTE"], ["R280e OK"]),
 ("referto_non_riscritto", {A: {"ref_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "REFERTO DEL DRIVER VECCHIO (scritto prima del job: NON e di questa corsa)"], ["R280a OK"]),
 ("referto_terminale_banco_VPS", {E: {"ref_term": "C:\\MT5_Backtest\\terminal64.exe"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "terminale C:\\MT5_Backtest\\terminal64.exe", "DIVERSO DALLA RIGA"], ["R280e OK"]),
 ("referto_macchina_diversa", {E: {"ref_mac": "VMI3047753"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "macchina VMI3047753, terminale", "DIVERSO DALLA RIGA"], ["R280e OK"]),
 ("referto_driver_originale", {E: {"ref_driver": "walkforward_generico.ps1"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "driver walkforward_generico.ps1, riprova", "DIVERSO DALLA RIGA (attesi deposito 10000"], ["R280e OK"]),
 # la cartella vecchia che NON si lascia togliere: la riga si ferma PRIMA di aprire MT5 (classe 1032)
 ("cartella_vecchia_non_rimovibile", {}, "", "ok", PC, "", "ok", {"PRE_OLD": A, "NO_RM": A}, ["NON riesco a togliere la cartella di una corsa PRECEDENTE", "ROUND_R280a", NOSTUB], FERMA + ["tolta la cartella"]),
 # lo zip che perde una voce: la cartella e completa, il pacco no (classi 1021/1033)
 ("zip_senza_un_file", {}, "", "ok", PC, "", "ok", {"ZIP_DROP": "RIPROVE_%s_U30USD_R280a" % EA}, [OK2, "FILE ATTESI TROVATI: 15 su 15   NELLO ZIP: 14 su 15", "nello zip: NO"], ["NELLO ZIP: 15 su 15"]),
 ("zip_vecchio", {}, "", "ok", PC, "", "ok", {"ZIP_STALE": "1"}, [OK2, "ZIP VECCHIO (scritto prima di questa raccolta, NON e di questa corsa)", "FILE ATTESI TROVATI: 15 su 15   NELLO ZIP: 0 su 15"], ["ZIP PRONTO DA MANDARE"]),
 ("CE11_zip_senza_riepilogo", {}, "", "ok", PC, "", "ok", {"ZIP_DROP": "RIEPILOGO_ROUND_R280"}, [OK2, "NELLO ZIP: 14 su 15"], ["NELLO ZIP: 15 su 15"]),
 # magic del file prova contro la riga (difesa in profondita': il file e' gia' pinnato per SHA). Per raggiungerla si cambiano INSIEME la tabella dei job e il suo controllo di coerenza:
 # il file scaricato dice 798701, la riga dice 798702.
 ("riga_magic_diverso_dal_file", {}, r"s/mg='798701';/mg='798702';/; s/\$jobs\[1\].mg -ne '798701'/$jobs[1].mg -ne '798702'/", "ok", PC, "", "ok", {},
  [ST("OK", "NV"), "(magic atteso 798702, due lati e rischio 1 attesi)"], ["R280a OK"]),
 # gli argomenti passati al driver (classe 1019): li dice il referto, non la riga
 ("deposito_100000_passato", {}, r"s/-Deposito \$jb.dp /-Deposito 100000 /g", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "deposito 100000, modello 4", "DIVERSO DALLA RIGA (attesi deposito 10000", CAN + "NON VERIFICABILE"], ["R280e OK"]),
 # classe 1101: lo scenario e' preso dalla SOLA clausola del referto: lo stub fa uscire i file col nome di Modello 4 anche con -Modello 1 (no_ohlc_sfx), cosi il job non e' NV per i CSV _ohlc non trovati
 ("modello_1_passato", {E: {"no_ohlc_sfx": True}, A: {"no_ohlc_sfx": True}}, r"s/-Modello \$jb.m /-Modello 1 /g", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "modello 1, driver"], ["R280e OK"]),
 ("pin_diverso_passato", {}, r"s/-Pin \$PIN /-Pin lavoro /g", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "referto: pin lavoro,"], ["R280e OK"]),
 ("maxriprove_0_passato", {}, r"s/-MaxRiprove \$MAXRIP /-MaxRiprove 0 /g", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "riprova [MaxRiprove 0   attesa 20 s"], ["R280e OK"]),
 ("scadenza_non_passata", {}, r"s/ -RiprovaEntro \$scadTxt\( }\| 1>\)/\1/g", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "scadenza nessuna] DIVERSO DALLA RIGA"], ["R280e OK"]),
 # il tetto fra i job: orologio spostato di 45 minuti per UN solo job (modifica di banco, non della riga vera)
 ("tetto_secondo_job_non_lanciato", {}, CLOCK(A), "ok", PC, "", "ok", {},
  [ST("OK", "NON LANCIATO"), "=== R280a: NON LANCIATO (tetto di 30 minuti", "FILE ATTESI TROVATI: 8 su 8   NELLO ZIP: 8 su 8", "ROUND LANCIATI: 1 su 2   NON LANCIATI (tetto): 1", CAN + "PASS"], ["R280a OK", "R280a NV"]),
 # il per-trade e INFORMATIVO (classe 455): non cambia lo stato, ma si dice cosa e (e ne ha DUE, uno per magic)
 ("pertrade_vecchio_su_e", {E: {"pertrade_stale": True}}, "", "ok", PC, "", "ok", {},
  [OK2, "PERTRADE R280e %s: assente in Common\\Files o scritto prima del job" % PTE1, "PERTRADE R280e %s: assente in Common\\Files o scritto prima del job" % PTE2,
   "MANCA PERTRADE\\%s" % PTE1, "MANCA PERTRADE\\%s" % PTE2, "FILE ATTESI TROVATI: 13 su 15"], ["=NV"]),
 ("pertrade_solo_IS_su_a", {A: {"pertrade_ct": ["2024.10.01 08:10:00", "2025.06.30 08:40:00"]}}, "", "ok", PC, "", "ok", {}, [OK2, "2 deal di uscita, gamba IS (ultima chiusura 2025.06.30 08:40:00)"], ["=NV"]),
 ("pertrade_magic_estraneo_su_e", {E: {"pertrade_mg": "798701"}}, "", "ok", PC, "", "ok", {}, [OK2, "righe con magic diverso da 798711: 3", "righe con magic diverso da 798721: 3"], ["=NV"]),
 # i cancelli PRIMA del job: la riga si ferma, lo stub NON viene chiamato
 ("riga_incoerente_deposito", {}, r"s/dp=10000;/dp=100000;/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_asse_e", {}, r"s/av=@(798711,798721)/av=@(798711,798731)/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_asse_EmaSlow_di_a", {}, r"s/av=@(220,440,660,880,1100,1320); nr=6;/av=@(220,440,660,880,1100,1321); nr=6;/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_magic", {}, r"s/mg='798701';/mg='798702';/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_magic_di_e_pinnato", {}, r"s/mg=''; pm=/mg='798711'; pm=/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_input", {}, r"s/np=97;/np=96;/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_frazione", {}, r"s/fz='0.4322';/fz='0.50';/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_fine_IS", {}, r"s/me='2025.06.30';/me='2025.06.09';/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_simbolo", {}, r"s/s='U30USD'/s='SPXUSD'/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_TF_grafico", {}, r"s/tf='M5'/tf='H1'/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_ordine_dei_job", {}, r"s/'R280e,R280a'/'R280a,R280e'/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_tetto", {}, r"s/\$TETTO=30;/$TETTO=45;/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_margine", {}, r"s/\$MARGINE=10;/$MARGINE=0;/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_maxriprove", {}, r"s/\$MAXRIP=1;/$MAXRIP=2;/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),

 ("riga_incoerente_EA", {}, r"s/e='ABTG_Nasdaq_Apertura_US'; s='U30USD'/e='ABTG_Londra_ORB'; s='U30USD'/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_sigle", {}, r"s/k='e';/k='x';/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_inizio_OOS", {}, r"s/oa='2025.07.01';/oa='2025.07.02';/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_d0", {}, r"s/d0='2024.09.26';/d0='2024.09.25';/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_d1", {}, r"s/d1='2026.06.30';/d1='2026.06.29';/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_modello", {}, r"s/m=4;/m=1;/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_righe_attese", {}, r"s/nr=2;/nr=3;/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_asse_nome", {}, r"s/ax='InpMagic'/ax='InpMagik'/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_pm_di_e", {}, r"s/pm=@('798711','798721')/pm=@('798711','798722')/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_pm_di_a", {}, r"s/pm=@('798701')/pm=@('798702')/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_impronta_prova_corta", {}, r"s/hp='\([0-9A-F]\{60\}\)[0-9A-F]\{4\}';/hp='\1';/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_impronte_prova_uguali", {}, _SED_HP_UGUALI, "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_impronta_EA_corta", {}, r"s/\$shaEa='\([0-9A-F]\{60\}\)[0-9A-F]\{4\}';/$shaEa='\1';/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_impronta_include_corta", {}, r"s/\$shaInc='\([0-9A-F]\{60\}\)[0-9A-F]\{4\}';/$shaInc='\1';/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_impronta_walkforward_corta", {}, r"s/\$shaWf='\([0-9A-F]\{60\}\)[0-9A-F]\{4\}';/$shaWf='\1';/", "ok", PC, "", "ok", {}, ["RIGA R280 INCOERENTE", NOSTUB], FERMA),
 ("macchina_VPS", {}, "", "ok", "VMI3047753", "", "ok", {}, ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: VMI3047753", NOSTUB], FERMA + ["GUARDIA EA"]),
 ("macchina_vuota", {}, "", "ok", "", "", "ok", {}, ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ", NOSTUB], FERMA),
 ("mt5_aperto", {}, "", "ok", PC, "", "ok", {"PRE_MT5": "1"}, ["MT5 risulta APERTO su questo PC", "Questo round gira ABTG_Nasdaq_Apertura_US", NOSTUB], FERMA + ["GUARDIA EA"]),
 ("terminale_assente", {}, "", "ok", PC, "", "assente", {}, ["TERMINALE: non trovo C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe", NOSTUB], FERMA),
 ("terminale_collegamento", {}, "", "ok", PC, "", "link", {}, ["e un COLLEGAMENTO (junction o link)", NOSTUB], FERMA),
 ("grafico_con_EA", {}, "", "ea", PC, "", "ok", {}, ["GUARDIA EA: grafici salvati letti 3, con un EA attaccato o illeggibili 1", "EA: " + EA, NOSTUB], FERMA),
 ("grafico_illeggibile", {}, "", "rotto", PC, "", "ok", {}, ["ILLEGGIBILE", "GUARDIA EA: nel profilo del terminale 50503392", NOSTUB], FERMA),
 ("zero_grafici", {}, "", "zero", PC, "", "ok", {}, ["GUARDIA EA: ho letto ZERO grafici salvati", NOSTUB], FERMA),
 ("driver_mutato", {}, "", "ok", PC, "drv", "ok", {}, ["RIGA_ROUND_VPS_RETRY.ps1 scaricata con SHA256 DIVERSO", NOSTUB], FERMA),
 ("driver_originale_col_nome_RETRY", {}, "", "ok", PC, "orig", "ok", {}, ["scaricata SENZA il marcatore RETRY_v1", NOSTUB], FERMA),
 # --- classe 1051: ogni componente del confronto giornale/RIPROVE e della coerenza del RIPROVE ha uno scenario in cui e' il SOLO a scattare
 ("CE1_riprove_dichiara_riprova_che_il_giornale_non_ha", {A: {"legs": ["ko_ok", "ok"], "rp_fake_retry": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "NON TORNANO: giornale 2 intestazioni, 2 partite, 0 morte"], ["R280a OK"]),
 ("CE2_riprova_OOS_gira_la_finestra_IS", {A: {"legs": ["ok", "ko_ok"], "retry_win_is": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "FINESTRA GIRATA DIVERSA DALLA DICHIARATA"], ["R280a OK"]),
 ("CE3_csv_di_un_altra_cella", {A: {"pin_over": {"InpMagic": "798711"}}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "InpMagic=[798711] atteso 798701"], ["R280a OK"]),
 ("CE3b_csv_altra_cella_un_lato_solo", {A: {"pin_over": {"InpAllowShort": "0"}}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "InpAllowShort=[0] atteso 1"], ["R280a OK"]),
 ("CE4_morte_senza_causa_ma_riprove_dice_INIT", {A: {"legs": ["ko_ok", "ok"], "dead_nocause": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "NON TORNANO: giornale 3 intestazioni, 2 partite, 0 morte"], ["R280a OK"]),
 ("CE8_una_salvata_una_morta_due_volte", {A: {"legs": ["ko_ok", "ko_ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "MISTO"), "GAMBE RIPROVATE DAL DRIVER: 2 (R280a IS,OOS)", "giornale: intestazioni 4 partite 1 morte 3"], ["R280a OK", "R280a NV"]),
 ("CE10_riprove_senza_flag_RIPROVATA", {A: {"legs": ["ko_ok", "ok"], "rp_no_rip": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "file RIPROVE INCOERENTE"], ["R280a OK"]),
 ("CE12_tutti_i_job_riprovati", {E: {"legs": ["ok", "ko_ok"]}, A: {"legs": ["ko_ok", "ko_ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK_RIPROVATO", "OK_RIPROVATO"), "GAMBE RIPROVATE DAL DRIVER: 3 (R280e OOS, R280a IS,OOS)", "FILE ATTESI TROVATI: 15 su 15", CAN + "PASS"], ["=NV", "GAMBE SENZA CSV", "NON SI LEGGE"]),
 # la stima dei tempi: console e RIEPILOGO dicono lo STESSO numero (classe 1050)
 ("stima_tempi_console_uguale_riepilogo", {}, "", "ok", PC, "", "ok", {},
  [OK2, "TEMPO: [STIMA] circa 5-8 minuti in tutto se nessuna gamba muore", "RIEP:dichiarato [STIMA] circa 5-8 minuti, circa 2,5 in piu per gamba riprovata, tetto 30",
   "Circa 2,5 minuti in piu per ogni gamba che muore e viene riprovata", "scadenza ", "(T0 + 30 - 10 minuti"], ["circa 1,5 in piu", "circa 80 s", "3-5 minuti", "8-34", "tetto 20", "10-34", "tetto 40"]),
]

def _scen_patch(a_patch):
    return {E: {"patch": [{"fase": f, "riga": r, "col": c, "val": v} for (f, r, c), v in sorted(a_patch.items())]}}
CASI_CANCELLO = []
for _i, (_nome, _patch, _att) in enumerate(LG._casi_cancello()):
    _n = "CAN%02d_%s" % (_i, re.sub(r"[^A-Za-z0-9]+", "_", _nome)[:60].strip("_"))
    if _att == "PASS":
        _deve = [OK2, CAN + "PASS   " + PASSTXT, "CONS2:" + CAN + "PASS   ", "RIEP:" + CAN + "PASS   " + PASSTXT, "R280a OOS  InpEmaSlow   1320  InpMagic 798701", "R280a IS   InpEmaSlow    220  InpMagic 798701",
                 "PERTRADE R280a " + PTA, "RESIDUI DENTRO LA TOLLERANZA"]
        _non = ["NON SI LEGGE", "G0 FAIL", "G1 FAIL", "=NV", "ROUND NULLO"]
    else:
        # il testo del FAIL e' "G0 <PASS|FAIL (...)> / G1 <PASS|FAIL (...)> -> ROUND NULLO": le attese si scrivono su QUELLA forma (la frase "cancello G0 + G1 FAIL" della riga NON SI LEGGE non e' un esito di G1)
        if _att == "G1":
            _dg, _ng = ["G0 PASS / G1 FAIL ("], ["G0 FAIL ("]
        elif _att == "G0":
            _dg, _ng = ["G0 FAIL (", " / G1 PASS -> ROUND NULLO"], [" / G1 FAIL ("]
        else:
            _dg, _ng = ["G0 FAIL (", " / G1 FAIL ("], ["G0 PASS /", " / G1 PASS"]
        _deve = [OK2, CAN + "FAIL"] + _dg + ["-> ROUND NULLO (V4) per R280e e R280a secondo i file prova: R280a NON SI LEGGE", "CONS:   R280a: " + NSL % "FAIL", "RIEP:   R280a: " + NSL % "FAIL"]
        _non = ["G0 PASS (IS"] + NOA + NUMA + _ng
    if _i == 1:      # il precedente R246: un centesimo su UNA gemella; i due residui si ELENCANO, in console e nel RIEPILOGO (scarto = differenza esatta, in decimale)
        _res = "RESIDUI DENTRO LA TOLLERANZA (2, si scrivono, nessun giudizio): OOS magic 798721 Profit [2974.10] contro noto [2974.09] (scarto 0.01) ; OOS gemelle Profit [2974.09] contro [2974.10] (scarto 0.01)"
        _deve += ["CONS:" + _res, "RIEP:" + _res]
    if _nome.startswith("Recovery Factor +0,01"):    # il RF non ha tolleranza congelata: si ELENCA lo scarto e non blocca
        _res = "RESIDUI DENTRO LA TOLLERANZA (1, si scrivono, nessun giudizio): OOS magic 798721 Recovery Factor [4.43850] contro noto [4.42850] (scarto 0.01000; colonna senza tolleranza congelata, NON blocca)"
        _deve += ["CONS:" + _res, "RIEP:" + _res]
    CASI_CANCELLO.append((_n, _scen_patch(_patch), "", "ok", PC, "", "ok", {}, _deve, _non))
T += CASI_CANCELLO

def run(nome, sc, sed, ch, pc, mut, term, envx):
    sf = os.path.join(OUT, "scen_%s.json" % nome)
    json.dump(sc, open(sf, "w"))
    env = dict(os.environ, HARNESS_OUT=OUT, RIGA_FILE=RIGA)
    env.update(envx)
    subprocess.run(["bash", os.path.join(QD, "run.sh"), nome, sf, sed, ch, PIN, pc, mut, term], env=env, capture_output=True)
    H = os.path.join(OUT, "run_%s" % nome)
    t = open(os.path.join(H, "out.txt"), encoding="utf-8", errors="replace").read()
    # il RIEPILOGO scritto nella raccolta e' parte dell'uscita da collaudare (le righe che non vanno a schermo stanno solo li')
    riep = ""
    dk = os.path.join(H, "user", "Desktop")
    if os.path.isdir(dk):
        for x in sorted(os.listdir(dk)):
            rf = os.path.join(dk, x, "RIEPILOGO_ROUND_R280.txt")
            if x.startswith("ROUND_R280_") and os.path.isfile(rf):
                riep += open(rf, encoding="ascii", errors="replace").read()
    t += "\n=== RIEPILOGO ===\n" + riep
    sl = os.path.join(H, "stub.log")
    stub = open(sl).read() if os.path.exists(sl) else ""
    return re.sub(r"\x1b\[[0-9;]*m", "", t), stub

def stubargs_ok(out, stub):
    m = re.search(r"data: (\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)", out)
    if not m:
        return "data della riga non trovata nell uscita"
    scad = (dt.datetime.strptime(m.group(1), "%Y-%m-%d %H:%M:%S") + dt.timedelta(minutes=20)).strftime("%Y-%m-%d %H:%M:%S")
    righe = [l for l in stub.splitlines() if l.startswith("STUB ")]
    if len(righe) != 2:
        return "lo stub doveva essere chiamato 2 volte, e invece %d" % len(righe)
    for l, (lbl, prv) in zip(righe, ((E, "R280e_ancora_g1_candidato_dow_U30USD.txt"), (A, "R280a_filtrotf_h1_memoria_candidato_dow_U30USD.txt"))):
        att = ("-Expert | %s | -Prova | %s | -Etichetta | %s | -Pin | %s | -Modello | 4 | -Deposito | 10000 | -MaxRiprove | 1 | -AttesaRiprovaSec | 20 | -RiprovaEntro | %s"
               % (EA, prv, lbl, PIN, scad))
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
    # gli scenari con un processo terminal64 finto (PRE_MT5) vanno DA SOLI: Get-Process e' globale e fermerebbe le corse parallele
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
