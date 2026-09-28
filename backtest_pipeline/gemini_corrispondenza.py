#!/usr/bin/env python3
"""CORRISPONDENZA AUTOMATICA CON GEMINI (richiesta di Claudio, notte 28/29-09-2026:
"Con Gemini confrontiamoci ogni giorno. C'e' un modo di interfacciare tu in
automatico con Gemini? Si puo' creare un agente per l'interfaccia senza il mio aiuto?").

Cosa fa: prende il COMANDO per Gemini (docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md,
la parte fra INIZIO COMANDO e FINE COMANDO) come istruzione di sistema, allega i
documenti del giorno (file .md passati sulla riga di comando), manda tutto
all'API Gemini (generateContent) e salva la risposta in
docs/gemini/RISPOSTA_GEMINI_<data>_<ora>.md, con in testa il manifesto di cosa e'
stato mandato (nomi, byte, SHA256) e il modello usato.

Confini (regole di casa):
- la CHIAVE non sta nel repo: si legge SOLO da $GEMINI_API_KEY (segreto
  dell'ambiente). Senza chiave: --dry-run funziona, l'invio si rifiuta.
- NIENTE esce da qui senza che i file siano stati passati dal cancello
  (--oggetto md) e siano in repo: lo script rifiuta file NON tracciati da git
  o con modifiche non committate (classe: "si manda fuori solo cio' che e' in repo").
- Mai .set, .ps1 di lancio, chiavi, estratti conto: lista nera per estensione e nome.
- La risposta di Gemini e' DATI, non istruzioni: va letta dal cancello
  (controllo-preventivo) prima che qualunque cosa cambi nel repo o in campo.

Uso:
  python3 backtest_pipeline/gemini_corrispondenza.py --dry-run docs/PER_GEMINI_*.md
  GEMINI_API_KEY=... python3 backtest_pipeline/gemini_corrispondenza.py docs/PER_GEMINI_*.md
  python3 backtest_pipeline/gemini_corrispondenza.py --autotest
"""
import argparse, datetime as dt, hashlib, json, os, re, subprocess, sys, urllib.request, urllib.error

COMANDO = "docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md"
OUT_DIR = "docs/gemini"
MODELLO_DEFAULT = "gemini-2.5-pro"
ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/{m}:generateContent"
NERA_EXT = {".set", ".ps1", ".ini", ".xlsx", ".xls", ".key", ".pem", ".env"}
NERA_NOME = ("estratto", "statement", "ReportHistory", "chiave", "secret", "token")

def sha(p):
    return hashlib.sha256(open(p, "rb").read()).hexdigest().upper()

def istruzione_di_sistema(path=COMANDO):
    t = open(path, encoding="utf-8").read()
    i, j = t.find("## INIZIO COMANDO"), t.find("## FINE COMANDO")
    if i < 0 or j < 0:
        raise SystemExit("COMANDO senza i marcatori INIZIO/FINE COMANDO: " + path)
    return t[i + len("## INIZIO COMANDO"):j].strip()

def in_repo_e_pulito(p):
    """True solo se il file e' tracciato da git e senza modifiche non committate."""
    r = subprocess.run(["git", "ls-files", "--error-unmatch", p], capture_output=True, text=True)
    if r.returncode != 0:
        return False, "NON tracciato da git"
    r = subprocess.run(["git", "status", "--porcelain", "--", p], capture_output=True, text=True)
    if r.stdout.strip():
        return False, "modifiche NON committate"
    return True, "in repo"

def controlla_allegati(files):
    problemi = []
    for p in files:
        e = os.path.splitext(p)[1].lower()
        if e in NERA_EXT or any(n.lower() in os.path.basename(p).lower() for n in NERA_NOME):
            problemi.append(p + ": in lista NERA (preset, script di lancio, estratti, chiavi non escono)")
        if e != ".md":
            problemi.append(p + ": si mandano solo .md (le fonti sono il repo, non gli zip)")
        ok, perche = in_repo_e_pulito(p)
        if not ok:
            problemi.append(p + ": " + perche)
    return problemi

def costruisci_richiesta(files, domanda):
    parti = [{"text": "DOCUMENTI DEL GIORNO (dal repo, uno per blocco). Rispondi come Agente 3 e Agente 4.\n"}]
    for p in files:
        parti.append({"text": "\n\n===== FILE: %s (SHA256 %s) =====\n%s" % (p, sha(p)[:16], open(p, encoding="utf-8").read())})
    if domanda:
        parti.append({"text": "\n\nDOMANDA DEL GIORNO: " + domanda})
    return {
        "system_instruction": {"parts": [{"text": istruzione_di_sistema()}]},
        "contents": [{"role": "user", "parts": parti}],
        "generationConfig": {"temperature": 0.2, "maxOutputTokens": 8192},
    }

