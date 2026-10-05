#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# MARCATORE_LEGGI_F2_DK_v1
"""
leggi_f2_dk.py -- VALUTA le tre condizioni della F2 "FIRMO CANCELLO DK DOW" dai file che P1 produce. Non esegue niente e non scarica niente: legge CSV.

COSA E' (e cosa NON e'). E' l'attuazione MECCANICA del testo dell'appendice della F2 (report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md par. 5), che sta qui sotto
in TESTO_F2_APPENDICE, VERBATIM (le sole due differenze: le virgolette angolari di apertura e chiusura, nel piano, sono rese con "; questo file e' ASCII puro per la console di Windows).
L'autotest lo ricontrolla contro il piano quando il piano e' nel repo. La firma di Claudio a oggi NON e' ancora scritta nel suo testo preciso: se il testo firmato
differisce dall'appendice, questo file si aggiorna E si rifa' l'autotest; l'impronta del testo incorporato esce in ogni valutazione (TESTO_F2_SHA256).
NON decide niente sul rischio, sulle taglie, sui preset, sugli EA, sul conto reale: dice se un feed passa un cancello zero. Se NON passa, U30USD_DK resta in frigo.

I FILE CHE LEGGE (cartella unica, i nomi li fissa la riga P1):
  ABTG_ImportTick_giorni_U30USD_DK.csv     le righe per giorno della sonda di U30USD_DK  (scritte da ABTG_ImportaTickEsterno v1: IL SIMBOLO e' su OGNI riga)
  ABTG_ImportTick_giorni_U30USD_DKNEG.csv  le righe per giorno del CONTROLLO NEGATIVO (2025.03.12 convertito in UTC+0, simbolo e cartella SEPARATI)
  confronto_giorni.csv                     il confronto byte per byte dei CSV vecchi (03/09) e nuovi (dukascopy_tick.py --confronta-giorni)
  k0b_lag_per_giorno.csv                   OPZIONALE: Simbolo,Giorno,LagMinuti,Correlazione (formato definito qui; lo script K0b NON e' ancora costruito: "serve dopo")

COME LEGGE (le scelte che il testo lascia aperte sono DICHIARATE qui, non nascoste; ogni scelta e' la piu' severa fra le letture possibili, mai la piu' comoda):
  (1) "dentro" = mediana <= 0.05 E copertura >= 80, con le soglie della RIGA uguali a quelle congelate (se la riga porta altre soglie: SOGLIA_DIVERSA, non dentro) e col
      PassaImportatore della riga concorde con i numeri (altrimenti DISCORDANZA, non dentro: un giorno al bordo letto in due modi non e' un giorno dentro).
      Per ciascuno dei 9 giorni NOMINATI serve UNA riga, del simbolo U30USD_DK, con esito MISURATO. Zero righe = ASSENTE, due o piu' = RIPETUTO (ambiguo), esito diverso da MISURATO
      = quell'esito (NON_CONFRONTABILE, DATA_MALFORMATA). Righe di un ALTRO simbolo nel file di U30USD_DK = ATTRIBUZIONE INCOERENTE e la (1) cade. Versione dell'importer
      diversa da IMP-TICK-v1* (non scrive il simbolo come la F2 pretende) = NON VALUTABILE.
      Il verdetto "OK: CANCELLO PASSATO" e il conteggio "9/9" dell'importer NON entrano mai.
  (2) i 5 giorni in ora legale USA (2025.06.10, 2024.10.29, 2024.10.31, 2025.03.12, 2025.03.25: i 5 dei 6 del 03/09 che non sono 2024.11.20) devono avere nel confronto
      RigheVecchie == RigheNuove > 0 e SHA256 uguali. Zero righe da entrambe le parti NON certifica niente (n = 0 -> non identico). Una riga del confronto che dice SI con SHA
      diversi o conteggi diversi e' incoerente: non identico. Giorno assente dal confronto = non identico.
  (3) via A (controllo negativo): la riga di U30USD_DKNEG del 2025.03.12 deve essere MISURATA (stato DENTRO o FUORI: un NON_CONFRONTABILE conta come sotto il doppio), la riga di
      U30USD_DK dello STESSO giorno deve essere anch'essa MISURATA (e' il "valore giusto"), mediana_neg >= 2 x mediana_giusta E mediana_neg > 0.05 (STRETTO: un errore d'un'ora che resta
      a 0.05 o meno passerebbe la (1): il metro sarebbe cieco). 0 >= 2 x 0 non basta: la seconda clausola lo ferma e si va in K0b.
      via B (K0b): una riga per ciascuno dei 9 giorni, simbolo U30USD_DK, |LagMinuti| <= 1 in OGNI giorno (per giorno, MAI sull'aggregato: 5 estivi a lag 0 e 4 invernali a lag 60
      darebbero un picco aggregato a 0). La (3) passa se passa la via A OPPURE la via B. K0b sostituisce SOLO la (3).
  CANCELLO ZERO = (1) E (2) E (3). Esiti: PASSA (exit 0) | NON PASSA (exit 1) | NON VALUTABILE (exit 2: file mancanti/illeggibili/versione vecchia).
  Se 2024.11.20 non e' DENTRO: "U30USD_DK resta in frigo e non firmo nessuna deroga senza la misura della volatilita' oraria del Dow" (clausola finale dell'appendice).

USO:  python3 leggi_f2_dk.py --cartella DIR [--out FILE]      |    python3 leggi_f2_dk.py --autotest
"""
import csv
import hashlib
import io
import os
import re
import sys

