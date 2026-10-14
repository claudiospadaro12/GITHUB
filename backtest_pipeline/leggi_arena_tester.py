#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_arena_tester.py -- IL LETTORE della SONDA dell'EA di TERZI 'Arena Nexus Grid Smart XAU MT5' nello Strategy Tester
(zip/cartella di backtest_pipeline/righe/ARENA_TESTER_SONDA.ps1, oppure uno o piu' report .htm del tester).
SOLA LETTURA. Scatola nera: nessun sorgente, nessuna decompilazione. Non giudica il merito, non promuove, non archivia,
non scrive mai 'morto'. Il verdetto massimo e' NON ANCORA MISURATO (un trimestre, un feed, un regime).

USO
  python3 backtest_pipeline/leggi_arena_tester.py ARENA_TESTER_SONDA.zip [--csv-dir CARTELLA]
  python3 backtest_pipeline/leggi_arena_tester.py report/ARENA_SONDA1_x.htm [report/ARENA_SONDA2_x.htm]
  python3 backtest_pipeline/leggi_arena_tester.py --autotest     (dati finti con risposta nota + contro-esempi; esce 1 se un controllo cade)

ATTESE, SCRITTE PRIMA DEI NUMERI (14/10/2026, prima di qualunque giro del tester)
  (A) La SONDA1 (il solo 28/09/2026) APRE operazioni: >= 1 operazione nel report.
      Se ZERO: l'EA nel tester non opera o rifiuta il tester (licenza, DLL, simbolo, versione demo limitata): e' una MISURA
      MANCANTE, non un errore della riga e non un verdetto sull'EA. Si legge il giornale (log\\SONDA1_*.txt) per il perche'.
  (B) Il tester riproduce un profitto giornaliero dello STESSO ORDINE del demo: il demo 50503392 ha dato +487,31 EUR il 13/10
      e +817,57 EUR il 14/10 a lotto 0,01 su ~4.900 EUR [LETTO nel conto]. Regola: MEDIANA del netto per giorno (giorni con
      almeno un deal, PRIMA di un eventuale stop out) >= 100 EUR -> B regge; < 100 EUR -> B SMENTITA.
      Si giudica sulla SONDA2 (65 giorni). Sulla SONDA1 (un giorno solo, ed e' il giorno sospetto) si stampa e basta.
      E sulla SONDA2 SOLO con almeno 20 giorni con deal prima di uno stop out (aggiunto dal cancello il 14/10, PRIMA dei numeri: uno
      stop out al terzo giorno lasciava giudicare 'REGGE' o 'SMENTITA' su due giorni, lo stesso campione che sulla SONDA1 si rifiuta).
      Ipotesi alternativa, col numero: se B e' smentita, il demo e' OTTIMISTA. Ma il tester, come il demo, NON ha slippage
      (ExecutionMode=0, ordini stop riempiti al prezzo: lo misura il punto 'prezzo esatto'), quindi un tester sotto 100 EUR/giorno
      NON si spiega con lo slippage: restano il FEED/SPREAD (storico BCM di luglio-settembre contro il live di ottobre) e il
      REGIME (due giorni di ottobre contro un trimestre). Quale delle due, questa sonda non lo separa.
  (C) Il 28/09/2026 il tester mostra o NON mostra una CADUTA. CADUTA = drawdown di EQUITA' >= 10% del deposito (>= 500 EUR su
      5.000) DENTRO il 28/09. Fonte: SONDA1 -> il 'Equita Drawdown Massima' del report (la finestra e' il solo 28/09: il DD del
      report E' quello del giorno); SONDA2 -> la perdita d'equita' STIMATA dentro il giorno rispetto al saldo d'inizio giorno
      (limite INFERIORE: l'equita' e' campionata solo agli istanti dei deal), piu' il DD del report sull'intero trimestre.
      Ipotesi alternativa, col numero [INFERITO]: l'utente del Market [DICHIARATO DA TERZI] avrebbe fatto +31.000 USD su 1.000 e poi
      perso quasi tutto il 28/09: con un lotto CRESCIUTO col saldo (circa 32 volte il nostro 0,01 se proporzionale al saldo) la
      stessa traiettoria del prezzo a lotto fisso 0,01 vale circa 31.000/32 ~ 1.000 USD ~ 850 EUR ~ 17% di 5.000: SOPRA il 10%.
      Quindi: CADUTA vista -> coerente con l'utente; NESSUNA caduta in SONDA1 NON smentisce l'utente, perche' (i) la SONDA1 parte
      a conto vuoto il lunedi' e NON vede un cesto aperto il venerdi' 25/09 ne' il gap del weekend (InpFridayGapProtection=false),
      (ii) il feed e' un altro (XAUUSD.sd di un altro broker), (iii) a lotto proporzionale le scale dei livelli successivi pesano
      di piu'. Solo la SONDA2 (che arriva al 28/09 con i cesti veri della settimana) puo' dire 'non c'e' caduta su BCM'.
      OROLOGIO (classe 1436): il '28/09' e' la data SERVER BCM (UTC+1 fisso, report/OROLOGIO_BCM_2026-09-24.md). Il 28/09 dell'utente
      e' nell'orologio del SUO broker [NON NOTO]: una caduta a cavallo della mezzanotte puo' stare il 27 o il 29 sul nostro orologio,
      e la riapertura della domenica sera (27/09 server [INFERITO dall'orologio BCM]) sta FUORI dalla SONDA1. Per questo il lettore
      stampa anche il 27/09 e il 29/09 accanto al 28/09; la regola C resta sul 28/09 server, scritta cosi' prima dei numeri.

COME SI CONTA
  Deal = riga di 13 celle della tabella 'Affari' del report (data, numero intero, tipo buy/sell/balance). Ordine = riga di 11
  celle della tabella 'Ordini'. Il conto del tester e' HEDGING (come il demo 50503392): un deal 'out' di tipo sell chiude una
  posizione BUY. Il report NON ha l'identificativo di posizione: l'accoppiamento in -> out e' RICOSTRUITO, e lo si dichiara:
    1. i deal 'out' dello stesso secondo e dello stesso tipo sono un GRAPPOLO; se l'insieme dei volumi aperti di UN cesto ci sta
       dentro, il cesto si chiude tutto li' ('per insieme'); due cesti con lo stesso insieme = AMBIGUO (si prende il piu' vecchio);
    2. il resto deal per deal: posizioni aperte dello stesso lato e volume; se il commento dell'out e' 'tp X' / 'sl X', si
       preferiscono quelle con quel T/P o S/L nell'ordine d'apertura; un candidato = UNIVOCO; piu' candidati dello stesso cesto =
       STESSO CESTO (netto del cesto esatto); di cesti diversi = AMBIGUO (si prende il piu' vecchio).
    Un grappolo chiuso 'per insieme' conta come AMBIGUO anche quando le ALTRE posizioni aperte dello stesso lato (un altro cesto, o
    piu' cesti insieme, moduli [F] e commenti non riconosciuti compresi) contengono lo stesso insieme di volumi (il grappolo potrebbe
    essere una chiusura PARZIALE di quelle: il report non lo distingue; il demo chiude cesti grandi "in 4 volte").
    Se gli AMBIGUI superano il 5% dei deal 'out', i netti PER CESTO si stampano come APPROSSIMATI. Il netto PER GIORNO e i lotti
    vivi NON dipendono dall'accoppiamento (somme sui deal), e il netto totale si riconcilia col report. L'EQUITA' STIMATA SI'
    (il prezzo d'ingresso delle posizioni ancora vive dipende da quali si sono chiuse): con accoppiamento oltre il 5% la (C) della
    SONDA2 lo dice accanto al numero.
  VERDETTI SOSPESI (classe 1381, 14/10/2026, controllo-preventivo): (A), (B), (C) NON si danno, e si dice perche', se il giro non e'
  quello dichiarato -- REFERTO assente, marcatore diverso da MARCATORE_ARENA_TESTER_SONDA_v3, pin non in PIN_PASSATI (cioe' non quello
  della riga passata dal cancello), data del REFERTO prima del pin, .ex5 cambiato durante la passata (righe EX5_DOPO), report sciolto
  senza REFERTO -- oppure se il report stesso dice un'altra cosa: input imposti diversi, deposito, leva, simbolo, Expert, qualita' non
  100%, finestra diversa da quella della sonda. I numeri descrittivi si stampano lo stesso.
  Cesto = (CID, lato) dei deal d'ingresso col commento '... [CID=n] [R]' (modulo di recupero); il lato e' quello della COLONNA tipo
  del deal, non del commento (classe 1393: le discordanze si contano). Profondita' = numero di ingressi [R] del cesto.
  Moduli [F] ('FinlabX ... [F]', 'CF ... [F]', 'DZR ... [F]'): ogni posizione da sola. Commenti non riconosciuti: si contano a parte.
  Netto = profitto + commissioni + swap di TUTTI i deal (anche le commissioni dei deal d'ingresso). Giorno = data SERVER del deal.
  Lotti vivi = somma dei volumi aperti (buy + sell, lordi) dopo ogni deal: non dipende dall'accoppiamento.
  Equita' STIMATA = saldo del deal (colonna Bilancio) + flottante delle posizioni aperte valutato al PREZZO DI QUEL DEAL con k EUR
  per 1,0 di prezzo x 1 lotto, k = mediana di profitto / (delta prezzo x volume) sulle posizioni accoppiate (|delta| >= 0,5);
  senza posizioni utili k = 89,36 [DERIVATO dal demo, scheda del 13/10]. E' un LIMITE INFERIORE del drawdown vero (campiona solo
  agli istanti dei deal) e mescola bid/ask: [STIMA]. Controllo: il DD stimato sull'intera finestra NON deve superare il DD di
  equita' del report di oltre il 10%; se lo supera, la stima e' rotta e lo si dice.
  Prezzo esatto: per ogni deal d'ingresso nato da un ordine stop/limit, scarto = prezzo del deal - prezzo dell'ordine (verso
  sfavorevole positivo). Nel tester con ExecutionMode=0 non c'e' latenza: uno scarto > 0 su uno stop e' un SALTO fra due tick,
  non slippage di esecuzione. Il demo 14/10: 731 su 731 ingressi a prezzo esatto [LETTO, MARKET_CLASSIFICA_2026-10-14 par. 5].
  Commissioni: dalla colonna del report. Attesa 3,90 EUR/lotto a giro [NON VERIFICATO]; demo 4,00 EUR/lotto A/R [LETTO nel conto];
  tester BCM sull'oro 1,71 EUR per lato per lotto = 3,42 a giro [MISURATO nel report GBA_R0_R1A_03 del 10/10].

COSA NON SI PUO' CONCLUDERE (va stampato, e lo stampa)
  Un trimestre = un regime; tester senza slippage e senza latenza; feed BCM (non quello dell'utente); i due enum al valore che il
  tester ha usato (letto nel report), non scelti da noi; nessun merito (le regole di casa: >= 150 operazioni con regime dichiarato,
  e comunque griglia + scala di lotti + recupero senza SL iniziale = fuori dall'imbuto prop per natura).
"""
import argparse, collections, csv, datetime, io, math, os, re, statistics, sys, zipfile

DEPOSITO_ATTESO = 5000.0
LEVA_ATTESA = "1:500"
DEMO_GIORNO = (("2026-10-13", 487.31), ("2026-10-14", 817.57))   # [LETTO nel conto 50503392] netto del gruppo Arena
SOGLIA_B = 100.0           # EUR al giorno (mediana) a 0,01 con 5000 EUR
GIORNI_MIN_B = 20          # giorni con deal (prima dello stop out) sotto i quali la (B) della SONDA2 NON si giudica [cancello 14/10, prima dei numeri]
SOGLIA_C = 0.10            # caduta = DD di equita' >= 10% del deposito, dentro il 28/09
GIORNO_CROLLO = datetime.date(2026, 9, 28)
COMM_ATTESA = 3.90         # EUR/lotto a giro [NON VERIFICATO]
COMM_DEMO = 4.00           # [LETTO nel conto]
COMM_TESTER_GBA = 3.42     # 1,71 per lato x 2 [MISURATO, GBA_R0_R1A_03 10/10]
K_RIPIEGO = 89.36          # EUR per 1,0 di prezzo x 1 lotto [DERIVATO dal demo]
SOGLIA_AMBIGUI = 0.05
ANCORA_T1 = (25648545, 88416, "2026.07.01", "2026.09.30")   # tick, barre di XAUUSD M1 T1 a tick reali [MISURATO 10/10 e 14/10 su questo PC]
INPUT_IMPOSTI = (("InpS03FundedPrefix", "true", "b"), ("InpEntryPhaseSpacingR33", "true", "b"), ("InpMagicNumber", "888", "i"),
                 ("InpBaseLot", "0.01", "d"), ("InpFridayGapProtection", "false", "b"), ("InpShowDashboard", "true", "b"),
                 ("InpCounterFlowRail", "true", "b"), ("InpCounterFlowTriggerPrice", "0.2", "d"), ("InpCounterFlowLotMultiplier", "1.0", "d"),
                 ("InpCounterFlowMaxLivePositions", "1", "i"), ("InpCounterFlowRearmDelayMilliseconds", "0", "i"),
                 ("InpDeadZoneReactionRail", "true", "b"), ("InpDeadZoneReactionTriggerPrice", "0.2", "d"),
                 ("InpDeadZoneReactionRearmDelayMilliseconds", "0", "i"))
INPUT_ENUM = ("InpTradeMode", "InpGoldPulseTheme")
# PROVENIENZA (classe 1381): il pin della riga che ha passato il cancello per lo script v2. VUOTO finche' la riga v2 non e' pinnata:
# con la tupla vuota OGNI zip ha i verdetti SOSPESI (fail-closed). Dopo il commit dello script v2 si scrive qui il suo pin (40 esadecimali).
PIN_PASSATI = ("fa37652d349bd5f7f26167912a7b360c174949c4",)
MARCATORE_ATTESO = "MARCATORE_ARENA_TESTER_SONDA_v3"
DATA_MINIMA_REFERTO = "2026-10-14"   # il giorno dello script v2: un REFERTO datato prima non puo' venire da quel pin
FINESTRE = {"SONDA1": ("2026.09.28", ("2026.09.28", "2026.09.29")), "SONDA2": ("2026.07.01", ("2026.09.29", "2026.09.30"))}
DEMO_ENUM = "InpTradeMode demo = GOLDPULSE_BOTH_SIDES (ordinale NON NOTO)"
CLASSI_PROF = ((1, 1, "1"),(2, 2, "2"), (3, 4, "3-4"), (5, 9, "5-9"), (10, 10 ** 9, ">=10"))

RE_DATA = re.compile(r"^\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d$")
RE_MOD = re.compile(r"^(FinlabX|CF|DZR)\s+(BUY|SELL|B|S)\b")
RE_CID = re.compile(r"\[CID=(\d+)\]")
RE_TIPO = re.compile(r"\[(R|F)\]")
RE_TPSL = re.compile(r"^(tp|sl)\s+([0-9.]+)", re.I)
RE_SO = re.compile(r"^so[\s:]|stop ?out", re.I)


# ---------------------------------------------------------------------------------------------------------------------
#  LETTURA
# ---------------------------------------------------------------------------------------------------------------------
def decodifica(raw):
    if raw[:2] in (b"\xff\xfe", b"\xfe\xff"):
        return raw.decode("utf-16", "replace")
    if len(raw) > 4 and raw[1:2] == b"\x00" and raw[3:4] == b"\x00":
        return raw.decode("utf-16-le", "replace")
    return raw.decode("utf-8", "replace").lstrip("\ufeff")


def numero(s):
    if s is None:
        return None
    t = str(s).replace("\xa0", "").replace(" ", "").replace("\u202f", "").strip()
    if t == "":
        return None
    try:
        return float(t)
    except ValueError:
        return None


def _cella(piatto, etichette):
    for e in etichette:
        m = re.search(r"\|" + e + r":\|([^|]*)\|", piatto)
        if m:
            return re.sub(r"\s", "", m.group(1))
    return None


def _dd(s):
    if s is None:
        return (None, None)
    m = re.match(r"^(-?[0-9.]+)\(([0-9.]+)%\)$", s)
    if not m:
        return (None, None)
    return (float(m.group(1)), float(m.group(2)))


def _celle(tr):
    return [re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", c)).replace("&nbsp;", " ").strip()
            for c in re.findall(r"<td[^>]*>(.*?)</td>", tr, flags=re.S | re.I)]


def leggi_report(raw):
    """Il report .htm del tester: testa (impostazioni, input, risultati) + Ordini (11 celle) + Affari (13 celle)."""
    t = decodifica(raw)
    r = {"ok": False, "motivo": "", "avvisi": []}
    cut = len(t)
    for et in (">Ordini<", ">Orders<"):
        i = t.find(et)
        if i >= 0:
            cut = min(cut, i)
    testa = t[:cut]
    piatto = re.sub(r"<[^>]+>", "|", testa)
    piatto = re.sub(r"\s*\|[\s|]*", "|", piatto)
    esperti = re.findall(r"\|Expert:\|([^|]*)(?=\|)", re.sub(r"\s*\|[\s|]*", "|", re.sub(r"<[^>]+>", "|", t[:max(cut, 200000)])))
    r["esperti"] = [e.strip() for e in esperti]
    r["expert"] = r["esperti"][0] if r["esperti"] else None
    r["simbolo"] = _cella(piatto, ["Simbolo", "Symbol"])
    r["periodo"] = _cella(piatto, ["Periodo", "Period"])
    r["qualita"] = _cella(piatto, ["Qualit. dello Storico", "History Quality"])
    r["barre"] = numero(_cella(piatto, ["Barre", "Bars"]))
    r["ticks"] = numero(_cella(piatto, ["Ticks"]))
    r["deposito"] = numero(_cella(piatto, ["Deposito Iniziale", "Initial Deposit"]))
    r["leva"] = _cella(piatto, ["Leva", "Leverage"])
    r["trades"] = numero(_cella(piatto, ["Numero di Operazioni di Trading Totali", "Total Trades"]))
    r["affari"] = numero(_cella(piatto, ["Affari Totali", "Total Deals"]))
    r["profitto"] = numero(_cella(piatto, ["Profitto Totale Netto", "Total Net Profit"]))
    r["pf"] = numero(_cella(piatto, ["Fattore di Profitto", "Profit Factor"]))
    r["dd_eq_abs"], r["dd_eq_pct"] = _dd(_cella(piatto, ["Equit. Drawdown Massima", "Equity Drawdown Maximal"]))
    r["dd_bil_abs"], r["dd_bil_pct"] = _dd(_cella(piatto, ["Bilancio Drawdown Massimo", "Balance Drawdown Maximal"]))
    r["input"] = collections.OrderedDict()
    for m in re.finditer(r"\|(Inp[A-Za-z0-9_]+)=([^|]*)(?=\|)", piatto):
        r["input"].setdefault(m.group(1), m.group(2).strip())
    ordini, deals = {}, []
    for m in re.finditer(r"<tr[^>]*>(.*?)</tr>", t[cut:], flags=re.S | re.I):
        c = _celle(m.group(1))
        if len(c) == 11 and RE_DATA.match(c[0]) and c[1].isdigit():
            ordini[int(c[1])] = {"t": c[0], "tipo": c[3].lower(), "prezzo": numero(c[5]), "sl": numero(c[6]), "tp": numero(c[7]),
                                 "stato": c[9], "commento": c[10]}
        elif len(c) == 13 and RE_DATA.match(c[0]) and c[1].isdigit():
            deals.append({"t": datetime.datetime.strptime(c[0], "%Y.%m.%d %H:%M:%S"), "id": int(c[1]), "sim": c[2], "tipo": c[3].lower(),
                          "dir": c[4].lower(), "vol": numero(c[5]) or 0.0, "prezzo": numero(c[6]), "ordine": int(c[7]) if c[7].isdigit() else None,
                          "comm": numero(c[8]) or 0.0, "swap": numero(c[9]) or 0.0, "profitto": numero(c[10]) or 0.0,
                          "saldo": numero(c[11]), "commento": c[12]})
    r["ordini"], r["deals"] = ordini, deals
    r["completo"] = "</html>" in t[-400:].lower()
    if r["trades"] is None or r["profitto"] is None:
        r["motivo"] = "etichette del totale operazioni / profitto netto NON trovate (report troncato prima dei risultati, o non e' un report del tester)"
        return r
    r["ok"] = True
    return r


class Sorgente:
    """uno zip o una cartella (Compress-Archive scrive il backslash: i nomi si normalizzano) o un file .htm"""
    def __init__(self, percorso):
        self.percorso = percorso
        self.file = {}
        if os.path.isdir(percorso):
            for rd, _d, fs in os.walk(percorso):
                for f in fs:
                    vero = os.path.join(rd, f)
                    self.file[os.path.relpath(vero, percorso).replace(os.sep, "/").replace("\\", "/")] = ("d", vero)
        elif zipfile.is_zipfile(percorso):
            self.zip = zipfile.ZipFile(percorso)
            for n in self.zip.namelist():
                if not n.endswith("/") and not n.endswith("\\"):
                    self.file[n.replace("\\", "/")] = ("z", n)
        else:
            self.file[os.path.basename(percorso)] = ("d", percorso)

    def leggi(self, nome):
        k, v = self.file[nome]
        if k == "z":
            return self.zip.read(v)
        with open(v, "rb") as fh:
            return fh.read()

    def nomi(self):
        return sorted(self.file)


# ---------------------------------------------------------------------------------------------------------------------
#  ANALISI
# ---------------------------------------------------------------------------------------------------------------------
def classifica(commento):
    """(modulo, lato_del_commento, cid, tipo R/F) oppure None"""
    m = RE_MOD.match(commento or "")
    c = RE_CID.search(commento or "")
    k = RE_TIPO.search(commento or "")
    if not (m and c and k):
        return None
    lato = {"BUY": "buy", "B": "buy", "SELL": "sell", "S": "sell"}[m.group(2)]
    return (m.group(1), lato, int(c.group(1)), k.group(1))


def pf_di(v):
    g = sum(x for x in v if x > 0)
    p = -sum(x for x in v if x < 0)
    if p <= 0:
        return float("inf") if g > 0 else None
    return g / p


def fmt(x, d=2):
    if x is None:
        return "n/d"
    if isinstance(x, float) and math.isinf(x):
        return "inf"
    return ("%." + str(d) + "f") % x


def analizza(rep):
    """Tutte le misure di un report. Restituisce un dizionario; non stampa."""
    a = {"avvisi": [], "errori": []}
    deals = rep["deals"]
    dep = rep["deposito"] if rep["deposito"] is not None else DEPOSITO_ATTESO
    a["deposito"] = dep
    td = [d for d in deals if d["tipo"] in ("buy", "sell")]
    a["n_deal"] = len(td)
    if rep["affari"] is not None and int(rep["affari"]) != len(td):
        a["errori"].append("REPORT TRONCATO o incoerente: letti %d deal di trading contro 'Affari Totali' %d: le misure sui deal NON valgono" % (len(td), int(rep["affari"])))
    if not rep["completo"]:
        a["avvisi"].append("il file non finisce con </html>: possibile report TRONCATO")
    # riconciliazione: deposito + somma = ultimo saldo = deposito + netto del report
    somma = sum(d["profitto"] + d["comm"] + d["swap"] for d in td)
    a["netto_deal"] = somma
    if td and td[-1]["saldo"] is not None and abs(dep + somma - td[-1]["saldo"]) > 0.05:
        a["errori"].append("deposito + somma dei deal = %.2f ma l'ultimo saldo del report = %.2f: deal persi o letti male" % (dep + somma, td[-1]["saldo"]))
    if rep["profitto"] is not None and abs(somma - rep["profitto"]) > 0.05 and not a["errori"]:
        a["errori"].append("somma dei deal %.2f diversa dal 'Profitto Totale Netto' %.2f" % (somma, rep["profitto"]))
    # commissioni
    vol_tot = sum(d["vol"] for d in td)
    comm_tot = sum(d["comm"] for d in td)
    a["comm_tot"], a["vol_deal"] = comm_tot, vol_tot
    a["comm_lotto_giro"] = (-comm_tot / vol_tot * 2.0) if vol_tot > 0 else None
    # stop out
    so = [d for d in td if RE_SO.search(d["commento"] or "")]
    a["stop_out"] = so
    t_so = so[0]["t"] if so else None
    # prezzo esatto degli ingressi da ordine stop/limit
    sc = []
    n_mercato = 0
    for d in td:
        if d["dir"] != "in":
            continue
        o = rep["ordini"].get(d["ordine"]) if d["ordine"] is not None else None
        if o is None or not ("stop" in o["tipo"] or "limit" in o["tipo"]) or not o["prezzo"]:
            n_mercato += 1
            continue
        s = (d["prezzo"] - o["prezzo"]) if d["tipo"] == "buy" else (o["prezzo"] - d["prezzo"])
        sc.append(s)
    a["scarti"], a["n_mercato"] = sc, n_mercato
    # posizioni, cesti, giorni
    aperte = {"buy": [], "sell": []}
    chiuse = []
    episodi = {}          # chiave episodio -> dati del cesto
    corrente = {}         # chiave cesto -> chiave episodio aperto
    vivi_cesto = collections.Counter()
    acc = collections.Counter()
    discordi = 0
    giorni = collections.OrderedDict()
    k_campioni = []

    def giorno(d):
        g = d["t"].date()
        if g not in giorni:
            saldo_prima = d["saldo"] - (d["profitto"] + d["comm"] + d["swap"]) if d["saldo"] is not None else None
            giorni[g] = {"netto": 0.0, "n_in": 0, "lotti_in": 0.0, "picco": 0.0, "picco_buy": 0.0, "picco_sell": 0.0,
                         "saldo_inizio": saldo_prima, "saldo_min": None, "eq_min": None, "flott_min": 0.0, "prof_max": 0}
        return giorni[g]

    n_episodi = collections.Counter()

    def apri_episodio(chiave, d):
        n_episodi[chiave] += 1
        nep = chiave + (n_episodi[chiave],)
        episodi[nep] = {"chiave": chiave, "prof": 0, "lotti": 0.0, "vivi_max": 0.0, "t0": d["t"], "t1": None, "netto": 0.0, "aperto": True, "pos": 0}
        corrente[chiave] = nep
        return nep

    def chiudi_pos(p, d, quota, modo):
        net = p["comm_in"] * quota + d["profitto"] + d["comm"] + d["swap"]
        chiuse.append({"chiave": p["chiave"], "ep": p["ep"], "lato": p["lato"], "vol": d["vol"], "p_in": p["prezzo"], "p_out": d["prezzo"],
                       "t_in": p["t"], "t_out": d["t"], "netto": net, "profitto": d["profitto"], "modo": modo})
        ep = episodi.get(p["ep"])
        if ep is not None:
            ep["netto"] += net
            ep["t1"] = d["t"]
        if modo in ("univoco", "per insieme") and p["prezzo"] is not None and d["prezzo"] is not None:
            dp = (d["prezzo"] - p["prezzo"]) * (1 if p["lato"] == "buy" else -1)
            if abs(dp) >= 0.5 and d["vol"] > 0:
                k_campioni.append(d["profitto"] / (dp * d["vol"]))

    def togli(p, lato, d, modo):
        if abs(p["vol"] - d["vol"]) < 1e-9:
            aperte[lato].remove(p)
            chiudi_pos(p, d, 1.0, modo)
            if p["chiave"] is not None:
                vivi_cesto[p["ep"]] -= 1
                if vivi_cesto[p["ep"]] <= 0 and corrente.get(p["chiave"]) == p["ep"]:
                    episodi[p["ep"]]["aperto"] = False
                    del corrente[p["chiave"]]
        else:
            quota = d["vol"] / p["vol"] if p["vol"] > 0 else 1.0
            acc["parziali"] += 1
            p["vol"] -= d["vol"]
            chiudi_pos(p, d, quota, modo)
            p["comm_in"] *= (1 - quota)

    def stato_dopo(d, g):
        vb = sum(p["vol"] for p in aperte["buy"])
        vs = sum(p["vol"] for p in aperte["sell"])
        g["picco"] = max(g["picco"], vb + vs)
        g["picco_buy"] = max(g["picco_buy"], vb)
        g["picco_sell"] = max(g["picco_sell"], vs)
        if d["saldo"] is not None:
            g["saldo_min"] = d["saldo"] if g["saldo_min"] is None else min(g["saldo_min"], d["saldo"])
        prof = collections.Counter(p["ep"] for p in aperte["buy"] + aperte["sell"] if p["chiave"] is not None and p["chiave"][0] == "R")
        if prof:
            g["prof_max"] = max(g["prof_max"], max(episodi[e]["prof"] for e in prof))
        return vb, vs

    # il valore k si calibra a fine passata; per l'equita' stimata serve subito: prima passata per k, seconda per l'equita'
    i = 0
    cronaca = []
    while i < len(td):
        d = td[i]
        g = giorno(d)
        g["netto"] += d["profitto"] + d["comm"] + d["swap"]
        if d["dir"] == "in":
            lato = d["tipo"]
            cl = classifica(d["commento"])
            chiave = None
            if cl is not None:
                if cl[1] != lato:
                    discordi += 1
                chiave = ("R", cl[2], lato) if cl[3] == "R" else ("F", cl[0], cl[2], lato)
            else:
                acc["non_riconosciuti"] += 1
            ep = None
            if chiave is not None:
                ep = corrente.get(chiave) or apri_episodio(chiave, d)
                e = episodi[ep]
                e["prof"] += 1
                e["lotti"] += d["vol"]
                e["pos"] += 1
                vivi_cesto[ep] += 1
            o = rep["ordini"].get(d["ordine"]) if d["ordine"] is not None else None
            aperte[lato].append({"t": d["t"], "vol": d["vol"], "prezzo": d["prezzo"], "lato": lato, "chiave": chiave, "ep": ep,
                                 "comm_in": d["comm"], "sl": o["sl"] if o else None, "tp": o["tp"] if o else None,
                                 "commento": d["commento"]})
            g["n_in"] += 1
            g["lotti_in"] += d["vol"]
            if ep is not None:
                e = episodi[ep]
                e["vivi_max"] = max(e["vivi_max"], sum(p["vol"] for p in aperte[lato] if p["ep"] == ep))
            stato_dopo(d, g)
            cronaca.append((d, g))
            i += 1
            continue
        if d["dir"] not in ("out", "in/out", "out by"):
            i += 1
            continue
        # grappolo: deal out consecutivi, stesso secondo, stesso tipo
        j = i
        while j + 1 < len(td) and td[j + 1]["dir"] in ("out", "in/out", "out by") and td[j + 1]["t"] == d["t"] and td[j + 1]["tipo"] == d["tipo"]:
            j += 1
        grappolo = td[i:j + 1]
        lato = "buy" if d["tipo"] == "sell" else "sell"
        resto = list(grappolo)
        amb_grappolo = False
        if len(grappolo) >= 2:
            while True:
                vol_resto = collections.Counter(round(x["vol"], 2) for x in resto)
                per_ep = collections.defaultdict(list)
                for p in aperte[lato]:
                    if p["ep"] is not None:
                        per_ep[p["ep"]].append(p)
                adatti = []
                for ep, ps in per_ep.items():
                    cv = collections.Counter(round(p["vol"], 2) for p in ps)
                    if len(ps) >= 2 and all(vol_resto[v] >= n for v, n in cv.items()):
                        adatti.append((len(ps), ep, ps))
                if not adatti:
                    break
                adatti.sort(key=lambda x: (-x[0], x[2][0]["t"]))
                # un ALTRO cesto aperto dello stesso lato che contiene lo stesso insieme di volumi: il grappolo puo' essere una sua
                # chiusura PARZIALE (controllo-preventivo 14/10: senza questo, un parziale veniva contato 'per insieme', cioe' certo)
                # secondo giro del cancello (14/10): l'alternativa si cerca nell'UNIONE di tutte le ALTRE posizioni aperte dello stesso
                # lato (cesti diversi insieme, moduli [F], commenti non riconosciuti), non in un solo cesto: {0.01 del cesto 2 + 0.02 del
                # cesto 3} spiega il grappolo {0.01, 0.02} quanto il cesto 1 intero (autotest 16d). Il caso normale 16c non cambia.
                cv0 = collections.Counter(round(p["vol"], 2) for p in adatti[0][2])
                altri_vol = collections.Counter(round(p["vol"], 2) for p in aperte[lato] if p["ep"] != adatti[0][1])
                alternativa = all(altri_vol[v] >= n for v, n in cv0.items())
                if amb_grappolo or alternativa or (len(adatti) >= 2 and adatti[1][0] == adatti[0][0] and collections.Counter(round(p["vol"], 2) for p in adatti[1][2]) == collections.Counter(round(p["vol"], 2) for p in adatti[0][2])):
                    # due cesti con lo stesso insieme di volumi: la scelta e' arbitraria, e lo resta per tutto il grappolo
                    acc["ambigui"] += adatti[0][0]
                    modo = "ambiguo"
                    amb_grappolo = True
                else:
                    acc["per_insieme"] += adatti[0][0]
                    modo = "per insieme"
                for p in list(adatti[0][2]):
                    x = next(x for x in resto if abs(x["vol"] - p["vol"]) < 1e-9)
                    resto.remove(x)
                    g = giorno(x)
                    if x is not d:
                        g["netto"] += x["profitto"] + x["comm"] + x["swap"]
                    togli(p, lato, x, modo)
                    x["_fatto"] = True
        for x in resto:
            g = giorno(x)
            if x is not d:
                g["netto"] += x["profitto"] + x["comm"] + x["swap"]
            cand = [p for p in aperte[lato] if abs(p["vol"] - x["vol"]) < 1e-9]
            mt = RE_TPSL.match(x["commento"] or "")
            if mt and cand:
                livello = float(mt.group(2))
                campo = "tp" if mt.group(1).lower() == "tp" else "sl"
                sub = [p for p in cand if p[campo] is not None and abs(p[campo] - livello) < 0.005]
                if sub:
                    cand = sub
            if not cand:
                magg = [p for p in aperte[lato] if p["vol"] > x["vol"] + 1e-9]
                if magg:
                    acc["parziali_senza_volume"] += 1
                    togli(magg[0], lato, x, "ambiguo")
                else:
                    acc["non_accoppiati"] += 1
                continue
            chiavi = set(p["ep"] for p in cand)
            if len(cand) == 1:
                modo = "univoco"
            elif len(chiavi) == 1 and None not in chiavi:
                modo = "stesso cesto"
            else:
                modo = "ambiguo"
            acc[modo.replace(" ", "_")] += 1
            togli(cand[0], lato, x, modo)
        for x in grappolo:
            stato_dopo(x, giorno(x))
            cronaca.append((x, giorno(x)))
        i = j + 1
    a["k"] = statistics.median(k_campioni) if len(k_campioni) >= 5 else K_RIPIEGO
    a["k_fonte"] = ("mediana di %d posizioni accoppiate" % len(k_campioni)) if len(k_campioni) >= 5 else "ripiego 89,36 [DERIVATO dal demo]: meno di 5 posizioni utili"
    # seconda passata: equita' stimata agli istanti dei deal (ricostruisce le posizioni aperte dalla cronaca delle chiusure)
    aperte_eq = []
    # le posizioni vive a ogni istante: intervallo [t_in, t_out) con volume chiuso; quelle mai chiuse restano fino alla fine
    pos_intervalli = [(c["t_in"], c["t_out"], c["lato"], c["vol"], c["p_in"]) for c in chiuse]
    for lato in ("buy", "sell"):
        for p in aperte[lato]:
            pos_intervalli.append((p["t"], None, lato, p["vol"], p["prezzo"]))
    eventi = []
    for k_, (t0, t1, lato, vol, pin) in enumerate(pos_intervalli):
        eventi.append((t0, 1, k_))
        if t1 is not None:
            eventi.append((t1, 0, k_))
    eventi.sort()
    vive = set()
    picco_eq = dep
    dd_stimato = 0.0
    ie = 0
    istanti = sorted(set(x[0]["t"] for x in cronaca))
    saldo_a = {}
    for x, _g in cronaca:
        if x["saldo"] is not None:
            saldo_a[x["t"]] = x["saldo"]
    prezzo_a = {}
    for x, _g in cronaca:
        if x["prezzo"] is not None:
            prezzo_a[x["t"]] = x["prezzo"]
    eq_serie = []
    for t in istanti:
        while ie < len(eventi) and eventi[ie][0] <= t:
            tt, tipo, kk = eventi[ie]
            if tipo == 1:
                vive.add(kk)
            else:
                vive.discard(kk)
            ie += 1
        px = prezzo_a.get(t)
        fl = 0.0
        if px is not None:
            for kk in vive:
                t0, t1, lato, vol, pin = pos_intervalli[kk]
                if pin is not None:
                    fl += (px - pin) * (1 if lato == "buy" else -1) * vol * a["k"]
        eq = saldo_a.get(t, dep) + fl
        eq_serie.append((t, eq, fl))
        picco_eq = max(picco_eq, eq)
        dd_stimato = max(dd_stimato, picco_eq - eq)
        g = giorni[t.date()]
        g["eq_min"] = eq if g["eq_min"] is None else min(g["eq_min"], eq)
        g["flott_min"] = min(g["flott_min"], fl)
    a["dd_eq_stimato"] = dd_stimato
    a["eq_serie"] = eq_serie
    a["giorni"] = giorni
    a["acc"] = acc
    a["discordi"] = discordi
    a["chiuse"] = chiuse
    a["episodi"] = episodi
    a["aperte_fine"] = sum(len(aperte[x]) for x in aperte)
    a["t_stop_out"] = t_so
    n_out = sum(1 for d in td if d["dir"] in ("out", "in/out", "out by"))
    a["n_out"] = n_out
    a["quota_ambigui"] = (acc["ambiguo"] + acc["ambigui"] + acc["parziali_senza_volume"] + acc["non_accoppiati"]) / n_out if n_out else 0.0
    if rep["dd_eq_abs"] is not None and dd_stimato > rep["dd_eq_abs"] * 1.10 + 1.0:
        a["errori"].append("il DD d'equita' STIMATO (%.2f) supera quello VERO del report (%.2f) di oltre il 10%%: la stima (k, prezzi, accoppiamento) e' rotta, le colonne 'equita stimata' NON si leggono" % (dd_stimato, rep["dd_eq_abs"]))
        a["stima_rotta"] = True
    else:
        a["stima_rotta"] = False
    return a


# ---------------------------------------------------------------------------------------------------------------------
#  STAMPA
# ---------------------------------------------------------------------------------------------------------------------
def sonda_di(nome):
    b = os.path.basename(nome).upper()
    if "SONDA1" in b:
        return "SONDA1"
    if "SONDA2" in b:
        return "SONDA2"
    return "REPORT"


def solo_28(rep):
    p = rep.get("periodo") or ""
    return p.startswith("M1(2026.09.28-") and p[14:24] in ("2026.09.28", "2026.09.29")


def finestra_contiene_28(rep):
    m = re.match(r"^M1\((\d{4}\.\d\d\.\d\d)-(\d{4}\.\d\d\.\d\d)\)", rep.get("periodo") or "")
    return bool(m) and m.group(1) <= "2026.09.28" < m.group(2)


def condizioni(nome, rep):
    """i motivi per cui QUESTO report non e' il giro dichiarato (lista vuota = conforme). Classe 1381: senza questo, (B) veniva
    'giudicata' anche con InpBaseLot=0.02 o su un'altra finestra (contro-esempi 14 e 15 dell'autotest)."""
    m = []
    for nm, val, tipo in INPUT_IMPOSTI:
        v = rep["input"].get(nm)
        if v is None:
            m.append(nm + " ASSENTE dal report")
        elif tipo == "b":
            if v.lower() != val:
                m.append("%s=%s invece di %s" % (nm, v, val))
        else:
            n = numero(v)
            if n is None or abs(n - float(val)) > 1e-9:
                m.append("%s=%s invece di %s" % (nm, v, val))
    if rep.get("deposito") is None or abs(rep["deposito"] - DEPOSITO_ATTESO) > 0.005:
        m.append("deposito %s invece di %.0f" % (rep.get("deposito"), DEPOSITO_ATTESO))
    if rep.get("leva") != LEVA_ATTESA:
        m.append("leva %s invece di %s" % (rep.get("leva"), LEVA_ATTESA))
    if rep.get("simbolo") != "XAUUSD":
        m.append("simbolo %s invece di XAUUSD" % rep.get("simbolo"))
    if not rep.get("expert") or "arena" not in rep["expert"].lower() or len(rep.get("esperti") or []) != 1:
        m.append("Expert %s (celle Expert %d): non e' la sola Arena" % (rep.get("expert"), len(rep.get("esperti") or [])))
    if not (rep.get("qualita") or "").startswith("100%"):
        m.append("qualita' dello storico %s invece di 100%%" % rep.get("qualita"))
    s = sonda_di(nome)
    if s in FINESTRE:
        da, fini = FINESTRE[s]
        p = rep.get("periodo") or ""
        mm = re.match(r"^M1\((\d{4}\.\d\d\.\d\d)-(\d{4}\.\d\d\.\d\d)\)", p)
        if not mm or mm.group(1) != da or mm.group(2) not in fini:
            m.append("periodo %s invece di M1(%s-%s)" % (p or "NON LETTO", da, fini[-1]))
    return m


def verdetti(nome, rep, a, sospesi=None):
    """(A), (B), (C) come scritte nel docstring. Restituisce le righe. Se il giro non e' quello dichiarato (condizioni del report o
    provenienza passata in 'sospesi'), NESSUN verdetto, con i motivi."""
    out = []
    s = sonda_di(nome)
    motivi = list(sospesi or []) + condizioni(nome, rep)
    if motivi:
        txt = "; ".join(motivi[:8]) + ("; ... (%d motivi)" % len(motivi) if len(motivi) > 8 else "")
        for x in ("(A)", "(B)", "(C)"):
            out.append("%s NESSUN verdetto: il giro NON e' quello dichiarato -> %s" % (x, txt))
        return out
    if s in ("SONDA1", "REPORT") and rep["trades"] is not None:
        if rep["trades"] >= 1:
            out.append("(A) VERIFICATA: %d operazioni nel report: l'EA opera nel tester." % rep["trades"])
        else:
            out.append("(A) NON VERIFICATA: ZERO operazioni. MISURA MANCANTE (l'EA non opera o rifiuta il tester), non un errore: leggere log\\%s_*.txt." % s)
    giorni = a["giorni"]
    validi = [(g, v) for g, v in giorni.items() if a["t_stop_out"] is None or g < a["t_stop_out"].date()]
    netti = [v["netto"] for g, v in validi if v["n_in"] > 0 or v["netto"] != 0]
    lati = collections.Counter(k[2] for k in a.get("episodi", {}) if k[0] == "R")
    lati_txt = "cesti [R] buy %d, sell %d (%s: se un lato e' 0 il tester puo' aver usato un altro modo)" % (lati["buy"], lati["sell"], DEMO_ENUM)
    if netti:
        med = statistics.median(netti)
        if s == "SONDA2" and len(netti) < GIORNI_MIN_B:
            quale = "NESSUN verdetto: campione sottile, %d giorni < %d (la regola R59: il campione sottile sospende il MERITO; lo stop out, se c'e', e' il RISCHIO e sta sopra)" % (len(netti), GIORNI_MIN_B)
            esito = "sopra la soglia" if med >= SOGLIA_B else "sotto la soglia"
        elif s == "SONDA2":
            quale = "si GIUDICA qui"
            esito = "REGGE (stesso ordine del demo)" if med >= SOGLIA_B else "SMENTITA (demo ottimista: feed/spread o regime, o un enum diverso dal demo; NON lo slippage, che manca anche qui)"
        else:
            quale = "NESSUN verdetto: %d giorno/i, e la SONDA1 e' il solo giorno sospetto; B si giudica sulla SONDA2" % len(netti)
            esito = "sopra la soglia" if med >= SOGLIA_B else "sotto la soglia"
        tronca = ""
        if a.get("t_stop_out") is not None:
            tronca = " FINESTRA TRONCATA dallo stop out del %s: %d giorni con deal prima di lui." % (a["t_stop_out"].strftime("%Y-%m-%d"), len(netti))
        out.append("(B) mediana del netto per giorno %.2f EUR su %d giorni (prima di uno stop out), media %.2f; soglia %.0f -> %s [%s].%s %s. Demo: %s." % (
            med, len(netti), sum(netti) / len(netti), SOGLIA_B, esito, quale, tronca, lati_txt, ", ".join("%s %+.2f" % x for x in DEMO_GIORNO)))
    elif rep["trades"] is not None and rep["trades"] > 0:
        out.append("(B) NON VALUTABILE: nessun giorno con deal prima dello stop out (o nessun deal letto).")
    soglia = SOGLIA_C * a["deposito"]
    g28 = giorni.get(GIORNO_CROLLO)
    if rep["trades"] is not None and rep["trades"] == 0:
        out.append("(C) NON VALUTABILE: zero operazioni (nessuna esposizione, nessuna caduta possibile: non e' un 'nessuna caduta').")
    elif solo_28(rep):
        if rep["dd_eq_abs"] is None:
            out.append("(C) DD d'equita' del report NON letto: C non valutabile.")
        else:
            esito = "CADUTA" if rep["dd_eq_abs"] >= soglia else "NESSUNA CADUTA"
            out.append("(C) 28/09 (finestra = il solo 28/09, fonte: DD di equita' del report): %.2f EUR (%.2f%%) contro soglia %.2f (10%% di %.0f) -> %s.%s" % (
                rep["dd_eq_abs"], rep["dd_eq_pct"] or 0.0, soglia, a["deposito"], esito,
                "" if esito == "CADUTA" else " NON smentisce l'utente: la SONDA1 non vede il cesto del venerdi' ne' il gap del weekend; decide la SONDA2."))
    elif g28 is not None:
        if a["t_stop_out"] is not None and a["t_stop_out"].date() < GIORNO_CROLLO:
            out.append("(C) 28/09 NON MISURATO da questa sonda: il conto del tester e' andato in STOP OUT il %s, prima del 28/09." % a["t_stop_out"].strftime("%Y-%m-%d %H:%M"))
        else:
            perdita = (g28["saldo_inizio"] - g28["eq_min"]) if (g28["saldo_inizio"] is not None and g28["eq_min"] is not None) else None
            if perdita is None or a["stima_rotta"]:
                out.append("(C) 28/09: perdita d'equita' stimata NON disponibile (stima rotta o saldo d'inizio giorno non letto).")
            else:
                approx = a.get("quota_ambigui", 0.0) > SOGLIA_AMBIGUI
                esito = "CADUTA" if perdita >= soglia else ("NESSUNA CADUTA VISTA (limite inferiore: l'equita' e' campionata agli istanti dei deal)" if not approx else "NESSUNA CADUTA VISTA")
                coda = (" ACCOPPIAMENTO APPROSSIMATO (quota incerta %.1f%% > %.0f%%): l'equita' stimata dipende da quali posizioni risultano ancora vive, quindi il numero NON e' un limite inferiore garantito, in nessuno dei due versi." % (
                    100.0 * a["quota_ambigui"], 100 * SOGLIA_AMBIGUI)) if approx else ""
                out.append("(C) 28/09 (fonte: equita' STIMATA dentro il giorno rispetto al saldo d'inizio giorno %.2f): perdita %.2f EUR (%.1f%% del deposito) contro soglia %.2f -> %s. DD di equita' del report sull'intera finestra: %s EUR (%s%%).%s" % (
                    g28["saldo_inizio"], perdita, 100.0 * perdita / a["deposito"], soglia, esito, fmt(rep["dd_eq_abs"]), fmt(rep["dd_eq_pct"]), coda))
    elif finestra_contiene_28(rep):
        out.append("(C) 28/09: nessun deal quel giorno nel report (l'EA non ha operato il 28/09, o il giorno non ha tick): C NON VALUTABILE da questa sonda.")
    return out


def stampa(nome, rep, a, csv_dir=None, sospesi=None):
    W = print
    s = sonda_di(nome)
    W("=" * 118)
    W("%s  --  %s" % (s, nome))
    W("=" * 118)
    W("Expert %s | simbolo %s | periodo %s | qualita %s | barre %s | tick %s | deposito %s | leva %s" % (
        rep["expert"], rep["simbolo"], rep["periodo"], rep["qualita"], fmt(rep["barre"], 0), fmt(rep["ticks"], 0), fmt(rep["deposito"]), rep["leva"]))
    if len(set(rep["esperti"])) > 1 or len(rep["esperti"]) > 1:
        W("ERRORE: il report ha %d celle Expert (%s): DUE EA nello stesso report, non e' una sonda dell'Arena. Non si legge." % (len(rep["esperti"]), " / ".join(rep["esperti"])))
        return 2
    if rep["expert"] is None or "arena" not in rep["expert"].lower():
        W("ATTENZIONE: l'Expert del report (%s) non contiene 'Arena': report di un altro EA?" % rep["expert"])
    if rep["deposito"] is not None and abs(rep["deposito"] - DEPOSITO_ATTESO) > 0.005:
        W("ATTENZIONE: deposito %.2f invece di %.2f: l'.ini non e' stato applicato come dichiarato (le %% sotto sono sul deposito del report)." % (rep["deposito"], DEPOSITO_ATTESO))
    if rep["leva"] is not None and rep["leva"] != LEVA_ATTESA:
        W("ATTENZIONE: leva %s invece di %s." % (rep["leva"], LEVA_ATTESA))
    if rep["qualita"] is not None and not rep["qualita"].startswith("100%"):
        W("ATTENZIONE: qualita' dello storico %s: NON sono tick reali al 100%%." % rep["qualita"])
    if rep["periodo"] and rep["periodo"].startswith("M1(%s-" % ANCORA_T1[2]):
        ok = rep["ticks"] == ANCORA_T1[0] and rep["barre"] == ANCORA_T1[1]
        W("ANCORA DEL FEED (stessa finestra T1 di GBA, XAUUSD M1 a tick reali su questo PC: %d tick, %d barre [MISURATO 10/10 e 14/10]): %s" % (
            ANCORA_T1[0], ANCORA_T1[1], "UGUALE" if ok else "DIVERSA (tick %s, barre %s): il feed non e' quello del 10-14/10" % (fmt(rep["ticks"], 0), fmt(rep["barre"], 0))))
    # input
    W("")
    W("INPUT (dal report, 'Dati in ingresso': quelli che il tester ha USATO)")
    diversi = []
    for nm, val, tipo in INPUT_IMPOSTI:
        v = rep["input"].get(nm)
        if v is None:
            diversi.append(nm + " ASSENTE")
        elif tipo == "b":
            if v.lower() != val:
                diversi.append("%s=%s (atteso %s)" % (nm, v, val))
        else:
            n = numero(v)
            if n is None or abs(n - float(val)) > 1e-9:
                diversi.append("%s=%s (atteso %s)" % (nm, v, val))
    W("  imposti (14): %s" % ("TUTTI come dichiarato" if not diversi else "DIVERSI: " + "; ".join(diversi)))
    W("  enum NON imposti, valore usato dal tester: %s" % ", ".join("%s=%s" % (e, rep["input"].get(e, "NON NEL REPORT")) for e in INPUT_ENUM))
    altri = [k for k in rep["input"] if k not in dict((x[0], 1) for x in INPUT_IMPOSTI) and k not in INPUT_ENUM]
    if altri:
        W("  input del report fuori dall'elenco dello screenshot: %s" % ", ".join("%s=%s" % (k, rep["input"][k]) for k in altri))
    if not rep["ok"]:
        W("REPORT NON LEGGIBILE: %s" % rep["motivo"])
        return 2
    W("")
    W("RISULTATO (dal report)")
    W("  operazioni %d | netto %.2f EUR | PF %s | DD equita' massimo %s EUR (%s%%) | DD saldo massimo %s EUR (%s%%)" % (
        rep["trades"], rep["profitto"], fmt(rep["pf"]), fmt(rep["dd_eq_abs"]), fmt(rep["dd_eq_pct"]), fmt(rep["dd_bil_abs"]), fmt(rep["dd_bil_pct"])))
    for e in a["errori"]:
        W("  ERRORE: " + e)
    for e in a["avvisi"]:
        W("  AVVISO: " + e)
    if rep["trades"] == 0:
        W("")
        for v in verdetti(nome, rep, a, sospesi):
            W(v)
        return 0
    if any(e.startswith("REPORT TRONCATO") or "deal persi" in e for e in a["errori"]):
        W("  le misure sui deal (giorni, cesti, lotti vivi) NON si stampano: il report non e' intero.")
        return 2
    acc = a["acc"]
    W("  deal di trading %d (ingressi %d, uscite %d), posizioni aperte a fine test %d (il tester le chiude da se' con 'end of test': di norma 0)" % (
        a["n_deal"], a["n_deal"] - a["n_out"], a["n_out"], a["aperte_fine"]))
    if a["stop_out"]:
        W("  STOP OUT: %d deal col commento di stop out, il primo il %s (%s). DA QUI il conto del tester e' MORTO: i giorni dopo non misurano l'EA." % (
            len(a["stop_out"]), a["stop_out"][0]["t"].strftime("%Y-%m-%d %H:%M:%S"), a["stop_out"][0]["commento"]))
    else:
        W("  stop out: NESSUNO (nessun deal col commento 'so ...' / 'stop out')")
    # commissioni
    W("")
    W("COMMISSIONI addebitate dal tester: %.2f EUR su %.2f lotti di deal -> %s EUR per lotto a giro (atteso %.2f [NON VERIFICATO]; demo %.2f [LETTO nel conto]; tester BCM oro %.2f [MISURATO R1A 10/10])" % (
        a["comm_tot"], a["vol_deal"], fmt(a["comm_lotto_giro"]), COMM_ATTESA, COMM_DEMO, COMM_TESTER_GBA))
    W("  a 0,01 lotti la commissione di un deal e' arrotondata al centesimo (1,71 x 0,01 = 0,0171 -> 0,02): il valore per lotto qui sopra e' distorto verso l'ALTO; il totale in EUR e' quello vero.")
    if a["comm_tot"] == 0:
        W("  il tester NON ha addebitato commissioni: il netto e' ottimista di circa %.2f x lotti/2 = %.2f EUR" % (COMM_ATTESA, COMM_ATTESA * a["vol_deal"] / 2.0))
    # prezzo esatto
    sc = a["scarti"]
    if sc:
        esatti = sum(1 for x in sc if abs(x) < 0.005)
        peggio = [x for x in sc if x >= 0.005]
        W("PREZZO ESATTO degli ingressi da ordine stop/limit: %d ingressi, %d esattamente al prezzo dell'ordine (%.1f%%), %d a prezzo PEGGIORE (max %.2f USD, media dei peggiori %.3f), %d migliori. Ingressi a mercato o senza ordine leggibile: %d." % (
            len(sc), esatti, 100.0 * esatti / len(sc), len(peggio), max(peggio) if peggio else 0.0, (sum(peggio) / len(peggio)) if peggio else 0.0,
            sum(1 for x in sc if x <= -0.005), a["n_mercato"]))
        W("  nel tester (ExecutionMode=0) non c'e' latenza: uno scarto > 0 e' un salto fra due tick, non slippage di esecuzione. Demo 14/10: 731/731 esatti [LETTO].")
    else:
        W("PREZZO ESATTO: nessun ingresso da ordine stop/limit con prezzo leggibile (%d a mercato)." % a["n_mercato"])
    # accoppiamento
    W("")
    W("ACCOPPIAMENTO in -> out (ricostruito: il report non ha l'identificativo di posizione): univoci %d, per insieme (cesto intero) %d, stesso cesto %d, AMBIGUI %d (+ %d in grappoli ambigui), parziali %d, senza volume uguale %d, non accoppiati %d -> quota incerta %.1f%% delle uscite" % (
        acc["univoco"], acc["per_insieme"], acc["stesso_cesto"], acc["ambiguo"], acc["ambigui"], acc["parziali"], acc["parziali_senza_volume"], acc["non_accoppiati"], 100.0 * a["quota_ambigui"]))
    approx = a["quota_ambigui"] > SOGLIA_AMBIGUI
    if approx:
        W("  oltre il %.0f%%: i netti PER CESTO qui sotto sono APPROSSIMATI (i netti per giorno e i lotti vivi NO)." % (100 * SOGLIA_AMBIGUI))
    W("  k = %.2f EUR per 1,0 di prezzo x 1 lotto (%s). DD d'equita' STIMATO agli istanti dei deal: %.2f EUR contro %s del report%s." % (
        a["k"], a["k_fonte"], a["dd_eq_stimato"], fmt(rep["dd_eq_abs"]), " -> STIMA ROTTA, colonne equita' da NON leggere" if a["stima_rotta"] else " (la stima deve stare SOTTO o vicino al vero: e' un limite inferiore)"))
    if acc["non_riconosciuti"]:
        W("  ingressi con commento NON riconosciuto (non 'FinlabX/CF/DZR ... [CID=n] [R|F]'): %d -> o commenti diversi nel tester, o operazioni di un ALTRO EA: non entrano nei cesti" % acc["non_riconosciuti"])
    if a["discordi"]:
        W("  ingressi col lato del commento DIVERSO dalla colonna tipo: %d (vale la colonna, classe 1393)" % a["discordi"])
    # giorni
    W("")
    W("PER GIORNO (data server). netto = realizzato (deal del giorno, commissioni comprese); picco lotti vivi = buy + sell lordi; perdite rispetto al saldo d'inizio giorno; equita' STIMATA = limite inferiore della perdita vera")
    W("  %-10s %5s %8s %10s %7s %6s %6s %5s %11s %11s %12s %6s" % ("giorno", "ingr", "lotti_in", "netto", "picco", "buy", "sell", "prof", "saldo_min-", "equita_min-", "flott_peggio", "%dep"))
    righe_csv = []
    for g, v in a["giorni"].items():
        ps = (v["saldo_min"] - v["saldo_inizio"]) if (v["saldo_min"] is not None and v["saldo_inizio"] is not None) else None
        pe = (v["eq_min"] - v["saldo_inizio"]) if (v["eq_min"] is not None and v["saldo_inizio"] is not None and not a["stima_rotta"]) else None
        pct = (100.0 * pe / a["deposito"]) if pe is not None else None
        segno = "  <-- 28/09" if g == GIORNO_CROLLO else ""
        if a["t_stop_out"] is not None and g >= a["t_stop_out"].date():
            segno += "  (stop out)"
        W("  %-10s %5d %8.2f %10.2f %7.2f %6.2f %6.2f %5d %11s %11s %12s %6s%s" % (
            g.isoformat(), v["n_in"], v["lotti_in"], v["netto"], v["picco"], v["picco_buy"], v["picco_sell"], v["prof_max"], fmt(ps), fmt(pe),
            fmt(v["flott_min"]) if not a["stima_rotta"] else "n/d", fmt(pct, 1), segno))
        righe_csv.append([g.isoformat(), v["n_in"], "%.2f" % v["lotti_in"], "%.2f" % v["netto"], "%.2f" % v["picco"], "%.2f" % v["picco_buy"], "%.2f" % v["picco_sell"],
                          v["prof_max"], fmt(ps), fmt(pe), fmt(v["flott_min"]) if not a["stima_rotta"] else "", fmt(pct, 2)])
    # cesti
    eps = [e for k, e in a["episodi"].items() if k[0] == "R"]
    W("")
    if not eps:
        W("CESTI DI RECUPERO [R]: NESSUNO riconosciuto (commenti '... [CID=n] [R]' assenti): l'analisi a cesti NON si fa (misura mancante, non zero).")
    else:
        tot_r = sum(e["netto"] for e in eps)
        W("CESTI DI RECUPERO [R] (CID, lato)%s: %d cesti, netto [R] %.2f EUR, profondita' massima %d, peggior cesto %.2f, aperti a fine test %d" % (
            " -- APPROSSIMATI" if approx else "", len(eps), tot_r, max(e["prof"] for e in eps), min(e["netto"] for e in eps), sum(1 for e in eps if e["aperto"])))
        W("  %-6s %6s %11s %18s %18s %10s %9s" % ("prof.", "cesti", "netto", "somma lotti (max)", "vivi insieme (max)", "in perdita", "durata h"))
        for lo, hi, et in CLASSI_PROF:
            sel = [e for e in eps if lo <= e["prof"] <= hi]
            if not sel:
                W("  %-6s %6d" % (et, 0))
                continue
            dur = max(((e["t1"] or e["t0"]) - e["t0"]).total_seconds() / 3600.0 for e in sel)
            W("  %-6s %6d %11.2f %18.2f %18.2f %10d %9.1f" % (et, len(sel), sum(e["netto"] for e in sel), max(e["lotti"] for e in sel),
                                                              max(e["vivi_max"] for e in sel), sum(1 for e in sel if e["netto"] < 0), dur))
        prof10 = sum(e["netto"] for e in eps if e["prof"] >= 10)
        prof5 = sum(e["netto"] for e in eps if e["prof"] >= 5)
        top3 = sum(sorted((e["netto"] for e in eps), reverse=True)[:3])
        if tot_r != 0:
            W("  CONCENTRAZIONE: cesti >= 10 livelli = %.2f (%.1f%% del netto [R]); >= 5 livelli = %.2f (%.1f%%); 3 cesti migliori = %.2f (%.1f%%). Demo: 24,5%% il 13/10 e 50,8%% il 14/10 dai >= 10 [LETTO]." % (
                prof10, 100 * prof10 / tot_r, prof5, 100 * prof5 / tot_r, top3, 100 * top3 / tot_r))
    fmod = collections.defaultdict(list)
    for c in a["chiuse"]:
        if c["chiave"] is not None and c["chiave"][0] == "F":
            fmod[c["chiave"][1]].append(c["netto"])
    for mnome, v in sorted(fmod.items()):
        W("  modulo [F] %-8s posizioni %6d netto %10.2f PF %s" % (mnome, len(v), sum(v), fmt(pf_di(v))))
    altri_n = [c["netto"] for c in a["chiuse"] if c["chiave"] is None]
    if altri_n:
        W("  commento non riconosciuto: posizioni %d netto %.2f" % (len(altri_n), sum(altri_n)))
    # 28/09
    W("")
    for gv in (GIORNO_CROLLO - datetime.timedelta(days=1), GIORNO_CROLLO + datetime.timedelta(days=1)):
        v = a["giorni"].get(gv)
        if v is not None:
            W("giorno vicino %s (orologio dell'utente NON NOTO): netto %.2f, ingressi %d, picco lotti vivi %.2f, profondita' massima %d" % (gv.isoformat(), v["netto"], v["n_in"], v["picco"], v["prof_max"]))
    g28 = a["giorni"].get(GIORNO_CROLLO)
    if g28 is None:
        W("28/09/2026 (data server BCM): nessun deal in questo report.")
    else:
        e28 = [e for e in eps if e["t0"].date() <= GIORNO_CROLLO and (e["t1"] is None or e["t1"].date() >= GIORNO_CROLLO)]
        W("28/09/2026, ORDINE DI GRANDEZZA: netto realizzato %.2f EUR (%.1f%% del deposito), ingressi %d, lotti d'ingresso %.2f, picco lotti vivi %.2f, profondita' massima viva %d, cesti [R] attraversati %d (netto %.2f)" % (
            g28["netto"], 100 * g28["netto"] / a["deposito"], g28["n_in"], g28["lotti_in"], g28["picco"], g28["prof_max"], len(e28), sum(e["netto"] for e in e28)))
    W("")
    for v in verdetti(nome, rep, a, sospesi):
        W(v)
    W("")
    W("COSA NON SI PUO' CONCLUDERE: un trimestre = un regime; tester senza slippage ne' latenza (ExecutionMode=0); feed BCM, non quello dell'utente; enum al valore del tester (sopra); nessun merito (n per regime, e la natura griglia + scala di lotti + recupero senza SL iniziale resta fuori dall'imbuto prop).")
    if csv_dir:
        os.makedirs(csv_dir, exist_ok=True)
        with open(os.path.join(csv_dir, "%s_giorni.csv" % s), "w", newline="") as fh:
            w = csv.writer(fh, delimiter=";")
            w.writerow(["giorno", "ingressi", "lotti_in", "netto", "picco_lotti", "picco_buy", "picco_sell", "prof_max", "saldo_min_meno_inizio", "equita_min_meno_inizio_stima", "flott_peggio_stima", "pct_deposito"])
            w.writerows(righe_csv)
        with open(os.path.join(csv_dir, "%s_cesti.csv" % s), "w", newline="") as fh:
            w = csv.writer(fh, delimiter=";")
            w.writerow(["cid", "lato", "episodio", "prof", "somma_lotti", "vivi_max", "t0", "t1", "netto", "aperto", "approssimato"])
            for k, e in a["episodi"].items():
                if k[0] == "R":
                    w.writerow([k[1], k[2], k[3], e["prof"], "%.2f" % e["lotti"], "%.2f" % e["vivi_max"], e["t0"], e["t1"], "%.2f" % e["netto"], e["aperto"], approx])
    return 1 if a["errori"] else 0


def leggi_giornali(src):
    """gli estratti dei giornali (log/SONDAx_*.txt): input stampati dopo 'started with inputs', righe di stop out / no money, errori"""
    per = collections.OrderedDict()
    for n in src.nomi():
        b = os.path.basename(n)
        m = re.match(r"^(SONDA[12])_", b)
        if not m or not n.replace("\\", "/").split("/")[-2:-1] == ["log"]:
            continue
        d = per.setdefault(m.group(1), {"input": collections.OrderedDict(), "stop_out": set(), "no_money": set(), "errori": [], "file": 0})
        d["file"] += 1
        dopo = 0
        for r in decodifica(src.leggi(n)).splitlines():
            msg = r.rsplit("\t", 1)[-1]
            if "started with inputs" in r:
                dopo = 80
                continue
            if dopo > 0:
                dopo -= 1
                mi = re.match(r"^\s*([A-Za-z_][A-Za-z0-9_]*)=(.*)$", msg)
                if mi:
                    d["input"][mi.group(1)] = mi.group(2).strip()
                    continue
            if re.search(r"stop ?out", r, re.I):
                d["stop_out"].add(msg.strip())
            if re.search(r"no money|not enough money", r, re.I):
                d["no_money"].add(msg.strip())
            if len(d["errori"]) < 12 and re.search(r"error|failed|cannot|not found|invalid|licen|dll|critical|expired|removed", r, re.I) and not r.startswith("#"):
                if msg.strip() not in d["errori"]:
                    d["errori"].append(msg.strip())
    return per


def stampa_giornali(per):
    if not per:
        print("GIORNALI: nessun estratto log/SONDAx_*.txt nelle sorgenti.")
        return
    for sn, d in per.items():
        print("GIORNALE %s (%d estratti): input stampati dopo 'started with inputs': %s" % (
            sn, d["file"], ", ".join("%s=%s" % kv for kv in d["input"].items()) if d["input"] else "NESSUNO letto (formato [NON VERIFICATO]: fa fede il report)"))
        print("  enum nel giornale: %s | righe distinte di stop out %d, di no money %d" % (
            ", ".join("%s=%s" % (e, d["input"].get(e, "assente")) for e in INPUT_ENUM), len(d["stop_out"]), len(d["no_money"])))
        for x in sorted(d["stop_out"])[:3]:
            print("    stop out: " + x)
        for x in d["errori"][:8]:
            print("    giornale: " + x)


def provenienza(src):
    """classe 1381: il REFERTO dello zip dice QUALE script, QUALE pin, QUANDO e se il .ex5 e' rimasto lo stesso.
    Restituisce (sospesi_comuni, sospesi_per_sonda, righe_da_stampare). Fail-closed: senza REFERTO o con un dato che non torna,
    i verdetti si sospendono (i numeri descrittivi si stampano lo stesso)."""
    comuni, per_sonda, righe = [], collections.defaultdict(list), []
    nomi_ref = [n for n in src.nomi() if os.path.basename(n) == "REFERTO_ARENA_SONDA.txt"]
    if not nomi_ref:
        comuni.append("REFERTO_ARENA_SONDA.txt ASSENTE (report sciolto o zip incompleto): provenienza (script, pin, data, impronta del .ex5) NON verificata")
        return comuni, per_sonda, righe
    if len(nomi_ref) > 1:
        comuni.append("%d REFERTO nella stessa sorgente: non so quale vale" % len(nomi_ref))
    testo = decodifica(src.leggi(nomi_ref[0]))
    rr = testo.splitlines()
    prima = rr[0] if rr else ""
    mpin = re.search(r"\bpin ([0-9a-fA-F]{40})\b", prima)
    mmar = re.search(r"MARCATORE_ARENA_TESTER_SONDA_v\d+", prima)
    mdat = None
    for r in rr[:3]:
        mdat = re.match(r"^data: (\d{4}-\d\d-\d\d) \d\d:\d\d:\d\d", r)
        if mdat:
            break
    pin = mpin.group(1).lower() if mpin else None
    righe.append("PROVENIENZA dal REFERTO: marcatore %s | pin %s | data %s | pin passati dal cancello: %s" % (
        mmar.group(0) if mmar else "ASSENTE", pin or "ASSENTE", mdat.group(1) if mdat else "ASSENTE", ", ".join(PIN_PASSATI) if PIN_PASSATI else "NESSUNO (tupla PIN_PASSATI vuota)"))
    if not mmar or mmar.group(0) != MARCATORE_ATTESO:
        comuni.append("marcatore %s invece di %s" % (mmar.group(0) if mmar else "ASSENTE", MARCATORE_ATTESO))
    if pin is None or pin not in PIN_PASSATI:
        comuni.append("pin %s NON fra quelli passati dal cancello (%s)" % (pin or "ASSENTE", ", ".join(PIN_PASSATI) if PIN_PASSATI else "PIN_PASSATI vuota: va scritto il pin della riga v2"))
    if not mdat or mdat.group(1) < DATA_MINIMA_REFERTO:
        comuni.append("data del REFERTO %s prima del %s (lo script v2 non esisteva)" % (mdat.group(1) if mdat else "ASSENTE", DATA_MINIMA_REFERTO))
    visti = set()
    for r in rr:
        me = re.match(r"^EX5_DOPO (SONDA[12]): (\S+) (UGUALE|DIVERSO)\s*$", r)
        if me:
            visti.add(me.group(1))
            righe.append("impronta del .ex5 dopo %s: %s" % (me.group(1), me.group(3)))
            if me.group(3) != "UGUALE":
                per_sonda[me.group(1)].append("il .ex5 e' CAMBIATO durante la %s (EX5_DOPO DIVERSO): il binario provato non e' quello dell'impronta" % me.group(1))
    for sn in ("SONDA1", "SONDA2"):
        if sn not in visti:
            per_sonda[sn].append("riga EX5_DOPO %s ASSENTE dal REFERTO: impronta del .ex5 dopo la passata NON ricontrollata" % sn)
    return comuni, per_sonda, righe


def leggi_percorsi(percorsi, csv_dir=None):
    rc = 0
    trovati = 0
    for p in percorsi:
        src = Sorgente(p)
        for n in src.nomi():
            b = os.path.basename(n)
            if b in ("REFERTO_ARENA_SONDA.txt",):
                testo = decodifica(src.leggi(n))
                print("-" * 118)
                print("REFERTO dello script (%s) -- righe chiave:" % n)
                for r in testo.splitlines():
                    if re.search(r"MARCATORE|^data:|^EX5:|^EX5_DOPO|^esiti:|STATO|ENUM|NON LANCIATA|stima|ATTENZIONE|^   - ", r):
                        print("  " + r.strip())
        comuni, per_sonda, righe_p = provenienza(src)
        for r in righe_p:
            print(r)
        for x in comuni:
            print("PROVENIENZA NON VERIFICATA: " + x + " -> verdetti SOSPESI")
        stampa_giornali(leggi_giornali(src))
        for n in src.nomi():
            if n.lower().endswith((".htm", ".html")):
                trovati += 1
                rep = leggi_report(src.leggi(n))
                a = analizza(rep) if rep["ok"] else {"errori": [], "avvisi": [], "giorni": {}}
                rc = max(rc, stampa(n, rep, a, csv_dir, comuni + per_sonda.get(sonda_di(n), [])))
    if trovati == 0:
        print("NESSUN report .htm nelle sorgenti date: la sonda non ha misurato niente (guardare il REFERTO e i log).")
        return 2
    return rc


# ---------------------------------------------------------------------------------------------------------------------
#  AUTOTEST: dati finti con risposta nota + contro-esempi
# ---------------------------------------------------------------------------------------------------------------------
def _f(x):
    s = "%.2f" % x
    ip, fp = s.split(".")
    neg = ip.startswith("-")
    ip = ip.lstrip("-")
    g = []
    while len(ip) > 3:
        g.insert(0, ip[-3:])
        ip = ip[:-3]
    g.insert(0, ip)
    return ("-" if neg else "") + " ".join(g) + "." + fp


class Finto:
    """costruisce un report nel formato vero (letto su GBA_R0_R1A_03 del 10/10): testa, Ordini 11 celle, Affari 13 celle"""
    def __init__(self, deposito=5000.0, periodo="M1 (2026.09.28 - 2026.09.29)", expert="Arena Nexus Grid Smart XAU MT5", k=1.0):
        self.dep, self.periodo, self.expert, self.k = deposito, periodo, expert, k
        self.ordini, self.deals = [], []
        self.saldo = deposito
        self.n = 1
        self.inputs = [(x[0], x[1]) for x in INPUT_IMPOSTI] + [("InpTradeMode", "2"), ("InpGoldPulseTheme", "1")]
        self.dd_eq = None
        self.aperte = {}
        self.eq = []

    def _eq(self, px):
        fl = sum((px - pin) * (1 if lato == "buy" else -1) * vol * 100.0 * self.k for lato, vol, pin in self.aperte.values())
        self.eq.append(self.saldo + fl)

    def _deal(self, t, tipo, dir_, vol, px, ordine, comm, prof, comm_txt):
        comm = round(comm, 2)
        self.saldo += prof + comm
        self.deals.append([t, str(self.n), "XAUUSD", tipo, dir_, ("%g" % vol), "%.2f" % px, str(ordine), _f(comm), "0.00", _f(prof), _f(self.saldo), comm_txt])
        self.n += 1

    def apri(self, t, lato, vol, px_ordine, commento, tp=None, sl=None, px_deal=None, stop=True):
        o = self.n
        self.ordini.append([t, str(o), "XAUUSD", lato + (" stop" if stop else ""), "%g / %g" % (vol, vol), "%.2f" % px_ordine if stop else "0.00",
                            "" if sl is None else "%.2f" % sl, "" if tp is None else "%.2f" % tp, t, "filled", commento])
        pd = px_ordine if px_deal is None else px_deal
        self._deal(t, lato, "in", vol, pd, o, -0.0171 * vol / 0.01 * 0.01 * 100, 0.0, commento)
        pid = o
        self.aperte[pid] = (lato, vol, pd)
        self._eq(pd)
        return pid

    def chiudi(self, t, pid, px, commento=""):
        lato, vol, pin = self.aperte.pop(pid)
        prof = (px - pin) * (1 if lato == "buy" else -1) * vol * 100.0 * self.k
        o = self.n
        self.ordini.append([t, str(o), "XAUUSD", "sell" if lato == "buy" else "buy", "%g / %g" % (vol, vol), "0.00", "", "", t, "filled", commento])
        self._deal(t, "sell" if lato == "buy" else "buy", "out", vol, px, o, -0.0171 * vol / 0.01 * 0.01 * 100, round(prof, 2), commento)
        self._eq(px)

    def htm(self, tronca=False, due_ea=False, trades=None):
        def row(c, spans=None):
            return "<tr>" + "".join("<td>%s</td>" % x for x in c) + "</tr>\n"
        h = "<html><body><table>\n"
        h += "<tr><td colspan=13>Report Strategy Tester</td></tr>\n"
        h += "<tr><td colspan=3>Expert:</td><td colspan=10><b>%s</b></td></tr>\n" % self.expert
        if due_ea:
            h += "<tr><td colspan=3>Expert:</td><td colspan=10><b>Altro EA</b></td></tr>\n"
        h += "<tr><td colspan=3>Simbolo:</td><td colspan=10><b>XAUUSD</b></td></tr>\n"
        h += "<tr><td colspan=3>Periodo:</td><td colspan=10><b>%s</b></td></tr>\n" % self.periodo
        h += "<tr><td colspan=3>Dati in ingresso:</td><td colspan=10><b>InpS03FundedPrefix=true</b></td></tr>\n"
        for k, v in self.inputs[1:]:
            h += "<tr><td colspan=3></td><td colspan=10><b>%s=%s</b></td></tr>\n" % (k, v)
        h += "<tr><td colspan=3>Deposito Iniziale:</td><td colspan=10><b>%s</b></td></tr>\n" % _f(self.dep)
        h += "<tr><td colspan=3>Leva:</td><td colspan=10><b>1:500</b></td></tr>\n"
        nt = sum(1 for d in self.deals if d[4] == "out") if trades is None else trades
        prof = self.saldo - self.dep
        ds = [float(d[10].replace(" ", "")) + float(d[8].replace(" ", "")) for d in self.deals]
        ddb = 0.0
        pk = self.dep
        s = self.dep
        for x in ds:
            s += x
            pk = max(pk, s)
            ddb = max(ddb, pk - s)
        pke, dde_v = self.dep, 0.0
        for e in self.eq:
            pke = max(pke, e)
            dde_v = max(dde_v, pke - e)
        dde = self.dd_eq if self.dd_eq is not None else dde_v
        gp = sum(x for x in ds if x > 0)
        gl = -sum(x for x in ds if x < 0)
        h += "<tr><td>Qualit\u00e0 dello Storico:</td><td><b>100% ticks reali</b></td><td>Barre:</td><td><b>1380</b></td><td>Ticks:</td><td><b>280000</b></td></tr>\n"
        h += "<tr><td>Profitto Totale Netto:</td><td><b>%s</b></td><td>Bilancio Drawdown Massimo:</td><td><b>%s (%.2f%%)</b></td><td>Equit\u00e0 Drawdown Massima:</td><td><b>%s (%.2f%%)</b></td></tr>\n" % (
            _f(prof), _f(ddb), 100 * ddb / self.dep, _f(dde), 100 * dde / self.dep)
        h += "<tr><td>Fattore di Profitto:</td><td><b>%s</b></td><td>Numero di Operazioni di Trading Totali:</td><td><b>%d</b></td><td>Affari Totali:</td><td><b>%d</b></td></tr>\n" % (
            ("%.2f" % (gp / gl)) if gl > 0 else "0.00", nt, len(self.deals))
        h += "<tr><th colspan=13><div><b>Ordini</b></div></th></tr>\n"
        h += row(["Orario di Apertura", "Ordine", "Simbolo", "Tipo", "Volume", "Prezzo", "S / L", "T / P", "Ora", "Stato", "Commento"])
        for o in self.ordini:
            h += row(o)
        h += "<tr><th colspan=13><div><b>Affari</b></div></th></tr>\n"
        h += row(["Ora", "Affare", "Simbolo", "Tipo", "Direzione", "Volume", "Prezzo", "Ordine", "Commissioni", "Swap", "Profitto", "Bilancio", "Commento"])
        h += row(["2026.09.28 00:00:00", "0", "", "balance", "", "", "", "", "0.00", "0.00", _f(self.dep), _f(self.dep), ""])
        corpo = [row(d) for d in self.deals]
        if tronca:
            corpo = corpo[:len(corpo) // 2]
            h += "".join(corpo)
            return ("\ufeff" + h).encode("utf-16-le")
        h += "".join(corpo)
        h += "</table></body></html>"
        return ("\ufeff" + h).encode("utf-16-le")


def _scenario_base():
    """un giorno: cesto BUY [R] di 3 livelli (0.01, 0.02, 0.03) a 4000 / 3998 / 3996, chiuso tutto insieme a 3997 (netto noto);
    due [F] CF buy a TP +1,00; uno stop riempito 0,05 peggio; un cesto SELL [R] di 1 livello; giorno dopo: un [F] DZR."""
    F = Finto(periodo="M1 (2026.09.28 - 2026.09.30)")
    a1 = F.apri("2026.09.28 10:00:00", "buy", 0.01, 4000.00, "FinlabX BUY [CID=7] [R]")
    a2 = F.apri("2026.09.28 10:05:00", "buy", 0.02, 3998.00, "FinlabX BUY [CID=7] [R]")
    a3 = F.apri("2026.09.28 10:10:00", "buy", 0.03, 3996.00, "FinlabX BUY [CID=7] [R]", px_deal=3996.05)
    f1 = F.apri("2026.09.28 10:11:00", "buy", 0.01, 3996.50, "CF B [F] [CID=7]", tp=3997.50)
    F.chiudi("2026.09.28 10:12:00", f1, 3997.50, "tp 3997.50")
    for p in (a1, a2, a3):
        F.chiudi("2026.09.28 10:20:00", p, 3997.00, "")
    s1 = F.apri("2026.09.28 11:00:00", "sell", 0.01, 4001.00, "FinlabX SELL [CID=8] [R]")
    F.chiudi("2026.09.28 11:30:00", s1, 4000.00, "")
    d1 = F.apri("2026.09.29 09:00:00", "buy", 0.01, 4010.00, "DZR B [F] [CID=9]", tp=4011.00)
    F.chiudi("2026.09.29 09:03:00", d1, 4011.00, "tp 4011.00")
    return F


def autotest():
    fall = []

    def ok(cond, testo):
        print("  %s  %s" % ("OK  " if cond else "FAIL", testo))
        if not cond:
            fall.append(testo)

    print("AUTOTEST leggi_arena_tester.py")
    # 1. scenario base
    F = _scenario_base()
    rep = leggi_report(F.htm())
    ok(rep["ok"] and rep["expert"].startswith("Arena"), "1a report letto, Expert Arena")
    ok(rep["input"].get("InpBaseLot") == "0.01" and rep["input"].get("InpTradeMode") == "2" and len(rep["input"]) == 16, "1b 16 input letti (14 + 2 enum), celle adiacenti comprese")
    a = analizza(rep)
    ok(not a["errori"], "1c nessun errore di riconciliazione (deposito + deal = ultimo saldo = netto)")
    eps = {k: e for k, e in a["episodi"].items() if k[0] == "R"}
    eb = [e for k, e in eps.items() if k[2] == "buy"][0]
    # netto atteso del cesto: (3997-4000)*0.01*100 + (3997-3998)*0.02*100 + (3997-3996.05)*0.03*100 = -3 -2 +2.85 = -2.15;
    # commissioni 1,71 per lato per lotto arrotondate al centesimo per deal: 0.01 -> 0.02, 0.02 -> 0.03, 0.03 -> 0.05, due lati = -0.20
    comm_b = -0.20
    ok(abs(eb["netto"] - (-2.15 + comm_b)) < 0.011 and eb["prof"] == 3 and abs(eb["lotti"] - 0.06) < 1e-9, "1d cesto BUY CID 7: profondita' 3, lotti 0,06, netto %.2f (atteso %.2f)" % (eb["netto"], -2.15 + comm_b))
    ok(a["acc"]["per_insieme"] == 3 and a["acc"]["ambiguo"] == 0, "1e le tre uscite del cesto accoppiate PER INSIEME (grappolo dello stesso secondo)")
    ok(len(a["scarti"]) == 6 and sum(1 for x in a["scarti"] if x >= 0.005) == 1 and abs(max(a["scarti"]) - 0.05) < 1e-9, "1f prezzo esatto: 6 ingressi stop, 1 peggiore di 0,05")
    # commissioni: 6 posizioni, (0.02+0.03+0.05+0.02+0.02+0.02) x 2 lati = 0.32 EUR su 0.18 lotti di deal -> 3,56 per lotto a giro (l'arrotondamento al centesimo alza il 3,42)
    ok(a["comm_lotto_giro"] is not None and abs(a["comm_lotto_giro"] - 0.32 / 0.18 * 2) < 1e-6 and abs(a["comm_tot"] + 0.32) < 1e-9, "1g commissioni: 0,32 EUR totali, %.4f per lotto a giro (atteso %.4f)" % (a["comm_lotto_giro"] or 0, 0.32 / 0.18 * 2))
    g28 = a["giorni"][datetime.date(2026, 9, 28)]
    ok(abs(g28["picco"] - 0.07) < 1e-9 and g28["n_in"] == 5, "1h 28/09: picco lotti vivi 0,07 (0,06 [R] + 0,01 CF), 5 ingressi")
    ok(abs(sum(v["netto"] for v in a["giorni"].values()) - (rep["profitto"])) < 0.011, "1i somma dei netti per giorno = netto del report")
    ok(abs(a["k"] - 100.0) < 1e-6, "1j k calibrato su 6 posizioni (|delta| >= 0,5) = 100, il k vero del report finto: %.4f" % a["k"])
    # 2. equita' stimata contro un caso calcolato a mano: k vero = 100 (F.k=1 -> profitto = dp*vol*100)
    F2 = Finto(periodo="M1 (2026.09.28 - 2026.09.29)")
    ps = [F2.apri("2026.09.28 10:%02d:00" % i, "buy", 0.01, 4000.0 - 2 * i, "FinlabX BUY [CID=1] [R]") for i in range(6)]
    for p in ps:
        F2.chiudi("2026.09.28 12:00:00", p, 3999.00, "")
    rep2 = leggi_report(F2.htm())
    a2 = analizza(rep2)
    # all'ultimo ingresso (3990) vive 6 posizioni a 4000..3990: flottante = sum(3990 - p) * 0.01 * 100 = -(10+8+6+4+2+0) = -30
    ok(abs(a2["k"] - 100.0) < 1e-6, "2a k calibrato = 100 dalle posizioni accoppiate (atteso 100)")
    fl_min = min(x[2] for x in a2["eq_serie"])
    ok(abs(fl_min - (-30.0)) < 1e-6, "2b flottante stimato peggiore -30,00 all'istante del sesto ingresso (calcolato a mano): %.2f" % fl_min)
    # 3. report senza operazioni
    F3 = Finto()
    rep3 = leggi_report(F3.htm())
    a3 = analizza(rep3)
    v3 = verdetti("ARENA_SONDA1_x.htm", rep3, a3)
    ok(rep3["ok"] and rep3["trades"] == 0 and any(x.startswith("(A) NON VERIFICATA") for x in v3), "3 report a ZERO operazioni: (A) NON VERIFICATA come misura mancante, nessun crash")
    # 4. report troncato
    rep4 = leggi_report(_scenario_base().htm(tronca=True))
    a4 = analizza(rep4)
    ok(any(e.startswith("REPORT TRONCATO") for e in a4["errori"]) or any("deal persi" in e for e in a4["errori"]), "4 report TRONCATO a meta' degli Affari: segnalato, le misure sui deal non valgono")
    # 4b. troncato PRIMA dei risultati
    raw = _scenario_base().htm()
    t = decodifica(raw)
    rep4b = leggi_report(("\ufeff" + t[:t.find("Profitto Totale")]).encode("utf-16-le"))
    ok(not rep4b["ok"], "4b report troncato prima dei risultati: non leggibile, dichiarato")
    # 5. commenti diversi
    F5 = Finto()
    p = F5.apri("2026.09.28 10:00:00", "buy", 0.01, 4000.0, "Sample Comment")
    F5.chiudi("2026.09.28 10:30:00", p, 4001.0, "")
    p = F5.apri("2026.09.28 11:00:00", "buy", 0.01, 4000.0, "FinlabX BUY [CID=3] [R]")
    F5.chiudi("2026.09.28 11:30:00", p, 4001.0, "")
    a5 = analizza(leggi_report(F5.htm()))
    ok(a5["acc"]["non_riconosciuti"] == 1 and len([k for k in a5["episodi"] if k[0] == "R"]) == 1, "5 commento diverso: 1 non riconosciuto, fuori dai cesti; il cesto Arena resta")
    ok(abs(a5["k"] - K_RIPIEGO) < 1e-9 and "ripiego" in a5["k_fonte"], "5c con meno di 5 posizioni utili k = ripiego 89,36 DICHIARATO")
    # 5b. lato del commento discorde dalla colonna tipo (classe 1393)
    F5b = Finto()
    p = F5b.apri("2026.09.28 10:00:00", "sell", 0.01, 4000.0, "FinlabX BUY [CID=4] [R]")
    F5b.chiudi("2026.09.28 10:30:00", p, 3999.0, "")
    a5b = analizza(leggi_report(F5b.htm()))
    ok(a5b["discordi"] == 1 and [k for k in a5b["episodi"]][0][2] == "sell", "5b lato dal commento BUY ma colonna sell: vale la colonna, discordanza contata")
    # 6. due EA nello stesso report
    rep6 = leggi_report(_scenario_base().htm(due_ea=True))
    import contextlib
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        rc6 = stampa("ARENA_SONDA1_x.htm", rep6, analizza(rep6))
    ok(rc6 == 2 and "DUE EA" in buf.getvalue(), "6 due celle Expert: ERRORE 'DUE EA nello stesso report', rc 2")
    # 7. ambiguita': due cesti BUY con lo stesso insieme di volumi chiusi nello stesso secondo
    F7 = Finto()
    x1 = F7.apri("2026.09.28 10:00:00", "buy", 0.01, 4000.0, "FinlabX BUY [CID=1] [R]")
    x2 = F7.apri("2026.09.28 10:01:00", "buy", 0.01, 3999.0, "FinlabX BUY [CID=1] [R]")
    y1 = F7.apri("2026.09.28 10:02:00", "buy", 0.01, 3990.0, "FinlabX BUY [CID=2] [R]")
    y2 = F7.apri("2026.09.28 10:03:00", "buy", 0.01, 3989.0, "FinlabX BUY [CID=2] [R]")
    for p in (y1, y2, x1, x2):
        F7.chiudi("2026.09.28 11:00:00", p, 3995.0, "")
    a7 = analizza(leggi_report(F7.htm()))
    ok(a7["acc"]["ambigui"] >= 2 and a7["quota_ambigui"] > SOGLIA_AMBIGUI, "7 due cesti indistinguibili chiusi insieme: AMBIGUI contati, quota %.0f%% > 5%% -> cesti APPROSSIMATI" % (100 * a7["quota_ambigui"]))
    ok(abs(sum(v["netto"] for v in a7["giorni"].values()) - (F7.saldo - F7.dep)) < 0.011, "7b il netto per giorno NON dipende dall'accoppiamento: torna anche con l'ambiguita'")
    # 8. soglia C: 9,9% contro 10,0% sul DD di equita' del report (finestra = solo 28/09)
    for dd, att in ((495.0, "NESSUNA CADUTA"), (500.0, "CADUTA")):
        F8 = _scenario_base()
        F8.periodo = "M1 (2026.09.28 - 2026.09.29)"
        F8.dd_eq = dd
        r8 = leggi_report(F8.htm())
        v8 = [x for x in verdetti("ARENA_SONDA1_x.htm", r8, analizza(r8)) if x.startswith("(C)")]
        ok(v8 and ("-> " + att) in v8[0], "8 DD equita' %.0f su 5000: '%s'" % (dd, att))
    # 9. stop out: deal col commento 'so ...' -> data del primo stop out; il 28/09 NON misurato se lo stop out e' prima
    F9 = Finto(periodo="M1 (2026.07.01 - 2026.09.30)")
    p = F9.apri("2026.09.01 10:00:00", "buy", 0.10, 4000.0, "FinlabX BUY [CID=1] [R]")
    F9.chiudi("2026.09.01 12:00:00", p, 3600.0, "so: 45.10%/123.00/272.70")
    p = F9.apri("2026.09.28 10:00:00", "buy", 0.01, 4000.0, "FinlabX BUY [CID=2] [R]")
    F9.chiudi("2026.09.28 10:10:00", p, 4001.0, "")
    r9 = leggi_report(F9.htm())
    a9 = analizza(r9)
    v9 = verdetti("ARENA_SONDA2_x.htm", r9, a9)
    ok(a9["t_stop_out"] is not None and any("NON MISURATO" in x and "STOP OUT" in x for x in v9), "9 stop out il 01/09: rilevato, (C) del 28/09 NON MISURATO da questa sonda")
    # 10. riconciliazione rotta: un saldo alterato -> errore
    t10 = decodifica(_scenario_base().htm())
    i10 = t10.rfind("<td>FinlabX SELL")
    rr = t10[:i10]
    j = rr.rfind("</td><td>")
    k10 = rr.rfind("<td>", 0, j)
    t10b = t10[:k10] + "<td>9 999.99" + t10[j:]
    a10 = analizza(leggi_report(("\ufeff" + t10b.lstrip("\ufeff")).encode("utf-16-le")))
    ok(any("deal persi" in e or "diversa" in e for e in a10["errori"]), "10 un valore di un deal alterato (9 999,99): la riconciliazione deposito + deal = ultimo saldo lo segnala")
    # 11. (B): mediana sopra/sotto 100 EUR
    # (secondo giro del cancello 14/10: 21 giorni, perche' sotto GIORNI_MIN_B la (B) della SONDA2 non si giudica; 11b il caso a 19)
    for ng, att11 in ((21, "REGGE"), (19, "NESSUN verdetto: campione sottile")):
        F11 = Finto(periodo="M1 (2026.07.01 - 2026.09.30)")
        for gi in range(ng):
            guad = (150.0, 50.0, 120.0)[gi % 3]
            p = F11.apri("2026.07.%02d 10:00:00" % (gi + 1), "buy", 0.01, 4000.0, "FinlabX BUY [CID=%d] [R]" % (gi + 1))
            F11.chiudi("2026.07.%02d 11:00:00" % (gi + 1), p, 4000.0 + guad, "")
        r11 = leggi_report(F11.htm())
        v11 = [x for x in verdetti("ARENA_SONDA2_x.htm", r11, analizza(r11)) if x.startswith("(B)")]
        ok(v11 and att11 in v11[0] and (att11 == "REGGE" or ("REGGE" not in v11[0] and "SMENTITA" not in v11[0])),
           "11%s (B) %d giorni, mediana ~120 EUR/giorno (150, 50, 120 meno le commissioni): %s" % ("" if ng >= GIORNI_MIN_B else "b", ng, att11))
    # 12. (B) sulla SONDA1: nessun verdetto (un giorno, il giorno sospetto)
    # (controllo-preventivo 14/10: prima usava il report di TRE MESI chiamato SONDA1; ora un report della finestra vera della SONDA1)
    F12 = Finto(periodo="M1 (2026.09.28 - 2026.09.29)")
    p = F12.apri("2026.09.28 10:00:00", "buy", 0.01, 4000.0, "FinlabX BUY [CID=1] [R]")
    F12.chiudi("2026.09.28 11:00:00", p, 4150.0, "")
    r12 = leggi_report(F12.htm())
    ok(not condizioni("ARENA_SONDA1_x.htm", r12), "12a il report finto della SONDA1 e' CONFORME (nessun motivo di sospensione)")
    v12 = [x for x in verdetti("ARENA_SONDA1_x.htm", r12, analizza(r12)) if x.startswith("(B)")]
    ok(v12 and "giorno sospetto" in v12[0] and "REGGE" not in v12[0] and "SMENTITA" not in v12[0], "12 (B) sulla SONDA1 conforme (150 EUR, sopra soglia): stampata SENZA verdetto")
    v12a = [x for x in verdetti("ARENA_SONDA1_x.htm", r12, analizza(r12)) if x.startswith("(A)")]
    ok(v12a and v12a[0].startswith("(A) VERIFICATA"), "12b (A) VERIFICATA sulla SONDA1 conforme")
    # 14. CONTRO-ESEMPIO (classe 1381): SONDA2 girata con InpBaseLot=0.02 -> la v1 diceva '(B) ... REGGE [si GIUDICA qui]'
    F14 = Finto(periodo="M1 (2026.07.01 - 2026.09.30)")
    F14.inputs = [(k, ("0.02" if k == "InpBaseLot" else v)) for k, v in F14.inputs]
    for gi, guad in enumerate((150.0, 120.0, 130.0)):
        p = F14.apri("2026.07.%02d 10:00:00" % (gi + 1), "buy", 0.02, 4000.0, "FinlabX BUY [CID=%d] [R]" % (gi + 1))
        F14.chiudi("2026.07.%02d 11:00:00" % (gi + 1), p, 4000.0 + guad / 2, "")
    r14 = leggi_report(F14.htm())
    v14 = verdetti("ARENA_SONDA2_x.htm", r14, analizza(r14))
    ok(all("NESSUN verdetto" in x for x in v14) and not any("REGGE" in x for x in v14) and any("InpBaseLot=0.02" in x for x in v14), "14 SONDA2 con InpBaseLot=0.02: (A)(B)(C) NESSUN verdetto, motivo stampato")
    # 15. CONTRO-ESEMPIO: SONDA2 su un'altra finestra (agosto-settembre) -> nessun verdetto
    F15 = Finto(periodo="M1 (2026.08.01 - 2026.09.30)")
    p = F15.apri("2026.08.03 10:00:00", "buy", 0.01, 4000.0, "FinlabX BUY [CID=1] [R]")
    F15.chiudi("2026.08.03 11:00:00", p, 4150.0, "")
    r15 = leggi_report(F15.htm())
    v15 = verdetti("ARENA_SONDA2_x.htm", r15, analizza(r15))
    ok(all("NESSUN verdetto" in x for x in v15) and any("periodo" in x for x in v15), "15 SONDA2 sulla finestra sbagliata: NESSUN verdetto")
    # 16. CONTRO-ESEMPIO: chiusura PARZIALE di un cesto con lo stesso insieme di volumi di un altro -> AMBIGUO, non 'per insieme'
    F16 = Finto()
    a1 = F16.apri("2026.09.28 10:00:00", "buy", 0.01, 4000.0, "FinlabX BUY [CID=1] [R]")
    a2_ = F16.apri("2026.09.28 10:01:00", "buy", 0.02, 3998.0, "FinlabX BUY [CID=1] [R]")
    b1 = F16.apri("2026.09.28 10:02:00", "buy", 0.01, 3980.0, "FinlabX BUY [CID=2] [R]")
    b2 = F16.apri("2026.09.28 10:03:00", "buy", 0.02, 3978.0, "FinlabX BUY [CID=2] [R]")
    b3 = F16.apri("2026.09.28 10:04:00", "buy", 0.04, 3976.0, "FinlabX BUY [CID=2] [R]")
    F16.chiudi("2026.09.28 10:30:00", b1, 3990.0, "")
    F16.chiudi("2026.09.28 10:30:00", b2, 3990.0, "")
    for p in (a1, a2_, b3):
        F16.chiudi("2026.09.28 11:00:00", p, 4005.0, "")
    a16 = analizza(leggi_report(F16.htm()))
    ok(a16["acc"]["ambigui"] >= 2 and a16["quota_ambigui"] > SOGLIA_AMBIGUI, "16 parziale del cesto 2 con lo stesso insieme {0.01, 0.02} del cesto 1: AMBIGUO (quota %.0f%%), non 'per insieme'" % (100 * a16["quota_ambigui"]))
    ok(abs(sum(v["netto"] for v in a16["giorni"].values()) - (F16.saldo - F16.dep)) < 0.011, "16b il netto per giorno resta esatto")
    # 16c. il caso normale resta 'per insieme': cesto 1 {0.01, 0.02} chiuso intero, cesto 2 aperto {0.01} (non lo contiene)
    F16c = Finto()
    c1 = F16c.apri("2026.09.28 10:00:00", "buy", 0.01, 4000.0, "FinlabX BUY [CID=1] [R]")
    c2 = F16c.apri("2026.09.28 10:01:00", "buy", 0.02, 3998.0, "FinlabX BUY [CID=1] [R]")
    c3 = F16c.apri("2026.09.28 10:02:00", "buy", 0.01, 3990.0, "FinlabX BUY [CID=2] [R]")
    F16c.chiudi("2026.09.28 10:30:00", c1, 4001.0, "")
    F16c.chiudi("2026.09.28 10:30:00", c2, 4001.0, "")
    F16c.chiudi("2026.09.28 11:00:00", c3, 3995.0, "")
    a16c = analizza(leggi_report(F16c.htm()))
    ok(a16c["acc"]["per_insieme"] == 2 and a16c["acc"]["ambigui"] == 0, "16c caso normale: cesto intero chiuso, l'altro non contiene il suo insieme -> 'per insieme'")
    # 16d. CONTRO-ESEMPIO del secondo giro (14/10): cesto 1 {0.01, 0.02}, cesto 2 {0.01, 0.04}, cesto 3 {0.02, 0.08}; nello stesso
    # secondo escono lo 0.01 del cesto 2 e lo 0.02 del cesto 3. Nessun ALTRO cesto da solo contiene {0.01, 0.02}: la v2 contava il
    # cesto 1 'per insieme' (certo, quota incerta 0%). L'unione dei cesti 2 e 3 lo contiene: deve essere AMBIGUO.
    F16d = Finto()
    d1 = F16d.apri("2026.09.28 10:00:00", "buy", 0.01, 4000.0, "FinlabX BUY [CID=1] [R]")
    d2 = F16d.apri("2026.09.28 10:01:00", "buy", 0.02, 3998.0, "FinlabX BUY [CID=1] [R]")
    e1 = F16d.apri("2026.09.28 10:02:00", "buy", 0.01, 3990.0, "FinlabX BUY [CID=2] [R]")
    e2 = F16d.apri("2026.09.28 10:03:00", "buy", 0.04, 3985.0, "FinlabX BUY [CID=2] [R]")
    f1 = F16d.apri("2026.09.28 10:04:00", "buy", 0.02, 3980.0, "FinlabX BUY [CID=3] [R]")
    f2 = F16d.apri("2026.09.28 10:05:00", "buy", 0.08, 3975.0, "FinlabX BUY [CID=3] [R]")
    F16d.chiudi("2026.09.28 10:30:00", e1, 3995.0, "")
    F16d.chiudi("2026.09.28 10:30:00", f1, 3995.0, "")
    for p in (d1, d2, e2, f2):
        F16d.chiudi("2026.09.28 11:00:00", p, 4005.0, "")
    a16d = analizza(leggi_report(F16d.htm()))
    ok(a16d["acc"]["ambigui"] >= 2 and a16d["quota_ambigui"] > SOGLIA_AMBIGUI,
       "16d {0.01 del cesto 2 + 0.02 del cesto 3} nello stesso secondo, cesto 1 = {0.01, 0.02}: AMBIGUO (quota %.0f%%), non 'per insieme'" % (100 * a16d["quota_ambigui"]))
    ok(abs(sum(v["netto"] for v in a16d["giorni"].values()) - (F16d.saldo - F16d.dep)) < 0.011, "16e il netto per giorno resta esatto anche nel 16d")
    # 17. stop out il primo giorno della SONDA2: (B) NON VALUTABILE, non un verdetto su zero giorni; stop out dopo 2 giorni: TRONCATA
    F17 = Finto(periodo="M1 (2026.07.01 - 2026.09.30)")
    p = F17.apri("2026.07.01 10:00:00", "buy", 0.10, 4000.0, "FinlabX BUY [CID=1] [R]")
    F17.chiudi("2026.07.01 12:00:00", p, 3600.0, "so: 45.10%/123.00/272.70")
    r17 = leggi_report(F17.htm())
    v17 = [x for x in verdetti("ARENA_SONDA2_x.htm", r17, analizza(r17)) if x.startswith("(B)")]
    ok(v17 and "NON VALUTABILE" in v17[0], "17 stop out il primo giorno: (B) NON VALUTABILE (la partizione non resta muta)")
    F17b = Finto(periodo="M1 (2026.07.01 - 2026.09.30)")
    for gi in (1, 2):
        p = F17b.apri("2026.07.%02d 10:00:00" % gi, "buy", 0.01, 4000.0, "FinlabX BUY [CID=%d] [R]" % gi)
        F17b.chiudi("2026.07.%02d 11:00:00" % gi, p, 4150.0, "")
    p = F17b.apri("2026.07.03 10:00:00", "buy", 0.10, 4000.0, "FinlabX BUY [CID=9] [R]")
    F17b.chiudi("2026.07.03 12:00:00", p, 3600.0, "so: 45.10%/123.00/272.70")
    r17b = leggi_report(F17b.htm())
    v17b = [x for x in verdetti("ARENA_SONDA2_x.htm", r17b, analizza(r17b)) if x.startswith("(B)")]
    ok(v17b and "FINESTRA TRONCATA" in v17b[0] and "2 giorni" in v17b[0] and "sell 0" in v17b[0], "17b stop out dopo 2 giorni: (B) dice FINESTRA TRONCATA, 2 giorni, e i lati dei cesti (sell 0)")
    # 17c. CONTRO-ESEMPIO del secondo giro (14/10): con lo stop out al terzo giorno la v2 stampava '(B) ... REGGE [si GIUDICA qui]' su 2 giorni
    ok(v17b and "NESSUN verdetto: campione sottile" in v17b[0] and "REGGE" not in v17b[0] and "SMENTITA" not in v17b[0],
       "17c stop out dopo 2 giorni: (B) NESSUN verdetto (campione sottile), ne' REGGE ne' SMENTITA")
    # 18. PROVENIENZA (classe 1381): REFERTO di un altro pin, di un altro giorno, del marcatore v1, senza EX5_DOPO, con EX5 DIVERSO
    global PIN_PASSATI
    import tempfile
    salva = PIN_PASSATI
    PIN_PASSATI = ("a" * 40,)
    try:
        def ref(pin="a" * 40, mar="MARCATORE_ARENA_TESTER_SONDA_v3", data="2026-10-15", ex=("UGUALE", "UGUALE")):
            t = "ARENA TESTER SONDA -- EA di TERZI. Script %s, pin %s\r\ndata: %s 10:00:00   pc: DESKTOP-H4D7CAJ\r\n" % (mar, pin, data)
            for sn, e in zip(("SONDA1", "SONDA2"), ex):
                if e:
                    t += "EX5_DOPO %s: %s %s\r\n" % (sn, "B" * 64, e)
            return t
        casi = (("buono", ref(), 0, 0), ("altro pin", ref(pin="b" * 40), 1, 0), ("altro giorno", ref(data="2026-10-13"), 1, 0),
                ("marcatore v1", ref(mar="MARCATORE_ARENA_TESTER_SONDA_v1"), 1, 0), ("ex5 DIVERSO", ref(ex=("DIVERSO", "UGUALE")), 0, 1),
                ("EX5_DOPO assente", ref(ex=("UGUALE", None)), 0, 0))
        for nome_c, testo_c, att_com, att_s1 in casi:
            with tempfile.TemporaryDirectory() as td:
                open(os.path.join(td, "REFERTO_ARENA_SONDA.txt"), "w").write(testo_c)
                com, per, _r = provenienza(Sorgente(td))
            ok(len(com) == att_com and len(per.get("SONDA1", [])) == att_s1 and (nome_c != "EX5_DOPO assente" or len(per.get("SONDA2", [])) == 1),
               "18 provenienza '%s': %d motivi comuni (attesi %d), SONDA1 %d (attesi %d)" % (nome_c, len(com), att_com, len(per.get("SONDA1", [])), att_s1))
        with tempfile.TemporaryDirectory() as td:
            com, per, _r = provenienza(Sorgente(td))
        ok(len(com) == 1 and "ASSENTE" in com[0], "18b REFERTO assente: provenienza NON verificata, verdetti sospesi")
    finally:
        PIN_PASSATI = salva
    with tempfile.TemporaryDirectory() as td:
        open(os.path.join(td, "REFERTO_ARENA_SONDA.txt"), "w").write("Script MARCATORE_ARENA_TESTER_SONDA_v3, pin %s\r\ndata: 2026-10-15 10:00:00\r\n" % ("a" * 40))
        com, per, _r = provenienza(Sorgente(td))
    ok(PIN_PASSATI or any("PIN_PASSATI vuota" in x for x in com), "18c con PIN_PASSATI vuota ogni zip e' SOSPESO (fail-closed finche' il pin v2 non e' scritto)")
    v18 = verdetti("ARENA_SONDA1_x.htm", r12, analizza(r12), ["pin X NON fra quelli passati"])
    ok(all("NESSUN verdetto" in x for x in v18) and len(v18) == 3, "18d un motivo di provenienza sospende (A)(B)(C) anche su un report conforme")
    # 13. gli estratti dei giornali: input dopo 'started with inputs' (enum compresi), stop out, righe di errore; un file fuori da log/ NON conta
    import tempfile
    with tempfile.TemporaryDirectory() as td:
        os.makedirs(os.path.join(td, "log"))
        righe = ["# giornale finto", "XX\t0\t12:00:00.000\tTester\tXAUUSD,M1: testing of Experts\\Market\\Arena.ex5 from 2026.09.28 00:00 to 2026.09.29 00:00 started with inputs:",
                 "XX\t0\t12:00:00.000\tTester\t  InpBaseLot=0.01", "XX\t0\t12:00:00.000\tTester\t  InpTradeMode=2",
                 "XX\t0\t12:00:00.000\tTester\tXAUUSD,M1: 280000 ticks, 1380 bars generated",
                 "XX\t0\t12:00:00.000\tTrade\t2026.09.28 15:00:00   stop out occurred on 50% level", "XX\t0\t12:00:00.000\tTrade\t2026.09.28 15:00:00   failed market buy 0.01 XAUUSD [No money]"]
        open(os.path.join(td, "log", "SONDA1_01_logs_20261014.log.txt"), "w").write("\n".join(righe))
        open(os.path.join(td, "SONDA2_fuori.txt"), "w").write("\n".join(righe))
        g = leggi_giornali(Sorgente(td))
    ok(list(g) == ["SONDA1"] and g["SONDA1"]["input"].get("InpTradeMode") == "2" and len(g["SONDA1"]["input"]) == 2 and len(g["SONDA1"]["stop_out"]) == 1
       and len(g["SONDA1"]["no_money"]) == 1, "13 estratti dei giornali: 2 input (enum InpTradeMode=2), 1 stop out, 1 no money; il file fuori da log/ ignorato")
    print("")
    if fall:
        print("AUTOTEST: %d controlli FALLITI" % len(fall))
        return 1
    print("AUTOTEST: tutti i controlli OK")
    return 0


def main():
    ap = argparse.ArgumentParser(description="lettore della sonda Arena nello Strategy Tester (sola lettura)")
    ap.add_argument("percorsi", nargs="*")
    ap.add_argument("--csv-dir", default=None)
    ap.add_argument("--autotest", action="store_true")
    x = ap.parse_args()
    if x.autotest:
        return autotest()
    if not x.percorsi:
        ap.error("serve uno zip, una cartella o un report .htm (oppure --autotest)")
    return leggi_percorsi(x.percorsi, x.csv_dir)


if __name__ == "__main__":
    sys.exit(main())