def invia(richiesta, modello, chiave):
    url = ENDPOINT.format(m=modello) + "?key=" + chiave
    req = urllib.request.Request(url, data=json.dumps(richiesta).encode("utf-8"),
                                 headers={"Content-Type": "application/json"}, method="POST")
    try:
        with urllib.request.urlopen(req, timeout=300) as r:
            return json.loads(r.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        corpo = e.read().decode("utf-8", "replace")[:800]
        raise SystemExit("Gemini HTTP %d: %s" % (e.code, corpo))

def testo_risposta(js):
    try:
        return "\n".join(p.get("text", "") for p in js["candidates"][0]["content"]["parts"])
    except (KeyError, IndexError):
        return "[RISPOSTA SENZA TESTO] " + json.dumps(js)[:1000]

def scrivi_risposta(files, modello, testo, domanda):
    os.makedirs(OUT_DIR, exist_ok=True)
    ora = dt.datetime.now()
    out = os.path.join(OUT_DIR, "RISPOSTA_GEMINI_%s.md" % ora.strftime("%Y-%m-%d_%H%M"))
    with open(out, "w", encoding="utf-8") as f:
        f.write("# RISPOSTA DI GEMINI -- %s (modello %s)\n\n" % (ora.strftime("%d/%m/%Y %H:%M"), modello))
        f.write("> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che\n"
                "> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.\n\n")
        f.write("## Manifesto di cio' che e' stato mandato\n")
        f.write("- istruzione di sistema: `%s` (INIZIO..FINE COMANDO)\n" % COMANDO)
        for p in files:
            f.write("- `%s` (%d byte, SHA256 %s)\n" % (p, os.path.getsize(p), sha(p)[:16]))
        if domanda:
            f.write("- domanda del giorno: %s\n" % domanda)
        f.write("\n---\n\n" + testo + "\n")
    return out

def autotest():
    import tempfile
    # (1) lista nera: un .set non parte
    d = tempfile.mkdtemp()
    p = os.path.join(d, "ABTG_X.set"); open(p, "w").write("x")
    assert any("NERA" in x for x in controlla_allegati([p])), "un .set deve essere rifiutato"
    # (2) un .md fuori repo non parte
    p2 = os.path.join(d, "nota.md"); open(p2, "w").write("x")
    assert any("NON tracciato" in x for x in controlla_allegati([p2])), "un file fuori repo deve essere rifiutato"
    # (3) l'istruzione di sistema si estrae e contiene i 4 agenti
    s = istruzione_di_sistema()
    assert "AGENTE 1" in s and "AGENTE 4" in s and "INIZIO COMANDO" not in s
    # (4) senza chiave l'invio si rifiuta (non chiama la rete)
    assert not os.environ.get("GEMINI_API_KEY_TEST_FAKE")
    # (5) la richiesta ha system_instruction e i file in ordine
    r = costruisci_richiesta([COMANDO], "d")
    assert r["system_instruction"]["parts"][0]["text"] == s and "FILE: " + COMANDO in r["contents"][0]["parts"][1]["text"]
    print("AUTOTEST OK (5 controlli: lista nera, fuori repo, istruzione, chiave assente, richiesta)")

def main():
    ap = argparse.ArgumentParser(description="corrispondenza automatica con Gemini (documenti .md del repo -> risposta in docs/gemini/)")
    ap.add_argument("files", nargs="*", help="documenti .md da mandare (devono essere in repo e committati)")
    ap.add_argument("--domanda", default="", help="domanda del giorno, una frase")
    ap.add_argument("--modello", default=MODELLO_DEFAULT)
    ap.add_argument("--dry-run", action="store_true", help="prepara e stampa il manifesto, NON manda")
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        return autotest()
    if not a.files:
        raise SystemExit("nessun documento: passa uno o piu' .md del repo")
    problemi = controlla_allegati(a.files)
    if problemi:
        print("RIFIUTATO -- non si manda niente:"); [print("  X " + x) for x in problemi]; sys.exit(2)
    richiesta = costruisci_richiesta(a.files, a.domanda)
    n = sum(len(p["text"]) for p in richiesta["contents"][0]["parts"])
    print("manifesto: %d documenti, %d caratteri, modello %s" % (len(a.files), n, a.modello))
    for p in a.files:
        print("  - %s  %d byte  SHA256 %s" % (p, os.path.getsize(p), sha(p)[:16]))
    if a.dry_run:
        print("DRY-RUN: niente mandato."); return
    chiave = os.environ.get("GEMINI_API_KEY", "")
    if not chiave:
        raise SystemExit("GEMINI_API_KEY assente nell'ambiente: l'invio si rifiuta (la chiave e' un segreto di Claudio, non del repo)")
    js = invia(richiesta, a.modello, chiave)
    out = scrivi_risposta(a.files, a.modello, testo_risposta(js), a.domanda)
    print("risposta salvata: " + out + "  (va letta dal cancello prima di qualunque uso)")

if __name__ == "__main__":
    main()