GIORNI9 = ["2024.11.20", "2025.06.10", "2024.10.29", "2024.10.31", "2025.03.12", "2025.03.25", "2024.12.10", "2025.01.14", "2025.02.11"]
ESTIVI5 = ["2025.06.10", "2024.10.29", "2024.10.31", "2025.03.12", "2025.03.25"]
GIORNO_NEG = "2025.03.12"
SIM_DK = "U30USD_DK"
SIM_NEG = "U30USD_DKNEG"
SOGLIA_DIFF = 0.05
SOGLIA_COP = 80.0
PREFISSO_VERSIONE = "IMP-TICK-v1"
F_DK = "ABTG_ImportTick_giorni_U30USD_DK.csv"
F_NEG = "ABTG_ImportTick_giorni_U30USD_DKNEG.csv"
F_CONF = "confronto_giorni.csv"
F_K0B = "k0b_lag_per_giorno.csv"
COL_GIORNI = ["Versione", "Simbolo", "Giorno", "Esito", "MedianaDiffPct", "CoperturaPct", "TickNat", "TickDK", "SpreadNat", "SpreadDK",
              "SogliaDiffPct", "SogliaCoperturaPct", "PassaImportatore"]
COL_CONF = ["Giorno", "RigheVecchie", "RigheNuove", "ShaVecchie", "ShaNuove", "Identico"]
COL_K0B = ["Simbolo", "Giorno", "LagMinuti", "Correlazione"]

TESTO_F2_APPENDICE = (
    '> **"FIRMO CANCELLO DK DOW"**: per `U30USD_DK` il cancello zero si decide **riconvertendo i 222 giorni gia\' scaricati con orologio UTC+1 fisso** e rifacendo la sonda su 9 giorni '
    '(i 6 del 03/09 + 2024.12.10, 2025.01.14, 2025.02.11) col metro di sempre (mediana <= 0,05 %, copertura >= 80 %), piu\' il **controllo negativo** sul 2025.03.12 convertito apposta '
    'in UTC+0 in un simbolo e in una cartella separati: **il cancello zero passa solo se valgono TUTTE E TRE: (1) ciascuno dei 9 giorni NOMINATI qui sopra ha la sua riga per giorno '
    'nella sonda, misurata e dentro (dentro = mediana <= 0,05 % E copertura >= 80 % su quel giorno: copertura sotto 80 % e\' fuori anche con la mediana bassa), letta nella sonda di '
    '`U30USD_DK` e solo li\' (la riga per giorno dell\'importer, r.503, non stampa il simbolo: ogni riga portata in repo porta il nome del simbolo, e la riga del 2025.03.12 di '
    '`U30USD_DKNEG` non vale per la (1) ne\' quella di `U30USD_DK` come misura del negativo nella (3): nella (3) la riga di `U30USD_DK` serve solo come "valore giusto dello stesso giorno"); '
    'un giorno "NON confrontabile" o assente dalle righe non e\' dentro, e non bastano ne\' il conteggio "9/9" ne\' il verdetto "OK: CANCELLO PASSATO"; (2) le righe dei 5 giorni in ora legale '
    'USA sono identiche, byte per byte, nei CSV del 03/09 (copiati prima di riconvertire) e in quelli nuovi; (3) il controllo negativo, misurato (una riga per giorno del 2025.03.12 nel '
    'simbolo separato; se esce "NON confrontabile" conta come sotto il doppio), esce almeno al doppio del valore giusto dello stesso giorno **e** con mediana sopra 0,05 % (un errore d\'un\'ora '
    'che resta sotto 0,05 % passerebbe la (1): il metro sarebbe cieco proprio alla soglia che decide), oppure, se manca anche una delle due, K0b mette il picco di correlazione a lag 0 +-1 minuto '
    'su ciascuno dei 9 giorni (K0b sostituisce solo la (3): la (1) e la (2) restano obbligatorie); se `2024.11.20` resta sopra, `U30USD_DK` resta in frigo e non firmo nessuna deroga senza la '
    'misura della volatilita\' oraria del Dow.**')
TESTO_F2_SHA256 = hashlib.sha256(TESTO_F2_APPENDICE.encode("ascii")).hexdigest().upper()


# ---------------------------------------------------------------------
#  lettura dei CSV (intestazione ESATTA: una colonna in piu' o in meno e' un file di un'altra versione)
# ---------------------------------------------------------------------
class FileNonValutabile(Exception):
    pass


def leggi_csv(testo, colonne, nome):
    rd = csv.reader(io.StringIO(testo))
    righe = list(rd)
    if not righe:
        raise FileNonValutabile("%s: file vuoto" % nome)
    if [c.strip() for c in righe[0]] != colonne:
        raise FileNonValutabile("%s: intestazione diversa dall'attesa (%s)" % (nome, ",".join(colonne)))
    out = []
    for i, r in enumerate(righe[1:], 2):
        if not r or all(not c.strip() for c in r):
            continue
        if len(r) != len(colonne):
            raise FileNonValutabile("%s: riga %d con %d colonne invece di %d" % (nome, i, len(r), len(colonne)))
        out.append({c: v.strip() for c, v in zip(colonne, r)})
    return out


