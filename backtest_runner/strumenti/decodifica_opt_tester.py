"""Decodifica i file .opt (cache dell'ottimizzazione del tester MT5, modalita' tutti i simboli) quando l'XML esportato e' incompleto.
Formato dedotto e verificato sul file IS 2013-2020 (39 simboli): record da 344 byte; rispetto all'offset del Profit Factor (PF):
  PF-184 = indice del passaggio (int32; corrisponde alla posizione del simbolo nell'elenco dell'intestazione), PF-160 = profitto netto,
  PF-16 = DD equity %, PF-8 = payoff atteso, PF+44 = numero di operazioni (int32). Primo record: PF a 3737 byte dall'inizio.
Uso: python3 decodifica_opt_tester.py file.opt"""
import struct,sys,re,subprocess
def decode(f,start=3737):
    b=open(f,'rb').read(); n=len(b)
    out=subprocess.run(['strings','-el',f],capture_output=True,text=True).stdout.split('\n')
    i=next(k for k,s in enumerate(out) if re.fullmatch(r'[A-Za-z0-9_ ]+ H\d',s) or s.endswith(' H4'))
    syms=[s for s in out[i+1:] if re.fullmatch(r'[A-Z0-9]{3,8}',s)]
    recs={}; o=start
    while o+60<n:
        pi=struct.unpack_from('<i',b,o-184)[0]
        if pi in recs or pi<0 or pi>300: break
        recs[pi]=dict(pf=struct.unpack_from('<d',b,o)[0],profit=struct.unpack_from('<d',b,o-160)[0],dd=struct.unpack_from('<d',b,o-16)[0],trades=struct.unpack_from('<i',b,o+44)[0])
        o+=344
    return {syms[k]:v for k,v in recs.items() if k<len(syms)}
if __name__=='__main__':
    for s,v in decode(sys.argv[1]).items(): print('%-8s n=%d PF %.2f profit %.0f DD %.1f'%(s,v['trades'],v['pf'],v['profit'],v['dd']))
