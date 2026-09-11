# -*- coding: ascii -*-
"""IL CONTRO-ESEMPIO IN FUNZIONE: si simula la cascata dell'imbuto in due
versioni, una CORRETTA e una con un ramo NON contato (il difetto che
volevamo poter scoprire). La riga di quadratura deve dire OK nella prima
e ROTTA nella seconda: se dicesse OK in tutte e due, non misurerebbe nulla."""
import random
random.seed(7)

def giro(bugiardo):
    c = {k: 0 for k in ["val","occ","spread","nodoji","lato","lotto","entrate"]}
    for _ in range(20000):
        c["val"] += 1
        if random.random() < 0.35: c["occ"] += 1; continue
        if random.random() < 0.05: c["spread"] += 1; continue
        if random.random() < 0.80: c["nodoji"] += 1; continue
        if random.random() < 0.30:
            # IL DIFETTO: qui il codice bugiardo fa 'continue' SENZA contare
            if not bugiardo: c["lato"] += 1
            continue
        if random.random() < 0.10: c["lotto"] += 1; continue
        c["entrate"] += 1
    somma = sum(v for k, v in c.items() if k != "val")
    return c, somma

for bugiardo in (False, True):
    c, somma = giro(bugiardo)
    stato = "OK" if somma == c["val"] else "ROTTA: somma %d contro valutate %d" % (somma, c["val"])
    print("%-22s valutate %d | occupata %d | spread %d | niente doji %d | lato spento %d | lotto %d | ENTRATE %d | quadratura %s"
          % ("versione BUGIARDA" if bugiardo else "versione CORRETTA",
             c["val"], c["occ"], c["spread"], c["nodoji"], c["lato"], c["lotto"], c["entrate"], stato))
