#!/usr/bin/env python3
# -*- coding: ascii -*-
# shim di powershell.exe per il banco: la riga RIGA_ROUND_VPS_RETRY.ps1 lancia il driver con
#   Start-Process powershell.exe -ArgumentList -NoProfile -ExecutionPolicy Bypass -File <drv> -Expert ... (stesso testo del PC vero)
# Qui si rilancia lo STESSO .ps1 con pwsh, dentro il preludio del banco (PSDrive C: + Invoke-WebRequest che copia dal repo),
# passando gli argomenti cosi' come sono arrivati. Il codice d'uscita e' quello del driver.
import os, subprocess, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import harness
a = sys.argv[1:]
open(os.environ['HARNESS_LOG'], 'a').write('POWERSHELL ' + ' | '.join(a) + '\n')
i = [x.lower() for x in a].index('-file')
f = a[i + 1]
rest = a[i + 2:]
toks = ' '.join(x if (x.startswith('-') and x[1:].isalnum()) else harness.q(x) for x in rest)
H = os.environ['HARNESS_H']
ps = harness.prelude(H) + '& ' + harness.q(f) + ' ' + toks + '\nexit $LASTEXITCODE\n'
w = os.path.join(H, 'shim_%d.ps1' % os.getpid())
open(w, 'w').write(ps)
r = subprocess.run(['pwsh', '-NoProfile', '-File', w])
sys.exit(r.returncode)
