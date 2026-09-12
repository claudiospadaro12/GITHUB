#!/usr/bin/env python3
"""IL TAVOLO — il posto virtuale dove Claude Code e ChatGPT si parlano.

Ogni confronto e' una SESSIONE: una cartella dentro `confronto_ia/sessioni/`
con dentro i turni, in ordine, come file markdown numerati:

    2026-09-12_SupRev_DAX_H4/
        sessione.json      metadati (EA, stato, modello usato)
        00_claude.md       il dossier preparato da Claude Code
        01_chatgpt.md      il parere di ChatGPT
        02_claude.md       la replica di Claude Code (cosa accetta, cosa no)
        03_chatgpt.md      ...

Due modi per far arrivare il messaggio a ChatGPT:

  A) AUTOMATICO  — serve una chiave API OpenAI in OPENAI_API_KEY:
        python confronto_ia/tavolo.py chiedi
     il programma manda tutto il thread e salva da solo la risposta.

  B) MANUALE     — nessun costo API, basta il tuo ChatGPT normale:
        python confronto_ia/tavolo.py apri --ea ABTG_xxx      -> crea 00_claude.md
        (apri il file, copialo/caricalo in ChatGPT, copia la risposta)
        python confronto_ia/tavolo.py incolla --file risposta.txt

Comandi:
    apri     crea una sessione nuova con il dossier di un EA (o un tema libero)
    chiedi   manda il thread a ChatGPT via API e salva la risposta
    incolla  registra una risposta di ChatGPT copiata a mano
    replica  registra il turno di Claude Code
    stato    mostra le sessioni e i turni
    estrai   stampa il blocco JSON dell'ultima risposta di ChatGPT
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.request
from datetime import date, datetime
from pathlib import Path

QUI = Path(__file__).resolve().parent
ROOT = QUI.parent
SESSIONI = QUI / "sessioni"
PROTOCOLLO = QUI / "PROTOCOLLO.md"

API_URL = os.environ.get("OPENAI_BASE_URL", "https://api.openai.com/v1").rstrip("/") + "/chat/completions"
MODELLO_DEFAULT = os.environ.get("OPENAI_MODEL", "gpt-5")


# ------------------------------------------------------------------ #
#  Utilita'                                                          #
# ------------------------------------------------------------------ #
def carica_env() -> None:
    """Legge il file .env del progetto senza sovrascrivere l'ambiente."""
    env = ROOT / ".env"
    if not env.is_file():
        return
    for riga in env.read_text(encoding="utf-8", errors="replace").splitlines():
        riga = riga.strip()
        if not riga or riga.startswith("#") or "=" not in riga:
            continue
        k, v = riga.split("=", 1)
        os.environ.setdefault(k.strip(), v.strip().strip('"').strip("'"))


def slug(testo: str) -> str:
    s = re.sub(r"[^\w\-]+", "_", testo.strip())
    return re.sub(r"_+", "_", s).strip("_")[:60] or "confronto"


def sessione_ultima() -> Path:
    cartelle = [p for p in SESSIONI.iterdir() if p.is_dir()] if SESSIONI.is_dir() else []
    if not cartelle:
        raise SystemExit("Nessuna sessione aperta. Lanciane una con:\n"
                         "  python confronto_ia/tavolo.py apri --ea NOME_EA")
    return max(cartelle, key=lambda p: p.stat().st_mtime)


def risolvi_sessione(nome: str | None) -> Path:
    if not nome:
        return sessione_ultima()
    p = Path(nome)
    if p.is_dir():
        return p
    p = SESSIONI / nome
    if p.is_dir():
        return p
    candidati = [c for c in SESSIONI.iterdir() if c.is_dir() and nome.lower() in c.name.lower()]
    if len(candidati) == 1:
        return candidati[0]
    raise SystemExit(f"Sessione '{nome}' non trovata (o ambigua). Usa: tavolo.py stato")


def turni(sess: Path) -> list[Path]:
    return sorted(p for p in sess.glob("[0-9][0-9]_*.md"))


def prossimo_turno(sess: Path, autore: str) -> Path:
    n = len(turni(sess))
    return sess / f"{n:02d}_{autore}.md"


