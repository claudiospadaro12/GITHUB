#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni.py -- il collaudo del collaudo per RIGA_OMBRA_INSTALL.ps1: ogni mutazione TESTUALE spegne UN controllo (o ne sbaglia uno) e almeno uno scenario della batteria deve diventare ROSSO
(classi 1068/1074/1101). Ogni mutante dichiara lo scenario SENTINELLA che lo deve prendere, scritto guardando il controllo e non l'uscita; se la sentinella resta verde si prova tutta la batteria
e il mutante e' PRESO ma "da altro scenario" (segnalato: la sentinella non isola il controllo, classe 1101).
Uso: python3 mutazioni.py [--jobs N]   -> ultima riga "MUTAZIONI: p/n PRESE"
"""
import os, sys, tempfile
from multiprocessing import Pool
import battery as B

QD = os.path.dirname(os.path.abspath(__file__))
RIGA = os.path.abspath(os.path.join(QD, "..", "righe", "RIGA_OMBRA_INSTALL.ps1"))
ORIG = open(RIGA, encoding="ascii", newline="").read()

M = [
 ("guardia_macchina", "if($env:COMPUTERNAME -ne 'VMI3047753'){", "if($false){", ["02_", "02b"]),
 ("origin_con_like", "if(Uguali $o $TermBcm){ $c.Candidata = $true }", "if((Norm $o) -like '*bcm markets mt5 terminal*'){ $c.Candidata = $true }", ["06b"]),
 ("conto_non_confrontato", "elseif($g.Ultimo -ne $ContoAtt){", "elseif($false){", ["04c_"]),
 ("ultimo_login_e_il_primo", "$o.Ultimo = $mm[$mm.Count - 1].Groups[1].Value", "$o.Ultimo = $mm[0].Groups[1].Value", ["04c_", "04d_"]),
 ("giornali_dal_piu_vecchio", "Sort-Object LastWriteTime -Descending | Select-Object -First 30", "Sort-Object LastWriteTime | Select-Object -First 30", ["04c2"]),
 ("freschezza_tolta", "elseif($g.Eta -gt $EtaMaxOre){", "elseif($false){", ["05b", "03e"]),
 ("soglia_720_ore", "$EtaMaxOre = 72", "$EtaMaxOre = 720", ["05b"]),
 ("soglia_24_ore", "$EtaMaxOre = 72", "$EtaMaxOre = 24", ["05a"]),
 ("freschezza_solo_logs", "foreach($sub in @('logs', 'MQL5\\Logs')){", "foreach($sub in @('logs')){", ["05c"]),
 ("experts_non_controllato", "if(-not (Test-Path -LiteralPath $ex)){ [void]$c.Motivi.Add('manca MQL5\\Experts') }", "", ["15"]),
 ("tetto_lettura_tolto", "if(($letti + $f.Length) -gt ($TettoLetturaMB * 1MB)){", "if($false){", ["04g"]),
 ("giornale_senza_stop_al_primo_login", "$o.File = $f.Name; break }", "$o.File = $f.Name }", ["04d2"]),
 ("ini_discordanza_tolta", "if($c.IniLogin -ne '' -and $c.IniLogin -ne $ContoAtt){", "if($false){", ["04e"]),
 ("due_eleggibili_ammesse", "elseif($el.Count -gt 1){", "elseif($false){", ["03_", "03d"]),
 ("zero_eleggibili_ammesse", "elseif($el.Count -eq 0){", "elseif($false){", ["03e"]),
 ("sha_non_confrontato", "if($HScaricato -ne $EaSha){", "if($false){", ["09a"]),
 ("trading_non_controllato", "if($nTr -ne 0){", "if($false){", ["09b"]),
 ("versione_property_tolta", "if(-not [regex]::IsMatch($txt, ('(?m)^#property\\s+version\\s+\"' + [regex]::Escape($EaVer) + '\"'))){", "if($false){", ["09c"]),
 ("versione_define_tolta", "if(-not [regex]::IsMatch($txt, ('(?m)^#define\\s+OMBRA_VER\\s+\"' + [regex]::Escape($EaVer) + '\"'))){", "if($false){", ["09d"]),
 ("ascii_tolto", "if([regex]::IsMatch($txt, '[^\\x09\\x0A\\x0D\\x20-\\x7E]')){", "if($false){", ["09e"]),
 ("ascii_su_stringa_decodificata_ascii", "[Text.Encoding]::GetEncoding(28591).GetString($Bytes)", "[Text.Encoding]::ASCII.GetString($Bytes)", ["09e"]),
 ("cartella_come_file", "if($it.PSIsContainer){", "if($false){", ["08b"]),
 ("diverso_come_uguale", "if($hOld -eq $EaSha){", "if($true){", ["08_"]),
 ("createnew_in_create", "[IO.FileMode]::CreateNew", "[IO.FileMode]::Create", ["10a"]),
 ("delete_senza_flag_creato", "if($Creato -and -not $Installato){ try{ [IO.File]::Delete", "if(-not $Installato){ try{ [IO.File]::Delete", ["10a"]),
 ("delete_tolto", "[IO.File]::Delete($destNative); $Rimosso = $true", "$Rimosso = $true", ["10b"]),
 ("verifica_lunghezza_tolta", "if($v.PSIsContainer -or $v.Length -ne $Bytes.Length){", "if($false){", ["10b"]),
 ("verifica_hash_tolta", "if($hv -ne $EaSha){", "if($false){", ["10c"]),
 ("marcatore_sul_prefisso", "$mio = (Uguali $cart $TermBcm)", "$mio = ((Norm $cart).StartsWith((Norm $TermBcm)))", ["01_"]),
 ("sedie_di_tutti_i_profili", "foreach($f in @(Get-ChildItem -LiteralPath $cr -File -Filter 'chart*.chr' -ErrorAction SilentlyContinue)){", "foreach($f in @(Get-ChildItem -LiteralPath (Join-Path $Scelta.Cartella 'MQL5\\Profiles\\Charts') -File -Recurse -Filter 'chart*.chr' -ErrorAction SilentlyContinue)){", ["01_"]),
 ("kb_diviso_1000", "[math]::Round([double]$os.FreePhysicalMemory / 1024, 0)", "[math]::Round([double]$os.FreePhysicalMemory / 1000, 0)", ["01_"]),
 ("pavimento_con_min", "[math]::Max(1024, $LiberaMB - 800)", "[math]::Min(1024, $LiberaMB - 800)", ["01_"]),
 ("giallo_400", "([math]::Round($WsNostro + 500, 0))", "([math]::Round($WsNostro + 400, 0))", ["01_"]),
 ("rosso_700", "([math]::Round($WsNostro + 800, 0))", "([math]::Round($WsNostro + 700, 0))", ["01_"]),
 ("cpu_x10", "($c1 - $c0) / $CampioneSec * 100", "($c1 - $c0) / $CampioneSec * 10", ["01_"]),
 ("zip_senza_prima", "Compress-Archive -LiteralPath $RefTxt, $PriTxt -DestinationPath $Zip -Force", "Compress-Archive -LiteralPath $RefTxt -DestinationPath $Zip -Force", ["01_"]),
 ("prossimo_passo_anche_su_stop", "if($Installato -or $GiaUguale){\n  Dico ''", "if($true){\n  Dico ''", ["03_"]),
 ("esito_fermato_perde_il_motivo", "if($Fatale -ne ''){ $Esito = 'FERMATO -- ' + $Fatale }", "if($Fatale -ne ''){ $Esito = 'FERMATO -- (vedi sopra)' }", ["03_"]),
 ("altri_profili_non_letti", "foreach($u in @(Get-ChildItem -LiteralPath ($Drive + '\\Users') -Directory -ErrorAction Stop)){", "foreach($u in @()){", ["03b", "03c"]),
 ("bom_utf16_non_tolto", "if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }", "if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return ([Text.Encoding]::Unicode.GetString($b)) }", ["01_"]),
 ("bom_utf8_non_tolto", "return ([Text.Encoding]::UTF8.GetString($b)).TrimStart([char]0xFEFF)", "return ([Text.Encoding]::UTF8.GetString($b))", ["06c"]),
 ("norm_senza_barra_finale", "(($p -replace '/', '\\').TrimEnd('\\')).ToLower()", "(($p -replace '/', '\\')).ToLower()", ["06e"]),
 ("norm_senza_minuscole", "(($p -replace '/', '\\').TrimEnd('\\')).ToLower()", "(($p -replace '/', '\\').TrimEnd('\\'))", ["06e"]),
 ("dedup_root_tolto", "if(StessaCartella $x.Root $rApp){ $giaApp = $true }", "if($false){ $giaApp = $true }", ["01_"]),
 ("profilelast_non_letto", "'(?im)^[ \\t]*ProfileLast[ \\t]*=[ \\t]*(.+?)[ \\t\\r]*$'", "'(?im)^[ \\t]*ProfileLastX[ \\t]*=[ \\t]*(.+?)[ \\t\\r]*$'", ["01_"]),
 ("login_senza_previous", "(?:login|authorized|connesso|previous)", "(?:login|authorized|connesso)", ["01_"]),
 ("ombra_gia_attaccata_non_vista", "if($nm -like '*EMA200_Ombra*'){", "if($false){", ["13b"]),
 ("ex5_non_visto", "if(Test-Path -LiteralPath $ex5){", "if($false){", ["16"]),
 ("desktop_senza_ripiego", "if(-not (Test-Path -LiteralPath $Dsk)){ $Dsk = $env:USERPROFILE }", "", ["14"]),
 ("nostri_piu_di_uno_muto", "if($NostriN -gt 1){", "if($false){", ["11d"]),
 ("nessun_terminale_muto", "if($NostriN -eq 0){", "if($false){", ["11a"]),
 ("metaeditor_non_visto", "$me = @(Get-Process -Name metaeditor64 -ErrorAction SilentlyContinue)", "$me = @()", ["11f"]),
 ("ram_bassa_muta", "if($null -ne $LiberaMB -and $LiberaMB -lt 1024){", "if($false){", ["12b"]),
 ("ram_poco_margine_muta", "if($null -ne $LiberaMB -and $LiberaMB -ge 1024 -and $LiberaMB -lt 1800){", "if($false){", ["12c"]),
]


def prova(args):
    nome, old, new, sent = args
    n = ORIG.count(old)
    if n != 1:
        return nome, "ANCORA: %d occorrenze di %r" % (n, old[:50]), []
    sc = B.scenari()
    scelti = [s for s in sc if any(s[0].startswith(x) for x in sent)]
    assert scelti, "nessuna sentinella per " + nome
    rossi = []
    for (n_, sp, op, at) in scelti:
        o = dict(op)
        o["patch"] = list(o.get("patch", [])) + [(old, new)]
        _, err = B.runna((n_, sp, o, at, RIGA))
        if err:
            rossi.append(n_)
    if rossi:
        return nome, "PRESA da " + ",".join(rossi), rossi
    # la sentinella e' verde: si prova tutta la batteria
    alt = []
    for (n_, sp, op, at) in sc:
        if n_ in [s[0] for s in scelti]:
            continue
        o = dict(op)
        o["patch"] = list(o.get("patch", [])) + [(old, new)]
        _, err = B.runna((n_, sp, o, at, RIGA))
        if err:
            alt.append(n_)
    if alt:
        return nome, "PRESA SOLO DA ALTRO scenario (%s): la sentinella non isola il controllo" % ",".join(alt[:3]), alt
    return nome, "SOPRAVVISSUTA", []


def main():
    jobs = int(sys.argv[sys.argv.index("--jobs") + 1]) if "--jobs" in sys.argv else 4
    with Pool(jobs) as p:
        res = p.map(prova, M)
    presi = 0
    for nome, esito, _ in res:
        print("  mutazione %-34s -> %s" % (nome, esito))
        if esito.startswith("PRESA da "):
            presi += 1
    altro = [r for r in res if r[1].startswith("PRESA SOLO")]
    print("MUTAZIONI: %d/%d PRESE dalla sentinella (%d prese solo da altro scenario)" % (presi, len(M), len(altro)))
    return 0 if presi == len(M) else 1


if __name__ == "__main__":
    sys.exit(main())
