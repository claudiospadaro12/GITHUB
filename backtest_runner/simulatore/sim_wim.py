#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sim_wim.py - simulatore Python di Template_EA_Wim v1.04 (oro D1, ordini stop, pendenti persistenti, filtro fake breakout).
Binario C (criteri: report/CLAU12_SIMULATORE_PYTHON_CRITERI_2026-11-18.md). STRUMENTO DI SCARTO: MT5 resta il giudice.
Regole del tester MT5 ricavate dal riferimento (RIEPILOGO_CONTROLLO_DISEGNO3): 4 tick per barra M1 ai secondi :00/:20/:40/:59
(rialzista O-L-H-C, ribassista O-H-L-C); ingressi stop e uscite SL/TP al PREZZO dell'ordine; OCO nello stesso tick; scadenza arrotondata
alla mezzanotte; swap a ogni mezzanotte server (1 unita, 3 il mercoledi, 0 sabato/domenica).
Uso:  python3 sim_wim.py --xau ABTG_M1_XAUUSD_2018.csv --eur ABTG_M1_EURUSD_2018.csv [--da 2019.01.01 --a 2019.04.01]
"""
import argparse, bisect, csv, math, sys
from datetime import datetime, timezone

DAY = 86400

def epoch(s):                      # 'YYYY.MM.DD HH:MM' (ora server) -> secondi (trattata come UTC: solo aritmetica)
    return int(datetime(int(s[0:4]), int(s[5:7]), int(s[8:10]), int(s[11:13]), int(s[14:16]), tzinfo=timezone.utc).timestamp())

def fmt(t):
    return datetime.fromtimestamp(t, timezone.utc).strftime('%Y.%m.%d %H:%M:%S')

def carica_m1(path):
    T, O, H, L, C, S = [], [], [], [], [], []
    with open(path, encoding='utf-8-sig') as f:
        rd = csv.reader(f, delimiter=';')
        for r in rd:
            if len(r) < 7 or not r[0][:1].isdigit():
                continue
            T.append(epoch(r[0])); O.append(float(r[1])); H.append(float(r[2])); L.append(float(r[3])); C.append(float(r[4])); S.append(int(float(r[6])))
    return dict(t=T, o=O, h=H, l=L, c=C, s=S)

class Par:                         # parametri (default = disegno 3, riga 2)
    point = 0.01; digits = 2; lot = 0.1; contract = 100.0
    sl_pct = 0.35; tp_pct = 2.1; countback = 10; fbf = 1; exp_days = 6
    offset_atr = 0.10; mindist_atr = 0.20; atr_period = 14
    stops_level_pts = 0          # PARAMETRO da verificare
    chiuso_fino_min = 65         # mercato chiuso (rifiuto 10018) dalle 00:00 alle 01:05 server
    tick_sec = (0, 20, 40, 59)
    comm_deal_eur = -0.08
    swap_long_eur = -5.11        # EUR per unita per 0,1 lotto  (STIMATO dal riferimento di fase 1, poi CONGELATO)
    swap_short_eur = -0.37
    max_trades_day = 1
    gap_fill = False             # False: riempimenti e uscite SEMPRE al livello dell'ordine, anche con gap (verificato su R1 e R5, fase 2)
    lvl_sec = 86400; entry = 'stop'; sl_mode = 'pct'; tp_mode = 'pct'; sl_pts = 0; tp_pts = 0; sl_atr = 1.0; tp_rr = 1.0
    rearm = False; exp_bars = None   # fase 3: modalita dei disegni 1 e 2 (livelli D1/H4, ordini limit, SL/TP in punti e ATR/RR, riarmo)
    eventi_in_chiusura = False   # False: nessun riempimento/SL/TP nella finestra di chiusura (ipotesi 1, da verificare col riferimento)

def costruisci_d1(m1, sec=DAY):
    giorni = {}
    for i, t in enumerate(m1['t']):
        k = t // sec
        g = giorni.get(k)
        if g is None:
            giorni[k] = [m1['o'][i], m1['h'][i], m1['l'][i], m1['c'][i]]
        else:
            g[1] = max(g[1], m1['h'][i]); g[2] = min(g[2], m1['l'][i]); g[3] = m1['c'][i]
    ks = sorted(giorni)
    d = dict(k=ks, o=[giorni[k][0] for k in ks], h=[giorni[k][1] for k in ks], l=[giorni[k][2] for k in ks], c=[giorni[k][3] for k in ks])
    tr = []
    for i in range(len(ks)):
        r = d['h'][i] - d['l'][i]
        if i > 0:
            r = max(r, abs(d['h'][i] - d['c'][i - 1]), abs(d['l'][i] - d['c'][i - 1]))
        tr.append(r)
    d['tr'] = tr
    return d

def atr_sma(d, i, n):              # ATR MT5 = media semplice del True Range delle n barre che finiscono in i
    if i < n: return 0.0
    return sum(d['tr'][i - n + 1:i + 1]) / n

def chiusure_tf(m1, sec):          # chiusura (bid) dell'ultimo M1 di ogni periodo di 'sec' secondi
    out = {}
    for t, c in zip(m1['t'], m1['c']):
        out[t // sec] = c
    return out

def prossima_mezzanotte(ts):
    return ts if ts % DAY == 0 else (ts // DAY + 1) * DAY

def unita_swap(giorno_k):          # giorno_k = giorno appena concluso (numero di giorni dall'epoca)
    wd = (giorno_k + 3) % 7        # 0=lunedi ... 6=domenica (1970-01-01 era giovedi)
    if wd >= 5: return 0
    return 3 if wd == 2 else 1

class Sim:
    def __init__(self, m1, eur, p):
        self.m1, self.p = m1, p
        self.d1 = costruisci_d1(m1, p.lvl_sec)
        self.dk = {k: i for i, k in enumerate(self.d1['k'])}
        self.cl_h1 = chiusure_tf(m1, 3600); self.cl_h4 = chiusure_tf(m1, 14400)
        self.eur_t = eur['t']; self.eur_c = eur['c']
        self.pend = []; self.pos = None
        self.ordini = []; self.deals = []; self.trades = []
        self.bar_corr = None; self.armata = False; self.ult_try = -10**12
        self.saldo = 100000.0; self.ult_giorno_swap = None
        self.n_ordine = 1

    def eurusd(self, t):
        i = bisect.bisect_right(self.eur_t, t) - 1
        return self.eur_c[max(i, 0)] if self.eur_c else 1.0

    # ---------- ordini ----------
    def chiuso(self, t):
        return (t % DAY) < self.p.chiuso_fino_min * 60

    def livelli(self, k_idx):      # massimo/minimo delle ultime countback barre D1 chiuse (shift 1..N)
        N = self.p.countback
        if k_idx - N < 0: return None
        hh = max(self.d1['h'][k_idx - N:k_idx]); ll = min(self.d1['l'][k_idx - N:k_idx])
        return (hh, ll) if hh > ll else None

    def calcola_sltp(self, buy, entry, atr, dm):
        p = self.p
        if p.sl_mode == 'pct': sl_d = p.sl_pct / 100.0 * entry
        elif p.sl_mode == 'pts': sl_d = p.sl_pts * p.point
        else: sl_d = p.sl_atr * atr
        minimo = max(dm * 1.5, 0.3 * atr)
        sl_d = max(sl_d, minimo)
        if p.tp_mode == 'pct': tp_d = p.tp_pct / 100.0 * entry
        elif p.tp_mode == 'pts': tp_d = p.tp_pts * p.point
        else: tp_d = p.tp_rr * sl_d
        tp_d = max(tp_d, minimo)
        r = lambda x: round(x, p.digits)
        return (r(entry - sl_d), r(entry + tp_d)) if buy else (r(entry + sl_d), r(entry - tp_d))

    def piazza(self, t, buy, prezzo, atr, bid, ask, sp_pts, limit=False):
        p = self.p
        dm = p.stops_level_pts * p.point + sp_pts * p.point
        prezzo = round(prezzo, p.digits)
        if not limit:
            if buy and prezzo < ask + dm: return 0
            if (not buy) and prezzo > bid - dm: return 0
        else:
            if buy and prezzo > ask - dm: return 0
            if (not buy) and prezzo < bid + dm: return 0
        ref = ask if buy else bid
        if abs(prezzo - ref) < p.mindist_atr * atr: return 0
        sl, tp = self.calcola_sltp(buy, prezzo, atr, dm)
        if self.chiuso(t): return -1
        scad = prossima_mezzanotte(t + (p.exp_days * DAY if p.exp_bars is None else p.exp_bars * p.lvl_sec))
        o = dict(id=self.n_ordine, t=t, buy=buy, limit=limit, prezzo=prezzo, sl=sl, tp=tp, scad=scad, stato='attivo', t_fine=None)
        self.n_ordine += 1
        self.pend.append(o); self.ordini.append(o)
        return 1

    def cancella_pendenti(self, t, motivo='canceled'):
        for o in self.pend:
            o['stato'] = motivo; o['t_fine'] = t
        self.pend = []

    # ---------- posizione ----------
    def apri(self, t, o, prezzo_fill):
        p = self.p
        self.pos = dict(buy=o['buy'], t=t, prezzo=prezzo_fill, sl=o['sl'], tp=o['tp'], fbf_ok=False, ordine=o['id'], swap=0.0)
        o['stato'] = 'filled'; o['t_fine'] = t
        self.pend.remove(o)
        self.deals.append(dict(t=t, dir='in', buy=o['buy'], prezzo=prezzo_fill, comm=p.comm_deal_eur, swap=0.0, profit=0.0, motivo='TPL_WIM'))
        self.saldo += p.comm_deal_eur

    def chiudi(self, t, prezzo, motivo):
        p = self.p; pos = self.pos
        pnl_usd = ((prezzo - pos['prezzo']) if pos['buy'] else (pos['prezzo'] - prezzo)) * p.contract * p.lot
        pnl_eur = pnl_usd / self.eurusd(t)
        self.deals.append(dict(t=t, dir='out', buy=not pos['buy'], prezzo=prezzo, comm=p.comm_deal_eur, swap=pos['swap'], profit=pnl_eur, motivo=motivo))
        self.trades.append(dict(t_in=pos['t'], t_out=t, buy=pos['buy'], p_in=pos['prezzo'], p_out=prezzo, motivo=motivo, profit=pnl_eur, swap=pos['swap'], comm=2 * p.comm_deal_eur))
        self.saldo += pnl_eur + p.comm_deal_eur + pos['swap']
        self.pos = None

    # ---------- un tick ----------
    def tick(self, t, bid, ask, sp_pts, nuova_barra_d1, apertura=False):
        p = self.p
        # swap a ogni mezzanotte attraversata con posizione aperta
        if self.pos is not None:
            kg = t // DAY
            if self.ult_giorno_swap is None: self.ult_giorno_swap = max(kg, self.pos['t'] // DAY)
            while self.ult_giorno_swap < kg:
                u = unita_swap(self.ult_giorno_swap)      # notte del giorno appena concluso
                self.pos['swap'] += u * (p.swap_long_eur if self.pos['buy'] else p.swap_short_eur) * (p.lot / 0.1)
                self.ult_giorno_swap += 1
        else:
            self.ult_giorno_swap = None
        # scadenze (lato server)
        for o in list(self.pend):
            if o['scad'] <= t:
                o['stato'] = 'expired'; o['t_fine'] = o['scad']; self.pend.remove(o)
        chiuso = self.chiuso(t) and not p.eventi_in_chiusura
        # riempimenti (lato server)
        if self.pos is None and not chiuso:
            for o in list(self.pend):
                if o['buy']: hit = (ask <= o['prezzo']) if o['limit'] else (ask >= o['prezzo'])
                else: hit = (bid >= o['prezzo']) if o['limit'] else (bid <= o['prezzo'])
                if hit:
                    self.apri(t, o, o['prezzo']); break
        # SL / TP (lato server)
        if self.pos is not None and not chiuso:
            pos = self.pos
            if pos['buy']:
                if bid <= pos['sl']: self.chiudi(t, min(pos['sl'], bid) if (apertura and p.gap_fill) else pos['sl'], 'sl')
                elif bid >= pos['tp']: self.chiudi(t, max(pos['tp'], bid) if (apertura and p.gap_fill) else pos['tp'], 'tp')
            else:
                if ask >= pos['sl']: self.chiudi(t, max(pos['sl'], ask) if (apertura and p.gap_fill) else pos['sl'], 'sl')
                elif ask <= pos['tp']: self.chiudi(t, min(pos['tp'], ask) if (apertura and p.gap_fill) else pos['tp'], 'tp')
        # ---- EA: GestisciPosizioni ----
        if self.pos is not None:
            pos = self.pos
            if p.fbf > 0 and not pos['fbf_ok']:
                sec = 3600 if p.fbf == 1 else 14400
                kin = pos['t'] // sec
                if t // sec > kin:
                    pos['fbf_ok'] = True
                    cl = (self.cl_h1 if p.fbf == 1 else self.cl_h4).get(kin)
                    if cl is not None and ((cl < pos['prezzo']) if pos['buy'] else (cl > pos['prezzo'])):
                        if not self.chiuso(t):                # a mercato chiuso PositionClose e rifiutata e l'EA non riprova (gia segnato)
                            self.chiudi(t, bid if pos['buy'] else ask, 'fbf')
            if self.pos is not None and self.pend:
                self.cancella_pendenti(t)                     # OCO
        # ---- EA: nuova barra e armo ----
        kd = t // p.lvl_sec; kday = t // DAY
        if kd != self.bar_corr:
            self.bar_corr = kd; self.armata = False
        if self.armata: return
        if self.pos is not None: self.armata = True; return
        if (not p.rearm) and self.pend: self.armata = True; return   # InpRearm=false: pendenti persistenti
        if t - self.ult_try < 60: return
        self.ult_try = t
        oggi = sum(1 for d in self.deals if d['dir'] == 'in' and d['t'] // DAY == kday)
        if p.max_trades_day > 0 and oggi >= p.max_trades_day: self.armata = True; return
        idx = self.dk.get(kd)
        if idx is None: return
        atr = atr_sma(self.d1, idx - 1, p.atr_period)
        if atr <= 0: return
        if self.pend:                                         # riarmo: i vecchi pendenti si cancellano solo a mercato aperto
            if self.chiuso(t): return
            self.cancella_pendenti(t)
        lv = self.livelli(idx)
        if lv is None: self.armata = True; return
        hh, ll = lv
        off = p.offset_atr * atr
        if p.entry == 'limit':
            a = self.piazza(t, False, hh - off, atr, bid, ask, sp_pts, True)
            b = self.piazza(t, True, ll + off, atr, bid, ask, sp_pts, True)
        else:
            a = self.piazza(t, True, hh + off, atr, bid, ask, sp_pts)
            b = self.piazza(t, False, ll - off, atr, bid, ask, sp_pts)
        if a == -1 or b == -1: return                         # mercato chiuso: riprova al minuto dopo
        self.armata = True

    # ---------- ciclo ----------
    def esegui(self, t_da, t_a):
        m1, p = self.m1, self.p
        n = len(m1['t'])
        i = 0
        while i < n and m1['t'][i] < t_da: i += 1
        ultimo_giorno = None
        prev_c = m1['c'][i - 1] if i > 0 else m1['o'][i]
        prev_s = m1['s'][i - 1] if i > 0 else m1['s'][i]
        while i < n and m1['t'][i] < t_a:
            t0 = m1['t'][i]; kd = t0 // DAY
            if kd != ultimo_giorno:                           # primo tick del giorno a 00:00:00 (prezzo = ultima chiusura nota)
                ultimo_giorno = kd
                if t0 % DAY != 0:
                    bid = prev_c; ask = prev_c + prev_s * p.point
                    self.tick(kd * DAY, bid, ask, prev_s, True)
            o, h, l, c, s = m1['o'][i], m1['h'][i], m1['l'][i], m1['c'][i], m1['s'][i]
            seq = (o, l, h, c) if c >= o else (o, h, l, c)
            for sec, px in zip(p.tick_sec, seq):
                self.tick(t0 + sec, px, px + s * p.point, s, False, sec == 0)
            prev_c, prev_s = c, s
            i += 1
        # fine test: cancella pendenti residui, la posizione aperta resta (il tester la chiude a fine test: non conteggiata qui)
        t_fine = m1['t'][min(i, n) - 1] + 59 if n else 0
        for o in list(self.pend):
            o['stato'] = 'canceled'; o['t_fine'] = t_fine
        self.pend = []

def serie_giornaliera(sim):
    g = {}
    for d in sim.deals:
        if d['dir'] != 'out': continue
        k = fmt(d['t'])[:10]
        g[k] = g.get(k, 0.0) + d['profit'] + d['comm'] + d['swap']
    return g

def riepilogo(sim, costo=3.6):
    ops = len(sim.trades)
    tot = sum(t['profit'] for t in sim.trades)
    lordo = sum(max(t['profit'], 0) for t in sim.trades); perdite = -sum(min(t['profit'], 0) for t in sim.trades)
    return dict(operazioni=ops, profitto_tester=sum(d['profit'] + d['comm'] + d['swap'] for d in sim.deals),
                PF=(lordo / perdite if perdite > 0 else float('inf')), saldo=sim.saldo)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--xau', required=True); ap.add_argument('--eur', required=True)
    ap.add_argument('--da', default='2019.01.01'); ap.add_argument('--a', default='2019.04.01')
    ap.add_argument('--sl', type=float, default=0.35); ap.add_argument('--tp', type=float, default=2.1)
    ap.add_argument('--cb', type=int, default=10); ap.add_argument('--fbf', type=int, default=1)
    a = ap.parse_args()
    p = Par(); p.sl_pct, p.tp_pct, p.countback, p.fbf = a.sl, a.tp, a.cb, a.fbf
    xau = carica_m1(a.xau); eur = carica_m1(a.eur)
    s = Sim(xau, eur, p)
    s.esegui(epoch(a.da + ' 00:00'), epoch(a.a + ' 00:00'))
    print('ORDINI', len(s.ordini), 'TRADE', len(s.trades))
    for tr in s.trades:
        print(fmt(tr['t_in']), 'buy' if tr['buy'] else 'sell', tr['p_in'], '->', fmt(tr['t_out']), tr['p_out'], tr['motivo'], round(tr['profit'], 2), round(tr['swap'], 2))
    print(riepilogo(s))

if __name__ == '__main__':
    main()
