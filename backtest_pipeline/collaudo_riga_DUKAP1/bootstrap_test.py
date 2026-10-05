#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
bootstrap_test.py -- collaudo del bootstrap RIGA_LANCIA_DUKA_P1.txt: (1) rigenerato dal generatore al commit e confrontato byte per byte col file committato (classe 1093), con le impronte dei QUATTRO file
+ driver lette con git show; (2) eseguito nel banco di P1 contro un server HTTP locale (URL di GitHub raw sostituito) con le impronte dei file SERVITI (che nel banco hanno l'URL locale): scenari ok / driver
manomesso (IMPRONTA DIVERSA, niente eseguito, niente scritto) / marcatore assente / macchina sbagliata (zero richieste); (3) tre mutazioni del bootstrap (guardia macchina, controllo impronta, controllo marcatore)
che devono far diventare rosso uno scenario; e il passaggio delle impronte alla riga (-ShaPy ecc.): una impronta alterata nella chiamata deve fermare la riga alla fase B.
Uso: python3 bootstrap_test.py <COMMIT_DEL_DRIVER>
"""
import hashlib, os, subprocess, sys, tempfile
import h1
import bootstrap as BS

QD = os.path.dirname(os.path.abspath(__file__))
C = sys.argv[1]
TMP = os.environ.get("HARNESS_TMP") or tempfile.mkdtemp(prefix="p1boot_")


def esegui(line_tpl, spec, drv_serv, macchina=None):
    """line_tpl: bootstrap con le impronte da usare; drv_serv: i byte che il server servira' come driver"""
    spec = dict(spec)
    if macchina:
        spec["macchina"] = macchina
    b = tempfile.mkdtemp(prefix="b_", dir=TMP)
    c = h1.costruisci(b, spec)
    srv = h1.Srv(spec)
    srv.files[h1.FILE_DRV_PATH] = drv_serv(srv) if callable(drv_serv) else drv_serv
    shas = dict(drv=BS.sha(srv.files[h1.FILE_DRV_PATH]), py=srv.sha(h1.FILE_PY), f2=srv.sha(h1.FILE_F2), imp=srv.sha(h1.FILE_IMP), mq5=srv.sha(h1.FILE_MQ5))
    line = line_tpl(shas, srv)
    f = os.path.join(b, "boot.txt")
    open(f, "w", newline="").write(line)
    p = h1.esegui(spec, c, f, "", srv, b, timeout=900, iex=True)
    desk = os.path.join(c, "Users", "Master", "Desktop")
    r = dict(out=p.stdout + p.stderr, hits=list(srv.hits), desk=sorted(os.listdir(desk)), c=c, work=os.path.exists(os.path.join(c, "Users", "Master", "abtg_duka_p1")))
    srv.chiudi()
    return r


def main():
    err = []
    gen = BS.genera(C)
    committato = os.path.join(h1.REPO, "backtest_pipeline", "righe", "RIGA_LANCIA_DUKA_P1.txt")
    if os.path.exists(committato):
        if open(committato, encoding="ascii", newline="").read() != gen:
            err.append("il bootstrap COMMITTATO non e' identico a quello rigenerato al commit %s (classe 1093)" % C[:8])
    else:
        print("  (bootstrap committato non ancora presente: confronto byte per byte saltato)")
    if "\n" in gen or any(ord(ch) > 126 for ch in gen):
        err.append("il bootstrap non e' UNA riga ASCII")
    for fr in ("BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ", "10105439", "50504263", "50503392", "1514806751", "VMI3047753", "NON tocca preset, EA, taglie, rischio, conti"):
        if fr not in gen:
            err.append("manca nel BERSAGLIO: " + fr)
    for k, f in (("drv", BS.FILE_DRV), ("py", BS.FILE_PY), ("f2", BS.FILE_F2), ("imp", BS.FILE_IMP), ("mq5", BS.FILE_MQ5)):
        if BS.sha(BS.git_show(C, f)) not in gen:
            err.append("l'impronta di %s al commit non e' nel bootstrap" % f)
    spec = h1.spec_base()
    def ok_line(shas, srv):
        return BS.genera(h1.PIN, shas=shas, raw=srv.base)
    h1.FILE_DRV_PATH = BS.FILE_DRV
    def drv_ok(srv):
        return open(os.path.join(h1.REPO, BS.FILE_DRV), "rb").read().replace(h1.RAW.encode(), srv.base.encode())
    # (a) tutto ok
    r = esegui(ok_line, spec, drv_ok)
    for s in ("Riga P1 scaricata, impronta OK:", "ESITO P1: fasi eseguite, ESITO F2 = PASSA", "codice d uscita della riga P1: 0", "FASE K: valutazione F2: PASSA"):
        if s not in r["out"]:
            err.append("(a) manca: " + s)
    if not any(x.startswith("DUKA_P1_") and x.endswith(".zip") for x in r["desk"]):
        err.append("(a) manca lo zip DUKA_P1")
    # (b) driver manomesso DOPO il calcolo dell'impronta: la riga ha l'impronta del file buono
    def manomesso(shas, srv):
        return BS.genera(h1.PIN, shas=dict(shas, drv=BS.sha(drv_ok(srv))), raw=srv.base)
    r = esegui(manomesso, spec, lambda srv: drv_ok(srv) + b"\n# manomesso\n")
    if "IMPRONTA DIVERSA" not in r["out"] or r["work"] or r["desk"]:
        err.append("(b) il driver manomesso NON e' stato fermato dall'impronta (o ha scritto: work=%s desk=%s)" % (r["work"], r["desk"]))
    # (c) marcatore assente con impronta coerente
    senza = lambda srv: drv_ok(srv).replace(b"MARCATORE_RIGA_DUKA_P1_v1", b"MARCATORE_RIGA_DUKA_P1_vX")
    r = esegui(ok_line, spec, senza)
    if "Marcatore della riga P1 assente" not in r["out"] or r["work"] or r["desk"]:
        err.append("(c) il marcatore assente NON ha fermato la riga")
    # (d) macchina sbagliata: zero richieste, niente scritto
    r = esegui(ok_line, spec, drv_ok, macchina="VMI3047753")
    if r["hits"] or "Nessun download e stato fatto" not in r["out"] or r["work"] or r["desk"]:
        err.append("(d) la macchina sbagliata non e' stata fermata PRIMA del download (richieste %d)" % len(r["hits"]))
    # (e) impronta di un file alterata NELLA CHIAMATA: la riga si ferma alla fase B senza eseguire niente
    def sha_py_alterata(shas, srv):
        return BS.genera(h1.PIN, shas=dict(shas, py="0" * 64), raw=srv.base)
    r = esegui(sha_py_alterata, spec, drv_ok)
    if "[B]" not in r["out"] or "IMPRONTA DIVERSA per backtest_pipeline/dukascopy/dukascopy_tick.py" not in r["out"] or "FASE E:" in r["out"]:
        err.append("(e) un'impronta alterata passata alla riga NON l'ha fermata alla fase B")
    # mutazioni del bootstrap
    def mutato(old, new):
        def f(shas, srv):
            t = ok_line(shas, srv)
            assert old in t, old
            return t.replace(old, new, 1)
        return f
    muts = [("guardia_macchina", "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){", "if($false){", "d"),
            ("controllo_impronta", None, None, "b"),
            ("controllo_marcatore", "if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern 'MARCATORE_RIGA_DUKA_P1_v1')){", "if($false){", "c"),
            ("impronte_non_passate", " -ShaPy '", " -XX '", "e")]
    for nome, old, new, quale in muts:
        if nome == "controllo_impronta":
            def f(shas, srv):
                t = manomesso(shas, srv)
                import re
                return re.sub(r"if\(\$h -ne '[0-9A-F]{64}'\)\{", "if($false){", t, count=1)
            r = esegui(f, spec, lambda srv: drv_ok(srv) + b"\n# manomesso\n")
            presa = ("IMPRONTA DIVERSA" not in r["out"]) and (r["work"] or r["desk"])
        elif nome == "guardia_macchina":
            r = esegui(mutato(old, new), spec, drv_ok, macchina="VMI3047753")
            presa = bool(r["hits"]) or "Nessun download e stato fatto" not in r["out"]
        elif nome == "controllo_marcatore":
            r = esegui(mutato(old, new), spec, senza)
            presa = "Marcatore della riga P1 assente" not in r["out"]
        else:
            r = esegui(mutato(old, new), spec, drv_ok)
            presa = "ESITO P1: fasi eseguite, ESITO F2 = PASSA" not in r["out"]
        print("  mutazione bootstrap %-22s -> %s" % (nome, "PRESA" if presa else "SOPRAVVISSUTA"))
        if not presa:
            err.append("mutazione del bootstrap sopravvissuta: " + nome)
    for e in err:
        print("  X " + e)
    print("BOOTSTRAP P1: " + ("OK (5 scenari + 4 mutazioni)" if not err else "%d problemi" % len(err)))
    return 0 if not err else 1


if __name__ == "__main__":
    sys.exit(main())
