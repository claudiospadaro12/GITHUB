#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
===========================================================================
 ANALISI DELLA GRIGLIA H4  --  BCM contro FTMO
 20/09/2026
===========================================================================

IL PROBLEMA, e non e' un'opinione: sta scritto nel preset
-----------------------------------------------------------------------
mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770202_FTMO.set r.40-48:

    questa sedia ha InpUseEmaFilter=true su InpFilterTF=16388 (H4).
    La GRIGLIA delle candele H4 e' ancorata alla mezzanotte del SERVER:
      BCM  (UTC+1) -> H4 aperte alle 23,03,07,11,15,19 UTC
      FTMO (UTC+3) -> H4 aperte alle 21,01,05,09,13,17 UTC
    Sono griglie DIVERSE (2h di sfasamento su un passo di 4h).

Verificato nel sorgente (mql5/Experts/ABTG_Dow_Apertura_US.mq5):
  r.405-406  iMA(_Symbol, InpFilterTF, InpEmaFast, 0, MODE_EMA, PRICE_CLOSE)
             e iMA(..., InpEmaSlow, ...)
  r.1495-1502 CopyBuffer(gEmaFastH, 0, 1, 1, f) -- shift 1 = ULTIMA BARRA
             CHIUSA; e = (f>s ? +1 : (f<s ? -1 : 0))
  r.885-887  bias = TrendBias(); longOK = (bias == 0 || bias == +1)
Preset 770202 FTMO: InpEmaFast=1, InpEmaSlow=50, InpFilterTF=16388 (H4),
  InpAllowLong=true, InpAllowShort=FALSE  -> SEDIA SOLO-LONG,
  InpSessionHour=16 InpSessionMin=30 (ora FTMO) = 14:30 BCM = 13:30 UTC,
  InpRangeMinutes=35 -> i pendenti si piazzano alle 15:05 BCM = 14:05 UTC.
  Nel preset gli altri filtri di bias sono TUTTI SPENTI (InpUseSupertrend,
  InpUseSupertrend3, InpUseCorrelation, InpUseVwapFilter = false), quindi
  il bias e' DECISO SOLO dalla EMA su H4. Non c'e' nessun altro addendo.

  EMA(1) NON e' una media: con periodo 1 il coefficiente e' 2/(1+1)=1,
  quindi EMA(1) == la CHIUSURA della barra. Il filtro e', alla lettera,
  "chiusura dell'ultima H4 chiusa contro EMA(50) delle chiusure H4".

  Su una sedia SOLO-LONG, bias -1 non peggiora l'ingresso: lo CANCELLA
  (longOK diventa false e nessun BUY STOP viene piazzato).

LA ROBUSTEZZA CHE RENDE LA MISURA SOLIDA, ed e' un fatto aritmetico
-----------------------------------------------------------------------
  griglia BCM  : barra in formazione alle 14:05 UTC = quella aperta 11:00,
                 ultima CHIUSA = quella che ha chiuso alle 11:00 UTC;
  griglia FTMO : barra in formazione = quella aperta 13:00,
                 ultima CHIUSA = quella che ha chiuso alle 13:00 UTC.
  Le due barre decisive restano LE STESSE per qualunque istante di
  ingresso dentro [13:00, 15:00) UTC. Quindi il risultato NON dipende dal
  fatto che si usi 13:30 (ora di sessione) o 14:05 (ora del piazzamento):
  un errore di mezz'ora su quell'ora non sposta niente.

L'INTUIZIONE CHE RENDE LA MISURA FACILE (non e' mia, ed e' buona)
-----------------------------------------------------------------------
  Una barra H4 e' l'unione di 4 barre H1. Due griglie sfalsate di 2 ore
  sono DUE RAGGRUPPAMENTI DELLA STESSA SERIE H1. Serve percio' UNA SOLA
  esportazione H1 del Dow, e il resto si fa offline, qui.

L'ATTESA, SCRITTA PRIMA DI GUARDARE I DATI (obbligo di casa)
-----------------------------------------------------------------------
  Attesa: bias OPPOSTO nel 10-20% delle sedute.
  Perche': le due griglie hanno una EMA(50) quasi identica (stessa serie,
  campionata sfalsata: mezza vita ~17 barre H4 ~ 2,8 giorni), quindi la
  differenza la fa quasi tutta la CHIUSURA -- prezzo delle 11:00 UTC
  contro prezzo delle 13:00 UTC. Su U30USD un movimento di 2 ore attorno
  alla pre-apertura USA vale tipicamente 0,25-0,40%, mentre la distanza
  |chiusura - EMA50| sta tipicamente attorno all'1%. Un disaccordo
  succede solo quando il prezzo sta gia' a ridosso della EMA50 e lo
  scarto di 2 ore basta a scavalcarla: circa (2h di movimento)/(tipica
  distanza) x densita' vicino allo zero ~ 0,15.

  IL RISULTATO CHE MI FAREBBE DIRE "IL PROBLEMA NON ESISTE":
    discordanza SOTTO IL 3% delle sedute (meno di una seduta al mese).
    A quel punto lo sfasamento della griglia e' rumore rispetto alla
    varianza normale della sedia, e i preset non si toccano.
  IL RISULTATO CHE MI FAREBBE DIRE "E' UN'ALTRA STRATEGIA":
    discordanza SOPRA IL 25%: una seduta su quattro in cui il filtro dice
    il contrario non e' la stessa sedia che e' stata validata.
  In mezzo (3-25%) il verdetto e': si schiera DICHIARANDO lo scarto, e la
  frequenza attesa su FTMO va corretta della quota di sedute perse.

