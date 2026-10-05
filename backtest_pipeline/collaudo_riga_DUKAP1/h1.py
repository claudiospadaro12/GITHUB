#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
h1.py -- il BANCO di P1: costruisce un finto disco C: del PC di backtest (PSDrive in pwsh 7), con una CACHE SINTETICA di 222 giorni costruita col layout VERO (dukascopy_tick.percorso_cache),
i CSV "del 03/09" PRODOTTI DAL TOOL VERO (dukascopy_tick.py --dst usa --solo-cache, quindi con lo stesso orologio sbagliato d'inverno), il terminale finto (metaeditor64.exe e' uno script
che produce l'.ex5; il lancio di terminal64 e' la funzione Start-Process del banco che chiama sim_mt5.py), un server HTTP LOCALE che serve i file "al pin" (con l'URL di GitHub raw sostituito
da quello locale: unica differenza dal testo vero), e lancia RIGA_DUKA_P1_OROLOGIO.ps1 (o la figlia da sola) con le sostituzioni di cmdlet assenti su Linux: Get-CimInstance (dischi), Get-Command
(python.exe -> shim di python3, o alias dello Store, o assente), Start-Process (il terminale), Start-Sleep (no-op). Compress-Archive, Get-FileHash, Invoke-WebRequest, Get-Process sono i VERI.
"""
import datetime, hashlib, http.server, json, os, shutil, subprocess, sys, tempfile, threading

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
DUK = os.path.join(REPO, "backtest_pipeline", "dukascopy")
sys.path.insert(0, DUK)
import dukascopy_tick as DT

RAW = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/"
PIN = "a" * 40
TERM = "C:\\Program Files\\BCM Markets MT5 Terminal"
D0, D1 = datetime.date(2024, 10, 1), datetime.date(2025, 6, 16)
GIORNI9 = ["2024.11.20", "2025.06.10", "2024.10.29", "2024.10.31", "2025.03.12", "2025.03.25", "2024.12.10", "2025.01.14", "2025.02.11"]
MESI = ["2024-10", "2024-11", "2024-12", "2025-01", "2025-02", "2025-03", "2025-04", "2025-05", "2025-06"]
ESTIVI = ["2025.06.10", "2024.10.29", "2024.10.31", "2025.03.12", "2025.03.25"]
INVERNO = ["2024.11.20", "2024.12.10", "2025.01.14", "2025.02.11"]
FILE_PY = "backtest_pipeline/dukascopy/dukascopy_tick.py"
FILE_F2 = "backtest_pipeline/dukascopy/leggi_f2_dk.py"
FILE_IMP = "backtest_pipeline/righe/RIGA_DUKA_IMPORT_SONDA.ps1"
FILE_MQ5 = "mql5/Scripts/ABTG_ImportaTickEsterno.mq5"
FILE_DRV_PATH = "backtest_pipeline/righe/RIGA_DUKA_P1_OROLOGIO.ps1"


MUTAZIONI_FILE = {
    "py_senza_marcatore": lambda b: b.replace(b'VERSIONE = "DUKA-TICK-v3"', b'VERSIONE = "x"').replace(b"DUKA-TICK-v3", b"DUKA-TICK-vX").replace(b"DUKA-TICK-v2", b"DUKA-TICK-vY"),
    "py_riconversione_fallisce": lambda b: b.replace(b'    if args.autotest:\n        return autotest()\n', b'    if args.autotest:\n        return autotest()\n    if args.dst == "fisso" and args.solo_cache and "dukascopy_lavoro" in args.cartella:\n        return 1\n'),
    "py_solo_referto_fresco": lambda b: b.replace(b'    if args.autotest:\n        return autotest()\n', b'    if args.autotest:\n        return autotest()\n    if args.dst == "fisso" and args.solo_cache and "dukascopy_lavoro" in args.cartella:\n        open(os.path.join(args.cartella, "tick", "referto_dukascopy_tick.txt"), "w").write("ESITO   : OK\\nDST: fisso\\n")\n        return 0\n'),
    "py_referto_dst_usa": lambda b: b.replace(b'    if args.autotest:\n        return autotest()\n', b'    if args.autotest:\n        return autotest()\n    if args.dst == "fisso" and args.solo_cache and "dukascopy_lavoro" in args.cartella:\n        open(os.path.join(args.cartella, "tick", "referto_dukascopy_tick.txt"), "w").write("ESITO   : OK\\nDST: usa\\n")\n        return 0\n'),
    "py_nome_uscita_ignorato": lambda b: b.replace(b'nome_out = args.nome_uscita or (bcm + "_DK")', b'nome_out = (bcm + "_DK") if "dukascopy_neg" in args.cartella else (args.nome_uscita or (bcm + "_DK"))'),
    "py_negativo_scrive_in_tick": lambda b: b.replace(b'    if args.copia_cache_giorno:\n        return copia_cache_cmd(args)\n', b'    if args.copia_cache_giorno:\n        if "dukascopy_neg" in args.copia_cache_giorno:\n            open(os.path.join(os.path.dirname(args.copia_cache_giorno), "tick", "U30USD_DK_ticks_2025-03.csv"), "a").write("x")\n        return copia_cache_cmd(args)\n'),
    "py_autotest_rosso": lambda b: b.replace(b'    log("AUTOTEST: TUTTO OK.")\n    return 0', b'    log("AUTOTEST: FALLITO")\n    return 1'),
    "f2_autotest_rosso": lambda b: b.replace(b'    if "--autotest" in argv:\n        return autotest()', b'    if "--autotest" in argv:\n        print("AUTOTEST ROSSO")\n        return 1'),
    "py_senza_referto": lambda b: b.replace(b'    scrivi_atomico(ref_path, testa.getvalue())\n    file_referto.append(ref_path)', b'    if "dukascopy_lavoro" not in args.cartella:\n        scrivi_atomico(ref_path, testa.getvalue())\n    file_referto.append(ref_path)'),
    "py_copia_cache_fallisce": lambda b: b.replace(b'    if args.copia_cache_giorno:\n        return copia_cache_cmd(args)\n', b'    if args.copia_cache_giorno and "dukascopy_neg" in args.copia_cache_giorno:\n        return 3\n    if args.copia_cache_giorno:\n        return copia_cache_cmd(args)\n'),
}


def utf16(s):
    return b"\xff\xfe" + s.encode("utf-16-le")


def giorni():
    d = D0
    while d <= D1:
        if d.weekday() != 5:
            yield d
        d += datetime.timedelta(days=1)


def spec_base(**kw):
    s = dict(macchina="DESKTOP-H4D7CAJ", buchi=[], chr=[{}], mt5_vivo=False, python="real", dischi=[dict(id="C:", size=500 * 2**30, free=250 * 2**30)],
             doppio_dati=False, stato_tick="usa", backup="nessuno", tick_mancante=None, tick_extra=None, files_stale=[], compile_fallisce=False,
             # scenario del simulatore MT5
             scen_dk={g: ["MISURATO", "0.03", "99.0"] for g in GIORNI9}, scen_neg={"2025.03.12": ["MISURATO", "0.09", "95.0"]}, righe_grezze={}, non_scrive=[],
             # manomissioni dei file serviti al pin
             muta_py=None, muta_f2=None, muta_imp=None, muta_mq5=None, sha_sbagliato=None,
             pin=PIN, args_extra="", solo_controllo=False, senza_cache_raw=False, copia_corrotta=False)
    s.update(kw)
    return s


def costruisci(base, spec):
    c = os.path.join(base, "cdrive")
    shutil.rmtree(c, ignore_errors=True)
    user = os.path.join(c, "Users", "Master")
    os.makedirs(os.path.join(user, "Desktop"))
    lavoro = os.path.join(user, "dukascopy_lavoro")
    os.makedirs(lavoro)
    # --- cache sintetica col layout VERO
    if not spec["senza_cache_raw"]:
        for k, d in enumerate(giorni()):
            for h in range(24):
                dt = datetime.datetime(d.year, d.month, d.day, h, tzinfo=datetime.timezone.utc)
                dd, f_ok, f_no = DT.percorso_cache(os.path.join(lavoro, "raw"), "USA30IDXUSD", dt)
                os.makedirs(dd, exist_ok=True)
                if h in (10, 11):
                    b = 3290000 + 10 * k + h
                    rec = b"".join(DT.RECORD.pack(ms, a, bb, 1.0, 1.0) for (ms, a, bb) in ((250, b + 100, b), (59000, b + 200, b + 120)))
                    import lzma
                    open(f_ok, "wb").write(lzma.compress(rec, format=lzma.FORMAT_ALONE))
                else:
                    open(f_no, "wb").close()
        for (g, h) in spec["buchi"]:
            y, mth, dd_ = (int(x) for x in g.split("."))
            dt = datetime.datetime(y, mth, dd_, h, tzinfo=datetime.timezone.utc)
            _, f_ok, f_no = DT.percorso_cache(os.path.join(lavoro, "raw"), "USA30IDXUSD", dt)
            for p in (f_ok, f_no):
                if os.path.exists(p):
                    os.remove(p)
        # --- i CSV "del 03/09": prodotti dal tool vero con --dst usa (stato "fisso" = gia' riconvertiti)
        dst = "usa" if spec["stato_tick"] == "usa" else "fisso"
        r = subprocess.run([sys.executable, os.path.join(DUK, "dukascopy_tick.py"), "--simboli", "USA30IDXUSD", "--da", "2024-10-01", "--a", "2025-06-16", "--dst", dst,
                            "--solo-cache", "--senza-raccolta", "--cartella", lavoro], capture_output=True, text=True)
        tick = os.path.join(lavoro, "tick")
        if spec["stato_tick"] == "senza_referto":
            os.remove(os.path.join(tick, "referto_dukascopy_tick.txt"))
        if spec["tick_mancante"]:
            os.remove(os.path.join(tick, "U30USD_DK_ticks_%s.csv" % spec["tick_mancante"]))
        if spec["tick_extra"]:
            open(os.path.join(tick, spec["tick_extra"]), "w").write("Time,Msec,Bid,Ask\n")
        if spec["backup"] != "nessuno":
            bk = os.path.join(lavoro, "tick_0309_backup")
            os.makedirs(bk)
            man = []
            for n in sorted(os.listdir(tick)):
                if n.endswith(".csv") or n == "referto_dukascopy_tick.txt":
                    shutil.copy(os.path.join(tick, n), bk)
                    man.append("%s  %s" % (hashlib.sha256(open(os.path.join(tick, n), "rb").read()).hexdigest().upper(), n))
            if spec["backup"] != "senza_manifest":
                open(os.path.join(bk, "MANIFEST_SHA256.txt"), "w").write("\n".join(man) + "\n")
            if spec["backup"] == "alterato":
                with open(os.path.join(bk, "U30USD_DK_ticks_2025-01.csv"), "a") as f:
                    f.write("2025.01.31 23:59:59,999,1.0,2.0\n")
    # --- terminale + cartella dati
    tdir = os.path.join(c, "Program Files", "BCM Markets MT5 Terminal")
    os.makedirs(tdir)
    open(os.path.join(tdir, "terminal64.exe"), "wb").write(b"x")
    me = os.path.join(tdir, "metaeditor64.exe")
    open(me, "w").write("#!/usr/bin/env python3\nimport sys, shutil\n"
                        "f = [a[len('/compile:'):] for a in sys.argv[1:] if a.startswith('/compile:')][0]\n"
                        + ("sys.exit(1)\n" if spec["compile_fallisce"] else
                           "t = open(f, 'rb').read()\nsys.exit(1) if b'IMP-TICK-v1-GIORNI' not in t else None\nshutil.copy(f, f[:-4] + '.ex5')\n"))
    os.chmod(me, 0o755)
    ap = os.path.join(user, "AppData", "Roaming", "MetaQuotes", "Terminal")
    dati = os.path.join(ap, "ABC123")
    for sub in ("Scripts", "Presets", "Files", "Logs", os.path.join("Profiles", "Charts", "Default")):
        os.makedirs(os.path.join(dati, "MQL5", sub))
    open(os.path.join(dati, "origin.txt"), "wb").write(utf16(TERM))
    if spec["doppio_dati"]:
        os.makedirs(os.path.join(ap, "DDD444", "MQL5", "Profiles", "Charts", "Default"))     # con un grafico senza EA: la guardia A non si ferma "per caso" sul secondo
        open(os.path.join(ap, "DDD444", "MQL5", "Profiles", "Charts", "Default", "chart01.chr"), "wb").write(utf16("<chart>\nsymbol=U30USD\n</chart>\n"))
        open(os.path.join(ap, "DDD444", "origin.txt"), "wb").write(utf16(TERM))
    os.makedirs(os.path.join(ap, "ZZZ999", "MQL5"))
    open(os.path.join(ap, "ZZZ999", "origin.txt"), "wb").write(utf16("C:\\MT5_MANUALE"))
    cd = os.path.join(dati, "MQL5", "Profiles", "Charts", "Default")
    for i, ch in enumerate(spec["chr"]):
        p = os.path.join(cd, "chart%02d.chr" % (i + 1))
        if ch.get("illeggibile"):
            os.symlink("/nonexistent/x.chr", p)
        elif ch.get("ea"):
            open(p, "wb").write(utf16("<chart>\nsymbol=U30USD\n<window>\n<expert>\nname=%s\n</expert>\n</window>\n</chart>\n" % ch["ea"]))
        else:
            open(p, "wb").write(utf16("<chart>\nsymbol=U30USD\n</chart>\n"))
    # l'alias dello Store FUNZIONANTE (percorso con \WindowsApps\, dentro il finto C:): se la riga non lo filtra per percorso, gira; il banco prova il FILTRO, non il fallimento a valle
    sd = os.path.join(user, "AppData", "Local", "Microsoft", "WindowsApps")
    os.makedirs(sd)
    open(os.path.join(sd, "python.exe"), "w").write('#!/bin/sh\nexec python3 "$@"\n'); os.chmod(os.path.join(sd, "python.exe"), 0o755)
    for n in spec["files_stale"]:
        open(os.path.join(dati, "MQL5", "Files", n), "w").write("Time,Msec,Bid,Ask\n")
    return c


def snapshot(c, escludi=("Users/Master/Desktop", "Users/Master/abtg_duka_p1", "Users/Master/dukascopy_lavoro", "Users/Master/AppData/Roaming/MetaQuotes/Terminal/ABC123/MQL5", "Windows")):
    out = {}
    for rd, dirs, files in os.walk(c):
        rel = os.path.relpath(rd, c).replace(os.sep, "/")
        if any(rel == e or rel.startswith(e + "/") for e in escludi):
            continue
        for f in files:
            p = os.path.join(rd, f)
            out[os.path.join(rel, f)] = ("link" if os.path.islink(p) else hashlib.sha256(open(p, "rb").read()).hexdigest())
    return out


def tree_hash(path, filtro=None):
    out = {}
    for rd, dirs, files in os.walk(path):
        for f in files:
            if filtro and not filtro(f):
                continue
            p = os.path.join(rd, f)
            out[os.path.relpath(p, path)] = hashlib.sha256(open(p, "rb").read()).hexdigest()
    return out


class Srv:
    """serve /<pin>/<percorso> con i file del repo (working tree), mutati se richiesto; l'URL di GitHub raw nei .ps1 diventa quello locale"""
    def __init__(self, spec):
        self.hits = []
        self.base = None
        self.files = {}
        s = self
        class H(http.server.BaseHTTPRequestHandler):
            def do_GET(self):
                s.hits.append(self.path)
                p = self.path.split("/", 2)
                corpo = s.files.get(p[2]) if len(p) == 3 and p[1] == spec["pin"] else None
                if corpo is None:
                    self.send_response(404); self.send_header("Content-Length", "0"); self.end_headers(); return
                self.send_response(200); self.send_header("Content-Length", str(len(corpo))); self.end_headers(); self.wfile.write(corpo)
            def log_message(self, *a): pass
        self.srv = http.server.ThreadingHTTPServer(("127.0.0.1", 0), H)
        self.porta = self.srv.server_address[1]
        self.base = "http://127.0.0.1:%d/" % self.porta
        threading.Thread(target=self.srv.serve_forever, daemon=True).start()
        def leggi(rel):
            return open(os.path.join(REPO, rel), "rb").read()
        def muta(rel, f):
            if isinstance(f, str):
                f = MUTAZIONI_FILE[f]
            b = leggi(rel)
            if rel.endswith(".ps1"):
                b = b.replace(RAW.encode(), self.base.encode())
            return f(b) if f else b
        self.files[FILE_PY] = muta(FILE_PY, spec["muta_py"])
        self.files[FILE_F2] = muta(FILE_F2, spec["muta_f2"])
        def patch_selettore(b):
            # UNICA differenza dal testo vero della figlia: nel banco $cand.DirectoryName e' il percorso Linux del finto C:, e origin.txt dice C:\Program Files\...:
            # si forza $instDir al percorso Windows (il selettore e' invariato dal v1 gia' girato il 03/09). Dichiarato NON COPERTO.
            marker = b"  $instDir    = $cand.DirectoryName"
            assert marker in b, "selettore della figlia cambiato: aggiorna il banco"
            b = b.replace(marker, marker + b"\n  $instDir = 'C:\\Program Files\\BCM Markets MT5 Terminal'")
            f = spec["muta_imp"]
            return (MUTAZIONI_FILE[f] if isinstance(f, str) else f)(b) if f else b
        self.files[FILE_IMP] = muta(FILE_IMP, patch_selettore)
        self.files[FILE_MQ5] = muta(FILE_MQ5, spec["muta_mq5"])
    def sha(self, rel):
        return hashlib.sha256(self.files[rel]).hexdigest().upper()
    def chiudi(self):
        self.srv.shutdown(); self.srv.server_close()