def num(s):
    try:
        v = float(s)
    except (TypeError, ValueError):
        return None
    if v != v or v in (float("inf"), float("-inf")):
        return None
    return v


# ---------------------------------------------------------------------
#  UN giorno di UN simbolo: lo stato (la stessa macchina a stati di Valuta-GiorniPerNome in RIGA_DUKA_IMPORT_SONDA.ps1: la batteria li confronta)
#  DENTRO | FUORI | NON_CONFRONTABILE (e ogni altro Esito) | ASSENTE | RIPETUTO | NON_VALIDO | SOGLIA_DIVERSA | DISCORDANZA
# ---------------------------------------------------------------------
def stato_giorno(righe, simbolo, giorno):
    r = [x for x in righe if x["Simbolo"] == simbolo and x["Giorno"] == giorno]
    if len(r) == 0:
        return ("ASSENTE", None, None)
    if len(r) > 1:
        return ("RIPETUTO", None, None)
    x = r[0]
    med, cop = num(x["MedianaDiffPct"]), num(x["CoperturaPct"])
    if x["Esito"] != "MISURATO":
        return (x["Esito"] or "ESITO_VUOTO", med, cop)
    sd, sc = num(x["SogliaDiffPct"]), num(x["SogliaCoperturaPct"])
    if med is None or cop is None or sd is None or sc is None:
        return ("NON_VALIDO", med, cop)
    if sd != SOGLIA_DIFF or sc != SOGLIA_COP:
        return ("SOGLIA_DIVERSA", med, cop)
    dentro = (med <= SOGLIA_DIFF and cop >= SOGLIA_COP)
    if x["PassaImportatore"] not in ("SI", "NO"):
        return ("NON_VALIDO", med, cop)
    if dentro != (x["PassaImportatore"] == "SI"):
        return ("DISCORDANZA", med, cop)
    return ("DENTRO" if dentro else "FUORI", med, cop)


def misurato(stato):
    return stato in ("DENTRO", "FUORI")


# ---------------------------------------------------------------------
#  le tre condizioni
# ---------------------------------------------------------------------
def condizione_1(righe_dk):
    anomalie = []
    if any(not x["Versione"].startswith(PREFISSO_VERSIONE) for x in righe_dk):
        raise FileNonValutabile("file di U30USD_DK: Versione dell'importer diversa da %s* (non scrive il simbolo come la F2 pretende)" % PREFISSO_VERSIONE)
    altri = [x for x in righe_dk if x["Simbolo"] != SIM_DK]
    if altri:
        anomalie.append("ATTRIBUZIONE INCOERENTE: %d righe con simbolo diverso da %s nel file di %s (%s)" % (
            len(altri), SIM_DK, SIM_DK, ",".join(sorted(set(x["Simbolo"] for x in altri)))))
    per = []
    for g in GIORNI9:
        per.append((g,) + stato_giorno(righe_dk, SIM_DK, g))
    ok = all(s == "DENTRO" for (_, s, _, _) in per) and not anomalie
    return ok, per, anomalie


def condizione_2(righe_conf):
    per = []
    for g in ESTIVI5:
        r = [x for x in righe_conf if x["Giorno"] == g]
        if len(r) != 1:
            per.append((g, "ASSENTE" if not r else "RIPETUTO", None, None))
            continue
        x = r[0]
        nv, nn = num(x["RigheVecchie"]), num(x["RigheNuove"])
        if nv is None or nn is None:
            per.append((g, "NON_VALIDO", None, None)); continue
        nv, nn = int(nv), int(nn)
        uguali = (nv > 0 and nv == nn and x["ShaVecchie"] == x["ShaNuove"] and x["ShaVecchie"] not in ("", "-"))
        dichiara = (x["Identico"] == "SI")
        if uguali and dichiara:
            per.append((g, "IDENTICO", nv, nn))
        elif dichiara and not uguali:
            per.append((g, "INCOERENTE (dice SI ma conteggi/SHA no)", nv, nn))
        else:
            per.append((g, "DIVERSO" if nv > 0 and nn > 0 else "VUOTO (n=0: non certifica)", nv, nn))
    return all(s == "IDENTICO" for (_, s, _, _) in per), per