COLLAUDO
-----------------------------------------------------------------------
  python3 backtest_pipeline/analisi_griglia_h4.py --autocollaudo
  costruisce serie H1 SINTETICHE in cui la risposta e' nota PER
  COSTRUZIONE e verifica che l'analizzatore tiri fuori quel numero.
  Senza questo collaudo lo script non si consegna.
"""

import argparse
import csv
import io
import os
import re
import sys
from datetime import datetime, timedelta

ORA = 3600
H4 = 4 * ORA


# ==========================================================================
# LETTURA DEL CSV H1
# ==========================================================================

_SEP_CANDIDATI = ["\t", ";", ",", " "]

_FMT_DATA = [
    "%Y.%m.%d", "%Y-%m-%d", "%Y/%m/%d",
    "%d.%m.%Y", "%d/%m/%Y", "%d-%m-%Y",
]
_FMT_ORA = ["%H:%M:%S", "%H:%M"]


def _prova_data(testo):
    t = testo.strip().strip('"')
    for f in _FMT_DATA:
        try:
            return datetime.strptime(t, f)
        except ValueError:
            pass
    return None


def _prova_dataora(testo):
    """Una colonna sola che contiene data E ora."""
    t = testo.strip().strip('"').replace("T", " ")
    for fd in _FMT_DATA:
        for fo in _FMT_ORA:
            try:
                return datetime.strptime(t, fd + " " + fo)
            except ValueError:
                pass
    return None


def _prova_ora(testo):
    t = testo.strip().strip('"')
    for f in _FMT_ORA:
        try:
            x = datetime.strptime(t, f)
            return timedelta(hours=x.hour, minutes=x.minute, seconds=x.second)
        except ValueError:
            pass
    return None


def _numero(testo):
    t = testo.strip().strip('"').replace(" ", "")
    if not t:
        return None
    # separatore decimale a virgola solo se non c'e' gia' un punto
    if "," in t and "." not in t:
        t = t.replace(",", ".")
    try:
        return float(t)
    except ValueError:
        return None


def indovina_separatore(righe):
    """
    Il separatore lo SCEGLIE il numero di colonne, non il mio gusto:
    MT5 esporta con TAB (Ctrl+S sul grafico e Ctrl+U -> Barre -> Esporta),
    ma un passaggio da Excel puo' trasformarlo in ; o in ,. Si prova e si
    tiene quello che da' piu' colonne COSTANTI su tutte le righe.
    """
    migliore, punteggio = None, -1
    for sep in _SEP_CANDIDATI:
        conte = []
        for r in righe:
            if sep == " ":
                conte.append(len(r.split()))
            else:
                conte.append(len(r.split(sep)))
        if not conte:
            continue
        n = max(set(conte), key=conte.count)
        if n < 5:
            continue
        costanti = sum(1 for c in conte if c == n)
        p = costanti * 100 + n
        if p > punteggio:
            migliore, punteggio = sep, p
    return migliore


def leggi_h1(percorso):
    """
    Torna una lista ORDINATA di (datetime_naive_ora_server, close).
    Regge i due export di MT5 (con e senza intestazione, con colonna data
    e ora separate o unite) e l'eventuale passaggio da Excel.
    """
    with io.open(percorso, "r", encoding="utf-8", errors="replace") as f:
        testo = f.read()
    righe = [r for r in testo.replace("\r\n", "\n").replace("\r", "\n").split("\n")
             if r.strip()]
    if len(righe) < 10:
        raise SystemExit("ERRORE: il file ha meno di 10 righe utili: non e' un export H1.")

    sep = indovina_separatore(righe[:200])
    if sep is None:
        raise SystemExit("ERRORE: non riconosco il separatore del CSV (provati TAB ; , e spazio).")

    def campi(r):
        return r.split() if sep == " " else [c.strip().strip('"') for c in r.split(sep)]

    # L'INTESTAZIONE: MT5 scrive <DATE> <TIME> <OPEN>... ma non sempre.
    # Non mi fido del nome: mi fido del fatto che la PRIMA riga non si
    # riesca a leggere come data. E' un test, non una convenzione.
    intest = None
    c0 = campi(righe[0])
    if _prova_data(c0[0]) is None and _prova_dataora(c0[0]) is None:
        intest = [c.lower().strip("<>") for c in c0]
        righe = righe[1:]

    # dove stanno data, ora e chiusura
    c0 = campi(righe[0])
    if _prova_dataora(c0[0]) is not None:
        i_data, i_ora = 0, None
        primo_dato = 1
    elif _prova_data(c0[0]) is not None and len(c0) > 1 and _prova_ora(c0[1]) is not None:
        i_data, i_ora = 0, 1
        primo_dato = 2
    elif _prova_data(c0[0]) is not None:
        i_data, i_ora = 0, None
        primo_dato = 1
    else:
        raise SystemExit("ERRORE: la prima colonna non e' una data riconoscibile: %r" % (c0[0],))

    # la CHIUSURA: se c'e' l'intestazione la cerco per nome; altrimenti e'
    # la quarta colonna numerica dopo data/ora (open, high, low, CLOSE).
    i_close = None
    if intest:
        for nome in ("close", "chiusura"):
            if nome in intest:
                i_close = intest.index(nome)
                break
    if i_close is None:
        numeriche = [i for i in range(primo_dato, len(c0)) if _numero(c0[i]) is not None]
        if len(numeriche) < 4:
            raise SystemExit("ERRORE: mi servono almeno 4 colonne numeriche (O H L C), ne vedo %d."
                             % len(numeriche))
        i_close = numeriche[3]

    barre = []
    scartate = 0
    for r in righe:
        c = campi(r)
        if len(c) <= max(i_close, i_data, i_ora if i_ora is not None else 0):
            scartate += 1
            continue
        if i_ora is None:
            dt = _prova_dataora(c[i_data])
            if dt is None:
                d = _prova_data(c[i_data])
                dt = d
        else:
            d = _prova_data(c[i_data])
            o = _prova_ora(c[i_ora])
            dt = (d + o) if (d is not None and o is not None) else None
        px = _numero(c[i_close])
        if dt is None or px is None:
            scartate += 1
            continue
        barre.append((dt, px))

    barre.sort(key=lambda x: x[0])
    # doppioni: tengo l'ultimo
    pulite = []
    for dt, px in barre:
        if pulite and pulite[-1][0] == dt:
            pulite[-1] = (dt, px)
        else:
            pulite.append((dt, px))
    return pulite, sep, scartate


def controlla_h1(barre):
    """
    CONTRO-ESEMPIO: se qualcuno esporta per sbaglio M30 o H4, i gruppi da
    4 non sono piu' barre H4 e TUTTO il risultato e' falso senza che si
    veda. Quindi il passo si MISURA e si rifiuta se non e' 3600 s.
    """
    if len(barre) < 100:
        raise SystemExit("ERRORE: solo %d barre: troppo poche per misurare qualsiasi cosa." % len(barre))
    delta = {}
    for i in range(1, len(barre)):
        d = int((barre[i][0] - barre[i - 1][0]).total_seconds())
        delta[d] = delta.get(d, 0) + 1
    modale = max(delta, key=delta.get)
    quota = delta[modale] / float(len(barre) - 1)
    if modale != ORA:
        raise SystemExit(
            "ERRORE: il passo piu' frequente fra due barre e' %d s (%.0f%% dei casi), non 3600 s.\n"
            "        Questo NON e' un export H1. Rifiuto: con un TF sbagliato i gruppi da 4\n"
            "        non sono barre H4 e il risultato sarebbe falso senza dare segno."
            % (modale, 100 * quota))
    # allineamento all'ora piena
    fuori = sum(1 for dt, _ in barre if dt.minute != 0 or dt.second != 0)
    if fuori > 0:
        raise SystemExit("ERRORE: %d barre non sono allineate all'ora piena: la griglia H4 non si puo' ricostruire."
                         % fuori)
    return modale, quota


# ==========================================================================
# LE DUE GRIGLIE H4
# ==========================================================================

def ore_assolute(dt):
    """Ore intere dal 1970-01-01 00:00 letto come ORA DEL SERVER (naive).
    1970-01-01 00:00 e' una mezzanotte, quindi floor(h/4) da' bucket che
    partono esattamente alle 00,04,08,12,16,20 locali: e' l'ancoraggio di
    MT5 (griglia H4 agganciata alla mezzanotte del SERVER)."""
    return int((dt - datetime(1970, 1, 1)).total_seconds()) // ORA


def costruisci_h4(barre, sfasamento_ore):
    """
    Raggruppa le barre H1 nei secchi H4 di UNA griglia.
    sfasamento_ore = di quante ore il server di QUELLA griglia e' avanti
    rispetto al server del CSV. Il secchio e' floor((h + sfasamento)/4):
    con sfasamento 2 i secchi partono alle 22,02,06,10,14,18 del server
    del CSV -- cioe' 21,01,05,09,13,17 UTC se il CSV e' UTC+1. Che e'
    esattamente quello che c'e' scritto nel preset FTMO.

    Torna: lista ordinata di (fine_secchio_datetime, chiusura_h4).
    La CHIUSURA H4 e' la chiusura dell'ULTIMA barra H1 presente nel
    secchio (come MT5: un secchio senza tick non esiste proprio).
    """
    secchi = {}
    for dt, px in barre:
        k = (ore_assolute(dt) + sfasamento_ore) // 4
        vecchio = secchi.get(k)
        if vecchio is None or dt > vecchio[0]:
            secchi[k] = (dt, px)
    fuori = []
    for k in sorted(secchi):
        inizio = datetime(1970, 1, 1) + timedelta(hours=(k * 4 - sfasamento_ore))
        fine = inizio + timedelta(hours=4)
        fuori.append((fine, secchi[k][1]))
    return fuori


def ema_come_mt5(valori, periodo):
    """
    La EMA come la calcola iMA di MT5: primo valore = SMA dei primi
    `periodo`, poi ricorsione con k = 2/(periodo+1).
    Con periodo 1: k = 1 e la EMA COINCIDE con la chiusura -- che e'
    esattamente quello che fa InpEmaFast=1 nella sedia.
    Torna una lista lunga quanto `valori`, con None dove la EMA non
    esiste ancora.
    """
    n = len(valori)
    out = [None] * n
    if periodo <= 0 or n < periodo:
        return out
    k = 2.0 / (periodo + 1.0)
    somma = sum(valori[:periodo])
    out[periodo - 1] = somma / float(periodo)
    for i in range(periodo, n):
        out[i] = valori[i] * k + out[i - 1] * (1.0 - k)
    return out


class Griglia(object):
    """Una griglia H4 con le sue due EMA, pronta a rispondere alla
    domanda 'che bias avevi all'istante T?'."""

    def __init__(self, nome, barre_h1, sfasamento_ore, per_veloce, per_lenta):
        self.nome = nome
        self.sfasamento = sfasamento_ore
        self.barre = costruisci_h4(barre_h1, sfasamento_ore)
        chiusure = [c for _, c in self.barre]
        self.fini = [f for f, _ in self.barre]
        self.ema_v = ema_come_mt5(chiusure, per_veloce)
        self.ema_l = ema_come_mt5(chiusure, per_lenta)

    def indice_ultima_chiusa(self, istante):
        """L'ultima barra il cui SECCHIO E' GIA' FINITO all'istante dato.
        E' lo shift 1 di CopyBuffer: la barra in formazione non si legge."""
        lo, hi, res = 0, len(self.fini) - 1, -1
        while lo <= hi:
            mid = (lo + hi) // 2
            if self.fini[mid] <= istante:
                res = mid
                lo = mid + 1
            else:
                hi = mid - 1
        return res

    def bias(self, istante):
        """
        Riproduce ABTG_Dow_Apertura_US.mq5 r.1495-1502:
          e = (veloce > lenta) ? +1 : (veloce < lenta ? -1 : 0)
        Torna (bias, indice, veloce, lenta) oppure (None, ...) se la EMA
        non e' ancora disponibile (riscaldamento).
        """
        i = self.indice_ultima_chiusa(istante)
        if i < 0:
            return None, i, None, None
        v, l = self.ema_v[i], self.ema_l[i]
        if v is None or l is None:
            return None, i, v, l
        if v > l:
            return +1, i, v, l
        if v < l:
            return -1, i, v, l
        return 0, i, v, l


