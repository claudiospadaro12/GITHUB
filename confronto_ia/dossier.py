#!/usr/bin/env python3
"""Costruisce il DOSSIER di un EA: un unico file markdown, autoconsistente,
da dare a ChatGPT (o a qualunque altra IA) perche' possa dare un secondo parere
sull'ottimizzazione dei parametri.

Dentro il dossier finisce SOLO roba vera, letta dal repo:
  - contesto operativo fisso (broker, fuso orario, regole prop, money management)
  - descrizione della strategia (intestazione del .mq5)
  - parametri ATTUALI dell'EA (blocco input del .mq5)
  - griglia di ottimizzazione usata (backtest_pipeline/ea_config.json)
  - risultati di ottimizzazione: % combinazioni positive, top set, e soprattutto
    l'analisi PARAMETRO PER PARAMETRO (plateau vs picco isolato)
  - risultati forward/backtest gia' annotati nei file di progetto
  - le domande a cui l'altra IA deve rispondere + il formato di risposta

Se un dato manca, il dossier lo scrive: "DATO NON DISPONIBILE". Mai numeri inventati.

Uso:
    python confronto_ia/dossier.py ABTG_SupRev_DAX_H4_Ottimizzato
    python confronto_ia/dossier.py ABTG_DAX_Apertura_EU --codice --out dossier.md
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import statistics
import sys
import xml.etree.ElementTree as ET
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXPERTS = ROOT / "mql5" / "Experts"
EA_CONFIG = ROOT / "backtest_pipeline" / "ea_config.json"
CONTESTO = Path(__file__).resolve().parent / "contesto" / "contesto_base.md"
PROTOCOLLO = Path(__file__).resolve().parent / "PROTOCOLLO.md"
CARTELLE_RISULTATI = [
    ROOT / "backtest_pipeline" / "risultati_ottimizzazione",
    ROOT / "backtest_pipeline" / "risultati_archivio",
]
DOC_PROGETTO = [
    ROOT / "backtest_pipeline" / "TRACKING_FORWARD.md",
    ROOT / "backtest_pipeline" / "RIEPILOGO_FORWARD.md",
    ROOT / "backtest_pipeline" / "RISULTATI_OTTIMIZZAZIONE.md",
    ROOT / "backtest_pipeline" / "CLASSIFICA_PF.md",
    ROOT / "backtest_pipeline" / "REGISTRO_TEST.md",
]

# Alias simbolo: "DAX" nel nome dell'EA -> "D30EUR" nel nome del file risultati.
ALIAS_SIMBOLI = {
    "dax": ["d30eur", "de40", "ger40"],
    "nas": ["nasusd", "nas100", "nasdaq"],
    "nasdaq": ["nasusd", "nas100"],
    "dow": ["u30usd", "us30"],
    "cac": ["f40eur"],
    "gold": ["xauusd", "oro"],
    "oro": ["xauusd"],
    "eurusd": ["eurusd"],
    "gbpusd": ["gbpusd"],
}
# Parole che non aiutano a riconoscere il file dei risultati.
STOPWORD = {"abtg", "ottimizzato", "ott", "ea", "multi", "valid", "v2"}

ESTENSIONI_RISULTATI = (".csv", ".tsv", ".xml", ".xlsx", ".xls", ".xlsm")

# Metriche riconosciute nelle intestazioni MT5 (EN + IT).
METRICHE = {
    "profit": {"profit", "profitto"},
    "profit_factor": {"profit factor", "fattore di profitto"},
    "recovery": {"recovery factor", "fattore di recupero"},
    "drawdown": {"equity dd %", "equity dd%", "drawdown", "drawdown %", "drawdown massimo %"},
    "trades": {"trades", "trade", "operazioni", "deals"},
    "expected_payoff": {"expected payoff", "payoff atteso", "payoff previsto"},
    "sharpe": {"sharpe ratio", "sharpe", "indice di sharpe"},
    "result": {"result", "risultato"},
    "pass": {"pass", "passaggio", "#"},
}


# ------------------------------------------------------------------ #
#  Lettura del sorgente dell'EA                                      #
# ------------------------------------------------------------------ #
def trova_ea(nome: str) -> Path:
    """Trova il .mq5 dell'EA: nome esatto, poi ricerca tollerante."""
    nome = nome.strip().replace(".mq5", "")
    esatto = EXPERTS / f"{nome}.mq5"
    if esatto.is_file():
        return esatto
    candidati = [p for p in EXPERTS.rglob("*.mq5") if p.stem.lower() == nome.lower()]
    if not candidati:
        candidati = [p for p in EXPERTS.rglob("*.mq5") if nome.lower() in p.stem.lower()]
    if not candidati:
        raise SystemExit(
            f"EA '{nome}' non trovato in {EXPERTS}.\n"
            f"Disponibili: {', '.join(sorted(p.stem for p in EXPERTS.glob('*.mq5')))}"
        )
    # Preferisci il file direttamente in Experts/ (non standalone/ o copie).
    candidati.sort(key=lambda p: (p.parent != EXPERTS, len(p.stem)))
    return candidati[0]


