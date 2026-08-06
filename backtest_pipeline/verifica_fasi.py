#!/usr/bin/env python3
# =====================================================================
#  verifica_fasi.py  --  controlla le fasi di walkforward_aperture.ps1
#                        SIMULANDO il codice che gira davvero
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (06/08/2026):
#  la FASE F non e' partita - sei CSV vuoti - perche' sei parametri
#  (InpTP1_R, InpTP1_ClosePct, InpBreakevenAtTP1, InpRiskPercent,
#  InpMinStopPts, InpSkipIfTight) finivano DUE volte in [TesterInputs]:
#  una nel blocco job e una nello sweep.
#
#  Ma il problema vero e' un altro: **l'audit che avevo scritto a mano
#  non l'ha visto**, perche' deduplicava sia il blocco job sia la
#  blindatura mentre lo script deduplicava solo la blindatura. Stavo
#  controllando un codice diverso da quello che girava.
#
#  Quindi questo file non "controlla i parametri": RICOSTRUISCE la
#  composizione esatta leggendola dal .ps1, e se il .ps1 cambia e la
#  ricostruzione non e' piu' fedele, si accorge e lo dice.
#
#  USO:  python3 backtest_pipeline/verifica_fasi.py
#  Esce 1 se trova qualcosa. Da lanciare PRIMA di mandare un test.
# =====================================================================
import re, sys, os

PS1 = os.path.join(os.path.dirname(os.path.abspath(__file__)), "walkforward_aperture.ps1")
EA  = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "mql5", "Experts", "ABTG_DAX_Apertura_EU.mq5")

def righe(blocco):
    return [r for r in re.split(r"[\r\n]+|`n", blocco) if "=" in r]

def nome(r):
    return r.split("=")[0].strip()

def main():
    s = open(PS1, encoding="utf-8").read()
    problemi = []

    # --- fedelta': la composizione nel .ps1 deve essere quella che simulo ---
    # Lo script mette insieme BloccoJob + Blindatura + Sweep e tiene
    # l'ULTIMA occorrenza di ogni nome. Se questa riga sparisce o cambia,
    # questo controllo non vale piu' e va riscritto.
    firma = 'foreach($blocco in @($BloccoJob, $Blindatura, $fase.Sweep)){'
    if firma not in s:
        print("!! La composizione dei parametri nel .ps1 non e' piu' quella che questo")
        print("   controllo simula. NON fidarti del risultato: riallinea verifica_fasi.py.")
        return 1
    if "$Visti.ContainsKey($n)" not in s:
        print("!! Manca la deduplica 'tieni l'ultima occorrenza'. Controllo non valido.")
        return 1

    job  = righe(re.search(r'\$BloccoJob=@"\n(.*?)\n"@', s, re.S).group(1))
    blind = righe(re.search(r'\$Blindatura=@"\n(.*?)\n"@', s, re.S).group(1))
    ea_inputs = re.findall(r'^input\s+\S+\s+(Inp\w+)', open(EA, encoding="utf-8").read(), re.M)
    # MT5 non puo' ottimizzare le stringhe: non serve pinnarle
    stringhe = set(re.findall(r'^input\s+string\s+(Inp\w+)', open(EA, encoding="utf-8").read(), re.M))

    print(f"blocco job: {len(job)} righe · blindatura: {len(blind)} righe")
    print(f"input dell'EA: {len(ea_inputs)} (di cui {len(stringhe)} stringhe, non ottimizzabili)\n")

    fasi = re.finditer(r'Tag="(\w+)";\s*Pass=(\d+); Win=\$(\w+)\s*\n\s*Sweep="([^"]+)"', s)
    for m in fasi:
        tag, npass, win, sweep_txt = m.group(1), int(m.group(2)), m.group(3), m.group(4)
        sweep = righe(sweep_txt)

        # stessa composizione dello script: ultima occorrenza vince
        visti, finali = set(), []
        for r in reversed(job + blind + sweep):
            if nome(r) not in visti:
                visti.add(nome(r)); finali.insert(0, r)

        dup = sorted({nome(r) for r in finali if [nome(x) for x in finali].count(nome(r)) > 1})
        liberi = [i for i in ea_inputs if i not in visti and i not in stringhe]

        # celle della griglia. InpEntryMode e' un enum: MT5 ignora
        # start/step/stop e li spazzola TUTTI e sei (scoperto il 05/08).
        celle, dettaglio, enum = 1, [], False
        for r in sweep:
            p = r.split("=", 1)[1].split("||")
            if len(p) >= 5 and p[4] == "Y":
                if nome(r) == "InpEntryMode":
                    celle *= 6; enum = True; dettaglio.append("InpEntryMode = tutti e 6 (enum)")
                else:
                    a, st, b = float(p[1]), float(p[2]), float(p[3])
                    k = int(round((b - a) / st)) + 1 if st else 1
                    celle *= k
                    dettaglio.append(f"{nome(r)} = {[round(a + st*i, 2) for i in range(k)]}")

        nwin = 2 if win == "WF" else 1
        stato = []
        if dup:    stato.append(f"DUPLICATI {dup}"); problemi.append(tag)
        if liberi: stato.append(f"NON PINNATI {liberi}"); problemi.append(tag)
        if celle != npass: stato.append(f"celle {celle} != Pass dichiarati {npass}"); problemi.append(tag)

        esito = "  ".join(stato) if stato else "ok"
        print(f"{tag:<15} righe={len(finali):<4} celle={celle:<3} pass={celle*nwin*2:<4} {esito}")
        for d in dettaglio:
            print(f"        {d}")

    if problemi:
        print(f"\n!! PROBLEMI in: {', '.join(sorted(set(problemi)))}")
        return 1
    print("\nTutte le fasi ok: nessun duplicato, nessun input libero, griglie coerenti.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