SETUP = r'''
New-PSDrive -Name C -PSProvider FileSystem -Root $env:CDRIVE | Out-Null
function Get-CimInstance { [CmdletBinding()] param([Parameter(Position=0)][string]$ClassName, [string]$Filter)
  foreach($d in @($env:DISCHI_JSON | ConvertFrom-Json)){ [pscustomobject]@{ DeviceID=$d.id; Size=[double]$d.size; FreeSpace=[double]$d.free } } }
function Get-Command { [CmdletBinding()] param([Parameter(Position=0)][string[]]$Name)
  if($Name -contains "python.exe"){
    if($env:PYSCEN -eq "real"){ [pscustomobject]@{ Name="python.exe"; Source=$env:PY_SHIM } }
    if($env:PYSCEN -eq "store"){ [pscustomobject]@{ Name="python.exe"; Source=$env:PY_STORE_SHIM } } } }
function Copy-Item { [CmdletBinding()] param([string]$LiteralPath, [string]$Destination, [switch]$Force)
  Microsoft.PowerShell.Management\Copy-Item -LiteralPath $LiteralPath -Destination $Destination -Force:$Force
  if($env:COPY_CORROTTA -eq "1" -and $Destination -like "*tick_0309_backup*" -and $LiteralPath -like "*2025-01.csv"){ Add-Content -LiteralPath $Destination -Value "x" } }
function Start-Sleep { [CmdletBinding()] param([int]$Seconds, [int]$Milliseconds) }
function Start-Process { [CmdletBinding()] param([string]$FilePath, [string[]]$ArgumentList)
  $env:SIM_ARGS = ($ArgumentList -join " ")
  & python3 $env:SIM_SCRIPT | Out-Host }
'''


