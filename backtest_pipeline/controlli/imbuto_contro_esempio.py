# -*- coding: ascii -*-
"""IL CONTRO-ESEMPIO: l'imbuto MENTE se esiste un 'return' nella catena
d'ingresso che NON passa da un contatore. Qui si elencano TUTTI i return
delle funzioni della catena e si segnala quelli scoperti."""
import re, sys

CATENA = {
 "ABTG_PTE.mq5":                            ["OnNewBar", "Enter"],
 "ABTG_PTE_Ottimizzato.mq5":                ["OnNewBar", "Enter"],
 "ABTG_SuperWave.mq5":                      ["OnNewBar", "Enter"],
 "ABTG_SuperWave_DOW_H1_Ottimizzato.mq5":   ["OnNewBar", "Enter"],
 "ABTG_SuperWave_DAX_H4_Ottimizzato.mq5":   ["OnNewBar", "Enter"],
 "ABTG_SupertrendReversal.mq5":             ["OnNewBar", "Enter"],
 "ABTG_SupertrendReversal_Ottimizzato.mq5": ["OnNewBar", "Enter"],
 "ABTG_EMA200.mq5":                         ["OnNewBar", "PlaceOrders", "PlaceLimit"],
 "ABTG_EMA200_Ottimizzato.mq5":             ["OnNewBar", "PlaceOrders", "PlaceLimit"],
 "ABTG_CostToCost.mq5":                     ["ValutaSegnale", "TryEnter"],
}
B = "/home/user/GITHUB/mql5/Experts/"

def corpo(t, nome):
    m = re.search(r"^(?:void|bool|double)\s+%s\s*\([^)]*\)\s*\n\s*\{" % nome, t, re.M)
    if not m: return None
    i = t.index("{", m.start())
    lv = 0
    for j in range(i, len(t)):
        if t[j] == "{": lv += 1
        elif t[j] == "}":
            lv -= 1
            if lv == 0: return t[i:j+1]
    return None

scoperti = 0
for f, funs in CATENA.items():
    t = open(B + f).read()
    for fn in funs:
        c = corpo(t, fn)
        if c is None:
            print("!! %s: funzione %s non trovata" % (f, fn)); scoperti += 1; continue
        for k, riga in enumerate(c.split("\n")):
            if not re.search(r"\breturn\b", riga): continue
            contesto = "\n".join(c.split("\n")[max(0, k-3):k+1])
            if re.search(r"c[A-Z][A-Za-z0-9_]*\+\+", contesto): continue
            print("SCOPERTO  %-42s %-14s %s" % (f, fn, riga.strip()))
            scoperti += 1
print("\n== return senza contatore nelle vicinanze: %d ==" % scoperti)
