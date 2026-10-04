#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni.py -- il collaudo DEL COLLAUDO (classe 1033): per ogni controllo che la riga LATI dichiara, lo si SPEGNE nella riga assemblata (una sostituzione di testo, una per volta) e si fa
girare la batteria sugli scenari che lo riguardano: almeno uno deve diventare ROSSO. Una mutazione che lascia tutto verde vuol dire che quel controllo NON e' collaudato.
Gli scenari dei cancelli (CA2_nn / CA1_nn) sono gli stessi ~80 casi al bordo del lettore indipendente leggi_lati.py: ogni mutante di soglia/colonna/bordo li fa girare per colonna.
Uso: python3 backtest_pipeline/collaudo_riga_LATI/mutazioni.py [PIN] [filtro ...]    (esce 0 se OGNI mutazione e' presa)
"""
import os, re, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
PIN = sys.argv[1] if len(sys.argv) > 1 else subprocess.check_output(["git", "-C", REPO, "rev-parse", "HEAD"]).decode().strip()
RIGA = os.path.join(REPO, "backtest_pipeline", "righe", "RIGA_ROUND_LATI.txt")
sys.path.insert(0, os.path.join(QD, ".."))
import leggi_lati as LG
CA2 = ["CA2_%02d_%s" % (i, re.sub(r"[^A-Za-z0-9]+", "_", n)[:56].strip("_")) for i, (n, p, a_) in enumerate(LG._casi_a2())]
CA1 = ["CA1_%02d_%s" % (i, re.sub(r"[^A-Za-z0-9]+", "_", n)[:56].strip("_")) for i, (n, p, a_) in enumerate(LG._casi_a1())]
CAN = CA2 + CA1
RES = ["residui_A2_caso_0310", "residui_A1_solo_scarto", "residuo_A1_FAIL_senza_valori"]
def _n(x):
    return re.sub(r"[^A-Za-z0-9]+", "_", x).strip("_").lower()
def sel(*sub, base=None):
    """i casi dei cancelli il cui nome (normalizzato come nei nomi degli scenari: non alfanumerici -> _) contiene UNA delle sottostringhe, normalizzate allo stesso modo.
    Una selezione VUOTA e un errore: la batteria senza nomi gira TUTTI gli scenari e un mutante sarebbe preso per la ragione sbagliata (classe 1101)."""
    r = [n for n in (base or CAN) if any(_n(s) in n.lower() for s in sub)]
    assert r, "selezione vuota per %r" % (sub,)
    return r
SOGLIA = lambda *s: sel(*s) + RES[:2]
# (nome, testo vero, testo mutato, scenari che devono prenderla)
M = [
 ("zip: voci non controllate", "$inZ=($zipE -contains $fa);", "$inZ=$true;", ["zip_senza_un_file"]),
 ("zip: freschezza non controllata", "$zipFr=((Test-Path -LiteralPath $zip) -and ((Get-Item -LiteralPath $zip).LastWriteTime -ge $tRac));", "$zipFr=(Test-Path -LiteralPath $zip);", ["zip_vecchio"]),
 ("asse non controllato", "$gq.axOk=$okA;", "$gq.axOk=$true;", ["asse_non_0_1_su_A1", "asse_ripetuto_su_A2S", "asse_non_arrivato_0_0", "A2L_asse_sbagliato_NV"]),
 ("pin numerici non controllati", "$gq.pinKo=$gq.pinKo+1;", "", ["pin_magic_perso_su_A1S", "pin_lato_pinnato_perso_su_A2L", "pin_lato_pinnato_perso_su_A1S", "pin_rischio_perso_su_A1L", "csv_di_un_altro_job_magic"]),
 ("Trades>0 non controllato", "$co.ok=($co.n -eq $nrAtt -and $co.nTr -eq $nrAtt);", "$co.ok=($co.n -eq $nrAtt);", ["trades_zero_in_una_cella"]),
 ("referto: freschezza", "$refFr=((Test-Path -LiteralPath $refF) -and ((Get-Item -LiteralPath $refF).LastWriteTime -ge $tJ));", "$refFr=(Test-Path -LiteralPath $refF);", ["referto_non_riscritto"]),
 ("referto: riprova e scadenza", " -and $refRip -eq $ripAtt);", ");", ["maxriprove_0_passato", "scadenza_non_passata"]),
 ("referto: nome del driver", " -and $refV['driver'] -eq $nomeWf", "", ["referto_driver_originale"]),
 ("referto: deposito", " -and $refV['deposito'] -eq ('' + $jb.dp)", "", ["deposito_non_passato"]),
 ("referto: modello", " -and $refV['modello'] -eq ('' + $jb.m)", "", ["modello_1_passato"]),
 ("referto: pin", " -and $refV['pin'] -eq $PIN", "", ["pin_diverso_passato"]),
 ("referto: terminale", " -and $refTerm -eq ($TB + '\\terminal64.exe')", "", ["referto_terminale_banco_VPS"]),
 ("cartella vecchia: rimozione non verificata", "Remove-Item -LiteralPath $vec -Recurse -Force -ErrorAction SilentlyContinue; if(Test-Path -LiteralPath $vec){ throw", "Remove-Item -LiteralPath $vec -Recurse -Force -ErrorAction SilentlyContinue; if($false){ throw", ["cartella_vecchia_non_rimovibile"]),
 ("166/892: walkforward_generico_RETRY", "-Algorithm SHA256).Hash -ne $shaWf){", "-Algorithm SHA256).Hash -eq 'X'){", ["walkforward_retry_mutato", "walkforward_originale_col_nome_RETRY"]),
 ("166/892: RIGA_ROUND_VPS_RETRY dopo il job", "elseif((Get-FileHash -LiteralPath $drv -Algorithm SHA256).Hash -ne $shaDrv){ $div +=", "elseif($false){ $div +=", ["riga_retry_locale_mutata_durante_il_quarto_job"]),
 ("166/892: EA", "-Algorithm SHA256).Hash -ne $shaEa){", "-Algorithm SHA256).Hash -eq 'X'){", ["ea_mutato_nel_terzo_job"]),
 ("166/892: include", "-Algorithm SHA256).Hash -ne $shaInc){", "-Algorithm SHA256).Hash -eq 'X'){", ["include_mutato"]),
 ("prova: SHA256 contro il pin", "-Algorithm SHA256).Hash -ne $jb.hp){ $pvTxt=", "-Algorithm SHA256).Hash -eq 'X'){ $pvTxt=", ["prova_mutata"]),
 ("RIPROVE: freschezza", "-and ((Get-Item -LiteralPath $rpF).LastWriteTime -ge $tJ)){ $rp.fr=$true;", "){ $rp.fr=$true;", ["riprove_vecchio"]),
 ("RIPROVE: assente accettato", "elseif(-not $rp.fr){", "elseif($false){", ["riprove_assente", "riprove_vecchio"]),
 ("RIPROVE: numero di righe GAMBA", "elseif($rp.nG -ne 2 -or $null -eq $gI -or $null -eq $gO){", "elseif($false){", ["riprove_una_gamba", "OOS_senza_nessuna_riga_RIPROVE"]),
 ("RIPROVATA non letta", "rip=($tq -clike '*| RIPROVATA | ESITO GAMBA:*');", "rip=$false;", ["A2L_riprovata_e_salvata"]),
 ("CSV PRODOTTO letto sempre", "prod=($tq -cmatch 'ESITO GAMBA: CSV PRODOTTO')}", "prod=$true}", ["A2L_due_gambe_IS_morte_KO", "OOS_dice_NON_PRODOTTO_ma_il_file_c_e", "OOS_degenere_senza_CSV_accettata"]),
 ("giornale contro RIPROVE", "elseif($nLg -ne $tA -or $nS -ne $tP -or $nK -ne $tK -or $nDg -ne 1){", "elseif($false){", ["giornale_e_riprove_non_tornano", "OOS_partita_normalmente", "giornale_OOS_senza_set_mode"]),
 ("giornale contro RIPROVE: SOLO il conto delle degeneri", " -or $nDg -ne 1){", "){", ["giornale_OOS_senza_set_mode"]),
 ("giornale contro RIPROVE: SOLO il conto delle morte", " -or $nK -ne $tK ", " ", ["CE4_morte_senza_causa_ma_riprove_dice_INIT"]),
 ("RIPROVE incoerente (IS)", "elseif(-not $rpCoh){", "elseif($false){", ["riprove_incoerente_IS", "riprove_senza_flag_RIPROVATA"]),
 ("RIPROVE: due tentativi senza il flag RIPROVATA", " -or ($gI.n -eq 2) -ne $gI.rip){", "){", ["riprove_senza_flag_RIPROVATA"]),
 ("esito diverso da PARTITA/MORTA_INIT (IS)", "elseif($tXi -gt 0){", "elseif($false){", ["IS_morta_con_altra_causa"]),
 ("OOS degenere come atteso", "elseif(-not $oosDegOk){", "elseif($false){", ["OOS_riprovata_una_sola_intestazione"]),
 ("OOS degenere: la riprova non e ammessa", " -or $gO.rip){ $oosDegOk=$false }", "){ $oosDegOk=$false }", ["OOS_riprovata_una_sola_intestazione"]),
 ("OOS degenere: il giornale deve avere set mode", "if($tL -match 'Tester\\s+set mode to math calculations or adjust testing dates'){ $cur.deg=$true; continue }; ", "", ["ok", "giornale_OOS_senza_set_mode"]),
 ("OOS: il CSV con righe contraddice la degenere", "elseif($crO.fresco -and $crO.n -gt 0){", "elseif($false){", ["OOS_CSV_con_righe"]),
 ("OOS: il RIPROVE e il file _OOS devono tornare", "elseif($gO.prod -ne $crO.fresco){", "elseif($false){", ["OOS_dice_NON_PRODOTTO_ma_il_file_c_e", "OOS_dice_PRODOTTO_ma_il_file_manca"]),
 ("rc diverso da 2 accettato", "elseif($J.rc -ne 2){", "elseif($false){", ["rc_0_invece_di_2", "rc_3_invece_di_2"]),
 ("rc 1 non fermato", "if($J.rc -eq 1){ $why='rc 1:", "if($false){ $why='rc 1:", ["T1_A1_rc1_NV"]),
 ("referto: riga ESITO (IS prodotta)", "elseif($J.refEs -ne 'NON MISURATO -- CSV mancanti o vuoti: OOS'){", "elseif($false){", ["esito_del_referto_ROUND_GIRATO", "esito_del_referto_solo_IS"]),
 ("referto: riga ESITO (IS non prodotta)", "elseif($J.refEs -ne 'NON MISURATO -- CSV mancanti o vuoti: IS, OOS'){", "elseif($false){", ["esito_del_referto_KO_sbagliato"]),
 ("IS non prodotta: CSV fresco = contraddizione", "else { if($crI.fresco){ $why=('contraddizione: il driver dice CSV NON PRODOTTO per la gamba IS", "else { if($false){ $why=('contraddizione: il driver dice CSV NON PRODOTTO per la gamba IS", ["morta_ma_csv_IS_fresco"]),
 ("KO letto come NV", "$st='KO';", "$st='NV';", ["A2L_due_gambe_IS_morte_KO"]),
 ("IS prodotta: CSV non buono", "elseif($gI.prod){ if(-not $crI.ok){", "elseif($gI.prod){ if($false){", ["csv_IS_0_byte", "IS_assente", "csv_IS_vecchio"]),
 ("OK_RIPROVATO non distinto", "elseif($ripL.Count -gt 0){ $st='OK_RIPROVATO';", "elseif($false){ $st='OK_RIPROVATO';", ["A2L_riprovata_e_salvata"]),
 ("finestra girata", "elseif($nS -ne 1 -or $nWis -ne 1){", "elseif($false){", ["finestra_IS_un_giorno_prima_su_A1", "finestra_IS_un_giorno_prima_su_A2", "CE2_finestra_IS_del_secondo_tentativo_sbagliata"]),
 ("magic del file prova", " -and $pinA['InpMagic'] -eq [double]$jb.mg);", ");", ["riga_magic_diverso_dal_file"]),
 ("lato pinnato del file prova", "$pinA.ContainsKey($jb.fx) -and $pinA[$jb.fx] -eq 1 -and ", "", ["riga_lato_pinnato_diverso_dal_file"]),
 ("l altro lato deve essere l asse (non pinnato)", " -and -not $pinA.ContainsKey($jb.ax)", "", []),
 ("tetto fra i job", "if($minAvv -ge $TETTO){", "if($false){", ["A2L_non_lanciato", "A1S_non_lanciato", "A2S_non_lanciato"]),
 ("RIPROVE fra i file attesi", "[void]$fAtt.Add('ROUND_' + $jb.t + '\\RIPROVE_' + $jb.e + '_' + $jb.s + '_' + $jb.t + '.txt');", "", ["ok", "rp_copia_mancante_in_raccolta"]),
 ("marcatore RETRY_v1 della riga driver", "-Pattern 'MARCATORE_RIGA_ROUND_VPS_RETRY_v1' -Quiet", "-Pattern 'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet", ["driver_originale_col_nome_RETRY"]),
 ("macchina", "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){", "if($false){", ["macchina_VPS"]),
 ("guardia EA sui grafici", "if($conEA.Count -gt 0){ foreach($xE", "if($false){ foreach($xE", ["grafico_con_EA", "grafico_illeggibile"]),
 ("MT5 aperto", "if((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){ throw 'MT5 risulta APERTO", "if($false){ throw 'MT5 risulta APERTO", ["mt5_aperto"]),
 # la tabella dei job: ogni controllo ha uno scenario in cui e' il SOLO a scattare (i controlli sovrapposti sono dichiarati sotto)
 ("coerenza della tabella: maxriprove", "-or $MAXRIP -ne 1 -or", "-or", ["riga_incoerente_maxriprove"]),
 ("coerenza della tabella: ordine dei job", " -or ((@($jobs | ForEach-Object { $_.t })) -join ',') -ne 'LATIA2L,LATIA2S,LATIA1L,LATIA1S'", "", ["riga_incoerente_ordine_dei_job"]),
 ("coerenza della tabella: deposito", " -or $_.dp -ne 100000", "", ["riga_incoerente_deposito"]),
 ("coerenza della tabella: modello", " -or $_.m -ne 4", "", ["riga_incoerente_modello"]),
 ("coerenza della tabella: simbolo", " -or $_.s -ne 'U30USD'", "", ["riga_incoerente_simbolo"]),
 ("coerenza della tabella: righe attese del CSV", " -or $_.nr -ne 2", "", ["riga_incoerente_righe_attese"]),
 ("coerenza della tabella: valori dell asse", " -or ((@($_.av)) -join ',') -ne '0,1'", "", ["riga_incoerente_valori_asse"]),
 ("coerenza della tabella: asse di ogni job", " -or ((@($jobs | ForEach-Object { $_.ax })) -join ',') -ne 'InpAllowShort,InpAllowLong,InpAllowShort,InpAllowLong'", "", ["riga_incoerente_asse_di_A1S"]),
 ("coerenza della tabella: lato pinnato di ogni job", " -or ((@($jobs | ForEach-Object { $_.fx })) -join ',') -ne 'InpAllowLong,InpAllowShort,InpAllowLong,InpAllowShort'", "", ["riga_incoerente_lato_pinnato"]),
 ("coerenza della tabella: magic pinnati", " -or ((@($jobs | ForEach-Object { $_.mg })) -join ',') -ne '764102,764103,764100,764101'", "", ["riga_incoerente_magic"]),
 ("coerenza della tabella: magic dei per-trade", " -or ((@($jobs | ForEach-Object { $_.pm })) -join ',') -ne '764102,764103,764100,764101'", "", ["riga_incoerente_magic_per_trade"]),
 ("coerenza della tabella: file prova", " -or ((@($jobs | ForEach-Object { $_.p })) -join ',') -ne 'LATI_A2_EMA200_U30USD_TORO_long.txt,LATI_A2_EMA200_U30USD_TORO_short.txt,LATI_A1_EMA200_U30USD_DISCESA_long.txt,LATI_A1_EMA200_U30USD_DISCESA_short.txt'", "", ["riga_incoerente_file_prova"]),
 ("coerenza della tabella: numeri noti (console)", " -or ((@($jobs | ForEach-Object { $_.nt })) -join ',') -ne '1,1,0,0'", "", ["riga_incoerente_numeri_noti"]),
 ("coerenza della tabella: finestre", " -or ((@($jobs | ForEach-Object { $_.d0 + '/' + $_.d1 })) -join ',') -ne '2025.06.10/2026.06.30,2025.06.10/2026.06.30,2025.02.01/2025.04.30,2025.02.01/2025.04.30'", "", []),
 ("coerenza della tabella: inizio della gamba OOS degenere", " -or ((@($jobs | ForEach-Object { $_.oa })) -join ',') -ne '2026.07.01,2026.07.01,2025.05.01,2025.05.01'", "", []),
 ("coerenza della tabella: tetto", " -or $TETTO -ne 25", "", ["riga_incoerente_tetto"]),
 ("coerenza della tabella: margine", " -or $MARGINE -ne 5", "", ["riga_incoerente_margine"]),
 ("coerenza della tabella: righe di input", " -or $_.np -ne 42", "", ["riga_incoerente_input"]),
 ("coerenza della tabella: frazione e finestra IS-OOS (cohOk)", " -or -not $cohOk", "", []),
 # il confronto giornale/RIPROVE (classe 1051)
 ("giornale contro RIPROVE: SOLO il conto delle intestazioni", "elseif($nLg -ne $tA -or", "elseif($false -or", ["giornale_con_intestazione_in_piu"]),
 # per-trade: un file per magic
 ("per-trade: freschezza", "-and ((Get-Item -LiteralPath $ptf).LastWriteTime -ge $tIni[$jb.t])){ Copy-Item", "){ Copy-Item", ["pertrade_vecchio_su_A2L"]),
 ("per-trade: chiusure oltre la finestra", "elseif([string]::CompareOrdinal($ctS[$ctS.Count-1], $jb.oa) -lt 0){", "elseif($true){", ["pertrade_oltre_la_finestra_su_A1L"]),
 ("per-trade: magic estraneo contato", "-ne $pmg }).Count;", "-ne $pmg -and $false }).Count;", ["pertrade_magic_estraneo_su_A2S"]),
 # ---- I CANCELLI: ogni componente (colonna, soglia, bordo, cella, gemella, tipo numerico) e il SOLO a scattare in almeno uno dei casi al bordo
 ("S1: Profit non confrontato", "foreach($tc in @(@('Profit','Profit'), @('Profit Factor','PF'), @('Equity DD %','DD'), @('Trades','N'))){ $tvv=& $decF $sp[1]", "foreach($tc in @(@('Profit Factor','PF'), @('Equity DD %','DD'), @('Trades','N'))){ $tvv=& $decF $sp[1]", sel("Profit +", "Profit -", "Profit +0,97", "R235", "deposito")),
 ("S1: PF non confrontato", "@(@('Profit','Profit'), @('Profit Factor','PF'), @('Equity DD %','DD'), @('Trades','N'))){ $tvv=& $decF $sp[1]", "@(@('Profit','Profit'), @('Equity DD %','DD'), @('Trades','N'))){ $tvv=& $decF $sp[1]", sel("PF 1.52386", "PF +0,0002")),
 ("S1: DD non confrontato", "@('Equity DD %','DD'), @('Trades','N'))){ $tvv=& $decF $sp[1]", "@('Trades','N'))){ $tvv=& $decF $sp[1]", sel("7.8324 su entrambe", "7.8322")),
 ("S1: Trades non confrontato", ", @('Trades','N'))){ $tvv=& $decF $sp[1]", ")){ $tvv=& $decF $sp[1]", sel("Trades 516 su entrambe", "Trades 518")),
 ("S1: solo la cella L+S del file long", "foreach($sp in @(@('LATIA2L',$cLL), @('LATIA2S',$cSL))){", "foreach($sp in @(@('LATIA2L',$cLL))){", sel("sulla gemella short")),
 ("S1: solo la cella L+S del file short", "foreach($sp in @(@('LATIA2L',$cLL), @('LATIA2S',$cSL))){", "foreach($sp in @(@('LATIA2S',$cSL))){", sel("su entrambe")),
 ("S1: confronto sempre vero", "if($null -eq $tvv -or -not (& $tolOk $tc[0] $tvv $tev $pEx $nEx)){ $s1Dif +=", "if($false){ $s1Dif +=", sel("su entrambe", "sulla gemella short", "deposito")),
 ("S2: n non controllato", "if($null -eq $nv -or [Math]::Abs($nv - $nT) -gt ($nT * $tolN)){ $s2Dif +=", "if($false){ $s2Dif +=", sel("puro n ")),
 ("S2: PF non controllato", "if($null -eq $pv -or [Math]::Abs($pv - $pT) -gt $tolB){ $s2Dif +=", "if($false){ $s2Dif +=", sel("puro PF")),
 ("S2: solo la pura LONG", "foreach($sp in @(@('LATIA2L pura LONG',$cLP,$s2Exp['L']), @('LATIA2S pura SHORT',$cSP,$s2Exp['S']))){", "foreach($sp in @(@('LATIA2L pura LONG',$cLP,$s2Exp['L']))){", sel("SHORT puro")),
 ("S2: solo la pura SHORT", "foreach($sp in @(@('LATIA2L pura LONG',$cLP,$s2Exp['L']), @('LATIA2S pura SHORT',$cSP,$s2Exp['S']))){", "foreach($sp in @(@('LATIA2S pura SHORT',$cSP,$s2Exp['S']))){", sel("LONG puro")),
 ("S2: bordo n fuori (-ge)", "[Math]::Abs($nv - $nT) -gt ($nT * $tolN)", "[Math]::Abs($nv - $nT) -ge ($nT * $tolN)", []),   # EQUIVALENTE: il bordo esatto e' 241 x 0,02 = 4,82 e 302 x 0,02 = 6,04, non interi: nessun n intero lo raggiunge
 ("S2: bordo PF fuori (-ge)", "[Math]::Abs($pv - $pT) -gt $tolB", "[Math]::Abs($pv - $pT) -ge $tolB", sel("puro PF")),
 ("S2: soglia n 1 per cento", "$tolN=& $decF '0.02';", "$tolN=& $decF '0.01';", sel("puro n ")),
 ("S2: soglia n 3 per cento", "$tolN=& $decF '0.02';", "$tolN=& $decF '0.03';", sel("puro n ")),
 ("S2: soglia PF 0,04", "$tolB=& $decF '0.05';", "$tolB=& $decF '0.04';", sel("puro PF")),
 ("S2: soglia PF 0,06", "$tolB=& $decF '0.05';", "$tolB=& $decF '0.06';", sel("puro PF")),
 ("S2: i numeri attesi di R110 (n LONG)", "L=@{N='241';", "L=@{N='240';", sel("puro n ", "R110 veri")),
 ("T2: confronto sempre vero", "-not (& $tolOk $tcn $g1 $g0 $pG $nG)){ $t2Dif +=", "$false){ $t2Dif +=", sel("sulla gemella short")),
 ("T2: la gemella contro se stessa", "$g1=& $decF $cSL.$tcn;", "$g1=& $decF $cLL.$tcn;", sel("sulla gemella short", "Recovery", "EP ", "Sharpe")),
 ("A1: confronto sempre vero", "-not (& $tolOk $tcn $g1 $g0 $pG1 $nG1)){ $a1Dif +=", "$false){ $a1Dif +=", sel("A1 ")),
 ("A1: la gemella contro se stessa", "$g1=& $decF $dSL.$tcn;", "$g1=& $decF $dLL.$tcn;", sel("A1 ")),
 ("colonna Profit fuori da gCol", "$gCol=@('Profit','Expected Payoff',", "$gCol=@('Expected Payoff',", sel("Profit +0,60", "A1 Profit")),
 ("colonna Expected Payoff fuori da gCol", "@('Profit','Expected Payoff','Profit Factor'", "@('Profit','Profit Factor'", sel("EP ", "A1 EP")),
 ("colonna PF fuori da gCol", "'Expected Payoff','Profit Factor','Recovery Factor'", "'Expected Payoff','Recovery Factor'", sel("PF +0,00021 sulla gemella", "A1 PF")),
 ("colonna Recovery Factor fuori da gCol", "'Profit Factor','Recovery Factor','Sharpe Ratio'", "'Profit Factor','Sharpe Ratio'", sel("Recovery", "A1 RF")),
 ("colonna Sharpe fuori da gCol", "'Recovery Factor','Sharpe Ratio','Equity DD %'", "'Recovery Factor','Equity DD %'", sel("Sharpe", "A1 Sharpe")),
 ("colonna DD fuori da gCol", "'Sharpe Ratio','Equity DD %','Trades');", "'Sharpe Ratio','Trades');", sel("Equity DD", "A1 Equity")),
 ("colonna Trades fuori da gCol", "'Sharpe Ratio','Equity DD %','Trades');", "'Sharpe Ratio','Equity DD %');", sel("Trades 516 sulla gemella", "A1 Trades")),
 ("soglia Profit 0 (esatto)", "$tolP=& $decF '1.00';", "$tolP=& $decF '0';", SOGLIA("Profit")),
 ("soglia Profit 0,50", "$tolP=& $decF '1.00';", "$tolP=& $decF '0.50';", SOGLIA("Profit")),
 ("soglia Profit 1,01", "$tolP=& $decF '1.00';", "$tolP=& $decF '1.01';", SOGLIA("Profit")),
 ("soglia Profit 2,00", "$tolP=& $decF '1.00';", "$tolP=& $decF '2.00';", SOGLIA("Profit")),
 ("soglia PF/RF 0,0001", "$tolF=& $decF '0.0002';", "$tolF=& $decF '0.0001';", SOGLIA("PF", "RF", "Recovery")),
 ("soglia PF/RF 0,0003", "$tolF=& $decF '0.0002';", "$tolF=& $decF '0.0003';", SOGLIA("PF", "RF", "Recovery")),
 ("soglia RF sola 0,0001", "elseif($col -eq 'Recovery Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Recovery Factor'){ ($dd -le [decimal]'0.0001') }", SOGLIA("Recovery", "RF")),
 ("soglia RF sola 0,0003", "elseif($col -eq 'Recovery Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Recovery Factor'){ ($dd -le [decimal]'0.0003') }", SOGLIA("Recovery", "RF")),
 ("soglia PF sola 0,0001", "elseif($col -eq 'Profit Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Profit Factor'){ ($dd -le [decimal]'0.0001') }", SOGLIA("PF")),
 ("soglia PF sola 0,0003", "elseif($col -eq 'Profit Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Profit Factor'){ ($dd -le [decimal]'0.0003') }", SOGLIA("PF")),
 ("soglia EP/Sharpe 0,50", "$tolK=& $decF '1.00';", "$tolK=& $decF '0.50';", SOGLIA("EP ", "Sharpe")),
 ("soglia EP/Sharpe 2,00", "$tolK=& $decF '1.00';", "$tolK=& $decF '2.00';", SOGLIA("EP ", "Sharpe")),
 ("EP: soglia assoluta 1,00 (senza Trades)", "(($dd * $nRef) -le $tolK)", "($dd -le $tolK)", sel("EP ")),
 ("EP: moltiplicato per il Profit invece dei Trades", "(($dd * $nRef) -le $tolK)", "(($dd * $pRef) -le $tolK)", sel("EP ")),
 ("Sharpe: soglia assoluta 1,00 (senza Profit)", "(($dd * [Math]::Abs($pRef)) -le ([Math]::Abs($vb) * $tolK))", "($dd -le $tolK)", sel("Sharpe")),
 ("Sharpe: senza il valore dello Sharpe a destra", "(($dd * [Math]::Abs($pRef)) -le ([Math]::Abs($vb) * $tolK))", "(($dd * [Math]::Abs($pRef)) -le $tolK)", sel("Sharpe")),
 ("Trades con tolleranza 1", "if($col -eq 'Trades'){ ($va -eq $vb) }", "if($col -eq 'Trades'){ ($dd -le 1) }", SOGLIA("Trades")),
 ("DD con tolleranza 0,0001", "elseif($col -eq 'Equity DD %'){ ($va -eq $vb) }", "elseif($col -eq 'Equity DD %'){ ($dd -le [decimal]'0.0001') }", SOGLIA("Equity DD")),
 ("DD con tolleranza 0,001", "elseif($col -eq 'Equity DD %'){ ($va -eq $vb) }", "elseif($col -eq 'Equity DD %'){ ($dd -le [decimal]'0.001') }", SOGLIA("Equity DD")),
 ("bordo Profit fuori (-lt)", "($dd -le $tolP)", "($dd -lt $tolP)", sel("Profit +1,00", "Profit -1,00", "A1 Profit +1,00", "A1 Profit -1,00")),
 ("bordo PF fuori (-lt)", "elseif($col -eq 'Profit Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Profit Factor'){ ($dd -lt $tolF) }", sel("PF +0,00020", "PF -0,00020", "PF +0,0002 (", "PF -0,0002 (")),
 ("bordo RF fuori (-lt)", "elseif($col -eq 'Recovery Factor'){ ($dd -le $tolF) }", "elseif($col -eq 'Recovery Factor'){ ($dd -lt $tolF) }", sel("Recovery Factor +0,0002", "Recovery Factor -0,0002", "RF +0,0002", "RF -0,0002")),
 # NOTA: i mutanti EQUIVALENTI della classe 1091 (bordo EP e Sharpe fuori con -lt: il bordo esatto 1/Trades e Sharpe/Profit non e un multiplo di 1e-5, la risoluzione dei CSV; [double] al posto di
 # [decimal]; riferimento dello Sharpe = gemella 0 o 1) valgono anche qui e NON si ripetono: stessa funzione tolOk, stessa risoluzione dei CSV (calcolati a mano il 03/10 per EMAGEM2).
 ("residui entro tolleranza non elencati (S1)", "elseif($tvv -ne $tev){ $a2Res +=", "elseif($false){ $a2Res +=", ["residui_A2_caso_0310"]),
 ("residui entro tolleranza non elencati (T2)", "elseif($g0 -ne $g1){ $a2Res +=", "elseif($false){ $a2Res +=", ["residui_A2_caso_0310"]),
 ("residui entro tolleranza non elencati (A1)", "elseif($g0 -ne $g1){ $a1Res +=", "elseif($false){ $a1Res +=", ["residui_A1_solo_scarto"]),
 ("residui non scritti nel testo del PASS (A2)", "' + $resTxt + ' INFORMATIVO sulle celle pure: '", "' + ' INFORMATIVO sulle celle pure: '", ["residui_A2_caso_0310"]),
 ("residui non scritti nel testo del PASS (A1)", "' + $resTxt1) } else { $gA1St='FAIL';", "') } else { $gA1St='FAIL';", ["residui_A1_solo_scarto"]),
 ("A2: esito PASS senza controllo", "if($s1Dif.Count -eq 0 -and $s2Dif.Count -eq 0 -and $t2Dif.Count -eq 0){ $gA2St='PASS';", "if($true){ $gA2St='PASS';", CA2),
 ("A2: S1 ignorato nell esito", "if($s1Dif.Count -eq 0 -and $s2Dif.Count -eq 0 -and $t2Dif.Count -eq 0){ $gA2St='PASS';", "if($s2Dif.Count -eq 0 -and $t2Dif.Count -eq 0){ $gA2St='PASS';", sel("Profit +1,01 su entrambe", "Trades 516 su entrambe", "deposito")),
 ("A2: S2 ignorato nell esito", "if($s1Dif.Count -eq 0 -and $s2Dif.Count -eq 0 -and $t2Dif.Count -eq 0){ $gA2St='PASS';", "if($s1Dif.Count -eq 0 -and $t2Dif.Count -eq 0){ $gA2St='PASS';", sel("puro n 246", "puro PF 1.29104")),
 ("A2: T2 ignorato nell esito", "if($s1Dif.Count -eq 0 -and $s2Dif.Count -eq 0 -and $t2Dif.Count -eq 0){ $gA2St='PASS';", "if($s1Dif.Count -eq 0 -and $s2Dif.Count -eq 0){ $gA2St='PASS';", sel("Recovery Factor +0,0003", "EP +0,00194", "Sharpe +0,00036")),
 ("A1: esito PASS senza controllo", "if($a1Dif.Count -eq 0){ $gA1St='PASS';", "if($true){ $gA1St='PASS';", sel("A1 ", base=CA1)),
 ("A2: eseguito anche con A2 NON certificato", "elseif(-not (& $okSt $stMap['LATIA2L']) -or -not (& $okSt $stMap['LATIA2S'])){", "elseif($false){", ["A2L_asse_sbagliato_NV", "A2L_due_gambe_IS_morte_KO"]),
 ("A1: eseguito anche con A1 NON certificato", "elseif(-not (& $okSt $stMap['LATIA1L']) -or -not (& $okSt $stMap['LATIA1S'])){", "elseif($false){", ["A1S_gamba_IS_morta_due_volte_KO_A2_resta_PASS", "T1_A1_rc1_NV"]),
 ("A2: OK_RIPROVATO non accettato", "($sx -eq 'OK' -or $sx -eq 'OK_RIPROVATO')", "($sx -eq 'OK')", ["A2L_riprovata_e_salvata", "A1S_riprovata_e_salvata", "tutti_i_job_riprovati"]),
 ("A2: non lanciato non visto", "if($jL2.nonLanc -or $jS2.nonLanc){", "if($false){", ["A2L_non_lanciato"]),
 ("A1: non lanciato non visto", "if($jL1.nonLanc -or $jS1.nonLanc){", "if($false){", ["A1S_non_lanciato"]),
 ("cella per valore dell asse: sempre la prima riga", "$rr=@($cr.rows | Where-Object { (& $numF $_.$axn) -eq $val }); if($rr.Count -eq 1){ $rr[0] } else { $null }", "$rr=@($cr.rows); if($rr.Count -ge 1){ $rr[0] } else { $null }", ["ok", CA2[0], CA2[3]]),
 # LA LETTURA DI A1 SI PERMETTE SOLO A TUTTI E TRE I CANCELLI PASS
 ("lettura A1: il cancello A2 ignorato", "$leggiA1=($gA2St -eq 'PASS' -and $gA1St -eq 'PASS');", "$leggiA1=($gA1St -eq 'PASS');", sel("Profit +1,01 sulla gemella", "puro n 246", "deposito", "Trades 516 su entrambe")),
 ("lettura A1: il cancello A1 ignorato", "$leggiA1=($gA2St -eq 'PASS' -and $gA1St -eq 'PASS');", "$leggiA1=($gA2St -eq 'PASS');", sel("A1 Profit +1,01", "A1 Trades 83", "A1 PF +0,00021")),
 ("lettura A1: sempre permessa", "$leggiA1=($gA2St -eq 'PASS' -and $gA1St -eq 'PASS');", "$leggiA1=$true;", ["A1S_gamba_IS_morta_due_volte_KO_A2_resta_PASS", "A2L_due_gambe_IS_morte_KO", CA1[2]]),
 # I NUMERI DI A1 NON SI STAMPANO COL CANCELLO NON PASS (classe 1090): ogni uscita e il SOLO a scattare in almeno uno scenario
 ("console: tabella di A1 stampata col cancello rosso (condizione spenta)", "foreach($jb in $jobs){ if(-not $leggiA1 -and $jb.nt -eq 0){ Write-Host ('   ' + $jb.t + ': NON SI LEGGE", "foreach($jb in $jobs){ if($false){ Write-Host ('   ' + $jb.t + ': NON SI LEGGE", [CA1[2], "A2L_asse_sbagliato_NV"]),
 ("console: tabella di A1 stampata dopo la riga NON SI LEGGE (continue tolto)", "restano nei CSV della raccolta per la diagnosi') -ForegroundColor Red; continue };", "restano nei CSV della raccolta per la diagnosi') -ForegroundColor Red };", [CA1[2], "A2L_asse_sbagliato_NV"]),
 ("riepilogo: tabella di A1 scritta col cancello rosso (condizione spenta)", "foreach($jb in $jobs){ if(-not $leggiA1 -and $jb.nt -eq 0){ [void]$ri.Add('   ' + $jb.t + ': NON SI LEGGE", "foreach($jb in $jobs){ if($false){ [void]$ri.Add('   ' + $jb.t + ': NON SI LEGGE", [CA1[2], "A2L_asse_sbagliato_NV"]),
 ("riepilogo: tabella di A1 scritta dopo la riga NON SI LEGGE (continue tolto)", "restano nei CSV della raccolta per la diagnosi'); continue };", "restano nei CSV della raccolta per la diagnosi') };", [CA1[2], "A2L_asse_sbagliato_NV"]),
 ("console: per-trade di A1 stampato col cancello rosso", "foreach($pl in $ptL){ if(-not $leggiA1 -and $pl.nt -eq 0){ continue }; Write-Host $pl.t", "foreach($pl in $ptL){ Write-Host $pl.t", [CA1[2], "A2L_asse_sbagliato_NV"]),
 ("riepilogo: per-trade di A1 scritto col cancello rosso", "foreach($pl in $ptL){ if(-not $leggiA1 -and $pl.nt -eq 0){ continue }; [void]$ri.Add($pl.t) };", "foreach($pl in $ptL){ [void]$ri.Add($pl.t) };", [CA1[2], "A2L_asse_sbagliato_NV"]),
 ("console del driver di A1 NON dirottata su file", " -RiprovaEntro $scadTxt 1> $conF }", " -RiprovaEntro $scadTxt }", ["ok", CA1[2]]),
 ("console del driver: la scelta per numeri noti", "if($jb.nt -eq 1){ & powershell.exe", "if($true){ & powershell.exe", ["ok", CA1[2]]),
 ("console del driver di A1 fuori dallo zip", "foreach($jb in $jobs){ if($tIni.ContainsKey($jb.t) -and $jb.nt -eq 0){ [void]$fAtt.Add('CONSOLE_DRIVER", "foreach($jb in $jobs){ if($false){ [void]$fAtt.Add('CONSOLE_DRIVER", ["ok", "zip_senza_console_driver_A1"]),
 ("console del driver di A1 non copiata", "if($tIni.ContainsKey($jb.t) -and $jb.nt -eq 0){ $cfj=", "if($false){ $cfj=", ["ok", "zip_senza_console_driver_A1"]),
 ("A1 FAIL: il testo stampa valori invece dei soli scarti", "$a1Dif += ($tcn + ' scarto ' + $(if($null -eq $g0 -or $null -eq $g1){'non numerico'}else{([Math]::Abs($g1 - $g0)).ToString([Globalization.CultureInfo]::InvariantCulture)}))", "$a1Dif += ($tcn + ' [' + $dLL.$tcn + '] contro [' + $dSL.$tcn + ']')", ["residuo_A1_FAIL_senza_valori", CA1[2]]),
 ("riga dei cancelli fuori dal riepilogo (A2)", "[void]$ri.Add('STATO: ' + $statiV); [void]$ri.Add($gA2Riga);", "[void]$ri.Add('STATO: ' + $statiV);", ["ok"]),
]
riga = open(RIGA, encoding="ascii").read()
tot = 0; prese = 0; nonapp = 0; nonprese = []
FILTRO = sys.argv[2:]          # opzionale: sottostringhe del nome della mutazione (per rigirarne solo alcune)
for nome, vero, mut, scen in M:
    if FILTRO and not any(f in nome for f in FILTRO):
        continue
    if not scen:
        continue          # mutazioni dichiarate SOVRAPPOSTE (difesa in profondita'): si contano a parte, vedi la nota sotto
    tot += 1
    n = riga.count(vero)
    if n != 1:
        print("NON APPLICABILE (%d occorrenze del testo vero): %s" % (n, nome)); nonapp += 1; continue
    f = tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False, encoding="ascii"); f.write(riga.replace(vero, mut)); f.close()
    r = subprocess.run([sys.executable, os.path.join(QD, "battery.py"), PIN, f.name] + scen, capture_output=True, text=True,
                       env=dict(os.environ, HARNESS_OUT=os.environ.get("HARNESS_OUT", "/tmp/lati_mut"), PAR=os.environ.get("PAR", "4")))
    rossi = [l.split()[1] for l in r.stdout.splitlines() if l.startswith("FALLITO")]
    ok = len(rossi) > 0
    prese += 1 if ok else 0
    if not ok:
        nonprese.append(nome)
    print(("PRESA     " if ok else "NON PRESA ") + nome + "   (rossi: " + (", ".join(rossi[:4]) + (" ..." if len(rossi) > 4 else "") if rossi else "nessuno") + ")")
    sys.stdout.flush()
# NOTA, mutazioni SOVRAPPOSTE (scenari vuoti sopra, non contate): la coerenza della tabella controlla alcuni valori in DUE punti (per esempio la finestra: lista d0/d1, me = d1 e cohOk;
# il lato pinnato nel file prova: idOk e il confronto con la tabella): togliendone UNO l altro scatta lo stesso, quindi il mutante e EQUIVALENTE e non si puo prendere con nessuno scenario.
# Sono difesa in profondita', dichiarate, NON collaudate una per una: finestre (d0/d1 e me = d1), inizio della gamba OOS (oa, cohOk), -and -not $pinA.ContainsKey($jb.ax) (l asse non e pinnato:
# il parser del file prova lo scarta gia'), il bordo di n della banda S2 (4,82 e 6,04 non sono interi: nessun numero di deal lo raggiunge, EQUIVALENTE per costruzione, come il bordo di EP e Sharpe della classe 1091), cohOk (frazione/finestra: ogni scenario che lo fa scattare fa scattare anche la lista delle date o me = d1).
print("MUTAZIONI PRESE: %d/%d   (non applicabili: %d)" % (prese, tot, nonapp))
sys.exit(0 if prese == tot and nonapp == 0 else 1)
