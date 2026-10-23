#!/usr/bin/env python3
# S4 -- rilettura dei per-trade OOS nei giorni di chiusura. Criteri: report/SONDE_SENZA_MACCHINA_CRITERI_2026-10-23.md (congelati prima).
import csv, sys, os, collections
D = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_prove', 'trades_portafoglio')
NYSE_CHIUSO = {'2025.06.19','2025.07.04','2025.09.01','2025.11.27','2025.12.25','2026.01.01','2026.01.19','2026.02.16','2026.04.03','2026.05.25','2026.06.19'}
NYSE_MEZZA = {'2025.07.03','2025.11.28','2025.12.24'}
XETRA_CHIUSA = {'2025.12.24','2025.12.25','2025.12.26','2025.12.31','2026.01.01','2026.04.03','2026.04.06','2026.05.01'}
EA = [('Dow Apertura 770206','abtg_trades_ABTG_Dow_Apertura_US_U30USD_770206.csv',[('NYSE chiuso',NYSE_CHIUSO),('NYSE mezza',NYSE_MEZZA)]),
      ('ORB 770612','abtg_trades_ABTG_ORB_Ottimizzato_U30USD_770612.csv',[('NYSE chiuso',NYSE_CHIUSO),('NYSE mezza',NYSE_MEZZA)]),
      ('DAX Apertura 770115','abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_770115.csv',[('Xetra chiusa',XETRA_CHIUSA)]),
      ('MaxMin DAX short 770413','abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv',[('Xetra chiusa',XETRA_CHIUSA)])]
def pf(L):
    w=sum(x for x in L if x>0); l=-sum(x for x in L if x<0)
    return (w/l) if l else None
def main():
    for nome,f,liste in EA:
        R=list(csv.DictReader(open(os.path.join(D,f)),delimiter=';'))
        pos=collections.OrderedDict()
        for r in R:
            pos.setdefault(r['position_id'],[]).append((r['close_time'][:10],float(r['net_profit'])))
        P=[(max(d for d,_ in v),sum(x for _,x in v)) for v in pos.values()]   # data dell'ultima uscita, netto della posizione
        tot=len(P); print('== %s: %d posizioni (%d deal), %s -> %s, netto %.0f'%(nome,tot,len(R),min(d for d,_ in P),max(d for d,_ in P),sum(x for _,x in P)))
        giorni=set()
        for et,S in liste:
            hit=[(d,x) for d,x in P if d in S]; giorni|=S
            print('   %-14s: %d posizioni (%.1f%%), netto %.0f  %s'%(et,len(hit),100.0*len(hit)/tot,sum(x for _,x in hit),sorted(d for d,_ in hit)))
        res=[x for d,x in P if d not in giorni]; allv=[x for _,x in P]
        a=pf(allv); b=pf(res)
        n=len([1 for d,_ in P if d in giorni])
        print('   resto: %d posizioni, netto %.0f, PF %s  (tutte: PF %s)  -> %s'%(len(res),sum(res),('%.3f'%b if b else 'n/d'),('%.3f'%a if a else 'n/d'),'MATERIALE (>=3%)' if 100.0*n/tot>=3 else 'non materiale'))
main()
