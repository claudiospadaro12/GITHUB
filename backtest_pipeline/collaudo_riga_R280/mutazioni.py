#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni.py -- il collaudo DEL COLLAUDO (classe 1033): per ogni controllo che la riga R280 dichiara, lo si SPEGNE nella riga assemblata
(una sostituzione di testo, una per volta) e si fa girare la batteria sugli scenari che lo riguardano: almeno uno deve diventare ROSSO.
Una mutazione che lascia tutto verde vuol dire che quel controllo NON e' collaudato.
Uso: python3 backtest_pipeline/collaudo_riga_R280/mutazioni.py [PIN] [filtro ...]    (esce 0 se OGNI mutazione e' presa)

MUTANTI EQUIVALENTI dichiarati (NON presi per costruzione, col conto; la scelta resta "per principio", non "collaudata"):
 (1) il ramo "else { $false }" di tolOk: irraggiungibile (si chiama solo con le quattro colonne gate).
 (2) i confronti espliciti di d0, me, oa e fz e il controllo -not $cohOk si COPRONO A VICENDA (la finestra IS e' d0 + floor(giorni x fz)): ognuno spento da solo e' equivalente; spenti INSIEME
     sono presi (mutazione combinata). d1 NON e' coperto da cohOk (641 o 642 giorni danno lo stesso floor): il suo confronto esplicito e' una mutazione a se', presa.
     assembla.py verifica in Python che 0.4322 su 2024.09.26-2026.06.30 dia 2025.06.30.
 (3) $nomeWf, $shaDrv.Length: il driver e il walkforward si fermano PRIMA (SHA diverso dal pin: scenari driver_mutato e walkforward_*).
 (5) $nS -ne 2 nell ultimo elseif dello stato (finestra girata): ridondante con $nWis -ne 1 e $nWoos -ne 1 piu i controlli che lo precedono (giornale contro RIPROVE: nLg = tentativi,
     eaKo, tX, rpCoh): con nWis = nWoos = 1 e nLg = tA = 2 le gambe partite sono gia 2 (una gamba riprovata ha 3 intestazioni ma solo 2 con la riga from..to).
 (4) i due controlli sul conteggio dell asse (@($_.av).Count -ne $_.nr e la lista dei nr '2,6') si coprono a vicenda: ognuno e' preso solo se spenti INSIEME (mutazione combinata).
NON equivalente (e PRESA): [double] al posto di [decimal] nel parser dei numeri ($decF): in double 2974.09-2974.04 = 0.0500000000001819, 1.48133-1.48128 = 5.0000000000105516e-05 e
6.6241-6.6141 = 0.010000000000000675 stanno OLTRE le soglie 0,05 / 0,00005 / 0,01 e i tre casi "bordo: PASS" diventano rossi (calcolato a mano il 05/10).
"""
import os, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_R280.txt")
sys.path.insert(0, os.path.join(QD, ".."))
import re
import leggi_r280 as LG
CAN = ["CAN%02d_%s" % (i, re.sub(r"[^A-Za-z0-9]+", "_", n)[:60].strip("_")) for i, (n, p, a_) in enumerate(LG._casi_cancello())]
INC = ["riga_incoerente_deposito", "riga_incoerente_asse_e", "riga_incoerente_asse_EmaSlow_di_a", "riga_incoerente_magic", "riga_incoerente_magic_di_e_pinnato", "riga_incoerente_input",
       "riga_incoerente_frazione", "riga_incoerente_fine_IS", "riga_incoerente_simbolo", "riga_incoerente_TF_grafico", "riga_incoerente_ordine_dei_job", "riga_incoerente_tetto",
       "riga_incoerente_margine", "riga_incoerente_maxriprove"]
# (nome, testo vero, testo mutato, scenari che devono prenderla)
M = [
 ("zip: voci non controllate", "$inZ=($zipE -contains $fa);", "$inZ=$true;", ["zip_senza_un_file"]),
 ("zip: freschezza non controllata", "$zipFr=((Test-Path -LiteralPath $zip) -and ((Get-Item -LiteralPath $zip).LastWriteTime -ge $tRac));", "$zipFr=(Test-Path -LiteralPath $zip);", ["zip_vecchio"]),
 ("asse non controllato", "$gq.axOk=$okA;", "$gq.axOk=$true;", ["asse_EmaSlow_non_arrivato", "asse_EmaSlow_sbagliato", "e_csv_veri_pin_perso", "asse_EmaSlow_ripetuto"]),
 ("pin numerici non controllati", "$gq.pinKo=$gq.pinKo+1;", "", ["pin_magic_perso_su_a", "pin_lato_short_perso_su_a", "pin_lato_long_perso_su_e", "pin_FilterTF_H1_perso_su_a", "pin_EmaSlow_220_perso_su_e"]),
 ("Trades>0 non controllato", "$co.ok=($co.n -eq $nrAtt -and $co.nTr -eq $nrAtt);", "$co.ok=($co.n -eq $nrAtt);", ["trades_zero_in_una_cella_di_e", "G_pass_ma_a_NV"]),
 ("numero di righe del CSV non controllato", "$co.ok=($co.n -eq $nrAtt -and $co.nTr -eq $nrAtt);", "$co.ok=($co.nTr -eq $co.nTr);", ["una_riga_in_meno_su_a"]),
 ("referto: freschezza", "$refFr=((Test-Path -LiteralPath $refF) -and ((Get-Item -LiteralPath $refF).LastWriteTime -ge $tJ));", "$refFr=(Test-Path -LiteralPath $refF);", ["referto_non_riscritto"]),
 ("referto: riprova e scadenza", " -and $refRip -eq $ripAtt);", ");", ["maxriprove_0_passato", "scadenza_non_passata"]),
 ("referto: nome del driver", " -and $refV['driver'] -eq $nomeWf", "", ["referto_driver_originale"]),
 ("referto: deposito", " -and $refV['deposito'] -eq ('' + $jb.dp)", "", ["deposito_100000_passato"]),
 ("referto: modello", " -and $refV['modello'] -eq ('' + $jb.m)", "", ["modello_1_passato"]),
 ("referto: pin", "$refOk=($refFr -and $refV['pin'] -eq $PIN", "$refOk=($refFr", ["pin_diverso_passato"]),
 ("referto: macchina", " -and $refV['macchina'] -eq 'DESKTOP-H4D7CAJ'", "", ["referto_terminale_banco_VPS"]),
 ("referto: terminale", " -and $refTerm -eq ($TB + '\\terminal64.exe')", "", ["referto_terminale_banco_VPS"]),
 ("cartella vecchia: rimozione non verificata", "Remove-Item -LiteralPath $vec -Recurse -Force -ErrorAction SilentlyContinue; if(Test-Path -LiteralPath $vec){ throw", "Remove-Item -LiteralPath $vec -Recurse -Force -ErrorAction SilentlyContinue; if($false){ throw", ["cartella_vecchia_non_rimovibile"]),
 ("166/892: walkforward_generico_RETRY", "-Algorithm SHA256).Hash -ne $shaWf){", "-Algorithm SHA256).Hash -eq 'X'){", ["walkforward_retry_mutato", "walkforward_originale_col_nome_RETRY"]),
 ("166/892: RIGA_ROUND_VPS_RETRY dopo il job", "elseif((Get-FileHash -LiteralPath $drv -Algorithm SHA256).Hash -ne $shaDrv){ $div +=", "elseif($false){ $div +=", ["riga_retry_locale_mutata_durante_il_secondo_job"]),
 ("166/892: EA", "-Algorithm SHA256).Hash -ne $shaEa){", "-Algorithm SHA256).Hash -eq 'X'){", ["ea_mutato_nel_secondo_job"]),
 ("166/892: include", "-Algorithm SHA256).Hash -ne $shaInc){", "-Algorithm SHA256).Hash -eq 'X'){", ["include_mutato"]),
 ("166/892: prova contro il pin", "-Algorithm SHA256).Hash -ne $jb.hp){", "-Algorithm SHA256).Hash -eq 'X'){", ["prova_mutata", "prova_mutata_su_e"]),
 ("RIPROVE: freschezza", "-and ((Get-Item -LiteralPath $rpF).LastWriteTime -ge $tJ)){ $rp.fr=$true;", "){ $rp.fr=$true;", ["riprove_vecchio"]),
 ("RIPROVE: assente accettato", "elseif(-not $rp.fr){", "elseif($false){", ["riprove_assente_con_gamba_riprovata", "riprove_vecchio"]),
 ("RIPROVATA non letta", "rip=($tq -clike '*| RIPROVATA | ESITO GAMBA:*');", "rip=$false;", ["job_a_gamba_riprovata_e_salvata"]),
 ("CSV PRODOTTO letto sempre", "prod=($tq -cmatch 'ESITO GAMBA: CSV PRODOTTO')}", "prod=$true}", ["job_a_gamba_morta", "ko_quattro_tentativi_morti_su_a"]),
 ("giornale contro RIPROVE", "elseif($nLg -ne $tA -or $nS -ne $tP -or $nK -ne $tK){", "elseif($false){", ["giornale_e_riprove_non_tornano"]),
 ("RIPROVE incoerente", "elseif(-not $rpCoh){", "elseif($false){", ["riprove_incoerente"]),
 ("esito diverso da PARTITA/MORTA_INIT", "elseif($tX -gt 0){", "elseif($false){", ["morta_con_altra_causa"]),
 ("RIPROVE con una sola riga GAMBA", "elseif($rp.nG -ne 2 -or $null -eq $gI -or $null -eq $gO){", "elseif($false){", ["riprove_una_gamba"]),
 ("classe 1030: gambe CONTATE nel giornale (attese 2)", "elseif($eaKo -gt 0){ $why='una gamba", "elseif($nLg -ne 2){ $why='x' } elseif($eaKo -gt 0){ $why='una gamba", ["job_a_gamba_riprovata_e_salvata", "job_a_gamba_morta_due_volte"]),
 ("EA di una gamba diverso", "elseif($eaKo -gt 0){", "elseif($false){", ["gamba_di_altro_EA"]),
 ("giornale non verificabile", "elseif($nGTok -eq 0){ $why=", "elseif($false){ $why=", ["giornale_assente", "giornale_vuoto"]),
 ("OK_RIPROVATO non distinto", "elseif($ripL.Count -gt 0){ $st='OK_RIPROVATO';", "elseif($false){ $st='OK_RIPROVATO';", ["job_a_gamba_riprovata_e_salvata"]),
 ("MISTO letto come KO", "$st='MISTO';", "$st='KO';", ["job_a_gamba_morta"]),
 ("KO: contraddizione col CSV fresco", "if($crI.fresco -or $crO.fresco){ $why=('contraddizione: il driver dice CSV NON PRODOTTO per IS e OOS", "if($false){ $why=('contraddizione: il driver dice CSV NON PRODOTTO per IS e OOS", ["ko_ma_csv_fresco"]),
 ("MISTO con il CSV della morta fresco", "if($crMo.fresco){", "if($false){", ["misto_ma_csv_morto_fresco"]),
 ("PRODOTTO ma CSV non buoni", "if(-not ($crI.ok -and $crO.ok)){ $why=('contraddizione: il driver dice CSV PRODOTTO", "if($false){ $why=('contraddizione: il driver dice CSV PRODOTTO", ["csv_0_byte", "una_riga_in_meno_su_a", "csv_vecchio", "oos_assente"]),
 ("finestra girata", " -or $nWis -ne 1 -or $nWoos -ne 1", "", ["finestra_oos_un_giorno_prima_su_a", "CE2_riprova_OOS_gira_la_finestra_IS"]),
 ("magic del file prova", " -and $idOk);", ");", ["riga_magic_diverso_dal_file"]),
 ("tetto fra i job", "if($minAvv -ge $TETTO){", "if($false){", ["tetto_secondo_job_non_lanciato", "G_e_non_lanciato"]),
 ("RIPROVE fra i file attesi", "[void]$fAtt.Add('ROUND_' + $jb.t + '\\RIPROVE_' + $jb.e + '_' + $jb.s + '_' + $jb.t + '.txt');", "", ["ok", "rp_copia_mancante_in_raccolta"]),
 ("marcatore RETRY_v1 della riga driver", "-Pattern 'MARCATORE_RIGA_ROUND_VPS_RETRY_v1' -Quiet", "-Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet", ["driver_originale_col_nome_RETRY"]),
 ("SHA256 del driver scaricato", "if((Get-FileHash -LiteralPath $drv -Algorithm SHA256).Hash -ne $shaDrv){ throw 'RIGA_ROUND_VPS_RETRY.ps1 scaricata", "if($false){ throw 'RIGA_ROUND_VPS_RETRY.ps1 scaricata", ["driver_mutato"]),
 ("macchina", "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){", "if($false){", ["macchina_VPS", "macchina_vuota"]),
 ("MT5 gia aperto", "if((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){ throw 'MT5 risulta APERTO", "if($false){ throw 'MT5 risulta APERTO", ["mt5_aperto"]),
 ("terminale presente", "if(-not (Test-Path -LiteralPath (Join-Path $TB 'terminal64.exe') -PathType Leaf)){", "if($false){", ["terminale_assente"]),
 ("terminale non collegamento", "-band ([int][IO.FileAttributes]::ReparsePoint)) -ne 0){", "-band ([int][IO.FileAttributes]::ReparsePoint)) -eq 99){", ["terminale_collegamento"]),
 ("guardia EA sui grafici", "if($conEA.Count -gt 0){ foreach($xE", "if($false){ foreach($xE", ["grafico_con_EA", "grafico_illeggibile"]),
 ("guardia EA: zero grafici letti", "if($nChr -eq 0){ throw", "if($false){ throw", ["zero_grafici"]),
 ("coerenza della tabella: maxriprove", "-or $MAXRIP -ne 1 -or", "-or", ["riga_incoerente_maxriprove"]),
 ("coerenza della tabella: ordine dei job", " -or ((@($jobs | ForEach-Object { $_.t })) -join ',') -ne 'R280e,R280a'", "", ["riga_incoerente_ordine_dei_job"]),
 ("coerenza della tabella: sigle", " -or ((@($jobs | ForEach-Object { $_.k })) -join ',') -ne 'e,a'", "", ["riga_incoerente_sigle"]),
 ("coerenza della tabella: EA", "-or @($jobs | Where-Object { $_.e -ne 'ABTG_Nasdaq_Apertura_US' -or", "-or @($jobs | Where-Object { $false -or", ["riga_incoerente_EA"]),
 ("coerenza della tabella: simbolo", " -or $_.s -ne 'U30USD'", "", ["riga_incoerente_simbolo"]),
 ("coerenza della tabella: TF del grafico", " -or $_.tf -ne 'M5'", "", ["riga_incoerente_TF_grafico"]),
 ("coerenza della tabella: modello", " -or $_.m -ne 4", "", ["riga_incoerente_modello"]),
 ("coerenza della tabella: deposito", " -or $_.dp -ne 10000", "", ["riga_incoerente_deposito"]),
 ("coerenza della tabella: fine", " -or $_.d1 -ne '2026.06.30'", "", ["riga_incoerente_d1"]),
 ("coerenza della finestra: d0, me, oa, fz E $cohOk spenti INSIEME", " -or $_.d0 -ne '2024.09.26'", "", ["riga_incoerente_d0", "riga_incoerente_inizio_OOS", "riga_incoerente_fine_IS", "riga_incoerente_frazione"],
  [" -or $_.me -ne '2025.06.30'", " -or $_.oa -ne '2025.07.01'", " -or $_.fz -ne '0.4322'", " -or -not $cohOk"]),
 ("coerenza della tabella: righe di input", " -or $_.np -ne 97", "", ["riga_incoerente_input"]),
 ("coerenza della tabella: impronta di prova lunga 64", " -or $_.hp.Length -ne 64", "", ["riga_incoerente_impronta_prova_corta"]),
 ("coerenza della tabella: asse (nomi)", " -or ((@($jobs | ForEach-Object { $_.ax })) -join ',') -ne 'InpMagic,InpEmaSlow'", "", ["riga_incoerente_asse_nome"]),
 ("coerenza della tabella: conteggio dell asse E righe attese 2,6 (spenti insieme)", "@($_.av).Count -ne $_.nr -or $_.np -ne 97", "$_.np -ne 97", ["riga_incoerente_righe_attese"], " -or ((@($jobs | ForEach-Object { $_.nr })) -join ',') -ne '2,6'"),
 ("coerenza della tabella: asse di e", " -or ((@($jobs[0].av)) -join ',') -ne '798711,798721'", "", ["riga_incoerente_asse_e"]),
 ("coerenza della tabella: asse EmaSlow di a", " -or ((@($jobs[1].av)) -join ',') -ne '220,440,660,880,1100,1320'", "", ["riga_incoerente_asse_EmaSlow_di_a"]),
 ("coerenza della tabella: magic di e vuoto", " -or $jobs[0].mg -ne ''", "", ["riga_incoerente_magic_di_e_pinnato"]),
 ("coerenza della tabella: magic di a", " -or $jobs[1].mg -ne '798701'", "", ["riga_incoerente_magic"]),
 ("coerenza della tabella: per-trade di e", " -or ((@($jobs[0].pm)) -join ',') -ne '798711,798721'", "", ["riga_incoerente_pm_di_e"]),
 ("coerenza della tabella: per-trade di a", " -or ((@($jobs[1].pm)) -join ',') -ne '798701'", "", ["riga_incoerente_pm_di_a"]),
 ("coerenza della tabella: impronte di prova diverse", " -or $jobs[0].hp -eq $jobs[1].hp", "", ["riga_incoerente_impronte_prova_uguali"]),
 ("coerenza della tabella: impronta EA lunga 64", " -or $shaEa.Length -ne 64", "", ["riga_incoerente_impronta_EA_corta"]),
 ("coerenza della tabella: impronta include lunga 64", " -or $shaInc.Length -ne 64", "", ["riga_incoerente_impronta_include_corta"]),
 ("coerenza della tabella: impronta walkforward lunga 64", " -or $shaWf.Length -ne 64", "", ["riga_incoerente_impronta_walkforward_corta"]),
 ("coerenza della tabella: tetto", " -or $TETTO -ne 30", "", ["riga_incoerente_tetto"]),
 ("coerenza della tabella: margine", " -or $MARGINE -ne 10", "", ["riga_incoerente_margine"]),
 # cancello indipendente 01/10/2026 (classe 1051)
 ("giornale contro RIPROVE: SOLO il conto delle morte", " -or $nK -ne $tK){", "){", ["CE4_morte_senza_causa_ma_riprove_dice_INIT"]),
 ("RIPROVE: due tentativi senza il flag RIPROVATA", " -or ($gg.n -eq 2) -ne $gg.rip){", "){", ["CE10_riprove_senza_flag_RIPROVATA"]),
 # per-trade: un file per magic (e ne ha due)
 ("per-trade: solo il primo magic", "foreach($pmg in @($jb.pm)){ $ptN=", "foreach($pmg in @($jb.pm | Select-Object -First 1)){ $ptN=", ["pertrade_vecchio_su_e"]),
 ("file attesi: solo il primo per-trade", "foreach($pmg in @($jb.pm)){ [void]$fAtt.Add(", "foreach($pmg in @($jb.pm | Select-Object -First 1)){ [void]$fAtt.Add(", ["ok"]),
 # IL CANCELLO G0 + G1 CON LA TOLLERANZA: ogni componente (colonna, soglia, bordo, gamba, gemella) e il SOLO a scattare in almeno uno dei casi al bordo (CAN)
 ("[double] al posto di [decimal] nel parser dei numeri", "$dv=[decimal]0; if([decimal]::TryParse(", "$dv=[double]0; if([double]::TryParse(", CAN),
 ("G0: Profit non confrontato", "@('Profit','Profit'), @('Profit Factor','PF')", "@('Profit Factor','PF')", CAN),
 ("G0: PF non confrontato", "@('Profit Factor','PF'), @('Equity DD %','DD')", "@('Equity DD %','DD')", CAN),
 ("G0: DD non confrontato", "@('Equity DD %','DD'), @('Trades','N')", "@('Trades','N')", CAN),
 ("G0: Trades non confrontato", ", @('Trades','N'))){ $tvv=", ")){ $tvv=", CAN),
 ("G0: gamba IS non confrontata", "foreach($tg in @('IS','OOS')){ $tcr=", "foreach($tg in @('OOS')){ $tcr=", CAN),
 ("G0: gamba OOS non confrontata", "foreach($tg in @('IS','OOS')){ $tcr=", "foreach($tg in @('IS')){ $tcr=", CAN),
 ("G0: solo la prima gemella", "foreach($tr in $trw){ foreach($tc in", "foreach($tr in @($trw | Select-Object -First 1)){ foreach($tc in", CAN),
 ("G0: confronto sempre vero", "-not (& $tolOk $tc[0] $tvv $tev)", "$false", CAN),
 ("G1: confronto sempre vero", "-not (& $tolOk $tcn $g1 $g0)", "$false", CAN),
 ("G1: solo la gemella 1 contro se stessa", "$g1=& $decF $trw[1].$tcn;", "$g1=& $decF $trw[0].$tcn;", CAN),
 ("G1: Profit fuori dalle colonne", "foreach($tcn in @('Profit','Profit Factor',", "foreach($tcn in @('Profit Factor',", CAN),
 ("G1: PF fuori dalle colonne", "@('Profit','Profit Factor','Equity DD %','Trades')){ $g0=", "@('Profit','Equity DD %','Trades')){ $g0=", CAN),
 ("G1: DD fuori dalle colonne", "@('Profit','Profit Factor','Equity DD %','Trades')){ $g0=", "@('Profit','Profit Factor','Trades')){ $g0=", CAN),
 ("G1: Trades fuori dalle colonne", "@('Profit','Profit Factor','Equity DD %','Trades')){ $g0=", "@('Profit','Profit Factor','Equity DD %')){ $g0=", CAN),
 ("G1: gemelle non due", "} else { $t1Gem += ($tg + ' righe ' + $trw.Count + ' invece di 2') }", "}", CAN),
 # le soglie (una per volta, di un passo)
 ("soglia Profit 0 (esatto)", "$tolP=& $decF '0.05';", "$tolP=& $decF '0';", CAN),
 ("soglia Profit 0,04", "$tolP=& $decF '0.05';", "$tolP=& $decF '0.04';", CAN),
 ("soglia Profit 0,06", "$tolP=& $decF '0.05';", "$tolP=& $decF '0.06';", CAN),
 ("soglia Profit 1,00", "$tolP=& $decF '0.05';", "$tolP=& $decF '1.00';", CAN),
 ("soglia PF 0,00004", "$tolF=& $decF '0.00005';", "$tolF=& $decF '0.00004';", CAN),
 ("soglia PF 0,00006", "$tolF=& $decF '0.00005';", "$tolF=& $decF '0.00006';", CAN),
 ("soglia PF 0,0002", "$tolF=& $decF '0.00005';", "$tolF=& $decF '0.0002';", CAN),
 ("soglia DD 0,0099", "$tolD=& $decF '0.01';", "$tolD=& $decF '0.0099';", CAN),
 ("soglia DD 0,0101", "$tolD=& $decF '0.01';", "$tolD=& $decF '0.0101';", CAN),
 ("soglia DD 0 (esatto)", "$tolD=& $decF '0.01';", "$tolD=& $decF '0';", CAN),
 ("Trades con tolleranza 1", "if($col -eq 'Trades'){ ($va -eq $vb) }", "if($col -eq 'Trades'){ ($dd -le 1) }", CAN),
 # il bordo e DENTRO: -lt al posto di -le, colonna per colonna
 ("bordo Profit fuori (-lt)", "elseif($col -eq 'Profit'){ ($dd -le $tolP) }", "elseif($col -eq 'Profit'){ ($dd -lt $tolP) }", CAN),
 ("bordo PF fuori (-lt)", "elseif($col -eq 'Profit Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Profit Factor'){ ($dd -lt $tolF) }", CAN),
 ("bordo DD fuori (-lt)", "elseif($col -eq 'Equity DD %'){ ($dd -le $tolD) }", "elseif($col -eq 'Equity DD %'){ ($dd -lt $tolD) }", CAN),
 ("numeri attesi: Profit di IS", "IS=@{Profit='1249.94';", "IS=@{Profit='1249.95';", CAN),
 ("numeri attesi: Profit di OOS", "OOS=@{Profit='2974.09';", "OOS=@{Profit='2974.08';", CAN),
 ("numeri attesi: PF di IS", "PF='1.25920';", "PF='1.25921';", CAN),
 ("numeri attesi: PF di OOS", "PF='1.48133';", "PF='1.48134';", CAN),
 ("numeri attesi: DD di IS", "DD='7.1736';", "DD='7.1737';", CAN),
 ("numeri attesi: DD di OOS", "DD='6.6241';", "DD='6.6242';", CAN),
 ("numeri attesi: Trades di IS", "N='157';", "N='158';", CAN),
 ("numeri attesi: Trades di OOS", "N='199';", "N='200';", CAN),
 ("residui entro tolleranza non elencati (G0)", "elseif($tvv -ne $tev){ $t1Res +=", "elseif($false){ $t1Res +=", CAN),
 ("residui entro tolleranza non elencati (G1)", "elseif($g0 -ne $g1){ $t1Res +=", "elseif($false){ $t1Res +=", CAN),
 ("residui non scritti nel testo del PASS", "' + $resTxt) } else { $t1St='FAIL';", "') } else { $t1St='FAIL';", CAN),
 ("RF: residuo non elencato", "elseif($rfv -ne $rfe){ $t1Res +=", "elseif($false){ $t1Res +=", CAN),
 ("RF: non numerico non blocca", "if($null -eq $rfv){ $t1Dif +=", "if($false){ $t1Dif +=", CAN),
 ("RF: confrontato con tolleranza (blocca)", "elseif($rfv -ne $rfe){ $t1Res +=", "elseif($rfv -ne $rfe){ $t1Dif +=", CAN),
 ("G0: eseguito anche con e NON certificato", "elseif($stMap['R280e'] -ne 'OK' -and $stMap['R280e'] -ne 'OK_RIPROVATO'){", "elseif($false){", ["G_e_asse_sbagliato_NV", "G_e_gamba_morta_MISTO"]),
 ("G0: OK_RIPROVATO non accettato", " -and $stMap['R280e'] -ne 'OK_RIPROVATO'){", "){", ["G_e_riprovata_PASS"]),
 ("G0: e non lanciato non visto", "if($jA.nonLanc){ $t1Txt=", "if($false){ $t1Txt=", ["G_e_non_lanciato"]),
 ("G0: esito PASS senza controllo", "if($t1Dif.Count -eq 0 -and $t1Gem.Count -eq 0){ $t1St='PASS';", "if($true){ $t1St='PASS';", CAN),
 ("G0: G1 ignorato nell esito", "if($t1Dif.Count -eq 0 -and $t1Gem.Count -eq 0){ $t1St='PASS';", "if($t1Dif.Count -eq 0){ $t1St='PASS';", CAN),
 ("G0: G0 ignorato nell esito", "if($t1Dif.Count -eq 0 -and $t1Gem.Count -eq 0){ $t1St='PASS';", "if($t1Gem.Count -eq 0){ $t1St='PASS';", CAN),
 # I NUMERI DI R280a NON SI STAMPANO COL CANCELLO ROSSO (classi 1090 e 1092): ogni uscita e il SOLO a scattare in almeno uno scenario
 ("console: tabella di R280a stampata col cancello rosso (condizione spenta)", "foreach($jb in $jobs){ if($t1St -ne 'PASS' -and $jb.k -ne 'e'){ Write-Host ('   ' + $jb.t + ': NON SI LEGGE", "foreach($jb in $jobs){ if($false){ Write-Host ('   ' + $jb.t + ': NON SI LEGGE", CAN + ["G_e_asse_sbagliato_NV"]),
 ("console: tabella di R280a stampata dopo la riga NON SI LEGGE (continue tolto)", "restano nei CSV della raccolta per la diagnosi') -ForegroundColor Red; continue };", "restano nei CSV della raccolta per la diagnosi') -ForegroundColor Red };", CAN + ["G_e_asse_sbagliato_NV"]),
 ("riepilogo: tabella di R280a scritta col cancello rosso (condizione spenta)", "foreach($jb in $jobs){ if($t1St -ne 'PASS' -and $jb.k -ne 'e'){ [void]$ri.Add('   ' + $jb.t + ': NON SI LEGGE", "foreach($jb in $jobs){ if($false){ [void]$ri.Add('   ' + $jb.t + ': NON SI LEGGE", CAN + ["G_e_asse_sbagliato_NV"]),
 ("riepilogo: tabella di R280a scritta dopo la riga NON SI LEGGE (continue tolto)", "restano nei CSV della raccolta per la diagnosi'); continue };", "restano nei CSV della raccolta per la diagnosi') };", CAN + ["G_e_asse_sbagliato_NV"]),
 ("console: per-trade di R280a stampato col cancello rosso", "foreach($pl in $ptL){ if($t1St -ne 'PASS' -and $pl.k -ne 'e'){ continue }; Write-Host $pl.t", "foreach($pl in $ptL){ Write-Host $pl.t", CAN + ["G_e_asse_sbagliato_NV"]),
 ("riepilogo: per-trade di R280a scritto col cancello rosso", "foreach($pl in $ptL){ if($t1St -ne 'PASS' -and $pl.k -ne 'e'){ continue }; [void]$ri.Add($pl.t) };", "foreach($pl in $ptL){ [void]$ri.Add($pl.t) };", CAN + ["G_e_asse_sbagliato_NV"]),
 # classe 1092: la console del DRIVER di R280a (che stampa i numeri grezzi) va su file, non in finestra; e il file va nella raccolta
 ("classe 1092: console del driver di R280a NON dirottata su file", "if($jb.k -eq 'e'){ & powershell.exe", "if($true){ & powershell.exe", ["ok"] + CAN[:2]),
 ("classe 1092: la console del driver di R280e dirottata su file (il gate non si vedrebbe)", "if($jb.k -eq 'e'){ & powershell.exe", "if($false){ & powershell.exe", ["ok"]),
 ("classe 1092: CONSOLE_DRIVER fuori dalla raccolta", "if($tIni.ContainsKey($jb.t) -and $jb.k -ne 'e'){ $cfj=", "if($false){ $cfj=", ["ok"]),
 ("classe 1092: CONSOLE_DRIVER fuori dai file attesi", "foreach($jb in $jobs){ if($tIni.ContainsKey($jb.t) -and $jb.k -ne 'e'){ [void]$fAtt.Add('CONSOLE_DRIVER", "foreach($jb in $jobs){ if($false){ [void]$fAtt.Add('CONSOLE_DRIVER", ["ok"]),
 ("G0: riga del cancello fuori dal riepilogo", "[void]$ri.Add('STATO: ' + $statiV); [void]$ri.Add($t1Riga);", "[void]$ri.Add('STATO: ' + $statiV);", ["ok", CAN[3]]),
 ("G0: riga del cancello fuori dalla console", "Write-Host $t1Riga -ForegroundColor $t1Col; Write-Host 'NUMERI DAI CSV", "Write-Host 'NUMERI DAI CSV", ["ok"]),
]
riga = open(RIGA, encoding="ascii").read()
tot = 0; prese = 0
FILTRO = sys.argv[2:]          # opzionale: sottostringhe del nome della mutazione (per rigirarne solo alcune)
_parte = os.environ.get("MUT_PART")        # "k/n": solo le mutazioni con indice % n == k (per dividere il lavoro fra piu processi: l esito finale e la somma delle parti)
for _idx, entry in enumerate(M):
    if _parte and _idx % int(_parte.split("/")[1]) != int(_parte.split("/")[0]):
        continue
    nome, vero, mut, scen = entry[:4]
    extra = entry[4] if len(entry) > 4 else None          # altri testi da TOGLIERE (mutazione combinata): una stringa o una lista
    if FILTRO and not any(f in nome for f in FILTRO):
        continue
    tot += 1
    n = riga.count(vero)
    extras = [] if extra is None else ([extra] if isinstance(extra, str) else list(extra))
    if n != 1 or any(riga.count(x) != 1 for x in extras):
        print("NON APPLICABILE (%d occorrenze del testo vero): %s" % (n, nome)); continue
    mutata = riga.replace(vero, mut)
    for x in extras:
        mutata = mutata.replace(x, "")
    f = tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False, encoding="ascii"); f.write(mutata); f.close()
    r = subprocess.run([sys.executable, os.path.join(QD, "battery.py"), PIN, f.name] + scen, capture_output=True, text=True,
                       env=dict(os.environ, HARNESS_OUT=os.environ.get("HARNESS_OUT", "/tmp/r280_mut")))
    rossi = [l.split()[1] for l in r.stdout.splitlines() if l.startswith("FALLITO")]
    ok = len(rossi) > 0
    prese += 1 if ok else 0
    print(("PRESA     " if ok else "NON PRESA ") + nome + "   (rossi: " + (", ".join(rossi[:4]) + (" ..." if len(rossi) > 4 else "") if rossi else "nessuno") + ")")
print("MUTAZIONI PRESE: %d/%d" % (prese, tot))
sys.exit(0 if prese == tot else 1)
