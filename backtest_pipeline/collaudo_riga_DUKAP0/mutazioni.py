#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni.py -- il collaudo del collaudo per RIGA_DUKA_P0_CENSIMENTO.ps1: ogni mutazione TESTUALE spegne UN controllo (o ne sbaglia uno) e almeno uno scenario della batteria
deve diventare ROSSO. Una mutazione verde = un controllo che la batteria non protegge (classe 1068/1074: i mutanti non li scrive solo chi ha scritto le ancore: qui c'e' anche
il caso 'plausibile ma sbagliato' del mese 1-based, dichiarato nel docstring di fixture.py PRIMA di scrivere lo script).
Strategia: si provano prima gli scenari sentinella; se nessuno e' rosso si prova TUTTA la batteria (una mutazione e' PRESA se cade in uno qualsiasi).
Uso: python3 mutazioni.py [--jobs N]   -> ultima riga "MUTAZIONI: p/n PRESE"
"""
import os, sys, tempfile
from multiprocessing import Pool
import battery as B

QD = os.path.dirname(os.path.abspath(__file__))
RIGA = os.path.abspath(os.path.join(QD, "..", "righe", "RIGA_DUKA_P0_CENSIMENTO.ps1"))
ORIG = open(RIGA, encoding="ascii", newline="").read()
TMP = os.environ.get("HARNESS_TMP") or tempfile.mkdtemp(prefix="p0mut_")

M = [
 # --- il percorso e la finestra della cache
 ("mese_zero_based_dell_url", "$d.Month.ToString('00', $INV) + '\\' + $d.Day", "($d.Month - 1).ToString('00', $INV) + '\\' + $d.Day", ["01"]),
 ("sabato_non_saltato", "if($d.DayOfWeek -ne [DayOfWeek]::Saturday){", "if($true){", ["01"]),
 ("fine_finestra_15", "$Giorno2 = '2025-06-16'", "$Giorno2 = '2025-06-15'", ["01"]),
 ("inizio_finestra_02", "$Giorno1 = '2024-10-01'", "$Giorno1 = '2024-10-02'", ["01"]),
 ("simbolo_sbagliato", "$rawS = Join-Path $raw 'USA30IDXUSD'", "$rawS = Join-Path $raw 'USATECHIDXUSD'", ["01"]),
 ("assente_suffisso", "$nomi.ContainsKey($n + '.assente')", "$nomi.ContainsKey($n + '.assent')", ["01"]),
 ("buco_contato_come_assente", "else { $c.buchi++; [void]$oreBuco.Add($h.ToString('00', $INV) + 'h') }", "else { $c.ass++ }", ["04"]),
 ("zero_byte_come_bi5", "if($nomi[$n] -gt 0){", "if($nomi[$n] -ge 0){", ["04"]),
 ("doppio_non_contato", "if($ha -and $hs){ $c.doppi++;", "if($false){ $c.doppi++;", ["04"]),
 ("tmp_non_contato", "if($nomi.ContainsKey($n + '.tmp')){ $c.tmp++ }", "", ["04"]),
 ("byte_non_sommati", "$tot.byte += $c.byte", "", ["01"]),
 ("zero_byte_come_buco", "$completo = ($c.buchi -eq 0 -and $c.doppi -eq 0)", "$completo = ($c.buchi -eq 0 -and $c.zero -eq 0 -and $c.doppi -eq 0)", ["04"]),
 ("completo_ignora_doppi", "$completo = ($c.buchi -eq 0 -and $c.doppi -eq 0)", "$completo = ($c.buchi -eq 0)", ["04"]),
 ("completo_ignora_buchi", "$completo = ($c.buchi -eq 0 -and $c.doppi -eq 0)", "$completo = ($c.doppi -eq 0)", ["04"]),
 ("zero_non_elencati", "      if($c.zero -gt 0){ [void]$conZero.Add(", "      if($false){ [void]$conZero.Add(", ["04"]),
 ("campione_percorsi_tolto", "    Dico ('esempi di percorso nell albero", "    $null = ('esempi di percorso nell albero", ["01"]),
 ("elenco_lavoro_tolto", "        Dico ('cartelle in dukascopy_lavoro (dove sta la cache, se non e qui?): ' + ($sott -join ', '))", "", ["03"]),
 ("giorno_senza_cartella_ok", "} else { $tot.senzaCartella++ }", "} else { }", ["04"]),
 ("fuori_finestra_non_contato", "if(-not $finestra.ContainsKey($f.FullName)){ $fuori++ }", "", ["01"]),
 ("cache_assente_non_ferma", "if(-not $S.cache_esiste){", "if($false){", ["03"]),
 # --- i 9 giorni
 ("sonda_senza_0312", "'2025.03.12','2025.03.25'", "'2025.03.25'", ["01"]),
 ("nuovi_senza_asterisco", "$GiorniNuovi = @('2024.12.10','2025.01.14','2025.02.11','2025.03.12')", "$GiorniNuovi = @('2024.12.10','2025.01.14','2025.02.11')", ["01"]),
 ("sonda_completi_ignora_buchi", "if($null -ne $c -and $c.buchi -eq 0 -and $c.doppi -eq 0){ $sonda += $g }", "if($null -ne $c){ $sonda += $g }", ["04"]),
 # --- CSV
 ("righe_con_intestazione", "$o.Righe = [math]::Max([long]0, $n - 1)", "$o.Righe = $n", ["01"]),
 ("primo_e_intestazione", "if($n -eq 2){ $prima = $l }", "if($n -eq 1){ $prima = $l }", ["01"]),
 ("totale_righe_sbagliato", "$S.csv_righe += $i.Righe", "$S.csv_righe += 1", ["01"]),
 ("dkneg_non_cercato", "-Filter '*DKNEG*'", "-Filter '*DKNEGX*'", ["12"]),
 ("backup_non_cercato", "$_.Name -like 'tick_*' -or $_.Name -like '*backup*'", "$_.Name -like 'zzz_*'", ["12"]),
 ("referto_py_non_letto", "-TotalCount 12", "-TotalCount 0", ["01"]),
 # --- dischi
 ("disco_sbagliato", "$lettera = $Matches[1].ToUpper()", "$lettera = 'D:'", ["01", "05"]),
 ("soglia_confronto_invertita", "$ok = ($S.liberi_lavoro_gb -ge $SogliaLiberiGB)", "$ok = ($S.liberi_lavoro_gb -le $SogliaLiberiGB)", ["01", "05"]),
 ("passo_senza_catch", "  catch{\n    $m = Pulisci ('' + $_.Exception.Message)\n    [void]$Problemi.Add($nome + ': ' + $m)", "  catch{\n    throw\n    $m = Pulisci ('' + $_.Exception.Message)\n    [void]$Problemi.Add($nome + ': ' + $m)", ["05c"]),
 # --- MT5, terminale, conto
 ("mt5_sempre_aperto", "$S.mt5_aperto = (@($viv | Where-Object { $_.ProcessName -eq 'terminal64' }).Count -gt 0)", "$S.mt5_aperto = $true", ["01"]),
 ("processo_sbagliato", "$_.ProcessName -eq 'terminal64' }).Count -gt 0)", "$_.ProcessName -eq 'terminal32' }).Count -gt 0)", ["06"]),
 ("origin_con_like", "$_.Origine -ieq $TermBcm", "$_.Origine -like '*BCM Markets MT5 Terminal*'", ["08"]),
 ("origin_bom_non_tolto", "return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }\n  $zeri", "return ([Text.Encoding]::Unicode.GetString($b)) }\n  $zeri", ["01"]),
 ("chr_expert_sbagliato", "if($t -match '<expert>'){", "if($t -match '<expertX>'){", ["07"]),
 ("chr_illeggibile_non_contato", "$S.chr_illeggibili++; Dico", "Dico", ["07"]),
 ("chr_zero_etichettato_misurato", "$(if($S.chr_letti -eq 0){ $nonm }else{ $mis })", "$mis", ["01"]),
 ("chr_zero_non_dichiarato", "if($S.chr_letti -eq 0){ Dico 'ZERO grafici letti", "if($false){ Dico 'ZERO grafici letti", ["01"]),
 ("login_regex_rotto", "(\\d{5,12})')\n        $mS", "(\\d{99})')\n        $mS", ["01"]),
 ("log_conto_regex_rotto", "\"'(\\d{6,12})'\\s*:", "\"'(\\d{99})'\\s*:", ["01"]),
 ("conti_discordanti_muti", "if($S.ContainsKey('conto_ini') -and $S.ContainsKey('conto_log')", "if($false -and $S.ContainsKey('conto_log')", ["11b"]),
 ("mese_nativo_tolto", "$MesiNativi  = @('202410','202411',", "$MesiNativi  = @('202410',", ["01"]),
 ("custom_neg_non_cercato", "$_.Name -like 'U30USD_DKNEG*'", "$_.Name -like 'Z*'", ["12"]),
 ("bases_assente_silenzioso", "NON MISURATI (non vuol dire che manchino: il terminale non ha mai scaricato tick?)", "", ["16"]),
 ("python_store_non_visto", "$store = ($p -match 'WindowsApps')", "$store = $false", ["13"]),
 ("curl_sbagliato", "'System32\\curl.exe'", "'System32\\curl2.exe'", ["01"]),
 # --- guardia macchina, exit, pin
 ("guardia_macchina_larga", "if($env:COMPUTERNAME -ne $MacchinaAmmessa){", "if($env:COMPUTERNAME -notlike 'DESKTOP*'){", ["02c"]),
 ("guardia_macchina_tolta", "if($env:COMPUTERNAME -ne $MacchinaAmmessa){", "if($false){", ["02"]),
 ("exit_in_coda", "Write-Host 'ESITO P0: CENSIMENTO COMPLETO (solo lettura). La lettura per P1 la fa chi riceve lo zip.' -ForegroundColor Green }", "Write-Host 'ESITO P0: CENSIMENTO COMPLETO (solo lettura). La lettura per P1 la fa chi riceve lo zip.' -ForegroundColor Green }\nexit 0", ["01"]),
 ("pin_non_letto", "-Name DUKA_P0_PIN", "-Name DUKA_P0_PINX", ["01"]),
 ("sha_non_letto", "-Name DUKA_P0_SHA", "-Name DUKA_P0_SHAX", ["01"]),
 # --- raccolta
 ("zip_senza_csv_tick", "  Set-Content -LiteralPath (Join-Path $Cart 'P0_CSV_TICK.csv') -Value ($CsvTick -join \"`r`n\") -Encoding ASCII\n", "", ["01"]),
 ("zip_senza_cache_csv", "  Set-Content -LiteralPath (Join-Path $Cart 'P0_CACHE_PER_GIORNO.csv') -Value ($CsvCache -join \"`r`n\") -Encoding ASCII\n", "", ["01"]),
 ("desktop_senza_ripiego", "if(-not (Test-Path -LiteralPath $Dsk)){ $Dsk = $env:USERPROFILE }", "", ["14"]),
 ("pulisci_tolta", "function Pulisci([string]$t){ if($null -eq $t){ return '' }; return ($t -replace '[^\\x20-\\x7E]', '?') }", "function Pulisci([string]$t){ return $t }", ["07"]),
 # --- SOLA LETTURA: una scrittura infilata nel censimento
 ("scrive_nel_lavoro", "  Titolo '2. SPAZIO LIBERO SUI DISCHI'", "  Set-Content -LiteralPath (Join-Path $Lavoro 'x.txt') -Value 1\n  Titolo '2. SPAZIO LIBERO SUI DISCHI'", ["01"]),
 ("cancella_residuo", "      $negs = @(", "      Get-ChildItem -LiteralPath $tick -Filter '*DKNEG*' | Remove-Item\n      $negs = @(", ["12"]),
 # --- classe 1119 (controllo preventivo 05/10): history\U30USD (barre M1) contata come cartella dei tick
 ("nativi_anche_history", "$_.Name -eq 'U30USD' -and $_.Parent.Name -ieq 'ticks' })", "$_.Name -eq 'U30USD' })", ["16c"]),
 ("custom_anche_history", "$_.Name -eq 'U30USD_DK' -and $_.Parent.Name -ieq 'ticks' }).Count\n", "$_.Name -eq 'U30USD_DK' }).Count\n", ["16d"]),
 # --- MaxBars (piano par. 3.1 P0, classe 160)
 ("maxbars_soglia_tolta", "$(if($S.maxbars -lt 200000){", "$(if($S.maxbars -lt 0){", ["17_"]),
 ("maxbars_non_letto", "if($mB.Count -gt 0){", "if($false){", ["17b"]),
]


def prova(m):
    nome, old, new, sent = m
    if ORIG.count(old) < 1:
        return nome, "MUTAZIONE NON APPLICABILE (testo non trovato)", None
    t = ORIG.replace(old, new, 1) if nome not in ("origin_con_like",) else ORIG.replace(old, new)
    d = tempfile.mkdtemp(prefix="m_", dir=TMP)
    f = os.path.join(d, "mut.ps1")
    open(f, "w", encoding="ascii", newline="").write(t)
    # sentinelle prima
    res = []
    for s, sp, op in B.scenari():
        if any(s.startswith(x) for x in sent):
            n, err = B.runna(s, sp, op, f)
            if err:
                return nome, "PRESA da " + n, err[0][:120]
    return nome, "TUTTI", f


def tutta(args):
    nome, f = args
    out = []
    for s, sp, op in B.scenari():
        n, err = B.runna(s, sp, op, f)
        if err:
            return nome, "PRESA (batteria intera) da " + n, err[0][:120]
    return nome, "SOPRAVVISSUTA", ""


def main():
    jobs = int(sys.argv[sys.argv.index("--jobs") + 1]) if "--jobs" in sys.argv else 4
    with Pool(jobs) as p:
        r1 = p.map(prova, M)
    prese = 0; nonapp = []; resto = []
    for nome, esito, extra in r1:
        if esito.startswith("PRESA"):
            prese += 1; print("  presa    %-32s %s" % (nome, esito))
        elif esito.startswith("MUTAZIONE NON"):
            nonapp.append(nome); print("  NON APPLICABILE %s" % nome)
        else:
            resto.append((nome, extra))
    if resto:
        with Pool(jobs) as p:
            r2 = p.map(tutta, resto)
        for nome, esito, extra in r2:
            if esito.startswith("PRESA"):
                prese += 1; print("  presa    %-32s %s" % (nome, esito))
            else:
                print("  SOPRAVVISSUTA %s" % nome)
    print("MUTAZIONI: %d/%d PRESE (non applicabili: %d)" % (prese, len(M), len(nonapp)))
    return 0 if prese == len(M) else 1


if __name__ == "__main__":
    sys.exit(main())
