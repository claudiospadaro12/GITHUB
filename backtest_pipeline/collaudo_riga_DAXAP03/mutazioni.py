#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni.py -- il collaudo DEL COLLAUDO (classe 1033): per ogni controllo che la riga DAXAP03 dichiara, lo si SPEGNE nella riga assemblata
(una sostituzione di testo, una per volta) e si fa girare la batteria sugli scenari che lo riguardano: almeno uno deve diventare ROSSO.
Una mutazione che lascia tutto verde vuol dire che quel controllo NON e' collaudato.
Uso: python3 backtest_pipeline/collaudo_riga_DAXAP03/mutazioni.py [PIN]    (esce 0 se OGNI mutazione e' presa)
"""
import os, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_DAXAP03.txt")
# (nome, testo vero, testo mutato, scenari che devono prenderla)
M = [
 ("zip: voci non controllate", "$inZ=($zipE -contains $fa);", "$inZ=$true;", ["zip_senza_un_file"]),
 ("zip: freschezza non controllata", "$zipFr=((Test-Path -LiteralPath $zip) -and ((Get-Item -LiteralPath $zip).LastWriteTime -ge $tRac));", "$zipFr=(Test-Path -LiteralPath $zip);", ["zip_vecchio"]),
 ("asse non controllato", "$gq.axOk=$okA;", "$gq.axOk=$true;", ["asse_non_arrivato", "asse_sbagliato", "csv_veri_R246i_pin_perso"]),
 ("pin numerici non controllati", "$gq.pinKo=$gq.pinKo+1;", "", ["pin_placehour_perso", "pin_magic_perso"]),
 ("Trades>0 non controllato", "$co.ok=($co.n -eq $nrAtt -and $co.nTr -eq $nrAtt);", "$co.ok=($co.n -eq $nrAtt);", ["trades_zero_in_una_cella"]),
 ("referto: freschezza", "$refFr=((Test-Path -LiteralPath $refF) -and ((Get-Item -LiteralPath $refF).LastWriteTime -ge $tJ));", "$refFr=(Test-Path -LiteralPath $refF);", ["referto_non_riscritto"]),
 ("referto: riprova e scadenza", " -and $refRip -eq $ripAtt);", ");", ["maxriprove_0_passato", "scadenza_non_passata"]),
 ("referto: nome del driver", " -and $refV['driver'] -eq $nomeWf", "", ["referto_driver_originale"]),
 ("referto: deposito", " -and $refV['deposito'] -eq ('' + $jb.dp)", "", ["deposito_non_passato"]),
 ("cartella vecchia: rimozione non verificata", "Remove-Item -LiteralPath $vec -Recurse -Force -ErrorAction SilentlyContinue; if(Test-Path -LiteralPath $vec){ throw", "Remove-Item -LiteralPath $vec -Recurse -Force -ErrorAction SilentlyContinue; if($false){ throw", ["cartella_vecchia_non_rimovibile"]),
 ("166/892: walkforward_generico_RETRY", "-Algorithm SHA256).Hash -ne $shaWf){", "-Algorithm SHA256).Hash -eq 'X'){", ["walkforward_retry_mutato", "walkforward_originale_col_nome_RETRY"]),
 ("166/892: RIGA_ROUND_VPS_RETRY dopo il job", "elseif((Get-FileHash -LiteralPath $drv -Algorithm SHA256).Hash -ne $shaDrv){ $div +=", "elseif($false){ $div +=", ["riga_retry_locale_mutata_durante_il_job"]),
 ("166/892: EA", "-Algorithm SHA256).Hash -ne $shaEa){", "-Algorithm SHA256).Hash -eq 'X'){", ["ea_mutato_nel_secondo_job"]),
 ("RIPROVE: freschezza", "-and ((Get-Item -LiteralPath $rpF).LastWriteTime -ge $tJ)){ $rp.fr=$true;", "){ $rp.fr=$true;", ["riprove_vecchio"]),
 ("RIPROVE: assente accettato", "elseif(-not $rp.fr){", "elseif($false){", ["riprove_assente_con_gamba_riprovata", "riprove_vecchio"]),
 ("RIPROVATA non letta", "rip=($tq -clike '*| RIPROVATA | ESITO GAMBA:*');", "rip=$false;", ["job2_gamba_riprovata_e_salvata"]),
 ("CSV PRODOTTO letto sempre", "prod=($tq -cmatch 'ESITO GAMBA: CSV PRODOTTO')}", "prod=$true}", ["job1_ok_job2_gamba_morta", "ko_quattro_tentativi_morti"]),
 ("giornale contro RIPROVE", "elseif($nLg -ne $tA -or $nS -ne $tP -or $nK -ne $tK){", "elseif($false){", ["giornale_e_riprove_non_tornano"]),
 ("RIPROVE incoerente", "elseif(-not $rpCoh){", "elseif($false){", ["riprove_incoerente"]),
 ("esito diverso da PARTITA/MORTA_INIT", "elseif($tX -gt 0){", "elseif($false){", ["morta_con_altra_causa"]),
 ("classe 1030: gambe CONTATE nel giornale (attese 2)", "elseif($eaKo -gt 0){ $why='una gamba", "elseif($nLg -ne 2){ $why='x' } elseif($eaKo -gt 0){ $why='una gamba", ["job2_gamba_riprovata_e_salvata", "job1_gamba_morta_due_volte"]),
 ("OK_RIPROVATO non distinto", "elseif($ripL.Count -gt 0){ $st='OK_RIPROVATO';", "elseif($false){ $st='OK_RIPROVATO';", ["job2_gamba_riprovata_e_salvata"]),
 ("MISTO letto come KO", "$st='MISTO';", "$st='KO';", ["job1_ok_job2_gamba_morta"]),
 ("MISTO con il CSV della morta fresco", "if($crMo.fresco){", "if($false){", ["misto_ma_csv_morto_fresco"]),
 ("finestra girata", " -or $nWis -ne 1 -or $nWoos -ne 1", "", ["finestra_oos_un_giorno_prima"]),
 ("magic e InpPlaceHour del file", " -and $idOk);", ");", ["riga_placehour_diversa_dal_file"]),
 ("tetto fra i job", "if($minAvv -ge $TETTO){", "if($false){", ["tetto_secondo_job_non_lanciato"]),
 ("RIPROVE fra i file attesi", "[void]$fAtt.Add('ROUND_' + $jb.t + '\\RIPROVE_' + $jb.e + '_' + $jb.s + '_' + $jb.t + '.txt');", "", ["ok", "rp_copia_mancante_in_raccolta"]),
 ("marcatore RETRY_v1 della riga driver", "-Pattern 'MARCATORE_RIGA_ROUND_VPS_RETRY_v1' -Quiet", "-Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet", ["driver_originale_col_nome_RETRY"]),
 ("macchina", "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){", "if($false){", ["macchina_VPS"]),
 ("guardia EA sui grafici", "if($conEA.Count -gt 0){ foreach($xE", "if($false){ foreach($xE", ["grafico_con_EA", "grafico_illeggibile"]),
 ("coerenza della tabella", "-or $MAXRIP -ne 1 -or", "-or", ["riga_incoerente_maxriprove"]),
 # cancello indipendente 01/10/2026 (classe 1051): queste due restavano VERDI su 80/80
 ("giornale contro RIPROVE: SOLO il conto delle morte", " -or $nK -ne $tK){", "){", ["CE4_morte_senza_causa_ma_riprove_dice_INIT"]),
 ("RIPROVE: due tentativi senza il flag RIPROVATA", " -or ($gg.n -eq 2) -ne $gg.rip){", "){", ["CE10_riprove_senza_flag_RIPROVATA"]),
]
riga = open(RIGA, encoding="ascii").read()
tot = 0; prese = 0
for nome, vero, mut, scen in M:
    tot += 1
    n = riga.count(vero)
    if n != 1:
        print("NON APPLICABILE (%d occorrenze del testo vero): %s" % (n, nome)); continue
    f = tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False, encoding="ascii"); f.write(riga.replace(vero, mut)); f.close()
    r = subprocess.run([sys.executable, os.path.join(QD, "battery.py"), PIN, f.name] + scen, capture_output=True, text=True,
                       env=dict(os.environ, HARNESS_OUT=os.environ.get("HARNESS_OUT", "/tmp/daxap03_mut")))
    rossi = [l.split()[1] for l in r.stdout.splitlines() if l.startswith("FALLITO")]
    ok = len(rossi) > 0
    prese += 1 if ok else 0
    print(("PRESA     " if ok else "NON PRESA ") + nome + "   (rossi: " + (", ".join(rossi) if rossi else "nessuno") + ")")
print("MUTAZIONI PRESE: %d/%d" % (prese, tot))
sys.exit(0 if prese == tot else 1)
