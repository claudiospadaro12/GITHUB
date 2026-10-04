#!/usr/bin/env python3
# -*- coding: ascii -*-
# finto metaeditor64.exe: "/compile:<cartella>\EA.mq5" "/log" -> scrive EA.ex5 accanto al sorgente (compilazione riuscita).
# Con STUB_COMPILA_KO=1 non scrive niente: il driver deve morire PRIMA del terminale (errore di compilazione: mai una riprova).
import os, sys
for a in sys.argv[1:]:
    if a.lower().startswith('/compile:'):
        p = a[9:].strip().strip('"').replace('\\', '/')
        open(os.environ['HARNESS_LOG'], 'a').write('COMPILA %s\n' % os.path.basename(p))
        if os.environ.get('STUB_COMPILA_KO') != '1':
            open(p[:-4] + '.ex5', 'wb').write(b'EX5')
sys.exit(0)
