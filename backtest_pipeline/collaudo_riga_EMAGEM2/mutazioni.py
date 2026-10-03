#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni.py -- il collaudo DEL COLLAUDO (classe 1033): per ogni controllo che la riga EMAGEM2 dichiara, lo si SPEGNE nella riga assemblata
(una sostituzione di testo, una per volta) e si fa girare la batteria sugli scenari che lo riguardano: almeno uno deve diventare ROSSO.
Una mutazione che lascia tutto verde vuol dire che quel controllo NON e' collaudato.
Uso: python3 backtest_pipeline/collaudo_riga_EMAGEM2/mutazioni.py [PIN] [filtro ...]    (esce 0 se OGNI mutazione e' presa)
"""
import os, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_EMAGEM2.txt")
sys.path.insert(0, os.path.join(QD, ".."))
import re
import leggi_emagem2 as LG
CAN = ["CAN%02d_%s" % (i, re.sub(r"[^A-Za-z0-9]+", "_", n)[:60].strip("_")) for i, (n, p, a_) in enumerate(LG._casi_cancello())]
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
 ("coerenza della tabella: ordine dei job", " -or ((@($jobs | ForEach-Object { $_.t })) -join ',') -ne 'EMAGEM2a,EMAGEM2b,EMAGEM2c'", "", ["riga_incoerente_ordine_dei_job"]),
 ("coerenza della tabella: simboli", " -or ((@($jobs | ForEach-Object { $_.s })) -join ',') -ne 'U30USD,D30EUR,NASUSD'", "", ["riga_incoerente_simbolo"]),
 ("coerenza della tabella: asse di a", " -or ((@($jobs[0].av)) -join ',') -ne '766901,766902'", "", ["riga_incoerente_asse_a"]),
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
 # IL CANCELLO INCROCIATO T1 + G1 CON LA TOLLERANZA: ogni componente (colonna, soglia, bordo, gamba, gemella, tipo numerico) e il SOLO a scattare in almeno uno dei casi al bordo (CAN)
 ("T1: Profit non confrontato", "@('Profit','Profit'), @('Profit Factor','PF')", "@('Profit Factor','PF')", CAN),
 ("T1: PF non confrontato", "@('Profit Factor','PF'), @('Equity DD %','DD')", "@('Equity DD %','DD')", CAN),
 ("T1: DD non confrontato", "@('Equity DD %','DD'), @('Trades','N')", "@('Trades','N')", CAN),
 ("T1: Trades non confrontato", ", @('Trades','N'))){ $tvv=", ")){ $tvv=", CAN),
 ("T1: gamba IS non confrontata", "foreach($tg in @('IS','OOS')){ $tcr=", "foreach($tg in @('OOS')){ $tcr=", CAN),
 ("T1: gamba OOS non confrontata", "foreach($tg in @('IS','OOS')){ $tcr=", "foreach($tg in @('IS')){ $tcr=", CAN),
 ("T1: solo la prima gemella", "foreach($tr in $trw){ foreach($tc in", "foreach($tr in @($trw | Select-Object -First 1)){ foreach($tc in", CAN),
 ("T1: confronto sempre vero", "-not (& $tolOk $tc[0] $tvv $tev $pEx $nEx)", "$false", CAN),
 ("G1: confronto sempre vero", "-not (& $tolOk $tcn $g1 $g0 $pG $nG)", "$false", CAN),
 ("G1: solo la gemella 1 contro se stessa", "$g1=& $decF $trw[1].$tcn;", "$g1=& $decF $trw[0].$tcn;", CAN),
 ("G1: Profit fuori dalle colonne", "foreach($tcn in @('Profit','Expected Payoff',", "foreach($tcn in @('Expected Payoff',", CAN),
 ("G1: Expected Payoff fuori dalle colonne", "@('Profit','Expected Payoff','Profit Factor'", "@('Profit','Profit Factor'", CAN),
 ("G1: PF fuori dalle colonne", "'Expected Payoff','Profit Factor','Recovery Factor'", "'Expected Payoff','Recovery Factor'", CAN),
 ("G1: Recovery Factor fuori dalle colonne", "'Profit Factor','Recovery Factor','Sharpe Ratio'", "'Profit Factor','Sharpe Ratio'", CAN),
 ("G1: Sharpe fuori dalle colonne", "'Recovery Factor','Sharpe Ratio','Equity DD %'", "'Recovery Factor','Equity DD %'", CAN),
 ("G1: DD fuori dalle colonne", "'Sharpe Ratio','Equity DD %','Trades')){ $g0=", "'Sharpe Ratio','Trades')){ $g0=", CAN),
 ("G1: Trades fuori dalle colonne", "'Sharpe Ratio','Equity DD %','Trades')){ $g0=", "'Sharpe Ratio','Equity DD %')){ $g0=", CAN),
 # le soglie (una per volta, di un passo)
 ("soglia Profit 0 (esatto)", "$tolP=& $decF '1.00';", "$tolP=& $decF '0';", CAN),
 ("soglia Profit 0,50", "$tolP=& $decF '1.00';", "$tolP=& $decF '0.50';", CAN),
 ("soglia Profit 1,01", "$tolP=& $decF '1.00';", "$tolP=& $decF '1.01';", CAN),
 ("soglia Profit 2,00", "$tolP=& $decF '1.00';", "$tolP=& $decF '2.00';", CAN),
 ("soglia PF/RF 0,0001", "$tolF=& $decF '0.0002';", "$tolF=& $decF '0.0001';", CAN),
 ("soglia PF/RF 0,0003", "$tolF=& $decF '0.0002';", "$tolF=& $decF '0.0003';", CAN),
 ("soglia RF sola 0,0001", "elseif($col -eq 'Recovery Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Recovery Factor'){ ($dd -le [decimal]'0.0001') }", CAN),
 ("soglia RF sola 0,0003", "elseif($col -eq 'Recovery Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Recovery Factor'){ ($dd -le [decimal]'0.0003') }", CAN),
 ("soglia PF sola 0,0001", "elseif($col -eq 'Profit Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Profit Factor'){ ($dd -le [decimal]'0.0001') }", CAN),
 ("soglia PF sola 0,0003", "elseif($col -eq 'Profit Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Profit Factor'){ ($dd -le [decimal]'0.0003') }", CAN),
 ("soglia EP/Sharpe 0,50", "$tolK=& $decF '1.00';", "$tolK=& $decF '0.50';", CAN),
 ("soglia EP/Sharpe 2,00", "$tolK=& $decF '1.00';", "$tolK=& $decF '2.00';", CAN),
 ("EP: soglia assoluta 1,00 (senza Trades)", "(($dd * $nRef) -le $tolK)", "($dd -le $tolK)", CAN),
 ("EP: moltiplicato per il Profit invece dei Trades", "(($dd * $nRef) -le $tolK)", "(($dd * $pRef) -le $tolK)", CAN),
 ("Sharpe: soglia assoluta 1,00 (senza Profit)", "(($dd * [Math]::Abs($pRef)) -le ([Math]::Abs($vb) * $tolK))", "($dd -le $tolK)", CAN),
 ("Sharpe: senza il valore dello Sharpe a destra", "(($dd * [Math]::Abs($pRef)) -le ([Math]::Abs($vb) * $tolK))", "(($dd * [Math]::Abs($pRef)) -le $tolK)", CAN),
 ("Trades con tolleranza 1", "if($col -eq 'Trades'){ ($va -eq $vb) }", "if($col -eq 'Trades'){ ($dd -le 1) }", CAN),
 ("DD con tolleranza 0,0001", "elseif($col -eq 'Equity DD %'){ ($va -eq $vb) }", "elseif($col -eq 'Equity DD %'){ ($dd -le [decimal]'0.0001') }", CAN),
 ("DD con tolleranza 0,001", "elseif($col -eq 'Equity DD %'){ ($va -eq $vb) }", "elseif($col -eq 'Equity DD %'){ ($dd -le [decimal]'0.001') }", CAN),
 # il bordo e DENTRO: -lt al posto di -le, colonna per colonna
 ("bordo Profit fuori (-lt)", "($dd -le $tolP)", "($dd -lt $tolP)", CAN),
 ("bordo PF fuori (-lt)", "elseif($col -eq 'Profit Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Profit Factor'){ ($dd -lt $tolF) }", CAN),
 ("bordo RF fuori (-lt)", "elseif($col -eq 'Recovery Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Recovery Factor'){ ($dd -lt $tolF) }", CAN),
 # NOTA (TRE altri mutanti EQUIVALENTI, tolti dopo la corsa completa del 03/10: 100/104 presi, i 4 non presi sono questi tre e quello del [double]):
 # (a) bordo EP e bordo Sharpe fuori (-lt al posto di -le): il bordo esatto e' |diff| = 1/Trades (1/517 e 1/237) e |diff| = Sharpe/Profit (8.16765/23321.47, 3.77377/4585.40),
 #     nessuno dei quali e' un multiplo di 1e-5, la risoluzione con cui i CSV scrivono EP e Sharpe: il bordo NON e' raggiungibile con un numero di CSV, quindi -le e -lt danno lo stesso
 #     verdetto su qualunque CSV vero (calcolato a mano il 03/10); (b) riferimento dello Sharpe = la gemella 1 invece della 0: la soglia cambia di un fattore (1 +- d/Sharpe) e
 #     nessun d multiplo di 1e-5 cade nella finestra (larga circa 1,5e-8 e 4e-8) fra le due soglie (provato per tutti i k su IS e OOS). La scelta "gemella col magic piu' basso" resta
 #     documentata nel sorgente e nel lettore, NON collaudata.
 # NOTA (mutante EQUIVALENTE, tolto): [double] al posto di [decimal] nello scarto NON e rilevabile con i numeri di a: i sei bordi a +-1,00 EUR / +-0,0002 (IS e OOS, Profit PF RF)
 # in double cadono TUTTI sul lato permissivo (23322.47-23321.47 = 1.0 esatto; i PF 0.00019999999999997797 <= 0.0002), calcolato a mano il 03/10. Il decimal e' scelto per principio, NON provato necessario.
 ("residui entro tolleranza non elencati (T1)", "elseif($tvv -ne $tev){ $t1Res +=", "elseif($false){ $t1Res +=", CAN),
 ("residui entro tolleranza non elencati (G1)", "elseif($g0 -ne $g1){ $t1Res +=", "elseif($false){ $t1Res +=", CAN),
 ("residui non scritti nel testo del PASS", "' + $resTxt) } else { $t1St='FAIL';", "') } else { $t1St='FAIL';", CAN),
 ("T1: eseguito anche con a NON certificato", "elseif($stMap['EMAGEM2a'] -ne 'OK' -and $stMap['EMAGEM2a'] -ne 'OK_RIPROVATO'){", "elseif($false){", ["T1_a_asse_sbagliato_NV", "T1_a_gamba_morta_MISTO"]),
 ("T1: OK_RIPROVATO non accettato", " -and $stMap['EMAGEM2a'] -ne 'OK_RIPROVATO'){", "){", ["T1_a_riprovata_PASS"]),
 ("T1: a non lanciato non visto", "if($jA.nonLanc){ $t1Txt=", "if($false){ $t1Txt=", ["T1_a_non_lanciato"]),
 ("T1: esito PASS senza controllo", "if($t1Dif.Count -eq 0 -and $t1Gem.Count -eq 0){ $t1St='PASS';", "if($true){ $t1St='PASS';", CAN),
 ("T1: G1 ignorato nell esito", "if($t1Dif.Count -eq 0 -and $t1Gem.Count -eq 0){ $t1St='PASS';", "if($t1Dif.Count -eq 0){ $t1St='PASS';", CAN),
 ("T1: T1 ignorato nell esito", "if($t1Dif.Count -eq 0 -and $t1Gem.Count -eq 0){ $t1St='PASS';", "if($t1Gem.Count -eq 0){ $t1St='PASS';", CAN),
 # I NUMERI DI b e c NON SI STAMPANO COL CANCELLO ROSSO (classe 1090): ogni uscita e il SOLO a scattare in almeno uno scenario
 ("console: tabella di b e c stampata col cancello rosso (condizione spenta)", "foreach($jb in $jobs){ if($t1St -ne 'PASS' -and $jb.k -ne 'a'){ Write-Host ('   ' + $jb.t + ': NON SI LEGGE", "foreach($jb in $jobs){ if($false){ Write-Host ('   ' + $jb.t + ': NON SI LEGGE", CAN + ["T1_a_asse_sbagliato_NV"]),
 ("console: tabella di b e c stampata dopo la riga NON SI LEGGE (continue tolto)", "restano nei CSV della raccolta per la diagnosi') -ForegroundColor Red; continue };", "restano nei CSV della raccolta per la diagnosi') -ForegroundColor Red };", CAN + ["T1_a_asse_sbagliato_NV"]),
 ("riepilogo: tabella di b e c scritta col cancello rosso (condizione spenta)", "foreach($jb in $jobs){ if($t1St -ne 'PASS' -and $jb.k -ne 'a'){ [void]$ri.Add('   ' + $jb.t + ': NON SI LEGGE", "foreach($jb in $jobs){ if($false){ [void]$ri.Add('   ' + $jb.t + ': NON SI LEGGE", CAN + ["T1_a_asse_sbagliato_NV"]),
 ("riepilogo: tabella di b e c scritta dopo la riga NON SI LEGGE (continue tolto)", "restano nei CSV della raccolta per la diagnosi'); continue };", "restano nei CSV della raccolta per la diagnosi') };", CAN + ["T1_a_asse_sbagliato_NV"]),
 ("console: per-trade di b e c stampato col cancello rosso", "foreach($pl in $ptL){ if($t1St -ne 'PASS' -and $pl.k -ne 'a'){ continue }; Write-Host $pl.t", "foreach($pl in $ptL){ Write-Host $pl.t", CAN + ["T1_a_asse_sbagliato_NV"]),
 ("riepilogo: per-trade di b e c scritto col cancello rosso", "foreach($pl in $ptL){ if($t1St -ne 'PASS' -and $pl.k -ne 'a'){ continue }; [void]$ri.Add($pl.t) };", "foreach($pl in $ptL){ [void]$ri.Add($pl.t) };", CAN + ["T1_a_asse_sbagliato_NV"]),
 ("T1: riga del cancello fuori dal riepilogo", "[void]$ri.Add('STATO: ' + $statiV); [void]$ri.Add($t1Riga);", "[void]$ri.Add('STATO: ' + $statiV);", ["ok", CAN[3]]),
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
                       env=dict(os.environ, HARNESS_OUT=os.environ.get("HARNESS_OUT", "/tmp/emagem2_mut")))
    rossi = [l.split()[1] for l in r.stdout.splitlines() if l.startswith("FALLITO")]
    ok = len(rossi) > 0
    prese += 1 if ok else 0
    print(("PRESA     " if ok else "NON PRESA ") + nome + "   (rossi: " + (", ".join(rossi) if rossi else "nessuno") + ")")
print("MUTAZIONI PRESE: %d/%d" % (prese, tot))
sys.exit(0 if prese == tot else 1)
