#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
statico.py -- controllo STATICO di sola lettura su RIGA_DUKA_P0_CENSIMENTO.ps1 (complementa lo snapshot dinamico della batteria, che prova solo i rami eseguiti).
Tolti commenti e stringhe, nel codice NON devono comparire cmdlet/eseguibili che cancellano, spostano, copiano, scaricano o lanciano; le sole scritture ammesse
(Set-Content, New-Item, Compress-Archive) devono avere come bersaglio $Cart o $Zip (la cartella DUKA_P0_* e il suo zip sul Desktop). Niente `exit`, niente `param(`.
Uso: python3 statico.py [file]   -> ultima riga "STATICO: OK" o "STATICO: n problemi"
"""
import os, re, sys
QD = os.path.dirname(os.path.abspath(__file__))
F = [a for a in sys.argv[1:] if not a.startswith("--")][0] if [a for a in sys.argv[1:] if not a.startswith("--")] else os.path.join(QD, "..", "righe", "RIGA_DUKA_P0_CENSIMENTO.ps1")
VIETATI = ["Remove-Item", "Stop-Process", "Start-Process", "Invoke-WebRequest", "Invoke-RestMethod", "Invoke-Expression", "Copy-Item", "Move-Item", "Rename-Item", "Out-File", "Add-Content",
           "Clear-Content", "Set-ItemProperty", "New-ItemProperty", "Remove-ItemProperty", "Expand-Archive", "Register-ScheduledTask", "Unregister-ScheduledTask", "Set-ExecutionPolicy",
           "taskkill", "iwr", "irm", "iex", "kill", "WriteAllText", "WriteAllBytes", "AppendAllText", "Delete", "Net.WebClient", "DownloadFile", "DownloadString", "DownloadData",
           "Start-Sleep", "Stop-Service", "Restart-Computer", "Stop-Computer", "Set-Variable -Scope Global"]
SCRIVONO = ["Set-Content", "New-Item", "Compress-Archive"]


def codice(t):
    righe = []
    for l in t.splitlines():
        if l.lstrip().startswith("#"):
            continue
        l = re.sub(r"'(?:[^']|'')*'", "''", l)          # via le stringhe fra apici singoli
        l = re.sub(r'"(?:[^"`]|`.)*"', '""', l)         # e quelle fra doppi apici
        l = re.sub(r"\s#.*$", "", l)
        righe.append(l)
    return righe


def autotest():
    """il controllo statico DEVE vedere il male: tre righe cattive e tre buone (stringhe e commenti non contano)"""
    cattive = ["Remove-Item -LiteralPath $x", "Set-Content -LiteralPath (Join-Path $Lavoro 'x') -Value 1", "if($a){ exit 0 }", "Copy-Item $a $b", "$x = 5; iex $y"]
    buone = ["# Remove-Item e exit nei commenti", "Dico 'non usa Remove-Item ne exit ne python'", "Set-Content -LiteralPath (Join-Path $Cart 'a') -Value 1", "Compress-Archive -Path $a -DestinationPath $Zip -Force"]
    import io
    ko = 0
    for c in cattive:
        if not _problemi(c):
            print("  X l'autotest non vede: " + c); ko += 1
    for c in buone:
        if _problemi(c):
            print("  X l'autotest vede un falso: " + c); ko += 1
    print("AUTOTEST STATICO: " + ("OK" if ko == 0 else "%d errori" % ko))
    return ko


def _problemi(t):
    prob = []
    for i, l in enumerate(codice(t), 1):
        for v in VIETATI:
            if re.search(r"(?<![\w-])" + re.escape(v) + r"(?![\w-])", l, re.I):
                prob.append(v)
        for s in SCRIVONO:
            if re.search(r"(?<![\w-])" + re.escape(s) + r"(?![\w-])", l, re.I) and not re.search(r"\$Cart|\$Zip|\$base", l):
                prob.append(s)
        if re.search(r"(?<![\w-])exit(?![\w-])", l, re.I):
            prob.append("exit")
        if re.search(r"^\s*param\s*\(", l, re.I):
            prob.append("param")
    return prob


def main():
    if "--autotest" in sys.argv:
        return autotest()
    t = open(F, encoding="ascii").read()
    prob = []
    for i, l in enumerate(codice(t), 1):
        for v in VIETATI:
            if re.search(r"(?<![\w-])" + re.escape(v) + r"(?![\w-])", l, re.I):
                prob.append("r.%d: '%s' vietato in una riga di SOLA LETTURA: %s" % (i, v, l.strip()[:100]))
        for s in SCRIVONO:
            if re.search(r"(?<![\w-])" + re.escape(s) + r"(?![\w-])", l, re.I) and not re.search(r"\$Cart|\$Zip|\$base", l):
                prob.append("r.%d: scrittura (%s) con bersaglio diverso da $Cart/$Zip: %s" % (i, s, l.strip()[:100]))
        if re.search(r"(?<![\w-])exit(?![\w-])", l, re.I):
            prob.append("r.%d: exit (chiuderebbe la finestra con Invoke-Expression): %s" % (i, l.strip()[:100]))
        if re.search(r"^\s*param\s*\(", l, re.I):
            prob.append("r.%d: param() (non vale dentro Invoke-Expression)" % i)
    for p in prob:
        print("  X " + p)
    print("STATICO: " + ("OK" if not prob else "%d problemi" % len(prob)))
    return 0 if not prob else 1


if __name__ == "__main__":
    sys.exit(main())
