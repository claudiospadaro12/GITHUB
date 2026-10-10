#!/usr/bin/env python3
# -*- coding: ascii -*-
# gba_r2u_equivalenze.py -- STRUMENTO DI ANALISI (10/10/2026), BOZZA, NON ancora passato dal cancello (controllo-preventivo).
# Non lancia MT5, non tocca l'EA, non scrive nel repo: compila in una cartella temporanea.
#
# COSA PROVA, sul CODICE VERO dell'EA mql5/Experts/ABTG_GoldBreakoutATR.mq5 (v1.10, SHA256 1381E3DC...): estrae per regex le funzioni pure
# GbaBeArmato, GbaSLProposto, GbaArrotonda, GbaSLMigliore, GbaSLValido, GbaUscitaTempo, GbaAzione, le compila in C++ e le fa girare su 200.000 percorsi
# di 2.900 tick (1 tick = 1 secondo, 60 tick per barra), entrambi i lati, ATR 0,5-10, prezzo 3.000-4.100, tre regimi di deriva (nulla, +0,02 e -0,02 volte
# la volatilita' per tick, nel verso della posizione), seed fisso. Equivalenze che i file prova GBA_R2U_* usano:
#   (1) InpBE_TriggerATR = 99,0  ==  InpUseBreakeven = false          (differenze attese: 0)
#   (2) InpTrail_ATR     = 99,0  ==  InpTrail_ATR = 0 (trailing spento) (differenze attese: 0)
#   (3) InpTimeExitBars  = 0     non chiude MAI a tempo                 (chiusure attese: 0)
# E quattro CONTROLLI CHE DEVONO MORDERE (stessi percorsi): l'uscita a tempo scatta nel default, lo SL si sposta nel default, kTrail 5,0 e' diverso da
# kTrail spento, un BE a 3,0 e' diverso da un BE a 1,0: se uno di questi e' ZERO il test e' cieco e lo strumento esce con 1.
# NON PROVA: il glue (GbaGestisci, CTrade, il tester, i tick reali), il filling, le notizie. Per quello c'e' la prima passata di ogni cella.
# USO: python3 backtest_pipeline/gba_r2u_equivalenze.py          (richiede g++)
import os, re, subprocess, sys, tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'mql5', 'Experts', 'ABTG_GoldBreakoutATR.mq5')
NAMES = ['GbaBeArmato', 'GbaSLProposto', 'GbaArrotonda', 'GbaSLMigliore', 'GbaSLValido', 'GbaUscitaTempo', 'GbaAzione']
src = open(SRC, encoding='utf-8', errors='replace').read()

def fn(name):
    m = re.search(r'^(?:bool|int|double)\s+' + name + r'\s*\(', src, re.M)
    if not m:
        sys.exit('funzione %s NON trovata nel sorgente' % name)
    i = src.index('{', m.start()); d = 0; j = i
    while True:
        if src[j] == '{': d += 1
        elif src[j] == '}':
            d -= 1
            if d == 0: break
        j += 1
    return src[m.start():j + 1]

