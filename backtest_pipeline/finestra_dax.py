#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
MARCATORE_FINESTRA_DAX_v1

LA RIPARAZIONE DELLA CONVENZIONE ORARIA DEL DAX -- richiesta di Claudio,
10/09/2026: "RIPARA LA CONVENZIONE ORARIA DEL DAX 2024-2026".

=====================================================================
 IL FATTO, MISURATO (DIAGNOSI_DAX_20260910_SOGLIA41)
=====================================================================
  anni 2010-2018  finestra 02:00-15:00   14 ore   dens 58,1-59,6   SANI
  anni 2019,2024,2025,2026  finestra 00:00-23:00  22-24 ore  dens 45,4-47,6

 Non e' uno SPOSTAMENTO: e' una COPERTURA piu' larga. Dal 2019 il feed
 copre quasi 24 ore invece delle ~14 della sola seduta. La densita' piu'
 bassa e' l'effetto aritmetico di dividere per piu' ore, non un buco.

=====================================================================
 L'ATTESA, SCRITTA PRIMA DI VEDERE I NUMERI (regola di casa)
=====================================================================
 Se l'orologio del feed e' LO STESSO e cambia solo la copertura, allora
 restringendo gli anni 2019/2024/2025/2026 alla finestra 02:00-15:00 la
 loro densita' deve SALIRE fino alla banda dei sani.

   PREVISIONE:  densita' ristretta dei RIPARABILI  ->  fra 55,0 e 62,0
                (i sani stanno fra 58,1 e 59,6)

   - dentro la banda  -> l'orologio e' lo stesso: la riparazione e' un
     TAGLIO, si dichiara la finestra e quegli anni diventano usabili;
   - sotto la banda   -> dentro la seduta ci sono buchi veri: NON e'
     solo copertura, e la riparazione non basta;
   - sopra 62         -> impossibile per costruzione (max 60 barre/ora):
     se succede, c'e' un difetto in QUESTO script, non nei dati.

 SCRIVERE L'ATTESA PRIMA SERVE A QUESTO: se esce 47 invece di 58, non
 posso raccontarla come "comunque interessante". E' una smentita.

=====================================================================
 COSA FA E COSA NON FA
=====================================================================
  FA:   legge gli ZIP HistData gia' in cache, conta le barre per ORA e
        per GIORNO, e stampa densita' TOCCATA e densita' RISTRETTA.
  NON FA: non scarica niente, non scrive nessun CSV di dati, non tocca
        MT5, non converte, non importa. E' una MISURA.

 Densita' = barre / (giorni con dati x ore toccate). E' la stessa
 formula del referto di diagnosi -- verificata sui suoi numeri:
 2018 -> 213273 / (257 x 14) = 59,3, che e' esattamente cio' che stampa.

 USO:
   python finestra_dax.py --autotest
   python finestra_dax.py --cache "C:\\Users\\Administrator\\histdata_m1" --simbolo grxeur
"""
import argparse, os, re, sys, zipfile
from collections import defaultdict

MARCATORE = "MARCATORE_FINESTRA_DAX_v1"
BANDA_SANI = (55.0, 62.0)
FINESTRA_SANI = (2, 15)          # ore incluse, come le stampa il referto
ANNI_SANI = list(range(2010, 2019))

def leggi_zip(percorso, simbolo):
    """Torna [(anno, mese, giorno, ora)] delle barre del simbolo chiesto.
    Non fa nessun controllo OHLC: qui si misura la COPERTURA, non la
    qualita' dei prezzi (quella l'ha gia' fatta la diagnosi)."""
    fuori = []
    with zipfile.ZipFile(percorso) as z:
        for n in z.namelist():
            if not n.lower().endswith(".csv"):
                continue
            base = os.path.basename(n).upper()
            m = re.search(r"DAT_ASCII_([A-Z]{6})_M1_", base)
            pair = m.group(1).lower() if m else ""
            if simbolo and pair and pair != simbolo.lower():
                continue
            testo = z.read(n).decode("ascii", "ignore")
            for riga in testo.splitlines():
                riga = riga.strip()
                if len(riga) < 15 or not riga[0:8].isdigit():
                    continue
                try:
                    aa = int(riga[0:4]); mm = int(riga[4:6])
                    gg = int(riga[6:8]); oo = int(riga[9:11])
                except ValueError:
                    continue
                if not (1 <= mm <= 12 and 1 <= gg <= 31 and 0 <= oo <= 23):
                    continue
                fuori.append((aa, mm, gg, oo))
    return fuori