# ==========================================================================
# IL CONFRONTO SEDUTA PER SEDUTA
# ==========================================================================

class Esito(object):
    def __init__(self):
        self.sedute = []          # dict per seduta
        self.saltate_riscaldamento = 0
        self.saltate_mercato_chiuso = 0


def confronta(barre, ora_ingresso, minuti_range, sfasamento_ftmo,
              per_veloce, per_lenta, riscaldamento, da=None, a=None):
    g_bcm = Griglia("BCM", barre, 0, per_veloce, per_lenta)
    g_ftmo = Griglia("FTMO", barre, sfasamento_ftmo, per_veloce, per_lenta)

    # indice rapido delle barre H1 per (giorno, ora): serve per sapere se
    # il mercato era davvero aperto in quella seduta. Una seduta senza
    # barre e' una seduta in cui la sedia non avrebbe fatto NIENTE, e
    # contarla falserebbe la percentuale (denominatore gonfiato).
    presenti = set(dt for dt, _ in barre)

    giorni = sorted(set(dt.date() for dt, _ in barre))
    es = Esito()

    hh, mm = ora_ingresso
    for g in giorni:
        if da is not None and g < da:
            continue
        if a is not None and g > a:
            continue
        apertura = datetime(g.year, g.month, g.day, hh, mm)
        istante = apertura + timedelta(minutes=minuti_range)

        # mercato aperto in quella sessione? deve esistere la barra H1 che
        # contiene l'ora di apertura della sessione.
        barra_sessione = datetime(g.year, g.month, g.day, hh, 0)
        if barra_sessione not in presenti:
            es.saltate_mercato_chiuso += 1
            continue

        b1, i1, v1, l1 = g_bcm.bias(istante)
        b2, i2, v2, l2 = g_ftmo.bias(istante)
        if b1 is None or b2 is None or i1 < riscaldamento or i2 < riscaldamento:
            es.saltate_riscaldamento += 1
            continue

        long_bcm = (b1 in (0, +1))
        long_ftmo = (b2 in (0, +1))
        es.sedute.append({
            "data": g,
            "istante": istante,
            "close_bcm": g_bcm.barre[i1][1],
            "fine_bcm": g_bcm.barre[i1][0],
            "ema50_bcm": l1,
            "close_ftmo": g_ftmo.barre[i2][1],
            "fine_ftmo": g_ftmo.barre[i2][0],
            "ema50_ftmo": l2,
            "bias_bcm": b1,
            "bias_ftmo": b2,
            "long_bcm": long_bcm,
            "long_ftmo": long_ftmo,
            "margine_bcm": abs(v1 - l1),
            "margine_ftmo": abs(v2 - l2),
        })
    return es, g_bcm, g_ftmo