def esegui(spec, c, riga, argv_ps, srv, scen_dir, timeout=900, extra_env=None, iex=False):
    """riga = file .ps1 gia' con URL locale; argv_ps = stringa di argomenti PowerShell dopo il file."""
    env = dict(os.environ)
    shim = os.path.join(scen_dir, "python.exe")
    open(shim, "w").write('#!/bin/sh\nexec python3 "$@"\n'); os.chmod(shim, 0o755)
    scen = os.path.join(scen_dir, "scen.json")
    json.dump(dict(simboli={"U30USD_DK": spec["scen_dk"], "U30USD_DKNEG": spec["scen_neg"]}, righe_grezze=spec["righe_grezze"], non_scrive=spec["non_scrive"]), open(scen, "w"))
    tmp = os.path.join(scen_dir, "tmp"); os.makedirs(tmp, exist_ok=True)
    env.update(COMPUTERNAME=spec["macchina"], USERNAME="Master", USERPROFILE="C:\\Users\\Master", APPDATA="C:\\Users\\Master\\AppData\\Roaming", TEMP=tmp, TMP=tmp,
               SystemRoot="C:\\Windows", CDRIVE=c, DISCHI_JSON=json.dumps(spec["dischi"]), PYSCEN=spec["python"], PY_SHIM=shim, PY_STORE_SHIM="C:\\Users\\Master\\AppData\\Local\\Microsoft\\WindowsApps\\python.exe",
               SIM_DATA=os.path.join(c, "Users", "Master", "AppData", "Roaming", "MetaQuotes", "Terminal", "ABC123"), SIM_SCEN=scen, SIM_LOG=os.path.join(scen_dir, "simlog"),
               SIM_SCRIPT=os.path.join(QD, "sim_mt5.py"))
    if spec.get("copia_corrotta"):
        env["COPY_CORROTTA"] = "1"
    if extra_env:
        env.update(extra_env)
    bindir = os.path.join(scen_dir, "bin"); os.makedirs(bindir, exist_ok=True)
    pid = None
    if spec["mt5_vivo"]:
        shutil.copy(shutil.which("sleep"), os.path.join(bindir, "terminal64"))
        pid = subprocess.Popen([os.path.join(bindir, "terminal64"), "300"])
        time_sleep = __import__("time").sleep; time_sleep(0.3)
    if iex:     # il bootstrap e' una RIGA da incollare: Invoke-Expression sul testo, come fa Claudio
        cmd = SETUP + "\n$ErrorActionPreference='Stop'; $t = Get-Content -Raw -LiteralPath '" + riga + "'; Invoke-Expression $t; 'FINE-HARNESS rc=' + $LASTEXITCODE\n"
    else:
        cmd = SETUP + "\n$ErrorActionPreference='Stop'; & '" + riga + "' " + argv_ps + "; 'FINE-HARNESS rc=' + $LASTEXITCODE\n"
    try:
        p = subprocess.run(["pwsh", "-NoProfile", "-Command", cmd], env=env, capture_output=True, text=True, timeout=timeout)
    finally:
        if pid:
            pid.kill(); pid.wait()
    return p
