#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- il collaudo a macchina di RIGA_ROUND_EMAGEM.txt (TRE job, driver con la riprova, cancello incrociato T1 + G1). Stessa forma di
collaudo_riga_DAXAP03/battery.py.

Fa girare la riga VERA sotto pwsh (Linux, PowerShell 7) con un driver FINTO (stub_driver.py) che scrive, per ciascun job, CSV IS/OOS nel formato
di OptFrame (per a: i CSV VERI di R110, scritti da MT5 il 26/08, col solo magic portato a 766801/766802), un giornale del tester UTF-16 con le
righe VERE e UNA intestazione per tentativo, il file RIPROVE nelle righe di walkforward_generico_RETRY.ps1, il per-trade in Common\\Files (uno per
magic) e il REFERTO della riga RETRY (pin/macchina/terminale/deposito/modello/driver/riprova); `irm` servito da un magazzino locale
(righe/RIGA_ROUND_VPS_RETRY.ps1 AL PIN, via git show); un disco C: finto.
Verifica che OK / OK_RIPROVATO / KO / MISTO / NV / NON LANCIATO scattino job per job quando devono e NON scattino quando non devono, che il
CANCELLO INCROCIATO T1 + G1 di a dica PASS solo sui numeri veri e FAIL / NON VERIFICABILE altrimenti (con b e c "NON SI LEGGE"), e che i cancelli
della riga reggano. Un'attesa che comincia con RIEP: si cerca SOLO nel RIEPILOGO scritto nella raccolta, con CONS: SOLO nella console, con CONS2: almeno DUE volte nella console.
NON prova: Windows PowerShell 5.1, MT5, il tester, il tempo vero, la rete, GitHub raw, il driver vero.
Uso:  python3 backtest_pipeline/collaudo_riga_EMAGEM/battery.py [PIN] [RIGA] [nomi...]   (esce 0 se tutto come atteso). Serve: pwsh, python3, iconv, git.
"""
import json, os, re, subprocess, sys, datetime as dt
from concurrent.futures import ThreadPoolExecutor
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
OUT = os.environ.get("HARNESS_OUT", "/tmp/emagem_harness")
os.makedirs(OUT, exist_ok=True)
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = sys.argv[2] if len(sys.argv) > 2 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_EMAGEM.txt")
PC = "DESKTOP-H4D7CAJ"
A, B, C = "EMAGEMa", "EMAGEMb", "EMAGEMc"
EA = "ABTG_EMA200"
def ST(a, b, c):
    return "STATO: EMAGEMa=%s EMAGEMb=%s EMAGEMc=%s" % (a, b, c)
OK3 = ST("OK", "OK", "OK")
FERMA = ["EMAGEMa OK", "EMAGEMa NV", "EMAGEMb NV", "RACCOLTA:", "STATO: EMAGEMa"]   # una riga fermata dai cancelli NON arriva agli stati ne alla raccolta
NOSTUB = "__NOSTUB__"            # lo stub NON deve essere stato chiamato
STUBARGS = "__STUBARGS__"        # lo stub deve aver ricevuto, per OGNI job, gli argomenti esatti (scadenza = T0 + 30 minuti, con lo spazio)
RPA = "ROUND_EMAGEMa\\RIPROVE_%s_U30USD_EMAGEMa.txt" % EA
RPB = "ROUND_EMAGEMb\\RIPROVE_%s_D30EUR_EMAGEMb.txt" % EA
RPC = "ROUND_EMAGEMc\\RIPROVE_%s_NASUSD_EMAGEMc.txt" % EA
def CLOCK(lbl):
    return r"s/\$minAvv=\[int\](((Get-Date)-\$T0).TotalMinutes);/$minAvv=[int](((Get-Date)-$T0).TotalMinutes) + $(if($LBL -eq '%s'){45}else{0});/" % lbl
CAN = "CANCELLO INCROCIATO (T1 + G1 di EMAGEMa): "
PASSTXT = "T1 PASS (IS 4585.40 / 1.20110 / 5.7325 / 237 e OOS 23321.47 / 1.52365 / 7.8323 / 517 riprodotti al centesimo su tutte e due le celle gemelle) e G1 PASS (le due celle gemelle identiche su Profit, Expected Payoff, PF, Recovery Factor, Sharpe, DD e Trades)"
NSL = "NON SI LEGGE (cancello incrociato %s)"
def FAIL3(extra):
    """a e' girato bene (STATO OK per i tre), il cancello da FAIL, b e c NON SI LEGGONO."""
    return [OK3, CAN + "FAIL", "-> ROUND NULLO per a, b e c secondo i file prova: b e c NON SI LEGGONO", "CONS:   EMAGEMb: " + NSL % "FAIL", "CONS:   EMAGEMc: " + NSL % "FAIL",
            "RIEP:   EMAGEMb: " + NSL % "FAIL", "RIEP:   EMAGEMc: " + NSL % "FAIL", "CONS2:" + CAN + "FAIL", "RIEP:" + CAN + "FAIL"] + extra
