#!/usr/bin/env python3
# =====================================================================
#  lint_ps1.py  --  controlla i driver PowerShell PRIMA di mandarli
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (06/08/2026):
#  ho mandato a Claudio uno script con dentro "$tag:", che PowerShell
#  legge come nome di disco e rifiuta di eseguire. Errore da niente,
#  ma gli ha bruciato un lancio e del tempo. Qui non c'e' PowerShell
#  per provare gli script, quindi il controllo va fatto a mano - cioe'
#  con questo.
#
#  USO:  python3 backtest_pipeline/lint_ps1.py [file.ps1 ...]
#        senza argomenti controlla tutti i .ps1 di backtest_pipeline/
#
#  Esce con codice 1 se trova qualcosa. Va lanciato PRIMA di ogni push
#  che tocchi un .ps1.
# =====================================================================
import re, sys, glob, os

ERRORI = []

def segnala(f, n, testo, riga):
    ERRORI.append((f, n, testo, riga.rstrip()))

# --- 1) $var: dentro stringhe con doppi apici ------------------------
#  PowerShell legge $tag: come "variabile sul disco tag". Ci vuole ${tag}:
#  Falsi positivi da escludere: $env:, $global:, $script:, $local:,
#  $using:, $private: -- sono scope veri.
SCOPE_VERI = ("env", "global", "script", "local", "using", "private", "variable")
RE_VAR_COLON = re.compile(r'\$([A-Za-z_][A-Za-z0-9_]*):')

# --- 2) "$oggetto.Proprieta" dentro stringhe -------------------------
#  PowerShell espande solo $oggetto e poi lascia ".Proprieta" letterale.
#  Ci vuole "$($oggetto.Proprieta)".
RE_VAR_DOT = re.compile(r'\$([A-Za-z_][A-Za-z0-9_]*)\.([A-Za-z_][A-Za-z0-9_]*)')

def togli_subespressioni(s):
    """Toglie i blocchi $( ... ), anche annidati: dentro quelli la sintassi
    e' codice normale e $j.Nome / $env:X sono scritti bene."""
    out, i, n = [], 0, len(s)
    while i < n:
        if s[i] == '$' and i + 1 < n and s[i+1] == '(':
            liv, i = 0, i + 1
            while i < n:
                if s[i] == '(': liv += 1
                elif s[i] == ')':
                    liv -= 1
                    if liv == 0: i += 1; break
                i += 1
        else:
            out.append(s[i]); i += 1
    return "".join(out)

def stringhe_doppie(riga):
    """Ritorna i pezzi di riga dentro doppi apici, senza le $( ... )."""
    fuori = riga.split('#')[0]          # via i commenti di riga
    return [togli_subespressioni(s) for s in re.findall(r'"([^"]*)"', fuori)]

def controlla(path):
    righe = open(path, encoding="utf-8", errors="replace").read().split("\n")
    # --- 0) caratteri che PowerShell 5.1 scambia per virgolette ---------
    #  08/08/2026: PS 5.1 legge i .ps1 senza BOM come ANSI. I byte UTF-8 di
    #  un em-dash riletti cosi' contengono una VIRGOLETTA tipografica, che
    #  chiude la stringa a meta': ParserError su tutto il file. Successo con
    #  "# CODA DEL WEEKEND [em-dash] stato vivo". PowerShell 7 legge UTF-8 e
    #  NON se ne accorge: il collaudo su pwsh da solo non basta.
    for i, riga in enumerate(righe, 1):
        for ch in "\u2013\u2014\u2018\u2019\u201c\u201d":
            if ch in riga:
                segnala(path, i, "carattere tipografico U+%04X: su PowerShell 5.1 "
                                 "diventa una virgoletta e TRONCA la stringa -> usa ASCII" % ord(ch), riga)
    dentro_here = False
    tag_here = None
    for i, riga in enumerate(righe, 1):

        # --- here-string: apertura @" e chiusura "@ a colonna 0 ------
        if not dentro_here:
            if re.search(r'@"\s*$', riga):
                dentro_here = True; tag_here = i
                continue
            if re.search(r"@'\s*$", riga):
                dentro_here = True; tag_here = i
                continue
        else:
            if riga.startswith('"@') or riga.startswith("'@"):
                dentro_here = False; tag_here = None
            elif riga.strip() in ('"@', "'@"):
                segnala(path, i, "chiusura here-string INDENTATA: PowerShell la ignora, "
                                 "deve stare a colonna 0", riga)
                dentro_here = False; tag_here = None
            continue   # dentro una here-string non si controlla altro

        for s in stringhe_doppie(riga):
            for m in RE_VAR_COLON.finditer(s):
                if m.group(1).lower() not in SCOPE_VERI:
                    segnala(path, i, f'"${m.group(1)}:" letto come nome di disco '
                                     f'-> scrivi "${{{m.group(1)}}}:"', riga)
            for m in RE_VAR_DOT.finditer(s):
                var, prop = m.group(1), m.group(2)
                if var.lower() in SCOPE_VERI: continue
                if prop.lower() in ("ps1","csv","exe","mq5","ex5","ini","txt","set","zip","log"):
                    continue   # e' un'estensione di file, non una proprieta'
                segnala(path, i, f'"${var}.{prop}" non espande la proprieta\' '
                                 f'-> scrivi "$({var}.{prop})"', riga)

    if dentro_here:
        segnala(path, tag_here, "here-string aperta e mai chiusa", "")

    # NIENTE controllo di bilanciamento parentesi: con here-string, regex e
    # apici annidati un conteggio grezzo da' falsi allarmi, e un controllo
    # che grida al lupo e' peggio di nessun controllo.

def main():
    files = sys.argv[1:]
    if not files:
        qui = os.path.dirname(os.path.abspath(__file__))
        files = sorted(glob.glob(os.path.join(qui, "*.ps1")))
    for f in files:
        controlla(f)

    if not ERRORI:
        print(f"OK: {len(files)} file controllati, nessun problema.")
        return 0

    ultimo = None
    for f, n, testo, riga in ERRORI:
        if f != ultimo:
            print(f"\n### {os.path.basename(f)}")
            ultimo = f
        print(f"  riga {n}: {testo}")
        if riga: print(f"    | {riga.strip()[:110]}")
    print(f"\n{len(ERRORI)} problemi in {len({e[0] for e in ERRORI})} file.")
    return 1

if __name__ == "__main__":
    sys.exit(main())
