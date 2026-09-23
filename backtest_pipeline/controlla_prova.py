#!/usr/bin/env python3
# =====================================================================
#  controlla_prova.py -- i controlli del driver, fatti QUI, prima
#                        di svegliare MT5
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (21/08/2026, preparazione di R93)
#  walkforward_generico.ps1 ha gia' i suoi controlli (nome sconosciuto,
#  sweep degenere, parametro doppio) -- ma girano SUL PC DI CLAUDIO, e
#  ogni errore torna indietro come un giro a vuoto e un messaggio.
#  Questi tre li si puo' fare qui, a costo zero, prima di mandare la riga.
#
#  E ne fa uno IN PIU', che il driver NON fa e che e' costato un round:
#
#    >>> IL PIN DI UNA STRINGA A VALORE VUOTO NON ARRIVA ALL'EA. <<<
#
#  Il file prova della coda fascia B (prove/ABTG_FiboH4_Multi.txt)
#  scriveva `InpSymbols=` con sopra la nota "il pin sotto e'
#  OBBLIGATORIO". MT5 lo ha ignorato e ha usato il default compilato:
#  otto passate intitolate a otto mercati hanno misurato OTTO VOLTE LO
#  STESSO BASKET di tre cross (7 CSV su 8 identici al centesimo), e da
#  li' e' uscito il verdetto "0/8 promossi".
#  La riga c'era, sembrava applicata, e non lo era.
#
#  USO:
#    python3 backtest_pipeline/controlla_prova.py \
#        --ea mql5/Experts/ABTG_FiboH4_Multi.mq5 \
#        backtest_pipeline/prove/R93a_baseline.txt ...
#
#    # o in blocco, deducendo l'EA dalla riga "#  EA: <nome>" del file:
#    python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/R93*.txt
#
#  Esce 1 se trova qualcosa. Va lanciato PRIMA di ogni riga di lancio.
# =====================================================================
from __future__ import annotations

import argparse
import datetime
import glob
import os
import re
import sys

RADICE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def inputs_ea(percorso: str) -> set[str]:
    s = open(percorso, encoding="utf-8", errors="replace").read()
    return set(re.findall(r"^input\s+\w+\s+(\w+)", s, flags=re.M))


# =====================================================================
#  IL CONTO DELLE CELLE SUGLI ENUM -- 12/09/2026, classe 287
# ---------------------------------------------------------------------
#  Fino a oggi questo file contava le celle SEMPRE aritmeticamente:
#      celle = |stop - start| / passo + 1
#  Su un input ENUM quel conto E' SBAGLIATO PER COSTRUZIONE, perche'
#  MT5 (e il driver, che lo imita apposta) IGNORA IL PASSO e spazzola
#  i MEMBRI dell'enum compresi fra start e stop.
#
#  Quanto e' costato: su COLLAUDO_EMADOW_05_tf_U30USD.txt
#  (InpTF=16385||15||1||16388||Y, InpTF e' ENUM_TIMEFRAMES) questo
#  file stampava "celle=16374". Le celle VERE sono SETTE
#  (M15 M20 M30 H1 H2 H3 H4). Su quel 16374 la riga e' stata spenta
#  dalla coda del 12/09 come se valesse il 99,2% della notte: valeva
#  il 5,1% (14 passate su 272).
#
#  La regola qui sotto e' COPIATA dal driver, non inventata:
#  walkforward_generico.ps1 r.385-413 (tabelle) e r.784-790 (il conto).
#  Se il driver cambia, QUESTO va rifatto: e' un doppione deliberato,
#  e la ragione e' che il driver gira sul PC di backtest e questo qui
#  gira prima, a costo zero.
#
#  Verifica contro numeri GIA' SCRITTI DA ALTRI (non contro se stesso):
#    - COLLAUDO_EMADOW_05 r.59-61 dichiara 7 celle -> il conto da' 7
#    - R128a_trailingTF_D30EUR r.255-257 dichiara 7 celle -> da' 7
#    - R128a r.265-268 riporta dall'ARCHIVIO che
#      InpTF=16385||15||1||16408||Y produsse 11 RIGHE (40+ CSV in
#      risultati_prove\) -> il conto su quegli estremi da' 11.
# =====================================================================