def leggi_sorgente(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def estrai_intestazione(src: str) -> str:
    """Il blocco di commento iniziale: e' li' che e' descritta la strategia."""
    righe = []
    for riga in src.splitlines():
        s = riga.strip()
        if s.startswith("//"):
            righe.append(re.sub(r"^//[+|\s]*", "", riga).rstrip("|+ ").rstrip())
        elif s.startswith("#property description"):
            righe.append(s)
        elif righe and not s:
            continue
        elif righe:
            break
    testo = "\n".join(r for r in righe if r.strip())
    return testo or "DATO NON DISPONIBILE (nessuna intestazione descrittiva nel .mq5)"


def estrai_inputs(src: str) -> list[dict]:
    """Estrae gli `input` con gruppo, tipo, nome, valore di default e commento."""
    out: list[dict] = []
    gruppo = "(senza gruppo)"
    re_group = re.compile(r'^\s*input\s+group\s+"(.*?)"')
    re_input = re.compile(
        r'^\s*(?:extern|input)\s+(?!group\b)([A-Za-z_][\w:<>\s]*?)\s+'
        r'(\w+)\s*=\s*([^;]+);\s*(?://\s*(.*))?$'
    )
    for riga in src.splitlines():
        g = re_group.match(riga)
        if g:
            gruppo = g.group(1).strip("= ").strip()
            continue
        m = re_input.match(riga)
        if m:
            out.append({
                "gruppo": gruppo,
                "tipo": m.group(1).strip(),
                "nome": m.group(2).strip(),
                "valore": m.group(3).strip(),
                "commento": (m.group(4) or "").strip(),
            })
    return out


def risolvi_costanti(src: str, inputs: list[dict]) -> list[dict]:
    """Molti EA usano `#define ABTG_DEF_X 700` come default: risolvo il numero."""
    define = dict(re.findall(r"^\s*#define\s+(\w+)\s+([^\s/]+)", src, re.M))
    for i in inputs:
        v = i["valore"]
        if v in define:
            i["valore"] = f"{define[v]}  (via {v})"
    return inputs


def estrai_magic(src: str) -> str:
    m = re.search(r"(?:InpMagic\w*|MagicNumber)\s*=\s*(\d+)", src)
    return m.group(1) if m else "DATO NON DISPONIBILE"


# ------------------------------------------------------------------ #
#  Config di ottimizzazione                                          #
# ------------------------------------------------------------------ #
def config_ea(nome_ea: str) -> tuple[dict | None, dict]:
    """Ritorna (voce dell'EA in ea_config.json, defaults). Prova anche il nome base."""
    if not EA_CONFIG.is_file():
        return None, {}
    cfg = json.loads(EA_CONFIG.read_text(encoding="utf-8"))
    defaults = cfg.get("defaults", {})
    base = nome_ea.replace("_Ottimizzato", "")
    for voce in cfg.get("experts", []):
        if voce.get("file", "").lower() in (nome_ea.lower(), base.lower()):
            return voce, defaults
    # Le varianti (es. ABTG_MaxMinNotte_DAX_Short_Ottimizzato) non stanno in config:
    # uso la griglia dell'EA di partenza (ABTG_MaxMinNotte), segnalandolo nel dossier.
    prefissi = [v for v in cfg.get("experts", [])
                if v.get("file") and base.lower().startswith(v["file"].lower())]
    if prefissi:
        voce = max(prefissi, key=lambda v: len(v["file"]))
        voce = dict(voce, _ereditata_da=voce["file"])
        return voce, defaults
    return None, defaults


# ------------------------------------------------------------------ #
#  Risultati di ottimizzazione                                       #
# ------------------------------------------------------------------ #
def _token(nome_ea: str) -> set[str]:
    grezzi = re.split(r"[_\-\s]+", nome_ea.lower())
    tok = {t for t in grezzi if len(t) >= 2 and t not in STOPWORD}
    for t in list(tok):
        tok.update(ALIAS_SIMBOLI.get(t, []))
    return tok


def trova_risultati(nome_ea: str, limite: int = 3) -> list[Path]:
    """Cerca i file di risultati piu' plausibili per questo EA (per punteggio)."""
    tok = _token(nome_ea)
    punteggi: list[tuple[int, Path]] = []
    for cartella in CARTELLE_RISULTATI:
        if not cartella.is_dir():
            continue
        for p in cartella.rglob("*"):
            if p.suffix.lower() not in ESTENSIONI_RISULTATI or not p.is_file():
                continue
            testo = f"{p.parent.name} {p.stem}".lower()
            punti = sum(1 for t in tok if t in testo)
            if punti:
                punteggi.append((punti, p))
    if not punteggi:
        return []
    # Tengo SOLO i file che combaciano meglio (stesso punteggio massimo): evita di
    # infilare nel dossier ottimizzazioni di un altro simbolo con nome simile.
    massimo = max(p[0] for p in punteggi)
    punteggi = [x for x in punteggi if x[0] == massimo]
    punteggi.sort(key=lambda x: x[1].name)
    return [p for _, p in punteggi[:limite]]


def _canonica(header: str) -> str | None:
    h = header.strip().lower().replace("_", " ")
    for canon, alias in METRICHE.items():
        if h in alias:
            return canon
    return None


def _carica_tabella(path: Path) -> tuple[list[str], list[list[str]]]:
    """Legge CSV/TSV o l'XML SpreadsheetML di MT5. Solo stdlib: niente pandas."""
    if path.suffix.lower() in (".csv", ".tsv"):
        delim = "\t" if path.suffix.lower() == ".tsv" else ","
        with path.open(newline="", encoding="utf-8-sig", errors="replace") as fh:
            righe = list(csv.reader(fh, delimiter=delim))
        if not righe:
            raise ValueError("file vuoto")
        return righe[0], righe[1:]
    if path.suffix.lower() == ".xml":
        ns = {"ss": "urn:schemas-microsoft-com:office:spreadsheet"}
        root = ET.parse(path).getroot()
        righe = []
        for row in root.iter(f"{{{ns['ss']}}}Row"):
            celle = []
            for cell in row.findall(f"{{{ns['ss']}}}Cell"):
                data = cell.find(f"{{{ns['ss']}}}Data")
                celle.append((data.text or "").strip() if data is not None else "")
            righe.append(celle)
        if not righe:
            raise ValueError("XML senza righe")
        return righe[0], righe[1:]
    raise ValueError(f"formato non leggibile senza dipendenze extra: {path.suffix}")


def _num(v: str):
    try:
        return float(str(v).replace(" ", "").replace(",", "."))
    except (TypeError, ValueError):
        return None


def riassumi_risultati(path: Path, top: int = 5, min_trades: int = 20) -> str:
    """Sintesi onesta di un file di ottimizzazione: quanto e' robusto il parco set."""
    try:
        header, righe = _carica_tabella(path)
    except Exception as e:  # file non leggibile: lo dico, non invento
        return f"- `{path.relative_to(ROOT)}`: NON LEGGIBILE ({e})"

    idx_metriche = {}
    idx_param = {}
    for i, h in enumerate(header):
        canon = _canonica(h)
        if canon:
            idx_metriche.setdefault(canon, i)
        elif h.strip() and not h.lower().startswith("unnamed"):
            idx_param[h.strip()] = i

    if not ({"profit", "profit_factor", "result"} & set(idx_metriche)) or not idx_param:
        return f"- `{path.relative_to(ROOT)}`: non e' una tabella di ottimizzazione (saltato)"

    col_profit = idx_metriche.get("profit", idx_metriche.get("result"))
    col_pf = idx_metriche.get("profit_factor")
    col_tr = idx_metriche.get("trades")
    col_dd = idx_metriche.get("drawdown")
    col_rec = idx_metriche.get("recovery")

    dati = []
    for r in righe:
        if len(r) < len(header):
            r = r + [""] * (len(header) - len(r))
        profit = _num(r[col_profit]) if col_profit is not None else None
        if profit is None:
            continue
        dati.append({
            "riga": r,
            "profit": profit,
            "pf": _num(r[col_pf]) if col_pf is not None else None,
            "trades": _num(r[col_tr]) if col_tr is not None else None,
            "dd": _num(r[col_dd]) if col_dd is not None else None,
            "rec": _num(r[col_rec]) if col_rec is not None else None,
        })
    if not dati:
        return f"- `{path.relative_to(ROOT)}`: nessuna riga numerica valida"

    tot = len(dati)
    pos = sum(1 for d in dati if d["profit"] > 0)
    validi = [d for d in dati if (d["trades"] or 0) >= min_trades] or dati

    out = [f"### File `{path.relative_to(ROOT)}`", ""]
    out.append(f"- combinazioni testate: **{tot}**")
    out.append(f"- combinazioni in profitto: **{pos} ({pos*100//tot}%)** "
               f"← superficie robusta se alta, fortuna isolata se bassa")
    if col_tr is not None:
        out.append(f"- combinazioni con almeno {min_trades} trade: {sum(1 for d in dati if (d['trades'] or 0) >= min_trades)}")
    out.append("")

    # Top set per Profit Factor (a parita' di filtro trade minimo).
    chiave = (lambda d: (d["pf"] if d["pf"] is not None else -9e9)) if col_pf is not None \
        else (lambda d: d["profit"])
    migliori = sorted(validi, key=chiave, reverse=True)[:top]
    param_variabili = [p for p, i in idx_param.items()
                       if len({r["riga"][i] for r in dati}) > 1][:12]
    intest = ["PF", "Profit", "Trade", "DD%", "Recovery"] + param_variabili
    out.append("**Top set (per Profit Factor):**")
    out.append("")
    out.append("| " + " | ".join(intest) + " |")
    out.append("|" + "---|" * len(intest))
    for d in migliori:
        cells = [
            f"{d['pf']:.2f}" if d["pf"] is not None else "-",
            f"{d['profit']:.0f}",
            f"{d['trades']:.0f}" if d["trades"] is not None else "-",
            f"{d['dd']:.1f}" if d["dd"] is not None else "-",
            f"{d['rec']:.2f}" if d["rec"] is not None else "-",
        ] + [d["riga"][idx_param[p]] for p in param_variabili]
        out.append("| " + " | ".join(cells) + " |")
    out.append("")

    # Analisi parametro per parametro: e' un plateau o un picco isolato?
    out.append("**Robustezza per singolo parametro** (per ogni valore: quante "
               "combinazioni restano in profitto e il PF mediano):")
    out.append("")
    for p in param_variabili:
        i = idx_param[p]
        valori = sorted({r["riga"][i] for r in dati}, key=lambda v: (_num(v) is None, _num(v), v))
        if len(valori) > 12:
            continue
        pezzi = []
        for v in valori:
            gruppo = [d for d in dati if d["riga"][i] == v]
            if not gruppo:
                continue
            quota = sum(1 for d in gruppo if d["profit"] > 0) * 100 // len(gruppo)
            pf_list = [d["pf"] for d in gruppo if d["pf"] is not None]
            pf_med = f"{statistics.median(pf_list):.2f}" if pf_list else "-"
            pezzi.append(f"{v}: {quota}% pos, PF med {pf_med}")
        out.append(f"- `{p}` → " + " | ".join(pezzi))
    out.append("")
    return "\n".join(out)


# ------------------------------------------------------------------ #
#  Estratti dai documenti di progetto                                #
# ------------------------------------------------------------------ #
def estratti_documenti(nome_ea: str, max_righe: int = 12) -> str:
    """Righe dei file di progetto che citano questo EA (forward, classifiche...)."""
    chiave = nome_ea.replace("ABTG_", "").replace("_Ottimizzato", "")
    # Cerco il nome della STRATEGIA, non parole comuni come "short" o "multi":
    # altrimenti il dossier si riempie di righe che parlano di altri EA.
    generiche = {"short", "long", "multi", "base", "live", "study", "indici"}
    pezzi_chiave = [chiave] + [t for t in re.split(r"[_\-]", chiave)
                               if len(t) >= 5 and t.lower() not in generiche]
    blocchi = []
    for doc in DOC_PROGETTO:
        if not doc.is_file():
            continue
        trovate = [r.strip() for r in doc.read_text(encoding="utf-8", errors="replace").splitlines()
                   if any(k.lower() in r.lower() for k in pezzi_chiave)]
        if trovate:
            blocchi.append(f"**{doc.relative_to(ROOT)}**\n```\n" +
                           "\n".join(trovate[:max_righe]) + "\n```")
    return "\n\n".join(blocchi) or "DATO NON DISPONIBILE (nessuna nota su questo EA nei file di progetto)"


# ------------------------------------------------------------------ #
#  Composizione del dossier                                          #
# ------------------------------------------------------------------ #
def componi(nome_ea: str, domanda: str = "", con_codice: bool = False) -> str:
    path = trova_ea(nome_ea)
    nome_ea = path.stem
    src = leggi_sorgente(path)
    inputs = risolvi_costanti(src, estrai_inputs(src))
    voce, defaults = config_ea(nome_ea)
    risultati = trova_risultati(nome_ea)

    contesto = CONTESTO.read_text(encoding="utf-8") if CONTESTO.is_file() else "DATO NON DISPONIBILE"
    protocollo = PROTOCOLLO.read_text(encoding="utf-8") if PROTOCOLLO.is_file() else ""

    p: list[str] = []
    p.append(f"# DOSSIER EA — {nome_ea}")
    p.append("")
    p.append(f"_Generato automaticamente da Claude Code il {date.today().isoformat()} "
             f"dal repository di progetto. Ogni numero qui dentro e' letto dai file reali; "
             f"dove manca il dato c'e' scritto **DATO NON DISPONIBILE**._")
    p.append("")
    p.append("## 0. Cosa ti chiedo (leggi prima il paragrafo 8: formato di risposta)")
    p.append("")
    p.append(domanda.strip() or
             "Dimmi se i parametri attuali di questo EA sono ottimizzati al massimo "
             "o se c'e' margine di miglioramento, e perche'. Mi interessa la ROBUSTEZZA "
             "(tenuta fuori campione), non il picco di backtest.")
    p.append("")
    p.append("---")
    p.append("")
    p.append("## 1. Contesto operativo")
    p.append("")
    p.append(contesto.strip())
    p.append("")
    p.append("## 2. Strategia dell'EA (intestazione del sorgente)")
    p.append("")
    p.append("```")
    p.append(estrai_intestazione(src))
    p.append("```")
    p.append("")
    p.append(f"- File: `{path.relative_to(ROOT)}`")
    p.append(f"- Magic number: {estrai_magic(src)}")
    p.append("")
    p.append("## 3. Parametri ATTUALI (valori che girano adesso)")
    p.append("")
    if inputs:
        p.append("| Gruppo | Parametro | Tipo | Valore attuale | Nota nel codice |")
        p.append("|---|---|---|---|---|")
        for i in inputs:
            nota = i["commento"].replace("|", "/")
            p.append(f"| {i['gruppo']} | `{i['nome']}` | {i['tipo']} | `{i['valore']}` | {nota} |")
    else:
        p.append("DATO NON DISPONIBILE (nessun `input` riconosciuto nel sorgente)")
    p.append("")
    p.append("## 4. Griglia di ottimizzazione usata")
    p.append("")
    if voce:
        if voce.get("_ereditata_da"):
            p.append(f"> ATTENZIONE: questa variante non ha una sua voce in `ea_config.json`. "
                     f"Quella qui sotto e' la griglia dell'EA di partenza **{voce['_ereditata_da']}**: "
                     f"i valori attuali della sezione 3 possono stare FUORI da questi range.")
            p.append("")
        p.append(f"- simbolo: `{voce.get('symbol', '?')}` — timeframe: `{voce.get('period', '?')}`")
        if voce.get("_note"):
            p.append(f"- nota: {voce['_note']}")
        p.append(f"- periodo backtest: {defaults.get('from_date', '?')} → {defaults.get('to_date', '?')}, "
                 f"deposito {defaults.get('deposit', '?')} {defaults.get('currency', '')}, "
                 f"modello {defaults.get('model', '?')} (4 = tick reali), "
                 f"criterio {defaults.get('optimization_criterion', '?')}")
        p.append("")
        p.append("| Parametro | start | step | stop | n. valori |")
        p.append("|---|---|---|---|---|")
        for nome, r in (voce.get("params") or {}).items():
            try:
                n = int((r["stop"] - r["start"]) / r["step"]) + 1 if r.get("step") else 1
            except Exception:
                n = "?"
            p.append(f"| `{nome}` | {r.get('start')} | {r.get('step')} | {r.get('stop')} | {n} |")
        if voce.get("fixed"):
            p.append("")
            p.append("Parametri tenuti FISSI durante l'ottimizzazione: " +
                     ", ".join(f"`{k}={v}`" for k, v in voce["fixed"].items()))
    else:
        p.append("DATO NON DISPONIBILE (questo EA non e' in `backtest_pipeline/ea_config.json`)")
    p.append("")
    p.append("## 5. Risultati di ottimizzazione (dai file reali del tester)")
    p.append("")
    if risultati:
        for r in risultati:
            p.append(riassumi_risultati(r))
            p.append("")
    else:
        p.append("DATO NON DISPONIBILE (nessun file di risultati trovato per questo EA "
                 "in `backtest_pipeline/risultati_*`)")
    p.append("")
    p.append("## 6. Note di progetto su questo EA (backtest annotati / forward demo)")
    p.append("")
    p.append(estratti_documenti(nome_ea))
    p.append("")
    p.append("## 7. Limiti dichiarati (per non farti trarre in inganno)")
    p.append("")
    p.append("- Lo storico di alcuni indici CFD e' corto: i numeri di backtest hanno un "
             "intervallo di confidenza ampio.")
    p.append("- Il backtest NON misura lo slippage reale; negli EA delle aperture si paga "
             "uno slippage fisso simulato.")
    p.append("- La validazione vera e' il forward in demo, non il backtest.")
    p.append("- Se ti serve un dato che qui non c'e', NON stimarlo: chiedilo esplicitamente "
             "nel campo `domande_a_claude`.")
    p.append("")
    if con_codice:
        p.append("## 7-bis. Sorgente completo dell'EA")
        p.append("")
        p.append("```cpp")
        p.append(src)
        p.append("```")
        p.append("")
    p.append("## 8. Protocollo di risposta (OBBLIGATORIO)")
    p.append("")
    p.append(protocollo.strip() or "DATO NON DISPONIBILE (manca confronto_ia/PROTOCOLLO.md)")
    p.append("")
    return "\n".join(p)


def main() -> int:
    ap = argparse.ArgumentParser(description="Genera il dossier di un EA per il confronto con un'altra IA.")
    ap.add_argument("ea", help="nome dell'EA (es. ABTG_SupRev_DAX_H4_Ottimizzato)")
    ap.add_argument("--domanda", default="", help="domanda specifica da mettere in cima")
    ap.add_argument("--codice", action="store_true", help="allega il sorgente completo del .mq5")
    ap.add_argument("--out", default=None, help="file di destinazione (default: stampa a video)")
    a = ap.parse_args()

    testo = componi(a.ea, a.domanda, a.codice)
    if a.out:
        Path(a.out).parent.mkdir(parents=True, exist_ok=True)
        Path(a.out).write_text(testo, encoding="utf-8")
        print(f"Dossier scritto in {a.out} ({len(testo)//1024} KB)")
    else:
        sys.stdout.write(testo)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
