#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
controlla_riga.py -- IL CANCELLO DETERMINISTICO PRIMA DI OGNI PASSAGGIO.

Richiesta di Claudio, 09/09/2026: "VOGLIO CHE CREI UN AGENTE CHE VERIFICHI LE
STRINGHE E CONTROLLI SE CI SONO ERRORI, COSI PRIMA DI OGNI PASSAGGIO."

L'agente `verificatore-stringhe` esiste dal 17/08 e funziona (oggi ha trovato
3 difetti bloccanti sulla riga dei gemelli IBRetest). Ma un agente RAGIONA, e
chi ragiona puo' DIMENTICARE. Questo script no: non ragiona, non si stanca, e
fa sempre gli stessi controlli nello stesso ordine.

DIVISIONE DEL LAVORO, dichiarata:
  - QUESTO SCRIPT prende i difetti MECCANICI (quelli con una firma esatta:
    un byte, una parola chiave, un percorso vietato). Sono quelli che
    costano giri a vuoto e che nessuno dovrebbe mai piu' pagare.
  - L'AGENTE prende quelli di GIUDIZIO (la riga fa quello che promette? il
    file prova misura la cosa giusta? l'ora e' quella del server?).
  - Passare questo script NON sostituisce l'agente. Fallirlo lo blocca.

USO:
  python3 backtest_pipeline/controlla_riga.py --riga FILE_CON_LA_RIGA.txt
  python3 backtest_pipeline/controlla_riga.py --ps1 backtest_pipeline/righe/X.ps1
  python3 backtest_pipeline/controlla_riga.py --riga R.txt --ps1 A.ps1 --ps1 B.ps1