NOPASS = ["T1 PASS (IS", "EMAGEMa: NON SI LEGGE"]
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
   "GUARDIA EA: grafici salvati letti 2, con un EA attaccato o illeggibili 0", "asse InpMagic [766801/766802] ok", "asse InpTF [30/16385/16386/16387/16388] ok",
   "FILE ATTESI TROVATI: 20 su 20   NELLO ZIP: 20 su 20", "ZIP PRONTO DA MANDARE", "OK    " + RPA, "OK    " + RPB, "OK    " + RPC,
   "EMAGEMa OOS  InpMagic 766801  InpMagic 766801   Trades   517   Profit   23321.47   PF  1.52365   Equity DD % 7.8323",
   "EMAGEMa IS   InpMagic 766802  InpMagic 766802   Trades   237   Profit    4585.40   PF  1.20110   Equity DD % 5.7325",
   "EMAGEMb OOS  InpTF  16388  InpMagic 766811", "EMAGEMc IS   InpTF     30  InpMagic 766821", "CATENA COMPLETA: 3 cartelle del driver su 3 job lanciati",
   "motore = pin (SHA256, EA + include + walkforward_generico_RETRY + RIGA_ROUND_VPS_RETRY)", "NON ha svuotato Tester\\cache", "MARCATORE_RIGA_ROUND_EMAGEM_v1",
   "righe con magic diverso da 766801: 0", "righe con magic diverso da 766802: 0", "righe con magic diverso da 766811: 0", "righe con magic diverso da 766821: 0",
   "ROUND LANCIATI: 3 su 3   NON LANCIATI (tetto): 0   PARTITI (rc diverso da 1): 3 su 3   MOTORE DIVERSO DAL PIN in 0 job", "=== RIEPILOGO ===",
   "direttive, input, asse, due lati, rischio e magic: = riga (42 input, asse InpMagic, due lati e rischio 1, nessuna @DEPOSITO)",
   "direttive, input, asse, due lati, rischio e magic: = riga (42 input, asse InpTF, due lati e rischio 1, nessuna @DEPOSITO)",
   CAN + "PASS   " + PASSTXT, "CONS2:" + CAN + "PASS   ", "RIEP:" + CAN + "PASS   " + PASSTXT],
  ["MOTIVO: ", "MANCA ", "SHA256 DIVERSO", "DIVERSO DALLA RIGA", "DIVERSI dalla", "DIVERSO dall atteso", "DIVERSA dalla", "=NV", " NV   rc", "GAMBE SENZA CSV", "GAMBE RIPROVATE", "=OK_RIPROVATO", "MOTORE DIVERSO DAL PIN:", "NON SI LEGGE", "FAIL"]),
 # ---- IL CANCELLO INCROCIATO. a gira i CSV VERI di R110; ogni scenario cambia UNA cella e il cancello deve accorgersene (e b e c non leggersi)
 ("T1_pf_una_gemella", {A: {"patch": [{"fase": "OOS", "riga": 0, "col": "Profit Factor", "val": "1.52366"}]}}, "", "ok", PC, "", "ok", {},
  FAIL3(["T1 FAIL (1 differenze: OOS magic 766801 Profit Factor [1.52366] atteso 1.52365)", "/ G1 FAIL (1 differenze: OOS Profit Factor [1.52366] contro [1.52365])"]), NOPASS),
 ("T1_pf_entrambe_le_gemelle", {A: {"patch": patch2("Profit Factor", "1.52366")}}, "", "ok", PC, "", "ok", {},
  FAIL3(["T1 FAIL (2 differenze: OOS magic 766801 Profit Factor [1.52366] atteso 1.52365 ; OOS magic 766802 Profit Factor [1.52366] atteso 1.52365) / G1 PASS"]), NOPASS + ["G1 FAIL"]),
 ("T1_profit_un_centesimo", {A: {"patch": patch2("Profit", "23321.48")}}, "", "ok", PC, "", "ok", {},
  FAIL3(["T1 FAIL (2 differenze: OOS magic 766801 Profit [23321.48] atteso 23321.47", "/ G1 PASS"]), NOPASS + ["G1 FAIL"]),
 ("T1_dd_ultima_cifra", {A: {"patch": patch2("Equity DD %", "7.8324")}}, "", "ok", PC, "", "ok", {},
  FAIL3(["T1 FAIL (2 differenze: OOS magic 766801 Equity DD % [7.8324] atteso 7.8323", "/ G1 PASS"]), NOPASS + ["G1 FAIL"]),
 ("T1_trades", {A: {"patch": patch2("Trades", "516")}}, "", "ok", PC, "", "ok", {},
  FAIL3(["T1 FAIL (2 differenze: OOS magic 766801 Trades [516] atteso 517", "/ G1 PASS"]), NOPASS + ["G1 FAIL"]),
 ("T1_is_sbagliata", {A: {"patch": patch2("Profit", "4585.41", "IS")}}, "", "ok", PC, "", "ok", {},
  FAIL3(["T1 FAIL (2 differenze: IS magic 766801 Profit [4585.41] atteso 4585.40", "/ G1 PASS"]), NOPASS + ["G1 FAIL"]),
 # il caso del deposito sbagliato: tutte e due le gemelle uguali fra loro ma con i numeri di un altro banco
 ("T1_banco_diverso_gemelle_uguali", {A: {"patch": patch2("Profit", "2332.15") + patch2("Trades", "517") + patch2("Profit", "458.54", "IS") + patch2("Trades", "230", "IS")}}, "", "ok", PC, "", "ok", {},
  FAIL3(["T1 FAIL (6 differenze: IS magic 766801 Profit [458.54] atteso 4585.40", "OOS magic 766802 Profit [2332.15] atteso 23321.47", "/ G1 PASS"]), NOPASS + ["G1 FAIL"]),
 ("G1_solo_sharpe", {A: {"patch": [{"fase": "OOS", "riga": 1, "col": "Sharpe Ratio", "val": "8.16767"}]}}, "", "ok", PC, "", "ok", {},
  FAIL3(["T1 PASS / G1 FAIL (1 differenze: OOS Sharpe Ratio [8.16765] contro [8.16767])"]), ["T1 FAIL", "EMAGEMa: NON SI LEGGE"]),
 ("G1_solo_expected_payoff_IS", {A: {"patch": [{"fase": "IS", "riga": 1, "col": "Expected Payoff", "val": "19.34769"}]}}, "", "ok", PC, "", "ok", {},
  FAIL3(["T1 PASS / G1 FAIL (1 differenze: IS Expected Payoff [19.34768] contro [19.34769])"]), ["T1 FAIL"]),
 ("G1_solo_recovery", {A: {"patch": [{"fase": "OOS", "riga": 0, "col": "Recovery Factor", "val": "2.53682"}]}}, "", "ok", PC, "", "ok", {},
  FAIL3(["T1 PASS / G1 FAIL (1 differenze: OOS Recovery Factor [2.53682] contro [2.53681])"]), ["T1 FAIL"]),
 # a non e certificato dalla catena: il cancello NON gira (NON VERIFICABILE) e b e c non si leggono
 ("T1_a_asse_sbagliato_NV", {A: {"ax_vals": [766801, 766803]}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK", "OK"), CAN + "NON VERIFICABILE   EMAGEMa ha STATO NV", "-> b e c NON SI LEGGONO (il cancello non ha potuto dire PASS)", "EMAGEMb: " + NSL % "NON VERIFICABILE", "EMAGEMc: " + NSL % "NON VERIFICABILE",
   "RIEP:" + CAN + "NON VERIFICABILE", "asse InpMagic [766801/766803] DIVERSO dall atteso 766801/766802"], ["T1 PASS", "T1 FAIL", ": PASS"]),
 ("T1_a_due_gambe_morte_KO", {A: {"legs": ["ko_ko", "ko_ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("KO", "OK", "OK"), CAN + "NON VERIFICABILE   EMAGEMa ha STATO KO", "EMAGEMb: " + NSL % "NON VERIFICABILE", "EMAGEMc: " + NSL % "NON VERIFICABILE"], ["T1 PASS", "T1 FAIL", ": PASS"]),
 ("T1_a_gamba_morta_MISTO", {A: {"legs": ["ko_ko", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("MISTO", "OK", "OK"), CAN + "NON VERIFICABILE   EMAGEMa ha STATO MISTO", "EMAGEMb: " + NSL % "NON VERIFICABILE"], ["T1 PASS", "T1 FAIL"]),
 ("T1_a_rc1_NV", {A: {"rc1": True}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK", "OK"), "rc 1: il driver si e fermato con un ERRORE", CAN + "NON VERIFICABILE   EMAGEMa ha STATO NV", "EMAGEMc: " + NSL % "NON VERIFICABILE"], ["T1 PASS", "T1 FAIL"]),
 ("T1_a_non_lanciato", {}, CLOCK(A), "ok", PC, "", "ok", {},
  [ST("NON LANCIATO", "OK", "OK"), CAN + "NON VERIFICABILE   EMAGEMa NON LANCIATO (tetto): il cancello non e stato eseguito", "EMAGEMb: " + NSL % "NON VERIFICABILE", "=== EMAGEMa: NON LANCIATO (tetto di 40 minuti"], ["T1 PASS", "T1 FAIL"]),
 # OK_RIPROVATO e un RILIEVO, non un difetto: i numeri si leggono come OK, e il cancello gira
 ("T1_a_riprovata_PASS", {A: {"legs": ["ko_ok", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK_RIPROVATO", "OK", "OK"), CAN + "PASS   " + PASSTXT, "giornale: intestazioni 3 partite 2 morte 1", "GAMBE RIPROVATE DAL DRIVER: 1 (EMAGEMa IS)"], ["NON SI LEGGE", "T1 FAIL", "G1 FAIL"]),
 # le pietre del cancello: se b ha un problema suo (NV), il cancello di a resta PASS e a si legge
 ("T1_pass_ma_b_NV", {B: {"trades0": True}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV", "OK"), CAN + "PASS   " + PASSTXT, "NON BUONO: righe 5 (attese 5), Trades>0 su 4"], ["NON SI LEGGE", "EMAGEMa NV"]),
 # a: i CSV VERI di R110 col pin non arrivato (il magic dell asse non e arrivato: due righe con lo stesso magic)
 ("a_csv_veri_pin_perso", {A: {"ax_vals": [766801, 766801]}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK", "OK"), "asse InpMagic [766801/766801] DIVERSO dall atteso 766801/766802", "il pin dell asse NON e arrivato"], ["EMAGEMa OK"]),
 # ---- gambe morte, riprove (portati da DAXAP03, sui job b e c)
 ("job_c_gamba_morta", {C: {"legs": ["ok", "ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK", "MISTO"), "EMAGEMc MISTO   rc 2", "giornale: intestazioni 2 partite 1 morte 1   RIPROVE: IS: PARTITA, CSV PRODOTTO; OOS: MORTA_INIT, CSV NON PRODOTTO;",
   "gamba OOS MORTA in OnTesterInit e non salvata dalla riprova", "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 1 (EMAGEMc 1 su 2", "NON e una replica", "RIPESCATE dalla cache",
   "FrameAdd r.655 in OnTester r.643", "ExportTrades r.616 chiamata in OnTester r.645", "magic 766801/766802/766811/766821",
   "MANCA ROUND_EMAGEMc\\%s_NASUSD_OOS_EMAGEMc.csv" % EA, "OK    " + RPC, "FILE ATTESI TROVATI: 19 su 20   NELLO ZIP: 19 su 20", CAN + "PASS"], ["EMAGEMa NV", "EMAGEMc OK", "GAMBE RIPROVATE", "ABTG_MaxMinNotte"]),
 ("job_b_gamba_riprovata_e_salvata", {B: {"legs": ["ko_ok", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK_RIPROVATO", "OK"), "EMAGEMb OK_RIPROVATO   rc 3", "giornale: intestazioni 3 partite 2 morte 1", "RIPROVE: IS: MORTA_INIT poi PARTITA RIPROVATA, CSV PRODOTTO;",
   "GAMBE RIPROVATE DAL DRIVER: 1 (EMAGEMb IS)", "RILIEVO, non un difetto: gamba IS", "FILE ATTESI TROVATI: 20 su 20   NELLO ZIP: 20 su 20", "asse InpTF [30/16385/16386/16387/16388] ok", CAN + "PASS"],
  ["EMAGEMb NV", "GAMBE SENZA CSV", "MANCA ", "NON SI LEGGE"]),
 ("job_a_due_gambe_riprovate_e_salvate", {A: {"legs": ["ko_ok", "ko_ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK_RIPROVATO", "OK", "OK"), "giornale: intestazioni 4 partite 2 morte 2", "GAMBE RIPROVATE DAL DRIVER: 2 (EMAGEMa IS,OOS)", "gamba IS e OOS morta in OnTesterInit", CAN + "PASS"], ["EMAGEMa NV", "GAMBE SENZA CSV", "NON SI LEGGE"]),
 ("job_c_gamba_morta_due_volte", {C: {"legs": ["ko_ko", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK", "MISTO"), "giornale: intestazioni 3 partite 1 morte 2", "RIPROVE: IS: MORTA_INIT poi MORTA_INIT RIPROVATA, CSV NON PRODOTTO;", "GAMBE RIPROVATE DAL DRIVER: 1 (EMAGEMc IS)",
   "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 1 (EMAGEMc 1 su 2"], ["EMAGEMc NV", "EMAGEMc OK"]),
 ("ko_quattro_tentativi_morti_su_c", {C: {"legs": ["ko_ko", "ko_ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK", "KO"), "EMAGEMc KO   rc 2", "giornale: intestazioni 4 partite 0 morte 4", "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 2 (EMAGEMc 2 su 2",
   "MANCA PERTRADE\\abtg_trades_%s_NASUSD_766821.csv" % EA, "OK    ROUND_EMAGEMc\\REFERTO_ROUND_EMAGEMc.txt", "OK    " + RPC, "FILE ATTESI TROVATI: 17 su 20"], ["EMAGEMc NV", "EMAGEMc OK"]),
 ("ko_ma_csv_fresco", {C: {"legs": ["ko", "ko"], "csv_anyway": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "il driver dice CSV NON PRODOTTO per IS e OOS ma esiste un CSV fresco"], ["EMAGEMc KO"]),
 ("misto_ma_csv_morto_fresco", {B: {"legs": ["ok", "ko"], "csv_anyway": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "il driver dice CSV NON PRODOTTO per la gamba OOS ma il suo CSV e fresco"], ["EMAGEMb MISTO"]),
 ("riprove_assente_con_gamba_riprovata", {B: {"legs": ["ko_ok", "ok"], "rp_absent": True}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV", "OK"), "file RIPROVE del driver ASSENTE: non so quante volte e stata lanciata ogni gamba (classe 1030)", "MANCA " + RPB], ["EMAGEMb OK"]),
 ("riprove_vecchio", {C: {"rp_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "file RIPROVE del driver VECCHIO (scritto prima del job)"], ["EMAGEMc OK"]),
 ("riprove_una_gamba", {B: {"rp_una_gamba": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "file RIPROVE del driver con 1 righe GAMBA"], ["EMAGEMb OK"]),
 ("riprove_incoerente", {C: {"legs": ["ko", "ok"], "rp_dice_prodotto": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "file RIPROVE INCOERENTE"], ["EMAGEMc MISTO"]),
 ("giornale_e_riprove_non_tornano", {B: {"extra_leg": True}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV", "OK"), "il giornale del tester e il file RIPROVE NON TORNANO: giornale 3 intestazioni, 3 partite, 0 morte; RIPROVE 2 tentativi, 2 PARTITA, 0 MORTA_INIT"], ["EMAGEMb OK"]),
 ("morta_con_altra_causa", {C: {"legs": ["altro", "ok"]}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "un tentativo con esito diverso da PARTITA o MORTA_INIT", "MORTA_ALTRO"], ["EMAGEMc MISTO", "EMAGEMc KO"]),
 ("rp_copia_mancante_in_raccolta", {B: {"rp_nocopy": True}}, "", "ok", PC, "", "ok", {}, [OK3, "MANCA " + RPB, "FILE ATTESI TROVATI: 19 su 20   NELLO ZIP: 19 su 20"], ["MANCA " + RPA]),
 ("trades_zero_in_una_cella_di_a", {A: {"trades0": True}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK", "OK"), "NON BUONO: righe 2 (attese 2), Trades>0 su 1", CAN + "NON VERIFICABILE   EMAGEMa ha STATO NV"], ["EMAGEMa OK"]),
 ("una_riga_in_meno_su_c", {C: {"una_riga": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "righe 4 (attese 5)"], ["EMAGEMc OK"]),
 ("csv_0_byte", {B: {"csv_zero": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "contraddizione: il driver dice CSV PRODOTTO per IS e OOS ma i CSV non sono buoni (_IS 0 byte ; _OOS 0 byte)"], ["EMAGEMb OK"]),
 ("csv_vecchio", {C: {"csv_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "VECCHIO (scritto prima del job)"], ["EMAGEMc OK"]),
 ("oos_assente", {B: {"no_OOS": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "MANCA ROUND_EMAGEMb\\%s_D30EUR_OOS_EMAGEMb.csv" % EA], ["EMAGEMb OK"]),
 ("asse_TF_sbagliato", {B: {"ax_vals": [30, 16385, 16386, 16387, 16389]}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "[30/16385/16386/16387/16389] DIVERSO dall atteso 30/16385/16386/16387/16388"], ["EMAGEMb OK"]),
 ("asse_TF_ripetuto", {C: {"ax_vals": [30, 16385, 16385, 16387, 16388]}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "[30/16385/16385/16387/16388] DIVERSO dall atteso 30/16385/16386/16387/16388"], ["EMAGEMc OK"]),
 # l asse TF non arrivato: MT5 gira cinque volte la cella H1
 ("asse_TF_non_arrivato", {C: {"ax_vals": [16385, 16385, 16385, 16385, 16385]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK", "NV"), "[16385/16385/16385/16385/16385] DIVERSO dall atteso 30/16385/16386/16387/16388", "il pin dell asse NON e arrivato"], ["EMAGEMc OK"]),
 ("pin_magic_perso_su_b", {B: {"pin_bad": "InpMagic"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "PIN DEL FILE PROVA NON ARRIVATI nel CSV: _IS 5 valori diversi InpMagic=[0] atteso 766811"], ["EMAGEMb OK"]),
 ("pin_lato_short_perso_su_b", {B: {"pin_bad": "InpAllowShort"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "InpAllowShort=[0] atteso 1"], ["EMAGEMb OK"]),
 ("pin_lato_long_perso_su_a", {A: {"pin_bad": "InpAllowLong"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "InpAllowLong=[0] atteso 1", CAN + "NON VERIFICABILE"], ["EMAGEMa OK"]),
 ("pin_rischio_perso_su_c", {C: {"pin_bad": "InpRiskPercent"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "InpRiskPercent=[0] atteso 1"], ["EMAGEMc OK"]),
 ("pin_TF_di_a_perso", {A: {"pin_bad": "InpTF"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "InpTF=[0] atteso 16385"], ["EMAGEMa OK"]),
 ("colonna_assente_su_b", {B: {"col_absent": "InpEmaPeriod"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "InpEmaPeriod=[] atteso 200"], ["EMAGEMb OK"]),
 ("finestra_oos_un_giorno_prima_su_c", {C: {"win_bad": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "FINESTRA GIRATA DIVERSA DALLA DICHIARATA (classe 992)", "to 2026.06.29 00:00 su NASUSD: DIVERSA dalla dichiarata"], ["EMAGEMc OK"]),
 ("corse_precedenti_stesso_giorno", {"prima": True}, "", "ok", PC, "", "ok", {}, [OK3, "(corse precedenti dello stesso giorno, non contano): 6"], ["=NV"]),
 ("giornale_assente", {"no_logs": True}, "", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "GIORNALE DEL TESTER: NON VERIFICABILE (file *Tester_logs* trovati 0, leggibili 0)", CAN + "NON VERIFICABILE"], ["EMAGEMa OK"]),
 ("giornale_vuoto", {"tlog": "vuoto"}, "", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "giornale del tester NON VERIFICABILE"], ["EMAGEMa OK"]),
 ("gamba_di_altro_EA", {B: {"ea_other": "ABTG_Nightly"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "porta il nome di un ALTRO EA"], ["EMAGEMb OK"]),
 # classi 166/892, DOPO OGNI JOB: la mutazione nel SOLO secondo job deve colpire il secondo e non il primo ne il terzo
 ("ea_mutato_nel_secondo_job", {B: {"mut_ea": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "%s.mq5 SHA256 DIVERSO DAL PIN" % EA, "MOTORE DIVERSO DAL PIN in 1 job"], ["EMAGEMb OK", "EMAGEMa NV"]),
 ("ea_assente_su_a", {A: {"no_ea": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "%s.mq5 ASSENTE" % EA], ["EMAGEMa OK"]),
 ("include_mutato", {A: {"mut_inc": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "ABTG_PausaGuardian.mqh SHA256 DIVERSO DAL PIN"], ["EMAGEMa OK"]),
 ("walkforward_retry_mutato", {C: {"mut_wf": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "walkforward_generico_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["EMAGEMc OK"]),
 ("walkforward_retry_assente", {A: {"no_wf": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "walkforward_generico_RETRY.ps1 ASSENTE"], ["EMAGEMa OK"]),
 # classe 1028: l ORIGINALE (senza riprova) salvato col nome della copia porta i marcatori vecchi ma non lo SHA del pin
 ("walkforward_originale_col_nome_RETRY", {A: {"wf_originale": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "walkforward_generico_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["EMAGEMa OK"]),
 ("riga_retry_locale_mutata_durante_il_terzo_job", {C: {"mut_drvloc": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "RIGA_ROUND_VPS_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["EMAGEMc OK", "EMAGEMb NV"]),
 # mutata durante il SECONDO job: la copia locale resta mutata, quindi il secondo la vede e anche il terzo (non la riscarica nessuno): e voluto
 ("riga_retry_locale_mutata_durante_il_secondo_job", {B: {"mut_drvloc": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "NV"), "RIGA_ROUND_VPS_RETRY.ps1 SHA256 DIVERSO DAL PIN", "MOTORE DIVERSO DAL PIN in 2 job"], ["EMAGEMb OK", "EMAGEMa NV"]),
 ("prova_mutata", {C: {"mut_prova": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "prova SHA256 DIVERSO DAL PIN"], ["EMAGEMc OK"]),
 # il referto del driver (classi 1019 e 1032)
 ("referto_assente", {A: {"ref_absent": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "REFERTO DEL DRIVER ASSENTE", "MANCA ROUND_EMAGEMa\\REFERTO_ROUND_EMAGEMa.txt"], ["EMAGEMa OK"]),
 ("referto_vecchio_sul_desktop", {A: {"ref_absent": True}}, "", "ok", PC, "", "ok", {"PRE_OLD": A}, [ST("NV", "OK", "OK"), "tolta la cartella di una corsa PRECEDENTE: ROUND_EMAGEMa", "REFERTO DEL DRIVER ASSENTE"], ["EMAGEMa OK"]),
 ("referto_non_riscritto", {B: {"ref_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "REFERTO DEL DRIVER VECCHIO (scritto prima del job: NON e di questa corsa)"], ["EMAGEMb OK"]),
 ("referto_terminale_banco_VPS", {A: {"ref_term": "C:\\MT5_Backtest\\terminal64.exe"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "terminale C:\\MT5_Backtest\\terminal64.exe", "DIVERSO DALLA RIGA"], ["EMAGEMa OK"]),
 ("referto_driver_originale", {A: {"ref_driver": "walkforward_generico.ps1"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK", "OK"), "driver walkforward_generico.ps1, riprova", "DIVERSO DALLA RIGA (attesi deposito 100000"], ["EMAGEMa OK"]),
 # la cartella vecchia che NON si lascia togliere: la riga si ferma PRIMA di aprire MT5 (classe 1032)
 ("cartella_vecchia_non_rimovibile", {}, "", "ok", PC, "", "ok", {"PRE_OLD": B, "NO_RM": B}, ["NON riesco a togliere la cartella di una corsa PRECEDENTE", "ROUND_EMAGEMb", NOSTUB], FERMA + ["tolta la cartella"]),
 # lo zip che perde una voce: la cartella e completa, il pacco no (classi 1021/1033)
 ("zip_senza_un_file", {}, "", "ok", PC, "", "ok", {"ZIP_DROP": "RIPROVE_%s_D30EUR_EMAGEMb" % EA}, [OK3, "FILE ATTESI TROVATI: 20 su 20   NELLO ZIP: 19 su 20", "nello zip: NO"], ["NELLO ZIP: 20 su 20"]),
 ("zip_vecchio", {}, "", "ok", PC, "", "ok", {"ZIP_STALE": "1"}, [OK3, "ZIP VECCHIO (scritto prima di questa raccolta, NON e di questa corsa)", "FILE ATTESI TROVATI: 20 su 20   NELLO ZIP: 0 su 20"], ["ZIP PRONTO DA MANDARE"]),
 ("CE11_zip_senza_riepilogo", {}, "", "ok", PC, "", "ok", {"ZIP_DROP": "RIEPILOGO_ROUND_EMAGEM"}, [OK3, "NELLO ZIP: 19 su 20"], ["NELLO ZIP: 20 su 20"]),
 # magic del file prova contro la riga (difesa in profondita': il file e' gia' pinnato per SHA). Per raggiungerla si cambiano INSIEME la tabella dei job
 # e il suo controllo di coerenza: il file scaricato dice 766811, la riga dice 766812.
 ("riga_magic_diverso_dal_file", {}, r"s/mg='766811';/mg='766812';/; s/\$jobs\[1\].mg -ne '766811'/$jobs[1].mg -ne '766812'/", "ok", PC, "", "ok", {},
  [ST("OK", "NV", "OK"), "(magic atteso 766812, due lati e rischio 1 attesi)"], ["EMAGEMb OK"]),
 # gli argomenti passati al driver (classe 1019): li dice il referto, non la riga
 ("deposito_non_passato", {}, r"s/ -Deposito \$jb.dp / /", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "deposito 10000, modello 4", CAN + "NON VERIFICABILE"], ["EMAGEMa OK"]),
 ("modello_1_passato", {}, r"s/-Modello \$jb.m /-Modello 1 /", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "modello 1, driver"], ["EMAGEMa OK"]),
 ("pin_diverso_passato", {}, r"s/-Pin \$PIN /-Pin lavoro /", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "referto: pin lavoro,"], ["EMAGEMa OK"]),
 ("maxriprove_0_passato", {}, r"s/-MaxRiprove \$MAXRIP /-MaxRiprove 0 /", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "riprova [MaxRiprove 0   attesa 20 s"], ["EMAGEMa OK"]),
 ("scadenza_non_passata", {}, r"s/ -RiprovaEntro \$scadTxt;/;/", "ok", PC, "", "ok", {}, [ST("NV", "NV", "NV"), "scadenza nessuna] DIVERSO DALLA RIGA"], ["EMAGEMa OK"]),
 # il tetto fra i job: orologio spostato di 45 minuti per UN solo job (modifica di banco, non della riga vera)
 ("tetto_secondo_job_non_lanciato", {}, CLOCK(B), "ok", PC, "", "ok", {},
  [ST("OK", "NON LANCIATO", "OK"), "=== EMAGEMb: NON LANCIATO (tetto di 40 minuti", "FILE ATTESI TROVATI: 14 su 14   NELLO ZIP: 14 su 14", "ROUND LANCIATI: 2 su 3   NON LANCIATI (tetto): 1", CAN + "PASS"], ["EMAGEMb OK", "EMAGEMb NV"]),
 ("tetto_terzo_job_non_lanciato", {}, CLOCK(C), "ok", PC, "", "ok", {},
  [ST("OK", "OK", "NON LANCIATO"), "=== EMAGEMc: NON LANCIATO (tetto di 40 minuti", "FILE ATTESI TROVATI: 14 su 14   NELLO ZIP: 14 su 14", "ROUND LANCIATI: 2 su 3   NON LANCIATI (tetto): 1"], ["EMAGEMc OK", "EMAGEMc NV"]),
 # il per-trade e INFORMATIVO (classe 455): non cambia lo stato, ma si dice cosa e (a ne ha DUE, uno per magic)
 ("pertrade_vecchio_su_a", {A: {"pertrade_stale": True}}, "", "ok", PC, "", "ok", {},
  [OK3, "PERTRADE EMAGEMa abtg_trades_%s_U30USD_766801.csv: assente in Common\\Files o scritto prima del job" % EA, "PERTRADE EMAGEMa abtg_trades_%s_U30USD_766802.csv: assente in Common\\Files o scritto prima del job" % EA,
   "MANCA PERTRADE\\abtg_trades_%s_U30USD_766801.csv" % EA, "MANCA PERTRADE\\abtg_trades_%s_U30USD_766802.csv" % EA, "FILE ATTESI TROVATI: 18 su 20"], ["=NV"]),
 ("pertrade_solo_IS_su_b", {B: {"pertrade_ct": ["2024.10.01 08:10:00", "2025.06.09 08:40:00"]}}, "", "ok", PC, "", "ok", {}, [OK3, "2 deal di uscita, gamba IS (ultima chiusura 2025.06.09 08:40:00)"], ["=NV"]),
 ("pertrade_magic_estraneo_su_a", {A: {"pertrade_mg": "763300"}}, "", "ok", PC, "", "ok", {}, [OK3, "righe con magic diverso da 766801: 3", "righe con magic diverso da 766802: 3"], ["=NV"]),
 # i cancelli PRIMA del job: la riga si ferma, lo stub NON viene chiamato
 ("riga_incoerente_deposito", {}, r"s/dp=100000;/dp=10000;/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_asse_a", {}, r"s/av=@(766801,766802)/av=@(766801,766803)/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_asse_TF_di_c", {}, r"s/av=@(30,16385,16386,16387,16388); nr=5; mg='766821'/av=@(30,16385,16386,16387,16389); nr=5; mg='766821'/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_magic", {}, r"s/mg='766821';/mg='766822';/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_magic_di_a_pinnato", {}, r"s/mg=''; pm=/mg='766801'; pm=/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_input", {}, r"s/np=42;/np=41;/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_frazione", {}, r"s/fz='0.40';/fz='0.50';/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_simbolo", {}, r"s/s='NASUSD'/s='SPXUSD'/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_ordine_dei_job", {}, r"s/'EMAGEMa,EMAGEMb,EMAGEMc'/'EMAGEMb,EMAGEMa,EMAGEMc'/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_tetto", {}, r"s/\$TETTO=40;/$TETTO=45;/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_margine", {}, r"s/\$MARGINE=10;/$MARGINE=0;/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_maxriprove", {}, r"s/\$MAXRIP=1;/$MAXRIP=2;/", "ok", PC, "", "ok", {}, ["RIGA EMAGEM INCOERENTE", NOSTUB], FERMA),
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
 ("CE1_riprove_dichiara_riprova_che_il_giornale_non_ha", {B: {"legs": ["ko_ok", "ok"], "rp_fake_retry": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "NON TORNANO: giornale 2 intestazioni, 2 partite, 0 morte"], ["EMAGEMb OK"]),
 ("CE2_riprova_OOS_gira_la_finestra_IS", {C: {"legs": ["ok", "ko_ok"], "retry_win_is": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "OK", "NV"), "FINESTRA GIRATA DIVERSA DALLA DICHIARATA"], ["EMAGEMc OK"]),
 ("CE3_csv_di_un_altra_cella", {B: {"pin_over": {"InpMagic": "766821"}}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "InpMagic=[766821] atteso 766811"], ["EMAGEMb OK"]),
 ("CE3b_csv_altra_cella_un_lato_solo", {B: {"pin_over": {"InpAllowShort": "0"}}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "InpAllowShort=[0] atteso 1"], ["EMAGEMb OK"]),
 ("CE4_morte_senza_causa_ma_riprove_dice_INIT", {B: {"legs": ["ko_ok", "ok"], "dead_nocause": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "NON TORNANO: giornale 3 intestazioni, 2 partite, 0 morte"], ["EMAGEMb OK"]),
 ("CE8_una_salvata_una_morta_due_volte", {C: {"legs": ["ko_ok", "ko_ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK", "MISTO"), "GAMBE RIPROVATE DAL DRIVER: 2 (EMAGEMc IS,OOS)", "giornale: intestazioni 4 partite 1 morte 3"], ["EMAGEMc OK", "EMAGEMc NV"]),
 ("CE10_riprove_senza_flag_RIPROVATA", {B: {"legs": ["ko_ok", "ok"], "rp_no_rip": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV", "OK"), "file RIPROVE INCOERENTE"], ["EMAGEMb OK"]),
 ("CE12_tre_job_riprovati", {A: {"legs": ["ok", "ko_ok"]}, B: {"legs": ["ko_ok", "ok"]}, C: {"legs": ["ko_ok", "ko_ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK_RIPROVATO", "OK_RIPROVATO", "OK_RIPROVATO"), "GAMBE RIPROVATE DAL DRIVER: 4 (EMAGEMa OOS, EMAGEMb IS, EMAGEMc IS,OOS)", "FILE ATTESI TROVATI: 20 su 20", CAN + "PASS"], ["=NV", "GAMBE SENZA CSV", "NON SI LEGGE"]),
 # la stima dei tempi: console e RIEPILOGO dicono lo STESSO numero (classe 1050)
 ("stima_tempi_console_uguale_riepilogo", {}, "", "ok", PC, "", "ok", {},
  [OK3, "TEMPO: [STIMA] circa 10-34 minuti in tutto se nessuna gamba muore", "RIEP:dichiarato [STIMA] circa 10-34 minuti, circa 2,5 in piu per gamba riprovata, tetto 40",
   "Circa 2,5 minuti in piu per ogni gamba che muore e viene riprovata", "scadenza ", "(T0 + 40 - 10 minuti"], ["circa 1,5 in piu", "circa 80 s", "3-5 minuti", "8-34", "tetto 20"]),
]

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
            rf = os.path.join(dk, x, "RIEPILOGO_ROUND_EMAGEM.txt")
            if x.startswith("ROUND_EMAGEM_") and os.path.isfile(rf):
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
    for l, (lbl, prv) in zip(righe, ((A, "EMAGEM_a_ancora_U30USD_H1_LS.txt"), (B, "EMAGEM_b_D30EUR_LS_tf.txt"), (C, "EMAGEM_c_NASUSD_LS_tf.txt"))):
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