def misura(cartella, simbolo):
    per_anno_ora = defaultdict(lambda: defaultdict(int))
    per_anno_giorni = defaultdict(set)
    per_anno_giorni_r = defaultdict(set)
    zips = sorted([f for f in os.listdir(cartella) if f.lower().endswith(".zip")])
    if not zips:
        return None, 0
    for nz in zips:
        try:
            barre = leggi_zip(os.path.join(cartella, nz), simbolo)
        except Exception as e:
            print("  ZIP NON LETTO (%s): %s" % (nz, e))
            continue
        for (aa, mm, gg, oo) in barre:
            per_anno_ora[aa][oo] += 1
            per_anno_giorni[aa].add((mm, gg))
            if FINESTRA_SANI[0] <= oo <= FINESTRA_SANI[1]:
                per_anno_giorni_r[aa].add((mm, gg))
    return (per_anno_ora, per_anno_giorni, per_anno_giorni_r), len(zips)

def densita(barre, giorni, ore):
    if giorni <= 0 or ore <= 0:
        return None
    return float(barre) / (float(giorni) * float(ore))

def stampa(dati):
    per_ora, per_giorni, per_giorni_r = dati
    o0, o1 = FINESTRA_SANI
    ore_r = o1 - o0 + 1
    print("")
    print("anno   barre    giorni  finestra     ore  dens      |  barre 02-15  giorni  dens RISTRETTA  classe")
    print("-" * 108)
    esiti = {}
    for aa in sorted(per_ora.keys()):
        ore = per_ora[aa]
        tot = sum(ore.values())
        gg = len(per_giorni[aa])
        tocc = sorted([h for h, c in ore.items() if c > 0])
        if not tocc:
            continue
        n_tocc = tocc[-1] - tocc[0] + 1
        d_tot = densita(tot, gg, n_tocc)
        tot_r = sum(c for h, c in ore.items() if o0 <= h <= o1)
        gg_r = len(per_giorni_r[aa])
        d_r = densita(tot_r, gg_r, ore_r)
        classe = "SANO" if aa in ANNI_SANI else "da riparare"
        esiti[aa] = d_r
        print("%-6d %-8d %-7d %02d:00-%02d:00  %-4d %-9s |  %-11d %-7d %-15s %s" % (
            aa, tot, gg, tocc[0], tocc[-1], n_tocc,
            ("%.1f" % d_tot) if d_tot else "n/d",
            tot_r, gg_r, ("%.1f" % d_r) if d_r else "n/d", classe))
    return esiti

def verdetto(esiti):
    lo, hi = BANDA_SANI
    da_rip = {a: d for a, d in esiti.items() if a not in ANNI_SANI and d is not None}
    sani = [d for a, d in esiti.items() if a in ANNI_SANI and d is not None]
    print("")
    print("=" * 70)
    print(" VERDETTO -- contro l'attesa scritta PRIMA: banda %.1f - %.1f" % (lo, hi))
    print("=" * 70)
    if sani:
        print("  controllo positivo (anni SANI, densita' ristretta): %.1f - %.1f"
              % (min(sani), max(sani)))
        if min(sani) < lo or max(sani) > hi:
            print("  !! I SANI NON CADONO NELLA LORO BANDA: il difetto e' in questo")
            print("     script o nella formula, NON nei dati. Fermarsi qui.")
            return 2
    if not da_rip:
        print("  nessun anno da riparare trovato in cache: NON CONCLUSIVO.")
        return 2
    dentro = [a for a, d in da_rip.items() if lo <= d <= hi]
    sotto = [a for a, d in da_rip.items() if d < lo]
    sopra = [a for a, d in da_rip.items() if d > hi]
    for a in sorted(da_rip):
        print("  %d -> %.1f   %s" % (a, da_rip[a],
              "DENTRO la banda" if a in dentro else ("SOTTO la banda" if a in sotto else "SOPRA la banda")))
    print("")
    if sopra:
        print("  ESITO: DIFETTO DELLO SCRIPT. Sopra 60 barre/ora e' impossibile.")
        return 2
    if not sotto:
        print("  ESITO: CONFERMATA. L'orologio e' LO STESSO e cambia solo la")
        print("         copertura: la riparazione e' un TAGLIO alla finestra")
        print("         %02d:00-%02d:00, e quegli anni diventano usabili" % FINESTRA_SANI)
        print("         DICHIARANDO la finestra. Serve una firma nuova.")
        return 0
    print("  ESITO: SMENTITA (o parziale). Gli anni %s restano sotto la banda:"
          % ", ".join(str(a) for a in sorted(sotto)))
    print("         dentro la seduta ci sono buchi VERI, non solo copertura")
    print("         piu' larga. Il taglio NON basta. Non si dichiara riparato.")
    return 1