#  ENUM_TIMEFRAMES: non sta nel sorgente dell'EA, la mette il driver.
#  PERIOD_CURRENT=0 e' ESCLUSO, esattamente come fa il driver
#  (r.412: "if($TF[$k] -gt 0)").
MEMBRI_TF = [1, 2, 3, 4, 5, 6, 10, 12, 15, 20, 30,
             16385, 16386, 16387, 16388, 16390, 16392, 16396, 16408,
             32769, 49153]


def enum_ea(percorso: str) -> tuple[dict[str, list[int]], dict[str, str]]:
    """Restituisce (membri per nome di enum, tipo dichiarato per ogni input).

    Gli enum dichiarati nel .mq5 si leggono dal sorgente; quelli di MT5
    li mettiamo noi, come fa il driver.
    """
    txt = open(percorso, encoding="utf-8", errors="replace").read()
    membri: dict[str, list[int]] = {
        "ENUM_TIMEFRAMES": list(MEMBRI_TF),
        "ENUM_MA_METHOD": [0, 1, 2, 3],
    }
    for m in re.finditer(r"enum\s+(\w+)\s*\{(.*?)\}", txt, flags=re.S):
        corpo = re.sub(r"/\*.*?\*/", "", m.group(2), flags=re.S)
        corpo = re.sub(r"//[^\r\n]*", "", corpo)
        prossimo = 0
        lista: list[int] = []
        for pezzo in corpo.split(","):
            p = pezzo.strip()
            if not p:
                continue
            mm = re.match(r"^(\w+)\s*=\s*(-?\d+)", p)
            if mm:
                valore = int(mm.group(2))
            elif re.match(r"^\w+", p):
                valore = prossimo
            else:
                continue
            prossimo = valore + 1
            lista.append(valore)
        if lista:
            membri[m.group(1)] = lista
    tipi = dict(
        (x.group(2), x.group(1))
        for x in re.finditer(r"^\s*(?:sinput|input)\s+([A-Za-z_][\w:]*)\s+(\w+)\s*=",
                             txt, flags=re.M)
    )
    return membri, tipi


def trova_ea(prova: str) -> str | None:
    """Legge la riga '#  EA: <Nome> ...' dell'intestazione del file prova."""
    for l in open(prova, encoding="utf-8", errors="replace"):
        m = re.match(r"#\s*EA:\s*([A-Za-z0-9_]+)", l)
        if m:
            p = os.path.join(RADICE, "mql5", "Experts", m.group(1) + ".mq5")
            return p if os.path.exists(p) else None
    return None