def riassumi(es):
    n = len(es.sedute)
    entrambe = sum(1 for s in es.sedute if s["long_bcm"] and s["long_ftmo"])
    nessuna = sum(1 for s in es.sedute if not s["long_bcm"] and not s["long_ftmo"])
    solo_bcm = sum(1 for s in es.sedute if s["long_bcm"] and not s["long_ftmo"])
    solo_ftmo = sum(1 for s in es.sedute if s["long_ftmo"] and not s["long_bcm"])
    disc = solo_bcm + solo_ftmo
    operative = entrambe + disc
    return {
        "n": n,
        "entrambe_long": entrambe,
        "nessuna_long": nessuna,
        "solo_bcm": solo_bcm,
        "solo_ftmo": solo_ftmo,
        "discordi": disc,
        "operative": operative,
        "pct_discordi": (100.0 * disc / n) if n else 0.0,
        "pct_discordi_su_operative": (100.0 * disc / operative) if operative else 0.0,
        "pct_entrambe": (100.0 * entrambe / n) if n else 0.0,
        "pct_nessuna": (100.0 * nessuna / n) if n else 0.0,
    }


# ==========================================================================
# IL COLLAUDO SU DATI SINTETICI
# ==========================================================================

def serie_sintetica(tipi_per_giorno, base=1000.0, ampiezza=10.0,
                    giorni_riscaldamento=400, inizio=datetime(2020, 1, 6)):
    """
    Costruisce una serie H1 in cui la risposta e' NOTA PER COSTRUZIONE.

    COME, e perche' funziona (e' aritmetica, non fortuna):
      - griglia BCM  (sfasamento 0): il secchio decisivo alle 15:05 e'
        08:00-12:00 locali, e la sua chiusura e' la barra H1 delle 11:00;
      - griglia FTMO (sfasamento 2): il secchio decisivo e' 10:00-14:00
        locali, e la sua chiusura e' la barra H1 delle 13:00.
      Le due barre sono DIVERSE e ognuna chiude UN SOLO secchio:
        * la barra delle 11:00 sta anche dentro il secchio FTMO 10-14 ma
          NON ne e' la chiusura -> non tocca la EMA di FTMO;
        * la barra delle 13:00 sta anche dentro il secchio BCM 12-16 ma
          quel secchio chiude alle 15:00 (barra piatta) -> non tocca la
          EMA di BCM.
      Quindi posso decidere il bias di ogni griglia, giorno per giorno,
      scrivendo un solo numero.

      Tutto il resto della serie sta a `base`, quindi la EMA(50) di
      tutte e due le griglie resta incollata a `base` (la deriva di
      regime e' < 2,0 con ampiezza 10: margine > 8, si verifica a valle).

    tipi_per_giorno: lista di 'DIV' | 'ENTRAMBE' | 'NESSUNA' | 'PIATTO'
    """
    barre = []
    giorno = inizio
    # riscaldamento tutto piatto
    da_fare = ["PIATTO"] * giorni_riscaldamento + list(tipi_per_giorno)
    attesi = []
    primo_test = None
    for tipo in da_fare:
        while giorno.weekday() >= 5:          # sabato/domenica: mercato chiuso
            giorno += timedelta(days=1)
        for h in range(24):
            px = base
            if h == 11:                       # chiusura del secchio BCM 08-12
                if tipo == "DIV":
                    px = base + ampiezza
                elif tipo == "ENTRAMBE":
                    px = base + ampiezza
                elif tipo == "NESSUNA":
                    px = base - ampiezza
            elif h == 13:                     # chiusura del secchio FTMO 10-14
                if tipo == "DIV":
                    px = base - ampiezza
                elif tipo == "ENTRAMBE":
                    px = base + ampiezza
                elif tipo == "NESSUNA":
                    px = base - ampiezza
            barre.append((datetime(giorno.year, giorno.month, giorno.day, h, 0), px))
        if tipo != "PIATTO":
            attesi.append((giorno.date(), tipo))
            if primo_test is None:
                primo_test = giorno.date()
        giorno += timedelta(days=1)
    return barre, attesi, primo_test


