#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- il collaudo a macchina di RIGA_ROUND_EMAGEM2.txt (TRE job, driver con la riprova, cancello incrociato T1 + G1 con la TOLLERANZA DI BANCO). Stessa forma di
collaudo_riga_EMAGEM/battery.py (round del 03/10) e di collaudo_riga_DAXAP03/battery.py.
Il cancello con la tolleranza si collauda con LE STESSE ~40 prove al bordo del lettore indipendente (leggi_emagem2.py, Python/Decimal; qui la riga e' PowerShell/[decimal]):
le attese sono scritte A MANO in leggi_emagem2._casi_cancello (limiti derivati col conto, non letti dal codice). In piu': in ogni scenario in cui il cancello NON e' PASS i numeri
di b e c NON devono comparire ne' in console ne' nel RIEPILOGO ne' nelle righe PERTRADE (classe 1090: la riga del 03/10 li stampava anche col cancello rosso).

Fa girare la riga VERA sotto pwsh (Linux, PowerShell 7) con un driver FINTO (stub_driver.py) che scrive, per ciascun job, CSV IS/OOS nel formato
di OptFrame (per a: i CSV VERI di R110, scritti da MT5 il 26/08, col solo magic portato a 766901/766902), un giornale del tester UTF-16 con le
righe VERE e UNA intestazione per tentativo, il file RIPROVE nelle righe di walkforward_generico_RETRY.ps1, il per-trade in Common\\Files (uno per
magic) e il REFERTO della riga RETRY (pin/macchina/terminale/deposito/modello/driver/riprova); `irm` servito da un magazzino locale
(righe/RIGA_ROUND_VPS_RETRY.ps1 AL PIN, via git show); un disco C: finto.
Verifica che OK / OK_RIPROVATO / KO / MISTO / NV / NON LANCIATO scattino job per job quando devono e NON scattino quando non devono, che il
CANCELLO INCROCIATO T1 + G1 di a dica PASS solo sui numeri veri e FAIL / NON VERIFICABILE altrimenti (con b e c "NON SI LEGGE"), e che i cancelli
della riga reggano. Un'attesa che comincia con RIEP: si cerca SOLO nel RIEPILOGO scritto nella raccolta, con CONS: SOLO nella console, con CONS2: almeno DUE volte nella console.
NON prova: Windows PowerShell 5.1, MT5, il tester, il tempo vero, la rete, GitHub raw, il driver vero.
Uso:  python3 backtest_pipeline/collaudo_riga_EMAGEM2/battery.py [PIN] [RIGA] [nomi...]   (esce 0 se tutto come atteso). Serve: pwsh, python3, iconv, git.
"""
import json, os, re, subprocess, sys, datetime as dt
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
import leggi_emagem2 as LG
from concurrent.futures import ThreadPoolExecutor
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
OUT = os.environ.get("HARNESS_OUT", "/tmp/emagem2_harness")
os.makedirs(OUT, exist_ok=True)
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = sys.argv[2] if len(sys.argv) > 2 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_EMAGEM2.txt")
PC = "DESKTOP-H4D7CAJ"
A, B, C = "EMAGEM2a", "EMAGEM2b", "EMAGEM2c"
EA = "ABTG_EMA200"
def ST(a, b, c):
    return "STATO: EMAGEM2a=%s EMAGEM2b=%s EMAGEM2c=%s" % (a, b, c)
OK3 = ST("OK", "OK", "OK")
FERMA = ["EMAGEM2a OK", "EMAGEM2a NV", "EMAGEM2b NV", "RACCOLTA:", "STATO: EMAGEM2a"]   # una riga fermata dai cancelli NON arriva agli stati ne alla raccolta
NOSTUB = "__NOSTUB__"            # lo stub NON deve essere stato chiamato
STUBARGS = "__STUBARGS__"        # lo stub deve aver ricevuto, per OGNI job, gli argomenti esatti (scadenza = T0 + 30 minuti, con lo spazio)
RPA = "ROUND_EMAGEM2a\\RIPROVE_%s_U30USD_EMAGEM2a.txt" % EA
RPB = "ROUND_EMAGEM2b\\RIPROVE_%s_D30EUR_EMAGEM2b.txt" % EA
RPC = "ROUND_EMAGEM2c\\RIPROVE_%s_NASUSD_EMAGEM2c.txt" % EA
def CLOCK(lbl):
    return r"s/\$minAvv=\[int\](((Get-Date)-\$T0).TotalMinutes);/$minAvv=[int](((Get-Date)-$T0).TotalMinutes) + $(if($LBL -eq '%s'){45}else{0});/" % lbl
CAN = "CANCELLO INCROCIATO (T1 + G1 di EMAGEM2a): "
PASSTXT = "T1 PASS (IS 4585.40 / 1.20110 / 5.7325 / 237 e OOS 23321.47 / 1.52365 / 7.8323 / 517 riprodotti DENTRO LA TOLLERANZA DI BANCO su tutte e due le celle gemelle: Trades e DD esatti, Profit entro 1,00 EUR, PF entro 0,0002) e G1 PASS (le due celle gemelle uguali dentro la tolleranza su Profit, Expected Payoff, PF, Recovery Factor, Sharpe, DD e Trades)."
# I NUMERI di b e c non devono comparire quando il cancello non e' PASS: ne' la tabella (console e RIEPILOGO) ne' le righe del per-trade
NOBC = ["EMAGEM2b IS   InpTF", "EMAGEM2b OOS  InpTF", "EMAGEM2c IS   InpTF", "EMAGEM2c OOS  InpTF", "PERTRADE EMAGEM2b ", "PERTRADE EMAGEM2c "]
NSL = "NON SI LEGGE (cancello incrociato %s)"
def FAIL3(extra):
    """a e' girato bene (STATO OK per i tre), il cancello da FAIL, b e c NON SI LEGGONO."""
    return [OK3, CAN + "FAIL", "-> ROUND NULLO per a, b e c secondo i file prova: b e c NON SI LEGGONO", "CONS:   EMAGEM2b: " + NSL % "FAIL", "CONS:   EMAGEM2c: " + NSL % "FAIL",
            "RIEP:   EMAGEM2b: " + NSL % "FAIL", "RIEP:   EMAGEM2c: " + NSL % "FAIL", "CONS2:" + CAN + "FAIL", "RIEP:" + CAN + "FAIL", "i numeri NON si stampano, restano nei CSV della raccolta"] + extra
NOPASS = ["T1 PASS (IS", "EMAGEM2a: NON SI LEGGE"] + NOBC
def patch2(col, val, fase="OOS"):
    return [{"fase": fase, "riga": 0, "col": col, "val": val}, {"fase": fase, "riga": 1, "col": col, "val": val}]
# (nome, scenario, sed, grafici, macchina, mutazione servita, terminale, env extra, [DEVE esserci], [NON deve esserci])
T = [
 ("ok", {}, "", "ok", PC, "", "ok", {},
  [OK3, STUBARGS, "pin numerici confrontati: _IS 78 _OOS 78 (attesi 78 per gamba, piu 2 stringhe NON confrontate e l asse)",
   "pin numerici confrontati: _IS 195 _OOS 195 (attesi 195 per gamba", "giornale: intestazioni 2 partite 2 morte 0   RIPROVE: IS: PARTITA, CSV PRODOTTO; OOS: PARTITA, CSV PRODOTTO;",
   "[from 2024.09.26 00:00 to 2025.06.09 00:00 su U30USD: = IS dichiarata] [from 2025.06.10 00:00 to 2026.06.30 00:00 su U30USD: = OOS dichiarata]",
   "[from 2024.09.26 00:00 to 2025.06.09 00:00 su D30EUR: = IS dichiarata]", "[from 2025.06.10 00:00 to 2026.06.30 00:00 su NASUSD: = OOS dichiarata]",
   "terminale C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe" + ", deposito 100000, modello 4, driver walkforward_generico_RETRY.ps1, riprova [MaxRiprove 1   attesa 20 s   scadenza ",
   "GUARDIA EA: grafici salvati letti 2, con un EA attaccato o illeggibili 0", "asse InpMagic [766901/766902] ok", "asse InpTF [30/16385/16386/16387/16388] ok",
   "FILE ATTESI TROVATI: 20 su 20   NELLO ZIP: 20 su 20", "ZIP PRONTO DA MANDARE", "OK    " + RPA, "OK    " + RPB, "OK    " + RPC,
   "EMAGEM2a OOS  InpMagic 766901  InpMagic 766901   Trades   517   Profit   23321.47   PF  1.52365   Equity DD % 7.8323",
   "EMAGEM2a IS   InpMagic 766902  InpMagic 766902   Trades   237   Profit    4585.40   PF  1.20110   Equity DD % 5.7325",
   "EMAGEM2b OOS  InpTF  16388  InpMagic 766911", "EMAGEM2c IS   InpTF     30  InpMagic 766921", "CATENA COMPLETA: 3 cartelle del driver su 3 job lanciati",
   "motore = pin (SHA256, EA + include + walkforward_generico_RETRY + RIGA_ROUND_VPS_RETRY)", "NON ha svuotato Tester\\cache", "MARCATORE_RIGA_ROUND_EMAGEM2_v1",
   "righe con magic diverso da 766901: 0", "righe con magic diverso da 766902: 0", "righe con magic diverso da 766911: 0", "righe con magic diverso da 766921: 0",
   "ROUND LANCIATI: 3 su 3   NON LANCIATI (tetto): 0   PARTITI (rc diverso da 1): 3 su 3   MOTORE DIVERSO DAL PIN in 0 job", "=== RIEPILOGO ===",
   "direttive, input, asse, due lati, rischio e magic: = riga (42 input, asse InpMagic, due lati e rischio 1, nessuna @DEPOSITO)",
   "direttive, input, asse, due lati, rischio e magic: = riga (42 input, asse InpTF, due lati e rischio 1, nessuna @DEPOSITO)",
   CAN + "PASS   " + PASSTXT, "CONS2:" + CAN + "PASS   ", "RIEP:" + CAN + "PASS   " + PASSTXT],
  ["MOTIVO: ", "MANCA ", "SHA256 DIVERSO", "DIVERSO DALLA RIGA", "DIVERSI dalla", "DIVERSO dall atteso", "DIVERSA dalla", "=NV", " NV   rc", "GAMBE SENZA CSV", "GAMBE RIPROVATE", "=OK_RIPROVATO", "MOTORE DIVERSO DAL PIN:", "NON SI LEGGE", "FAIL"]),
 # ---- IL CANCELLO INCROCIATO CON LA TOLLERANZA. a gira i CSV VERI di R110; i casi al bordo sono QUELLI del lettore indipendente (stessa lista, attese scritte a mano)
 # (generati sotto, dopo la lista T: CASI_CANCELLO)
 # a non e certificato dalla catena: il cancello NON gira (NON VERIFICABILE) e b e c non si leggono
 ("T1_a_asse_sbagliato_NV", {A: {"ax_vals": [766901, 766903]}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK", "OK"), CAN + "NON VERIFICABILE   EMAGEM2a ha STATO NV", "-> b e c NON SI LEGGONO (il cancello non ha potuto dire PASS)", "EMAGEM2b: " + NSL % "NON VERIFICABILE", "EMAGEM2c: " + NSL % "NON VERIFICABILE",
   "RIEP:" + CAN + "NON VERIFICABILE", "asse InpMagic [766901/766903] DIVERSO dall atteso 766901/766902"], ["T1 PASS", "T1 FAIL", ": PASS"] + NOBC),
 ("T1_a_due_gambe_morte_KO", {A: {"legs": ["ko_ko", "ko_ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("KO", "OK", "OK"), CAN + "NON VERIFICABILE   EMAGEM2a ha STATO KO", "EMAGEM2b: " + NSL % "NON VERIFICABILE", "EMAGEM2c: " + NSL % "NON VERIFICABILE"], ["T1 PASS", "T1 FAIL", ": PASS"] + NOBC),
 ("T1_a_gamba_morta_MISTO", {A: {"legs": ["ko_ko", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("MISTO", "OK", "OK"), CAN + "NON VERIFICABILE   EMAGEM2a ha STATO MISTO", "EMAGEM2b: " + NSL % "NON VERIFICABILE"], ["T1 PASS", "T1 FAIL"] + NOBC),
 ("T1_a_rc1_NV", {A: {"rc1": True}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK", "OK"), "rc 1: il driver si e fermato con un ERRORE", CAN + "NON VERIFICABILE   EMAGEM2a ha STATO NV", "EMAGEM2c: " + NSL % "NON VERIFICABILE"], ["T1 PASS", "T1 FAIL"] + NOBC),
 ("T1_a_non_lanciato", {}, CLOCK(A), "ok", PC, "", "ok", {},
  [ST("NON LANCIATO", "OK", "OK"), CAN + "NON VERIFICABILE   EMAGEM2a NON LANCIATO (tetto): il cancello non e stato eseguito", "EMAGEM2b: " + NSL % "NON VERIFICABILE", "=== EMAGEM2a: NON LANCIATO (tetto di 40 minuti"], ["T1 PASS", "T1 FAIL"]),
 # OK_RIPROVATO e un RILIEVO, non un difetto: i numeri si leggono come OK, e il cancello gira
 ("T1_a_riprovata_PASS", {A: {"legs": ["ko_ok", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK_RIPROVATO", "OK", "OK"), CAN + "PASS   " + PASSTXT, "giornale: intestazioni 3 partite 2 morte 1", "GAMBE RIPROVATE DAL DRIVER: 1 (EMAGEM2a IS)"], ["NON SI LEGGE", "T1 FAIL", "G1 FAIL"]),
 # le pietre del cancello: se b ha un problema suo (NV), il cancello di a resta PASS e a si legge
 ("T1_pass_ma_b_NV", {B: {"trades0": True}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV", "OK"), CAN + "PASS   " + PASSTXT, "NON BUONO: righe 5 (attese 5), Trades>0 su 4"], ["NON SI LEGGE", "EMAGEM2a NV"]),
 # a: i CSV VERI di R110 col pin non arrivato (il magic dell asse non e arrivato: due righe con lo stesso magic)
 ("a_csv_veri_pin_perso", {A: {"ax_vals": [766901, 766901]}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK", "OK"), "asse InpMagic [766901/766901] DIVERSO dall atteso 766901/766902", "il pin dell asse NON e arrivato"], ["EMAGEM2a OK"]),
 # ---- gambe morte, riprove (portati da DAXAP03, sui job b e c)
 ("job_c_gamba_morta", {C: {"legs": ["ok", "ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK", "MISTO"), "EMAGEM2c MISTO   rc 2", "giornale: intestazioni 2 partite 1 morte 1   RIPROVE: IS: PARTITA, CSV PRODOTTO; OOS: MORTA_INIT, CSV NON PRODOTTO;",
   "gamba OOS MORTA in OnTesterInit e non salvata dalla riprova", "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 1 (EMAGEM2c 1 su 2", "NON e una replica", "RIPESCATE dalla cache",
   "FrameAdd r.655 in OnTester r.643", "ExportTrades r.616 chiamata in OnTester r.645", "magic 766901/766902/766911/766921",
   "MANCA ROUND_EMAGEM2c\\%s_NASUSD_OOS_EMAGEM2c.csv" % EA, "OK    " + RPC, "FILE ATTESI TROVATI: 19 su 20   NELLO ZIP: 19 su 20", CAN + "PASS"], ["EMAGEM2a NV", "EMAGEM2c OK", "GAMBE RIPROVATE", "ABTG_MaxMinNotte"]),
 ("job_b_gamba_riprovata_e_salvata", {B: {"legs": ["ko_ok", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK_RIPROVATO", "OK"), "EMAGEM2b OK_RIPROVATO   rc 3", "giornale: intestazioni 3 partite 2 morte 1", "RIPROVE: IS: MORTA_INIT poi PARTITA RIPROVATA, CSV PRODOTTO;",
   "GAMBE RIPROVATE DAL DRIVER: 1 (EMAGEM2b IS)", "RILIEVO, non un difetto: gamba IS", "FILE ATTESI TROVATI: 20 su 20   NELLO ZIP: 20 su 20", "asse InpTF [30/16385/16386/16387/16388] ok", CAN + "PASS"],
  ["EMAGEM2b NV", "GAMBE SENZA CSV", "MANCA ", "NON SI LEGGE"]),
 ("job_a_due_gambe_riprovate_e_salvate", {A: {"legs": ["ko_ok", "ko_ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK_RIPROVATO", "OK", "OK"), "giornale: intestazioni 4 partite 2 morte 2", "GAMBE RIPROVATE DAL DRIVER: 2 (EMAGEM2a IS,OOS)", "gamba IS e OOS morta in OnTesterInit", CAN + "PASS"], ["EMAGEM2a NV", "GAMBE SENZA CSV", "NON SI LEGGE"]),
 ("job_c_gamba_morta_due_volte", {C: {"legs": ["ko_ko", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK", "MISTO"), "giornale: intestazioni 3 partite 1 morte 2", "RIPROVE: IS: MORTA_INIT poi MORTA_INIT RIPROVATA, CSV NON PRODOTTO;", "GAMBE RIPROVATE DAL DRIVER: 1 (EMAGEM2c IS)",
   "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 1 (EMAGEM2c 1 su 2"], ["EMAGEM2c NV", "EMAGEM2c OK"]),
 ("ko_quattro_tentativi_morti_su_c", {C: {"legs": ["ko_ko", "ko_ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK", "KO"), "EMAGEM2c KO   rc 2", "giornale: intestazioni 4 partite 0 morte 4", "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 2 (EMAGEM2c 2 su 2",
   "MANCA PERTRADE\\abtg_trades_%s_NASUSD_766921.csv" % EA, "OK    ROUND_EMAGEM2c\\REFERTO_ROUND_EMAGEM2c.txt", "OK    " + RPC, "FILE ATTESI TROVATI: 17 su 20"], ["EMAGEM2c NV", "EMAGEM2c OK"]),
 ("ko_ma_csv_fresco", {C: {"legs": ["ko", "ko"], "csv_anyway": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "il driver dice CSV NON PRODOTTO per IS e OOS ma esiste un CSV fresco"], ["EMAGEM2c KO"]),
 ("misto_ma_csv_morto_fresco", {B: {"legs": ["ok", "ko"], "csv_anyway": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "il driver dice CSV NON PRODOTTO per la gamba OOS ma il suo CSV e fresco"], ["EMAGEM2b MISTO"]),
 ("riprove_assente_con_gamba_riprovata", {B: {"legs": ["ko_ok", "ok"], "rp_absent": True}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV", "OK"), "file RIPROVE del driver ASSENTE: non so quante volte e stata lanciata ogni gamba (classe 1030)", "MANCA " + RPB], ["EMAGEM2b OK"]),
 ("riprove_vecchio", {C: {"rp_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "file RIPROVE del driver VECCHIO (scritto prima del job)"], ["EMAGEM2c OK"]),
 ("riprove_una_gamba", {B: {"rp_una_gamba": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "file RIPROVE del driver con 1 righe GAMBA"], ["EMAGEM2b OK"]),
 ("riprove_incoerente", {C: {"legs": ["ko", "ok"], "rp_dice_prodotto": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "file RIPROVE INCOERENTE"], ["EMAGEM2c MISTO"]),
 ("giornale_e_riprove_non_tornano", {B: {"extra_leg": True}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV", "OK"), "il giornale del tester e il file RIPROVE NON TORNANO: giornale 3 intestazioni, 3 partite, 0 morte; RIPROVE 2 tentativi, 2 PARTITA, 0 MORTA_INIT"], ["EMAGEM2b OK"]),
 ("morta_con_altra_causa", {C: {"legs": ["altro", "ok"]}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "un tentativo con esito diverso da PARTITA o MORTA_INIT", "MORTA_ALTRO"], ["EMAGEM2c MISTO", "EMAGEM2c KO"]),
 ("rp_copia_mancante_in_raccolta", {B: {"rp_nocopy": True}}, "", "ok", PC, "", "ok", {}, [OK3, "MANCA " + RPB, "FILE ATTESI TROVATI: 19 su 20   NELLO ZIP: 19 su 20"], ["MANCA " + RPA]),
 ("trades_zero_in_una_cella_di_a", {A: {"trades0": True}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK", "OK"), "NON BUONO: righe 2 (attese 2), Trades>0 su 1", CAN + "NON VERIFICABILE   EMAGEM2a ha STATO NV"], ["EMAGEM2a OK"]),
 ("una_riga_in_meno_su_c", {C: {"una_riga": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "righe 4 (attese 5)"], ["EMAGEM2c OK"]),
 ("csv_0_byte", {B: {"csv_zero": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "contraddizione: il driver dice CSV PRODOTTO per IS e OOS ma i CSV non sono buoni (_IS 0 byte ; _OOS 0 byte)"], ["EMAGEM2b OK"]),
 ("csv_vecchio", {C: {"csv_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "VECCHIO (scritto prima del job)"], ["EMAGEM2c OK"]),
 ("oos_assente", {B: {"no_OOS": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "MANCA ROUND_EMAGEM2b\\%s_D30EUR_OOS_EMAGEM2b.csv" % EA], ["EMAGEM2b OK"]),
 ("asse_TF_sbagliato", {B: {"ax_vals": [30, 16385, 16386, 16387, 16389]}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "[30/16385/16386/16387/16389] DIVERSO dall atteso 30/16385/16386/16387/16388"], ["EMAGEM2b OK"]),
 ("asse_TF_ripetuto", {C: {"ax_vals": [30, 16385, 16385, 16387, 16388]}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "[30/16385/16385/16387/16388] DIVERSO dall atteso 30/16385/16386/16387/16388"], ["EMAGEM2c OK"]),
 # l asse TF non arrivato: MT5 gira cinque volte la cella H1
 ("asse_TF_non_arrivato", {C: {"ax_vals": [16385, 16385, 16385, 16385, 16385]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK", "NV"), "[16385/16385/16385/16385/16385] DIVERSO dall atteso 30/16385/16386/16387/16388", "il pin dell asse NON e arrivato"], ["EMAGEM2c OK"]),
 ("pin_magic_perso_su_b", {B: {"pin_bad": "InpMagic"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "PIN DEL FILE PROVA NON ARRIVATI nel CSV: _IS 5 valori diversi InpMagic=[0] atteso 766911"], ["EMAGEM2b OK"]),
 ("pin_lato_short_perso_su_b", {B: {"pin_bad": "InpAllowShort"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "InpAllowShort=[0] atteso 1"], ["EMAGEM2b OK"]),
 ("pin_lato_long_perso_su_a", {A: {"pin_bad": "InpAllowLong"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "InpAllowLong=[0] atteso 1", CAN + "NON VERIFICABILE"], ["EMAGEM2a OK"]),
 ("pin_rischio_perso_su_c", {C: {"pin_bad": "InpRiskPercent"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "InpRiskPercent=[0] atteso 1"], ["EMAGEM2c OK"]),
 ("pin_TF_di_a_perso", {A: {"pin_bad": "InpTF"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "InpTF=[0] atteso 16385"], ["EMAGEM2a OK"]),
 ("colonna_assente_su_b", {B: {"col_absent": "InpEmaPeriod"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "InpEmaPeriod=[] atteso 200"], ["EMAGEM2b OK"]),
 ("finestra_oos_un_giorno_prima_su_c", {C: {"win_bad": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "FINESTRA GIRATA DIVERSA DALLA DICHIARATA (classe 992)", "to 2026.06.29 00:00 su NASUSD: DIVERSA dalla dichiarata"], ["EMAGEM2c OK"]),
 ("corse_precedenti_stesso_giorno", {"prima": True}, "", "ok", PC, "", "ok", {}, [OK3, "(corse precedenti dello stesso giorno, non contano): 6"], ["=NV"]),
 ("giornale_assente", {"no_logs": True}, "", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "GIORNALE DEL TESTER: NON VERIFICABILE (file *Tester_logs* trovati 0, leggibili 0)", CAN + "NON VERIFICABILE"], ["EMAGEM2a OK"]),
 ("giornale_vuoto", {"tlog": "vuoto"}, "", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "giornale del tester NON VERIFICABILE"], ["EMAGEM2a OK"]),
 ("gamba_di_altro_EA", {B: {"ea_other": "ABTG_Nightly"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "porta il nome di un ALTRO EA"], ["EMAGEM2b OK"]),
 # classi 166/892, DOPO OGNI JOB: la mutazione nel SOLO secondo job deve colpire il secondo e non il primo ne il terzo
 ("ea_mutato_nel_secondo_job", {B: {"mut_ea": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "%s.mq5 SHA256 DIVERSO DAL PIN" % EA, "MOTORE DIVERSO DAL PIN in 1 job"], ["EMAGEM2b OK", "EMAGEM2a NV"]),
 ("ea_assente_su_a", {A: {"no_ea": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "%s.mq5 ASSENTE" % EA], ["EMAGEM2a OK"]),
 ("include_mutato", {A: {"mut_inc": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "ABTG_PausaGuardian.mqh SHA256 DIVERSO DAL PIN"], ["EMAGEM2a OK"]),
 ("walkforward_retry_mutato", {C: {"mut_wf": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "walkforward_generico_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["EMAGEM2c OK"]),
 ("walkforward_retry_assente", {A: {"no_wf": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "walkforward_generico_RETRY.ps1 ASSENTE"], ["EMAGEM2a OK"]),
 # classe 1028: l ORIGINALE (senza riprova) salvato col nome della copia porta i marcatori vecchi ma non lo SHA del pin
 ("walkforward_originale_col_nome_RETRY", {A: {"wf_originale": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "walkforward_generico_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["EMAGEM2a OK"]),
 ("riga_retry_locale_mutata_durante_il_terzo_job", {C: {"mut_drvloc": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "RIGA_ROUND_VPS_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["EMAGEM2c OK", "EMAGEM2b NV"]),
 # mutata durante il SECONDO job: la copia locale resta mutata, quindi il secondo la vede e anche il terzo (non la riscarica nessuno): e voluto
 ("riga_retry_locale_mutata_durante_il_secondo_job", {B: {"mut_drvloc": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "NV"), "RIGA_ROUND_VPS_RETRY.ps1 SHA256 DIVERSO DAL PIN", "MOTORE DIVERSO DAL PIN in 2 job"], ["EMAGEM2b OK", "EMAGEM2a NV"]),
 ("prova_mutata", {C: {"mut_prova": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "prova SHA256 DIVERSO DAL PIN"], ["EMAGEM2c OK"]),
 # il referto del driver (classi 1019 e 1032)
 ("referto_assente", {A: {"ref_absent": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "REFERTO DEL DRIVER ASSENTE", "MANCA ROUND_EMAGEM2a\\REFERTO_ROUND_EMAGEM2a.txt"], ["EMAGEM2a OK"]),
 ("referto_vecchio_sul_desktop", {A: {"ref_absent": True}}, "", "ok", PC, "", "ok", {"PRE_OLD": A}, [ST("NV", "OK", "OK"), "tolta la cartella di una corsa PRECEDENTE: ROUND_EMAGEM2a", "REFERTO DEL DRIVER ASSENTE"], ["EMAGEM2a OK"]),
 ("referto_non_riscritto", {B: {"ref_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "REFERTO DEL DRIVER VECCHIO (scritto prima del job: NON e di questa corsa)"], ["EMAGEM2b OK"]),
 ("referto_terminale_banco_VPS", {A: {"ref_term": "C:\\MT5_Backtest\\terminal64.exe"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "terminale C:\\MT5_Backtest\\terminal64.exe", "DIVERSO DALLA RIGA"], ["EMAGEM2a OK"]),
 ("referto_driver_originale", {A: {"ref_driver": "walkforward_generico.ps1"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "driver walkforward_generico.ps1, riprova", "DIVERSO DALLA RIGA (attesi deposito 100000"], ["EMAGEM2a OK"]),
 # la cartella vecchia che NON si lascia togliere: la riga si ferma PRIMA di aprire MT5 (classe 1032)
 ("cartella_vecchia_non_rimovibile", {}, "", "ok", PC, "", "ok", {"PRE_OLD": B, "NO_RM": B}, ["NON riesco a togliere la cartella di una corsa PRECEDENTE", "ROUND_EMAGEM2b", NOSTUB], FERMA + ["tolta la cartella"]),
 # lo zip che perde una voce: la cartella e completa, il pacco no (classi 1021/1033)
 ("zip_senza_un_file", {}, "", "ok", PC, "", "ok", {"ZIP_DROP": "RIPROVE_%s_D30EUR_EMAGEM2b" % EA}, [OK3, "FILE ATTESI TROVATI: 20 su 20   NELLO ZIP: 19 su 20", "nello zip: NO"], ["NELLO ZIP: 20 su 20"]),
 ("zip_vecchio", {}, "", "ok", PC, "", "ok", {"ZIP_STALE": "1"}, [OK3, "ZIP VECCHIO (scritto prima di questa raccolta, NON e di questa corsa)", "FILE ATTESI TROVATI: 20 su 20   NELLO ZIP: 0 su 20"], ["ZIP PRONTO DA MANDARE"]),
 ("CE11_zip_senza_riepilogo", {}, "", "ok", PC, "", "ok", {"ZIP_DROP": "RIEPILOGO_ROUND_EMAGEM2"}, [OK3, "NELLO ZIP: 19 su 20"], ["NELLO ZIP: 20 su 20"]),
 # magic del file prova contro la riga (difesa in profondita': il file e' gia' pinnato per SHA). Per raggiungerla si cambiano INSIEME la tabella dei job
 # e il suo controllo di coerenza: il file scaricato dice 766911, la riga dice 766912.
 ("riga_magic_diverso_dal_file", {}, r"s/mg='766911';/mg='766912';/; s/\$jobs\[1\].mg -ne '766911'/$jobs[1].mg -ne '766912'/", "ok", PC, "", "ok", {},
  [ST("OK", "NV", "OK"), "(magic atteso 766912, due lati e rischio 1 attesi)"], ["EMAGEM2b OK"]),
 # gli argomenti passati al driver (classe 1019): li dice il referto, non la riga
 ("deposito_non_passato", {}, r"s/ -Deposito \$jb.dp / /", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "deposito 10000, modello 4", CAN + "NON VERIFICABILE"], ["EMAGEM2a OK"]),
 ("modello_1_passato", {}, r"s/-Modello \$jb.m /-Modello 1 /", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "modello 1, driver"], ["EMAGEM2a OK"]),
 ("pin_diverso_passato", {}, r"s/-Pin \$PIN /-Pin lavoro /", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "referto: pin lavoro,"], ["EMAGEM2a OK"]),
 ("maxriprove_0_passato", {}, r"s/-MaxRiprove \$MAXRIP /-MaxRiprove 0 /", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "riprova [MaxRiprove 0   attesa 20 s"], ["EMAGEM2a OK"]),
 ("scadenza_non_passata", {}, r"s/ -RiprovaEntro \$scadTxt;/;/", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "scadenza nessuna] DIVERSO DALLA RIGA"], ["EMAGEM2a OK"]),
 # il tetto fra i job: orologio spostato di 45 minuti per UN solo job (modifica di banco, non della riga vera)
 ("tetto_secondo_job_non_lanciato", {}, CLOCK(B), "ok", PC, "", "ok", {},
  [ST("OK", "NON LANCIATO", "OK"), "=== EMAGEM2b: NON LANCIATO (tetto di 40 minuti", "FILE ATTESI TROVATI: 14 su 14   NELLO ZIP: 14 su 14", "ROUND LANCIATI: 2 su 3   NON LANCIATI (tetto): 1", CAN + "PASS"], ["EMAGEM2b OK", "EMAGEM2b NV"]),
 ("tetto_terzo_job_non_lanciato", {}, CLOCK(C), "ok", PC, "", "ok", {},
  [ST("OK", "OK", "NON LANCIATO"), "=== EMAGEM2c: NON LANCIATO (tetto di 40 minuti", "FILE ATTESI TROVATI: 14 su 14   NELLO ZIP: 14 su 14", "ROUND LANCIATI: 2 su 3   NON LANCIATI (tetto): 1"], ["EMAGEM2c OK", "EMAGEM2c NV"]),
 # il per-trade e INFORMATIVO (classe 455): non cambia lo stato, ma si dice cosa e (a ne ha DUE, uno per magic)
 ("pertrade_vecchio_su_a", {A: {"pertrade_stale": True}}, "", "ok", PC, "", "ok", {},
  [OK3, "PERTRADE EMAGEM2a abtg_trades_%s_U30USD_766901.csv: assente in Common\\Files o scritto prima del job" % EA, "PERTRADE EMAGEM2a abtg_trades_%s_U30USD_766902.csv: assente in Common\\Files o scritto prima del job" % EA,
   "MANCA PERTRADE\\abtg_trades_%s_U30USD_766901.csv" % EA, "MANCA PERTRADE\\abtg_trades_%s_U30USD_766902.csv" % EA, "FILE ATTESI TROVATI: 18 su 20"], ["=NV"]),
 ("pertrade_solo_IS_su_b", {B: {"pertrade_ct": ["2024.10.01 08:10:00", "2025.06.09 08:40:00"]}}, "", "ok", PC, "", "ok", {}, [OK3, "2 deal di uscita, gamba IS (ultima chiusura 2025.06.09 08:40:00)"], ["=NV"]),
 ("pertrade_magic_estraneo_su_a", {A: {"pertrade_mg": "763300"}}, "", "ok", PC, "", "ok", {}, [OK3, "righe con magic diverso da 766901: 3", "righe con magic diverso da 766902: 3"], ["=NV"]),
 # i cancelli PRIMA del job: la riga si ferma, lo stub NON viene chiamato
 ("riga_incoerente_deposito", {}, r"s/dp=100000;/dp=10000;/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_asse_a", {}, r"s/av=@(766901,766902)/av=@(766901,766903)/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_asse_TF_di_c", {}, r"s/av=@(30,16385,16386,16387,16388); nr=5; mg='766921'/av=@(30,16385,16386,16387,16389); nr=5; mg='766921'/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_magic", {}, r"s/mg='766921';/mg='766922';/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_magic_di_a_pinnato", {}, r"s/mg=''; pm=/mg='766901'; pm=/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_input", {}, r"s/np=42;/np=41;/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_frazione", {}, r"s/fz='0.40';/fz='0.50';/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_simbolo", {}, r"s/s='NASUSD'/s='SPXUSD'/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_ordine_dei_job", {}, r"s/'EMAGEM2a,EMAGEM2b,EMAGEM2c'/'EMAGEM2b,EMAGEM2a,EMAGEM2c'/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_tetto", {}, r"s/\$TETTO=40;/$TETTO=45;/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_margine", {}, r"s/\$MARGINE=10;/$MARGINE=0;/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_maxriprove", {}, r"s/\$MAXRIP=1;/$MAXRIP=2;/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM2 INCOERENTE", NOSTUB], FERMA),
 ("macchina_VPS", {}, "", "ok", "VMI3047753", "", "ok", {}, ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: VMI3047753", NOSTUB], FERMA + ["GUARDIA EA"]),
 ("macchina_vuota", {}, "", "ok", "", "", "ok", {}, ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ", NOSTUB], FERMA),
 ("mt5_aperto", {}, "", "ok", PC, "", "ok", {"PRE_MT5": "1"}, ["MT5 risulta APERTO su questo PC", "Questo round gira ABTG_EMA200", NOSTUB], FERMA + ["GUARDIA EA"]),
 ("terminale_assente", {}, "", "ok", PC, "", "assente", {}, ["TERMINALE: non trovo C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe", NOSTUB], FERMA),
 ("terminale_collegamento", {}, "", "ok", PC, "", "link", {}, ["e un COLLEGAMENTO (junction o link)", NOSTUB], FERMA),
 ("grafico_con_EA", {}, "", "ea", PC, "", "ok", {}, ["GUARDIA EA: grafici salvati letti 3, con un EA attaccato o illeggibili 1", "EA: " + EA, NOSTUB], FERMA),
 ("grafico_illeggibile", {}, "", "rotto", PC, "", "ok", {}, ["ILLEGGIBILE", "GUARDIA EA: nel profilo del terminale 50503392", NOSTUB], FERMA),
 ("zero_grafici", {}, "", "zero", PC, "", "ok", {}, ["GUARDIA EA: ho letto ZERO grafici salvati", NOSTUB], FERMA),
 ("driver_mutato", {}, "", "ok", PC, "drv", "ok", {}, ["RIGA_ROUND_VPS_RETRY.ps1 scaricata con SHA256 DIVERSO", NOSTUB], FERMA),
 ("driver_originale_col_nome_RETRY", {}, "", "ok", PC, "orig", "ok", {}, ["scaricata SENZA il marcatore RETRY_v1", NOSTUB], FERMA),
 # --- classe 1051: ogni componente del confronto giornale/RIPROVE e della coerenza del RIPROVE ha uno scenario in cui e' il SOLO a scattare
 ("CE1_riprove_dichiara_riprova_che_il_giornale_non_ha", {B: {"legs": ["ko_ok", "ok"], "rp_fake_retry": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "NON TORNANO: giornale 2 intestazioni, 2 partite, 0 morte"], ["EMAGEM2b OK"]),
 ("CE2_riprova_OOS_gira_la_finestra_IS", {C: {"legs": ["ok", "ko_ok"], "retry_win_is": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "FINESTRA GIRATA DIVERSA DALLA DICHIARATA"], ["EMAGEM2c OK"]),
 ("CE3_csv_di_un_altra_cella", {B: {"pin_over": {"InpMagic": "766921"}}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "InpMagic=[766921] atteso 766911"], ["EMAGEM2b OK"]),
 ("CE3b_csv_altra_cella_un_lato_solo", {B: {"pin_over": {"InpAllowShort": "0"}}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "InpAllowShort=[0] atteso 1"], ["EMAGEM2b OK"]),
 ("CE4_morte_senza_causa_ma_riprove_dice_INIT", {B: {"legs": ["ko_ok", "ok"], "dead_nocause": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "NON TORNANO: giornale 3 intestazioni, 2 partite, 0 morte"], ["EMAGEM2b OK"]),
 ("CE8_una_salvata_una_morta_due_volte", {C: {"legs": ["ko_ok", "ko_ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK", "MISTO"), "GAMBE RIPROVATE DAL DRIVER: 2 (EMAGEM2c IS,OOS)", "giornale: intestazioni 4 partite 1 morte 3"], ["EMAGEM2c OK", "EMAGEM2c NV"]),
 ("CE10_riprove_senza_flag_RIPROVATA", {B: {"legs": ["ko_ok", "ok"], "rp_no_rip": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "file RIPROVE INCOERENTE"], ["EMAGEM2b OK"]),
 ("CE12_tre_job_riprovati", {A: {"legs": ["ok", "ko_ok"]}, B: {"legs": ["ko_ok", "ok"]}, C: {"legs": ["ko_ok", "ko_ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK_RIPROVATO", "OK_RIPROVATO", "OK_RIPROVATO"), "GAMBE RIPROVATE DAL DRIVER: 4 (EMAGEM2a OOS, EMAGEM2b IS, EMAGEM2c IS,OOS)", "FILE ATTESI TROVATI: 20 su 20", CAN + "PASS"], ["=NV", "GAMBE SENZA CSV", "NON SI LEGGE"]),
 # la stima dei tempi: console e RIEPILOGO dicono lo STESSO numero (classe 1050)
 ("stima_tempi_console_uguale_riepilogo", {}, "", "ok", PC, "", "ok", {},
  [OK3, "TEMPO: [STIMA] circa 10-34 minuti in tutto se nessuna gamba muore", "RIEP:dichiarato [STIMA] circa 10-34 minuti, circa 2,5 in piu per gamba riprovata, tetto 40",
   "Circa 2,5 minuti in piu per ogni gamba che muore e viene riprovata", "scadenza ", "(T0 + 40 - 10 minuti"], ["circa 1,5 in piu", "circa 80 s", "3-5 minuti", "8-34", "tetto 20"]),
]

def _scen_patch(a_patch):
    return {A: {"patch": [{"fase": f, "riga": r, "col": c, "val": v} for (f, r, c), v in sorted(a_patch.items())]}}
CASI_CANCELLO = []
for _i, (_nome, _patch, _att) in enumerate(LG._casi_cancello()):
    _n = "CAN%02d_%s" % (_i, re.sub(r"[^A-Za-z0-9]+", "_", _nome)[:60].strip("_"))
    if _att == "PASS":
        _deve = [OK3, CAN + "PASS   " + PASSTXT, "CONS2:" + CAN + "PASS   ", "RIEP:" + CAN + "PASS   " + PASSTXT, "EMAGEM2b OOS  InpTF  16388  InpMagic 766911", "EMAGEM2c IS   InpTF     30  InpMagic 766921",
                 "PERTRADE EMAGEM2b abtg_trades_%s_D30EUR_766911.csv" % EA, "RESIDUI DENTRO LA TOLLERANZA"]
        _non = ["NON SI LEGGE", "T1 FAIL", "G1 FAIL", "=NV", "ROUND NULLO"]
    else:
        _t1 = "T1 PASS" if _att == "G1" else "T1 FAIL"
        _g1 = "G1 PASS" if _att == "T1" else "G1 FAIL"
        _deve = [OK3, CAN + "FAIL", _t1, _g1, "-> ROUND NULLO per a, b e c secondo i file prova: b e c NON SI LEGGONO", "CONS:   EMAGEM2b: " + NSL % "FAIL", "RIEP:   EMAGEM2c: " + NSL % "FAIL"]
        _non = ["T1 PASS (IS", "EMAGEM2a: NON SI LEGGE"] + NOBC + (["G1 FAIL"] if _att == "T1" else []) + (["T1 FAIL"] if _att == "G1" else [])
    if _i == 1:      # il caso del 03/10: i quattro residui entro tolleranza si ELENCANO, in console e nel RIEPILOGO (scarto = differenza esatta, in decimale)
        _res = "RESIDUI DENTRO LA TOLLERANZA (4, si scrivono, nessun giudizio): OOS magic 766902 Profit [23321.46] contro noto [23321.47] (scarto 0.01) ; OOS gemelle Profit [23321.47] contro [23321.46] (scarto 0.01) ; OOS gemelle Expected Payoff [45.10923] contro [45.10921] (scarto 0.00002) ; OOS gemelle Sharpe Ratio [8.16765] contro [8.16764] (scarto 0.00001)"
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
            rf = os.path.join(dk, x, "RIEPILOGO_ROUND_EMAGEM2.txt")
            if x.startswith("ROUND_EMAGEM2_") and os.path.isfile(rf):
                riep += open(rf, encoding="ascii", errors="replace").read()
    t += "\n=== RIEPILOGO ===\n" + riep
    sl = os.path.join(H, "stub.log")
    stub = open(sl).read() if os.path.exists(sl) else ""
    return re.sub(r"\x1b\[[0-9;]*m", "", t), stub

def stubargs_ok(out, stub):
    m = re.search(r"data: (\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)", out)
    if not m:
        return "data della riga non trovata nell uscita"
    scad = (dt.datetime.strptime(m.group(1), "%Y-%m-%d %H:%M:%S") + dt.timedelta(minutes=30)).strftime("%Y-%m-%d %H:%M:%S")
    righe = [l for l in stub.splitlines() if l.startswith("STUB ")]
    if len(righe) != 3:
        return "lo stub doveva essere chiamato 3 volte, e invece %d" % len(righe)
    for l, (lbl, prv) in zip(righe, ((A, "EMAGEM2_a_ancora_U30USD_H1_LS.txt"), (B, "EMAGEM2_b_D30EUR_LS_tf.txt"), (C, "EMAGEM2_c_NASUSD_LS_tf.txt"))):
        att = ("-Expert | %s | -Prova | %s | -Etichetta | %s | -Pin | %s | -Modello | 4 | -Deposito | 100000 | -MaxRiprove | 1 | -AttesaRiprovaSec | 20 | -RiprovaEntro | %s"
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