def controlla_direttive(prova: str) -> list:
    """Le direttive '@' del file prova. STA FUORI da controlla() APPOSTA.

    CLASSE 686 (23/09/2026). Questi controlli non hanno bisogno dell'EA, ma
    vivevano dentro controlla(), che main() chiama SOLO quando l'EA si
    risolve. MISURATO sul corpus: 446 file su 874 escono prima su "EA NON
    TROVATO", quindi la copertura vera era 428, non 874. E i CINQUE file con
    "@DAQUANDO" NUDO che il driver stesso nomina (ABTG_BandFade,
    ABTG_CanaleLento, ABTG_RangeBudget, ABTG_TurnaroundTuesday,
    SESSIONREOPEN_ORO_BOZZA) stanno TUTTI fra quei 446: il controllo di punta
    ("direttiva SENZA VALORE") aveva copertura viva ZERO.
    Un cancello che non poggia e' peggio di nessun cancello, perche' fa
    credere che qualcuno stia guardando.
    """
    problemi: list = []
    # 5. LE DIRETTIVE '@'. Nato il 23/09/2026.
    #    Il driver le legge a walkforward_generico.ps1 r.507-514: salta le
    #    righe vuote, salta quelle che cominciano per '#' (quindi un '@'
    #    dentro un commento e' INERTE, ed e' giusto cosi'), e delle altre
    #    tiene solo quelle che matchano '^@(\w+)\s+(.+)$' -- nome
    #    MAIUSCOLIZZATO, valore trimmato.
    #    I nomi che poi qualcuno RILEGGE sono CINQUE: SIMBOLO (r.519),
    #    PERIODO (r.520), DAQUANDO (r.521), FINOA (r.562), FRAZIONEIS
    #    (r.702). Ogni altro nome entra in $Direttive e NON LO LEGGE NESSUNO.
    #
    #    >>> ED E' QUI IL DIFETTO CHE QUESTO BLOCCO ESISTE PER PRENDERE:
    #        UNA DIRETTIVA SBAGLIATA NON FA RUMORE. <<<
    #    '@FRAZIONE 0.50' (senza l'IS) viene memorizzata, mai riletta, e il
    #    round gira sul DEFAULT DI FABBRICA -FrazioneIS 0.40 (r.189) senza
    #    una riga di log che lo dica. Idem '@FINOA' storpiata: si torna alla
    #    data di fabbrica. Il CSV esce lo stesso, il referto si scrive, e la
    #    finestra MISURATA non e' quella DICHIARATA nel file.
    #    E' la famiglia della classe 683: il cancello che fallisce MUTO.
    #
    #    Le altre tre (senza valore, formato, campo) il driver le prende gia'
    #    lui con Muori, ma le prende SUL PC DI BACKTEST e a round gia' avviato:
    #    la corsa in batch gira ogni file in un PROCESSO SEPARATO, quindi non
    #    perde la catena -- perde QUEL round, e lo si scopre alla fine dalla
    #    riga CATENA ROTTA. Prenderle qui costa zero.
    DIRETTIVE_LETTE = ("SIMBOLO", "PERIODO", "DAQUANDO", "FINOA", "FRAZIONEIS")
    viste = {}
    for l in open(prova, encoding="utf-8", errors="replace"):
        t = l.strip()
        if not t or t.startswith("#") or not t.startswith("@"):
            continue
        m = re.match(r"^@(\w+)\s+(.+)$", t)
        if not m:
            problemi.append(
                "direttiva SENZA VALORE (il driver non la vede proprio): " + t)
            continue
        k, v = m.group(1).upper(), m.group(2).strip()
        if k not in DIRETTIVE_LETTE:
            problemi.append(
                "direttiva SCONOSCIUTA: @" + k + " -- il driver la memorizza e NON la "
                "rilegge MAI, quindi il round girerebbe sui DEFAULT in SILENZIO. "
                "Le sole lette: " + ", ".join("@" + x for x in DIRETTIVE_LETTE))
            continue
        if k in viste:
            problemi.append(
                "direttiva DOPPIA: @" + k + " ('" + viste[k] + "' poi '" + v + "'). "
                "Il driver tiene l'ULTIMA e non avvisa: la prima e' una dichiarazione falsa.")
        viste[k] = v

    # 5-bis. LA FINESTRA CHE NON PUO' STARE NEL FILE -- 23/09/2026.
    #    Il primo giro di questo blocco chiedeva '@DAQUANDO' a TUTTI. MISURATO
    #    che su OTTO file prova era un FALSO ALLARME, e del tipo peggiore:
    #    spingeva a rompere un ALTRO cancello per far tacere questo.
    #      - POSTNEWS_NFP/1330/ISM_00_conta.txt sono gattati da
    #        RIGA_POSTNEWS_*.ps1 (GateProva, r.382/511/480), che TIRA
    #        UN'ECCEZIONE SE '@DAQUANDO' C'E': "DEVE essere assente", perche'
    #        la data la MISURA la fase 8 sulle barre M1 vere e scriverla a
    #        mano sarebbe "una data indovinata che scavalca la misura". Lo
    #        stesso gate conta le righe VIVE ESATTE (34 = 2 direttive + 31
    #        fissi + 1 asse): una riga viva in piu' e il round non parte.
    #      - i 5 POSTNEWS_ORO_* passano dal generico e omettono '@DAQUANDO'
    #        APPOSTA perche' il driver si FERMI (r.737-742) e obblighi a
    #        misurare lo storico M1 dell'oro prima di partire.
    #    Cioe': "aggiungi @DAQUANDO cosi' il cancello sta zitto" avrebbe
    #    introdotto ESATTAMENTE il guasto che questo blocco esiste per
    #    prevenire -- una data INDOVINATA al posto di una MISURATA.
    #    Quindi l'omissione resta lecita, ma si DICHIARA, e si dichiara in
    #    modo LEGGIBILE A MACCHINA: la prosa e' proprio quello che fino a
    #    ieri faceva passare questi file per falso verde.
    #    Il marcatore sta in un COMMENTO apposta: il driver salta le righe
    #    '#' (r.510) e la RigheVive dei RIGA_POSTNEWS le esclude, quindi non
    #    cambia ne' il comportamento del driver ne' il conto delle 34.
    #    Non e' sintassi inventata: RIGA_NOTTE2_DUKA_R91.ps1 (r.498-500) legge
    #    gia' '# @FINESTRA / # @DA / # @A' dai commenti dei R90a-d.
    motivo_senza = ""
    for l in open(prova, encoding="utf-8", errors="replace"):
        m = re.match(r"^#\s*@DAQUANDO-DALLA-RIGA\s+(.+)$", l.strip())
        if m:
            motivo_senza = m.group(1).strip()
            break

    if "DAQUANDO" in viste and motivo_senza:
        problemi.append(
            "CONTRADDIZIONE: il file dichiara '@DAQUANDO-DALLA-RIGA' (la data arriva "
            "dalla riga di lancio) e POI scrive anche '@DAQUANDO " + viste["DAQUANDO"]
            + "'. Una delle due e' falsa, e chi legge non sa quale: scegline UNA.")
    elif "DAQUANDO" not in viste and not motivo_senza:
        problemi.append(
            "manca @DAQUANDO: la finestra va dichiarata nel file, non ricordata. "
            "Se la data arriva DAVVERO dalla riga di lancio perche' va MISURATA "
            "(caso POSTNEWS), non aggiungere la direttiva -- un altro cancello la "
            "rifiuta: dichiaralo in un COMMENTO, "
            "'#  @DAQUANDO-DALLA-RIGA <chi la misura e perche' non puo' stare qui>'.")
    elif motivo_senza and len(motivo_senza) < 20:
        problemi.append(
            "'@DAQUANDO-DALLA-RIGA' senza un motivo vero ('" + motivo_senza + "'): il "
            "marcatore serve a DICHIARARE chi misura la data, non a zittire il cancello. "
            "Scrivi CHI la passa e PERCHE' non puo' stare nel file.")

    for k in ("DAQUANDO", "FINOA"):
        if k in viste and not re.match(r"^[0-9]{4}\.[0-9]{2}\.[0-9]{2}$", viste[k]):
            problemi.append(
                "@" + k + " '" + viste[k] + "' non e' una data aaaa.mm.gg: il driver muore "
                "(r.563 per @FINOA, ParseExact r.931 per @DAQUANDO).")

    if "DAQUANDO" in viste and "FINOA" in viste:
        try:
            d0 = datetime.datetime.strptime(viste["DAQUANDO"], "%Y.%m.%d")
            d1 = datetime.datetime.strptime(viste["FINOA"], "%Y.%m.%d")
            if d1 <= d0:
                problemi.append(
                    "finestra VUOTA o ROVESCIATA: @DAQUANDO " + viste["DAQUANDO"]
                    + " non e' prima di @FINOA " + viste["FINOA"] + " (driver r.933).")
        except ValueError:
            problemi.append(
                "@DAQUANDO/@FINOA hanno la forma giusta ma NON sono date vere: "
                + viste["DAQUANDO"] + " / " + viste["FINOA"])

    if "FRAZIONEIS" in viste:
        f = viste["FRAZIONEIS"]
        if not re.match(r"^[0-9]*\.?[0-9]+$", f):
            problemi.append(
                "@FRAZIONEIS '" + f + "' non e' un decimale col PUNTO: il driver muore "
                "(r.704). Si scrive '0.40', mai '0,40'.")
        elif not (0.0 < float(f) <= 1.0):
            problemi.append(
                "@FRAZIONEIS '" + f + "' fuori campo: ammesso 0 < f <= 1 (driver r.710).")
    return problemi