body = '\n'.join(fn(n) for n in NAMES)
DRV = r'''
#include <cstdio>
#define MathRound std::round
#include <cmath>
#include <cstdlib>
#include <random>
#define GBA_AZ_NULLA 0
#define GBA_AZ_SPOSTA 1
#define GBA_AZ_CHIUDI 2
''' + body + r'''
struct Cfg{double kTrail;bool useBE;double beTrig;int maxBarre;};
struct Res{int exitTick;double exitSL;int reason;int moves;double finalSL;};
// reason: 0 nessuna uscita, 1 SL, 2 tempo
Res run(bool isLong,double entry,double atr,const double*bid,int nt,int ticksPerBar,const Cfg&c,double spread,double kSL){
  Res r{-1,0,0,0,0};
  double passo=0.01, minDist=0.0;
  double curSL = isLong? entry-kSL*atr : entry+kSL*atr;
  double estremo = isLong? entry: entry;
  for(int t=0;t<nt;t++){
    double b=bid[t], a=b+spread;
    if(isLong){ if(b>estremo) estremo=b; } else { if(b<estremo) estremo=b; }
    // SL colpito prima della gestione (come il server)
    if(isLong? (b<=curSL):(a>=curSL)){ r.exitTick=t; r.exitSL=curSL; r.reason=1; r.finalSL=curSL; return r; }
    int barre=t/ticksPerBar;
    double nuovo=0;
    int az=GbaAzione(isLong,entry,curSL,b,a,estremo,atr,barre,c.maxBarre,c.kTrail,c.useBE,c.beTrig,0.0,minDist,passo,nuovo);
    if(az==GBA_AZ_CHIUDI){ r.exitTick=t; r.reason=2; r.finalSL=curSL; return r; }
    if(az==GBA_AZ_SPOSTA){ curSL=nuovo; r.moves++; }
  }
  r.finalSL=curSL; return r;
}
bool same(const Res&a,const Res&b){ return a.exitTick==b.exitTick && a.reason==b.reason && a.moves==b.moves && std::fabs(a.finalSL-b.finalSL)<1e-9 && std::fabs(a.exitSL-b.exitSL)<1e-9; }
int main(){
  std::mt19937_64 rng(12345);
  std::normal_distribution<double> nd(0,1);
  long diff1=0,diff2=0,diff4=0,n=0,nclose_t0=0,tempoBase=0,beArmed=0,mut_k5=0,mut_be=0;
  double maxExc=0;
  for(int it=0;it<200000;it++){
    bool isLong=(rng()&1);
    double entry=3000+ (rng()%3000)*0.37; double atr=0.5+ (rng()%1000)/1000.0*9.5;
    int nt=2900; static double bid[2900];
    double p=entry; double vol=atr/ std::sqrt(60.0)*(0.5+(rng()%100)/100.0*1.5);
    // deriva opzionale per provocare armamento BE e corse lunghe
    double mu = (it%3==0)? 0.0 : ((it%3==1)? 0.02:-0.02)*vol*(isLong?1:-1);
    for(int t=0;t<nt;t++){ p+=mu+vol*nd(rng); bid[t]=std::round(p*100)/100.0; }
    double spread=0.21;
    Cfg base{2.5,true,1.0,48*60}; // 1 barra = 60 tick-passi (1 minuto), 48 barre
    // (1) BE spento via useBE=false  vs trigger 99
    Cfg a=base; a.useBE=false; Cfg b=base; b.beTrig=99.0;
    Res ra=run(isLong,entry,atr,bid,nt,60,a,spread,2.5), rb=run(isLong,entry,atr,bid,nt,60,b,spread,2.5);
    // il tempo: maxBarre in barre (48), qui passo barre=t/60 quindi maxBarre=48
    a.maxBarre=48; b.maxBarre=48; base.maxBarre=48;
    ra=run(isLong,entry,atr,bid,nt,60,a,spread,2.5); rb=run(isLong,entry,atr,bid,nt,60,b,spread,2.5);
    if(!same(ra,rb)) diff1++;
    // (2) trail spento via kTrail=0 vs kTrail=99 (BE acceso, trigger 1.0)
    Cfg c0=base; c0.kTrail=0.0; Cfg c99=base; c99.kTrail=99.0;
    Res r0=run(isLong,entry,atr,bid,nt,60,c0,spread,2.5), r99=run(isLong,entry,atr,bid,nt,60,c99,spread,2.5);
    if(!same(r0,r99)) diff2++;
    { Res rb0=run(isLong,entry,atr,bid,nt,60,base,spread,2.5); if(rb0.reason==2) tempoBase++; if(rb0.moves>0) beArmed++; Cfg k5=base; k5.kTrail=5.0; Res rk=run(isLong,entry,atr,bid,nt,60,k5,spread,2.5); if(!same(rk,r0)) mut_k5++; Cfg be5=base; be5.beTrig=3.0; Res rbe=run(isLong,entry,atr,bid,nt,60,be5,spread,2.5); if(!same(rbe,rb0)) mut_be++; }
    // (3) tempo spento (maxBarre=0) non chiude mai per tempo
    Cfg t0=base; t0.maxBarre=0; Res rt=run(isLong,entry,atr,bid,nt,60,t0,spread,2.5);
    if(rt.reason==2) nclose_t0++;
    // (4) trail spento + BE spento + tempo spento: solo SL iniziale
    n++;
  }
  printf("n=%ld  diff(BE trig99 vs useBE=false)=%ld  diff(kTrail99 vs kTrail0)=%ld  chiusure a tempo con maxBarre=0: %ld | CONTROLLI CHE DEVONO MORDERE: percorsi con uscita a tempo nel default=%ld, con SL spostato=%ld, kTrail5 diverso da kTrail0=%ld, BEtrig3 diverso da BEtrig1=%ld\n",n,diff1,diff2,nclose_t0,tempoBase,beArmed,mut_k5,mut_be);
  return 0;
}
'''

d = tempfile.mkdtemp(prefix='gba_r2u_eq_')
cpp = os.path.join(d, 'eq.cpp'); exe = os.path.join(d, 'eq')
open(cpp, 'w').write(DRV)
r = subprocess.run(['g++', '-O2', '-std=c++17', '-Wall', '-Wno-unused-variable', '-o', exe, cpp], capture_output=True, text=True)
if r.returncode != 0:
    sys.exit('compilazione C++ fallita:\n' + r.stderr)
out = subprocess.run([exe], capture_output=True, text=True).stdout.strip()
print(out)
m = re.search(r'diff\(BE trig99 vs useBE=false\)=(\d+)\s+diff\(kTrail99 vs kTrail0\)=(\d+)\s+chiusure a tempo con maxBarre=0: (\d+) \| .*?default=(\d+), con SL spostato=(\d+), kTrail5 diverso da kTrail0=(\d+), BEtrig3 diverso da BEtrig1=(\d+)', out)
if not m:
    sys.exit('uscita del C++ non riconosciuta')
d1, d2, c0, tb, ba, k5, b3 = [int(x) for x in m.groups()]
ok = (d1 == 0 and d2 == 0 and c0 == 0 and tb > 0 and ba > 0 and k5 > 0 and b3 > 0)
print('EQUIVALENZE: BE99==spento %s | kTrail99==spento %s | tempo 0 mai a tempo %s | controlli che mordono %s' % (
    'OK' if d1 == 0 else 'FAIL', 'OK' if d2 == 0 else 'FAIL', 'OK' if c0 == 0 else 'FAIL', 'OK' if min(tb, ba, k5, b3) > 0 else 'CIECHI'))
sys.exit(0 if ok else 1)
