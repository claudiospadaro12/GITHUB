#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni.py -- ogni mutazione SPEGNE UN controllo (o sposta una soglia) in PASSATA_STOP_SUPREV_NAS.ps1; gli scenari della batteria che la devono prendere (elencati per nome, scritti PRIMA di lanciare)
devono, sullo script mutato, diventare ROSSI: almeno uno per mutazione. Se nessuno diventa rosso, la mutazione e' "SOPRAVVISSUTA" = il controllo non e' provato dalla batteria.
Uso: python3 mutazioni.py [--solo SOTTOSTRINGA] [--jobs N]   -> ultima riga "MUTAZIONI R290A: n prese su m (equivalenti dichiarati: k)"
EQUIVALENTI dichiarati (la mutazione non cambia il comportamento osservabile, e si dice perche'):
  - rimuovere "Remove-Item $zip" prima di Compress-Archive: Compress-Archive -Force sostituisce comunque lo zip.
"""
import os, sys
from multiprocessing import Pool
import banco, battery

SCR = open(banco.SCRIPT, "rb").read().decode("ascii")


def M(nome, old, new, catturano, tutte=False):
    assert SCR.count(old) >= 1, (nome, old)
    if not tutte:
        assert SCR.count(old) == 1, (nome, "ambigua", SCR.count(old))
    return (nome, old, new, catturano, tutte)


SCEN_G0 = ["02_g0_trades_169", "02_g0_trades_175", "02_g0_trades_168", "02_g0_trades_176", "03_g0_profitto_4511.04", "03_g0_profitto_4511.03", "03_g0_profitto_4886.96", "03_g0_profitto_4886.97"]
MUT = [
    M("g0_bloccante_spento", "$g0OK = ($g0Motivi.Count -eq 0)", "$g0OK = $true", ["04_g0_report_assente", "02_g0_trades_176", "03_g0_profitto_4886.97"]),
    M("g0_tolleranza_n_3_a_4", "$G0_N_TOL  = 3", "$G0_N_TOL  = 4", ["02_g0_trades_168", "02_g0_trades_176"]),
    M("g0_tolleranza_n_3_a_2", "$G0_N_TOL  = 3", "$G0_N_TOL  = 2", ["02_g0_trades_169", "02_g0_trades_175"]),
    M("g0_n_centro_172_a_173", "$G0_N      = 172", "$G0_N      = 173", ["02_g0_trades_169", "02_g0_trades_176"]),
    M("g0_pct_4_a_5", "$G0_PCT    = [decimal]4", "$G0_PCT    = [decimal]5", ["03_g0_profitto_4511.03", "03_g0_profitto_4886.97"]),
    M("g0_pct_4_a_3", "$G0_PCT    = [decimal]4", "$G0_PCT    = [decimal]3", ["03_g0_profitto_4511.04", "03_g0_profitto_4886.96"]),
    M("g0_profitto_centro_4699_a_4700", "$G0_PROF   = [decimal]4699", "$G0_PROF   = [decimal]4700", ["03_g0_profitto_4511.04", "03_g0_profitto_4886.97"]),
    M("g0_profitto_senza_valore_assoluto", "[math]::Abs($lr.Profitto - $G0_PROF) * 100 -gt", "($lr.Profitto - $G0_PROF) * 100 -gt", ["03_g0_profitto_meno_4699"]),
    M("g0_n_senza_valore_assoluto", "[math]::Abs($lr.Trades - $G0_N) -gt", "($lr.Trades - $G0_N) -gt", ["02_g0_trades_168"]),
    M("g0_identita_simbolo_spenta", "if($null -ne $lr.Simbolo -and $lr.Simbolo -ne $SIMBOLO)", "if($false)", ["04f_g0_report_di_altro_simbolo"]),
    M("g0_identita_EA_spenta", "if($null -ne $lr.Expert -and $lr.Expert -ne $EXPERT)", "if($false)", ["04g_g0_report_di_altro_EA"]),
    M("g0_identita_periodo_spenta", "if($null -ne $lr.Periodo -and -not $lr.Periodo.StartsWith($PERIODO + '(' + $DataDa + '-' + $DataA + ')'))", "if($false)", ["04h_g0_report_di_altro_periodo"]),
    M("report_vecchio_accettato_cr", "| Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending)\n  if($cr.Count", "| Sort-Object LastWriteTime -Descending)\n  if($cr.Count", ["04b_g0_report_vecchio_non_si_usa", "04c_g0_report_vecchio_in_installazione_non_si_usa"]),
    M("report_non_cercato_in_MQL5_Files", "foreach($rad in @($InstAttesa, $DataFolder, $Work, $MqlFiles)){", "foreach($rad in @($InstAttesa, $DataFolder, $Work)){", ["01i_report_in_MQL5_Files"]),
    M("etichetta_inglese_trades_tolta", "@('Numero di Operazioni di Trading Totali', 'Total Trades')", "@('Numero di Operazioni di Trading Totali')", ["01e_report_inglese"]),
    M("etichetta_italiana_trades_tolta", "@('Numero di Operazioni di Trading Totali', 'Total Trades')", "@('Total Trades')", ["01_due_lati_insieme_verde"]),
    M("trades_letti_da_affari_totali", "$vt = CercaCella $t @('Numero di Operazioni di Trading Totali', 'Total Trades')", "$vt = CercaCella $t @('Affari Totali', 'Total Deals')", ["01_due_lati_insieme_verde", "02_g0_trades_175"]),
    M("separatori_migliaia_non_tolti", "([regex]::Replace($m.Groups[1].Value, '\\s', ''))", "$m.Groups[1].Value", ["01f_report_con_nbsp_nei_migliaia", "01_due_lati_insieme_verde"]),
    M("input_del_report_non_confrontati", "if($lr.Inputs[$kv[0]] -ieq $kv[1]){ $inOk = $inOk + 1 }", "if($true){ $inOk = $inOk + 1 }", ["04i_g0_input_del_report_diversi_non_blocca"]),
    M("regex_input_senza_lookahead", "'\\|(Inp[A-Za-z0-9_]+)=([^|]*)(?=\\|)'", "'\\|(Inp[A-Za-z0-9_]+)=([^|]*)\\|'", ["01_due_lati_insieme_verde"]),
    # --- lettore e configurazione
    M("incrocio_ge", "$croceOK = ($n -gt 0 -and $n -eq $sommaEntrate)", "$croceOK = ($n -gt 0 -and $n -ge $sommaEntrate)", ["06b_incrocio_somma_imbuto_meno_uno"]),
    M("incrocio_le", "$croceOK = ($n -gt 0 -and $n -eq $sommaEntrate)", "$croceOK = ($n -gt 0 -and $n -le $sommaEntrate)", ["06_incrocio_somma_imbuto_piu_uno"]),
    M("incrocio_senza_n_positivo", "$croceOK = ($n -gt 0 -and $n -eq $sommaEntrate)", "$croceOK = ($n -eq $sommaEntrate)", ["07d_zero_ingressi"]),
    M("avvio_non_confrontato", "if($av -ne $AVVIO_ATTESO){ [void]$cfgMotivi.Add", "if($false){ [void]$cfgMotivi.Add", ["05_ini_ignorata_EA_gira_coi_default"]),
    M("avvio_assente_ammesso", "if($avviiVisti.Count -eq 0){ [void]$cfgMotivi.Add('riga di avvio dell EA NON trovata nei log') }", "", ["05b_riga_di_avvio_assente"]),
    M("imbuto_altro_simbolo_ammesso", "if($imbFuori -gt 0){ [void]$cfgMotivi.Add", "if($false){ [void]$cfgMotivi.Add", ["05c_imbuto_di_un_altro_simbolo"]),
    M("sl_storto_non_controllato", "if($slStorto -gt 0){ [void]$cfgMotivi.Add", "if($false){ [void]$cfgMotivi.Add", ["07_sl_dal_lato_sbagliato"]),
    M("controllo_lato_opposto_reinserito", "$cfgOK = ($cfgMotivi.Count -eq 0)", "if(@($entr | Where-Object { $_.Lato -ne 'SHORT' }).Count -gt 0){ [void]$cfgMotivi.Add('ingressi del lato opposto in una passata a un lato solo') }\n$cfgOK = ($cfgMotivi.Count -eq 0)", ["01_due_lati_insieme_verde"]),
    M("dedupe_per_chiave_spenta", "if($visti.ContainsKey($chiave)){", "if($false){", ["01b_giornale_duplicato_senza_data"]),
    M("fotografia_ignorata", "$off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }", "$off = 0", ["01c_log_vecchio_prima_della_fotografia"]),
    M("data_senza_dedupe_nella_chiave", "$chiave = $m.Value", "$chiave = $quando + $m.Value", ["01b_giornale_duplicato_senza_data"]),
    # --- C3
    M("c3_passa_ge_a_gt", "if($r -ge $C3_PASSA){ return 'PASSA' }", "if($r -gt $C3_PASSA){ return 'PASSA' }", ["08_c3_banda_44_esatto"]),
    M("c3_fragile_ge_a_gt", "if($r -ge $C3_FRAGILE){ return 'FRAGILE' }", "if($r -gt $C3_FRAGILE){ return 'FRAGILE' }", ["08_c3_banda_36_esatto"]),
    M("c3_soglia_passa_44_a_40", "$C3_PASSA   = [decimal]44", "$C3_PASSA   = [decimal]40", ["08_c3_banda_43_9941"]),
    M("c3_soglia_fragile_36_a_35", "$C3_FRAGILE = [decimal]36", "$C3_FRAGILE = [decimal]35", ["08_c3_banda_35_9941"]),
    M("c3_mediana_bassa", "$medR = QuantD $ordR 0.5", "$medR = QuantD $ordR 0.4", ["08e_c3_mediana_di_due_a_cavallo_del_44", "01_due_lati_insieme_verde"]),
    M("c3_mediana_stop_alta", "$medS = QuantD $ordS 0.5", "$medS = QuantD $ordS 0.6", ["01_due_lati_insieme_verde"]),
    M("c3_derivato_divisore_100_a_10", "$delta = [decimal]($b - $BUF_MISURA) / 100", "$delta = [decimal]($b - $BUF_MISURA) / 10", ["01_due_lati_insieme_verde"]),
    M("c3_derivato_delta_senza_misura", "$delta = [decimal]($b - $BUF_MISURA) / 100", "$delta = [decimal]$b / 100", ["01_due_lati_insieme_verde"]),
    M("c3_buffer_centro_3378_a_3375", "$BUF_DERIV  = @(3003, 3378, 4503)", "$BUF_DERIV  = @(3003, 3375, 4503)", ["01_due_lati_insieme_verde"]),
    M("c3_ora_dal_carattere_sbagliato", "$hh = [int]$e.Quando.Substring(11, 2)\n      $s = [decimal]$e.Dist + $delta", "$hh = [int]$e.Quando.Substring(12, 2)\n      $s = [decimal]$e.Dist + $delta", ["01d_ore_di_confine_0_e_23", "01_due_lati_insieme_verde"]),
    M("c3_spread_media_invece_di_mediana", "$SpreadOra[$hh] = Dec $c[5]", "$SpreadOra[$hh] = Dec $c[4]", ["01_due_lati_insieme_verde"]),
    M("c3_pavimento_34_6_a_30", "$PAVIMENTO  = [decimal]34.6", "$PAVIMENTO  = [decimal]30", ["08f_c3_pavimento_duro", "08g_c3_pavimento_32_00"]),
    M("c3_pavimento_ge_a_gt", "if($medS -ge $PAVIMENTO){ $pavTxt = 'SI' }", "if($medS -gt $PAVIMENTO){ $pavTxt = 'SI' }", ["08g_c3_pavimento_34_60"]),
    M("c3_pavimento_conteggio_le", "if($s -lt $PAVIMENTO){ $sottoPav = $sottoPav + 1 }", "if($s -le $PAVIMENTO){ $sottoPav = $sottoPav + 1 }", ["08g_c3_pavimento_34_60"]),
    M("c3_stress_240_a_250", "$ST_EQUI    = [decimal]2.40", "$ST_EQUI    = [decimal]2.50", ["01_due_lati_insieme_verde"]),
    M("c3_per_lato_sempre_long", "foreach($e in $entr){ if($e.Lato -eq $lat){", "foreach($e in $entr){ if($e.Lato -eq 'LONG'){", ["01_due_lati_insieme_verde"]),
    M("c3_calcolato_anche_se_non_affidabile", "if($affidabile -and $senzaData -eq 0){", "if($senzaData -eq 0){", ["05_ini_ignorata_EA_gira_coi_default", "06_incrocio_somma_imbuto_piu_uno", "02_g0_trades_176", "04_g0_report_assente"]),
    M("c3_senza_controllo_senza_data", "if($affidabile -and $senzaData -eq 0){", "if($affidabile){", ["07b_ingressi_senza_data_simulata"]),
    M("attesa_65_a_60", "if($m0 -lt 65)", "if($m0 -lt 60)", ["09_attesa_64_99"]),
    M("attesa_93_a_90", "elseif($m0 -lt 93)", "elseif($m0 -lt 90)", ["09_attesa_92_99"]),
    M("attesa_188_a_190", "elseif($m0 -gt 188)", "elseif($m0 -gt 190)", ["09_attesa_188_01"]),
    # --- esito e codici
    M("exit_3_diventa_0", "exit 3\n", "exit 0\n", ["02_g0_trades_176", "05_ini_ignorata_EA_gira_coi_default"]),
    M("exit_0_senza_c3", "if($affidabile -and $c3Fatto){", "if($affidabile){", ["07b_ingressi_senza_data_simulata"]),
    M("zip_non_prodotto_se_non_misurato", "$zip = Join-Path $dsk 'PASSATA_STOP_SUPREV_NAS.zip'", "$zip = Join-Path $dsk 'PASSATA_STOP_SUPREV_NAS.zip'\nif(-not $affidabile){ Write-Host 'x'; exit 3 }", ["04_g0_report_assente"]),
    M("cartella_vecchia_non_rimossa", "if(Test-Path -LiteralPath $Cart){ Remove-Item -LiteralPath $Cart -Recurse -Force -ErrorAction SilentlyContinue }", "", ["01j_desktop_con_residui"]),
    M("zip_u30usd_stesso_nome", "$Cart = Join-Path $dsk 'PASSATA_STOP_SUPREV_NAS'", "$Cart = Join-Path $dsk 'PASSATA_STOP_SUPREV'", ["01j_desktop_con_residui"]),
    # --- guardie
    M("guardia_macchina_spenta", "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){", "if($false){", ["10_macchina_vps"]),
    M("guardia_mt5_spenta", "if((@(Get-Process -Name terminal64, metaeditor64 -ErrorAction SilentlyContinue)).Count -gt 0){", "if($false){", ["10b_mt5_aperto", "10c_metaeditor_aperto"]),
    M("guardia_solo_terminal64", "Get-Process -Name terminal64, metaeditor64", "Get-Process -Name terminal64", ["10c_metaeditor_aperto"]),
    M("guardia_ea_attaccati_spenta", "if($conEA.Count -gt 0){ throw", "if($false){ throw", ["10d_ea_sul_grafico_salvato", "10f_grafico_illeggibile"]),
    M("guardia_zero_grafici_spenta", "if($nChr -le 0){ throw", "if($false){ throw", ["10e_zero_grafici_salvati"]),
    M("guardia_chr_illeggibile_non_conta", "$conEA = $conEA + @($fc.Directory.Name + '\\' + $fc.Name + '  ILLEGGIBILE: non verificabile, conta come EA attaccato'); continue", "continue", ["10f_grafico_illeggibile"]),
    M("guardia_altre_installazioni_spenta", "if($diversi.Count -gt 0){", "if($false){", ["10h_altra_installazione_MT5"]),
    M("guardia_cartella_dati_univoca_spenta", "if($cands.Count -ne 1){", "if($false){", ["10g_due_cartelle_dati", "10i_nessuna_cartella_dati"]),
    M("guardia_pin_spenta", "if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw", "if($false){ throw", ["11_pin_malformato"]),
    M("firma_EA_spenta", "Scarica ('mql5/Experts/' + $EXPERT + '.mq5') $srcEA 'STREV-IMBUTO'", "Scarica ('mql5/Experts/' + $EXPERT + '.mq5') $srcEA ''", ["12_EA_senza_firma"]),
    M("firma_spread_spenta", "Scarica $SPREADCSV $fileSpread 'ora_server,tick_totali'", "Scarica $SPREADCSV $fileSpread ''", ["12c_spread_senza_firma"]),
    M("spread_24_ore_non_controllate", "if($SpreadOra.Count -ne 24){ throw", "if($false){ throw", ["12d_spread_con_23_ore"]),
    M("spread_TUTTO_non_controllato", "if($null -eq $tuttoTick -or $tuttoTick -ne $sommaTick){ throw", "if($false){ throw", ["12e_spread_TUTTO_non_somma"]),
    M("spread_ora_ripetuta_ammessa", "if($hh -lt 0 -or $hh -gt 23 -or $SpreadOra.ContainsKey($hh)){ throw", "if($hh -lt 0 -or $hh -gt 23){ throw", ["12f_spread_ora_ripetuta"]),
    M("spread_zero_ammesso", "if($SpreadOra[$hh] -le 0){ throw", "if($false){ throw", ["12g_spread_mediana_zero"]),
    M("ancora_unica_volta_spenta", "if(@($inputs | Where-Object { $_ -eq $pa }).Count -ne 1){ throw", "if(@($inputs | Where-Object { $_ -eq $pa }).Count -lt 1){ throw", ["13g_prova_con_riga_ancora_ripetuta_identica"]),
    M("ancora_non_controllata", "if(@($inputs | Where-Object { $_ -eq $pa }).Count -ne 1){ throw", "if($false){ throw", ["13_prova_con_buffer_diverso", "13e_prova_un_solo_lato", "13f_prova_senza_verbose"]),
    M("doppi_non_controllati", "if($doppi.Count -gt 0){ throw", "if($false){ throw", ["13b_prova_con_parametro_doppio"]),
    M("finestra_accesa_ammessa", "if($asse.Count -ne 1 -or $asse[0] -ne 'InpUseTimeWindow=0'){ throw", "if($false){ throw", ["13c_prova_con_finestra_accesa"]),
    M("prova_tronca_ammessa", "if($inputs.Count -lt 40){ throw", "if($false){ throw", ["13d_prova_tronca"]),
    M("compile_non_verificato", "if(-not (Test-Path -LiteralPath $ex5)){\n  try{", "if($false){\n  try{", ["14_compilazione_fallisce"]),
    M("compile_argomenti_in_un_solo_elemento", "@(('/compile:' + (Join-Path $MqlExp ($EXPERT + '.mq5'))), ('/log:' + $logC))", "@('/compile:' + (Join-Path $MqlExp ($EXPERT + '.mq5')), '/log:' + $logC)", ["01_due_lati_insieme_verde"]),
    M("ini_live_trading_true", "[Experts]`r`nAllowLiveTrading=false", "[Experts]`r`nAllowLiveTrading=true", ["01_due_lati_insieme_verde"]),
    M("ini_optimization_1", "Optimization=0`r`nFromDate=", "Optimization=1`r`nFromDate=", ["01_due_lati_insieme_verde"]),
    M("ini_simbolo_sbagliato", "Symbol=\" + $SIMBOLO", "Symbol=U30USD\" + ''", ["01_due_lati_insieme_verde"]),
    M("ini_report_con_altro_nome", "ShutdownTerminal=1`r`nReport=PASSATA_STOP_NAS", "ShutdownTerminal=1`r`nReport=PASSATA_STOP_X", ["01_due_lati_insieme_verde"]),
    M("timeout_senza_closemainwindow", "try{ [void]$p.CloseMainWindow() }catch{ }", "", ["15_timeout_chiude_con_CloseMainWindow"]),
]


def runna_mut(i):
    nome, old, new, catturano, tutte = MUT[i]
    testo = SCR.replace(old, new) if tutte else SCR.replace(old, new, 1)
    assert testo != SCR
    def muta_script(b):
        return testo.encode("ascii")
    res = []
    for sn in catturano:
        spec, att = battery.SC[sn]
        nome_s, prob, out = battery.runna(sn, spec, att, muta_script)
        res.append((sn, bool(prob)))
    presa = any(r for (_, r) in res)
    return nome, presa, [sn for (sn, r) in res if r]


def main():
    solo = sys.argv[sys.argv.index("--solo") + 1] if "--solo" in sys.argv else None
    jobs = int(sys.argv[sys.argv.index("--jobs") + 1]) if "--jobs" in sys.argv else 4
    tutti = battery.scenari() + battery.scenari_lenti()
    battery.SC.update({n: (s, a) for (n, s, a) in tutti})
    # prima: le mutazioni non usano scenari senza nome
    for (nome, old, new, cat, tutte) in MUT:
        for sn in cat:
            assert sn in battery.SC, (nome, sn)
    idx = [i for i, m in enumerate(MUT) if (not solo or solo in m[0])]
    # gli scenari "lenti" (timeout) e "mt5 vivo" non vanno in parallelo con gli altri
    seriali = [i for i in idx if any(battery.SC[sn][0]["mt5_vivo"] or battery.SC[sn][0]["no_exit"] for sn in MUT[i][3])]
    par = [i for i in idx if i not in seriali]
    with Pool(jobs) as pool:
        ris = pool.map(runna_mut, par)
    ris = ris + [runna_mut(i) for i in seriali]
    prese = 0
    for nome, presa, dove in ris:
        if presa:
            prese += 1
            if "--elenco" in sys.argv:
                print("presa      %-44s <- %s" % (nome, ", ".join(dove)))
        else:
            print("SOPRAVVISSUTA %s" % nome)
    print("MUTAZIONI R290A: %d prese su %d (equivalenti dichiarati: 1, nel docstring, non nell'elenco)" % (prese, len(ris)))
    return 0 if prese == len(ris) else 1


if __name__ == "__main__":
    sys.exit(main())