def controlla(prova: str, ea: str, tetto: int = 0) -> tuple[int, int]:
    nomi_ok = inputs_ea(ea)
    membri, tipi = enum_ea(ea)
    problemi: list[str] = []
    note: list[str] = []
    righe = []
    for l in open(prova, encoding="utf-8", errors="replace"):
        s = l.strip()
        if not s or s.startswith("#") or s.startswith("@") or "=" not in s:
            continue
        righe.append(s)

    nomi = [r.split("=")[0].strip() for r in righe]

    # 1. nome che l'EA non ha: MT5 lo ignora IN SILENZIO e la passata
    #    risponde a una domanda diversa da quella che credevi di fare.
    for n in nomi:
        if n not in nomi_ok:
            problemi.append(f"input SCONOSCIUTO all'EA: {n}")

    # 2. parametro doppio in [TesterInputs]: MT5 fa zero passate.
    for n in sorted(set(nomi)):
        if nomi.count(n) > 1:
            problemi.append(f"parametro DOPPIO: {n}")

    # 3. IL CONTROLLO CHE IL DRIVER NON FA: pin di stringa vuoto.
    for r in righe:
        if r.split("=", 1)[1].strip() == "":
            problemi.append(f"PIN VUOTO (MT5 lo IGNORA e usa il default compilato): {r}")

    # 4. esattamente UN asse Y, e non degenere.
    assi = [r for r in righe if r.endswith("||Y")]
    celle = 0
    if len(assi) == 0:
        problemi.append("nessun asse Y: sarebbe un backtest singolo, il driver rifiuta di lanciare")
    elif len(assi) > 1:
        problemi.append(f"{len(assi)} assi Y: un file prova misura UNA variabile alla volta "
                        + "(" + ", ".join(a.split("=")[0] for a in assi) + ")")
    else:
        nome_asse = assi[0].split("=")[0].strip()
        p = assi[0].split("=", 1)[1].split("||")
        if len(p) != 5:
            problemi.append(f"asse malformato (servono 5 campi v||start||step||stop||Y): {assi[0]}")
        else:
            try:
                start, step, stop = float(p[1]), float(p[2]), float(p[3])
                if start == stop or step == 0:
                    problemi.append(f"SWEEP DEGENERE su {nome_asse}: start==stop oppure step==0")
                else:
                    tipo_asse = tipi.get(nome_asse)
                    if tipo_asse in membri:
                        # ENUM: il passo NON conta. Contano i MEMBRI fra
                        # start e stop -- come fa il driver.
                        lo, hi = min(start, stop), max(start, stop)
                        celle = len([v for v in membri[tipo_asse] if lo <= v <= hi])
                        aritm = int(abs(stop - start) / step) + 1
                        nota_enum = f"asse ENUM ({tipo_asse}): il passo e' IGNORATO, celle = membri fra {lo:.0f} e {hi:.0f} = {celle}"
                        if celle == 0:
                            problemi.append(
                                f"asse ENUM {nome_asse} ({tipo_asse}): NESSUN membro fra "
                                f"{lo:.0f} e {hi:.0f}. Il driver non produce nemmeno una passata.")
                        elif aritm != celle:
                            # non e' un difetto: e' il numero che INGANNA chi legge.
                            nota_enum += f"  [il conto aritmetico direbbe {aritm}: NON guardarlo]"
                        note.append(nota_enum)
                    else:
                        celle = int(abs(stop - start) / step) + 1
            except ValueError:
                problemi.append(f"asse non numerico: {assi[0]}")

    # 4-bis. IL TETTO. Nato il 12/09/2026 (classe 287): il numero di celle
    #        veniva STAMPATO e non GUARDATO da nessuno.
    #        Il tetto e' scelto sulla distribuzione VERA dei file prova in
    #        archivio, contati con la regola del driver (enum compresi):
    #        su 217 file mono-asse con EA risolvibile il MASSIMO di sempre
    #        e' 24 celle (R129a/R129b), p99 = 10, p50 = 2. ZERO file sopra 24.
    #        Default 64 = 2,67x il massimo mai scritto, 6,4x il p99:
    #        MISURATO che non boccia nessuno dei 689 file in archivio.
    #        Un falso FAIL costa quanto un falso PASS: se una griglia grossa
    #        serve DAVVERO, si alza con --tetto e si dichiara nel referto.
    if tetto > 0 and celle > tetto:
        problemi.append(
            f"TROPPE CELLE: {celle} sopra il tetto di {tetto}. Il massimo mai scritto "
            f"in archivio e' 24. Se la griglia e' VOLUTA, rilancia con --tetto {celle} "
            f"e dichiaralo nel referto; se non lo e', l'asse e' scritto male.")

    # 5. LE DIRETTIVE '@'. Il blocco vive in controlla_direttive() (classe
    #    686), cosi' main() lo puo' chiamare ANCHE sui file il cui EA non si
    #    risolve: le direttive con l'EA non c'entrano niente.
    problemi.extend(controlla_direttive(prova))

    nome = os.path.basename(prova)
    stato = "OK" if not problemi else "!! " + str(len(problemi)) + " PROBLEMI"
    print(f"  {nome:32s} {os.path.basename(ea):26s} pin={len(nomi):2d} celle={celle:2d}  {stato}")
    for n in note:
        print(f"      . {n}")
    for p in problemi:
        print(f"      - {p}")
    return (len(problemi), celle)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("prove", nargs="+")
    ap.add_argument("--ea", default="", help="il .mq5; se manca si legge dalla riga '# EA:' del file prova")
    ap.add_argument("--tetto", type=int, default=64,
                    help="celle massime per file prova (0 = nessun tetto). "
                         "Default 64: il massimo MAI scritto in archivio e' 24 (classe 287).")
    ap.add_argument("--quota", type=float, default=50.0,
                    help="avvisa se UN file prova fa piu' di questa percentuale delle celle totali "
                         "del gruppo controllato (0 = nessun avviso). Avviso, NON bocciatura.")
    a = ap.parse_args()

    files: list[str] = []
    for p in a.prove:
        files.extend(sorted(glob.glob(p)) or [p])

    print("=== CONTROLLO FILE PROVA ===")
    tot_problemi = 0
    tot_celle = 0
    per_file: list[tuple[str, int]] = []
    for f in files:
        ea = a.ea or trova_ea(f)
        if not ea or not os.path.exists(ea):
            # CLASSE 686: l'EA non si risolve, quindi i controlli 1-4 non si
            # possono fare. Ma le DIRETTIVE con l'EA non c'entrano, e saltarle
            # lasciava 446 file su 874 senza NESSUN controllo.
            pd = controlla_direttive(f)
            stato_d = "OK" if not pd else "!! " + str(len(pd)) + " PROBLEMI"
            print(f"  {os.path.basename(f):32s} EA NON TROVATO -> controlli 1-4 non misurabili; direttive: {stato_d}")
            tot_problemi += 1 + len(pd)
            for x in pd:
                print(f"      - {x}")
            continue
        n, c = controlla(f, ea, a.tetto)
        tot_problemi += n
        tot_celle += c
        per_file.append((os.path.basename(f), c))

    # LA QUOTA. Non boccia: AVVISA. Nata il 12/09/2026 con la classe 287,
    # perche' il difetto non era il numero grosso, era che nessuno lo
    # confrontava col resto del gruppo. Un file che da solo pesa piu' di
    # tutti gli altri insieme e' un fatto STRUTTURALE, e va detto a voce.
    if a.quota > 0 and tot_celle > 0 and len(per_file) > 1:
        for nome_f, c in sorted(per_file, key=lambda x: -x[1]):
            quota = 100.0 * c / tot_celle
            if quota > a.quota:
                print()
                print(f"  >>> AVVISO DI QUOTA: {nome_f} fa {c} celle su {tot_celle} "
                      f"= {quota:.1f}% del gruppo.")
                print(f"      Un solo file pesa piu' del {a.quota:.0f}% della coda: "
                      f"controlla che sia VOLUTO prima di lanciarla.")
            break

    print()
    print(f"file: {len(files)} | celle totali: {tot_celle} | "
          f"passate (celle x 2 finestre): {tot_celle * 2} | problemi: {tot_problemi}")
    if tot_problemi:
        print("ESITO: FALLITO -- non si manda nessuna riga di lancio finche' e' rosso.")
        return 1
    print("ESITO: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
