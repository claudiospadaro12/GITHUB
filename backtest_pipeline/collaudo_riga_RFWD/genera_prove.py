#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
genera_prove.py -- costruisce i 7 file prova RFWD_*.txt dal FOTOGRAFIA DEL CAMPO e li verifica.

FONTE DEI VALORI: NON i .set del repo ma la foto dei grafici VIVI del terminale FTMO 541452707
(C:\\FTMO), letta da CODA_08 il 30/09/2026 03:30 (`.chr` del 28/09 07:43): e' quello che gira DAVVERO.
I .set FTMO del repo coincidono con quella foto (verificato qui sotto, riga per riga: 0 discordanze
sui cinque .set completi; EMA200 e SuperWave differiscono per input che il .set non porta, spiegati).

TRASFORMAZIONI, tutte e SOLE quelle dichiarate:
  1. orologio FTMO -> BCM, meno 2 ore, sui soli input orari elencati per sedia;
  2. InpUsaGuardian true -> false (il Guardian non c'e' nel tester: precedente TRAILFIX_*_pin.txt);
  3. InpCorrSymbol US500.cash -> SPXUSD (nome BCM);
  4. InpMagic diventa l'ASSE TECNICO a due celle (magic m e m+50: le gemelle per G1);
  5. i valori vuoti non si scrivono (il driver li salta, il default compilato e' vuoto).
Rischio (2,00), TP, trailing, filtri, tutto il resto: come nel campo.

VERIFICHE (l'esecuzione FALLISCE se una non torna):
  V1 (.chr con orologio -2h) contro l'ORIGINALE BCM del repo: le uniche differenze ammesse sono quelle
     dichiarate per sedia (rischio; 770105 = 770101 con i lati invertiti; Nasdaq TP1/BE del preset FTMO);
  V2 il .set FTMO del repo contro la foto: 0 discordanze salvo gli input citati;
  V3 l'orologio contro il FORWARD vero (xlsx): gli ordini pendenti della 770411 sono piazzati alle
     InpPlaceHour:InpPlaceMin FTMO e cancellati a InpEntryCutoff FTMO; gli ordini RETEST del DAX
     arrivano dopo apertura + range (10:00 + 35 min) e scadono a +InpPendingExpiryMin.
Uso: python3 backtest_pipeline/collaudo_riga_RFWD/genera_prove.py [--scrivi]
"""
import datetime, os, re, sys

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, "..", ".."))
sys.path.insert(0, os.path.join(REPO, "backtest_pipeline"))
import confronto_forward_tester as CF

CHR_LOG = "backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260930_033005.log"
XLSX = "data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx"

DA = "2026.09.14"
FINOA = "2026.10.01"
FRAZ = "0.38"
DELTA = 2


def parse_set(path):
    d = {}
    for ln in open(path, encoding="utf-8", errors="replace"):
        s = ln.strip()
        if not s or s.startswith(";") or s.startswith("#"):
            continue
        m = re.match(r"^([A-Za-z0-9_]+)=(.*)$", s)
        if m:
            d[m.group(1)] = m.group(2).split("||")[0].strip()
    return d


def parse_chr_log(path):
    txt = open(path, encoding="utf-8", errors="replace").read().replace("\r", "")
    i = txt.index("=== C:\\FTMO")
    j = txt.index("=== C:\\Program Files\\Pepperstone", i)
    out = {}
    for blk in re.split(r"\n--- SEDIA: ", txt[i:j])[1:]:
        head = blk.split("\n", 1)[0]
        m = re.match(r"(\S+)\s+su\s+(\S+)\s+magic\s+(\S+)\s+\[(chart\d+\.chr)\]", head)
        ea, sym, mg, chart = m.groups()
        d, ordine = {}, []
        for ln in blk.split("\n")[1:]:
            if ln.startswith(";") or not ln.strip():
                continue
            mm = re.match(r"^([A-Za-z0-9_]+)=(.*)$", ln.strip())
            if mm:
                d[mm.group(1)] = mm.group(2).strip()
                ordine.append(mm.group(1))
        out[mg] = dict(ea=ea, sym=sym, chart=chart, inp=d, ordine=ordine)
    return out


def norm(v):
    v = v.strip()
    try:
        return float(v)
    except Exception:
        return v.lower() if v.lower() in ("true", "false") else v


# per sedia: file prova, TF, input orari da spostare, originale BCM, differenze ammesse V1, .set FTMO, extra di HEAD
CFG = {
    "770411": dict(file="RFWD_770411_MAXMIN_DAX_short.txt", tf="M15",
                   ore=["InpBoxStartHour", "InpBoxEndHour", "InpPlaceHour", "InpEntryCutoffHour", "InpCloseHour"],
                   orig="mql5/Presets/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set",
                   ammesse={"InpRiskPercent"}, setftmo="ABTG_MaxMinNotte_DAX_Short_770411_FTMO.set", set_ok=set()),
    "770101": dict(file="RFWD_770101_DAX_RETEST_long.txt", tf="M5", ore=["InpSessionHour", "InpCloseHour"],
                   orig="mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set",
                   ammesse={"InpRiskPercent"}, setftmo="ABTG_DAX_Apertura_EU_770101_FTMO.set", set_ok=set()),
    "770105": dict(file="RFWD_770105_DAX_RETEST_short.txt", tf="M5", ore=["InpSessionHour", "InpCloseHour"],
                   orig="mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set",
                   ammesse={"InpRiskPercent", "InpAllowLong", "InpAllowShort", "InpMagic"},
                   setftmo="ABTG_DAX_Apertura_EU_770105_SHORT_FTMO.set", set_ok=set()),
    "771531": dict(file="RFWD_771531_EMA200_DOW.txt", tf="H1", ore=["InpCutoffHour", "InpFridayCloseHour"],
                   orig="mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set",
                   ammesse={"InpRiskPercent", "InpLogImbuto"}, setftmo="ABTG_EMA200_771531_FTMO.set",
                   set_ok={"InpLogImbuto"}),
    "770202": dict(file="RFWD_770202_DOW_APERTURA.txt", tf="M5", ore=["InpSessionHour", "InpCloseHour"],
                   orig="mql5/Presets/ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set",
                   ammesse={"InpRiskPercent"}, setftmo="ABTG_Dow_Apertura_US_770202_FTMO.set", set_ok=set()),
    "770260": dict(file="RFWD_770260_NASDAQ_RETEST.txt", tf="M5", ore=["InpSessionHour", "InpCloseHour"],
                   orig="mql5/Presets/ABTG_Nasdaq_Apertura_US_RETEST_770260.set",
                   ammesse={"InpRiskPercent", "InpBreakevenAtTP1", "InpTP1_ClosePct"},
                   setftmo="ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set", set_ok=set()),
    "770511": dict(file="RFWD_770511_SUPERWAVE_DOW.txt", tf="H1", ore=[],
                   orig="mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_SuperWave_DOW_H1_Ottimizzato_770511.set",
                   ammesse={"InpRiskPercent", "InpPendingAtr", "InpSLBufferAtr", "InpUsaGuardian"},
                   setftmo="ABTG_SuperWave_DOW_H1_770511_FTMO.set", set_ok={"InpPendingAtr", "InpSLBufferAtr", "InpUsaGuardian"}),
}

NOTE_SEDIA = {
    "770411": [
        "SEDIA-GUIDA. Forward: 3 posizioni in 7 giorni feriali (24/09 -1.668,46; 29/09 +968,37; 30/09 -1.535,91) e un sell stop 'canceled'",
        "il 25/09 (piazzato 09:59 FTMO, cancellato 10:30 = InpEntryCutoff). Contratto OOS ~0,03 pos/giorno (FTMO_PRIMI_OTTO_GIORNI par. 2.3;",
        "CONTRATTI_DELLE_SEDIE par. frequenze: 0,051): il forward e' ~8-14 volte sopra. Nota di contesto: sui demo BCM (piccolo e 100k) la stessa",
        "sedia mostra 0,50 e 0,57 pos/giorno su 10 e 7 giorni (CONTRATTI par. frequenze): il tasso alto NON e' solo di FTMO.",
        "ATTENZIONE, InpUseCorrelation=true su questa sedia (US500.cash su FTMO, SPXUSD su BCM): il filtro di correlazione LEGGE un secondo",
        "simbolo, quindi il feed dell'indice USA entra nella decisione. E' una differenza di feed che il tester non puo' eliminare.",
    ],
    "770101": [
        "Forward 770101 (long RETEST): 4 posizioni (24/09 +69,66; 25/09 -1.552,80; 28/09 +46,18; 29/09 +95,33) e 2 buy limit scaduti",
        "non riempiti (21/09 11:05, 22/09 12:43 FTMO, scadenza a +120 min). Contratto 0,699 pos/giorno.",
    ],
    "770105": [
        "Forward 770105 (short RETEST): attaccata il 28/09 (chart11.chr, CODA_01 del 29/09 03:30: prima non c'era). 1 posizione (28/09 +83,56).",
        "Prima del 28/09 questa sedia NON esisteva sul forward: il confronto la conta viva dal 28/09 (viva_da nello script). E' la STESSA",
        "EA della 770101 con i lati invertiti (InpAllowLong/InpAllowShort) e magic 770105: unica differenza dal .set 770101 (verificato V1).",
    ],
    "771531": [
        "Forward 771531 (EMA200 Dow H1, ordini limit S1/S2 a ogni apertura H1): 3 posizioni (22/09 due stop pieni -913,10 e -844,58;",
        "25/09 S1 +743,56 con parziale a 2,42 lotti) e diversi limit scaduti. Il sorgente in campo e' al pin 26a18566 (552 righe);",
        "il ramo lavoro ha 690 righe = pin + contatori 'IMBUTO' e InpLogImbuto (SOLO diagnostica, riletto sul diff riga per riga:",
        "ogni modifica e' un incremento di contatore o una graffa attorno a un return). Equivalenza LETTA, non misurata a macchina.",
        "InpLogImbuto non e' nella foto del campo (il binario non ce l'ha): qui vale il default compilato (true), solo log.",
    ],
    "770202": [
        "Forward 770202 (Dow Apertura long): NESSUNA operazione nei giorni (FTMO_PRIMI_OTTO_GIORNI par. 2.4). Contratto 0,348 pos/giorno.",
        "DIFFERENZA STRUTTURALE NON ELIMINABILE: InpUseEmaFilter=true su H4 (EMA 50): la griglia H4 e' ancorata alla mezzanotte del",
        "SERVER; BCM (UTC+1) e FTMO (UTC+3) hanno griglie H4 sfasate di 2 ore su un passo di 4: la EMA(50) H4 NON vale gli stessi numeri",
        "(mql5/Presets/FTMO/..._770202_FTMO.set e rimappa_preset_ftmo.py). Il tester BCM usa la griglia BCM: un'operazione in piu' o in",
        "meno su questa sedia puo' venire da qui e non dal codice.",
    ],
    "770260": [
        "Forward 770260 (Nasdaq RETEST, due lati): NESSUNA operazione. Giornale FTMO del 29/09 17:26 ora locale: 'RETEST SELL: rottura con",
        "volumi insufficienti, salto (regola Emiliano)' = filtro sul VOLUME dei tick, che dipende dal feed (tick FTMO contro tick BCM).",
        "Il preset FTMO ha TP1 50% e BreakevenAtTP1 (l'originale BCM RETEST_770260.set ha 0/false): la foto del campo lo conferma, si usa il campo.",
        "US100.cash su FTMO: decimali NON verificati (InpBufferPoints=200 e InpMinStopPts=500 sono in punti; su BCM NASUSD _Digits=2).",
    ],
    "770511": [
        "Forward 770511 (SuperWave DOW H1, ingresso a mercato + pendenti 2/3): NESSUNA operazione. Sorgente in campo al pin 872dba82",
        "(645 righe); il ramo lavoro (774) = pin + contatori IMBUTO (SOLO diagnostica, riletto sul diff). Equivalenza LETTA, non misurata.",
    ],
}


def cross_checks(chr_all, log):
    """V1 e V2. Ritorna (ok, righe_di_testo)."""
    ok = True
    out = []
    for m, cfg in CFG.items():
        ch = dict(chr_all[m]["inp"])
        bcm = dict(ch)
        for h in cfg["ore"]:
            bcm[h] = str((int(ch[h]) - DELTA) % 24)
        if "InpCorrSymbol" in bcm:
            bcm["InpCorrSymbol"] = "SPXUSD"
        orig = parse_set(os.path.join(REPO, cfg["orig"]))
        diff = []
        for k in sorted(set(orig) | set(bcm)):
            a, b = orig.get(k), bcm.get(k)
            if a is None or b is None or norm(a) != norm(b):
                diff.append((k, a, b))
        nuovi = [d for d in diff if d[0] not in cfg["ammesse"]]
        out.append("V1 %s: campo(-2h, SPXUSD) contro originale BCM %s: %d differenze, tutte ammesse: %s" %
                   (m, os.path.basename(cfg["orig"]), len(diff), "SI" if not nuovi else "NO -> " + str(nuovi)))
        for d in diff:
            out.append("     %-22s originale BCM=%-8s campo(-2h)=%s" % (d[0], d[1], d[2]))
        if nuovi:
            ok = False
        sf = parse_set(os.path.join(REPO, "mql5/Presets/FTMO", cfg["setftmo"]))
        dd = []
        for k in sorted(set(sf) | set(ch)):
            a, b = sf.get(k), ch.get(k)
            if a is None or b is None or norm(a) != norm(b):
                dd.append(k)
        strani = [k for k in dd if k not in cfg["set_ok"]]
        out.append("V2 %s: .set FTMO del repo contro la foto del campo: %d discordanze%s" % (m, len(dd), (" (" + ", ".join(dd) + ")") if dd else ""))
        if strani:
            ok = False
            out.append("     DISCORDANZE NON SPIEGATE: " + ", ".join(strani))
    return ok, out


def verifica_orologio(chr_all):
    """V3: l'orologio contro gli ORDINI VERI del forward. Ritorna (ok, righe)."""
    fw = CF.parse_forward(CF.leggi_xlsx(os.path.join(REPO, XLSX)))
    ok, out = True, []
    mm = chr_all["770411"]["inp"]
    ph, pm = int(mm["InpPlaceHour"]), int(mm["InpPlaceMin"])
    ch_, cm_ = int(mm["InpEntryCutoffHour"]), int(mm["InpEntryCutoffMin"])
    ordini = [o for o in fw["ordini"] if o["tipo"] == "sell stop" and o["sim"] == "GER40.cash" and re.search(r"MAXMIN DAX SHORT", o["commento"] or "")]
    ordini += [o for o in fw["ordini"] if o["tipo"] == "sell stop" and o["sim"] == "GER40.cash" and (o["commento"] or "") == "MAXMIN DAX SHORT SELL" and o not in ordini]
    for o in sorted(ordini, key=lambda x: x["t_open"]):
        t = o["t_open"]
        bcm = t - datetime.timedelta(hours=DELTA)
        # a volte il commento e' in "Ordini" con lo stato; ci basta l'orario di piazzamento
        good = (t.hour, t.minute) == (ph, pm)
        out.append("V3 770411 sell stop %d piazzato %s FTMO = %s BCM: atteso InpPlaceHour:Min FTMO %02d:%02d -> BCM %02d:%02d : %s" %
                   (o["id"], t.strftime("%Y.%m.%d %H:%M:%S"), bcm.strftime("%H:%M:%S"), ph, pm, (ph - DELTA) % 24, pm, "OK" if good else "NON TORNA"))
        ok &= good
        if o["stato"] == "canceled":
            fine = o["t_fine"]
            g2 = (fine.hour, fine.minute) == (ch_, cm_)
            out.append("V3 770411 ordine %d cancellato %s FTMO: atteso InpEntryCutoff FTMO %02d:%02d -> BCM %02d:%02d : %s" %
                       (o["id"], fine.strftime("%H:%M:%S"), ch_, cm_, (ch_ - DELTA) % 24, cm_, "OK" if g2 else "NON TORNA"))
            ok &= g2
    if len(ordini) < 4:
        ok = False
        out.append("V3 770411: attesi 4 sell stop nel forward, trovati %d" % len(ordini))
    d1 = chr_all["770101"]["inp"]
    ap = int(d1["InpSessionHour"]) * 60 + int(d1["InpSessionMin"]) + int(d1["InpRangeMinutes"])
    scad = int(d1["InpPendingExpiryMin"])
    lim = [o for o in fw["ordini"] if o["sim"] == "GER40.cash" and o["tipo"] == "buy limit"]
    for o in sorted(lim, key=lambda x: x["t_open"]):
        t = o["t_open"]
        mins = t.hour * 60 + t.minute
        g1 = mins >= ap
        durata = (o["t_fine"] - t).total_seconds() / 60.0 if o["t_fine"] and o["stato"] == "expired" else None
        g2 = True if durata is None else (scad - 1.0 <= durata <= scad + 0.01)
        out.append("V3 770101 buy limit %d piazzato %s FTMO = %s BCM: dopo apertura+range (%02d:%02d FTMO)? %s%s" %
                   (o["id"], t.strftime("%Y.%m.%d %H:%M:%S"), (t - datetime.timedelta(hours=DELTA)).strftime("%H:%M:%S"), ap // 60, ap % 60,
                    "OK" if g1 else "NON TORNA", ("; scade dopo %.1f min (atteso %d): %s" % (durata, scad, "OK" if g2 else "NON TORNA")) if durata is not None else ""))
        ok &= g1 and g2
    return ok, out


def scrivi(m, chr_all, comp):
    cfg = CFG[m]
    sd = CF.SEDIA_PER_ID[m]
    c = chr_all[m]
    ch = dict(c["inp"])
    tabora = []
    for h in cfg["ore"]:
        old = int(ch[h])
        new = (old - DELTA) % 24
        tabora.append((h, old, new, old - DELTA < 0))
        ch[h] = str(new)
    ch["InpUsaGuardian"] = "false"
    if "InpCorrSymbol" in ch:
        ch["InpCorrSymbol"] = "SPXUSD"
    ch.pop("InpMagic", None)
    L = []
    W = L.append
    W("#  EA: " + sd["ea"])
    W("# =====================================================================")
    W("#  RFWD %s -- %s: le operazioni del FORWARD FTMO 541452707 rigiocate nel TESTER BCM" % (m, sd["nome"]))
    W("#  Una sola domanda: nei giorni 21/09-30/09/2026 il tester fa le STESSE operazioni che la sedia ha fatto sul forward FTMO?")
    W("#  NON misura il merito, NON promuove, NON propone nessuna taglia, NON tocca preset, EA, sedie, conti. Nessun PF: il numero che")
    W("#  interessa e' quante posizioni escono, quando, a che prezzo (backtest_pipeline/confronto_forward_tester.py, criteri congelati in")
    W("#  report/RFWD_CRITERI.md PRIMA dei numeri).")
    W("#  Gira SOLO sul PC di backtest DESKTOP-H4D7CAJ (firma del 21/09/2026). MAI sul VPS, MAI su un terminale di conto.")
    W("#")
    W("#  DA DOVE VENGONO I VALORI")
    W("#   - la FOTO dei grafici vivi di C:\\FTMO (CODA_08 del 30/09/2026 03:30, .chr del 28/09 07:43, %d input, sedia %s magic %s su %s):" %
      (len(c["inp"]), m, m, c["sym"]))
    W("#     e' quello che gira davvero. Coincide col .set FTMO del repo (verifica V2 di genera_prove.py).")
    W("#   - sorgente in campo: CLAU12_* compilati da ABTG_* ai pin di mql5/Experts (righe/SCHIERA_FTMO.ps1, tavola $SORGENTI); i pin e le")
    W("#     impronte sono nel report RFWD_CRITERI par. 3. Qui l'EA compilato e' %s." % sd["ea"])
    W("#")
    W("#  QUATTRO TRASFORMAZIONI, e nient'altro (tutte dichiarate):")
    W("#   1. OROLOGIO: FTMO (UTC+3 d'estate) = BCM + 2 ore (report/OROLOGIO_BCM_2026-09-24.md; BCM = UTC+1 fisso). Input orari spostati di -2:")
    if tabora:
        for (h, old, new, wrap) in tabora:
            W("#        %-20s FTMO %2d -> BCM %2d%s" % (h, old, new, "   (attraversa la mezzanotte: e' il giorno PRIMA, l'EA lo gestisce: ComputeBox r.203-206)" if wrap else ""))
    else:
        W("#        nessuno: la sedia non ha finestra oraria (InpUseTimeWindow=false; InpStartHour=0 / InpEndHour=24 = tutto il giorno, invariante).")
    W("#      Le griglie H1 e M15 sono identiche fra i due server (sfasamento 2h = multiplo del passo). La griglia H4 NO (vedi sotto).")
    W("#   2. InpUsaGuardian true -> false: nel tester il Guardian non gira (precedente prove/TRAILFIX_*_pin.txt). Nel forward il Guardian c'era:")
    W("#      puo' aver RIFIUTATO ingressi che il tester fa. Non e' misurabile da qui: e' un limite dichiarato.")
    W("#   3. InpCorrSymbol US500.cash -> SPXUSD (nome BCM)%s." % ("; ATTENZIONE su questa sedia il filtro e' ACCESO" if m == "770411" else "; inerte (InpUseCorrelation=false)"))
    W("#   4. InpMagic = ASSE TECNICO a 2 celle (%d e %d): le due gemelle servono per G1 (identiche al centesimo) e perche' con Optimization=1" %
      (sd["magic"], sd["twin"]))
    W("#      e zero assi il driver non esegue nessuna passata (classe 134). Il per-trade della gamba OOS resta in Common\\Files.")
    W("#   RISCHIO: InpRiskPercent=%s come nel campo (2,00%%), deposito 80000 EUR in riga di lancio (= il conto FTMO da 80k). NON e' una taglia" % ch.get("InpRiskPercent", "?"))
    W("#   proposta: replica il forward. Il tester non ha lo stesso saldo corrente, quindi R e' 'nominale' (netto / (rischio% x saldo)).")
    W("#")
    W("#  CONTROLLI GIA' FATTI SU QUESTA PROVA (genera_prove.py, esito in RFWD_CRITERI par. 4):")
    W("#   V1 (foto - 2h) contro l'originale BCM del repo: differenze SOLO: %s." % ", ".join(sorted(cfg["ammesse"])))
    W("#   V2 .set FTMO del repo contro la foto: 0 discordanze%s." % (" salvo " + ", ".join(sorted(cfg["set_ok"])) if cfg["set_ok"] else ""))
    if m == "770411":
        W("#   V3 orologio contro gli ORDINI VERI del forward: ESATTO (4 sell stop piazzati alle 09:59:0x FTMO = InpPlaceHour:Min; il cancellato del 25/09 alle")
        W("#      10:30:00 FTMO = InpEntryCutoff): l'ora del xlsx e' la stessa dell'EA (ora server) e il BCM e' quella meno 2 ore (07:59 / 08:30).")
    if m in ("770101", "770105"):
        W("#   V3 orologio contro gli ORDINI VERI del forward: COMPATIBILE (6 buy limit, tutti dopo apertura+range = 10:35 FTMO, scadenza a +120 min):")
        W("#      condizione NECESSARIA, non sufficiente (non distingue una sessione alle 10:00 da una alle 09:00). La prova forte e' la foto (InpSessionHour=10).")
    W("#")
    W("#  FINESTRA (il tester tratta la data di fine come ESCLUSIVA: 'fine esclusiva' in TRAILFIX_*_pin.txt, R250: '2026.06.30 = ultima 06.29')")
    W("#   @DAQUANDO %s @FINOA %s @FRAZIONEIS %s -> Meta = %s + floor(17 x %s) giorni = 2026.09.20:" % (DA, FINOA, FRAZ, DA, FRAZ))
    W("#     gamba IS  2026.09.14 -> 2026.09.20 (fine esclusiva): 'riscaldamento', e' la settimana PRIMA della challenge;")
    W("#     gamba OOS 2026.09.21 -> 2026.10.01 (fine esclusiva) = i giorni del forward 21/09-30/09 COMPRESO il 30/09 intero.")
    W("#   Il per-trade e' UNO SOLO per magic e la gamba OOS (seconda) sovrascrive la IS: cio' che resta in Common\\Files e' la finestra del forward.")
    W("#   DEVIAZIONE DAL COMPITO, dichiarata: il compito diceva @DAQUANDO 2026.09.22 @FINOA 2026.09.30. Con FINOA esclusivo il 30/09 non ci sarebbe")
    W("#   (e il 30/09 ha il caso piu' importante: -1.535,91 della 770411); DAQUANDO 21/09 aggiunge il primo giorno vivo del forward (ordini 21/09).")
    W("#   Il confronto ufficiale resta 22-30/09; il 21/09 e' riportato a parte. Modello 4 (tick reali): i tick BCM degli indici partono dal 2024.09.26.")
    W("#   [NON MISURATO] che il PC di backtest abbia i tick BCM fino al 30/09: R248 (25/09) ha girato fino al 18/09; il tester li scarica dal")
    W("#   server BCM se il terminale e' collegato (giornale del tester: 'ticks synchronization completed').")
    W("#   Il forward xlsx e' l'ultimo evento 30/09 10:03:09 FTMO = 08:03:09 BCM: le operazioni del tester dopo quell'ora NON si confrontano.")
    W("#")
    W("#  DIFFERENZE FEED / MERCATO CHE IL TESTER NON PUO' TOGLIERE (RFWD_CRITERI par. 6): simbolo (%s FTMO contro %s BCM), spread,"
      % (sd["sim_f"], sd["sim_t"]))
    W("#  slippage, rifiuti di modify di FTMO (report/MODIFY_A_RAFFICA_FTMO_2026-09-25.md), volumi dei tick, Guardian, saldo corrente.")
    W("#")
    for l in NOTE_SEDIA[m]:
        W("#  " + l)
    W("#")
    W("#  ATTESE, SCRITTE PRIMA DEI NUMERI: in report/RFWD_CRITERI.md par. 5 (H_FEDELI contro H_DIVERSI, soglie e controesempio).")
    W("# =====================================================================")
    W("@SIMBOLO    %s" % sd["sim_t"])
    W("@PERIODO    %s" % cfg["tf"])
    W("@DAQUANDO   %s" % DA)
    W("@FINOA      %s" % FINOA)
    W("@FRAZIONEIS %s" % FRAZ)
    W("")
    W("# --- input della foto del campo (ordine del campo), con le trasformazioni sopra ---")
    saltati = []
    for k in c["ordine"]:
        if k == "InpMagic":
            continue
        v = ch[k]
        if v == "":
            saltati.append(k)
            continue
        W("%s=%s" % (k, v))
    if saltati:
        W("# (valori vuoti NON scritti, il driver li salta e il default compilato e' vuoto: %s)" % ", ".join(saltati))
    W("#")
    W("# --- L'UNICO ASSE: magic tecnico a due celle (gemelle) ---")
    W("InpMagic=%d||%d||50||%d||Y" % (sd["magic"], sd["magic"], sd["twin"]))
    W("# ======================================================================")
    return "\n".join(L) + "\n", saltati, tabora


def main():
    scrivi_file = "--scrivi" in sys.argv
    chr_all = parse_chr_log(os.path.join(REPO, CHR_LOG))
    log = []
    ok1, o1 = cross_checks(chr_all, log)
    ok3, o3 = verifica_orologio(chr_all)
    for r in o1 + o3:
        print(r)
    tot_ok = ok1 and ok3
    for m in CFG:
        testo, saltati, tabora = scrivi(m, chr_all, None)
        testo.encode("ascii")
        p = os.path.join(REPO, "backtest_pipeline", "prove", CFG[m]["file"])
        if scrivi_file:
            open(p, "w", newline="\n").write(testo)
            print("scritto", p, len(testo), "byte")
        else:
            esiste = os.path.exists(p) and open(p, newline="").read() == testo
            print("prova", CFG[m]["file"], "IDENTICA al disco" if esiste else "DIVERSA/ASSENTE sul disco")
    print("VERIFICHE V1/V2/V3:", "TUTTE OK" if tot_ok else "FALLITE")
    sys.exit(0 if tot_ok else 1)


if __name__ == "__main__":
    main()
