#!/usr/bin/env python3
"""AUDIT DEI KILL SUI TERMINALI MT5 -- cerca per SEMANTICA, non per forma.

PERCHE' ESISTE (classe 244, 12/09/2026)
---------------------------------------
L'11 e il 12/09 questo repo ha tolto i kill incondizionati del tipo

    Get-Process -Name "terminal64" | Stop-Process -Force

che non sbagliano terminale: li ammazzano TUTTI, conto REALE 10105439
compreso, mentre ha posizioni aperte. Il 10/09 e' successo davvero
(runner_abtg.ps1:139).

Un commit ha poi dichiarato "ZERO kill incondizionati". **Era falso: ne
restavano TRE, due dei quali VIVI.** Il censimento che li aveva persi
cercava la FORMA -- Get-Process e Stop-Process sulla STESSA riga -- mentre
nei tre casi stavano su righe DIVERSE, legati da una variabile:

    $running = Get-Process -Name "terminal64"     <- tutti
    if($running -and $ChiudiMT5){ $running | Stop-Process -Force }

Cercare la forma invece della semantica e' il difetto. Questo strumento
cerca la semantica: per OGNI Stop-Process risale a COSA gli viene pipato
dentro e chiede se quella collezione e' stata FILTRATA per percorso.

E la regola piu' importante e' l'ultima: quando non riesce a decidere,
scrive DA_LEGGERE. **Un audit che tace sui casi difficili fa credere di
averli controllati.**

USO
---
    python3 backtest_pipeline/audit_kill_terminali.py
    python3 backtest_pipeline/audit_kill_terminali.py --autotest

Uscita 0 = nessun kill NUDO. Uscita 1 = ce n'e' almeno uno.
"""
import os, re, sys

RADICE = os.path.dirname(os.path.abspath(__file__))

# una collezione e' "filtrata" se la sua costruzione guarda il PERCORSO del
# processo: e' l'unico modo di dire QUALE terminale, e un cancello testuale
# da solo non lo sa (per questo il runner vieta Stop-Process in corsia ROUND)
SEGNI_FILTRO = [r"\$_\.Path", r"-EsePath", r"Bersagli", r"\.Bersagli"]

def nudo(riga):
    """la riga pipa dentro Stop-Process qualcosa di gia' filtrato?"""
    return not any(re.search(s, riga) for s in SEGNI_FILTRO)

def sorgente(riga):
    """chi viene pipato dentro Stop-Process: una variabile o un Get-Process?"""
    m = re.search(r"(\$[A-Za-z_][A-Za-z0-9_]*)\s*\|\s*Stop-Process", riga)
    if m:
        return ("var", m.group(1))
    if re.search(r"Get-Process[^|]*\|\s*Stop-Process", riga):
        return ("diretto", None)
    m = re.search(r"@\(([^)]*)\)\s*\|\s*Stop-Process", riga)
    if m:
        return ("espressione", m.group(1))
    return ("ignoto", None)

def filtrata_a_monte(righe, i, var):
    """l'ULTIMA assegnazione di var prima della riga i guarda il percorso?

    Torna True/False/None. None vuol dire "non l'ho capito": e va scritto,
    non indovinato.
    """
    pat = re.compile(r"^\s*" + re.escape(var) + r"\s*=(.*)$")
    for j in range(i - 1, -1, -1):
        m = pat.match(righe[j])
        if not m:
            continue
        corpo = m.group(1)
        # l'assegnazione puo' continuare sulla riga dopo
        for k in range(j, min(j + 3, len(righe))):
            corpo += " " + righe[k]
        if any(re.search(s, corpo) for s in SEGNI_FILTRO):
            return True
        if re.search(r"Get-Process", corpo):
            return False          # presa la lista intera, senza filtro
        return None               # assegnata da qualcos'altro: non decido
    return None

