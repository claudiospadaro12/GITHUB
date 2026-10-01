#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
battery.py -- il collaudo a macchina di RIGA_ROUND_DAXAP03.txt (DUE job, driver con la riprova). Stessa forma di collaudo_riga_DAXAP02/battery.py.

Fa girare la riga VERA sotto pwsh (Linux, PowerShell 7) con un driver FINTO (stub_driver.py) che scrive, per ciascun job, CSV IS/OOS nel formato
di OptFrame, un giornale del tester UTF-16 con le righe VERE e UNA intestazione per tentativo, il file RIPROVE nelle righe di
walkforward_generico_RETRY.ps1, il per-trade in Common\\Files e il REFERTO della riga RETRY (pin/macchina/terminale/deposito/modello/driver/riprova);
`irm` servito da un magazzino locale (righe/RIGA_ROUND_VPS_RETRY.ps1 AL PIN, via git show); un disco C: finto. Due scenari usano i CSV VERI di R246i.
Verifica che OK / OK_RIPROVATO / KO / MISTO / NV / NON LANCIATO scattino job per job quando devono e NON scattino quando non devono, e che i
cancelli della riga reggano. NON prova: Windows PowerShell 5.1, MT5, il tester, il tempo vero, la rete, GitHub raw, il driver vero.
Uso:  python3 backtest_pipeline/collaudo_riga_DAXAP03/battery.py [PIN] [RIGA] [nomi...]   (esce 0 se tutto come atteso). Serve: pwsh, python3, iconv, git.
"""
import json, os, re, subprocess, sys, datetime as dt
from concurrent.futures import ThreadPoolExecutor
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
OUT = os.environ.get("HARNESS_OUT", "/tmp/daxap03_harness")
os.makedirs(OUT, exist_ok=True)
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = sys.argv[2] if len(sys.argv) > 2 else os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_DAXAP03.txt")
PC = "DESKTOP-H4D7CAJ"
A, B = "DAXAP03a", "DAXAP03b"
EA = "ABTG_MaxMinNotte_DAX_Short_Ottimizzato"
def ST(a, b):
    return "STATO: DAXAP03a=%s DAXAP03b=%s" % (a, b)
OK2 = ST("OK", "OK")
FERMA = ["DAXAP03a OK", "DAXAP03a NV", "DAXAP03b NV", "RACCOLTA:", "STATO: DAXAP03a"]   # una riga fermata dai cancelli NON arriva agli stati ne alla raccolta
NOSTUB = "__NOSTUB__"            # lo stub NON deve essere stato chiamato
STUBARGS = "__STUBARGS__"        # lo stub deve aver ricevuto, per OGNI job, gli argomenti esatti (scadenza = T0 + 17 minuti, con lo spazio)
RPA = "ROUND_DAXAP03a\\RIPROVE_%s_D30EUR_DAXAP03a.txt" % EA
RPB = "ROUND_DAXAP03b\\RIPROVE_%s_D30EUR_DAXAP03b.txt" % EA
CLOCK = r"s/\$minAvv=\[int\](((Get-Date)-\$T0).TotalMinutes);/$minAvv=[int](((Get-Date)-$T0).TotalMinutes) + $(if($LBL -eq 'DAXAP03b'){25}else{0});/"
# (nome, scenario, sed, grafici, macchina, mutazione servita, terminale, env extra, [DEVE esserci], [NON deve esserci])
T = [
 ("ok", {}, "", "ok", PC, "", "ok", {},
  [OK2, STUBARGS, "pin numerici confrontati: _IS 141 _OOS 141 (attesi 141 per gamba, piu 3 stringhe NON confrontate e l asse)",
   "pin numerici confrontati: _IS 188 _OOS 188 (attesi 188 per gamba", "giornale: intestazioni 2 partite 2 morte 0   RIPROVE: IS: PARTITA, CSV PRODOTTO; OOS: PARTITA, CSV PRODOTTO;",
   "[from 2024.09.26 00:00 to 2025.06.09 00:00 su D30EUR: = IS dichiarata] [from 2025.06.10 00:00 to 2026.06.30 00:00 su D30EUR: = OOS dichiarata]",
   "terminale C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe, deposito 100000, modello 4, driver walkforward_generico_RETRY.ps1, riprova [MaxRiprove 1   attesa 20 s   scadenza ",
   "GUARDIA EA: grafici salvati letti 2, con un EA attaccato o illeggibili 0", "asse InpPlaceMin [59/60/61] ok", "asse InpPlaceMin [0/5/10/15] ok",
   "FILE ATTESI TROVATI: 13 su 13   NELLO ZIP: 13 su 13", "ZIP PRONTO DA MANDARE", "OK    " + RPA, "OK    " + RPB,
   "DAXAP03a IS   InpPlaceHour  7  InpPlaceMin 59", "DAXAP03b OOS  InpPlaceHour  8  InpPlaceMin 15", "CATENA COMPLETA: 2 cartelle del driver su 2 job lanciati",
   "motore = pin (SHA256, EA + include + walkforward_generico_RETRY + RIGA_ROUND_VPS_RETRY)", "NON ha svuotato Tester\\cache", "MARCATORE_RIGA_ROUND_DAXAP03_v1",
   "righe con magic diverso da 798103: 0", "righe con magic diverso da 798104: 0",
   "ROUND LANCIATI: 2 su 2   NON LANCIATI (tetto): 0   PARTITI (rc diverso da 1): 2 su 2   MOTORE DIVERSO DAL PIN in 0 job", "=== RIEPILOGO ===",
   "direttive, input, magic e InpPlaceHour: = riga (51 input, asse InpPlaceMin, nessuna @DEPOSITO)"],
  ["MOTIVO: ", "MANCA ", "SHA256 DIVERSO", "DIVERSO DALLA RIGA", "DIVERSI dalla", "DIVERSO dall atteso", "DIVERSA dalla", "=NV", " NV   rc", "GAMBE SENZA CSV", "GAMBE RIPROVATE", "=OK_RIPROVATO", "MOTORE DIVERSO DAL PIN:"]),
 # i CSV VERI di R246i (24/09, stesso EA e finestra) portati alla forma attesa: il parser regge l intestazione vera (60 colonne, InpComment con spazi)
 ("csv_veri_R246i_corretti", {"real_csv": "patch"}, "", "ok", PC, "", "ok", {}, [OK2, "pin numerici confrontati: _IS 141 _OOS 141", "Profit    4766.96   PF  1.87803", "Profit    6143.38   PF  2.15985"], ["MOTIVO: "]),
 # i CSV VERI di R246i con InpPlaceMin 59 e InpPlaceHour 7 dappertutto = il pin dell asse NON arrivato: NV, mai OK
 ("csv_veri_R246i_pin_perso", {"real_csv": "pin_perso"}, "", "ok", PC, "", "ok", {},
  [ST("NV", "NV"), "asse InpPlaceMin [59/59/59] DIVERSO dall atteso 59/60/61", "asse InpPlaceMin [59/59/59/59] DIVERSO dall atteso 0/5/10/15", "il pin dell asse NON e arrivato"], ["DAXAP03a OK", "DAXAP03b OK"]),
 # MANDATO: job 1 OK e job 2 con una gamba MORTA (oltre la scadenza: nessuna riprova)
 ("job1_ok_job2_gamba_morta", {B: {"legs": ["ok", "ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "MISTO"), "DAXAP03b MISTO   rc 2", "giornale: intestazioni 2 partite 1 morte 1   RIPROVE: IS: PARTITA, CSV PRODOTTO; OOS: MORTA_INIT, CSV NON PRODOTTO;",
   "gamba OOS MORTA in OnTesterInit e non salvata dalla riprova", "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 1 (DAXAP03b 1 su 2", "NON e una replica", "RIPESCATE dalla cache", "FrameAdd r.584",
   "MANCA ROUND_DAXAP03b\\%s_D30EUR_OOS_DAXAP03b.csv" % EA, "OK    " + RPB, "FILE ATTESI TROVATI: 12 su 13   NELLO ZIP: 12 su 13"], ["DAXAP03a NV", "DAXAP03b OK", "GAMBE RIPROVATE"]),
 # classe 1030: la gamba morta e SALVATA al secondo tentativo lascia 3 intestazioni nel giornale: OK_RIPROVATO, NON NV
 ("job2_gamba_riprovata_e_salvata", {B: {"legs": ["ko_ok", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "OK_RIPROVATO"), "DAXAP03b OK_RIPROVATO   rc 3", "giornale: intestazioni 3 partite 2 morte 1", "RIPROVE: IS: MORTA_INIT poi PARTITA RIPROVATA, CSV PRODOTTO;",
   "GAMBE RIPROVATE DAL DRIVER: 1 (DAXAP03b IS)", "RILIEVO, non un difetto: gamba IS", "FILE ATTESI TROVATI: 13 su 13   NELLO ZIP: 13 su 13", "asse InpPlaceMin [0/5/10/15] ok"],
  ["DAXAP03b NV", "GAMBE SENZA CSV", "MANCA "]),
 ("job1_due_gambe_riprovate_e_salvate", {A: {"legs": ["ko_ok", "ko_ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("OK_RIPROVATO", "OK"), "giornale: intestazioni 4 partite 2 morte 2", "GAMBE RIPROVATE DAL DRIVER: 2 (DAXAP03a IS,OOS)", "gamba IS e OOS morta in OnTesterInit"], ["DAXAP03a NV", "GAMBE SENZA CSV"]),
 ("job1_gamba_morta_due_volte", {A: {"legs": ["ko_ko", "ok"]}}, "", "ok", PC, "", "ok", {},
  [ST("MISTO", "OK"), "giornale: intestazioni 3 partite 1 morte 2", "RIPROVE: IS: MORTA_INIT poi MORTA_INIT RIPROVATA, CSV NON PRODOTTO;", "GAMBE RIPROVATE DAL DRIVER: 1 (DAXAP03a IS)",
   "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 1 (DAXAP03a 1 su 2"], ["DAXAP03a NV", "DAXAP03a OK"]),
 ("ko_quattro_tentativi_morti", {A: {"legs": ["ko_ko", "ko_ko"]}}, "", "ok", PC, "", "ok", {},
  [ST("KO", "OK"), "DAXAP03a KO   rc 2", "giornale: intestazioni 4 partite 0 morte 4", "GAMBE SENZA CSV A FINE JOB (morte due volte, o non riprovate perche oltre la scadenza: lo dice il RIPROVE): 2 (DAXAP03a 2 su 2", "MANCA PERTRADE\\abtg_trades_%s_D30EUR_798103.csv" % EA,
   "OK    ROUND_DAXAP03a\\REFERTO_ROUND_DAXAP03a.txt", "OK    " + RPA], ["DAXAP03a NV", "DAXAP03a OK"]),
 ("ko_ma_csv_fresco", {A: {"legs": ["ko", "ko"], "csv_anyway": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "il driver dice CSV NON PRODOTTO per IS e OOS ma esiste un CSV fresco"], ["DAXAP03a KO"]),
 ("misto_ma_csv_morto_fresco", {A: {"legs": ["ok", "ko"], "csv_anyway": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "il driver dice CSV NON PRODOTTO per la gamba OOS ma il suo CSV e fresco"], ["DAXAP03a MISTO"]),
 # il file RIPROVE e la sola misura delle gambe con la riprova: assente, vecchio, monco o incoerente = NV
 ("riprove_assente_con_gamba_riprovata", {B: {"legs": ["ko_ok", "ok"], "rp_absent": True}}, "", "ok", PC, "", "ok", {},
  [ST("OK", "NV"), "file RIPROVE del driver ASSENTE: non so quante volte e stata lanciata ogni gamba (classe 1030)", "MANCA " + RPB], ["DAXAP03b OK"]),
 ("riprove_vecchio", {A: {"rp_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "file RIPROVE del driver VECCHIO (scritto prima del job)"], ["DAXAP03a OK"]),
 ("riprove_una_gamba", {A: {"rp_una_gamba": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "file RIPROVE del driver con 1 righe GAMBA"], ["DAXAP03a OK"]),
 ("riprove_incoerente", {A: {"legs": ["ko", "ok"], "rp_dice_prodotto": "IS"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "file RIPROVE INCOERENTE"], ["DAXAP03a MISTO"]),
 ("giornale_e_riprove_non_tornano", {A: {"extra_leg": True}}, "", "ok", PC, "", "ok", {},
  [ST("NV", "OK"), "il giornale del tester e il file RIPROVE NON TORNANO: giornale 3 intestazioni, 3 partite, 0 morte; RIPROVE 2 tentativi, 2 PARTITA, 0 MORTA_INIT"], ["DAXAP03a OK"]),
 ("morta_con_altra_causa", {A: {"legs": ["altro", "ok"]}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "un tentativo con esito diverso da PARTITA o MORTA_INIT", "MORTA_ALTRO"], ["DAXAP03a MISTO", "DAXAP03a KO"]),
 ("rp_copia_mancante_in_raccolta", {B: {"rp_nocopy": True}}, "", "ok", PC, "", "ok", {}, [OK2, "MANCA " + RPB, "FILE ATTESI TROVATI: 12 su 13   NELLO ZIP: 12 su 13"], ["MANCA " + RPA]),
 ("trades_zero_in_una_cella", {A: {"trades0": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "NON BUONO: righe 3 (attese 3), Trades>0 su 2"], ["DAXAP03a OK"]),
 ("una_riga_in_meno", {B: {"una_riga": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "righe 3 (attese 4)"], ["DAXAP03b OK"]),
 ("csv_0_byte", {A: {"csv_zero": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "contraddizione: il driver dice CSV PRODOTTO per IS e OOS ma i CSV non sono buoni (_IS 0 byte ; _OOS 0 byte)"], ["DAXAP03a OK"]),
 ("csv_vecchio", {A: {"csv_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "VECCHIO (scritto prima del job)"], ["DAXAP03a OK"]),
 ("oos_assente", {A: {"no_OOS": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "MANCA ROUND_DAXAP03a\\%s_D30EUR_OOS_DAXAP03a.csv" % EA], ["DAXAP03a OK"]),
 ("asse_sbagliato", {A: {"ax_vals": [59, 60, 62]}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "[59/60/62] DIVERSO dall atteso 59/60/61"], ["DAXAP03a OK"]),
 ("asse_ripetuto", {B: {"ax_vals": [0, 5, 5, 15]}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "[0/5/5/15] DIVERSO dall atteso 0/5/10/15"], ["DAXAP03b OK"]),
 # MANDATO: l asse NON arrivato (MT5 gira quattro volte la cella 08:00)
 ("asse_non_arrivato", {B: {"ax_vals": [0, 0, 0, 0]}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "[0/0/0/0] DIVERSO dall atteso 0/5/10/15", "il pin dell asse NON e arrivato"], ["DAXAP03b OK"]),
 ("pin_placehour_perso", {B: {"pin_bad": "InpPlaceHour"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "PIN DEL FILE PROVA NON ARRIVATI nel CSV: _IS 4 valori diversi InpPlaceHour=[0] atteso 8"], ["DAXAP03b OK"]),
 ("pin_magic_perso", {A: {"pin_bad": "InpMagic"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "InpMagic=[0] atteso 798103"], ["DAXAP03a OK"]),
 ("pin_bool_perso", {A: {"pin_bad": "InpAllowShort"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "InpAllowShort=[0] atteso 1"], ["DAXAP03a OK"]),
 ("colonna_placehour_assente", {A: {"col_absent": "InpPlaceHour"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "InpPlaceHour=[] atteso 7"], ["DAXAP03a OK"]),
 ("finestra_oos_un_giorno_prima", {B: {"win_bad": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "FINESTRA GIRATA DIVERSA DALLA DICHIARATA (classe 992)", "to 2026.06.29 00:00 su D30EUR: DIVERSA dalla dichiarata"], ["DAXAP03b OK"]),
 ("corse_precedenti_stesso_giorno", {"prima": True}, "", "ok", PC, "", "ok", {}, [OK2, "(corse precedenti dello stesso giorno, non contano): 4"], ["=NV"]),
 ("giornale_assente", {"no_logs": True}, "", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "GIORNALE DEL TESTER: NON VERIFICABILE (file *Tester_logs* trovati 0, leggibili 0)"], ["DAXAP03a OK"]),
 ("giornale_vuoto", {"tlog": "vuoto"}, "", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "giornale del tester NON VERIFICABILE"], ["DAXAP03a OK"]),
 ("gamba_di_altro_EA", {B: {"ea_other": "ABTG_EMA200"}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "porta il nome di un ALTRO EA"], ["DAXAP03b OK"]),
 ("rc1_sul_primo_job", {A: {"rc1": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "rc 1: il driver si e fermato con un ERRORE", "motore NON VERIFICATO (driver uscito con rc 1)", "MANCA ROUND_DAXAP03a\\REFERTO_ROUND_DAXAP03a.txt"], ["DAXAP03a OK"]),
 # classi 166/892, DOPO OGNI JOB: la mutazione nel SOLO secondo job deve colpire il secondo e non il primo
 ("ea_mutato_nel_secondo_job", {B: {"mut_ea": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "%s.mq5 SHA256 DIVERSO DAL PIN" % EA, "MOTORE DIVERSO DAL PIN in 1 job"], ["DAXAP03b OK"]),
 ("ea_assente", {A: {"no_ea": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "%s.mq5 ASSENTE" % EA], ["DAXAP03a OK"]),
 ("include_mutato", {A: {"mut_inc": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "ABTG_PausaGuardian.mqh SHA256 DIVERSO DAL PIN"], ["DAXAP03a OK"]),
 ("walkforward_retry_mutato", {B: {"mut_wf": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "walkforward_generico_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["DAXAP03b OK"]),
 ("walkforward_retry_assente", {A: {"no_wf": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "walkforward_generico_RETRY.ps1 ASSENTE"], ["DAXAP03a OK"]),
 # classe 1028: l ORIGINALE (senza riprova) salvato col nome della copia porta i marcatori vecchi ma non lo SHA del pin
 ("walkforward_originale_col_nome_RETRY", {A: {"wf_originale": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "walkforward_generico_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["DAXAP03a OK"]),
 ("riga_retry_locale_mutata_durante_il_job", {B: {"mut_drvloc": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "RIGA_ROUND_VPS_RETRY.ps1 SHA256 DIVERSO DAL PIN"], ["DAXAP03b OK"]),
 ("prova_mutata", {B: {"mut_prova": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "prova SHA256 DIVERSO DAL PIN"], ["DAXAP03b OK"]),
 # il referto del driver (classi 1019 e 1032)
 ("referto_assente", {A: {"ref_absent": True}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "REFERTO DEL DRIVER ASSENTE", "MANCA ROUND_DAXAP03a\\REFERTO_ROUND_DAXAP03a.txt"], ["DAXAP03a OK"]),
 ("referto_vecchio_sul_desktop", {A: {"ref_absent": True}}, "", "ok", PC, "", "ok", {"PRE_OLD": A}, [ST("NV", "OK"), "tolta la cartella di una corsa PRECEDENTE: ROUND_DAXAP03a", "REFERTO DEL DRIVER ASSENTE"], ["DAXAP03a OK"]),
 ("referto_non_riscritto", {B: {"ref_stale": True}}, "", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "REFERTO DEL DRIVER VECCHIO (scritto prima del job: NON e di questa corsa)"], ["DAXAP03b OK"]),
 ("referto_terminale_banco_VPS", {A: {"ref_term": "C:\\MT5_Backtest\\terminal64.exe"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "terminale C:\\MT5_Backtest\\terminal64.exe", "DIVERSO DALLA RIGA"], ["DAXAP03a OK"]),
 ("referto_driver_originale", {A: {"ref_driver": "walkforward_generico.ps1"}}, "", "ok", PC, "", "ok", {}, [ST("NV", "OK"), "driver walkforward_generico.ps1, riprova", "DIVERSO DALLA RIGA (attesi deposito 100000"], ["DAXAP03a OK"]),
 # la cartella vecchia che NON si lascia togliere: la riga si ferma PRIMA di aprire MT5 (classe 1032)
 ("cartella_vecchia_non_rimovibile", {}, "", "ok", PC, "", "ok", {"PRE_OLD": B, "NO_RM": B}, ["NON riesco a togliere la cartella di una corsa PRECEDENTE", "ROUND_DAXAP03b", NOSTUB], FERMA + ["tolta la cartella"]),
 # lo zip che perde una voce: la cartella e completa, il pacco no (classi 1021/1033)
 ("zip_senza_un_file", {}, "", "ok", PC, "", "ok", {"ZIP_DROP": "RIPROVE_%s_D30EUR_DAXAP03b" % EA}, [OK2, "FILE ATTESI TROVATI: 13 su 13   NELLO ZIP: 12 su 13", "nello zip: NO"], ["NELLO ZIP: 13 su 13"]),
 ("zip_vecchio", {}, "", "ok", PC, "", "ok", {"ZIP_STALE": "1"}, [OK2, "ZIP VECCHIO (scritto prima di questa raccolta, NON e di questa corsa)", "FILE ATTESI TROVATI: 13 su 13   NELLO ZIP: 0 su 13"], ["ZIP PRONTO DA MANDARE"]),
 # magic e InpPlaceHour del file prova contro la riga (difesa in profondita': il file e' gia' pinnato per SHA). Per raggiungerla si cambiano INSIEME
 # la tabella dei job e il suo controllo di coerenza: il file scaricato dice 8, la riga dice 9.
 ("riga_placehour_diversa_dal_file", {}, r"s/ph=8;/ph=9;/; s/\$jobs\[1\].ph -ne 8/$jobs[1].ph -ne 9/", "ok", PC, "", "ok", {}, [ST("OK", "NV"), "(magic atteso 798104, InpPlaceHour atteso 9)"], ["DAXAP03b OK"]),
 # gli argomenti passati al driver (classe 1019): li dice il referto, non la riga
 ("deposito_non_passato", {}, r"s/ -Deposito \$jb.dp / /", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "deposito 10000, modello 4"], ["DAXAP03a OK"]),
 ("modello_1_passato", {}, r"s/-Modello \$jb.m /-Modello 1 /", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "modello 1, driver"], ["DAXAP03a OK"]),
 ("pin_diverso_passato", {}, r"s/-Pin \$PIN /-Pin lavoro /", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "referto: pin lavoro,"], ["DAXAP03a OK"]),
 ("maxriprove_0_passato", {}, r"s/-MaxRiprove \$MAXRIP /-MaxRiprove 0 /", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "riprova [MaxRiprove 0   attesa 20 s"], ["DAXAP03a OK"]),
 ("scadenza_non_passata", {}, r"s/ -RiprovaEntro \$scadTxt;/;/", "ok", PC, "", "ok", {}, [ST("NV", "NV"), "scadenza nessuna] DIVERSO DALLA RIGA"], ["DAXAP03a OK"]),
 # il tetto fra i job: orologio spostato di 25 minuti per il SOLO secondo job (modifica di banco, non della riga vera)
 ("tetto_secondo_job_non_lanciato", {}, CLOCK, "ok", PC, "", "ok", {},
  [ST("OK", "NON LANCIATO"), "=== DAXAP03b: NON LANCIATO (tetto di 20 minuti", "FILE ATTESI TROVATI: 7 su 7   NELLO ZIP: 7 su 7", "ROUND LANCIATI: 1 su 2   NON LANCIATI (tetto): 1"], ["DAXAP03b OK", "DAXAP03b NV"]),
 # il per-trade e INFORMATIVO (classe 455): non cambia lo stato, ma si dice cosa e
 ("pertrade_vecchio", {A: {"pertrade_stale": True}}, "", "ok", PC, "", "ok", {}, [OK2, "PERTRADE DAXAP03a abtg_trades_%s_D30EUR_798103.csv: assente in Common\\Files o scritto prima del job" % EA, "MANCA PERTRADE\\abtg_trades_%s_D30EUR_798103.csv" % EA], ["=NV"]),
 ("pertrade_solo_IS", {B: {"pertrade_ct": ["2024.10.01 08:10:00", "2025.06.09 08:40:00"]}}, "", "ok", PC, "", "ok", {}, [OK2, "2 deal di uscita, gamba IS (ultima chiusura 2025.06.09 08:40:00)"], ["=NV"]),
 ("pertrade_magic_estraneo", {A: {"pertrade_mg": "794621"}}, "", "ok", PC, "", "ok", {}, [OK2, "righe con magic diverso da 798103: 3"], ["=NV"]),
 # i cancelli PRIMA del job: la riga si ferma, lo stub NON viene chiamato
 ("riga_incoerente_deposito", {}, r"s/dp=100000;/dp=10000;/", "ok", PC, "", "ok", {}, ["RIGA DAXAP03 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_asse", {}, r"s/av=@(59,60,61)/av=@(59,60,62)/", "ok", PC, "", "ok", {}, ["RIGA DAXAP03 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_magic", {}, r"s/mg='798104'/mg='798105'/", "ok", PC, "", "ok", {}, ["RIGA DAXAP03 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_placehour", {}, r"s/ph=8;/ph=7;/", "ok", PC, "", "ok", {}, ["RIGA DAXAP03 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_input", {}, r"s/np=51;/np=50;/", "ok", PC, "", "ok", {}, ["RIGA DAXAP03 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_frazione", {}, r"s/fz='0.40';/fz='0.50';/", "ok", PC, "", "ok", {}, ["RIGA DAXAP03 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_tetto", {}, r"s/\$TETTO=20;/$TETTO=45;/", "ok", PC, "", "ok", {}, ["RIGA DAXAP03 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_margine", {}, r"s/\$MARGINE=3;/$MARGINE=0;/", "ok", PC, "", "ok", {}, ["RIGA DAXAP03 INCOERENTE", NOSTUB], FERMA),
 ("riga_incoerente_maxriprove", {}, r"s/\$MAXRIP=1;/$MAXRIP=2;/", "ok", PC, "", "ok", {}, ["RIGA DAXAP03 INCOERENTE", NOSTUB], FERMA),
 ("macchina_VPS", {}, "", "ok", "VMI3047753", "", "ok", {}, ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: VMI3047753", NOSTUB], FERMA + ["GUARDIA EA"]),
 ("macchina_vuota", {}, "", "ok", "", "", "ok", {}, ["QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ", NOSTUB], FERMA),
 ("mt5_aperto", {}, "", "ok", PC, "", "ok", {"PRE_MT5": "1"}, ["MT5 risulta APERTO su questo PC", NOSTUB], FERMA + ["GUARDIA EA"]),
 ("terminale_assente", {}, "", "ok", PC, "", "assente", {}, ["TERMINALE: non trovo C:\\Program Files\\BCM Markets MT5 Terminal\\terminal64.exe", NOSTUB], FERMA),
 ("terminale_collegamento", {}, "", "ok", PC, "", "link", {}, ["e un COLLEGAMENTO (junction o link)", NOSTUB], FERMA),
 ("grafico_con_EA", {}, "", "ea", PC, "", "ok", {}, ["GUARDIA EA: grafici salvati letti 3, con un EA attaccato o illeggibili 1", "EA: " + EA, NOSTUB], FERMA),
 ("grafico_illeggibile", {}, "", "rotto", PC, "", "ok", {}, ["ILLEGGIBILE", "GUARDIA EA: nel profilo del terminale 50503392", NOSTUB], FERMA),
 ("zero_grafici", {}, "", "zero", PC, "", "ok", {}, ["GUARDIA EA: ho letto ZERO grafici salvati", NOSTUB], FERMA),
 ("driver_mutato", {}, "", "ok", PC, "drv", "ok", {}, ["RIGA_ROUND_VPS_RETRY.ps1 scaricata con SHA256 DIVERSO", NOSTUB], FERMA),
 ("driver_originale_col_nome_RETRY", {}, "", "ok", PC, "orig", "ok", {}, ["scaricata SENZA il marcatore RETRY_v1", NOSTUB], FERMA),
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
    dk = os.path.join(H, "user", "Desktop")
    if os.path.isdir(dk):
        for x in sorted(os.listdir(dk)):
            rf = os.path.join(dk, x, "RIEPILOGO_ROUND_DAXAP03.txt")
            if x.startswith("ROUND_DAXAP03_") and os.path.isfile(rf):
                t += "\n=== RIEPILOGO ===\n" + open(rf, encoding="ascii", errors="replace").read()
    sl = os.path.join(H, "stub.log")
    stub = open(sl).read() if os.path.exists(sl) else ""
    return re.sub(r"\x1b\[[0-9;]*m", "", t), stub

def stubargs_ok(out, stub):
    m = re.search(r"data: (\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)", out)
    if not m:
        return "data della riga non trovata nell uscita"
    scad = (dt.datetime.strptime(m.group(1), "%Y-%m-%d %H:%M:%S") + dt.timedelta(minutes=17)).strftime("%Y-%m-%d %H:%M:%S")
    righe = [l for l in stub.splitlines() if l.startswith("STUB ")]
    if len(righe) != 2:
        return "lo stub doveva essere chiamato 2 volte, e invece %d" % len(righe)
    for l, (lbl, prv) in zip(righe, ((A, "PRV_DAXAP_03a_ingresso_meno1_piu1_770411_D30EUR.txt"), (B, "PRV_DAXAP_03b_ritardo_5_15_770411_D30EUR.txt"))):
        att = ("-Expert | %s | -Prova | %s | -Etichetta | %s | -Pin | %s | -Modello | 4 | -Deposito | 100000 | -MaxRiprove | 1 | -AttesaRiprovaSec | 20 | -RiprovaEntro | %s"
               % (EA, prv, lbl, PIN, scad))
        if not l.rstrip().endswith(att) or "RIGA_ROUND_VPS_RETRY.ps1 | -Expert" not in l:
            return "argomenti del driver per %s diversi da: %s  --- ricevuti: %s" % (lbl, att, l)
    return ""

def check(item):
    (nome, sc, sed, ch, pc, mut, term, envx, deve, nondeve) = item
    out, stub = run(nome, sc, sed, ch, pc, mut, term, envx)
    mancano = []
    for x in deve:
        if x == NOSTUB:
            if stub != "":
                mancano.append("lo stub NON doveva essere chiamato, e invece: " + stub.strip()[:300])
        elif x == STUBARGS:
            e = stubargs_ok(out, stub)
            if e:
                mancano.append(e)
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
