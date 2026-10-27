import sys, glob, bisect, datetime, itertools, statistics
sys.path.insert(0, 'lavoro_wt/backtest_pipeline')
import leggi_equita_prop as E
import leggi_giorni_dd_prop as G
A = 'lavoro_wt/backtest_pipeline/risultati_archivio/DEEP5K_PERSONALE_20261026/'
ks, bars = E.carica_m1(glob.glob('exp/in/ABTG_M1_XAUUSD.csv'))
n = len(ks)
giorno = []
for k in ks:
    dt = E.EPOCA + datetime.timedelta(minutes=k)
    if G.cest(dt): dt += datetime.timedelta(hours=1)
    giorno.append(dt.date())
DEP = 5000.0; MARG = 8580.0   # EUR di margine per 1 lotto nel tester BCM (R114, derivato)
def serie(path):
    D = E.affari_p(path)
    pos, nonacc, esatto = E.accoppia(D)
    sr = E.fx_serie(pos); med = statistics.median([f for _, f in sr]) if sr else 0.9
    fc = [0.0]*n; fp = [0.0]*n; lot = [0.0]*n
    for (mi, mo, s, v, pi, po, prof) in pos:
        i0 = bisect.bisect_left(ks, mi); i1 = bisect.bisect_left(ks, mo)
        if i0 >= n or i1 <= 0: continue
        i1 = min(i1, n); k_ = v*E.CONTRATTO*E.fx_a(sr, mo, med)
        for i in range(i0, i1):
            o,h,lo,c = bars[i]; fc[i] += s*(c-pi)*k_; fp[i] += s*((lo if s>0 else h)-pi)*k_; lot[i] += v
    delta = [0.0]*(n+1)
    for x in D:
        i = bisect.bisect_left(ks, x['m']); delta[min(i, n)] += x['net']
    sal = []; c = 0.0
    for i in range(n): c += delta[i]; sal.append(c)
    return sal, fc, fp, lot, len(pos)
NOMI = {'GoldSnap':'DEEP5K_GOLDSNAP','Umbra':'DEEP5K_UMBRAVAULTAIEA','SomaGold':'DEEP5K_SOMAGOLD','Microedge':'DEEP5K_MICROEDGENEURALMATRIXEA'}
S = {}
for k, d in NOMI.items():
    f = glob.glob(A + d + '/report/*.htm.gz')[0]; S[k] = serie(f); print(k, 'posizioni', S[k][4])
i0 = next(i for i in range(n) if giorno[i] >= datetime.date(2025,1,3)); i1 = n
def valuta(nomi, pess=False):
    sal=[0.0]*n; fl=[0.0]*n; lot=[0.0]*n
    for k in nomi:
        s,fc,fp,lt,_ = S[k]; f = fp if pess else fc
        for i in range(i0,i1): sal[i]+=s[i]; fl[i]+=f[i]; lot[i]+=lt[i]
    eq=[DEP+sal[i]+fl[i] for i in range(n)]
    pk=eq[i0]; mdd=0; mdd_eur=0; mineq=min(eq[i0:i1]); mlev=1e9; t100=t50=0; maxlot=max(lot[i0:i1]); maxlot_i=lot.index(maxlot)
    for i in range(i0,i1):
        pk=max(pk,eq[i]); d=(pk-eq[i])/pk*100; mdd=max(mdd,d); mdd_eur=max(mdd_eur,pk-eq[i])
        if lot[i]>0:
            lv=eq[i]/(lot[i]*MARG)*100; mlev=min(mlev,lv); t100+= lv<100; t50+= lv<50
    worst=0; wd=None; g5=0
    i=i0
    while i<i1:
        j=i; g=giorno[i]
        while j<i1 and giorno[j]==g: j+=1
        base=DEP+sal[i-1]; mn=min(eq[t] for t in range(i,j)); loss=(base-mn)/base*100
        if loss>worst: worst,wd=loss,g
        g5+= loss>=5; i=j
    return dict(net=sal[i1-1], mdd=mdd, mdd_eur=mdd_eur, mineq=mineq, worst=worst, wd=wd, g5=g5, maxlot=maxlot, maxlot_t=(E.EPOCA+datetime.timedelta(minutes=ks[maxlot_i])).strftime('%Y-%m-%d'), mlev=mlev, t100=t100, t50=t50)
def riga(nomi):
    for pess in (False, True):
        r=valuta(nomi,pess)
        print('%-40s %s netto %+7.0f DD equity max %5.1f%% (%5.0f EUR) equity minima %6.0f peggior giorno %5.1f%% (%s) gg>=5%% %d | max lotti insieme %.2f (%s) livello di margine minimo %.0f%%, minuti sotto 100%%: %d, sotto 50%%: %d' % ('+'.join(nomi), 'PESS' if pess else 'CENTR', r['net'], r['mdd'], r['mdd_eur'], r['mineq'], r['worst'], r['wd'], r['g5'], r['maxlot'], r['maxlot_t'], r['mlev'], r['t100'], r['t50']))
for k in NOMI: riga([k])
riga(list(NOMI))
riga(['GoldSnap','Umbra'])
riga(['Umbra','Microedge'])
riga(['GoldSnap','Umbra','Microedge'])

print('=== FASE INIZIALE (primi 90 giorni dal 03/01/2025): conto da 3.500 con lotti di 5.000 (B) e lotti scalati 0,7 (A) ===')
j1 = next(i for i in range(n) if giorno[i] >= datetime.date(2025,4,3))
def iniziale(nomi, start, scala):
    sal=[0.0]*n; fl=[0.0]*n; lot=[0.0]*n
    for k in nomi:
        s,fc,fp,lt,_ = S[k]
        for i in range(i0,j1): sal[i]+=s[i]*scala; fl[i]+=fp[i]*scala; lot[i]+=lt[i]*scala
    eq=[start+sal[i]+fl[i] for i in range(n)]
    pk=eq[i0]; mdd=0; mdd_e=0; mlev=1e9; t100=t50=0; mineq=min(eq[i0:j1]); maxlot=max(lot[i0:j1])
    for i in range(i0,j1):
        pk=max(pk,eq[i]); mdd=max(mdd,(pk-eq[i])/pk*100); mdd_e=max(mdd_e,pk-eq[i])
        if lot[i]>0:
            lv=eq[i]/(lot[i]*MARG)*100; mlev=min(mlev,lv); t100+= lv<100; t50+= lv<50
    return mineq, mdd, mdd_e, mlev, t100, t50, maxlot, sal[j1-1]
for nomi in (['GoldSnap'],['Umbra'],['SomaGold'],['Microedge'],list(NOMI)):
    for lab,start,scala in (('A scalato 0,7',3500.0,0.7),('B lotti 5K su 3.500',3500.0,1.0)):
        r=iniziale(nomi,start,scala)
        print('%-36s %-22s equity minima %6.0f  DD max %5.1f%% (%5.0f EUR)  margine minimo %5.0f%%  minuti <100%%: %d  <50%%: %d  max lotti insieme %.2f  netto a 90 gg %+.0f' % ('+'.join(nomi), lab, r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7]))
