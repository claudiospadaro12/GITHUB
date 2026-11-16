# Controlla uno o piu script PowerShell: segnala le variabili che differiscono SOLO per maiuscole/minuscole
# (in PowerShell $W e $w sono la stessa variabile: classe di errore gia vista con $C/$c e $W/$w).
# Uso: python3 controlla_collisioni_ps1.py file1.ps1 file2.ps1 ...
import re,sys
for f in sys.argv[1:]:
    s=open(f,encoding='utf-8-sig',errors='ignore').read()
    s=re.sub(r"'[^'\n]*'","''",s)
    s='\n'.join(l for l in s.split('\n') if not l.lstrip().startswith('#'))
    by={}
    for n in set(re.findall(r'\$([A-Za-z_][A-Za-z0-9_]*)',s)): by.setdefault(n.lower(),set()).add(n)
    bad={k:sorted(v) for k,v in by.items() if len(v)>1}
    print(f,'-> collisioni:',bad if bad else 'nessuna')
