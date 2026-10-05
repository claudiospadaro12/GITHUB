#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni_ps1.py -- il collaudo del collaudo per i DUE .ps1 di P1: ogni mutazione TESTUALE spegne UN controllo (o ne sbaglia uno) e almeno uno scenario/caso deve diventare ROSSO.
Si provano prima gli scenari sentinella (driver: battery.py; figlia: battery_figlia.py); se nessuno e' rosso si prova la batteria intera relativa. Un mutante e' PRESO se cade in uno qualsiasi.
Le mutazioni sono parse-valide (controllato col parser PowerShell vero prima di lanciarle) e un mutante NON APPLICABILE (testo non trovato) e' un errore del collaudo, non un successo.
EQUIVALENTI dichiarati: vedi EQUIVALENTI qui sotto, ciascuno col suo perche'.
Uso: python3 mutazioni_ps1.py [--jobs N]   -> ultima riga "MUTAZIONI PS1: p/n PRESE (+ e equivalenti dichiarati)"
"""
import os, subprocess, sys, tempfile
from multiprocessing import Pool
import h1, battery as B, battery_figlia as BF

QD = os.path.dirname(os.path.abspath(__file__))
DRV = os.path.join(h1.REPO, "backtest_pipeline", "righe", "RIGA_DUKA_P1_OROLOGIO.ps1")
IMP = os.path.join(h1.REPO, "backtest_pipeline", "righe", "RIGA_DUKA_IMPORT_SONDA.ps1")
TMP = os.environ.get("HARNESS_TMP") or tempfile.mkdtemp(prefix="p1mut_")
ORIG_DRV = open(DRV, encoding="ascii", newline="").read()
ORIG_IMP = open(IMP, encoding="ascii", newline="").read()

# (nome, 'drv'|'imp', old, new, sentinelle) -- sentinelle: prefissi di scenari del driver (drv) o di casi della figlia (imp)
M = [
 # --- driver: guardie
 ("drv_guardia_macchina", "drv", "if($env:COMPUTERNAME -ne $MacchinaAmmessa){", "if($false){", ["09"]),
 ("drv_mt5_aperto_ignorato", "drv", 'Gate ($viv.Count -eq 0) "A"', 'Gate $true "A"', ["10"]),
 ("drv_EA_attaccato_ignorato", "drv", 'Gate ($conEA.Count -eq 0) "A"', 'Gate $true "A"', ["11"]),
 ("drv_zero_grafici_ignorato", "drv", 'Gate ($nChr -gt 0) "A"', 'Gate $true "A"', ["12"]),
 ("drv_illeggibile_non_conta", "drv", '$conEA += ($f.Directory.Name + "\\" + $f.Name + "  ILLEGGIBILE: non verificabile, conta come EA attaccato"); continue', 'continue', ["13"]),
 ("drv_cartelle_dati_ge1", "drv", 'Gate ($dati.Count -eq 1) "A"', 'Gate ($dati.Count -ge 1) "A"', ["14"]),
 ("drv_python_store_accettato", "drv", '| Where-Object { $_.Source -notlike "*\\WindowsApps\\*" }', '', ["15"]),
 ("drv_python_assente_ignorato", "drv", 'Gate ([bool]$Python) "A"', 'Gate $true "A"', ["16"]),
 ("drv_pin_non_validato", "drv", 'Gate ($Pin -match \'^[0-9a-fA-F]{40}$\') "A"', 'Gate $true "A"', ["17g"]),
 # --- driver: file al pin
 ("drv_impronta_non_verificata", "drv", 'Gate ($h -ieq $shaAtteso) "B"', 'Gate $true "B"', ["17_", "17b", "17c"]),
 ("drv_marcatore_non_verificato", "drv", 'Gate ([bool](Select-String -LiteralPath $dest -SimpleMatch -Quiet -Pattern $marcatore)) "B"', 'Gate $true "B"', ["17d"]),
 ("drv_autotest_py_ignorato", "drv", 'Gate (($rc1 -eq 0) -and (Select-String -LiteralPath $logA1 -SimpleMatch -Quiet -Pattern "AUTOTEST: TUTTO OK.")) "B"', 'Gate $true "B"', ["17e"]),
 ("drv_autotest_f2_ignorato", "drv", 'Gate (($rc2 -eq 0) -and (Select-String -LiteralPath $logA2 -SimpleMatch -Quiet -Pattern "TUTTO OK")) "B"', 'Gate $true "B"', ["17f"]),
 ("drv_negok_guardia_tolta", "drv", 'Gate $negOk "I"', 'Gate $true "I"', ["01"]),
 # --- driver: cache e stato
 ("drv_cache_con_buchi_ignorata", "drv", 'Gate ($rcC -eq 0) "C"', 'Gate $true "C"', ["18"]),
 ("drv_cache_assente_ignorata", "drv", 'Gate (Test-Path -LiteralPath (Join-Path $RawDir "USA30IDXUSD")) "C"', 'Gate $true "C"', ["19"]),
 ("drv_nove_csv_non_verificati", "drv", 'Gate (($nomiAttesi -join "|") -eq ($nomiNow -join "|")) "D"', 'Gate $true "D"', ["20", "21"]),
 ("drv_gia_fisso_ignorato", "drv", 'Gate (-not $giaFisso) "D"', 'Gate $true "D"', ["22"]),
 ("drv_era_usa_ignorato", "drv", 'Gate $eraUsa "D"', 'Gate $true "D"', ["23"]),
 ("drv_spazio_ignorato", "drv", 'Gate (($disco / 1GB) -ge $serveGB) "D"', 'Gate $true "D"', ["24"]),
 ("drv_spazio_non_leggibile_ignorato", "drv", 'Gate ($null -ne $disco) "D"', 'Gate $true "D"', ["24"]),
 # --- driver: backup
 ("drv_backup_alterato_ignorato", "drv", 'Gate (((Get-FileHash -LiteralPath $pf -Algorithm SHA256).Hash) -ieq $sh) "E"', 'Gate $true "E"', ["26"]),
 ("drv_manifest_assente_ignorato", "drv", 'Gate (Test-Path -LiteralPath $manifest) "E"', 'Gate $true "E"', ["27"]),
 ("drv_copia_non_verificata", "drv", 'Gate ($h0 -ieq $h1) "E"', 'Gate $true "E"', ["28d"]),
 ("drv_backup_riscritto_sempre", "drv", 'if(Test-Path -LiteralPath $Backup){\n    Dico ("la copia esiste gia', 'if($false){\n    Dico ("la copia esiste gia', ["25"]),
 # --- driver: riconversione
 ("drv_rc_riconversione_ignorato", "drv", 'Gate ($rcF -eq 0) "F"', 'Gate $true "F"', ["28_"]),
 ("drv_referto_py_non_riscritto", "drv", 'Gate (Test-Path -LiteralPath $refOld) "F" "il .py non ha riscritto', 'Gate $true "F" "il .py non ha riscritto', ["28e"]),
 ("drv_dst_fisso_non_verificato", "drv", 'Gate ($refNew -match \'(?m)^DST:\\s*fisso\') "F"', 'Gate $true "F"', ["28c"]),
 ("drv_csv_non_riscritti_ignorato", "drv", 'Gate ($f.LastWriteTime -ge $t0F) "F"', 'Gate $true "F"', ["28b"]),
 # --- driver: negativo e figlie
 ("drv_copia_cache_neg_ignorata", "drv", 'Gate ($rcI1 -eq 0) "I"', 'Gate $true "I"', ["29_"]),
 ("drv_nome_neg_non_verificato", "drv", 'Gate (($negFiles.Count -eq 1) -and ($negFiles[0] -eq ($SimNeg + "_ticks_2025-03.csv"))) "I"', 'Gate $true "I"', ["29b"]),
 ("drv_tick_toccato_dal_neg_ignorato", "drv", 'Gate ($shaTick.ContainsKey($f.Name) -and (((Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash) -eq $shaTick[$f.Name])) "J"', 'Gate $true "J"', ["29c"]),
 ("drv_import_dk_assente_ignorato", "drv", 'Gate (Test-Path -LiteralPath $giorniDk) "H"', 'Gate $true "H"', ["30"]),
 ("drv_import_neg_assente_ignorato", "drv", 'Gate (Test-Path -LiteralPath $giorniNeg) "J"', 'Gate $true "J"', ["31"]),
 ("drv_figlia_senza_sha_mq5", "drv", "& $Imp -Pin $Pin -ShaMq5 $ShaMq5 -SimboloDK $SimDK", "& $Imp -Pin $Pin -SimboloDK $SimDK", ["33"]),
 ("drv_neg_senza_pulisci", "drv", "-GiorniSonda $GiornoNeg -PulisciFiles -WorkDir", "-GiorniSonda $GiornoNeg -WorkDir", ["01"]),
 ("drv_neg_nel_posto_di_tick", "drv", '"--nome-uscita", $SimNeg, "--cartella", (Reale $NegDir))', '"--nome-uscita", $SimNeg, "--cartella", (Reale $Lavoro))', ["01"]),
 ("drv_neg_utc_ma_fisso", "drv", '"--fuso", "utc", "--solo-cache", "--senza-raccolta", "--nome-uscita"', '"--fuso", "server", "--dst", "fisso", "--solo-cache", "--senza-raccolta", "--nome-uscita"', ["01"]),
 ("drv_riconv_dst_usa", "drv", '"--dst", "fisso", "--fuso", "server", "--solo-cache"', '"--dst", "usa", "--fuso", "server", "--solo-cache"', ["01"]),
 ("drv_confronto_su_cartella_sbagliata", "drv", '"--confronta-giorni", (Reale $Backup), (Reale $TickDir)', '"--confronta-giorni", (Reale $TickDir), (Reale $TickDir)', ["01"]),
 ("drv_giorni_sonda_otto", "drv", '-GiorniSonda ($Giorni9 -join ";") -WorkDir $ImpWork', '-GiorniSonda (($Giorni9 | Select-Object -First 8) -join ";") -WorkDir $ImpWork', ["01"]),
 ("drv_giro_a_vuoto_ignorato", "drv", "if($SoloControllo){\n    Titolo", "if($false){\n    Titolo", ["08"]),
 ("drv_esito_f2_sbagliato", "drv", 'if($RcF2 -eq 0){ $EsitoF2 = "PASSA" } elseif($RcF2 -eq 1){ $EsitoF2 = "NON PASSA" }', 'if($RcF2 -eq 0){ $EsitoF2 = "PASSA" } elseif($RcF2 -eq 1){ $EsitoF2 = "PASSA" }', ["02"]),
 ("drv_rc1_senza_file_del_verdetto", "drv", 'if(($RcF2 -ge 0) -and ($RcF2 -le 2) -and ($f2Riga -ne $EsitoF2)){', 'if($false){', ["37"]),
 ("drv_k0b_messaggio_tolto", "drv", '($f2Txt -match \'(?m)^\\(3\\) .*: FAIL\\s\')){', '($f2Txt -match \'(?m)^\\(3\\) .*: FAIL\\s\') -and $false){', ["03"]),
 ("drv_k0b_messaggio_senza_la_1", "drv", "($EsitoF2 -eq \"NON PASSA\") -and ($f2Txt -match '(?m)^\\(1\\) .*: PASS\\s*$') -and ", "($EsitoF2 -eq \"NON PASSA\") -and ", ["38"]),
 ("drv_raccolta_non_sempre", "drv", "catch{\n  $Fatale = Pulisci", "catch{\n  throw\n  $Fatale = Pulisci", ["10"]),
 # --- figlia
 ("imp_maschera_larga", "imp", 'if($MascheraCsv -notlike ($SimboloDK + "_ticks_*")){', 'if($false){', ["17"]),
 ("imp_file_estranei", "imp", 'if($estranei.Count -gt 0){', 'if($false){', ["19"]),
 ("imp_dentro_mediana_stretta", "imp", '$dentro = ($d -le $SogliaDiff -and $c -ge $SogliaCop)', '$dentro = ($d -lt $SogliaDiff -and $c -ge $SogliaCop)', ["07", "05"]),
 ("imp_dentro_copertura_stretta", "imp", '$dentro = ($d -le $SogliaDiff -and $c -ge $SogliaCop)', '$dentro = ($d -le $SogliaDiff -and $c -gt $SogliaCop)', ["07", "05"]),
 ("imp_dentro_senza_copertura", "imp", '$dentro = ($d -le $SogliaDiff -and $c -ge $SogliaCop)', '$dentro = ($d -le $SogliaDiff)', ["06"]),
 ("imp_discordanza_tolta", "imp", 'if($dentro -ne $imp){ $stato = "DISCORDANZA" }\n          elseif($dentro)', 'if($false){ $stato = "DISCORDANZA" }\n          elseif($dentro)', ["09"]),
 ("imp_soglie_non_confrontate", "imp", 'elseif($sd -ne $SogliaDiff -or $sc -ne $SogliaCop){ $stato = "SOGLIA_DIVERSA" }', 'elseif($false){ $stato = "SOGLIA_DIVERSA" }', ["10"]),
 ("imp_ripetuto_tollerato", "imp", 'elseif($r.Count -gt 1){ $stato = "RIPETUTO" }', 'elseif($false){ $stato = "RIPETUTO" }', ["04"]),
 ("imp_assente_non_visto", "imp", 'if($r.Count -eq 0){ $stato = "ASSENTE" }', 'if($false){ $stato = "ASSENTE" }', ["03"]),
 ("imp_non_valido_non_visto", "imp", 'if(-not $okn){ $stato = "NON_VALIDO" }', 'if($false){ $stato = "NON_VALIDO" }', ["11"]),
 ("imp_esito_non_misurato_ignorato", "imp", 'if(("" + $x.Esito).Trim() -ne "MISURATO"){', 'if($false){', ["02", "12", "15"]),
 ("imp_codice_ok_senza_per_nome", "imp", 'if($PerNomeOk){ $Codice = 0 }else{ $Codice = 4 }', '$Codice = 0', ["02", "03"]),
 ("imp_altro_simbolo_ignorato", "imp", '$PerNomeOk = ($nDentro -eq $ListaGiorni.Count -and $AltroSimbolo -eq 0)', '$PerNomeOk = ($nDentro -eq $ListaGiorni.Count)', ["13b"]),
 ("imp_tutti_i_giorni_serve_uno", "imp", '$PerNomeOk = ($nDentro -eq $ListaGiorni.Count -and $AltroSimbolo -eq 0)', '$PerNomeOk = ($nDentro -ge 1 -and $AltroSimbolo -eq 0)', ["02", "03"]),
 ("imp_pulisci_tutto", "imp", "  foreach($nome in $Copiati){\n    if($nome -like $MascheraCsv){", "  foreach($nome in @(Get-ChildItem -LiteralPath $filesDir | ForEach-Object { $_.Name })){\n    if($nome -like '*.csv'){", ["20"]),
 ("imp_pulisci_non_chiamata", "imp", '$Pul = Pulisci-Copiati\n', '$Pul = "x"\n', ["20"]),
 ("imp_sha_mq5_non_verificato", "imp", 'if($shaMq5Letto -ine $ShaMq5){', 'if($false){', ["D33"]),
 ("imp_copia_senza_registro", "imp", 'Copy-Item -LiteralPath $f.FullName -Destination $filesDir -Force; [void]$Copiati.Add($f.Name)', 'Copy-Item -LiteralPath $f.FullName -Destination $filesDir -Force', ["20"]),
 ("imp_giorni_vuoti_ammessi", "imp", 'if($ListaGiorni.Count -eq 0){ throw', 'if($false){ throw', ["18"]),
 ("imp_preset_maschera_cablata", "imp", 'InpMascheraCsv=$MascheraCsv', 'InpMascheraCsv=U30USD_DK_ticks_*.csv', ["D01"]),
 ("imp_work_non_ripulito", "imp", "  Remove-Item -LiteralPath $GiorniWork -Force -ErrorAction SilentlyContinue\n  $dstScr", "  $dstScr", ["21"]),
]
# EQUIVALENTI dichiarati: (nome, perche')
EQUIVALENTI = {
 "drv_negok_guardia_tolta": "non attivabile da nessun input: controlla la FORMA di una cartella costruita da costanti prima di una cancellazione ricorsiva (difesa contro una modifica futura, classe 1113 dichiarata)",
}


def applica(nome, quale, old, new):
    t = ORIG_DRV if quale == "drv" else ORIG_IMP
    if t.count(old) != 1:
        return None
    return t.replace(old, new, 1)


def prova(m):
    nome, quale, old, new, sent = m
    t = applica(nome, quale, old, new)
    if t is None:
        return nome, "NON APPLICABILE (%d occorrenze)" % ORIG_DRV.count(old) if quale == "drv" else "NON APPLICABILE (%d occorrenze)" % ORIG_IMP.count(old)
    d = tempfile.mkdtemp(prefix="m_", dir=TMP)
    f = os.path.join(d, "mut.ps1")
    open(f, "w", encoding="ascii", newline="").write(t)
    if quale == "drv":
        scen = [s for s in B.scenari() if any(s[0].startswith(x) for x in sent)]
        for (n, sp, att) in scen:
            nn, err = B.runna(n, sp, att, f)
            if err:
                return nome, "PRESA da " + n
        return nome, "TUTTI"
    # figlia: la mutazione e' nel testo della figlia servita al pin
    nuovo = new.encode("ascii"); vecchio = old.encode("ascii")
    fn = lambda b, vecchio=vecchio, nuovo=nuovo: b.replace(vecchio, nuovo, 1)
    # casi della figlia (battery_figlia) e, se la sentinella comincia con D, scenari del driver
    for (n, kw, extra, attesi, rc, frasi) in BF.casi():
        if any(n.startswith(x) for x in sent if not x.startswith("D")):
            kw2 = dict(kw); kw2["muta_imp"] = fn
            nn, err = BF.runna(n, kw2, extra, attesi, rc, frasi)
            if err:
                return nome, "PRESA da figlia/" + n
    for (n, sp, att) in B.scenari():
        if any(n.startswith(x[1:]) for x in sent if x.startswith("D")):
            sp2 = dict(sp); sp2["muta_imp"] = fn
            nn, err = B.runna(n, sp2, att, None)
            if err:
                return nome, "PRESA da driver/" + n
    return nome, "TUTTI"


def tutta(m):
    nome, quale, old, new, sent = m
    t = applica(nome, quale, old, new)
    d = tempfile.mkdtemp(prefix="mt_", dir=TMP)
    if quale == "drv":
        f = os.path.join(d, "mut.ps1"); open(f, "w", encoding="ascii", newline="").write(t)
        for (n, sp, att) in B.scenari():
            if sp["mt5_vivo"]:
                continue
            nn, err = B.runna(n, sp, att, f)
            if err:
                return nome, "PRESA (batteria intera) da " + n
        return nome, "SOPRAVVISSUTA"
    nuovo = new.encode("ascii"); vecchio = old.encode("ascii")
    fn = lambda b, vecchio=vecchio, nuovo=nuovo: b.replace(vecchio, nuovo, 1)
    for (n, kw, extra, attesi, rc, frasi) in BF.casi():
        kw2 = dict(kw); kw2["muta_imp"] = fn
        nn, err = BF.runna(n, kw2, extra, attesi, rc, frasi)
        if err:
            return nome, "PRESA (batteria figlia intera) da " + n
    return nome, "SOPRAVVISSUTA"


def parse_ok(muts):
    d = tempfile.mkdtemp(prefix="pp_", dir=TMP)
    for m in muts:
        t = applica(*m[:4])
        if t is None:
            continue
        open(os.path.join(d, m[0] + ".ps1"), "w", encoding="ascii", newline="").write(t)
    ps = '$bad=0; foreach($f in Get-ChildItem "%s" -Filter *.ps1){ $e=$null; $t=$null; [void][System.Management.Automation.Language.Parser]::ParseFile($f.FullName,[ref]$t,[ref]$e); if($e.Count -gt 0){ $bad++; Write-Host ("PARSE ERR " + $f.Name + ": " + $e[0].Message) } }; "bad=$bad"' % d
    r = subprocess.run(["pwsh", "-NoProfile", "-Command", ps], capture_output=True, text=True).stdout
    return r


def main():
    jobs = int(sys.argv[sys.argv.index("--jobs") + 1]) if "--jobs" in sys.argv else 4
    global M
    if "--solo" in sys.argv:
        solo = sys.argv[sys.argv.index("--solo") + 1].split(",")
        M = [x for x in M if x[0] in solo]
    B.EXP_USA = B.hashes_tool("usa"); B.EXP_FISSO = B.hashes_tool("fisso")      # prima del Pool: i worker ereditano
    pr = parse_ok(M)
    print("parse dei mutanti:", pr.strip().splitlines()[-1])
    if "bad=0" not in pr:
        print(pr); return 1
    with Pool(jobs) as p:
        r1 = p.map(prova, M)
    prese = 0; eq = 0; non_app = 0; resto = []
    byname = {m[0]: m for m in M}
    for nome, esito in r1:
        if esito.startswith("PRESA"):
            prese += 1; print("  presa    %-40s %s" % (nome, esito))
        elif esito.startswith("NON APPLICABILE"):
            non_app += 1; print("  NON APPLICABILE %s %s" % (nome, esito))
        elif nome in EQUIVALENTI:
            eq += 1; print("  EQUIVALENTE %-37s %s" % (nome, EQUIVALENTI[nome]))
        else:
            resto.append(byname[nome])
    if resto:
        with Pool(jobs) as p:
            r2 = p.map(tutta, resto)
        for nome, esito in r2:
            if esito.startswith("PRESA"):
                prese += 1; print("  presa    %-40s %s" % (nome, esito))
            elif nome in EQUIVALENTI:
                eq += 1; print("  EQUIVALENTE %-37s %s" % (nome, EQUIVALENTI[nome]))
            else:
                print("  SOPRAVVISSUTA %s" % nome)
    print("MUTAZIONI PS1: %d/%d PRESE (+ %d equivalenti dichiarati, %d non applicabili)" % (prese, len(M) - eq, eq, non_app))
    return 0 if prese + eq == len(M) and non_app == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