def _caso(nome, tipi, atteso_disc, atteso_entrambe, atteso_nessuna,
          sfasamento=2, note=""):
    barre, attesi, primo = serie_sintetica(tipi)
    # --da sul primo giorno COSTRUITO: i 400 giorni piatti servono solo a
    # scaldare la EMA, non sono sedute da giudicare. Se li contassi, il
    # numero atteso non sarebbe piu' noto per costruzione (su una serie
    # piatta chiusura e EMA50 coincidono a meno dell'errore di
    # arrotondamento, e il bias diventa un lancio di monetina).
    es, _, _ = confronta(barre, (14, 30), 35, sfasamento, 1, 50,
                         riscaldamento=200, da=primo)
    r = riassumi(es)
    # le sedute giudicate devono essere ESATTAMENTE quelle costruite
    ok_n = (r["n"] == len(attesi))
    if not ok_n:
        note += " SEDUTE %d != COSTRUITE %d." % (r["n"], len(attesi))
    ok = (r["discordi"] == atteso_disc
          and r["entrambe_long"] == atteso_entrambe
          and r["nessuna_long"] == atteso_nessuna
          and ok_n)
    # margine: se la deriva della EMA si fosse mangiata il segnale il test
    # potrebbe passare per caso. Lo controllo esplicitamente.
    margine_min = min([min(s["margine_bcm"], s["margine_ftmo"]) for s in es.sedute]) if es.sedute else 0.0
    if margine_min < 3.0:
        ok = False
        note += " MARGINE TROPPO SOTTILE (%.2f): il collaudo non e' affidabile." % margine_min
    print("  %-34s sedute=%4d  discordi=%4d (atteso %4d)  entrambe=%4d (atteso %4d)  "
          "nessuna=%4d (atteso %4d)  margine_min=%.2f  -> %s %s"
          % (nome, r["n"], r["discordi"], atteso_disc, r["entrambe_long"], atteso_entrambe,
             r["nessuna_long"], atteso_nessuna, margine_min,
             "PASS" if ok else "FALLITO", note))
    return ok


