#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
statico.py -- controllo STATICO su RIGA_OMBRA_INSTALL.ps1 (complementa la batteria, che prova solo i rami eseguiti). Tolti commenti e stringhe, nel codice NON devono comparire
cmdlet/eseguibili che cancellano, spostano, copiano, lanciano, chiudono, compilano, riavviano. Le sole scritture ammesse:
  - Set-Content con bersaglio $RefTxt o $PriTxt (referto e numeri di partenza sul Desktop);
  - Compress-Archive con bersaglio $Zip;
  - [IO.File]::Open(...) SOLO su $destNative con FileMode CreateNew (mai Create/Open/Truncate: non puo' sovrascrivere);
  - [IO.File]::Delete(...) SOLO su $destNative, SOLO nella riga che contiene $Creato (si toglie solo cio' che questa corsa ha creato).
Download: una sola chiamata DownloadData. Niente `exit`, niente `param(`, niente Invoke-Expression.
Uso: python3 statico.py [--autotest] [file]   -> ultima riga "STATICO: OK" o "STATICO: n problemi"
"""
import os, re, sys
QD = os.path.dirname(os.path.abspath(__file__))
args = [a for a in sys.argv[1:] if not a.startswith("--")]
F = args[0] if args else os.path.join(QD, "..", "righe", "RIGA_OMBRA_INSTALL.ps1")
VIETATI = ["Remove-Item", "Stop-Process", "Start-Process", "Invoke-WebRequest", "Invoke-RestMethod", "Invoke-Expression", "Invoke-Command", "Invoke-Item", "Copy-Item", "Move-Item", "Rename-Item",
           "New-Item", "Out-File", "Add-Content", "Clear-Content", "Set-ItemProperty", "New-ItemProperty", "Remove-ItemProperty", "Expand-Archive", "Register-ScheduledTask",
           "Unregister-ScheduledTask", "Set-ExecutionPolicy", "taskkill", "iwr", "irm", "iex", "kill", "WriteAllText", "WriteAllBytes", "AppendAllText", "DownloadFile", "DownloadString",
           "Stop-Service", "Start-Service", "Restart-Service", "Restart-Computer", "Stop-Computer", "Set-Variable -Scope Global", "ProcessStartInfo", "CloseMainWindow", "schtasks", "sc.exe",
           "metaeditor64", "terminal64.exe", "MoveTo", "CopyTo", "Truncate", "OpenOrCreate", "FileMode]::Create(?!New)", "FileMode]::Append"]
# nel codice (non nelle stringhe) i nomi di processo 'terminal64' / 'metaeditor64' compaiono solo come argomento di Get-Process -Name; qui si vietano le forme ESEGUIBILI
VIETATI_NOMI_ESEGUIBILI = ["metaeditor64", "terminal64.exe"]


def codice(t):
    righe = []
    for l in t.splitlines():
        if l.lstrip().startswith("#"):
            continue
        l = re.sub(r"'(?:[^']|'')*'", "''", l)
        l = re.sub(r'"(?:[^"`]|`.)*"', '""', l)
        l = re.sub(r"\s#.*$", "", l)
        righe.append(l)
    return righe


def _problemi_riga(l, grezza):
    prob = []
    for v in VIETATI:
        if v in ("metaeditor64", "terminal64.exe"):
            continue            # solo dentro stringhe/argomenti di Get-Process: le stringhe sono gia' tolte, quindi se compaiono qui sono codice
        pat = (r"(?<![\w-])" + v + r"(?![\w-])") if "(?!" in v else (r"(?<![\w-])" + re.escape(v) + r"(?![\w-])")
        if re.search(pat, l, re.I):
            prob.append(v)
    for v in VIETATI_NOMI_ESEGUIBILI:
        if re.search(r"(?<![\w-])" + re.escape(v) + r"(?![\w-])", l, re.I) and not re.search(r"Get-Process\s+-Name\s+" + re.escape(v), l, re.I):
            prob.append(v + " (come codice, fuori da Get-Process -Name)")
    if re.search(r"(?<![\w-])Set-Content(?![\w-])", l, re.I) and not re.search(r"\$RefTxt|\$PriTxt", l):
        prob.append("Set-Content con bersaglio diverso da $RefTxt/$PriTxt")
    if re.search(r"(?<![\w-])Compress-Archive(?![\w-])", l, re.I) and not re.search(r"\$Zip", l):
        prob.append("Compress-Archive con bersaglio diverso da $Zip")
    if re.search(r"\[IO\.File\]::Open\(", l, re.I) and not (re.search(r"\$destNative\s*,\s*\[IO\.FileMode\]::CreateNew", l) or re.search(r"\$path\s*,\s*\[IO\.FileMode\]::Open\s*,\s*\[IO\.FileAccess\]::Read", l)):
        prob.append("[IO.File]::Open fuori da (a) $destNative+CreateNew (b) lettura condivisa di $path")
    if re.search(r"\[IO\.File\]::Delete\(", l, re.I) and not (re.search(r"\$destNative", l) and re.search(r"\$Creato", l)):
        prob.append("[IO.File]::Delete fuori da $destNative nella riga che guarda $Creato")
    if re.search(r"(?<![\w-])exit(?![\w-])", l, re.I):
        prob.append("exit")
    if re.search(r"^\s*param\s*\(", l, re.I):
        prob.append("param")
    return prob


def autotest():
    """il controllo statico DEVE vedere il male: righe cattive e righe buone (stringhe e commenti non contano)"""
    cattive = ["Remove-Item -LiteralPath $x", "Set-Content -LiteralPath (Join-Path $Cart 'x') -Value 1", "if($a){ exit 0 }", "Copy-Item $a $b", "$x = 5; iex $y",
               "$fs = [IO.File]::Open($destNative, [IO.FileMode]::Create, [IO.FileAccess]::Write, [IO.FileShare]::None)", "[IO.File]::Delete($p)",
               "[IO.File]::Delete($destNative)", "Start-Process terminal64", "[IO.File]::WriteAllBytes($destNative, $b)", "New-Item -ItemType Directory -Path $x",
               "Stop-Process -Name terminal64", "& metaeditor64 /compile:x", "$fs = [IO.File]::Open($x, [IO.FileMode]::OpenOrCreate)", "Compress-Archive -Path $a -DestinationPath $Desk"]
    buone = ["# Remove-Item e exit nei commenti", "Dico 'non usa Remove-Item ne exit ne python'", "Set-Content -LiteralPath $RefTxt -Value 1",
             "Compress-Archive -LiteralPath $RefTxt, $PriTxt -DestinationPath $Zip -Force",
             "$fs = [IO.File]::Open($destNative, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)",
             "if($Creato -and -not $Installato){ try{ [IO.File]::Delete($destNative); $Rimosso = $true }catch{ $Rimosso = $false } }",
             "$fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)",
             "$procs = @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)", "$me = @(Get-Process -Name metaeditor64 -ErrorAction SilentlyContinue)"]
    ko = 0
    for c in cattive:
        if not _problemi_riga(codice(c)[0] if codice(c) else "", c):
            print("  X l'autotest non vede: " + c); ko += 1
    for c in buone:
        cod = codice(c)
        if cod and _problemi_riga(cod[0], c):
            print("  X l'autotest vede un falso: " + c + "  -> " + str(_problemi_riga(cod[0], c))); ko += 1
    print("AUTOTEST STATICO: " + ("OK" if ko == 0 else "%d errori" % ko))
    return ko


def main():
    if "--autotest" in sys.argv:
        return autotest()
    t = open(F, encoding="ascii").read()
    prob = []
    for i, l in enumerate(codice(t), 1):
        for p in _problemi_riga(l, l):
            prob.append("r.%d: %s: %s" % (i, p, l.strip()[:100]))
    # esattamente UNA Open con CreateNew, UNA Delete, UNA DownloadData
    cod = "\n".join(codice(t))
    for nome, pat, n in (("CreateNew", r"FileMode\]::CreateNew", 1), ("Delete(", r"\[IO\.File\]::Delete\(", 1), ("DownloadData", r"\.DownloadData\(", 1)):
        k = len(re.findall(pat, cod))
        if k != n:
            prob.append("attesa %d occorrenza di %s nel codice, trovate %d" % (n, nome, k))
    for p in prob:
        print("  X " + p)
    print("STATICO: " + ("OK" if not prob else "%d problemi" % len(prob)))
    return 0 if not prob else 1


if __name__ == "__main__":
    sys.exit(main())