def scrivi_turno(sess: Path, autore: str, testo: str) -> Path:
    path = prossimo_turno(sess, autore)
    intest = f"<!-- {autore} — {datetime.now().isoformat(timespec='seconds')} -->\n\n"
    path.write_text(intest + testo.rstrip() + "\n", encoding="utf-8")
    meta = leggi_meta(sess)
    meta["ultimo_turno"] = path.name
    meta["aggiornata"] = datetime.now().isoformat(timespec="seconds")
    scrivi_meta(sess, meta)
    return path


def leggi_meta(sess: Path) -> dict:
    f = sess / "sessione.json"
    return json.loads(f.read_text(encoding="utf-8")) if f.is_file() else {}


def scrivi_meta(sess: Path, meta: dict) -> None:
    (sess / "sessione.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")


def corpo(path: Path) -> str:
    """Testo del turno senza la riga di intestazione HTML."""
    t = path.read_text(encoding="utf-8", errors="replace")
    return re.sub(r"^<!--.*?-->\s*", "", t, flags=re.S)


# ------------------------------------------------------------------ #
#  apri                                                              #
# ------------------------------------------------------------------ #
def cmd_apri(a) -> int:
    if not a.ea and not a.tema:
        raise SystemExit("Serve --ea NOME_EA oppure --tema \"argomento libero\".")
    SESSIONI.mkdir(parents=True, exist_ok=True)

    if a.ea:
        sys.path.insert(0, str(QUI))
        import dossier  # noqa: E402  (import locale: sta nella stessa cartella)
        path_ea = dossier.trova_ea(a.ea)
        nome = a.nome or f"{date.today().isoformat()}_{slug(path_ea.stem)}"
        testo = dossier.componi(path_ea.stem, a.domanda, a.codice)
        meta = {"tipo": "ea", "ea": path_ea.stem, "creata": datetime.now().isoformat(timespec="seconds")}
    else:
        nome = a.nome or f"{date.today().isoformat()}_{slug(a.tema)}"
        protocollo = PROTOCOLLO.read_text(encoding="utf-8") if PROTOCOLLO.is_file() else ""
        contesto = (QUI / "contesto" / "contesto_base.md")
        testo = (f"# CONFRONTO — {a.tema}\n\n## 0. Cosa ti chiedo\n\n"
                 f"{a.domanda or a.tema}\n\n## 1. Contesto operativo\n\n"
                 f"{contesto.read_text(encoding='utf-8') if contesto.is_file() else ''}\n\n"
                 f"## 2. Protocollo di risposta (OBBLIGATORIO)\n\n{protocollo}\n")
        meta = {"tipo": "tema", "tema": a.tema, "creata": datetime.now().isoformat(timespec="seconds")}

    sess = SESSIONI / slug(nome)
    if sess.exists() and any(sess.iterdir()):
        raise SystemExit(f"La sessione '{sess.name}' esiste gia'. Usa --nome per un nome diverso.")
    sess.mkdir(parents=True, exist_ok=True)
    scrivi_meta(sess, meta)
    path = scrivi_turno(sess, "claude", testo)

    print(f"Sessione aperta: {sess.relative_to(ROOT)}")
    print(f"Dossier:         {path.relative_to(ROOT)}  ({len(testo)//1024} KB, ~{len(testo)//4} token)")
    print()
    print("Adesso, a scelta:")
    print("  AUTOMATICO (serve OPENAI_API_KEY):  python confronto_ia/tavolo.py chiedi")
    print("  MANUALE:  apri il dossier, incollalo in ChatGPT, poi:")
    print("            python confronto_ia/tavolo.py incolla --file risposta.txt")
    return 0


# ------------------------------------------------------------------ #
#  chiedi (ponte API verso ChatGPT)                                  #
# ------------------------------------------------------------------ #
def costruisci_messaggi(sess: Path) -> list[dict]:
    sistema = PROTOCOLLO.read_text(encoding="utf-8") if PROTOCOLLO.is_file() else \
        "Sei il revisore di un altro modello. Rispondi in italiano."
    msg = [{"role": "system", "content": sistema}]
    for t in turni(sess):
        autore = t.stem.split("_", 1)[1]
        ruolo = "assistant" if autore == "chatgpt" else "user"
        msg.append({"role": ruolo, "content": corpo(t)})
    return msg