def autotest():
    import tempfile, io as _io
    print(MARCATORE)
    print("=== AUTOTEST (offline, nessuno zip vero) ===")
    ok = 0; ko = 0
    def esito(nome, cond):
        nonlocal ok, ko
        if cond: ok += 1; print("  [ok ] " + nome)
        else:    ko += 1; print("  [KO ] " + nome)

    # 1. la formula della densita' riproduce il numero del referto
    esito("densita': 2018 -> 213273 / (257 x 14) = 59,3 come nel referto",
          abs(densita(213273, 257, 14) - 59.3) < 0.05)
    # 2. e quella dei riparabili
    esito("densita': 2024 -> 332439 / (300 x 24) = 46,2 come nel referto",
          abs(densita(332439, 300, 24) - 46.2) < 0.05)
    # 3. zip sintetico: un anno 'sano' (solo 02-15) e uno '24h'
    cart = tempfile.mkdtemp(prefix="finestra_dax_")
    def scrivi(nome, anno, ore_range, giorni, per_ora):
        righe = []
        for g in range(1, giorni + 1):
            for h in ore_range:
                for mnt in range(per_ora):
                    righe.append("%04d%02d%02d %02d%02d00;100.0;100.0;100.0;100.0;0"
                                 % (anno, 1, g, h, mnt))
        buf = _io.BytesIO()
        with zipfile.ZipFile(buf, "w") as z:
            z.writestr("DAT_ASCII_GRXEUR_M1_%d.csv" % anno, "\n".join(righe))
        open(os.path.join(cart, nome), "wb").write(buf.getvalue())
    scrivi("a2011.zip", 2011, range(2, 16), 10, 59)     # sano, 59 barre/ora
    scrivi("a2024.zip", 2024, range(0, 24), 10, 59)     # 24h ma stessa densita' oraria
    dati, nz = misura(cart, "grxeur")
    esiti = stampa(dati)
    esito("legge i due zip sintetici", nz == 2 and 2011 in esiti and 2024 in esiti)
    esito("il 2011 sintetico cade nella banda dei sani", 55.0 <= esiti[2011] <= 62.0)
    esito("il 2024 sintetico, RISTRETTO, torna nella banda (e' un taglio)",
          55.0 <= esiti[2024] <= 62.0)
    # 4. un anno con buchi VERI dentro la seduta deve restare SOTTO
    scrivi("a2025.zip", 2025, range(0, 24), 10, 30)     # meta' barre
    dati, _ = misura(cart, "grxeur")
    esiti2 = stampa(dati)
    esito("un anno con buchi veri dentro la seduta resta SOTTO la banda",
          esiti2[2025] < 55.0)
    esito("e il verdetto lo dichiara SMENTITA (rc 1)", verdetto(esiti2) == 1)
    for f in os.listdir(cart):
        os.remove(os.path.join(cart, f))
    os.rmdir(cart)
    print("")
    print("AUTOTEST: %d/%d OK" % (ok, ok + ko))
    return 0 if ko == 0 else 2

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--cache", default="")
    ap.add_argument("--simbolo", default="grxeur")
    a = ap.parse_args()
    if a.autotest:
        return autotest()
    cart = a.cache or os.path.join(os.path.expanduser("~"), "histdata_m1")
    print(MARCATORE)
    print("cartella cache : %s" % cart)
    print("simbolo        : %s" % a.simbolo)
    print("finestra dei SANI, dichiarata prima: %02d:00-%02d:00 (ora del FILE = New York)"
          % FINESTRA_SANI)
    print("banda attesa per i riparabili, dichiarata prima: %.1f - %.1f" % BANDA_SANI)
    if not os.path.isdir(cart):
        print("")
        print("FERMATI: la cartella cache NON esiste. Non e' un 'zero': e' il posto sbagliato.")
        return 2
    dati, nz = misura(cart, a.simbolo)
    if dati is None:
        print("")
        print("FERMATI: nessuno zip nella cartella. NON CONCLUSIVO, non 'niente dati'.")
        return 2
    print("zip esaminati  : %d" % nz)
    esiti = stampa(dati)
    return verdetto(esiti)

if __name__ == "__main__":
    sys.exit(main())
