#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni_py.py -- il collaudo del collaudo per i DUE strumenti python di P1: dukascopy/leggi_f2_dk.py (il valutatore della F2) e dukascopy/dukascopy_tick.py (--dst fisso, --nome-uscita,
--senza-raccolta, --confronta-giorni). Ogni mutazione TESTUALE spegne UN controllo o sbaglia UNA regola; il --autotest del modulo mutato deve uscire con codice diverso da 0.
EQUIVALENTE dichiarato (1, col conto): confronto_conteggio_ignorato -- togliere "nv == nn" dal confronto dei giorni non cambia nessun esito, perche' due insiemi di righe di
conteggio diverso hanno SHA256 diversi (salvo collisione); il controllo del conteggio resta come difesa in profondita' e per il messaggio ("righe vecchie N nuove M").
EQUIVALENTE dichiarato (2): copia_giorno_non_validato -- senza la validazione esplicita del formato, strptime("%Y.%m.%d") solleva comunque ValueError su "2025-03-12" e copia_cache_cmd lo trasforma
nello stesso rc 2: la validazione resta per dare il messaggio giusto.
Uso: python3 mutazioni_py.py   -> ultima riga "MUTAZIONI PY: p/n PRESE (+ equivalenti dichiarati)"
"""
import os, shutil, subprocess, sys, tempfile
QD = os.path.dirname(os.path.abspath(__file__))
DUK = os.path.abspath(os.path.join(QD, "..", "dukascopy"))
PIANO = os.path.abspath(os.path.join(QD, "..", "..", "report", "PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md"))
F2 = [
 ("dentro_mediana_stretta", "dentro = (med <= SOGLIA_DIFF and cop >= SOGLIA_COP)", "dentro = (med < SOGLIA_DIFF and cop >= SOGLIA_COP)"),
 ("dentro_copertura_stretta", "dentro = (med <= SOGLIA_DIFF and cop >= SOGLIA_COP)", "dentro = (med <= SOGLIA_DIFF and cop > SOGLIA_COP)"),
 ("dentro_senza_copertura", "dentro = (med <= SOGLIA_DIFF and cop >= SOGLIA_COP)", "dentro = (med <= SOGLIA_DIFF)"),
 ("discordanza_tolta", "    if dentro != (x[\"PassaImportatore\"] == \"SI\"):\n        return (\"DISCORDANZA\", med, cop)\n", ""),
 ("soglia_diversa_tolta", "    if sd != SOGLIA_DIFF or sc != SOGLIA_COP:\n        return (\"SOGLIA_DIVERSA\", med, cop)\n", ""),
 ("ripetuto_tollerato", "    if len(r) > 1:\n        return (\"RIPETUTO\", None, None)\n    x = r[0]", "    x = r[0]"),
 ("esito_non_misurato_ignorato", "    if x[\"Esito\"] != \"MISURATO\":\n        return (x[\"Esito\"] or \"ESITO_VUOTO\", med, cop)\n", ""),
 ("attribuzione_ignorata", "ok = all(s == \"DENTRO\" for (_, s, _, _) in per) and not anomalie", "ok = all(s == \"DENTRO\" for (_, s, _, _) in per)"),
 ("uno_su_nove_basta", "ok = all(s == \"DENTRO\" for (_, s, _, _) in per) and not anomalie", "ok = any(s == \"DENTRO\" for (_, s, _, _) in per) and not anomalie"),
 ("versione_non_controllata", "    if any(not x[\"Versione\"].startswith(PREFISSO_VERSIONE) for x in righe_dk):\n        raise FileNonValutabile(\"file di U30USD_DK:", "    if False:\n        raise FileNonValutabile(\"file di U30USD_DK:"),
 ("n0_certifica_sha_vuoto_a_mano", "uguali = (nv > 0 and nv == nn and", "uguali = (nv >= 0 and nv == nn and"),
 ("sha_non_confrontato", "nv == nn and x[\"ShaVecchie\"] == x[\"ShaNuove\"] and", "nv == nn and"),
 ("dichiara_si_basta", "        if uguali and dichiara:\n            per.append((g, \"IDENTICO\", nv, nn))", "        if dichiara:\n            per.append((g, \"IDENTICO\", nv, nn))"),
 ("estivi_con_2024_11_20", "ESTIVI5 = [\"2025.06.10\",", "ESTIVI5 = [\"2024.11.20\", \"2025.06.10\","),
 ("doppio_stretto", "doppio = (mn >= 2.0 * mg)", "doppio = (mn > 2.0 * mg)"),
 ("sopra_largo", "sopra = (mn > SOGLIA_DIFF)", "sopra = (mn >= SOGLIA_DIFF)"),
 ("sopra_tolto", "via_a = bool(doppio and sopra)", "via_a = bool(doppio)"),
 ("giusto_non_misurato_ammesso", "            elif not misurato(sg):", "            elif False:"),
 ("neg_nc_ammesso", "            if not misurato(sn):", "            if False:"),
 ("via_a_e_via_b", "return (via_a or via_b), via_a, via_b, note", "return (via_a and via_b), via_a, via_b, note"),
 ("lag_largo", "fuori = [g for g in GIORNI9 if lag[g][0] is None or abs(lag[g][0]) > 1]", "fuori = [g for g in GIORNI9 if lag[g][0] is None or abs(lag[g][0]) > 5]"),
 ("lag_aggregato", "fuori = [g for g in GIORNI9 if lag[g][0] is None or abs(lag[g][0]) > 1]", "fuori = [] if abs(sum(lag[g][0] for g in GIORNI9)) <= 1 else list(GIORNI9)"),
 ("k0b_simbolo_ignorato", "            if x[\"Simbolo\"] == SIM_DK:\n                lag.setdefault", "            if True:\n                lag.setdefault"),
 ("esito_or", "esito = \"PASSA\" if (ok1 and ok2 and ok3) else \"NON PASSA\"", "esito = \"PASSA\" if (ok1 and ok2) or ok3 else \"NON PASSA\""),
 ("esito_senza_2", "esito = \"PASSA\" if (ok1 and ok2 and ok3) else \"NON PASSA\"", "esito = \"PASSA\" if (ok1 and ok3) else \"NON PASSA\""),
 ("neg_simbolo_ignorato", "        altri = [x for x in righe_neg if x[\"Simbolo\"] != SIM_NEG]\n        if altri:", "        altri = []\n        if altri:"),
 ("giorno_neg_sbagliato", "GIORNO_NEG = \"2025.03.12\"", "GIORNO_NEG = \"2025.03.25\""),
 ("giorni9_senza_uno", "\"2025.01.14\", \"2025.02.11\"]\nESTIVI5", "\"2025.01.14\"]\nESTIVI5"),
 ("testo_f2_alterato", "mediana <= 0,05 %, copertura >= 80 %), piu\\' il **controllo negativo**", "mediana <= 0,06 %, copertura >= 80 %), piu\\' il **controllo negativo**"),
 ("file_vuoto_accettato", "    if not righe:\n        raise FileNonValutabile(\"%s: file vuoto\" % nome)\n", "    if not righe:\n        return []\n"),
 ("intestazione_non_controllata", "    if [c.strip() for c in righe[0]] != colonne:", "    if False:"),
]
DT = [
 ("verifica_vuoto_e_buco", "                elif not dati:\n                    c[\"vuoti\"] += 1", "                elif False:\n                    c[\"vuoti\"] += 1"),
 ("verifica_buchi_ignorati", "        if r[\"buchi\"] or r[\"illeggibili\"]:\n            rc = 3", "        if False:\n            rc = 3"),
 ("verifica_illeggibili_ignorati", "        if r[\"buchi\"] or r[\"illeggibili\"]:\n            rc = 3", "        if r[\"buchi\"]:\n            rc = 3"),
 ("verifica_simbolo_assente_ok", "            log(\"%s: cartella %s ASSENTE\" % (sym, os.path.join(raw, sym)))\n            rc = 3", "            log(\"%s: cartella %s ASSENTE\" % (sym, os.path.join(raw, sym)))\n            rc = 0"),
 ("copia_src_dst_ammessi", "    if os.path.abspath(lavoro_src) == os.path.abspath(lavoro_dst):\n        raise ValueError", "    if False:\n        raise ValueError"),
 ("copia_solo_bi5", "            for (s, d) in ((s_ok, d_ok), (s_no, d_no)):", "            for (s, d) in ((s_ok, d_ok),):"),
 ("copia_mancanti_ignorati", "    if mancanti:\n        log(\"COPIA CACHE: INCOMPLETA", "    if False:\n        log(\"COPIA CACHE: INCOMPLETA"),
 ("copia_giorno_non_validato", "    for g in giorni_txt:\n        if not GIORNO_RE.match(g):\n            raise ValueError(\"giorno '%s' non e' AAAA.MM.GG\" % g)\n    copiati, mancanti", "    copiati, mancanti"),
 ("fisso_zero", "    if dst == \"fisso\":\n        return timedelta(hours=1)", "    if dst == \"fisso\":\n        return timedelta(0)"),
 ("fisso_alias_usa", "    if dst == \"fisso\":\n        return timedelta(hours=1)           # BCM indici", "    if dst == \"fisso\":\n        return timedelta(hours=1) if dst_usa_attivo(dt_utc) else timedelta(0)           # BCM indici"),
 ("fisso_alias_europa", "    if dst == \"fisso\":\n        return timedelta(hours=1)           # BCM indici", "    if dst == \"fisso\":\n        return timedelta(hours=1) if dst_eu_attivo(dt_utc) else timedelta(0)           # BCM indici"),
 ("nome_uscita_ignorato", "scrittore = ScrittoreMensile(out, nome_out, \"%%.%df\" % decimali)", "scrittore = ScrittoreMensile(out, bcm + \"_DK\", \"%%.%df\" % decimali)"),
 ("raccolta_sempre", "    if not args.senza_raccolta:\n        raccogli_desktop(file_referto, \"dukascopy_tick.zip\")", "    if True:\n        raccogli_desktop(file_referto, \"dukascopy_tick.zip\")"),
 ("confronto_n0_identico", "righe.append((g, nv, nn, sv if nv else \"-\", sn if nn else \"-\", bool(nv > 0 and nv == nn and sv == sn)))", "righe.append((g, nv, nn, sv if nv else \"-\", sn if nn else \"-\", bool(nv == nn and sv == sn)))"),
 ("confronto_sha_ignorato", "bool(nv > 0 and nv == nn and sv == sn)", "bool(nv > 0 and nv == nn)"),
 ("confronto_conteggio_ignorato", "bool(nv > 0 and nv == nn and sv == sn)", "bool(nv > 0 and sv == sn)"),
 ("confronto_prefissi_ignorati", "    if pv != pn:\n        raise ValueError(\"prefissi dei CSV diversi", "    if False:\n        raise ValueError(\"prefissi dei CSV diversi"),
 ("confronto_mese_saltato", "        if mese not in mesi:\n            continue", "        if True:\n            continue"),
 ("confronto_chiave_giorno", "s = out.get(riga[:10].decode(\"ascii\", \"replace\"))", "s = out.get(riga[:9].decode(\"ascii\", \"replace\"))"),
 ("nome_uscita_valido_tolto", "        if not re.match(r\"^[A-Za-z0-9_]+$\", args.nome_uscita):", "        if False:"),
 ("percorso_cache_mese_zero", "                     \"%02d\" % dt_utc.month, \"%02d\" % dt_utc.day)\n    f_ok = os.path.join(d, \"%02dh_ticks.bi5\" % dt_utc.hour)\n    return d, f_ok, f_ok + \".assente\"", "                     \"%02d\" % (dt_utc.month - 1), \"%02d\" % dt_utc.day)\n    f_ok = os.path.join(d, \"%02dh_ticks.bi5\" % dt_utc.hour)\n    return d, f_ok, f_ok + \".assente\""),
 ("fuso_utc_non_vince", "    if fuso == \"utc\":\n        return dt_utc\n    return dt_utc + offset_server(dt_utc, dst)", "    return dt_utc + offset_server(dt_utc, dst)"),
]


EQUIVALENTI = {"confronto_conteggio_ignorato", "copia_giorno_non_validato"}


def prova(nome, old, new, modulo):
    base = tempfile.mkdtemp(prefix="mpy_")
    d = os.path.join(base, "backtest_pipeline", "dukascopy")
    os.makedirs(d)
    try:
        for f in ("dukascopy_tick.py", "leggi_f2_dk.py"):
            shutil.copy(os.path.join(DUK, f), d)
        # il piano per il controllo del testo F2: nel posto relativo giusto (<base>/report/), cosi' il controllo NON e' saltato
        os.makedirs(os.path.join(base, "report"))
        shutil.copy(PIANO, os.path.join(base, "report"))
        p = os.path.join(d, modulo)
        t = open(p, encoding="utf-8").read()
        if t.count(old) != 1:
            return nome, "NON APPLICABILE (%d occorrenze)" % t.count(old)
        open(p, "w", encoding="utf-8").write(t.replace(old, new))
        r = subprocess.run([sys.executable, p, "--autotest"], capture_output=True, text=True, timeout=600)
        return nome, ("PRESA" if r.returncode != 0 else "SOPRAVVISSUTA")
    finally:
        shutil.rmtree(base, ignore_errors=True)


def main():
    from multiprocessing import Pool
    jobs = [(n, o, w, "leggi_f2_dk.py") for (n, o, w) in F2] + [(n, o, w, "dukascopy_tick.py") for (n, o, w) in DT]
    with Pool(4) as p:
        res = p.starmap(prova, jobs)
    ok = 0; eq = 0
    for n, e in res:
        if n in EQUIVALENTI and e == "SOPRAVVISSUTA":
            e = "EQUIVALENTE (dichiarato nel docstring)"; eq += 1
        print("  %-34s %s" % (n, e))
        if e == "PRESA": ok += 1
    print("MUTAZIONI PY: %d/%d PRESE (+ %d equivalenti dichiarati)" % (ok, len(jobs) - eq, eq))
    return 0 if ok + eq == len(jobs) else 1


if __name__ == "__main__":
    sys.exit(main())