def condizione_3(righe_dk, righe_neg, righe_k0b):
    """(ok, via_A_ok, via_B_ok, note). righe_neg/righe_k0b possono essere None (file assente)."""
    note = []
    # via A
    via_a = False
    if righe_neg is None:
        note.append("via A: file del controllo negativo ASSENTE -> NON MISURATO (conta come sotto il doppio)")
    else:
        if any(not x["Versione"].startswith(PREFISSO_VERSIONE) for x in righe_neg):
            raise FileNonValutabile("file di U30USD_DKNEG: Versione dell'importer diversa da %s*" % PREFISSO_VERSIONE)
        altri = [x for x in righe_neg if x["Simbolo"] != SIM_NEG]
        if altri:
            note.append("via A: ATTRIBUZIONE INCOERENTE (%d righe con simbolo diverso da %s nel file del negativo) -> via A non valida" % (len(altri), SIM_NEG))
        else:
            sn, mn, _ = stato_giorno(righe_neg, SIM_NEG, GIORNO_NEG)
            sg, mg, _ = stato_giorno(righe_dk, SIM_DK, GIORNO_NEG)
            if not misurato(sn):
                note.append("via A: negativo %s del %s = %s -> conta come sotto il doppio" % (SIM_NEG, GIORNO_NEG, sn))
            elif not misurato(sg):
                note.append("via A: il valore GIUSTO (%s del %s) non e' misurato (%s): niente rapporto" % (SIM_DK, GIORNO_NEG, sg))
            else:
                doppio = (mn >= 2.0 * mg)
                sopra = (mn > SOGLIA_DIFF)
                note.append("via A: negativo %.8f%% contro giusto %.8f%%: >= 2x? %s ; > %.2f%%? %s" % (mn, mg, "SI" if doppio else "NO", SOGLIA_DIFF, "SI" if sopra else "NO"))
                via_a = bool(doppio and sopra)
    # via B
    via_b = False
    if righe_k0b is None:
        note.append("via B (K0b): file ASSENTE -> K0b NON ANCORA MISURATO (serve dopo)")
    else:
        lag = {}
        for x in righe_k0b:
            if x["Simbolo"] == SIM_DK:
                lag.setdefault(x["Giorno"], []).append(num(x["LagMinuti"]))
        mancanti = [g for g in GIORNI9 if len(lag.get(g, [])) != 1]
        if mancanti:
            note.append("via B: K0b non ha UNA riga di %s per i giorni: %s" % (SIM_DK, ",".join(mancanti)))
        else:
            fuori = [g for g in GIORNI9 if lag[g][0] is None or abs(lag[g][0]) > 1]
            via_b = not fuori
            note.append("via B: lag per giorno entro +-1 minuto in %d/%d giorni%s" % (len(GIORNI9) - len(fuori), len(GIORNI9), ("; FUORI: " + ",".join(fuori)) if fuori else ""))
    return (via_a or via_b), via_a, via_b, note


# ---------------------------------------------------------------------
def valuta(testi):
    """testi: dict nome_file -> testo (o None se assente). Torna (esito, righe_di_testo). esito in PASSA | NON PASSA | NON VALUTABILE."""
    out = []
    P = out.append
    P("=== F2 CANCELLO DK DOW: VALUTAZIONE (leggi_f2_dk.py, %s) ===" % "MARCATORE_LEGGI_F2_DK_v1")
    P("testo F2 incorporato: SHA256 %s (la firma di Claudio, se ha un testo diverso, rifa' questo file)" % TESTO_F2_SHA256)
    if testi.get(F_DK) is None:
        P("NON VALUTABILE: manca %s (la sonda di U30USD_DK: senza, la (1) non esiste)" % F_DK)
        return "NON VALUTABILE", out
    try:
        righe_dk = leggi_csv(testi[F_DK], COL_GIORNI, F_DK)
        righe_neg = leggi_csv(testi[F_NEG], COL_GIORNI, F_NEG) if testi.get(F_NEG) is not None else None
        righe_conf = leggi_csv(testi[F_CONF], COL_CONF, F_CONF) if testi.get(F_CONF) is not None else None
        righe_k0b = leggi_csv(testi[F_K0B], COL_K0B, F_K0B) if testi.get(F_K0B) is not None else None
        ok1, per1, anom1 = condizione_1(righe_dk)
        ok2, per2 = (condizione_2(righe_conf) if righe_conf is not None else (False, None))
        ok3, via_a, via_b, note3 = condizione_3(righe_dk, righe_neg, righe_k0b)
    except FileNonValutabile as e:
        P("NON VALUTABILE: %s" % e)
        return "NON VALUTABILE", out
    P("")
    P("(1) i 9 giorni NOMINATI, ciascuno con la sua riga misurata e dentro, nella sonda di %s (mediana <= %.2f%%, copertura >= %.0f%%): %s" % (SIM_DK, SOGLIA_DIFF, SOGLIA_COP, "PASS" if ok1 else "FAIL"))
    for (g, s, m, c) in per1:
        P("      %s  %-18s mediana %s  copertura %s" % (g, s, "-" if m is None else "%.8f%%" % m, "-" if c is None else "%.4f%%" % c))
    for a in anom1:
        P("      " + a)
    P("(2) i 5 giorni in ora legale USA identici byte per byte nei CSV del 03/09 e in quelli nuovi: %s" % ("PASS" if ok2 else ("FAIL" if per2 is not None else "FAIL (confronto NON MISURATO: manca %s)" % F_CONF)))
    if per2 is not None:
        for (g, s, nv, nn) in per2:
            P("      %s  %-40s righe vecchie %s nuove %s" % (g, s, "-" if nv is None else nv, "-" if nn is None else nn))
    P("(3) controllo negativo (via A) oppure K0b (via B): %s   [via A %s, via B %s]" % ("PASS" if ok3 else "FAIL", "PASS" if via_a else "no", "PASS" if via_b else "no"))
    for n in note3:
        P("      " + n)
    esito = "PASSA" if (ok1 and ok2 and ok3) else "NON PASSA"
    P("")
    P("CANCELLO ZERO DEI _DK (serve (1) E (2) E (3)): %s" % esito)
    st1120 = [s for (g, s, _, _) in per1 if g == "2024.11.20"]
    if st1120 and st1120[0] != "DENTRO":
        P("2024.11.20 NON e' DENTRO (%s): U30USD_DK resta in frigo e non si firma nessuna deroga senza la misura della volatilita' oraria del Dow." % st1120[0])
    if esito == "NON PASSA":
        P("-> U30USD_DK RESTA IN FRIGO. Nessun round parte su U30USD_DK.")
    return esito, out


