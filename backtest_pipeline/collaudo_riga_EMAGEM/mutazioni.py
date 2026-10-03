#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni.py -- il collaudo DEL COLLAUDO (classe 1033): per ogni controllo che la riga EMAGEM dichiara, lo si SPEGNE nella riga assemblata
(una sostituzione di testo, una per volta) e si fa girare la batteria sugli scenari che lo riguardano: almeno uno deve diventare ROSSO.
Una mutazione che lascia tutto verde vuol dire che quel controllo NON e' collaudato.
Uso: python3 backtest_pipeline/collaudo_riga_EMAGEM/mutazioni.py [PIN] [filtro ...]    (esce 0 se OGNI mutazione e' presa)
"""
import os, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_EMAGEM.txt")
# (nome, testo vero, testo mutato, scenari che devono prenderla)
M = [
 ("zip: voci non controllate", "$inZ=($zipE -contains $fa);", "$inZ=$true;", ["zip_senza_un_file"]),
 ("zip: freschezza non controllata", "$zipFr=((Test-Path -LiteralPath $zip) -and ((Get-Item -LiteralPath $zip).LastWriteTime -ge $tRac));", "$zipFr=(Test-Path -LiteralPath $zip);", ["zip_vecchio"]),
 ("asse non controllato", "$gq.axOk=$okA;", "$gq.axOk=$true;", ["asse_TF_non_arrivato", "asse_TF_sbagliato", "a_csv_veri_pin_perso"]),
 ("pin numerici non controllati", "$gq.pinKo=$gq.pinKo+1;", "", ["pin_magic_perso_su_b", "pin_lato_short_perso_su_b", "pin_lato_long_perso_su_a"]),
 ("Trades>0 non controllato", "$co.ok=($co.n -eq $nrAtt -and $co.nTr -eq $nrAtt);", "$co.ok=($co.n -eq $nrAtt);", ["trades_zero_in_una_cella_di_a", "T1_pass_ma_b_NV"]),
 ("referto: freschezza", "$refFr=((Test-Path -LiteralPath $refF) -and ((Get-Item -LiteralPath $refF).LastWriteTime -ge $tJ));", "$refFr=(Test-Path -LiteralPath $refF);", ["referto_non_riscritto"]),
 ("referto: riprova e scadenza", " -and $refRip -eq $ripAtt);", ");", ["maxriprove_0_passato", "scadenza_non_passata"]),
 ("referto: nome del driver", " -and $refV['driver'] -eq $nomeWf", "", ["referto_driver_originale"]),
 ("referto: deposito", " -and $refV['deposito'] -eq ('' + $jb.dp)", "", ["deposito_non_passato"]),
 ("cartella vecchia: rimozione non verificata", "Remove-Item -LiteralPath $vec -Recurse -Force -ErrorAction SilentlyContinue; if(Test-Path -LiteralPath $vec){ throw", "Remove-Item -LiteralPath $vec -Recurse -Force -ErrorAction SilentlyContinue; if($false){ throw", ["cartella_vecchia_non_rimovibile"]),
 ("166/892: walkforward_generico_RETRY", "-Algorithm SHA256).Hash -ne $shaWf){", "-Algorithm SHA256).Hash -eq 'X'){", ["walkforward_retry_mutato", "walkforward_originale_col_nome_RETRY"]),
 ("166/892: RIGA_ROUND_VPS_RETRY dopo il job", "elseif((Get-FileHash -LiteralPath $drv -Algorithm SHA256).Hash -ne $shaDrv){ $div +=", "elseif($false){ $div +=", ["riga_retry_locale_mutata_durante_il_terzo_job"]),
 ("166/892: EA", "-Algorithm SHA256).Hash -ne $shaEa){", "-Algorithm SHA256).Hash -eq 'X'){", ["ea_mutato_nel_secondo_job"]),
 ("RIPROVE: freschezza", "-and ((Get-Item -LiteralPath $rpF).LastWriteTime -ge $tJ)){ $rp.fr=$true;", "){ $rp.fr=$true;", ["riprove_vecchio"]),
 ("RIPROVE: assente accettato", "elseif(-not $rp.fr){", "elseif($false){", ["riprove_assente_con_gamba_riprovata", "riprove_vecchio"]),
 ("RIPROVATA non letta", "rip=($tq -clike '*| RIPROVATA | ESITO GAMBA:*');", "rip=$false;", ["job_b_gamba_riprovata_e_salvata"]),
 ("CSV PRODOTTO letto sempre", "prod=($tq -cmatch 'ESITO GAMBA: CSV PRODOTTO')}", "prod=$true}", ["job_c_gamba_morta", "ko_quattro_tentativi_morti_su_c"]),
 ("giornale contro RIPROVE", "elseif($nLg -ne $tA -or $nS -ne $tP -or $nK -ne $tK){", "elseif($false){", ["giornale_e_riprove_non_tornano"]),
 ("RIPROVE incoerente", "elseif(-not $rpCoh){", "elseif($false){", ["riprove_incoerente"]),
 ("esito diverso da PARTITA/MORTA_INIT", "elseif($tX -gt 0){", "elseif($false){", ["morta_con_altra_causa"]),
 ("classe 1030: gambe CONTATE nel giornale (attese 2)", "elseif($eaKo -gt 0){ $why='una gamba", "elseif($nLg -ne 2){ $why='x' } elseif($eaKo -gt 0){ $why='una gamba", ["job_b_gamba_riprovata_e_salvata", "job_c_gamba_morta_due_volte"]),
 ("OK_RIPROVATO non distinto", "elseif($ripL.Count -gt 0){ $st='OK_RIPROVATO';", "elseif($false){ $st='OK_RIPROVATO';", ["job_b_gamba_riprovata_e_salvata"]),
 ("MISTO letto come KO", "$st='MISTO';", "$st='KO';", ["job_c_gamba_morta"]),
 ("MISTO con il CSV della morta fresco", "if($crMo.fresco){", "if($false){", ["misto_ma_csv_morto_fresco"]),
 ("finestra girata", " -or $nWis -ne 1 -or $nWoos -ne 1", "", ["finestra_oos_un_giorno_prima_su_c"]),
 ("magic del file prova", " -and $idOk);", ");", ["riga_magic_diverso_dal_file"]),
 ("tetto fra i job", "if($minAvv -ge $TETTO){", "if($false){", ["tetto_secondo_job_non_lanciato", "tetto_terzo_job_non_lanciato"]),
 ("RIPROVE fra i file attesi", "[void]$fAtt.Add('ROUND_' + $jb.t + '\\RIPROVE_' + $jb.e + '_' + $jb.s + '_' + $jb.t + '.txt');", "", ["ok", "rp_copia_mancante_in_raccolta"]),
 ("marcatore RETRY_v1 della riga driver", "-Pattern 'MARCATORE_RIGA_ROUND_VPS_RETRY_v1' -Quiet", "-Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet", ["driver_originale_col_nome_RETRY"]),
 ("macchina", "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){", "if($false){", ["macchina_VPS"]),
 ("guardia EA sui grafici", "if($conEA.Count -gt 0){ foreach($xE", "if($false){ foreach($xE", ["grafico_con_EA", "grafico_illeggibile"]),
 ("coerenza della tabella: maxriprove", "-or $MAXRIP -ne 1 -or", "-or", ["riga_incoerente_maxriprove"]),
 ("coerenza della tabella: ordine dei job", " -or ((@($jobs | ForEach-Object { $_.t })) -join ',') -ne 'EMAGEMa,EMAGEMb,EMAGEMc'", "", ["riga_incoerente_ordine_dei_job"]),
 ("coerenza della tabella: simboli", " -or ((@($jobs | ForEach-Object { $_.s })) -join ',') -ne 'U30USD,D30EUR,NASUSD'", "", ["riga_incoerente_simbolo"]),
 ("coerenza della tabella: asse di a", " -or ((@($jobs[0].av)) -join ',') -ne '766801,766802'", "", ["riga_incoerente_asse_a"]),
 ("coerenza della tabella: asse TF di c", " -or ((@($jobs[2].av)) -join ',') -ne '30,16385,16386,16387,16388'", "", ["riga_incoerente_asse_TF_di_c"]),
 ("coerenza della tabella: magic di a vuoto", " -or $jobs[0].mg -ne ''", "", ["riga_incoerente_magic_di_a_pinnato"]),
 ("coerenza della tabella: tetto", " -or $TETTO -ne 40", "", ["riga_incoerente_tetto"]),
 ("coerenza della tabella: margine", " -or $MARGINE -ne 10", "", ["riga_incoerente_margine"]),
 ("coerenza della tabella: righe di input", " -or $_.np -ne 42", "", ["riga_incoerente_input"]),
 # cancello indipendente 01/10/2026 (classe 1051)
 ("giornale contro RIPROVE: SOLO il conto delle morte", " -or $nK -ne $tK){", "){", ["CE4_morte_senza_causa_ma_riprove_dice_INIT"]),
 ("RIPROVE: due tentativi senza il flag RIPROVATA", " -or ($gg.n -eq 2) -ne $gg.rip){", "){", ["CE10_riprove_senza_flag_RIPROVATA"]),
 # per-trade: un file per magic (a ne ha due)
 ("per-trade: solo il primo magic", "foreach($pmg in @($jb.pm)){ $ptN=", "foreach($pmg in @($jb.pm | Select-Object -First 1)){ $ptN=", ["pertrade_vecchio_su_a"]),
 ("file attesi: solo il primo per-trade", "foreach($pmg in @($jb.pm)){ [void]$fAtt.Add(", "foreach($pmg in @($jb.pm | Select-Object -First 1)){ [void]$fAtt.Add(", ["ok"]),
 # IL CANCELLO INCROCIATO T1 + G1: ogni suo componente e il SOLO a scattare in almeno uno scenario
 ("T1: Profit non confrontato", "@('Profit','Profit',0.005), ", "", ["T1_profit_un_centesimo"]),
 ("T1: PF non confrontato", "@('Profit Factor','PF',0.000005), ", "", ["T1_pf_entrambe_le_gemelle"]),
 ("T1: DD non confrontato", "@('Equity DD %','DD',0.00005), ", "", ["T1_dd_ultima_cifra"]),
 ("T1: Trades non confrontato", ", @('Trades','N',0.5)", "", ["T1_trades"]),
 ("T1: tolleranza del PF troppo larga", "0.000005)", "0.0005)", ["T1_pf_entrambe_le_gemelle"]),
 ("T1: tolleranza del profit troppo larga", "@('Profit','Profit',0.005)", "@('Profit','Profit',0.5)", ["T1_profit_un_centesimo"]),
 ("T1: gamba IS non confrontata", "foreach($tg in @('IS','OOS')){ $tcr=", "foreach($tg in @('OOS')){ $tcr=", ["T1_is_sbagliata"]),
 ("T1: gamba OOS non confrontata", "foreach($tg in @('IS','OOS')){ $tcr=", "foreach($tg in @('IS')){ $tcr=", ["T1_pf_entrambe_le_gemelle", "T1_dd_ultima_cifra"]),
 ("T1: solo la prima gemella", "foreach($tr in $trw){ foreach($tc in", "foreach($tr in @($trw | Select-Object -First 1)){ foreach($tc in", ["T1_pf_entrambe_le_gemelle"]),
 ("G1: gemelle non confrontate", "if((('' + $trw[0].$tcn).Trim()) -ne (('' + $trw[1].$tcn).Trim())){", "if($false){", ["G1_solo_sharpe", "G1_solo_expected_payoff_IS", "G1_solo_recovery"]),
 ("G1: Sharpe fuori dalle colonne", "'Recovery Factor','Sharpe Ratio','Equity DD %'", "'Recovery Factor','Equity DD %'", ["G1_solo_sharpe"]),
 ("G1: Expected Payoff fuori dalle colonne", "@('Profit','Expected Payoff','Profit Factor'", "@('Profit','Profit Factor'", ["G1_solo_expected_payoff_IS"]),
 ("G1: Recovery Factor fuori dalle colonne", "'Expected Payoff','Profit Factor','Recovery Factor'", "'Expected Payoff','Profit Factor'", ["G1_solo_recovery"]),
 ("T1: eseguito anche con a NON certificato", "elseif($stMap['EMAGEMa'] -ne 'OK' -and $stMap['EMAGEMa'] -ne 'OK_RIPROVATO'){", "elseif($false){", ["T1_a_asse_sbagliato_NV", "T1_a_gamba_morta_MISTO"]),
 ("T1: OK_RIPROVATO non accettato", " -and $stMap['EMAGEMa'] -ne 'OK_RIPROVATO'){", "){", ["T1_a_riprovata_PASS"]),
 ("T1: a non lanciato non visto", "if($jA.nonLanc){ $t1Txt=", "if($false){ $t1Txt=", ["T1_a_non_lanciato"]),
 ("T1: esito PASS senza controllo", "if($t1Dif.Count -eq 0 -and $t1Gem.Count -eq 0){ $t1St='PASS';", "if($true){ $t1St='PASS';", ["T1_pf_una_gemella", "G1_solo_sharpe"]),
 ("T1: G1 ignorato nell esito", "if($t1Dif.Count -eq 0 -and $t1Gem.Count -eq 0){ $t1St='PASS';", "if($t1Dif.Count -eq 0){ $t1St='PASS';", ["G1_solo_sharpe", "G1_solo_recovery"]),
 ("T1: b e c letti anche col cancello rosso (console)", "Write-Host 'NUMERI DAI CSV, cella per cella (NON e un verdetto: T1 + G1 sono sopra, le altre letture si leggono dai file prova):' -ForegroundColor Cyan; foreach($jb in $jobs){ if($t1St -ne 'PASS' -and $jb.k -ne 'a'){", "Write-Host 'NUMERI DAI CSV, cella per cella (NON e un verdetto: T1 + G1 sono sopra, le altre letture si leggono dai file prova):' -ForegroundColor Cyan; foreach($jb in $jobs){ if($false){", ["T1_pf_una_gemella", "T1_a_asse_sbagliato_NV"]),
 ("T1: b e c letti anche col cancello rosso (riepilogo)", "foreach($jb in $jobs){ if($t1St -ne 'PASS' -and $jb.k -ne 'a'){ [void]$ri.Add(", "foreach($jb in $jobs){ if($false){ [void]$ri.Add(", ["T1_pf_una_gemella"]),
 ("T1: riga del cancello fuori dal riepilogo", "[void]$ri.Add('STATO: ' + $statiV); [void]$ri.Add($t1Riga);", "[void]$ri.Add('STATO: ' + $statiV);", ["ok", "T1_pf_una_gemella"]),
 ("T1: riga del cancello fuori dalla console", "Write-Host $t1Riga -ForegroundColor $t1Col; Write-Host 'NUMERI DAI CSV", "Write-Host 'NUMERI DAI CSV", ["ok"]),
]
riga = open(RIGA, encoding="ascii").read()
tot = 0; prese = 0
FILTRO = sys.argv[2:]          # opzionale: sottostringhe del nome della mutazione (per rigirarne solo alcune)
for nome, vero, mut, scen in M:
    if FILTRO and not any(f in nome for f in FILTRO):
        continue
    tot += 1
    n = riga.count(vero)
    if n != 1:
        print("NON APPLICABILE (%d occorrenze del testo vero): %s" % (n, nome)); continue
    f = tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False, encoding="ascii"); f.write(riga.replace(vero, mut)); f.close()
    r = subprocess.run([sys.executable, os.path.join(QD, "battery.py"), PIN, f.name] + scen, capture_output=True, text=True,
                       env=dict(os.environ, HARNESS_OUT=os.environ.get("HARNESS_OUT", "/tmp/emagem_mut")))
    rossi = [l.split()[1] for l in r.stdout.splitlines() if l.startswith("FALLITO")]
    ok = len(rossi) > 0
    prese += 1 if ok else 0
    print(("PRESA     " if ok else "NON PRESA ") + nome + "   (rossi: " + (", ".join(rossi) if rossi else "nessuno") + ")")
print("MUTAZIONI PRESE: %d/%d" % (prese, tot))
sys.exit(0 if prese == tot else 1)
