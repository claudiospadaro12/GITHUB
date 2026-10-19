import sys,re,collections
sys.path.insert(0,'.')
from parse_rep import read,rows,deals
def summary(path):
    R=rows(read(path))
    out={}
    flat=[c for r in R for c in r]
    for i,c in enumerate(flat):
        if c.endswith(':') and i+1<len(flat):
            k=c.rstrip(':')
            if k not in out: out[k]=flat[i+1]
    return out
if __name__=='__main__':
    s=summary(sys.argv[1])
    for k in s:
        if any(w in k for w in ('Profitto','Drawdown','Fattore','Operazioni','Lotto','Vittori','Perdit','Posizioni','Massim','Profit','Trades','Win','Largest','Expected','Aspett','Consec','Sharpe','Recupero','Lots')):
            print(k,'=',s[k][:90])