def autocollaudo():
    print("=" * 78)
    print(" COLLAUDO DELL'ANALIZZATORE SU DATI SINTETICI")
    print(" (serie H1 costruite in modo che la risposta sia nota PER COSTRUZIONE)")
    print("=" * 78)
    esiti = []

    # --- 1. divergenza costruita: 60 giorni, 20 di ogni tipo, alternati
    tipi = []
    for i in range(60):
        tipi.append(["DIV", "ENTRAMBE", "NESSUNA"][i % 3])
    esiti.append(_caso("1. mix 20/20/20", tipi, 20, 20, 20))

    # --- 2. nessuna divergenza: tutte le sedute concordi
    tipi = ["ENTRAMBE", "NESSUNA"] * 30
    esiti.append(_caso("2. zero divergenze", tipi, 0, 30, 30))

    # --- 3. tutte divergenti
    tipi = ["DIV"] * 40
    esiti.append(_caso("3. tutte divergenti", tipi, 40, 0, 0))

    # --- 4. IL CONTRO-ESEMPIO CHE CONTA.
    #     Con sfasamento 0 le due griglie sono LA STESSA griglia: qualunque
    #     numero di divergenza diverso da ZERO vorrebbe dire che la
    #     divergenza che misuro NON viene dallo sfasamento ma da un bug
    #     (EMA, indice della barra chiusa, ciclo delle sedute).
    tipi = ["DIV"] * 40
    esiti.append(_caso("4. sfasamento 0 -> stessa griglia", tipi, 0, 40, 0,
                       sfasamento=0,
                       note="(con sfasamento 0 le 'DIV' diventano tutte ENTRAMBE)"))

    # --- 5. lo sfasamento di 4 ore e' un giro intero: stessa griglia
    #     traslata di un secchio. Deve tornare a ZERO divergenze anche li'.
    tipi = ["DIV"] * 40
    esiti.append(_caso("5. sfasamento 4 -> giro intero", tipi, 0, 40, 0,
                       sfasamento=4,
                       note="(4h su passo 4h = stessa griglia)"))

    # --- 6. il rifiuto del TF sbagliato: una serie H4 non deve passare.
    barre, _, _ = serie_sintetica(["ENTRAMBE"] * 5)
    h4 = [(dt, px) for dt, px in barre if dt.hour % 4 == 0]
    try:
        controlla_h1(h4)
        ok = False
        print("  %-34s -> FALLITO (ha accettato una serie H4 come H1)" % "6. rifiuto del TF sbagliato")
    except SystemExit:
        ok = True
        print("  %-34s -> PASS (serie H4 rifiutata)" % "6. rifiuto del TF sbagliato")
    esiti.append(ok)

    # --- 7. l'ora di ingresso dentro [13:00,15:00) UTC non cambia niente:
    #     13:30 BCM+range 0 e 14:30 BCM+range 35 devono dare lo STESSO
    #     numero (le barre decisive sono le stesse).
    tipi = []
    for i in range(60):
        tipi.append(["DIV", "ENTRAMBE", "NESSUNA"][i % 3])
    barre, _, primo = serie_sintetica(tipi)
    a1 = riassumi(confronta(barre, (14, 30), 35, 2, 1, 50, 200, da=primo)[0])
    a2 = riassumi(confronta(barre, (14, 30), 0, 2, 1, 50, 200, da=primo)[0])
    ok = (a1["discordi"] == a2["discordi"] == 20)
    print("  %-34s 14:30+35min=%d  14:30+0min=%d  -> %s"
          % ("7. istante di ingresso robusto", a1["discordi"], a2["discordi"],
             "PASS" if ok else "FALLITO"))
    esiti.append(ok)

    print("-" * 78)
    tutti = all(esiti)
    print(" ESITO COLLAUDO: %d/%d PASS  -> %s"
          % (sum(1 for e in esiti if e), len(esiti),
             "ANALIZZATORE COLLAUDATO" if tutti else "NON CONSEGNABILE"))
    print("=" * 78)
    return 0 if tutti else 1