def chiama_openai(messaggi: list[dict], modello: str, timeout: int = 600) -> str:
    chiave = os.environ.get("OPENAI_API_KEY")
    if not chiave:
        raise SystemExit(
            "OPENAI_API_KEY non impostata.\n"
            "  - o la metti nel file .env del progetto (OPENAI_API_KEY=sk-...)\n"
            "  - oppure usi la modalita' MANUALE:\n"
            "      copia il dossier in ChatGPT e poi\n"
            "      python confronto_ia/tavolo.py incolla --file risposta.txt"
        )
    payload = json.dumps({"model": modello, "messages": messaggi}).encode("utf-8")
    req = urllib.request.Request(
        API_URL, data=payload,
        headers={"Authorization": f"Bearer {chiave}", "Content-Type": "application/json"},
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            dati = json.loads(r.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        dettaglio = e.read().decode("utf-8", "replace")[:600]
        raise SystemExit(f"Errore API OpenAI ({e.code}): {dettaglio}\n"
                         f"Se il modello '{modello}' non esiste sul tuo account, "
                         f"cambialo con OPENAI_MODEL=... o --modello.")
    except urllib.error.URLError as e:
        raise SystemExit(f"Rete non raggiungibile: {e.reason}")
    try:
        return dati["choices"][0]["message"]["content"]
    except (KeyError, IndexError):
        raise SystemExit(f"Risposta API inattesa: {json.dumps(dati)[:400]}")


def cmd_chiedi(a) -> int:
    sess = risolvi_sessione(a.sessione)
    elenco = turni(sess)
    if not elenco:
        raise SystemExit("Sessione vuota: manca il dossier.")
    if elenco[-1].stem.endswith("chatgpt"):
        print("Attenzione: l'ultimo turno e' gia' di ChatGPT. "
              "Scrivi prima la replica di Claude Code (comando `replica`).")
        if not a.forza:
            return 1
    modello = a.modello or MODELLO_DEFAULT
    print(f"Invio {len(elenco)} turni a {modello}...")
    risposta = chiama_openai(costruisci_messaggi(sess), modello)
    path = scrivi_turno(sess, "chatgpt", risposta)
    meta = leggi_meta(sess)
    meta["modello_chatgpt"] = modello
    scrivi_meta(sess, meta)
    print(f"Risposta salvata in {path.relative_to(ROOT)}")
    j = estrai_json(risposta)
    if j:
        print(f"Verdetto: {j.get('verdetto')} — robustezza {j.get('punteggio_robustezza')}/10 "
              f"— {len(j.get('proposte') or [])} proposte")
    else:
        print("Nota: la risposta non contiene il blocco JSON previsto dal protocollo.")
    return 0


# ------------------------------------------------------------------ #
#  incolla / replica / stato / estrai                                #
# ------------------------------------------------------------------ #
def _testo_in_ingresso(a) -> str:
    if a.file:
        return Path(a.file).read_text(encoding="utf-8", errors="replace")
    if not sys.stdin.isatty():
        return sys.stdin.read()
    print("Incolla il testo e chiudi con Ctrl+Z (Windows) o Ctrl+D (Linux/Mac):")
    return sys.stdin.read()


def cmd_incolla(a) -> int:
    sess = risolvi_sessione(a.sessione)
    testo = _testo_in_ingresso(a).strip()
    if not testo:
        raise SystemExit("Nessun testo ricevuto.")
    path = scrivi_turno(sess, "chatgpt", testo)
    print(f"Risposta di ChatGPT registrata in {path.relative_to(ROOT)}")
    j = estrai_json(testo)
    if j:
        print(f"Verdetto: {j.get('verdetto')} — robustezza {j.get('punteggio_robustezza')}/10")
    else:
        print("Nota: manca il blocco JSON del protocollo (la analizzo lo stesso, ma a mano).")
    return 0


def cmd_replica(a) -> int:
    sess = risolvi_sessione(a.sessione)
    testo = _testo_in_ingresso(a).strip()
    if not testo:
        raise SystemExit("Nessun testo ricevuto.")
    path = scrivi_turno(sess, "claude", testo)
    print(f"Turno di Claude Code registrato in {path.relative_to(ROOT)}")
    return 0


def estrai_json(testo: str) -> dict | None:
    """Prende l'ULTIMO blocco ```json del messaggio (il protocollo lo vuole in fondo)."""
    blocchi = re.findall(r"```json\s*(.*?)```", testo, re.S)
    if not blocchi:
        blocchi = re.findall(r"(\{[\s\S]*\})", testo)
    for b in reversed(blocchi):
        try:
            return json.loads(b.strip())
        except json.JSONDecodeError:
            continue
    return None


def cmd_estrai(a) -> int:
    sess = risolvi_sessione(a.sessione)
    risposte = [t for t in turni(sess) if t.stem.endswith("chatgpt")]
    if not risposte:
        raise SystemExit("Nessuna risposta di ChatGPT in questa sessione.")
    j = estrai_json(corpo(risposte[-1]))
    if not j:
        raise SystemExit(f"Nessun JSON valido in {risposte[-1].name}")
    print(json.dumps(j, indent=2, ensure_ascii=False))
    return 0


def cmd_stato(a) -> int:
    if not SESSIONI.is_dir() or not any(p.is_dir() for p in SESSIONI.iterdir()):
        print("Nessuna sessione. Aprine una: python confronto_ia/tavolo.py apri --ea NOME_EA")
        return 0
    for sess in sorted((p for p in SESSIONI.iterdir() if p.is_dir()), key=lambda p: p.name):
        meta = leggi_meta(sess)
        elenco = turni(sess)
        etichetta = meta.get("ea") or meta.get("tema") or "?"
        print(f"\n{sess.name}  [{etichetta}]  — {len(elenco)} turni")
        for t in elenco:
            j = estrai_json(corpo(t)) if t.stem.endswith("chatgpt") else None
            extra = f"  → verdetto: {j.get('verdetto')} ({j.get('punteggio_robustezza')}/10)" if j else ""
            print(f"   {t.name:<22} {t.stat().st_size//1024:>4} KB{extra}")
    print()
    return 0


def main() -> int:
    carica_env()
    ap = argparse.ArgumentParser(description="Il tavolo di confronto tra Claude Code e ChatGPT.")
    sub = ap.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("apri", help="crea una sessione nuova")
    p.add_argument("--ea", help="nome dell'EA da mettere sul tavolo")
    p.add_argument("--tema", help="argomento libero (senza EA)")
    p.add_argument("--domanda", default="", help="domanda specifica")
    p.add_argument("--codice", action="store_true", help="allega il sorgente completo")
    p.add_argument("--nome", help="nome della sessione")
    p.set_defaults(f=cmd_apri)

    p = sub.add_parser("chiedi", help="manda il thread a ChatGPT via API")
    p.add_argument("sessione", nargs="?")
    p.add_argument("--modello", help=f"modello OpenAI (default: {MODELLO_DEFAULT})")
    p.add_argument("--forza", action="store_true", help="invia anche se l'ultimo turno e' di ChatGPT")
    p.set_defaults(f=cmd_chiedi)

    p = sub.add_parser("incolla", help="registra una risposta di ChatGPT copiata a mano")
    p.add_argument("sessione", nargs="?")
    p.add_argument("--file", help="file con il testo della risposta")
    p.set_defaults(f=cmd_incolla)

    p = sub.add_parser("replica", help="registra il turno di Claude Code")
    p.add_argument("sessione", nargs="?")
    p.add_argument("--file", help="file con il testo della replica")
    p.set_defaults(f=cmd_replica)

    p = sub.add_parser("estrai", help="stampa il JSON dell'ultima risposta di ChatGPT")
    p.add_argument("sessione", nargs="?")
    p.set_defaults(f=cmd_estrai)

    p = sub.add_parser("stato", help="elenca sessioni e turni")
    p.set_defaults(f=cmd_stato)

    a = ap.parse_args()
    return a.f(a)


if __name__ == "__main__":
    raise SystemExit(main())