def esamina(path):
    esiti = []
    try:
        righe = open(path, encoding="utf-8", errors="replace").read().split("\n")
    except Exception:
        return esiti
    for i, riga in enumerate(righe):
        if "Stop-Process" not in riga:
            continue
        if re.match(r"^\s*#", riga):
            continue                       # commento
        if "Stop-Process -Id" in riga:
            continue                       # un PID preciso: e' il contrario di un kill cieco
        if "@{ p='Stop-Process'" in riga or "-match 'Stop-Process'" in riga or "txt=" in riga:
            continue                       # divieti e casi di prova del runner: devono restare
        if not nudo(riga):
            esiti.append(("FILTRATO", i + 1, riga.strip()))
            continue
        tipo, var = sorgente(riga)
        if tipo == "diretto":
            esiti.append(("NUDO", i + 1, riga.strip()))
        elif tipo == "var":
            f = filtrata_a_monte(righe, i, var)
            if f is True:
                esiti.append(("FILTRATO", i + 1, riga.strip()))
            elif f is False:
                esiti.append(("NUDO", i + 1, riga.strip()))
            else:
                esiti.append(("DA_LEGGERE", i + 1, riga.strip()))
        else:
            esiti.append(("DA_LEGGERE", i + 1, riga.strip()))
    return esiti

def autotest():
    """CONTRO-ESEMPIO: casi costruiti apposta, compresi quelli che DEVONO
    risultare NUDI. Un autotest coi soli casi buoni non prova niente."""
    casi = [
        # (testo, esito atteso della PRIMA riga con Stop-Process)
        ('Get-Process -Name "terminal64" | Stop-Process -Force', "NUDO"),
        ('$r = Get-Process -Name "terminal64"\n$r | Stop-Process -Force', "NUDO"),
        ('$r = Get-Process -Name "terminal64"\nif($r){ $r | Stop-Process -Force }', "NUDO"),
        ('Get-Process metatester64,terminal64 | Stop-Process -Force', "NUDO"),
        ('Get-Process terminal64 | Where-Object { $_.Path -like "C:\\X\\*" } | Stop-Process -Force', "FILTRATO"),
        ('$b = @($t | Where-Object { $_.Path -and ($_.Path -like ($d + "\\*")) })\n$b | Stop-Process -Force', "FILTRATO"),
        ('$b = Bersagli $tutti\n$b | Stop-Process -Force', "FILTRATO"),
        ('$r = @($sel.Bersagli)\n$r | Stop-Process -Force', "FILTRATO"),
        ('$x = QualcosAltro\n$x | Stop-Process -Force', "DA_LEGGERE"),
    ]
    import tempfile
    giusti = 0
    for n, (txt, atteso) in enumerate(casi, 1):
        with tempfile.NamedTemporaryFile("w", suffix=".ps1", delete=False, encoding="utf-8") as f:
            f.write(txt); p = f.name
        e = esamina(p)
        os.unlink(p)
        ott = e[0][0] if e else "NIENTE"
        ok = (ott == atteso)
        giusti += ok
        print(("  OK  " if ok else "  X   ") + "caso %d: atteso %-10s ottenuto %-10s | %s"
              % (n, atteso, ott, txt.replace("\n", " ; ")[:62]))
    print("\nAUTOTEST: %d giusti su %d" % (giusti, len(casi)))
    return 0 if giusti == len(casi) else 1

def main():
    if "--autotest" in sys.argv:
        return autotest()
    tot = {"NUDO": [], "FILTRATO": [], "DA_LEGGERE": []}
    nfile = 0
    for base, dirs, files in os.walk(RADICE):
        if ".git" in base:
            continue
        for nome in files:
            if not nome.endswith(".ps1"):
                continue
            nfile += 1
            p = os.path.join(base, nome)
            for stato, riga, testo in esamina(p):
                tot[stato].append((os.path.relpath(p, RADICE), riga, testo))
    print("=" * 70)
    print("  AUDIT DEI KILL SUI TERMINALI -- per SEMANTICA, non per forma")
    print("  file .ps1 esaminati: %d" % nfile)
    print("=" * 70)
    for stato, simbolo in (("NUDO", "X  "), ("DA_LEGGERE", "?  "), ("FILTRATO", "OK ")):
        v = tot[stato]
        print("\n%s (%d):" % (stato, len(v)))
        for f, r, t in v:
            print("  %s%s:%d" % (simbolo, f, r))
            print("        %s" % t[:110])
    print("\n" + "=" * 70)
    if tot["NUDO"]:
        print("ESITO: %d KILL NUDI. Ognuno di questi ammazza OGNI terminale della" % len(tot["NUDO"]))
        print("       macchina, conto REALE 10105439 compreso. NON si consegna.")
        return 1
    if tot["DA_LEGGERE"]:
        print("ESITO: nessun kill nudo, ma %d casi DA LEGGERE A MANO." % len(tot["DA_LEGGERE"]))
        print("       Sono DICHIARATI, non passati in silenzio.")
        return 0
    print("ESITO: nessun kill nudo, e nessun caso ambiguo.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
