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

USO -- si DICHIARA che oggetto e' (classe 225, 11/09/2026):
  python3 backtest_pipeline/controlla_riga.py --riga FILE_CON_LA_RIGA.txt
  python3 backtest_pipeline/controlla_riga.py --ps1 backtest_pipeline/righe/X.ps1
  python3 backtest_pipeline/controlla_riga.py --oggetto md  righe/RIGA_R125_DA_MANDARE.md
  python3 backtest_pipeline/controlla_riga.py --oggetto prova prove/R125a_costo_buffer_U30USD.txt
  python3 backtest_pipeline/controlla_riga.py righe/X.ps1 righe/RIGA_Y_DA_MANDARE.md
     (senza --oggetto il tipo si deduce da .ps1 / .md / prove\, e la deduzione
      viene STAMPATA. Su un .txt ambiguo il programma si rifiuta e chiede.)

I QUATTRO OGGETTI, e perche' non si controllano allo stesso modo:
  riga  -- una riga di lancio da incollare: pin, marcatore, raccolta, bersaglio.
  ps1   -- uno script: ASCII, costrutti pwsh-7, formati .NET, cultura, terminali.
  prova -- il formato di casa "InpTal=1.0||1.0||0||1.0||N". NON e' PowerShell:
           i "||" sono l'asse della griglia. Controlli PowerShell SPENTI.
  md    -- un documento: si estraggono i blocchi ``` e si controllano QUELLI.
           La prosa NON viene trattata come codice -- ma non viene nemmeno
           ignorata: vedi controlla_prosa(), che tiene chiusa la classe 223.

USCITA: 0 = nessun difetto BLOCCANTE. 1 = almeno uno. I RILIEVI non bloccano.
"""
import argparse, os, re, subprocess, sys

BLOCCANTI = []
RILIEVI   = []
PASSATI   = []

# CLASSE 225 (11/09/2026): il cancello non sapeva CHE OGGETTO stava guardando.
# Da qui in avanti lo sa, e lo dice: ogni messaggio porta davanti il pezzo da
# cui viene (quale blocco di quale .md). Un difetto senza indirizzo costringe
# a rileggere tutto il documento per trovarlo, e chi rilegge tutto salta.
CONTESTO = ""

def _pre(msg):
    return (CONTESTO + " " + msg) if CONTESTO else msg

def blocca(classe, msg, dove=""):
    BLOCCANTI.append((classe, _pre(msg), dove))
def rileva(classe, msg, dove=""):
    RILIEVI.append((classe, _pre(msg), dove))
def passa(msg):
    PASSATI.append(_pre(msg))

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
    """CLAUDE.md distingue, e il cancello deve distinguere uguale:

      "Le lettere accentate nei COMMENTI passano (vengono solo storpiate
       a schermo), l'emoji dentro una STRINGA no."

    Quindi: non-ASCII nel CODICE o dentro una stringa = BLOCCANTE (e' li'
    che il parser di PowerShell 5.1 esplode con "Token imprevisto").
    Non-ASCII in un COMMENTO = RILIEVO: viola la regola di casa dei .ps1
    in ASCII puro e va ripulito, ma non rompe niente.
    Correzione del 09/09/2026: prima erano tutti bloccanti, e la prima
    passata su tutta la pipeline ha prodotto 27 "bloccanti" quasi tutti
    su emoji dentro commenti d'intestazione. Un cancello che grida al
    lupo si impara a ignorare.
    """
    testo = dati.decode("utf-8", errors="replace")
    in_codice, in_commento = [], []
    for i, riga in enumerate(testo.splitlines(), 1):
        if not any(ord(c) > 127 for c in riga):
            continue
        # il '#' vale come inizio commento solo FUORI da una stringa
        nudo = senza_stringhe(riga)
        taglio = nudo.find("#")
        if taglio >= 0 and not any(ord(c) > 127 for c in riga[:taglio]):
            in_commento.append(i)
        else:
            in_codice.append(i)
    if in_codice:
        blocca("ASCII", "byte non-ASCII nel CODICE o dentro una stringa: PowerShell 5.1 legge i .ps1 come ANSI e il parser esplode. Righe: " + ", ".join(str(x) for x in in_codice[:10]), path)
    if in_commento:
        rileva("ASCII", "byte non-ASCII in COMMENTI (righe " + ", ".join(str(x) for x in in_commento[:8]) + "): non rompe il parser, ma viola la regola dei .ps1 in ASCII puro", path)
    if not in_codice and not in_commento:
        passa("ASCII puro: " + os.path.basename(path))

def controlla_parser(path):
    """CLASSE 242 (12/09/2026) -- IL CANCELLO NON COMPILAVA NIENTE.

    Il fatto che l'ha aperta: stanotte questo cancello ha stampato
    "ESITO: nessun difetto meccanico" su un file .ps1 che **non
    compilava affatto** (un `@(` aperto e mai chiuso, per un taglio
    sbagliato delle prime righe). Tutti i controlli qui dentro sono
    TESTUALI -- ASCII, formati, cultura, terminali -- e nessuno di loro
    guarda se il file e' PowerShell valido. E' la stessa classe pagata
    l'11/09 contando le graffe a mano: forma dove serviva semantica.

    Adesso, se sulla macchina c'e' `pwsh`, si chiama il PARSER VERO
    (`System.Management.Automation.Language.Parser`), che e' l'unica
    autorita' sulla sintassi. Un errore di sintassi e' BLOCCANTE: uno
    script che non compila non e' un difetto di stile, e' un file che non
    gira.

    Se `pwsh` NON c'e', il controllo si DICHIARA SALTATO invece di
    tacere: un cancello che salta un controllo in silenzio fa credere di
    averlo fatto.

    NB: `pwsh` e' la 7, sul VPS gira la 5.1. Le differenze fra le due
    versioni le prende `controlla_pwsh7` qui sopra; questo controllo
    serve a un'altra domanda -- "il file e' sintatticamente un file
    PowerShell?" -- e quella risposta e' la stessa in tutte e due.
    """
    import shutil, subprocess, json
    if not shutil.which("pwsh"):
        rileva("PARSER", "controllo di SINTASSI SALTATO: su questa macchina non c'e' 'pwsh'. "
                         "Questo cancello e' TESTUALE: senza parser non sa se il file compila. "
                         "Dichiarato, non taciuto.", path)
        return
    cmd = ("$e=$null; $t=$null; "
           "[void][System.Management.Automation.Language.Parser]::ParseFile("
           "(Resolve-Path -LiteralPath $env:ABTG_FILE).Path, [ref]$t, [ref]$e); "
           "@($e) | ForEach-Object { '' + $_.Extent.StartLineNumber + ': ' + $_.Message }")
    try:
        amb = dict(os.environ); amb["ABTG_FILE"] = os.path.abspath(path)
        r = subprocess.run(["pwsh", "-NoProfile", "-Command", cmd],
                           capture_output=True, text=True, timeout=120, env=amb)
    except Exception as e:
        rileva("PARSER", "controllo di SINTASSI NON ESEGUITO ('pwsh' c'e' ma non risponde: "
                         + str(e) + "). Dichiarato, non taciuto.", path)
        return
    errori = [x.strip() for x in r.stdout.splitlines() if x.strip()]
    if errori:
        blocca("PARSER", "IL FILE NON COMPILA. Il parser di PowerShell riporta "
               + str(len(errori)) + " errore/i di sintassi: " + " | ".join(errori[:4]), path)
    else:
        passa("compila: 0 errori dal parser PowerShell vero (" + os.path.basename(path) + ")")


def controlla_param_block(path):
    """CLASSE 253 (12/09/2026) -- UN param() FUORI POSTO E' INERTE IN SILENZIO.

    Il fatto: il 12/09 ho aggiunto un parametro a aggiorna_news.ps1
    mettendo il blocco `param(...)` DOPO la prima istruzione. Il parser
    di PowerShell ha detto **0 errori** -- perche' `param(...)` dopo
    un'istruzione e' sintatticamente una CHIAMATA DI COMANDO valida -- e
    il parametro **non esisteva**: passarlo dalla riga di comando non
    avrebbe fatto niente, e la guardia che dipendeva da lui era morta.

    E' la lezione della classe 242 rovesciata: la' il cancello non
    compilava; qui **compila e non basta**. Il parser risponde a "questo
    file e' sintatticamente PowerShell?"; questa domanda e' diversa: "il
    blocco dei parametri viene RICONOSCIUTO come tale?".

    Si chiede al parser la STRUTTURA (ScriptBlockAst.ParamBlock), non il
    solo conteggio degli errori. Se il file scrive `param(` ma l'albero
    non ha un ParamBlock, il blocco e' inerte: BLOCCANTE.
    """
    import shutil, subprocess
    if not shutil.which("pwsh"):
        return                     # il salto lo dichiara gia' controlla_parser
    testo = ""
    try:
        testo = open(path, encoding="utf-8", errors="replace").read()
    except Exception:
        return
    # interessa solo chi DICE di avere dei parametri
    if not re.search(r"(?im)^\s*param\s*\(", testo):
        return
    cmd = ("$e=$null; $t=$null; "
           "$a=[System.Management.Automation.Language.Parser]::ParseFile("
           "(Resolve-Path -LiteralPath $env:ABTG_FILE).Path, [ref]$t, [ref]$e); "
           "if($a.ParamBlock){ 'SI:' + (($a.ParamBlock.Parameters | "
           "ForEach-Object { $_.Name.VariablePath.UserPath }) -join ',') } else { 'NO' }")
    try:
        amb = dict(os.environ); amb["ABTG_FILE"] = os.path.abspath(path)
        r = subprocess.run(["pwsh", "-NoProfile", "-Command", cmd],
                           capture_output=True, text=True, timeout=120, env=amb)
    except Exception:
        return
    out = (r.stdout or "").strip()
    if out.startswith("SI:"):
        passa("param block RICONOSCIUTO (" + out[3:] + "): " + os.path.basename(path))
    elif out == "NO":
        blocca("PARAM", "il file scrive 'param(' ma il parser NON riconosce nessun "
               "PARAM BLOCK: messo dopo la prima istruzione, PowerShell lo legge come "
               "una CHIAMATA DI COMANDO e i parametri NON ESISTONO (e il parser non "
               "da' errore). Il blocco param va PRIMA di qualunque istruzione.", path)


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
        fuori.append((i, senza_stringhe(riga.split("#", 1)[0])))
    return fuori


def senza_stringhe(nudo):
    """Toglie i LETTERALI DI STRINGA prima di cercare i costrutti pwsh-7.

    CLASSE 167, trovata il 09/09/2026 dal controllo-preventivo su R123.
    Il cancello dava 5 BLOCCANTI [PWSH7] '||' su walkforward_generico.ps1
    -- il pezzo PIU' IMPORTANTE della pipeline -- e erano TUTTI FALSI:
    sono i "||" del NOSTRO formato .ini dentro stringhe fra virgolette
    (`"$($i.nome)=$($i.val)||$($i.val)||0||$($i.val)||N"`, r.570: la riga
    che scrive ogni cella di ogni round -- se fosse davvero pwsh-7 non
    avremmo un solo CSV in archivio).
    Conseguenza vera e sgradevole: proprio per quei falsi positivi
    walkforward_generico NON ERA MAI PASSATO DAL CANCELLO.

    Nota dichiarata: e' una spogliatura APPROSSIMATA (non gestisce il
    backtick di escape ne' le here-string, che sono gia' saltate a monte).
    Sbaglia nel verso SICURO -- puo' nascondere codice dentro una stringa
    mal chiusa, non puo' inventare un difetto che non c'e'.
    """
    return re.sub(r"'[^']*'", "''", re.sub(r'"[^"]*"', '""', nudo))

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

def conta_argomenti(riga, pos_aperta):
    """Quanti argomenti ha la chiamata che apre a `pos_aperta`?

    Serve perche' `[double]::Parse($s, $INV)` E' CORRETTO: $INV e' la
    nostra InvariantCulture, e cercare la parola "InvariantCulture" nella
    riga produceva 22 falsi positivi su 22 (misurato il 09/09 sulla prima
    passata su tutta la pipeline). Quello che conta non e' COME si chiama
    la cultura: e' SE e' stata passata.
    Ritorna None se la parentesi non si chiude sulla riga: una chiamata
    spezzata non si giudica, si salta.
    """
    liv, argomenti, visto = 0, 1, False
    for c in riga[pos_aperta:]:
        if c == "(":
            liv += 1
        elif c == ")":
            liv -= 1
            if liv == 0:
                return argomenti if visto else 0
        elif c == "," and liv == 1:
            argomenti += 1
        elif liv == 1 and not c.isspace():
            visto = True
    return None


def controlla_cultura(path, testo):
    """CORRETTO il 09/09/2026, dopo un FALSO POSITIVO su RIGA_DIAGNOSI_DAX.ps1.

    La prima stesura segnalava OGNI `[double]$var`. Sbagliato due volte:
      1. prendeva le DICHIARAZIONI DI TIPO dentro param(), che non sono
         conversioni di stringhe (`[double]$SogliaDensita = 55.0`);
      2. in PowerShell il CAST `[double]"2.5"` usa gia' la cultura
         invariante -- non e' li' il pericolo.
    Il pericolo VERO, e quello che ci ha morso davvero, e'
    `::Parse` / `::TryParse` SENZA cultura: quelli seguono la cultura del
    thread, e su un VPS it-IT "2.0" diventa 20.
    Regola di casa applicata a me stesso: un cancello che grida al lupo
    si impara a ignorare, ed e' peggio di nessun cancello.
    """
    sospetti = []
    in_param = False
    for i, riga in enumerate(testo.splitlines(), 1):
        nudo = riga.split("#", 1)[0]
        if re.match(r"\s*param\s*\(", nudo, re.I): in_param = True
        if in_param:
            if ")" in nudo and not re.search(r"\w\s*\(", nudo.split(")")[0]):
                in_param = False
            continue
        # SOLO i tipi CON LA VIRGOLA: su un intero il separatore decimale non
        # esiste, quindi la cultura non lo puo' mordere. Segnalare [int]::TryParse
        # sarebbe il terzo falso positivo di fila su questo stesso controllo.
        for m in re.finditer(r"\[(?:double|single|float|decimal)\]::(Try)?Parse\s*\(", nudo, re.I):
            n_arg = conta_argomenti(nudo, m.end() - 1)
            if n_arg is None:
                continue                      # chiamata spezzata su piu' righe: non giudico
            # Parse(x) = 1 argomento -> nessuna cultura passata.
            # TryParse(x,[ref]y) = 2 argomenti -> nessuna cultura passata.
            # Con un argomento in piu' la cultura c'e' (spesso e' $INV).
            limite = 2 if m.group(1) else 1
            if n_arg <= limite:
                sospetti.append((i, nudo.strip()[:60]))
    if sospetti:
        rileva("CULTURA", "Parse/TryParse senza cultura invariante: " + " | ".join("r." + str(i) + " " + t for i, t in sospetti[:5]) + "  -> su VPS it-IT '2.0' diventa 20", path)
    else:
        passa("nessun Parse decimale senza cultura invariante: " + os.path.basename(path))

GUARDIA = r"(Muori|throw|exit\s+1|VIETATO|notlike|-ne\b|Write-Host|Red)"

VERBI_CHE_SCRIVONO = (r"(Copy-Item|Move-Item|Rename-Item|Remove-Item|New-Item|"
                      r"Set-Content|Add-Content|Out-File|Export-\w+|Set-ItemProperty|"
                      r"Start-Process|Compress-Archive|\.CopyTo\(|\.MoveTo\(|"
                      r"\[IO\.File\]::(Write|Append|Copy|Move|Delete|Create))")


def scrive_dentro(testo, ago):
    """CLASSE 670-b (23/09/2026) -- il percorso VIETATO finisce dentro un verbo
    che SCRIVE? Allora non e' una menzione, e' un bersaglio, e si BLOCCA.

    Il commento storico di questo file diceva che un cancello testuale non sa
    distinguere un bersaglio da un'etichetta, e che "nel contro-esempio non ci
    finisce nemmeno dentro un verbo". Il contro-esempio del 23/09 invece SI':
        Copy-Item -Path '...' -Destination 'C:\\BCM_Reale\\MQL5\\Experts\\ABTG_X.ex5'
    Un .ex5 copiato nella cartella Experts del CONTO REALE 10105439. Quel caso
    si riconosce, e quindi si blocca invece di segnalarlo.
    """
    for pezzo in testo.split(";"):
        if ago in pezzo and re.search(VERBI_CHE_SCRIVONO, pezzo, re.I):
            return True
    return False


def guardia_vicina(nudo, ago):
    """CLASSE 670 (23/09/2026) -- SU UNA RIGA FISICA SOLA, UNA GUARDIA COPRE
    SOLO IL PEZZO DI RIGA IN CUI STA, NON TUTTA LA RIGA.

    Il buco: `coperto = re.search(GUARDIA_STRETTA, nudo)` cercava il throw in
    TUTTA la riga. Ogni riga di casa porta gia' due throw legittimi (guardia di
    macchina + controllo del MARCATORE), quindi `coperto` era SEMPRE True e il
    divieto sul REALE non poteva mai scattare.
    Contro-esempio MISURATO il 23/09: una riga con
        Copy-Item -Destination 'C:\\BCM_Reale\\MQL5\\Experts\\ABTG_X.ex5'
    usciva "nessun difetto meccanico" con SETTE verdi.
    E l'incentivo era ROVESCIATO: TOGLIERE la guardia di macchina rendeva la
    riga piu' sicura agli occhi del cancello.

    La regola: si spezza la riga sui ';' e si pretende una guardia NELLO STESSO
    pezzo in cui compare il percorso vietato. Un throw a inizio riga non
    assolve un Copy-Item dieci statement dopo.
    """
    if ago not in nudo:
        return True
    for pezzo in nudo.split(";"):
        if ago in pezzo and not re.search(GUARDIA_STRETTA, pezzo, re.I):
            return False
    return True


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

# CLASSE 221 (10/09/2026). Il commento a GUARDIA_RIGA gia' diceva che sulla
# riga la GUARDIA generica e' "troppo larga (basterebbe un Write-Host per
# zittire il divieto)" -- ma la correzione era stata applicata SOLO al ramo
# della riga su UNA sola riga fisica. Una riga di lancio MULTIRIGA passa da
# controlla_terminali(), che usa la GUARDIA larga, e li' il buco e' rimasto.
# Contro-esempio misurato su R125: cambiando il bersaglio in 'C:\BCM_Reale'
# la riga usciva "nessun difetto meccanico", perche' la riga SUCCESSIVA era
# "if($LASTEXITCODE -ne 0){ Write-Host (...) -ForegroundColor Red }" e conteneva
# Write-Host, Red e -ne, cioe' TRE dei token della GUARDIA larga.
# Due rimedi, indipendenti:
#   a) sul testo di una RIGA DI LANCIO si usa la guardia STRETTA;
#   b) un percorso vietato passato come VALORE di -Terminal*/-Percorso* non e'
#      mai una guardia: quello e' un bersaglio, e blocca sempre.
GUARDIA_STRETTA = r"(Muori|throw|exit\s+1|VIETATO)"

# =====================================================================
#  CLASSE 536 (21/09/2026) -- IL CANCELLO BLOCCAVA LA RIGA GIUSTA, PERCHE'
#  GUARDAVA IL PERCORSO E NON LA COPPIA "MACCHINA + PERCORSO".
#
#  IL FATTO. Il 21/09 Claudio ha firmato che, finche' una challenge e'
#  viva, i round NON girano piu' sul VPS ma sul PC DI BACKTEST
#  (CLAUDE.md, dopo che un backtest a tick reali ha inchiodato il VPS
#  nella prima mezz'ora del primo giorno di FTMO). Sul PC di backtest
#  l'unico MT5 e' installato in
#      C:\Program Files\BCM Markets MT5 Terminal
#  che e' ESATTAMENTE la stringa che sul VPS e' il PICCOLO 50503392, con
#  le sedie vive sopra. VIETATI_PERCORSO la conteneva (giustamente), e
#  quindi lo strato 1 del cancello BLOCCAVA LA RIGA CORRETTA: la firma
#  di Claudio non era eseguibile passando dal cancello.
#
#  LA CORREZIONE NON E' UN ALLENTAMENTO, ed e' importante che si veda:
#  non e' stato tolto NIENTE da VIETATI_PERCORSO ne' da nessun controllo.
#  E' stata INSEGNATA al cancello la stessa identica tabella che gli
#  .ps1 hanno gia' dal 21/09 -- il blocco GUARDIA_BANCO_POSITIVA_v2,
#  identico byte per byte in
#      backtest_pipeline\righe\RIGA_ROUND_VPS.ps1
#      backtest_pipeline\walkforward_generico.ps1
#      backtest_pipeline\righe\RIGA_SCAN_GESTIONE.ps1
#  (banco che dimostra che non divergono:
#   pwsh -NoProfile -File backtest_pipeline/banco_guardia_macchina.ps1).
#  Qui sotto c'e' la PORTA IN PYTHON della stessa tabella e della stessa
#  logica, nello stesso ordine: vietati PRIMA, macchina POI, e
#  fail-closed su cio' che non e' in tabella.
#
#  >>> E LA DIFFERENZA CHE CONTA FRA I DUE STRATI <<<
#  Lo .ps1 GIRA su una macchina e puo' chiedere $env:COMPUTERNAME. Il
#  cancello no: legge un TESTO, e un testo non ha una macchina. Quindi
#  la macchina, qui, e' quella che LA RIGA DICHIARA -- e si accetta la
#  dichiarazione SOLO se la riga si RIFIUTA DI GIRARE ALTROVE, cioe' se
#  porta una guardia della forma
#      if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw '...' }
#  Senza quella guardia la macchina e' SCONOSCIUTA e non si concede
#  nessuna deroga: il comportamento resta quello di prima, al byte.
#  Cosi' la deroga non e' mai una parola: e' una riga che, incollata
#  nella finestra sbagliata, muore prima di scaricare qualunque cosa --
#  che e' anche la rete contro l'incidente del 06/09 (un EA destinato al
#  piccolo quasi finito sul REALE) e la regola del 12/09 sul bersaglio
#  dichiarato in testa.
# =====================================================================
BERSAGLI_PER_MACCHINA = [
    {"macchina": "VMI3047753",
     "perc":     "C:\\MT5_Backtest",
     "conto":    "50504400",
     "comequi":  "il banco solo-tester del VPS",
     # False = su questa macchina NESSUN percorso della lista dei vietati
     #         puo' essere ammesso, per nessuna ragione.
     "deroga":   False},
    {"macchina": "DESKTOP-H4D7CAJ",
     "perc":     "C:\\Program Files\\BCM Markets MT5 Terminal",
     "conto":    "50503392",
     "comequi":  "il terminale del PC di backtest (ATTENZIONE: e' loggato sul demo 50503392, e il 14/08/2026 da quella macchina sono partiti ordini VERI)",
     # True = su QUESTA macchina, e SOLO qui, il percorso del piccolo e'
     #        il bersaglio legittimo. La deroga NON e' un permesso
     #        generico: vale SOLO per il percorso che, normalizzato, e'
     #        IDENTICO a 'perc' -- quindi "...MT5 Terminal -V3" resta
     #        VIETATO anche qui, perche' non e' lo stesso percorso.
     "deroga":   True},
]

# I vietati per NOME, copiati dal blocco condiviso. NON decidono da soli
# qual e' il bersaglio -- decide la tabella -- ma si consultano PRIMA e
# vincono, cosi' che un terminale vietato resti vietato SU QUALUNQUE
# MACCHINA, anche su una che non e' in tabella.
# NB: e' un SOVRAINSIEME di VIETATI_PERCORSO (che resta come sta, perche'
# governa un altro controllo -- la MENZIONE dentro uno script). Qui
# entrano anche FTMO 541452707 e il manuale 50503635: un bersaglio, non
# una menzione.
TERMINALI_VIETATI = [
    ("BCM_Reale",                "il terminale del conto REALE 10105439"),
    ("-V3",                      "il terminale del 100k, conto 50504263"),
    ("BCM Markets MT5 Terminal", "un terminale con SEDIE VIVE sopra: il piccolo 50503392 (e il 100k, che sta nella stessa famiglia di cartelle)"),
    ("10105439",                 "il conto REALE"),
    ("50504263",                 "il 100k"),
    ("50503392",                 "il piccolo"),
    ("FTMO",                     "il terminale della CHALLENGE FTMO viva, conto 541452707 (C:\\FTMO): sei sedie che stanno operando"),
    ("541452707",                "il conto della challenge FTMO"),
    ("MT5_MANUALE",              "il terminale del trading a mano, conto 50503635"),
    ("50503635",                 "il conto del trading a mano"),
]

def normalizza_percorso_win(p):
    """Porta in Python di NormalizzaPercorsoWin (blocco condiviso).
    Stessa regola, stesso verso dell'errore: cio' che non so risolvere lo
    RIFIUTO ("" = no), non lo indovino. Non uso os.path: il suo risultato
    dipende dalla piattaforma, e questo cancello gira su Linux mentre la
    riga girera' su Windows."""
    if p is None:
        return ""
    s = ("" + p).strip()
    if s == "":
        return ""
    s = s.replace("/", "\\")
    if "~" in s:
        return ""                                  # nome 8.3: non si indovina
    if re.search(r"[\*\?\[\]\"|<>]", s):
        return ""                                  # jolly e caratteri fuori posto
    if not re.match(r"^[A-Za-z]:\\", s):
        return ""                                  # niente UNC, niente \\?\, niente "C:senza-barra"
    disco, resto = s[:2].upper(), s[2:]
    if ":" in resto:
        return ""                                  # un secondo ':' non e' un percorso
    pezzi = []
    for t in resto.split("\\"):
        if t == "" or t == ".":
            continue
        if t == "..":
            if not pezzi:
                return ""                          # si risale sopra la radice
            pezzi.pop()
            continue
        pezzi.append(t)
    if not pezzi:
        return disco + "\\"                        # la RADICE: rifiutata piu' sotto
    return disco + "\\" + "\\".join(pezzi)

def radice_di_disco(norm):
    return bool(norm) and bool(re.match(r"^[A-Za-z]:\\$", norm))

def riga_macchina(macchina):
    m = ("" + (macchina or "")).strip()
    if m == "":
        return None
    for b in BERSAGLI_PER_MACCHINA:
        if m.lower() == b["macchina"].lower():     # i nomi NetBIOS non distinguono le maiuscole
            return b
    return None

def elenco_macchine_ammesse():
    return "; ".join(b["macchina"] + " -> " + b["perc"] + " (conto " + b["conto"] + ")"
                     for b in BERSAGLI_PER_MACCHINA)

def motivo_vietato_per_nome(chiesto, macchina):
    """Il PRIMO gradino, da solo: i vietati per NOME, con l'unica deroga.
    Si usa anche sui flag che NON sono -Terminal* (-Percorso, -Cartella,
    -Path), dove il valore puo' benissimo essere una cartella di risultati e
    non un terminale: li' la domanda giusta non e' "e' IL bersaglio di questa
    macchina?" -- sarebbe un falso positivo su ogni Compress-Archive -Path --
    ma resta "sta nominando un terminale che non si tocca?"."""
    g = ("" + (chiesto or "")).strip()
    m = ("" + (macchina or "")).strip()
    riga = riga_macchina(m)
    n = normalizza_percorso_win(g)
    for pv, chi in TERMINALI_VIETATI:
        if pv.lower() in g.lower():
            derogato = (riga is not None and riga["deroga"] and n != ""
                        and n.lower() == riga["perc"].lower())
            if not derogato:
                return "TERMINALE VIETATO: '" + g + "' nomina " + chi + "."
    return ""

def motivo_rifiuto_bersaglio(chiesto, macchina):
    """"" se il bersaglio e' quello ammesso SU QUESTA MACCHINA, altrimenti
    il MOTIVO. Stesso ordine del blocco condiviso, e l'ordine E' la guardia:
      1. i VIETATI PER NOME, prima di tutto e con la precedenza sulla
         tabella (l'unica deroga e' il percorso del piccolo sulla SOLA
         DESKTOP-H4D7CAJ, e servono TRE cose insieme: macchina in tabella,
         flag deroga, percorso normalizzato IDENTICO al suo bersaglio);
      2. la MACCHINA (fail-closed: chi non e' in tabella non ha bersagli);
      3. la forma del percorso e la RADICE DI DISCO;
      4. il confronto POSITIVO col bersaglio DI QUELLA MACCHINA."""
    g = ("" + (chiesto or "")).strip()
    m = ("" + (macchina or "")).strip()
    riga = riga_macchina(m)
    n = normalizza_percorso_win(g)

    vietato = motivo_vietato_per_nome(g, m)
    if vietato:
        return vietato
    if riga is None:
        return ("MACCHINA SCONOSCIUTA: la riga dichiara di girare su '" + m + "', che NON e'"
                " nella tabella dei bersagli. Ammesse: " + elenco_macchine_ammesse() + "."
                " Non esiste un ripiego: una macchina che non conosco non ha bersagli.")
    if g == "":
        return ("BERSAGLIO VUOTO: su '" + riga["macchina"] + "' il bersaglio sarebbe "
                + riga["perc"] + " (conto " + riga["conto"] + "): o lo si passa, o lo si"
                " lascia fuori del tutto e lo mette la tabella dello script.")
    if n == "":
        return ("BERSAGLIO NON RICONDUCIBILE A UNA CARTELLA DI WINDOWS: '" + g + "'."
                " Un nome 8.3, un percorso di rete, un \\\\?\\, un jolly o un percorso non"
                " ancorato a un disco non si indovinano: si rifiutano.")
    if radice_di_disco(n):
        return ("RADICE DI UN DISCO: '" + g + "'. Un disco intero non e' un terminale: la"
                " pipe di chiusura diventerebbe '" + n + "*', cioe' OGNI terminal64 della"
                " macchina, conto REALE compreso.")
    if n.lower() != riga["perc"].lower():
        return ("NON E' IL BERSAGLIO DI QUESTA MACCHINA: '" + g + "' (normalizzato: '" + n
                + "'). Su '" + riga["macchina"] + "' l'unico terminale ammesso e' "
                + riga["perc"] + " (conto " + riga["conto"] + "). Un percorso puo' essere"
                " legittimo su UN'ALTRA macchina e non qui: il bersaglio lo decide la"
                " MACCHINA, non il testo del percorso.")
    return ""

# La DICHIARAZIONE DI MACCHINA che il cancello accetta: solo una guardia
# che RIFIUTA di girare altrove. Il verso conta -- '-eq' + throw vuol dire
# l'esatto contrario ("muori SU quella macchina") e NON e' una
# dichiarazione: in quel caso la macchina resta sconosciuta, cioe' chiusa.
RE_MACCHINA_NE = re.compile(r"\$env:COMPUTERNAME\s*-ne\s*(?:'([^']*)'|\"([^\"]*)\")", re.I)

def macchina_dichiarata(testo):
    """(nome, nota). nome="" = nessuna macchina dichiarata -> nessuna deroga.
    nome="?" = dichiarazioni DISCORDI -> e' un difetto, non un'assenza."""
    nomi = []
    for m in RE_MACCHINA_NE.finditer(testo):
        val = (m.group(1) or m.group(2) or "").strip()
        coda = testo[m.end(): m.end() + 240]
        if not re.search(GUARDIA_STRETTA, coda, re.I):
            continue          # nomina la macchina ma non rifiuta: non e' una guardia
        if val:
            nomi.append(val)
    unici = sorted(set(x.lower() for x in nomi))
    if not unici:
        return "", "nessuna guardia '$env:COMPUTERNAME -ne ... { throw }' nella riga"
    if len(unici) > 1:
        return "?", "la riga dichiara DUE macchine diverse: " + ", ".join(sorted(set(nomi)))
    return nomi[0], "guardia di macchina presente"

# Attenzione: i percorsi veri CONTENGONO SPAZI ("C:\Program Files\BCM Markets
# MT5 Terminal -V3"). Un [^\s]* si ferma al primo spazio e lascia passare
# proprio i due terminali di Program Files: si cattura il VALORE per intero
# (fra apici, fra virgolette, o fino a spazio se nudo) e lo si confronta dopo.
BERSAGLIO_VALORE = re.compile(
    r"-(Terminal(?:e)?(?:Backtest)?|Percorso|Cartella|Path)\s+"
    r"(?:'([^']*)'|\"([^\"]*)\"|(\S+))", re.I)

# CLASSE 537 (21/09/2026) -- IL BERSAGLIO PASSATO COME ELEMENTO DI UN ARRAY
# NON VENIVA VISTO DA NESSUNO, E LA FORMA E' QUELLA DI CASA.
# Misurato ESEGUENDO il cancello, non leggendolo: la riga di round di casa
# non scrive "-TerminaleBacktest C:\..." con uno SPAZIO, scrive
#     $a=@('-NoProfile','-File',$p,'-TerminaleBacktest','C:\BCM_Reale',...);
#     Start-Process powershell -ArgumentList $a
# cioe' flag e valore separati da "','" e non da uno spazio. BERSAGLIO_VALORE
# pretende \s+ e quindi NON matcha: quella riga -- un round intero puntato
# sul CONTO REALE 10105439 -- usciva "ESITO: nessun difetto meccanico",
# USCITA 0, con due soli RILIEVI. Riprodotta col pin vero b8e679c4.
# E' la classe 223 che si riapre da un'altra porta: la 223 aveva imparato
# che un bersaglio vietato non e' mai innocente, ma il riconoscitore del
# bersaglio guardava UNA SOLA sintassi. Stessa lezione della 457: il
# cancello non deve guardare il codice come lo scrive il manuale, ma come
# lo scriviamo NOI.
BERSAGLIO_VALORE_ARRAY = re.compile(
    r"['\"]-(Terminal(?:e)?(?:Backtest)?|Percorso|Cartella|Path)['\"]\s*,\s*"
    r"(?:'([^']*)'|\"([^\"]*)\")", re.I)

def valori_bersaglio(riga_cruda):
    """Tutti i valori passati a -Terminal*/-Percorso*, nelle DUE sintassi che
    usiamo davvero: con lo spazio e dentro l'array di -ArgumentList.
    Gli apici interni si tolgono: per passare un percorso CON SPAZI dentro un
    array si scrive '"C:\\Program Files\\..."', e le virgolette fanno parte
    del quoting, non del percorso."""
    fuori = []
    for rx in (BERSAGLIO_VALORE, BERSAGLIO_VALORE_ARRAY):
        for m in rx.finditer(riga_cruda):
            gruppi = m.groups()
            flag, val = gruppi[0], ""
            for g in gruppi[1:]:
                if g:
                    val = g
                    break
            val = val.strip().strip('"').strip("'").strip()
            if val:
                fuori.append((flag, val))
    return fuori

def bersagli_vietati(riga_cruda, macchina=""):
    """I valori di -Terminal*/-Percorso* da RIFIUTARE, con il MOTIVO.

    DUE REGIMI, e la differenza e' tutta la classe 536:
      - macchina NON dichiarata (e' il caso di ogni riga scritta prima di
        oggi): vale la regola STORICA, cioe' i soli VIETATI PER NOME. Non
        si concede nessuna deroga, perche' non c'e' nessuna macchina a cui
        concederla. Comportamento identico a prima, al byte.
      - macchina DICHIARATA (la riga si rifiuta di girare altrove): vale la
        guardia INTERA, la stessa dei tre .ps1 -- quindi anche "questo
        percorso non e' il bersaglio di QUESTA macchina", che prima nessuno
        controllava.
    """
    fuori = []
    mac = ("" + (macchina or "")).strip()
    for flag, val in valori_bersaglio(riga_cruda):
        e_terminale = flag.lower().startswith("terminal")
        if mac and e_terminale:
            # macchina dichiarata + flag che nomina IL TERMINALE: guardia INTERA
            motivo = motivo_rifiuto_bersaglio(val, mac)
        else:
            # tutto il resto: la regola STORICA, i soli vietati per nome
            motivo = motivo_vietato_per_nome(val, mac)
            if motivo and not mac:
                motivo += (" Nessuna macchina e' dichiarata in questa riga, quindi nessuna"
                           " deroga e' possibile (classe 536): per lanciare un round sul PC"
                           " di backtest la riga deve portare"
                           " if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ... }")
        if motivo:
            fuori.append((val, motivo))
    return fuori

def controlla_terminali(path, testo, dove, stretta=False, macchina=""):
    righe = righe_utili(testo)
    # Il percorso di un terminale sta SEMPRE fra virgolette, e righe_utili()
    # le toglie: questo controllo va fatto sul testo GREZZO (stessa scelta,
    # e stessa motivazione, del ramo a riga singola).
    grezze = {n: l for n, l in enumerate(testo.splitlines(), 1)}
    for k, (i, nudo) in enumerate(righe):
        cruda = grezze.get(i, "")
        # CLASSE 223 (11/09/2026) -- QUI NON C'E' NESSUNA ESENZIONE, ED E' VOLUTO.
        # La 221 aveva subordinato questo blocco a "se non c'e' una guardia
        # stretta sulla riga". Contro-esempio misurato stanotte sulla riga vera
        # di R125: OGNI riga di lancio di casa porta gia' un
        #     if(-not (Select-String ... -Pattern 'MARCATORE_...')){ throw '...' }
        # cioe' un 'throw' del tutto legittimo che non c'entra niente col
        # terminale. Su UNA riga sola quel throw copriva l'intera riga, e
        #     -TerminaleBacktest 'C:\BCM_Reale'   (conto REALE 10105439)
        # usciva "nessun difetto meccanico". Il buco non era raro: era ATTIVO
        # su tutte le righe del progetto, perche' il controllo del marcatore e'
        # obbligatorio e porta sempre un throw.
        # La regola giusta non e' una guardia piu' stretta, e' che
        # UN TERMINALE VIETATO PASSATO COME BERSAGLIO NON E' MAI INNOCENTE:
        # nessun throw altrove sulla riga puo' renderlo tale. Una guardia vera
        # nomina il percorso per RIFIUTARLO (dentro un -like/-eq), non lo passa
        # come valore di -Terminal.../-Percorso... -- e in quel caso
        # bersagli_vietati() non lo cattura affatto.
        if True:
            for val, motivo in bersagli_vietati(cruda, macchina):
                blocca("221", "r." + str(i) + ": BERSAGLIO RIFIUTATO (-Terminal.../-Percorso..."
                              " = '" + val + "'). " + motivo + " Nessuna guardia altrove sulla"
                              " riga lo rende innocuo (classe 223)", dove)
        # CLASSE 457 (19/09/2026) -- IL CANCELLO CERCAVA SOLO FUORI DAGLI APICI,
        # E UN PERCORSO WINDOWS STA SEMPRE FRA APICI.
        # Il fatto: uno script di QUATTRO righe che copia dentro la cartella
        # dati del REALE e poi fa `Get-Process terminal64 | Stop-Process -Force`
        # usciva "ESITO: nessun difetto meccanico", USCITA 0. Riprodotto a mano.
        # Causa: `nudo` viene da righe_utili() -> senza_stringhe(), che
        # sostituisce ogni '...' con ''. Il percorso vietato spariva PRIMA del
        # confronto. Era la correzione giusta della classe 167 (non confondere
        # una stringa con del codice) applicata al controllo SBAGLIATO: qui la
        # stringa E' il bersaglio, ed e' esattamente la cosa da guardare.
        #
        # PERCHE' E' UN RILIEVO E NON UN BLOCCO -- tre misure, non un'opinione:
        #  (1) estendendo il blocco a tutti e tre i nomi di VIETATI_PERCORSO,
        #      i .ps1 di casa bloccati passavano da 0 a 141 su 248, runner
        #      compreso: "BCM Markets MT5 Terminal" e' la cartella del PICCOLO,
        #      bersaglio LEGITTIMO di decine di script. Ristretto a BCM_Reale.
        #  (2) cercando anche nei COMMENTI: 248 su 248, cioe' TUTTI. Ogni riga
        #      di casa DEVE dichiarare i bersagli vietati (emendamento 12/09 in
        #      CLAUDE.md), quindi quei nomi stanno per forza ovunque. Cercarli
        #      nei commenti punisce chi rispetta la regola: e' la classe 446.
        #      Quindi si guarda solo la parte VIVA della riga.
        #  (3) bloccando solo quando il nome ha un BACKSLASH attaccato (cioe'
        #      e' un percorso e non una voce di elenco): 6 falsi positivi su
        #      249, e tutti e sei della stessa forma -- il percorso e'
        #      un'ETICHETTA, non un bersaglio:
        #        runner_abtg.ps1 r.457  il CASO DI PROVA del runner, quello che
        #                               verifica che il reale venga RIFIUTATO
        #        RIGA_CENSIMENTO r.57   chiave di una mappa percorso -> conto
        #        RIGA_TROVA_POSTNEWS    idem, mappa GUID -> conto
        #        RIGA_SPREADLOGGER r.75 la costante che serve a ESCLUDERLO
        #        pubblica_trades r.186  testo di un messaggio a schermo
        #        prova_kill_chirurgico  finto processo di prova
        #
        # LA CONCLUSIONE, ed e' la cosa da ricordare: un cancello TESTUALE non
        # sa distinguere un BERSAGLIO da un'ETICHETTA. Servirebbe capire se il
        # percorso finisce dentro un verbo (Copy-Item, Start-Process), e nel
        # contro-esempio non ci finisce nemmeno: e' un'assegnazione nuda.
        # Quindi il cancello fa quello che sa fare -- LO RENDE VISIBILE -- e il
        # giudizio lo mette lo strato 2 (agente controllo-preventivo): e' la
        # divisione dei due strati gia' scritta in CLAUDE.md. Prima di oggi non
        # era visibile per niente, ed e' questa la differenza che conta.
        INTOCCABILI = ["BCM_Reale"]        # il REALE, e basta
        taglio_c = senza_stringhe(cruda).find("#")
        viva = cruda if taglio_c < 0 else cruda[:taglio_c]
        for v in VIETATI_PERCORSO:
            if stretta:
                # CLASSE 670: la guardia vale per lo STATEMENT, non per la riga.
                # E si cerca nello STESSO testo in cui si cerca il percorso:
                # 'nudo' per il codice nudo, 'viva' per il percorso DENTRO una
                # stringa -- altrimenti il ramo del REALE resta muto, che e'
                # esattamente il buco che questa classe chiude.
                coperto = guardia_vicina(nudo, v)
                coperto_v = guardia_vicina(viva, v)
            else:
                coperto = in_una_guardia(righe, k)
                coperto_v = coperto
            if v in nudo and not coperto:
                blocca("TERMINALE", "r." + str(i) + ": nomina '" + v + "' senza una guardia che lo rifiuta nelle righe vicine. Il 100k 50504263, il REALE 10105439 e il piccolo " + CONTO_PICCOLO + " non si toccano", dove)
            elif (v in INTOCCABILI and v in viva and v not in nudo
                  and not coperto_v and scrive_dentro(viva, v)):
                blocca("TERMINALE", "r." + str(i) + ": il percorso '" + v + "' finisce dentro"
                       " un VERBO CHE SCRIVE (Copy-Item / Set-Content / Start-Process ...)."
                       " Non e' una menzione: e' un bersaglio. IL CONTO REALE " + "10105439"
                       " NON SI TOCCA, MAI (classe 670)", dove)
            elif v in INTOCCABILI and v in viva and v not in nudo and not coperto_v:
                rileva("457", "r." + str(i) + ": nomina '" + v + "' DENTRO UNA STRINGA."
                              " Il cancello NON sa dire se e' un bersaglio, un'etichetta"
                              " o una lista di rifiuti: VA LETTO A MANO."
                              " Il REALE 10105439 non si tocca mai", dove)
        for c in CONTI_VIETATI:
            # CLASSE 670: su una riga sola vale la guardia DELLO STATEMENT.
            cop_c = guardia_vicina(nudo, c) if stretta else in_una_guardia(righe, k)
            cop_cv = guardia_vicina(viva, c) if stretta else cop_c
            if c in nudo and not cop_c:
                blocca("CONTO", "r." + str(i) + ": nomina il conto " + c + " fuori da una guardia", dove)
            elif c in viva and c not in nudo and not cop_cv:
                rileva("457", "r." + str(i) + ": nomina il conto " + c + " DENTRO UNA"
                              " STRINGA. VA LETTO A MANO: bersaglio o guardia?", dove)
        # CLASSE 457-b -- E IL CANCELLO NON CERCAVA NESSUN MODO DI AMMAZZARE UN
        # TERMINALE, benche' il 12/09 uno script di casa avesse spento TUTTI i
        # terminali della macchina, reale compreso. Qui non si blocca: chiudere
        # il terminale del BANCO e' legittimo e lo fanno 216 .ps1 del repo
        # (misurato). Si RILEVA, perche' chi legge deve andare a guardare CHE
        # COSA viene chiuso: il filtro dev'essere una COSTANTE sul percorso del
        # banco, mai una variabile che arriva da fuori.
        if re.search(r"Stop-Process|taskkill|\.Kill\s*\(|CloseMainWindow", cruda, re.I):
            rileva("457", "r." + str(i) + ": questa riga puo' TERMINARE un processo."
                          " Non e' vietato (il banco si chiude), ma VA LETTO A MANO che"
                          " cosa chiude: il filtro dev'essere una COSTANTE sul percorso"
                          " del banco, mai una variabile che arriva da fuori", dove)

# CLASSE 173 (10/09/2026) -- il cancello chiedeva un PIN e un MARCATORE anche a una
# riga che NON scarica e NON esegue nessuno script: un censimento di sola lettura
# fatto di soli cmdlet locali (Get-Process ...) non ha niente da appuntare a un
# commit, e bloccarlo era un falso positivo. La restrizione e' vera nell'altro
# verso e li' NON si tocca: se la riga scarica o esegue uno .ps1, pin e marcatore
# restano BLOCCANTI. In cambio la riga esente deve dimostrare di essere di sola
# lettura: se nomina un cmdlet che scrive, l'esenzione decade e torna bloccante.
# LISTA BIANCA: la sola lettura si DIMOSTRA, non si presume. Una lista NERA
# dimentica sempre qualcosa -- misurato il 10/09: con la lista nera passavano
# "Get-Process terminal64 | ForEach-Object { $_.Kill() }", "taskkill /IM
# terminal64.exe /F", "rm C:\...\Guardian.ex5" e "& C:\BCM_Reale\terminal64.exe".
LETTURA_AMMESSI = set(x.lower() for x in [
    "Get-Process", "Get-Service", "Get-Date", "Get-ChildItem", "Get-Item",
    "Get-Content", "Get-ItemProperty", "Get-CimInstance", "Get-WmiObject",
    "Get-ScheduledTask", "Get-ScheduledTaskInfo", "Get-ComputerInfo", "Get-Volume", "Get-PSDrive",
    "Get-Location", "Get-Command", "Get-Member", "Get-Host", "Get-Random",
    "Select-Object", "Sort-Object", "Where-Object", "ForEach-Object",
    "Group-Object", "Measure-Object", "Compare-Object", "Format-Table",
    "Format-List", "Out-String", "Out-Host", "Select-String", "Write-Output",
    "Write-Host", "Test-Path", "Join-Path", "Split-Path", "Resolve-Path",
    "Convert-Path", "ConvertTo-Json", "ConvertFrom-Json", "Import-Csv",
])
# comandi nativi, alias e METODI che scrivono/uccidono e che non hanno la forma Verbo-Nome
# CLASSE 234 (11/09/2026) -- DUE falsi positivi misurati sullo stesso blocco,
# il PASSO 3 (la raccolta) di RIGA_R125_DA_MANDARE.md:
#   a) "& {" NON invoca un eseguibile: apre uno SCRIPTBLOCK, ed e' la forma
#      con cui comincia OGNI riga di lancio di casa. Chiedere il pin per un
#      "& {" vuol dire bocciare la forma standard del progetto. Il contenuto
#      dello scriptblock resta esaminato da tutti gli altri controlli, perche'
#      e' testo della stessa riga: qui non si perde niente.
#   b) "\b(rm|rd|ni|md|sp|si|...)\b" scattava sul NOME DI UNA VARIABILE:
#      "$rd = Join-Path ..." contiene "rd" preceduto da "$", e "$" non e' un
#      carattere di parola, quindi \b apriva. Tre dei sei difetti del blocco
#      erano questo. Adesso l'alias non vale se preceduto da $ (variabile),
#      da - (parametro) o da . (proprieta'/metodo).
LETTURA_VIETATI = [
    (r"(?<![A-Za-z0-9_$-])&(?!&)(?!\s*\{)",   "l'operatore di chiamata '&' su qualcosa che non e' uno scriptblock: una riga senza pin non puo' invocare un eseguibile"),
    (r"\b(taskkill|schtasks|net|reg|attrib|xcopy|robocopy|cmd|wmic|sc)\b", "comando nativo che puo' modificare la macchina"),
    (r"(?<![A-Za-z0-9_$.-])(rm|del|erase|rd|rmdir|ri|mv|cp|ni|cpi|mi|sp|spps|saps|kill|start|echo|tee|ac|iex|ii|si|rp|rni|epcsv|md|mkdir|clc|cli|sal|sbp|rjb|spjb)\b", "alias PowerShell/DOS che scrive o uccide"),
    (r"\.(Kill|Close|CloseMainWindow|Stop|Delete|Remove|Save|WriteAllText|WriteAllLines|AppendText|Create)\s*\(", "chiamata a un METODO che modifica lo stato (es. $_.Kill())"),
    (r"\bNew-Object\b",                      "New-Object: puo' costruire un WebClient o uno scrittore di file"),
    (r"\[\s*System\.IO\.",                   "accesso diretto a System.IO"),
    (r">",                                    "redirezione: scrive un file"),
]
# CLASSE 235 (11/09/2026) -- IL BLOCCO DI RACCOLTA E' OBBLIGATORIO E IL CANCELLO
# LO BOCCIAVA. La regola delle righe di lancio (CLAUDE.md, punto 2) IMPONE la
# riga di raccolta: copia sul Desktop + Compress-Archive. Quel blocco non scarica
# niente (quindi non e' pinnabile: non c'e' nessuno script a cui appuntare un
# commit) e per forza SCRIVE. Con la sola classe 173 usciva BLOCCANTE:
#   "New-Item, Copy-Item, Compress-Archive non sono nella lista bianca".
# Cioe' il cancello bocciava la forma che la regola di casa impone. Un cancello
# che boccia l'unica forma ammessa e' un cancello che si impara a scavalcare.
#
# LA REGOLA, e non e' un'esenzione al buio: una RACCOLTA copia RISULTATI.
# Si declassa a RILIEVO solo se TUTTE e due:
#   1) gli unici comandi fuori dalla lista bianca stanno in SCRITTURA_RACCOLTA
#      (creare una cartella, copiare, zippare: niente cancellazioni, niente
#      esecuzioni, niente comandi nativi);
#   2) nel testo non compare NESSUN bersaglio delicato -- terminali, profili,
#      preset, sorgenti, binari, .ini. Una "raccolta" che nomina Experts\ o un
#      .set non sta raccogliendo: sta toccando il campo, e resta BLOCCANTE.
# Il cancello FALLISCE CHIUSO: se non riconosce la forma, blocca.
SCRITTURA_RACCOLTA = set(x.lower() for x in [
    "New-Item", "Copy-Item", "Compress-Archive", "Expand-Archive",
    "Out-Null", "Out-File", "Export-Csv", "Add-Content", "Set-Content",
])
BERSAGLI_DELICATI = [
    (r"MetaQuotes", "la cartella dati di MT5"),
    (r"Experts\\|Indicators\\|Profiles\\|Presets\\|config\\", "una cartella di codice o di configurazione di MT5"),
    (r"\.(set|ex5|mq5|mqh|chr|ini)\b", "un preset, un sorgente, un binario, un grafico o un .ini"),
    (r"Program Files", "la cartella dei programmi (li' stanno i terminali)"),
    (r"terminal64|metaeditor64", "un eseguibile di MetaTrader"),
]

# CLASSE 339 (15/09/2026) -- LA "RACCOLTA INNOCUA" NON GUARDAVA MAI IL CONTENUTO
# CHE UN Set-Content/Add-Content/Out-File/Export-Csv SCRIVE SU DISCO. senza_stringhe()
# toglie APPOSTA il testo fra apici dal controllo del CODICE (per non gridare al
# lupo sui log in italiano dentro un Write-Host) -- ma quello stesso testo tolto
# e' ESATTAMENTE il VALORE che uno di quei cmdlet scrive su un file, e nessuno lo
# controllava. Contro-esempio VERIFICATO DAL VIVO (CHECKLIST voce 339): un
#     Set-Content -Path "...\avvio.cmd" -Value '@echo off / start /min mshta.exe
#     "javascript:new ActiveXObject(1).Run(1)"'
# dentro un blocco di raccolta passava come RILIEVO 235, exit 0.
#
# Il fix: quando raccolta_innocua() ha gia' escluso i pattern pericolosi nel
# CODICE (sporche_pattern) e i cmdlet fuori whitelist (sporche_cmdlet), guarda
# ANCHE il contenuto di OGNI stringa del blocco -- con GLI STESSI pattern
# pericolosi gia' usati per il codice eseguibile (LETTURA_VIETATI: comandi
# nativi, New-Object, System.IO, chiamate a metodi che scrivono/eseguono; ODORE_PS:
# gli indicatori di download) PIU' le firme di lanciatore che il contro-esempio
# nomina alla lettera (mshta/wscript/cscript/rundll32/regsvr32 -- eseguibili
# Windows noti come LOLBin, non parole; javascript:/vbscript:/ActiveXObject --
# protocolli/oggetti COM, non parole; Invoke-Expression/iex/-EncodedCommand --
# comandi PowerShell, non parole).
#
# NON si riusa la lista ALIAS di LETTURA_VIETATI cosi' com'e' (rm, cp, mi, sp,
# si, ac, ii, rp, md, echo, start, ...): sono 2-3 lettere che collidono con
# parole italiane comuni nei referti che la raccolta stessa scrive ("si",
# "l'avvio", "l'accesso" ...). Verificato PRIMA di consegnare (contro-esempio
# inverso, regola del 10/09) sui 5 file di raccolta onesti del repo: nessuna
# delle loro stringhe contiene un comando nativo, un LOLBin, New-Object,
# System.IO, javascript:/vbscript:, ActiveXObject, Invoke-Expression/iex o un
# indicatore di download, quindi restano pulite con questi pattern.
CONTENUTO_PERICOLOSO = [
    (r"\b(taskkill|schtasks|net|reg|attrib|xcopy|robocopy|wmic|sc|mshta|wscript|cscript|rundll32|regsvr32|msiexec|certutil|bitsadmin)\b",
     "un comando nativo o un eseguibile Windows (LOLBin) noto per lanciare payload"),
    # "cmd" da solo prende anche il file ".cmd" che la RIGA STESSA sta creando come
    # PERCORSO (falso positivo misurato scrivendo il contro-esempio: la prima
    # stesura citava "$dest\avvio.cmd" come prova, non il payload vero). Qui si
    # vuole l'INVOCAZIONE dell'interprete, non l'estensione del file.
    (r"\bcmd(?:\.exe)?\s*(?:/c|/k)\b|\bcmd\.exe\b",
     "l'invocazione dell'interprete comandi cmd.exe"),
    (r"\.(Kill|Close|CloseMainWindow|Stop|Delete|Remove|Save|WriteAllText|WriteAllLines|AppendText|Create)\s*\(",
     "una chiamata a un METODO che modifica lo stato (es. .Kill())"),
    (r"\bNew-Object\b", "New-Object: puo' costruire un WebClient, un oggetto COM o uno scrittore di file"),
    (r"\[\s*System\.IO\.", "accesso diretto a System.IO"),
    (r"(?i)\b(javascript|vbscript):", "un protocollo di scripting (javascript:/vbscript:), tipico dei lanciatori HTA/mshta"),
    (r"(?i)ActiveXObject", "la creazione di un oggetto COM via ActiveXObject"),
    (r"(?i)\b(Invoke-Expression|iex)\b", "Invoke-Expression/iex: esegue del testo come codice"),
    (r"(?i)-Enc(odedCommand)?\b", "-EncodedCommand: codice PowerShell offuscato in base64"),
    (r"(?i)\b(irm|iwr|curl|wget|Invoke-RestMethod|Invoke-WebRequest|DownloadString|DownloadFile)\b",
     "un comando di download (ODORE_PS)"),
]

def contenuto_stringhe(testo):
    """I contenuti letterali fra apici singoli o doppi -- lo STESSO testo che
    senza_stringhe() toglie dal controllo del codice. Qui e' l'esatto contrario:
    e' l'unica cosa che conta, perche' e' quello che un Set-Content/Add-Content/
    Out-File/Export-Csv scrive davvero su disco. Stessa approssimazione
    dichiarata di senza_stringhe(): non gestisce l'escape con backtick.
    """
    return re.findall(r'"([^"]*)"', testo, re.S) + re.findall(r"'([^']*)'", testo, re.S)

def contenuto_scritto_pericoloso(crudo):
    """(True, motivo) se una delle STRINGHE del blocco contiene un pattern da
    codice eseguibile: il caso della CLASSE 339, un payload-lanciatore nascosto
    dentro il VALORE che un cmdlet di scrittura mette su disco."""
    for stringa in contenuto_stringhe(crudo):
        for pat, perche in CONTENUTO_PERICOLOSO:
            if re.search(pat, stringa):
                frammento = stringa.strip().replace("\n", " ")[:70]
                return True, ("il CONTENUTO scritto su disco contiene " + perche
                               + " (dentro una stringa: '" + frammento + "')")
    return False, ""

def raccolta_innocua(crudo, sporche_cmdlet, sporche_pattern):
    """(True, "") se questo blocco e' una raccolta di risultati e nient'altro.

    ATTENZIONE, ed e' costato un contro-esempio durante la scrittura: i bersagli
    delicati si cercano nel testo CRUDO, non in quello ripulito dalle stringhe.
    La prima stesura guardava il testo passato da senza_stringhe(), e un blocco
    che copiava da
        "$env:USERPROFILE\MetaQuotes\Terminal\ABC\MQL5\Experts"
    usciva "raccolta innocua", perche' il percorso sta FRA VIRGOLETTE e li' era
    gia' stato cancellato. E' la stessa forma delle classi 221 e 223: un percorso
    sta SEMPRE dentro una stringa, quindi un controllo sui percorsi che guarda il
    codice nudo non guarda niente.
    """
    if sporche_pattern:
        return False, "usa costrutti che non sono di sola raccolta"
    for c in sporche_cmdlet:
        if c.lower() not in SCRITTURA_RACCOLTA:
            return False, "il cmdlet '" + c + "' non e' fra quelli di una raccolta"
    for pat, che in BERSAGLI_DELICATI:
        if re.search(pat, crudo, re.I):
            return False, "nomina " + che + ": una raccolta copia risultati, non tocca il campo"
    # CLASSE 339: il cmdlet e' innocuo e il bersaglio e' innocuo, ma il
    # CONTENUTO che scrive su disco puo' non esserlo -- vedi sopra.
    pericoloso, motivo = contenuto_scritto_pericoloso(crudo)
    if pericoloso:
        return False, "CLASSE339: " + motivo
    return True, ""

def esegue_uno_script(riga):
    """True se la riga scarica codice o manda in esecuzione uno .ps1.
    Solo in quel caso il pin e il marcatore hanno un senso (e sono bloccanti)."""
    scarica = re.search(r"\b(irm|iwr|curl|wget|Invoke-RestMethod|Invoke-WebRequest)\b", riga, re.I)
    if scarica or "githubusercontent.com" in riga:
        return True
    if ".ps1" in riga.lower():
        return True
    if "& powershell" in riga or "powershell.exe" in riga.lower():
        return True
    return False

def controlla_riga_lancio(riga):
    # --- 0. classe 173: la riga esegue davvero uno script, o e' sola lettura locale?
    con_script = esegue_uno_script(riga)
    if not con_script:
        # confine di parola: senza, "Remove-Item" fa scattare anche "Move-Item"
        nudo = senza_stringhe(riga)
        sporche = []
        sporche_cmdlet, sporche_pattern = [], []
        for cmdlet in re.findall(r"(?<![A-Za-z0-9_.-])([A-Za-z]+-[A-Za-z]+)", nudo):
            if cmdlet.lower() not in LETTURA_AMMESSI:
                sporche.append("cmdlet '" + cmdlet + "' non e' nella lista bianca di sola lettura")
                sporche_cmdlet.append(cmdlet)
        for pat, perche in LETTURA_VIETATI:
            if re.search(pat, nudo, re.I):
                sporche.append(perche)
                sporche_pattern.append(perche)
        # CLASSE 175 (10/09/2026): la lista bianca fermava "& x.exe" ma NON un
        # eseguibile invocato PER PERCORSO senza '&' -- in PowerShell
        # "C:\python313\python.exe -c ..." parte lo stesso. Il cancello
        # stampava "riga di SOLA LETTURA" su una riga che ESEGUE codice: e' la
        # bugia, non l'esecuzione, il difetto. Se l'eseguibile e' un terminale
        # o sta in un percorso vietato e' BLOCCANTE; altrimenti si DICHIARA.
        esegui = re.findall(r"(?<![A-Za-z0-9_])([A-Za-z]:\\[^\"';|]*?\.(?:exe|bat|cmd|com|msi|msix|vbs|js|py|ps1))", nudo, re.I)
        esegui_ko = []
        for e in esegui:
            b = e.lower()
            if ("terminal64" in b) or ("metaeditor64" in b) or any(v.lower() in b for v in VIETATI_PERCORSO):
                esegui_ko.append(e)
                blocca("175", "la riga ESEGUE '" + e + "': e' un terminale MT5 o sta in un percorso vietato. Non si avvia un terminale da una riga senza pin")
            else:
                rileva("175", "la riga ESEGUE '" + e + "': NON e' una riga di sola lettura. Non e' vietato, ma va letto a mano cosa gli viene passato (qui il cancello non puo' dire altro)")
        # i costrutti pwsh-7 sulla RIGA: senza pin, la riga E' il codice che gira
        for pat, nome in PWSH7_ONLY:
            if re.search(pat, nudo):
                blocca("PWSH7", "la riga usa " + nome + ": sul VPS gira Windows PowerShell 5.1")
        # i percorsi vietati vanno cercati anche DENTRO le stringhe: in una riga
        # sola il percorso del REALE sta sempre fra virgolette
        # su UNA riga sola la GUARDIA generica e' troppo larga (basterebbe un
        # "Write-Host" per zittire il divieto): qui vale solo un RIFIUTO vero
        GUARDIA_RIGA = r"(Muori|throw|exit\s+1|VIETATO)"
        for v in VIETATI_PERCORSO:
            if v in riga and not re.search(GUARDIA_RIGA, riga, re.I):
                blocca("TERMINALE", "la riga nomina '" + v + "' (anche dentro una stringa) e non e' una guardia che lo rifiuta")
        if esegui_ko:
            pass          # gia' bloccata sopra: non si stampa nessun "passa"
        elif esegui and not sporche:
            passa("riga locale senza download: nessun cmdlet fuori dalla lista bianca (ma ESEGUE " + ", ".join(esegui) + ": vedi il rilievo 175)")
        elif sporche and raccolta_innocua(riga, sporche_cmdlet, sporche_pattern)[0]:
            # classe 235: e' la riga di raccolta, che la regola di casa IMPONE.
            rileva("235", "la riga SCRIVE (" + ", ".join(sorted(set(sporche_cmdlet)))
                   + ") ma e' una RACCOLTA di risultati: nessun terminale, nessun preset,"
                   + " nessun sorgente, nessuna cancellazione, nessun lanciatore nel CONTENUTO"
                   + " scritto (classe 339). Non e' pinnata perche' non scarica niente. Va"
                   + " comunque letto a mano DOVE copia")
        elif sporche:
            ok, motivo = raccolta_innocua(riga, sporche_cmdlet, sporche_pattern)
            if motivo.startswith("CLASSE339:"):
                # CLASSE 339: il cmdlet e IL bersaglio sono innocui (altrimenti si
                # sarebbe fermato sopra), ma il CONTENUTO che scrive su disco NO --
                # e questo, a differenza del RILIEVO 235, resta BLOCCANTE: il nome
                # del cmdlet non basta piu' a salvare la riga.
                blocca("339", "la riga SCRIVE (" + ", ".join(sorted(set(sporche_cmdlet)))
                       + ") con cmdlet e bersaglio innocui, ma " + motivo[len("CLASSE339:"):]
                       + " -- un payload dentro il contenuto di una 'raccolta' dichiarata"
                       + " NON si declassa a rilievo")
            else:
                blocca("173", "[" + motivo
                       + "] la riga non scarica nessuno script (quindi non e' appuntabile a un commit) MA non e' dimostrabilmente di SOLA LETTURA: " + "; ".join(sorted(set(sporche))) + ". Cosi' com'e' non e' ne' pinnata ne' innocua")
        else:
            # CLASSE 519 (21/09/2026) -- L'ASSEGNAZIONE A UNA PROPRIETA' PASSAVA LA
            # LISTA BIANCA E VENIVA CERTIFICATA "SOLA LETTURA".
            # La lista nera della 173 vieta i METODI ('.Kill(', '.Delete(',
            # '.WriteAllText') e i CMDLET fuori lista -- ma NON le assegnazioni a
            # proprieta'. Misurato eseguendo, il 21/09:
            #   $f = Get-Item "C:\MT5_Backtest\MQL5\Experts\X.ex5"; $f.IsReadOnly = $true
            # dava "PASSATI (3) ... riga di SOLA LETTURA locale", uscita 0.
            # Quella riga SCRIVE: cambia un file. E' la classe 175 che ritorna --
            # un cancello non certifica mai piu' di quello che ha guardato.
            #
            # Perche' RILIEVO e non BLOCCO: la scrittura piu' utile di questa
            # famiglia ($x.PriorityClass='Idle' per liberare CPU) e' REVERSIBILE e
            # non tocca nessun conto. Bloccarla insegnerebbe a scavalcare il
            # cancello (lezione della classe 235). Ma la frase "SOLA LETTURA" non
            # si stampa piu', e la proprieta' toccata si NOMINA.
            prop = re.findall(r"\$(?:[A-Za-z_][A-Za-z0-9_]*|_)(?:\.[A-Za-z_][A-Za-z0-9_]*)*\.([A-Za-z_][A-Za-z0-9_]*)\s*=(?!=)", nudo)
            if prop:
                rileva("519", "la riga NON e' di sola lettura: assegna a una PROPRIETA' ("
                       + ", ".join(sorted(set(prop))) + "), cioe' SCRIVE lo stato di un"
                       + " oggetto vivo. La lista bianca della 173 guarda i metodi e i"
                       + " cmdlet, non le assegnazioni: qui il verde e' MECCANICO, non"
                       + " innocuo. Va letta a mano, e va detto se e' REVERSIBILE")
                passa("riga locale senza download: nessun cmdlet fuori dalla lista bianca"
                      + " e nessuno script eseguito -> pin e marcatore non si applicano"
                      + " (classe 173). NON la chiamo di sola lettura: vedi il rilievo 519")
            else:
                passa("riga di SOLA LETTURA locale (lista bianca): nessuno script scaricato o eseguito, nessun cmdlet fuori dalla lista bianca, nessun operatore di chiamata -> pin e marcatore non si applicano (classe 173)")

    # --- 1. il PIN deve essere un COMMIT (classe 164): 40 esadecimali
    # CLASSE 217 (10/09/2026): questi due regex erano CASE SENSITIVE su $PIN,
    # ma in PowerShell le variabili NON lo sono e tutte le 388 occorrenze del
    # progetto scrivono '$pin=' minuscolo. Risultato misurato sulla prima riga
    # vera passata dal cancello (R125): il pin non veniva MAI trovato, usciva
    # il bloccante generico "nessun pin trovato" e le classi 164 (il pin e' un
    # commit?) e 187 (il pin contiene davvero quel marcatore?) NON venivano MAI
    # eseguite. Un cancello che blocca per il motivo sbagliato nasconde i due
    # controlli che contano. Ora il confronto e' insensibile al maiuscolo.
    pins = re.findall(r"githubusercontent\.com/[^/]+/[^/]+/([A-Za-z0-9_.-]+)/", riga)
    pins += re.findall(r"\$PIN\s*=\s*'([^']+)'", riga, re.I)
    pins += re.findall(r"\$PIN\s*=\s*\"([^\"]+)\"", riga, re.I)
    visti = set(p for p in pins if not p.startswith("$"))
    if not visti and con_script:
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
        # CLASSE 187 (10/09/2026): fin qui il cancello verificava che il pin fosse
        # UN commit, non IL commit. Con marcatore v4 e pin della v2 la riga muore
        # sul VPS con "SCRIPT VECCHIO" -- fallisce chiuso, quindi non e' pericolosa,
        # ma butta un giro di Claudio. Qui il pin e il marcatore si incrociano
        # PRIMA di partire: il file al pin deve contenere davvero quel marcatore.
        marcatori = re.findall(r"-Pattern\s+'([A-Za-z0-9_]*MARCATORE[A-Za-z0-9_]*)'", riga)
        # nell URL il pin di solito e' la VARIABILE $PIN, non l'esadecimale:
        # si accettano tutti e due, altrimenti questo controllo non trova mai niente.
        percorsi  = re.findall(r"githubusercontent\.com/[^/]+/[^/]+/(?:\$\w+|[0-9a-fA-F]{40})/([A-Za-z0-9_./-]+)", riga)
        for pin in [x for x in visti if re.fullmatch(r"[0-9a-f]{40}", x)]:
            for perc in percorsi:
                try:
                    t = subprocess.run(["git", "show", pin + ":" + perc],
                                       capture_output=True, text=True, timeout=30)
                except Exception as e:
                    rileva("187", "non ho potuto leggere " + perc + " al pin: " + str(e))
                    continue
                if t.returncode != 0:
                    blocca("187", "il file '" + perc + "' NON esiste al pin " + pin[:8]
                           + ": la riga scarichera' un 404")
                    continue
                for m in marcatori:
                    if m in t.stdout:
                        passa("il marcatore " + m + " c'e' davvero in " + perc + " al pin " + pin[:8])
                    else:
                        blocca("187", "il pin " + pin[:8] + " NON contiene il marcatore '" + m
                               + "' cercato in '" + perc + "': la riga morira' con SCRIPT VECCHIO"
                               + " (pin e marcatore appartengono a due versioni diverse)")
    elif not con_script:
        pass          # classe 173: niente script scaricato, niente marcatore da controllare
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

    # --- 5. il terminale bersaglio: LA COPPIA MACCHINA + PERCORSO (classe 536)
    #     Prima di oggi qui c'era una costante sola, TERMINALE_BUONO, cioe' il
    #     banco del VPS: tutto il resto era "verificare a mano". Con la firma
    #     del 21/09 i round girano sul PC di backtest, dove il terminale ha lo
    #     STESSO percorso del piccolo 50503392: una costante non basta piu',
    #     serve la tabella -- ed e' la stessa dei tre .ps1.
    mac, nota_mac = macchina_dichiarata(riga)
    if mac == "?":
        blocca("536", "DICHIARAZIONI DI MACCHINA DISCORDI: " + nota_mac
               + ". Una riga gira su UNA macchina: due guardie che nominano due nomi"
                 " diversi vogliono dire che almeno una e' sbagliata, e il cancello"
                 " non sceglie al posto di chi scrive")
        mac = ""
    if mac:
        rm = riga_macchina(mac)
        if rm is None:
            blocca("536", "la riga si inchioda alla macchina '" + mac + "', che NON e' nella"
                   " tabella dei bersagli. Ammesse: " + elenco_macchine_ammesse()
                   + ". FAIL-CLOSED: una macchina che il cancello non conosce non ha nessun"
                     " terminale ammesso. Se il round deve girare davvero li', si AGGIUNGE la"
                     " riga alla tabella -- a mano, nei tre .ps1 E qui -- e si ripassa dal cancello")
            mac = ""
        else:
            passa("macchina DICHIARATA e inchiodata dalla riga: " + mac + " -> unico bersaglio"
                  " ammesso qui " + rm["perc"] + " (conto " + rm["conto"] + ", " + rm["comequi"] + ")")
    valori = [v for f, v in valori_bersaglio(riga) if f.lower().startswith("terminal")]
    for val in valori:
        if mac:
            if motivo_rifiuto_bersaglio(val, mac) == "":
                passa("bersaglio AMMESSO sulla macchina dichiarata " + mac + ": '" + val + "'")
        elif normalizza_percorso_win(val).lower() == TERMINALE_BUONO.lower():
            passa("bersaglio dichiarato: " + TERMINALE_BUONO)
        else:
            rileva("TERMINALE", "la riga passa il terminale '" + val + "', che non e' "
                   + TERMINALE_BUONO + ", e non dichiara nessuna macchina: verificare a mano"
                   + " che non sia un conto in forward")
    if not valori:
        # CLASSE 671 (23/09/2026): NON si deduce un bersaglio da una
        # SOTTOSTRINGA cercata in tutto il testo. Il contro-esempio misurato:
        # una riga che scriveva "NON tocca e NON legge i dati di: 50504400
        # (C:\\MT5_Backtest)" -- cioe' una menzione di ESCLUSIONE, per giunta
        # OBBLIGATORIA dalla regola del 12/09 -- usciva fra i PASSATI come
        # "bersaglio dichiarato". Il cancello premiava chi rispettava la regola
        # trasformando il suo elenco di esclusioni in una dichiarazione di
        # bersaglio. Ora si pretende che il percorso compaia come VALORE.
        if re.search(r"(-Terminal\w*|-Percorso\w*|\$\w*(BERS|TERM|TARGET)\w*\s*=)\s*['\"]?"
                     + re.escape(TERMINALE_BUONO), riga, re.I):
            passa("bersaglio dichiarato come VALORE: " + TERMINALE_BUONO)
        elif TERMINALE_BUONO.lower() in riga.lower():
            rileva("671", "il testo NOMINA '" + TERMINALE_BUONO + "' ma non come valore di un"
                   " flag o di un'assegnazione: potrebbe essere una menzione di ESCLUSIONE."
                   " NON lo conto come bersaglio dichiarato: va letto a mano")
        elif "-Terminal" in riga:
            rileva("TERMINALE", "la riga nomina un -Terminal... di cui non riesco a leggere il"
                   " valore: va letto a mano")
    elif not mac:
        rileva("536", "la riga passa un BERSAGLIO ma non dichiara su che MACCHINA deve girare ("
               + nota_mac + "). E' la forma di tutte le righe scritte fino al 21/09 e non e' un"
               + " difetto di per se'; ma senza quella guardia la riga, incollata nella finestra"
               + " sbagliata, parte lo stesso -- e il cancello non puo' concedere nessuna deroga"
               + " per macchina. Per i round sul PC di backtest la guardia e' OBBLIGATORIA")
    controlla_terminali("<riga>", riga, "<riga di lancio>", stretta=True, macchina=mac)

    # --- 6. la raccolta
    if "Compress-Archive" in riga or "zip" in riga.lower() or "-File" in riga:
        passa("la riga prevede una raccolta o punta a uno script che ce l'ha")
    elif not con_script:
        pass          # classe 173: una riga che stampa e basta non produce file da raccogliere
    else:
        rileva("RACCOLTA", "non vedo la raccolta: ogni risultato deve arrivare anche sul Desktop del VPS (regola 11/08)")

    # --- 7. ora server
    if re.search(r"(InpSessionHour|InpIbInizioOra|SessionHour)\s*[= ]\s*(9|15)\b", riga):
        blocca("FUSO", "ora ITALIANA al posto dell'ora SERVER: server BCM = italiana - 1. DAX = 8 (non 9), Nasdaq = 14 (non 15)")

# =====================================================================
# CLASSE 225 (11/09/2026) -- IL CANCELLO ADESSO SA CHE OGGETTO STA GUARDANDO.
# Prima c'erano due modi soli (--riga, --ps1) e tre oggetti veri. Costo misurato:
#   - "--ps1 <file prova .txt>" usciva FAIL con "[PWSH7] operatore doppia pipe":
#     falso positivo al 100%, perche' nei file prova "||" e' il separatore
#     dell'asse della griglia, non l'operatore di pwsh 7;
#   - sui .md non c'era nessun modo, e un percorso posizionale moriva con
#     "unrecognized arguments";
#   - "--riga <documento .md>" bocciava la PROSA: RIGA_R125_DA_MANDARE.md usciva
#     FAIL perche' il testo dice "non tocca il conto reale 10105439" -- cioe' la
#     frase che PROMETTE di non toccarlo. I tre blocchi PowerShell dentro,
#     estratti, non avevano nessun difetto meccanico. Un round firmato da Claudio
#     e' rimasto fermo per questo.
# Un FAIL plausibile su un oggetto sano insegna a ignorare il cancello, che e' il
# modo piu' rapido per spegnere una rete di sicurezza senza toccarla.
# =====================================================================

# linguaggi di blocco che NON sono PowerShell: li' dentro non si cerca codice
LINGUAGGI_NON_PS = set([
    "text", "txt", "csv", "ini", "json", "yaml", "yml", "xml", "md", "diff",
    "mql5", "mq5", "cpp", "c", "python", "py", "bash", "sh", "sql", "log",
    "console", "output", "tabella",
])
LINGUAGGI_PS = set(["powershell", "ps", "ps1", "pwsh", "posh"])
# come si riconosce un blocco SENZA linguaggio dichiarato: se odora di PowerShell
# lo si controlla lo stesso. Meglio un controllo in piu' su un blocco di testo che
# un blocco di comandi non guardato perche' mancava l'etichetta.
ODORE_PS = re.compile(r"(\birm\b|\biwr\b|Invoke-RestMethod|& powershell|powershell\.exe|"
                      r"Write-Host|Get-ChildItem|Compress-Archive|\$env:|\$pin|-Terminal|"
                      r"Select-String|New-Item|Copy-Item|\bexit\b)", re.I)

def blocchi_md(testo):
    """(numero_riga_apertura, linguaggio, contenuto) di ogni blocco ``` del .md."""
    fuori = []
    dentro = False
    ling, inizio, buf = "", 0, []
    for i, riga in enumerate(testo.splitlines(), 1):
        m = re.match(r"^[ \t]*```([A-Za-z0-9_+-]*)[ \t]*$", riga)
        if m and not dentro:
            dentro, ling, inizio, buf = True, m.group(1).lower(), i, []
            continue
        if dentro and re.match(r"^[ \t]*```[ \t]*$", riga):
            fuori.append((inizio, ling, "\n".join(buf)))
            dentro = False
            continue
        if dentro:
            buf.append(riga)
    if dentro:                       # recinto aperto e mai chiuso: si dichiara
        fuori.append((inizio, ling, "\n".join(buf)))
    return fuori

def prosa_di(testo, blocchi):
    """Le righe del .md che NON stanno dentro un blocco ```."""
    dentro = set()
    for inizio, _l, cont in blocchi:
        n = len(cont.splitlines())
        for k in range(inizio, inizio + n + 2):
            dentro.add(k)
    return [(i, r) for i, r in enumerate(testo.splitlines(), 1) if i not in dentro]

def controlla_prosa(path, testo, blocchi, macchina=""):
    """LA PARTE DELICATA. Spegnere i controlli sulla prosa NON deve riaprire il
    buco della classe 223 (una riga puntata sul conto reale che esce pulita).

    Quindi la prosa non e' ignorata, e' trattata per quello che e':
      - un percorso vietato passato come VALORE di -Terminal.../-Percorso...
        BLOCCA anche se sta nella prosa. La regola della 221 non dipende dal
        recinto: un bersaglio vietato non e' mai innocente, ovunque sia scritto.
      - una riga di prosa che ha la FORMA di un comando (irm, & powershell,
        terminal64.exe) e nomina un percorso vietato BLOCCA: fuori dai recinti
        si scrive in italiano, non si scrivono comandi.
      - la semplice MENZIONE ("il driver muore se punta a C:\BCM_Reale") e' un
        RILIEVO, non un errore: e' la frase che PROMETTE di non toccarlo.
    """
    prosa = prosa_di(testo, blocchi)
    menzioni, comandi = [], 0
    for i, r in prosa:
        for val, motivo in bersagli_vietati(r, macchina):
            blocca("221", "r." + str(i) + " (PROSA): BERSAGLIO RIFIUTATO"
                   " (-Terminal.../-Percorso... = '" + val + "'). " + motivo
                   + " Fuori da un blocco o dentro, un bersaglio vietato non e' mai innocente", path)
        pare_comando = re.search(r"(\birm\b|& powershell|powershell\.exe|terminal64\.exe|"
                                 r"Invoke-RestMethod|Start-Process)", r, re.I)
        nominati = [v for v in VIETATI_PERCORSO if v in r] + [c for c in CONTI_VIETATI if c in r]
        if pare_comando and nominati:
            comandi += 1
            blocca("225", "r." + str(i) + " (PROSA): riga con la FORMA di un COMANDO che nomina "
                   + ", ".join(nominati) + " e sta FUORI da un blocco ```. Un comando fuori dal"
                   + " recinto non e' controllabile e non deve esistere: o entra in un blocco"
                   + " powershell, o si riscrive in italiano", path)
        elif nominati:
            menzioni.append(str(i) + ":" + "/".join(nominati))
    if menzioni:
        rileva("225", "la PROSA nomina terminali o conti vietati in " + str(len(menzioni))
               + " righe (" + ", ".join(menzioni[:8]) + "): NON e' un difetto -- in un documento"
               + " che spiega cosa non si tocca queste frasi ci DEVONO essere -- ma vanno"
               + " rilette a occhio, perche' qui il cancello non giudica", path)
    if not menzioni and not comandi:
        passa("la prosa non nomina nessun terminale o conto vietato: " + os.path.basename(path))

def controlla_md(path, testo):
    global CONTESTO
    blocchi = blocchi_md(testo)
    if not blocchi:
        rileva("225", "nessun blocco ``` in questo .md: non c'e' niente da controllare"
               + " meccanicamente. Se il documento contiene comandi, vanno messi in un"
               + " blocco ```powershell, altrimenti nessun cancello li vedra' mai", path)
    controllati, saltati = 0, []
    mac_doc = ""
    for inizio, ling, cont in blocchi:
        if not cont.strip():
            continue
        e_ps = (ling in LINGUAGGI_PS) or (ling == "" and bool(ODORE_PS.search(cont)))
        if e_ps:
            # la macchina del DOCUMENTO si legge solo dai blocchi eseguibili:
            # una frase in italiano non inchioda niente a nessuna macchina.
            mm, _nota = macchina_dichiarata(cont)
            if mm and mm != "?":
                mac_doc = mm
        if not e_ps:
            saltati.append("r." + str(inizio) + " (```" + (ling or "senza linguaggio") + ")")
            continue
        controllati += 1
        CONTESTO = "[blocco r." + str(inizio) + "]"
        try:
            riga = cont.strip()
            try:
                riga.encode("ascii")
            except UnicodeEncodeError:
                blocca("ASCII", "il blocco contiene caratteri non-ASCII (emoji?):"
                       " incollato in PowerShell 5.1 puo' rompersi")
            controlla_riga_lancio(riga)
        finally:
            CONTESTO = ""
    passa("blocchi ``` trovati: " + str(len(blocchi)) + ", controllati come riga di lancio: "
          + str(controllati) + ("; NON controllati: " + ", ".join(saltati) if saltati else "")
          + "  [" + os.path.basename(path) + "]")
    controlla_prosa(path, testo, blocchi, mac_doc)

def controlla_file_prova(path, dati, testo):
    """Un file prova NON e' PowerShell: e' il formato di casa
       InpTal=1.0||1.0||0||1.0||N
    I controlli PWSH7 / cultura / formati .NET qui non hanno senso, e il '||'
    dell'asse li fa gridare al lupo. Restano quelli che un file prova PUO'
    davvero sbagliare: byte non-ASCII, ora italiana al posto dell'ora server,
    e il nome di un terminale che qui non ci deve stare proprio.
    """
    try:
        dati.decode("ascii")
        passa("file prova ASCII puro: " + os.path.basename(path))
    except UnicodeDecodeError:
        blocca("ASCII", "il file prova contiene byte non-ASCII: lo legge PowerShell 5.1"
               " (ANSI) e finisce dentro un .ini del tester", path)
    # ora SERVER, non italiana (regola fissa di CLAUDE.md: server = italiana - 1)
    # Due livelli, e la differenza e' voluta:
    #  - i due nomi NOTI (InpSessionHour, InpIbInizioOra) con 9 o 15 sono il
    #    difetto gia' pagato: BLOCCANTE, come nel controllo della riga.
    #  - gli ALTRI nomi di ora d'INIZIO (RangeStart, Inizio, Start) con 9 o 15
    #    sono un RILIEVO e non un errore: ogni EA chiama i suoi input come vuole
    #    e un 15 puo' essere legittimo. Quello che NON puo' essere legittimo e'
    #    non essersene accorti. (Un'ora di CHIUSURA a 15 o a 21 non si tocca:
    #    li' il 15 e' un orario di fine, non l'apertura sbagliata di un cash.)
    for i, r in enumerate(testo.splitlines(), 1):
        m = re.match(r"\s*(InpSessionHour|InpIbInizioOra)\s*=\s*(\d+)", r)
        if m and m.group(2) in ("9", "15"):
            blocca("FUSO", "r." + str(i) + ": " + m.group(1) + "=" + m.group(2)
                   + " e' ora ITALIANA. Il server BCM e' un'ora indietro: DAX 8, Nasdaq 14", path)
            continue
        m = re.match(r"\s*(Inp\w*(?:RangeStart|Inizio|Start)\w*Hour)\s*=\s*(\d+)", r, re.I)
        if m and m.group(2) in ("9", "15"):
            rileva("FUSO", "r." + str(i) + ": " + m.group(1) + "=" + m.group(2)
                   + " e' un'ora d'INIZIO che vale 9 o 15, cioe' l'ora ITALIANA di apertura"
                   + " di DAX e Nasdaq. In ora SERVER sarebbero 8 e 14. Va confermato a mano:"
                   + " il cancello non sa come si chiamano gli input di questo EA", path)
    # CLASSE 439 (19/09/2026) -- IL COMMENTO DI UN FILE PROVA COMINCIA CON ';',
    # NON CON '#', E righe_utili() SA SOLO IL '#'.
    # Contro-esempio misurato su `sedia_NASDAQ_BREAKOUT_VOLUMI_770261.set`:
    # l'intestazione portava la riga che CLAUDE.md (emendamento 12/09) rende
    # OBBLIGATORIA -- "NON su -V3 (50504263), NON su C:\\BCM_Reale (10105439)" --
    # e il cancello la leggeva come testo vivo: 4 BLOCCANTI [TERMINALE]/[CONTO]
    # su una riga che e' un COMMENTO INERTE (MT5 legge solo le `chiave=valore`).
    # Il cancello puniva la regola di casa: chi dichiarava i terminali da NON
    # toccare veniva bocciato, chi taceva passava. Esattamente al contrario.
    # Stessa famiglia della classe 167 (senza_stringhe): il difetto non era la
    # severita', era il LESSICO del formato. La correzione e' NARROW APPOSTA --
    # vale solo per l'oggetto `prova` e solo per le righe il cui primo
    # carattere non bianco e' ';'. Nei .ps1 il ';' NON si tocca: li' e'
    # separatore di istruzioni, e spogliarlo aprirebbe un buco vero.
    righe_pulite = []
    n_commenti = 0
    for r in testo.splitlines():
        if r.lstrip().startswith(";"):
            righe_pulite.append("")      # riga svuotata: i numeri di riga restano
            n_commenti += 1
        else:
            righe_pulite.append(r)
    if n_commenti:
        passa("file prova: " + str(n_commenti) + " righe di COMMENTO (';') escluse dal"
              " controllo terminali/conti -- sono inerti per MT5 e l'intestazione DEVE"
              " nominare i bersagli vietati (CLAUDE.md 12/09). Classe 439")
    controlla_terminali(path, "\n".join(righe_pulite), path)
    rileva("225", "controlli PowerShell (PWSH7, cultura, formati .NET) SPENTI su questo"
           " oggetto: un file prova non e' uno script. Il cancello SEMANTICO dei file prova"
           " e' un altro programma, e va lanciato a parte:"
           " python3 backtest_pipeline/controlla_prova.py " + path, path)

def tipo_dedotto(path):
    """Che oggetto e'? Si DEDUCE solo quando e' inequivocabile, altrimenti si CHIEDE.
    Indovinare il tipo e' esattamente il difetto della classe 225."""
    b = path.lower()
    if b.endswith(".ps1"):
        return "ps1"
    if b.endswith(".md"):
        return "md"
    if "/prove/" in b.replace("\\", "/") or "\\prove\\" in b:
        return "prova"
    return None

def esamina(tipo, percorso):
    """Un oggetto, un tipo dichiarato, i controlli che a quel tipo si applicano."""
    if not os.path.exists(percorso):
        blocca("FILE", "file non trovato: " + percorso)
        return
    dati  = leggi(percorso)
    testo = dati.decode("utf-8", errors="replace")

    if tipo == "riga":
        riga = testo.strip()
        try:
            riga.encode("ascii")
            passa("la riga di lancio e' ASCII puro")
        except UnicodeEncodeError:
            blocca("ASCII", "la riga di lancio contiene caratteri non-ASCII (emoji?): incollata in PowerShell 5.1 puo' rompersi")
        controlla_riga_lancio(riga)
    elif tipo == "ps1":
        controlla_ascii(percorso, dati)
        controlla_parser(percorso)
        controlla_param_block(percorso)
        controlla_pwsh7(percorso, testo)
        controlla_formati_net(percorso, testo)
        controlla_cultura(percorso, testo)
        controlla_terminali(percorso, testo, percorso)
    elif tipo == "prova":
        controlla_file_prova(percorso, dati, testo)
    elif tipo == "md":
        controlla_md(percorso, testo)

def main():
    ap = argparse.ArgumentParser(
        description="Il cancello deterministico. DIMMI CHE OGGETTO E': "
                    "--oggetto riga|ps1|prova|md (classe 225).")
    ap.add_argument("file", nargs="*", help="file da controllare (con --oggetto, o con un'estensione che parla da sola)")
    ap.add_argument("--oggetto", choices=["riga", "ps1", "prova", "md"],
                    help="che cosa sono i file passati. Senza, si deduce da .ps1/.md/prove/ e si DICHIARA")
    ap.add_argument("--riga", help="file di testo con la riga di lancio")
    ap.add_argument("--ps1", action="append", default=[], help="script .ps1 da controllare (ripetibile)")
    ap.add_argument("--prova", action="append", default=[], help="file prova (formato di casa, NON PowerShell)")
    ap.add_argument("--md", action="append", default=[], help="documento .md: si controllano i BLOCCHI ``` dentro")
    a = ap.parse_args()

    lavoro = []
    if a.riga:  lavoro.append(("riga", a.riga))
    for x in a.ps1:   lavoro.append(("ps1", x))
    for x in a.prova: lavoro.append(("prova", x))
    for x in a.md:    lavoro.append(("md", x))
    for x in a.file:
        t = a.oggetto or tipo_dedotto(x)
        if t is None:
            print("NON SO CHE OGGETTO E': " + x)
            print("  un .txt puo' essere una riga di lancio O un file prova, e i controlli")
            print("  sono diversi. Dimmelo: --oggetto riga|ps1|prova|md " + x)
            return 2
        if not a.oggetto:
            print("[dedotto] " + x + " -> oggetto '" + t + "' (dall'estensione/percorso)")
        lavoro.append((t, x))
    # --oggetto vale anche sui file passati con i modi espliciti: se qualcuno
    # scrive "--ps1 file_prova.txt --oggetto prova", comanda l'oggetto.
    if a.oggetto:
        lavoro = [(a.oggetto, q) for _t, q in lavoro]

    if not lavoro:
        print("niente da controllare.")
        print("  python3 controlla_riga.py --riga RIGA.txt")
        print("  python3 controlla_riga.py --ps1 script.ps1")
        print("  python3 controlla_riga.py --oggetto md backtest_pipeline/righe/RIGA_X_DA_MANDARE.md")
        print("  python3 controlla_riga.py --oggetto prova backtest_pipeline/prove/R125a.txt")
        return 2

    for tipo, percorso in lavoro:
        esamina(tipo, percorso)

    print("=" * 70)
    print("  CONTROLLO PREVENTIVO -- cancello deterministico")
    print("  OGGETTI ESAMINATI: " + ", ".join(t + " -> " + q for t, q in lavoro))
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