USCITA: 0 = nessun difetto BLOCCANTE. 1 = almeno uno. I RILIEVI non bloccano.
"""
import argparse, os, re, subprocess, sys

BLOCCANTI = []
RILIEVI   = []
PASSATI   = []

def blocca(classe, msg, dove=""):
    BLOCCANTI.append((classe, msg, dove))
def rileva(classe, msg, dove=""):
    RILIEVI.append((classe, msg, dove))
def passa(msg):
    PASSATI.append(msg)

# --- percorsi e conti che non si toccano MAI (regola dei terminali multipli) --
VIETATI_PERCORSO = ["-V3", "BCM_Reale", "BCM Markets MT5 Terminal"]
CONTI_VIETATI    = ["50504263", "10105439"]
CONTO_PICCOLO    = "50503392"
TERMINALE_BUONO  = "C:\\MT5_Backtest"

# --- sintassi che pwsh 7 accetta e Windows PowerShell 5.1 NO -----------------
#     (sul VPS gira la 5.1: un costrutto pwsh-7 e' un errore garantito)
PWSH7_ONLY = [
    (r"(?<![&|])&&(?![&|])",      "operatore '&&' (pwsh 7)"),
    (r"(?<![|])\|\|(?![|])",      "operatore '||' (pwsh 7)"),
    (r"-AsHashtable",             "-AsHashtable (pwsh 7)"),
    (r"(?<!\$)\(\s*if\s*\(",      "'(if ...)' usato come espressione fra parentesi (pwsh 7). NB: '$(if ...)' e' una SUBEXPRESSION ed e' valida: non e' questo il caso"),
    (r"\?\?",                     "operatore null-coalescing '??' (pwsh 7)"),
]

def leggi(path):
    with open(path, "rb") as f:
        return f.read()

def controlla_ascii(path, dati):
    fuori = [(i + 1, b) for i, b in enumerate(dati) if b > 127]
    if fuori:
        righe = set()
        n = 1
        for b in dati:
            if b == 10:
                n += 1
            elif b > 127:
                righe.add(n)
        blocca("ASCII", "byte non-ASCII in un .ps1: Windows PowerShell 5.1 lo legge come ANSI e il parser esplode. Righe: " + ", ".join(str(x) for x in sorted(righe)[:10]), path)
    else:
        passa("ASCII puro: " + os.path.basename(path))

def righe_utili(testo):
    """Righe con (numero, codice nudo). Salta commenti e HERE-STRING.

    Perche' la here-string va saltata: i file prova di casa scrivono i
    parametri come `InpTal=1.0||1.0||0||1.0||N`, e quei `||` NON sono
    l'operatore di pwsh 7 -- sono il separatore del nostro formato. Senza
    questo salto il cancello grida al lupo su ogni file prova, e un
    cancello che grida al lupo si impara a ignorare.
    """
    fuori = []
    dentro_here = False
    for i, riga in enumerate(testo.splitlines(), 1):
        if not dentro_here and re.search(r"@[\"\']\s*$", riga):
            dentro_here = True
            continue
        if dentro_here:
            if re.match(r"^[\"\']@", riga.strip()):
                dentro_here = False
            continue
        fuori.append((i, riga.split("#", 1)[0]))
    return fuori

def controlla_pwsh7(path, testo):
    trovati = []
    for i, nudo in righe_utili(testo):
        for pat, nome in PWSH7_ONLY:
            if re.search(pat, nudo):
                trovati.append((i, nome, nudo.strip()[:70]))
    for i, nome, txt in trovati:
        blocca("PWSH7", "r." + str(i) + ": " + nome + " -> sul VPS gira Windows PowerShell 5.1", path)
    if not trovati:
        passa("nessun costrutto pwsh-7-only: " + os.path.basename(path))

def controlla_formati_net(path, testo):
    brutti = re.findall(r"\{\d+[,:][<>^]", testo)
    if brutti:
        blocca("FORMATO", "formato .NET non valido (allineamento tipo Python): " + ", ".join(sorted(set(brutti))[:5]), path)
    else:
        passa("formati .NET: " + os.path.basename(path))

def controlla_cultura(path, testo):
    nudi = []
    for i, riga in enumerate(testo.splitlines(), 1):
        nudo = riga.split("#", 1)[0]
        if re.search(r"\[double\]\s*\$", nudo) and "InvariantCulture" not in nudo:
            nudi.append(i)
    if nudi:
        rileva("CULTURA", "cast [double] nudo alle righe " + ", ".join(str(x) for x in nudi[:8]) + ": su VPS it-IT '2.0' diventa 20. Serve InvariantCulture", path)
    else:
        passa("nessun cast [double] nudo: " + os.path.basename(path))

GUARDIA = r"(Muori|throw|exit\s+1|VIETATO|notlike|-ne\b|Write-Host|Red)"

def in_una_guardia(righe, idx):
    """La guardia sta spesso su PIU' righe:
         if($x -like "*-V3*"){
           Muori "..."
         }
       Guardare solo la riga del -V3 fa gridare al lupo su ogni guardia
       scritta bene -- cioe' esattamente sui file fatti giusti.
       Quindi si guarda una FINESTRA di 3 righe avanti e 1 indietro.
    """
    for j in range(max(0, idx - 1), min(len(righe), idx + 4)):
        if re.search(GUARDIA, righe[j][1], re.I):
            return True
    return False

def controlla_terminali(path, testo, dove):
    righe = righe_utili(testo)
    for k, (i, nudo) in enumerate(righe):
        for v in VIETATI_PERCORSO:
            if v in nudo and not in_una_guardia(righe, k):
                blocca("TERMINALE", "r." + str(i) + ": nomina '" + v + "' senza una guardia che lo rifiuta nelle righe vicine. Il 100k 50504263, il REALE 10105439 e il piccolo " + CONTO_PICCOLO + " non si toccano", dove)
        for c in CONTI_VIETATI:
            if c in nudo and not in_una_guardia(righe, k):
                blocca("CONTO", "r." + str(i) + ": nomina il conto " + c + " fuori da una guardia", dove)

def controlla_riga_lancio(riga):
    # --- 1. il PIN deve essere un COMMIT (classe 164): 40 esadecimali
    pins = re.findall(r"githubusercontent\.com/[^/]+/[^/]+/([A-Za-z0-9_.-]+)/", riga)
    pins += re.findall(r"\$PIN\s*=\s*'([^']+)'", riga)
    pins += re.findall(r"\$PIN\s*=\s*\"([^\"]+)\"", riga)
    visti = set(p for p in pins if not p.startswith("$"))
    if not visti:
        blocca("PIN", "nessun pin trovato nella riga: la riga deve puntare a un COMMIT, non a un branch")
    for p in visti:
        if re.fullmatch(r"[0-9a-f]{40}", p):
            try:
                t = subprocess.run(["git", "cat-file", "-t", p], capture_output=True, text=True, timeout=20)
                if t.stdout.strip() == "commit":
                    passa("pin " + p[:8] + " e' un commit vero (git cat-file)")
                else:
                    blocca("PIN", "il pin " + p[:8] + " NON e' un commit di questo repo (git dice: '" + t.stdout.strip() + "'). Classe 164: sha1sum di un file NON e' un oggetto git -> 404")
            except Exception as e:
                rileva("PIN", "non ho potuto verificare il pin " + p[:8] + " con git: " + str(e))
        elif p in ("lavoro", "main", "master"):
            blocca("PIN", "il pin e' il branch '" + p + "', non un commit: quello che gira domani puo' essere diverso da quello che hai approvato oggi")
        else:
            blocca("PIN", "pin '" + p + "' non e' ne' un commit a 40 esadecimali ne' un branch noto")

    # --- 2. il MARCATORE va controllato prima di eseguire
    if "Select-String" in riga and "SimpleMatch" in riga and "MARCATORE" in riga:
        passa("la riga controlla il MARCATORE dello script scaricato")
    else:
        blocca("MARCATORE", "la riga non verifica il MARCATORE dello script scaricato: una copia vecchia in cache gira senza dirlo")

    # --- 3. classe 165: $ErrorActionPreference='Stop' ancora attivo sulle chiamate native
    if "& {" in riga or "&{" in riga:
        pos_stop = riga.find("$ErrorActionPreference='Stop'")
        if pos_stop < 0:
            pos_stop = riga.find('$ErrorActionPreference="Stop"')
        pos_cont = max(riga.find("$ErrorActionPreference='Continue'"), riga.find('$ErrorActionPreference="Continue"'))
        pos_nat  = riga.find("& powershell")
        if pos_stop >= 0 and pos_nat > pos_stop and not (0 <= pos_cont < pos_nat):
            blocca("165", "dentro '& { }' lo Stop e' ancora attivo quando parte '& powershell': su PS 5.1 lo stderr di un comando nativo diventa errore TERMINANTE e ammazza il resto della riga (la seconda corsa non parte, e sul Desktop resta un solo zip con l'aria di una raccolta riuscita). Mettere $ErrorActionPreference='Continue' dopo il cancello del marcatore")
        elif pos_nat > 0:
            passa("classe 165 disinnescata (Continue prima delle chiamate native)")

    # --- 4. $LASTEXITCODE letto invece che catturato, con piu' di una corsa
    n_corse = riga.count("& powershell")
    if n_corse > 1:
        catture = len(re.findall(r"\$\w+\s*=\s*\$LASTEXITCODE", riga))
        if catture < n_corse:
            rileva("RC", "ci sono " + str(n_corse) + " corse ma solo " + str(catture) + " catture di $LASTEXITCODE: la riga puo' stampare l'esito della corsa sbagliata, e dopo ore di tester le prime righe sono fuori dal buffer della console")
        else:
            passa("ogni corsa cattura il suo $LASTEXITCODE")

    # --- 5. il terminale bersaglio
    if TERMINALE_BUONO.lower() in riga.lower():
        passa("bersaglio dichiarato: " + TERMINALE_BUONO)
    elif "-Terminal" in riga or "-TerminaleBacktest" in riga:
        rileva("TERMINALE", "la riga passa un terminale che non e' " + TERMINALE_BUONO + ": verificare a mano che non sia un conto in forward")
    controlla_terminali("<riga>", riga, "<riga di lancio>")

    # --- 6. la raccolta
    if "Compress-Archive" in riga or "zip" in riga.lower() or "-File" in riga:
        passa("la riga prevede una raccolta o punta a uno script che ce l'ha")
    else:
        rileva("RACCOLTA", "non vedo la raccolta: ogni risultato deve arrivare anche sul Desktop del VPS (regola 11/08)")

    # --- 7. ora server
    if re.search(r"(InpSessionHour|InpIbInizioOra|SessionHour)\s*[= ]\s*(9|15)\b", riga):
        blocca("FUSO", "ora ITALIANA al posto dell'ora SERVER: server BCM = italiana - 1. DAX = 8 (non 9), Nasdaq = 14 (non 15)")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--riga", help="file di testo con la riga di lancio")
    ap.add_argument("--ps1", action="append", default=[], help="script .ps1 da controllare (ripetibile)")
    a = ap.parse_args()

    if not a.riga and not a.ps1:
        print("niente da controllare: passa --riga e/o --ps1")
        return 2

    if a.riga:
        if not os.path.exists(a.riga):
            print("ERRORE: file riga non trovato: " + a.riga); return 2
        riga = open(a.riga, "r", encoding="utf-8", errors="replace").read().strip()
        try:
            riga.encode("ascii")
            passa("la riga di lancio e' ASCII puro")
        except UnicodeEncodeError:
            blocca("ASCII", "la riga di lancio contiene caratteri non-ASCII (emoji?): incollata in PowerShell 5.1 puo' rompersi")
        controlla_riga_lancio(riga)

    for p in a.ps1:
        if not os.path.exists(p):
            blocca("FILE", "script non trovato: " + p); continue
        dati = leggi(p)
        testo = dati.decode("utf-8", errors="replace")
        controlla_ascii(p, dati)
        controlla_pwsh7(p, testo)
        controlla_formati_net(p, testo)
        controlla_cultura(p, testo)
        controlla_terminali(p, testo, p)

    print("=" * 70)
    print("  CONTROLLO PREVENTIVO -- cancello deterministico")
    print("=" * 70)
    if PASSATI:
        print("\n  PASSATI (" + str(len(PASSATI)) + "):")
        for m in PASSATI:
            print("    OK   " + m)
    if RILIEVI:
        print("\n  RILIEVI (" + str(len(RILIEVI)) + ") -- non bloccano, ma vanno letti:")
        for c, m, d in RILIEVI:
            print("    ~ [" + c + "] " + m + ("   (" + d + ")" if d else ""))
    if BLOCCANTI:
        print("\n  BLOCCANTI (" + str(len(BLOCCANTI)) + "):")
        for c, m, d in BLOCCANTI:
            print("    X [" + c + "] " + m + ("   (" + d + ")" if d else ""))
        print("\nESITO: FAIL -- la riga NON si manda a Claudio.")
        return 1
    print("\nESITO: nessun difetto meccanico.")
    print("ATTENZIONE: questo NON e' un PASS completo. Restano i controlli di")
    print("GIUDIZIO, che li fa l'agente: la riga fa quello che promette? il file")
    print("prova misura la cosa giusta? l'ora e' quella del server?")
    return 0

if __name__ == "__main__":
    sys.exit(main())