def carica_cartella(cartella):
    testi = {}
    for n in (F_DK, F_NEG, F_CONF, F_K0B):
        p = os.path.join(cartella, n)
        testi[n] = open(p, encoding="ascii", newline="").read() if os.path.exists(p) else None
    return testi


# ---------------------------------------------------------------------
#  AUTOTEST: casi scritti A MANO, con l'esito atteso scritto PRIMA (i controesempi sono quelli trovati dal cancello nelle sei passate sul piano)
# ---------------------------------------------------------------------
def _riga_g(simbolo, giorno, med, cop, esito="MISURATO", ver="IMP-TICK-v1-GIORNI", sd="0.05000000", sc="80.0000", passa=None):
    if esito != "MISURATO":
        return [ver, simbolo, giorno, esito, "-", "-", "0", "0", "-", "-", sd, sc, "-"]
    if passa is None:
        passa = "SI" if (float(med) <= 0.05 and float(cop) >= 80.0) else "NO"
    return [ver, simbolo, giorno, esito, med, cop, "1000", "1000", "2.5000", "2.5000", sd, sc, passa]


def _csv(colonne, righe):
    return "\n".join([",".join(colonne)] + [",".join(r) for r in righe]) + "\n"


def _dk(over=None, tolti=(), extra=()):
    base = {g: _riga_g(SIM_DK, g, "0.03000000", "99.0000") for g in GIORNI9}
    base["2024.11.20"] = _riga_g(SIM_DK, "2024.11.20", "0.04000000", "98.0000")
    base["2025.03.12"] = _riga_g(SIM_DK, "2025.03.12", "0.03000000", "99.0000")
    for g, r in (over or {}).items():
        base[g] = r
    righe = [r for g, r in base.items() if g not in tolti] + list(extra)
    return _csv(COL_GIORNI, righe)


def _neg(med="0.08000000", cop="95.0000", **kw):
    return _csv(COL_GIORNI, [_riga_g(SIM_NEG, GIORNO_NEG, med, cop, **kw)])


def _conf(over=None, tolti=()):
    base = {g: [g, "100", "100", "A" * 64, "A" * 64, "SI"] for g in ESTIVI5}
    for g in ("2024.11.20", "2024.12.10", "2025.01.14", "2025.02.11"):
        base[g] = [g, "50", "50", "B" * 64, "C" * 64, "NO"]      # gli invernali DEVONO differire: non contano per la (2)
    for g, r in (over or {}).items():
        base[g] = r
    return _csv(COL_CONF, [r for g, r in base.items() if g not in tolti])


def _k0b(lag_per_giorno):
    return _csv(COL_K0B, [[SIM_DK, g, str(l), "0.9"] for g, l in lag_per_giorno.items()])


