#!/usr/bin/env python3
"""integrita_aggregatore.py - punto (3): controlli di integrita dell'aggregatore di A4 su JSON manomessi / incoerenti.
Base: scenario CONFERMATO (4 coppie x 12 trade). Per ogni caso: atteso (scritto a mano) vs controlli_integrita_ok di A4 e della mia verifica.
Uso: python3 -I integrita_aggregatore.py"""
import copy, json, os, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import scenari_aggregatore as SA
AI = SA.AI
BASE = SA.SCEN[0]["per"]
V1 = AI.leggi_hash_codice(os.path.join(SA.BB, "congelati/HASH_CODICE.txt"))

def rehash(j): j["sha256_risultati"] = AI.hash_risultati(j)

def casi():
    c = []
    # (nome, funzione di modifica su dict {sym: json}, atteso_ok (integrita), nota)
    c.append(("00 controllo: nessuna modifica", lambda r, F: None, True))
    def m1(r, F): r["EURUSD"]["tabelle"]["LOG_TRADE"]["CONT_H1_2015"][0]["R"] = 5.0
    c.append(("01 R di un trade modificato a mano, hash NON aggiornato", m1, False))
    def m2(r, F): r["GBPUSD"]["sha256_risultati"] = "0" * 64
    c.append(("02 sha256_risultati sostituito a mano", m2, False))
    def m3(r, F): r["EURUSD"]["tabelle"]["LOG_TRADE"]["CONT_H1_2015"][0]["R"] = 5.0; rehash(r["EURUSD"])
    c.append(("03 R modificato E hash ricalcolato (incoerente con T2)", m3, False))
    def m4(r, F): r["USDJPY"]["tabelle"]["LOG_TRADE"]["CONT_H1_2015"].pop(); rehash(r["USDJPY"])
    c.append(("04 un trade tolto dal log, hash ricalcolato (T2 n != log)", m4, False))
    def m5(r, F): r["EURJPY"]["intestazione"]["sha256_codice"]["engine.py"] = "0" * 64; rehash(r["EURJPY"])
    c.append(("05 engine.py diverso da v2 (hash ricalcolato)", m5, False))
    def m6(r, F):
        for s in r:
            r[s]["intestazione"]["sha256_codice"] = dict(V1); rehash(r[s])
    c.append(("06 codice v1 (HASH_CODICE.txt) invece di v2 in tutte le coppie", m6, False))
    def m7(r, F): r["EURUSD"]["intestazione"]["PARAMETRI_NON_CONGELATI_PROVA"] = True; rehash(r["EURUSD"])
    c.append(("07 PARAMETRI_NON_CONGELATI_PROVA = true", m7, False))
    def m8(r, F): r["GBPUSD"]["intestazione"]["hash_dati_coincidono"]["ABTG_M1_GBPUSD_2017.csv"] = False; rehash(r["GBPUSD"])
    c.append(("08 hash dei CSV non coincidono", m8, False))
    c.append(("09 anni sbagliati (2013/2018/2020/2025-26) in tutte le coppie", "ANNI_VECCHI", False))
    def m10(r, F): r["USDJPY"]["tabelle"]["LOG_TRADE"]["CONT_H1_2017"] = r["USDJPY"]["tabelle"]["LOG_TRADE"].pop("CONT_H1_2017"); del r["USDJPY"]["tabelle"]["LOG_TRADE"]["INV_H1_2022"]; rehash(r["USDJPY"])
    c.append(("10 un periodo mancante in una coppia (INV_H1_2022 tolto)", m10, False))
    def m11(r, F): r["EURJPY"]["intestazione"]["simbolo"] = "EURUSD"; rehash(r["EURJPY"])
    c.append(("11 simbolo nel JSON diverso dall'etichetta (EURJPY dichiarato EURUSD)", m11, False))
    def m12(r, F): F["drop"] = "GBPUSD"
    c.append(("12 coppia GBPUSD mancante (3 file)", m12, False))
    def m13(r, F): r["GBPUSD"] = copy.deepcopy(r["EURUSD"]); F["etichetta_gbp_da_eurusd"] = True
    c.append(("13 stesso JSON usato per due coppie (EURUSD copiato come GBPUSD)", m13, False))
    def m14(r, F): r["EURUSD"]["intestazione"]["tf"] = ["H1"]; rehash(r["EURUSD"])
    c.append(("14 tf senza M30", m14, None))
    return c

def main():
    righe = []; bad = 0
    with tempfile.TemporaryDirectory() as td:
        for nome, fn, atteso in casi():
            F = {}
            if fn == "ANNI_VECCHI":
                runs = {s: SA.costruisci(s, trs, anni=("2013", "2018", "2020", "2025-26")) for s, trs in BASE.items()}
            else:
                runs = {s: SA.costruisci(s, trs) for s, trs in BASE.items()}
                fn(runs, F)
            files = {}
            for s, j in runs.items():
                if F.get("drop") == s: continue
                files[s] = os.path.join(td, nome[:2] + "_" + s + ".json"); json.dump(j, open(files[s], "w"))
            a4, p = SA.esegui_agg(files, os.path.join(td, "o" + nome[:2]), extra=())
            if a4 is None:
                a4ok = "RIFIUTA (exit %s)" % p.returncode; falliti = p.stderr.strip().splitlines()[-1][:100] if p.stderr.strip() else ""
            else:
                V = a4["VERDETTO"]; a4ok = V["controlli_integrita_ok"]; falliti = V["controlli_falliti"]
            # mia verifica
            mio_ok = None
            if len(files) == 4 and not F.get("etichetta_gbp_da_eurusd"):
                mio_ok = all(ok for _, ok, _ in sum([AI.integrita(runs[s], s, V1 if False else AI.leggi_hash_codice(SA.HASH_V2)) for s in runs], []))
            elif F.get("etichetta_gbp_da_eurusd"):
                mio_ok = all(ok for _, ok, _ in sum([AI.integrita(runs[s], s, AI.leggi_hash_codice(SA.HASH_V2)) for s in runs], []))
            elif len(files) < 4:
                mio_ok = False
            esito = a4["VERDETTO"]["esito"] if a4 else "-"
            ok = (a4ok == atteso) if atteso is not None else None
            if atteso is not None and a4ok != atteso: bad += 1
            righe.append((nome, atteso, a4ok, mio_ok, esito, falliti))
    for r in righe:
        print("%-66s atteso_ok=%-6s A4=%-6s mio=%-6s verdetto_A4=%-26s falliti=%s" % tuple(map(str, r)))
    print("\nCasi in cui A4 NON segnala l'anomalia attesa (controlli_integrita_ok != atteso):", bad)
    return 0

if __name__ == "__main__":
    sys.exit(main())