# ==========================================================================
# MAIN
# ==========================================================================

def ora_hhmm(s):
    m = re.match(r"^(\d{1,2}):(\d{2})$", s.strip())
    if not m:
        raise argparse.ArgumentTypeError("ora nel formato HH:MM, ricevuto %r" % s)
    return (int(m.group(1)), int(m.group(2)))


def data_iso(s):
    return datetime.strptime(s.strip(), "%Y-%m-%d").date()


def main():
    p = argparse.ArgumentParser(
        description="Quante sedute il filtro EMA su H4 dice il CONTRARIO fra griglia BCM e griglia FTMO.")
    p.add_argument("--csv", help="export H1 del Dow (dal banco 50504400)")
    p.add_argument("--ora-ingresso", type=ora_hhmm, default=(14, 30),
                   help="InpSessionHour:InpSessionMin in ORA DEL SERVER DEL CSV (default 14:30 = BCM)")
    p.add_argument("--minuti-range", type=int, default=35,
                   help="InpRangeMinutes: i pendenti si piazzano a ora-ingresso + questo (default 35)")
    p.add_argument("--delta-ftmo", type=int, default=2,
                   help="di quante ore il server FTMO e' AVANTI rispetto al server del CSV (default 2)")
    p.add_argument("--ema-veloce", type=int, default=1, help="InpEmaFast (default 1)")
    p.add_argument("--ema-lenta", type=int, default=50, help="InpEmaSlow (default 50)")
    p.add_argument("--riscaldamento", type=int, default=250,
                   help="barre H4 da scartare prima di giudicare (default 250 ~ 42 giorni)")
    p.add_argument("--da", type=data_iso, default=None, help="prima seduta AAAA-MM-GG")
    p.add_argument("--a", type=data_iso, default=None, help="ultima seduta AAAA-MM-GG")
    p.add_argument("--dettaglio", default=None, help="scrivi qui il CSV seduta per seduta")
    p.add_argument("--autocollaudo", action="store_true",
                   help="gira il collaudo su dati sintetici e esce")
    args = p.parse_args()

    if args.autocollaudo:
        return autocollaudo()

    if not args.csv:
        p.error("serve --csv (oppure --autocollaudo)")
    if not os.path.exists(args.csv):
        raise SystemExit("ERRORE: non trovo %s" % args.csv)

    barre, sep, scartate = leggi_h1(args.csv)
    passo, quota = controlla_h1(barre)

    print("=" * 78)
    print(" ANALISI DELLA GRIGLIA H4 -- BCM contro FTMO")
    print("=" * 78)
    print("  file           : %s" % args.csv)
    print("  separatore     : %r   righe scartate: %d" % (sep, scartate))
    print("  barre H1       : %d   da %s a %s"
          % (len(barre), barre[0][0], barre[-1][0]))
    print("  passo misurato : %d s (%.1f%% delle coppie) -> H1 confermato" % (passo, 100 * quota))
    print("  filtro         : EMA(%d) contro EMA(%d) sulle chiusure H4, ultima barra CHIUSA"
          % (args.ema_veloce, args.ema_lenta))
    print("  ingresso       : %02d:%02d + %d min = %02d:%02d ora del server del CSV"
          % (args.ora_ingresso[0], args.ora_ingresso[1], args.minuti_range,
             (args.ora_ingresso[0] * 60 + args.ora_ingresso[1] + args.minuti_range) // 60,
             (args.ora_ingresso[0] * 60 + args.ora_ingresso[1] + args.minuti_range) % 60))
    print("  griglia BCM    : secchi H4 che partono alle 00,04,08,12,16,20 del server del CSV")
    ore_f = sorted(set((h - args.delta_ftmo) % 24 for h in (0, 4, 8, 12, 16, 20)))
    print("  griglia FTMO   : secchi H4 che partono alle %s del server del CSV (FTMO = CSV +%dh)"
          % (",".join("%02d" % h for h in ore_f), args.delta_ftmo))

    # CONTRO-ESEMPIO SUL FUSO DEL CSV, e serve davvero: se Claudio
    # esportasse da un terminale con un server in un fuso diverso, TUTTO
    # quello che c'e' sotto sarebbe falso senza dare il minimo segno.
    # La firma che si puo' leggere dai dati e' la PAUSA GIORNALIERA del
    # feed: l'ora con MENO barre. Non e' un verdetto, e' un indizio da
    # confrontare -- ma e' un indizio che si legge, non si assume.
    conta_ore = {}
    for dt, _ in barre:
        conta_ore[dt.hour] = conta_ore.get(dt.hour, 0) + 1
    magre = sorted(conta_ore.items(), key=lambda x: x[1])[:3]
    print("  pausa del feed : le 3 ore con meno barre sono %s"
          % ", ".join("%02d:00 (%d barre)" % (h, n) for h, n in magre))
    print("                   CONTROLLALO: su un export in ORA SERVER BCM la pausa giornaliera")
    print("                   del Dow sta a ridosso delle 23:00. Se qui esce un'ora diversa,")
    print("                   il CSV NON e' in ora BCM e --ora-ingresso va corretto di conseguenza.")
    print("")

    es, g_bcm, g_ftmo = confronta(barre, args.ora_ingresso, args.minuti_range,
                                  args.delta_ftmo, args.ema_veloce, args.ema_lenta,
                                  args.riscaldamento, args.da, args.a)
    r = riassumi(es)

    if r["n"] == 0:
        raise SystemExit("ERRORE: zero sedute giudicabili. Storico troppo corto per il riscaldamento (%d barre H4)?"
                         % args.riscaldamento)

    print("  sedute giudicate           : %d" % r["n"])
    print("  saltate (mercato chiuso)   : %d" % es.saltate_mercato_chiuso)
    print("  saltate (riscaldamento)    : %d" % es.saltate_riscaldamento)
    print("")
    bordo = "  +" + "-" * 46 + "+" + "-" * 8 + "+" + "-" * 9 + "+"

    def riga(et, q):
        print("  | %-44s | %6d | %6.2f%% |" % (et, q, 100.0 * q / r["n"]))

    print(bordo)
    print("  | %-44s | %6s | %7s |" % ("esito del filtro EMA H4", "sedute", "quota"))
    print(bordo)
    riga("ENTRAMBE dicono LONG (la sedia opera sempre)", r["entrambe_long"])
    riga("ENTRAMBE bloccano    (la sedia sta ferma)", r["nessuna_long"])
    riga("DISCORDI: solo BCM  dice LONG", r["solo_bcm"])
    riga("DISCORDI: solo FTMO dice LONG", r["solo_ftmo"])
    print(bordo)
    print("")
    print("  >>> BIAS OPPOSTO: %.2f%% delle sedute (%d su %d)"
          % (r["pct_discordi"], r["discordi"], r["n"]))
    print("  >>> e %.2f%% delle sedute in cui almeno una delle due avrebbe operato (%d su %d)"
          % (r["pct_discordi_su_operative"], r["discordi"], r["operative"]))
    print("")

    # IL VERDETTO CONTRO L'ATTESA SCRITTA PRIMA (vedi l'intestazione)
    d = r["pct_discordi"]
    if d < 3.0:
        print("  VERDETTO: sotto il 3%. IL PROBLEMA NON ESISTE nei fatti: lo sfasamento")
        print("            della griglia sposta meno di una seduta al mese. I preset non si toccano.")
    elif d > 25.0:
        print("  VERDETTO: sopra il 25%. SU FTMO NON E' LA STESSA SEDIA: una seduta su quattro")
        print("            il filtro dice il contrario. Non si schiera senza rimisurare.")
    else:
        print("  VERDETTO: fra il 3%% e il 25%% (%.2f%%). Si puo' schierare, ma DICHIARANDO lo scarto:" % d)
        print("            su FTMO la sedia perde circa il %.1f%% delle sedute in cui BCM avrebbe"
              % (100.0 * r["solo_bcm"] / r["operative"] if r["operative"] else 0.0))
        print("            operato, e ne aggiunge %d che su BCM non ci sarebbero state."
              % r["solo_ftmo"])
        print("            La FREQUENZA attesa su FTMO va corretta di conseguenza.")
    print("")
    print("  CAVEAT DICHIARATI: (a) un solo broker di dati (il CSV viene dal banco BCM);")
    print("  (b) si misura SOLO il bias del filtro EMA, non il P/L: due sedute concordi")
    print("      possono comunque riempirsi a prezzi diversi; (c) il delta FTMO-BCM di %+dh"
          % args.delta_ftmo)
    print("      e' un INPUT, non una misura: va confermato con PREVOLO_FTMO_specifiche.csv.")

    if args.dettaglio:
        with open(args.dettaglio, "w", newline="") as f:
            w = csv.writer(f)
            w.writerow(["data", "istante", "fine_h4_bcm", "close_bcm", "ema50_bcm", "bias_bcm",
                        "fine_h4_ftmo", "close_ftmo", "ema50_ftmo", "bias_ftmo",
                        "long_bcm", "long_ftmo", "discordi"])
            for s in es.sedute:
                w.writerow([s["data"], s["istante"], s["fine_bcm"], "%.5f" % s["close_bcm"],
                            "%.5f" % s["ema50_bcm"], s["bias_bcm"],
                            s["fine_ftmo"], "%.5f" % s["close_ftmo"], "%.5f" % s["ema50_ftmo"],
                            s["bias_ftmo"], int(s["long_bcm"]), int(s["long_ftmo"]),
                            int(s["long_bcm"] != s["long_ftmo"])])
        print("")
        print("  dettaglio seduta per seduta: %s" % args.dettaglio)
    return 0


if __name__ == "__main__":
    sys.exit(main())