def autotest():
    ko = []
    n = 0

    def caso(nome, atteso, testi, contiene=None, non_contiene=None):
        nonlocal n
        n += 1
        esito, out = valuta(testi)
        t = "\n".join(out)
        if esito != atteso:
            ko.append("%s: atteso %s, uscito %s\n%s" % (nome, atteso, esito, t))
        for c in (contiene or []):
            if c not in t:
                ko.append("%s: manca nel testo: %s" % (nome, c))
        for c in (non_contiene or []):
            if c in t:
                ko.append("%s: NON dovrebbe esserci: %s" % (nome, c))

    def T(dk=None, neg=None, conf=None, k0b=None):
        return {F_DK: dk if dk is not None else _dk(), F_NEG: neg, F_CONF: conf if conf is not None else _conf(), F_K0B: k0b}

    # --- il caso buono: giusto 0.03, negativo 0.08 (>= 0.06 e > 0.05)
    caso("A1 tutto verde", "PASSA", T(neg=_neg("0.08000000")), ["(1) ", ": PASS", "CANCELLO ZERO DEI _DK (serve (1) E (2) E (3)): PASSA"])
    # --- (1): i controesempi trovati dal cancello
    caso("B1 2024.11.20 NON_CONFRONTABILE con gli altri 8 dentro ('8/8 OK' dell'importer)", "NON PASSA",
         T(dk=_dk({"2024.11.20": _riga_g(SIM_DK, "2024.11.20", "", "", esito="NON_CONFRONTABILE")}, ), neg=_neg()),
         ["2024.11.20  NON_CONFRONTABILE", "resta in frigo", "volatilita' oraria"])
    caso("B2 giorno RIPETUTO e 2024.11.20 saltato ('9/9' con un duplicato)", "NON PASSA",
         T(dk=_dk(tolti=("2024.11.20",), extra=(_riga_g(SIM_DK, "2025.03.25", "0.03000000", "99.0000"),)), neg=_neg()), ["2024.11.20  ASSENTE", "2025.03.25  RIPETUTO"])
    caso("B3 copertura 79.99 con mediana bassa = FUORI", "NON PASSA", T(dk=_dk({"2024.12.10": _riga_g(SIM_DK, "2024.12.10", "0.00100000", "79.9900")}), neg=_neg()), ["2024.12.10  FUORI"])
    caso("B4 mediana 0.05 e copertura 80 esatte = DENTRO (<= e >=)", "PASSA",
         T(dk=_dk({"2024.12.10": _riga_g(SIM_DK, "2024.12.10", "0.05000000", "80.0000")}, ), neg=_neg("0.08000000")), ["2024.12.10  DENTRO"])
    caso("B5 mediana 0.05000001 = FUORI", "NON PASSA", T(dk=_dk({"2024.12.10": _riga_g(SIM_DK, "2024.12.10", "0.05000001", "99.0000")}), neg=_neg()), ["2024.12.10  FUORI"])
    caso("B6 PassaImportatore discorde dai numeri = DISCORDANZA", "NON PASSA", T(dk=_dk({"2024.12.10": _riga_g(SIM_DK, "2024.12.10", "0.05000001", "99.0000", passa="SI")}), neg=_neg()), ["2024.12.10  DISCORDANZA"])
    caso("B7 soglie della riga diverse da quelle congelate", "NON PASSA", T(dk=_dk({"2024.12.10": _riga_g(SIM_DK, "2024.12.10", "0.03", "99", sd="0.06000000")}), neg=_neg()), ["2024.12.10  SOGLIA_DIVERSA"])
    caso("B8 riga di un ALTRO simbolo (il negativo) nel file di U30USD_DK", "NON PASSA",
         T(dk=_dk(extra=(_riga_g(SIM_NEG, "2025.03.12", "0.09000000", "95.0000"),)), neg=_neg()), ["ATTRIBUZIONE INCOERENTE"])
    caso("B9 il giorno e' presente ma col simbolo del NEGATIVO al posto del DK (swap): il DK non ha la riga", "NON PASSA",
         T(dk=_dk({"2025.03.12": _riga_g(SIM_NEG, "2025.03.12", "0.03000000", "99.0000")}), neg=_neg()), ["2025.03.12  ASSENTE", "ATTRIBUZIONE INCOERENTE"])
    caso("B10 mediana non numerica", "NON PASSA", T(dk=_dk({"2024.12.10": _riga_g(SIM_DK, "2024.12.10", "boh", "99.0000", passa="SI")}), neg=_neg()), ["2024.12.10  NON_VALIDO"])
    caso("B11 importer VECCHIO (v0) = NON VALUTABILE, non FAIL", "NON VALUTABILE", T(dk=_dk({"2024.12.10": _riga_g(SIM_DK, "2024.12.10", "0.03", "99", ver="IMP-TICK-v0-BOZZA")}), neg=_neg()), ["Versione dell'importer"])
    # --- (2)
    caso("C1 un estivo con SHA diverso", "NON PASSA", T(neg=_neg(), conf=_conf({"2024.10.29": ["2024.10.29", "100", "100", "A" * 64, "D" * 64, "NO"]})), ["2024.10.29  DIVERSO"])
    caso("C2 un estivo con n = 0 da entrambe le parti ('identici' perche' vuoti)", "NON PASSA",
         T(neg=_neg(), conf=_conf({"2025.06.10": ["2025.06.10", "0", "0", "-", "-", "NO"]})), ["VUOTO (n=0"])
    sha_vuoto = "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855"
    caso("C2b un estivo con n = 0 ma SHA 'vero' (quello dell'insieme vuoto) e Identico SI scritto a mano", "NON PASSA",
         T(neg=_neg(), conf=_conf({"2025.06.10": ["2025.06.10", "0", "0", sha_vuoto, sha_vuoto, "SI"]})), ["2025.06.10  INCOERENTE"])
    caso("C3 un estivo dice SI ma gli SHA no (incoerente)", "NON PASSA", T(neg=_neg(), conf=_conf({"2025.03.25": ["2025.03.25", "100", "100", "A" * 64, "D" * 64, "SI"]})), ["INCOERENTE"])
    caso("C4 un estivo con conteggio diverso", "NON PASSA", T(neg=_neg(), conf=_conf({"2025.03.25": ["2025.03.25", "100", "101", "A" * 64, "A" * 64, "NO"]})), ["2025.03.25  DIVERSO"])
    caso("C5 un estivo assente dal confronto", "NON PASSA", T(neg=_neg(), conf=_conf(tolti=("2024.10.31",))), ["2024.10.31  ASSENTE"])
    caso("C6 confronto non fornito", "NON PASSA", {F_DK: _dk(), F_NEG: _neg(), F_CONF: None, F_K0B: None}, ["FAIL (confronto NON MISURATO"])
    caso("C7 gli invernali nel confronto 'diversi' NON fanno cadere la (2)", "PASSA", T(neg=_neg()), ["(2) "])
    # --- (3) via A
    caso("D1 giusto 0.020, negativo 0.045: doppio si', sopra 0.05 no -> serve K0b", "NON PASSA",
         T(dk=_dk({"2025.03.12": _riga_g(SIM_DK, "2025.03.12", "0.02000000", "99.0000")}), neg=_neg("0.04500000")), ["> 0.05%? NO"])
    caso("D2 giusto 0.03, negativo 0.07 -> passa", "PASSA", T(neg=_neg("0.07000000")), [">= 2x? SI"])
    caso("D3 giusto 0.04, negativo 0.07: sopra 0.05 si', doppio no (serve 0.08)", "NON PASSA",
         T(dk=_dk({"2025.03.12": _riga_g(SIM_DK, "2025.03.12", "0.04000000", "99.0000")}), neg=_neg("0.07000000")), [">= 2x? NO"])
    caso("D3b giusto 0.04, negativo 0.08 = ESATTAMENTE il doppio -> passa (>=)", "PASSA",
         T(dk=_dk({"2025.03.12": _riga_g(SIM_DK, "2025.03.12", "0.04000000", "99.0000")}), neg=_neg("0.08000000")), [">= 2x? SI"])
    caso("D4 giusto 0 e negativo 0: 0 >= 2 x 0 ma non sopra 0.05 -> K0b", "NON PASSA",
         T(dk=_dk({"2025.03.12": _riga_g(SIM_DK, "2025.03.12", "0.00000000", "99.0000")}), neg=_neg("0.00000000")), ["> 0.05%? NO"])
    caso("D5 negativo esattamente 0.05 (non sopra: STRETTO) con giusto 0.01", "NON PASSA",
         T(dk=_dk({"2025.03.12": _riga_g(SIM_DK, "2025.03.12", "0.01000000", "99.0000")}), neg=_neg("0.05000000")), ["> 0.05%? NO"])
    caso("D6 negativo NON_CONFRONTABILE = sotto il doppio", "NON PASSA", T(neg=_neg(esito="NON_CONFRONTABILE")), ["conta come sotto il doppio"])
    caso("D7 file del negativo ASSENTE", "NON PASSA", T(neg=None), ["file del controllo negativo ASSENTE"])
    caso("D8 DK e NEG scambiati: DK 0.060 (fuori) e NEG 0.030", "NON PASSA",
         T(dk=_dk({"2025.03.12": _riga_g(SIM_DK, "2025.03.12", "0.06000000", "99.0000")}), neg=_neg("0.03000000")), ["2025.03.12  FUORI"])
    caso("D9 il file del negativo contiene una riga col simbolo DK", "NON PASSA",
         T(neg=_csv(COL_GIORNI, [_riga_g(SIM_DK, "2025.03.12", "0.09000000", "95.0000")])), ["ATTRIBUZIONE INCOERENTE"])
    caso("D10 il 'giusto' del 2025.03.12 non e' misurato -> niente rapporto", "NON PASSA",
         T(dk=_dk({"2025.03.12": _riga_g(SIM_DK, "2025.03.12", "", "", esito="NON_CONFRONTABILE")}), neg=_neg("0.09000000")), ["il valore GIUSTO"])
    # --- (3) via B, K0b per giorno
    ok_lag = {g: 0 for g in GIORNI9}
    caso("E1 negativo cieco (0.045) ma K0b a lag 0 in tutti e 9 -> (3) passa", "PASSA",
         T(dk=_dk({"2025.03.12": _riga_g(SIM_DK, "2025.03.12", "0.02000000", "99.0000")}), neg=_neg("0.04500000"), k0b=_k0b(ok_lag)), ["via B: lag per giorno entro +-1 minuto in 9/9"])
    lag_bad = dict(ok_lag); lag_bad["2024.12.10"] = 60; lag_bad["2024.11.20"] = 60; lag_bad["2025.01.14"] = 60; lag_bad["2025.02.11"] = 60
    caso("E2 5 estivi a lag 0 e 4 invernali a lag 60 (l'aggregato darebbe 0): per giorno -> FAIL", "NON PASSA",
         T(neg=_neg(esito="NON_CONFRONTABILE"), k0b=_k0b(lag_bad)), ["FUORI: "])
    lag_pm1 = dict(ok_lag); lag_pm1["2024.12.10"] = 1; lag_pm1["2025.01.14"] = -1
    caso("E3 lag +-1 ammesso", "PASSA", T(neg=_neg(esito="NON_CONFRONTABILE"), k0b=_k0b(lag_pm1)), ["9/9"])
    lag_2 = dict(ok_lag); lag_2["2025.01.14"] = 2
    caso("E4 lag 2 = fuori", "NON PASSA", T(neg=_neg(esito="NON_CONFRONTABILE"), k0b=_k0b(lag_2)), ["8/9"])
    caso("E5 K0b con un giorno mancante", "NON PASSA", T(neg=_neg(esito="NON_CONFRONTABILE"), k0b=_k0b({g: 0 for g in GIORNI9[:-1]})), ["K0b non ha UNA riga"])
    caso("E6 K0b NON sostituisce la (1): (1) cade e K0b perfetto", "NON PASSA",
         T(dk=_dk({"2024.11.20": _riga_g(SIM_DK, "2024.11.20", "0.07000000", "98.0000")}), neg=_neg("0.04500000"), k0b=_k0b(ok_lag)), ["2024.11.20  FUORI"])
    caso("E7 K0b NON sostituisce la (2): (2) cade e K0b perfetto", "NON PASSA",
         T(neg=_neg("0.04500000"), conf=_conf({"2024.10.29": ["2024.10.29", "100", "100", "A" * 64, "D" * 64, "NO"]}), k0b=_k0b(ok_lag)), ["2024.10.29  DIVERSO"])
    kb = _csv(COL_K0B, [["U30USD_DKNEG", g, "0", "0.9"] for g in GIORNI9])
    caso("E8 K0b del simbolo SBAGLIATO non vale", "NON PASSA", T(neg=_neg(esito="NON_CONFRONTABILE"), k0b=kb), ["K0b non ha UNA riga"])
    # --- file
    caso("F1 manca il file della sonda DK", "NON VALUTABILE", {F_DK: None, F_NEG: _neg(), F_CONF: _conf(), F_K0B: None})
    caso("F2 intestazione diversa", "NON VALUTABILE", {F_DK: "a,b,c\n1,2,3\n", F_NEG: _neg(), F_CONF: _conf(), F_K0B: None}, ["intestazione"])
    caso("F3 riga con colonne in meno", "NON VALUTABILE", {F_DK: _dk().rstrip("\n") + "\nx,y\n", F_NEG: _neg(), F_CONF: _conf(), F_K0B: None}, ["colonne"])
    caso("F4 file vuoto", "NON VALUTABILE", {F_DK: "", F_NEG: _neg(), F_CONF: _conf(), F_K0B: None}, ["vuoto"])

    # --- coerenza delle COSTANTI con il resto del repo (le liste a mano sono il punto debole: si ricalcolano)
    n += 1
    here = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, here)
    try:
        import dukascopy_tick as DT
        from datetime import datetime, timezone
        for g in ESTIVI5:
            d = datetime.strptime(g, "%Y.%m.%d").replace(hour=12, tzinfo=timezone.utc)
            if not DT.dst_usa_attivo(d):
                ko.append("costanti: %s e' in ESTIVI5 ma il DST USA non e' attivo" % g)
        for g in [x for x in GIORNI9 if x not in ESTIVI5]:
            d = datetime.strptime(g, "%Y.%m.%d").replace(hour=12, tzinfo=timezone.utc)
            if DT.dst_usa_attivo(d):
                ko.append("costanti: %s non e' in ESTIVI5 ma il DST USA e' attivo" % g)
            if d.weekday() >= 5:
                ko.append("costanti: %s non e' feriale" % g)
        for g in GIORNI9:
            if datetime.strptime(g, "%Y.%m.%d").weekday() >= 5:
                ko.append("costanti: %s non e' feriale" % g)
        if len(set(GIORNI9)) != 9 or len(ESTIVI5) != 5 or GIORNO_NEG not in ESTIVI5:
            ko.append("costanti: GIORNI9/ESTIVI5/GIORNO_NEG incoerenti")
        if "2024.11.20" in ESTIVI5:
            ko.append("costanti: 2024.11.20 e' l'unico invernale della sonda del 03/09, non puo' stare in ESTIVI5")
    except ImportError as e:
        ko.append("costanti: dukascopy_tick non importabile: %s" % e)
    # --- il testo F2 incorporato e' quello del piano (se il piano c'e')
    n += 1
    piano = os.path.abspath(os.path.join(here, "..", "..", "report", "PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md"))
    if os.path.exists(piano):
        trovato = None
        for riga in open(piano, encoding="utf-8").read().splitlines():
            if riga.startswith("> **\u00abFIRMO CANCELLO DK DOW\u00bb**"):
                trovato = riga.replace("\u00ab", '"').replace("\u00bb", '"')
        if trovato is None:
            ko.append("testo F2: l'appendice non e' stata trovata nel piano")
        else:
            # il piano usa +-, il nostro e' ASCII: confronto esatto dopo aver reso ASCII il solo carattere non ASCII del piano
            piano_txt = trovato.replace("\u00b1", "+-")
            if piano_txt != TESTO_F2_APPENDICE:
                # dove differiscono, per la diagnosi
                i = 0
                while i < min(len(piano_txt), len(TESTO_F2_APPENDICE)) and piano_txt[i] == TESTO_F2_APPENDICE[i]:
                    i += 1
                ko.append("testo F2: l'appendice incorporata DIFFERISCE dal piano alla posizione %d: ...%s... contro ...%s..." % (i, piano_txt[max(0, i - 30):i + 40], TESTO_F2_APPENDICE[max(0, i - 30):i + 40]))
    else:
        print("   (piano non presente accanto: controllo del testo F2 saltato)")
    for k in ko:
        print("  X " + k)
    print("AUTOTEST leggi_f2_dk: %d controlli, %s" % (n, "TUTTO OK" if not ko else "%d FALLITI" % len(ko)))
    return 0 if not ko else 1


def main(argv):
    if "--autotest" in argv:
        return autotest()
    if "--cartella" not in argv:
        print("uso: leggi_f2_dk.py --cartella DIR [--out FILE]   |   --autotest")
        return 2
    cart = argv[argv.index("--cartella") + 1]
    if not os.path.isdir(cart):
        print("cartella inesistente: " + cart)
        return 2
    esito, out = valuta(carica_cartella(cart))
    testo = "\n".join(out) + "\n"
    print(testo)
    if "--out" in argv:
        open(argv[argv.index("--out") + 1], "w", newline="").write(testo)
    return {"PASSA": 0, "NON PASSA": 1, "NON VALUTABILE": 2}[esito]


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
