#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
controesempi_cancello.py -- I CONTRO-ESEMPI DEL CANCELLO, TENUTI E RIGIRABILI.

Perche' esiste (11/09/2026). La checklist, alla classe 223, chiude cosi':
    "Contro-esempi da tenere: 4 bersagli (3 vietati + 1 buono) + 1 guardia
     legittima. Regressione: 237 .ps1, 0 falliti."
Erano da TENERE, e non erano tenuti da nessuna parte: vivevano nel messaggio
di chat di quella notte. Un contro-esempio che non si puo' rigirare non e' una
rete di sicurezza, e' un ricordo -- e la prima modifica al cancello lo perde.

Qui dentro ci sono, scritti, e si rigirano con un comando:
    python3 backtest_pipeline/controesempi_cancello.py

La regola che questi casi difendono, e che NON deve mai piu' aprirsi:
  * un terminale VIETATO passato come bersaglio BLOCCA (classi 221 e 223);
  * il banco C:\\MT5_Backtest PASSA;
  * una GUARDIA legittima (che nomina il percorso per RIFIUTARLO) PASSA;
  * e da oggi (classe 225): estrarre i blocchi da un .md per non bocciare la
    PROSA non deve far passare un blocco PERICOLOSO.

USCITA: 0 = tutti i contro-esempi si comportano come devono. 1 = almeno uno no,
e allora il cancello ha un buco NUOVO: non si commetta niente finche' non torna
verde.
"""
import os, subprocess, sys, tempfile

QUI      = os.path.dirname(os.path.abspath(__file__))
CANCELLO = os.path.join(QUI, "controlla_riga.py")
REPO     = os.path.dirname(QUI)

# La riga di lancio VERA di casa, ridotta all'osso: porta il pin, il marcatore
# (quindi il 'throw' legittimo che nel 2026-09-11 zittiva il divieto) e un
# bersaglio che si cambia. E' la forma che ha scoperto la classe 223.
PIN = "65ef4e096935fa4fc8694d1877e45113cce8fc1d"
# Il pin delle righe della classe 535: e' il commit in cui e' nato
# MARCATORE_RIGA_ROUND_VPS_v2 (la guardia PER MACCHINA). Serve un pin
# DIVERSO perche' il controllo 187 incrocia pin e marcatore, e al pin
# vecchio qui sopra il marcatore v2 non esiste ancora -- e' proprio il
# difetto che la 187 deve prendere.
PIN_V2 = "e724624bf0c8315f57db200fb93e1f76009bdc97"
def riga_con_bersaglio(bersaglio):
    return ("& { $ErrorActionPreference='Stop'; $pin='" + PIN + "'; "
            "$p=\"$env:USERPROFILE\\RIGA_ROUND_VPS.ps1\"; "
            "irm \"https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/"
            "backtest_pipeline/righe/RIGA_ROUND_VPS.ps1\" -OutFile $p -EA Stop; "
            "if(-not (Select-String -Path $p -SimpleMatch -Pattern "
            "'MARCATORE_RIGA_ROUND_VPS_v1' -Quiet)){ throw 'SCRIPT VECCHIO' }; "
            "& $p -Expert ABTG_ORB_Ottimizzato -Prova 'R125a_costo_buffer_U30USD.txt' "
            "-Etichetta x -Pin $pin -Deposito 100000 -Modello 4 "
            "-TerminaleBacktest '" + bersaglio + "' -SoloControllo }")

# la guardia LEGITTIMA: nomina i percorsi per RIFIUTARLI, non li passa come
# bersaglio. Deve passare, altrimenti il cancello boccia i file scritti bene.
GUARDIA_LEGITTIMA = """param([string]$TerminaleBacktest = "C:\\MT5_Backtest")
function Muori($m){ Write-Host $m; exit 1 }
if($TerminaleBacktest -like "*-V3*"){          Muori "VIETATO: e' il 100k 50504263" }
if($TerminaleBacktest -like "*BCM_Reale*"){    Muori "VIETATO: e' il REALE 10105439" }
if($TerminaleBacktest -eq "C:\\Program Files\\BCM Markets MT5 Terminal"){ Muori "VIETATO: e' il piccolo" }
Write-Host ("banco: " + $TerminaleBacktest)
exit 0
"""

MD_PROSA_INNOCUA_BLOCCO_CATTIVO = """# Riga di prova innocua

Questa riga fa solo un controllo di lettura sul banco di backtest.
Non tocca niente di vivo e la prosa non nomina nessun conto.

```powershell
""" + riga_con_bersaglio("C:\\BCM_Reale") + """
```

Fine. Si manda lo zip dal Desktop.
"""

MD_BLOCCO_SENZA_LINGUAGGIO = """# Documento con un recinto senza etichetta

La prosa e' innocua. Il blocco qui sotto non dichiara il linguaggio: se il
cancello guardasse solo i blocchi marcati ```powershell, non lo vedrebbe.

```
""" + riga_con_bersaglio("C:\\Program Files\\BCM Markets MT5 Terminal -V3") + """
```
"""

MD_COMANDO_NELLA_PROSA = """# Documento senza recinti

La prosa e' innocua, dice solo di lanciare questa cosa a mano:
& powershell -File C:\\BCM_Reale\\avvia.ps1 -Terminale 'C:\\BCM_Reale'

e poi mandare lo zip.
"""

# CLASSE 339 (15/09/2026): un payload-lanciatore dentro il CONTENUTO scritto da
# Set-Content -Value, all'interno di un blocco di RACCOLTA altrimenti innocuo
# (cmdlet in SCRITTURA_RACCOLTA, nessun bersaglio delicato). E' il contro-esempio
# ESEGUITO E VERIFICATO nella CHECKLIST voce 339: prima del fix usciva RILIEVO 235,
# exit 0 -- non coperto da nessuno dei casi sopra, che testano tutti il BERSAGLIO,
# mai il CONTENUTO scritto.
PAYLOAD_RACCOLTA_339 = """& {
$dest = "$env:USERPROFILE\\Desktop\\raccolta_ok"
New-Item -ItemType Directory -Force $dest | Out-Null
Set-Content -Path "$dest\\avvio.cmd" -Value '@echo off
start /min mshta.exe "javascript:new ActiveXObject(1).Run(1)"'
Compress-Archive -Path $dest -DestinationPath "$dest.zip" -Force
}
"""

MD_BUONO = """# Documento sano

Il banco e' `C:\\MT5_Backtest`, il demo di solo tester. Il driver muore da solo
se punta al 100k 50504263 (`... -V3`) o al REALE 10105439 (`C:\\BCM_Reale`):
sono nominati qui per dire che NON si toccano.

```powershell
""" + riga_con_bersaglio("C:\\MT5_Backtest") + """
```
"""


# =====================================================================
#  CLASSI 535 e 536 (21/09/2026) -- LA COPPIA MACCHINA + PERCORSO.
#
#  Il 21/09 Claudio ha firmato che i round girano sul PC DI BACKTEST
#  finche' una challenge e' viva. Sul PC di backtest l'unico MT5 sta in
#  "C:\Program Files\BCM Markets MT5 Terminal", che sul VPS e' il PICCOLO
#  50503392 con le sedie vive: lo STESSO TESTO deve essere ammesso di qua
#  e vietato di la'. Gli .ps1 l'hanno imparato (GUARDIA_BANCO_POSITIVA_v2,
#  banco: backtest_pipeline\banco_guardia_macchina.ps1, 117 prove); il
#  cancello no, e bloccava la riga CORRETTA.
#
#  Qui sotto i contro-esempi del CANCELLO, non della guardia .ps1: la
#  domanda e' diversa, perche' il cancello non gira su una macchina, legge
#  un TESTO. Quindi la macchina e' quella che la riga DICHIARA, e la
#  dichiarazione vale solo se la riga si RIFIUTA DI GIRARE ALTROVE.
#
#  E il caso che ha aperto la classe 536, misurato ESEGUENDO:
#  '-TerminaleBacktest','C:\BCM_Reale' dentro l'array di -ArgumentList --
#  cioe' LA FORMA DI CASA -- usciva "nessun difetto meccanico", uscita 0.
# =====================================================================
def riga_round(bersaglio, macchina=None, array=False, verso="-ne", rifiuta=True):
    """La riga di round di casa, con le due leve che contano:
       - macchina: la guardia $env:COMPUTERNAME in testa (None = nessuna);
       - array   : il bersaglio passato come elemento di -ArgumentList
                   (la forma VERA delle righe di round) invece che con lo
                   spazio. E' la sintassi che il cancello non vedeva.
       - verso/rifiuta: per provare le guardie FINTE (verso sbagliato, o
                   guardia che stampa e non rifiuta)."""
    testa = ""
    if macchina is not None:
        coda = "throw 'VIETATO: questa riga gira SOLO su " + macchina + "'" if rifiuta \
               else "Write-Host 'macchina diversa, ma vado avanti lo stesso'"
        testa = ("if($env:COMPUTERNAME " + verso + " '" + macchina + "'){ " + coda + " }; ")
    if array:
        bers = ("$a=@('-NoProfile','-File',('\"'+$p+'\"'),'-Expert','ABTG_X','-Prova','x.txt',"
                "'-Etichetta','X','-Pin',$pin,'-TerminaleBacktest','" + bersaglio + "',"
                "'-Modello','4','-Deposito','80000'); "
                "Start-Process powershell -ArgumentList $a -NoNewWindow -Wait; ")
    else:
        bers = ("& $p -Expert ABTG_ORB_Ottimizzato -Prova 'R125a_costo_buffer_U30USD.txt' "
                "-Etichetta x -Pin $pin -Deposito 100000 -Modello 4 "
                "-TerminaleBacktest '" + bersaglio + "' -SoloControllo; ")
    return ("& { $ErrorActionPreference='Stop'; " + testa + "$pin='" + PIN_V2 + "'; "
            "$p=\"$env:USERPROFILE\\RIGA_ROUND_VPS.ps1\"; "
            "irm \"https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/"
            "backtest_pipeline/righe/RIGA_ROUND_VPS.ps1\" -OutFile $p -EA Stop; "
            "if(-not (Select-String -Path $p -SimpleMatch -Pattern "
            "'MARCATORE_RIGA_ROUND_VPS_v2' -Quiet)){ throw 'SCRIPT VECCHIO' }; "
            + bers +
            "Compress-Archive -Path \"$env:USERPROFILE\\Desktop\\ROUND_X\\*\" "
            "-DestinationPath \"$env:USERPROFILE\\Desktop\\ROUND_X.zip\" -Force }")

PCB     = "DESKTOP-H4D7CAJ"
VPS     = "VMI3047753"
PICCOLO = "C:\\Program Files\\BCM Markets MT5 Terminal"
BANCO   = "C:\\MT5_Backtest"
V3      = "C:\\Program Files\\BCM Markets MT5 Terminal -V3"

CASI_MACCHINA = [
    # -------- LE TRE PROVE CHIESTE ----------------------------------
    ("535 STESSA RIGA, macchina PC di backtest dichiarata",
     riga_round(PICCOLO, PCB, array=True), "PASSA"),
    ("535 STESSA RIGA, ma dichiarata sul VPS -> e' il piccolo 50503392",
     riga_round(PICCOLO, VPS, array=True), "BLOCCA"),
    ("535 STESSA RIGA senza NESSUNA macchina dichiarata (regola storica)",
     riga_round(PICCOLO, None, array=True), "BLOCCA"),
    ("535 C:\\FTMO (challenge viva) sul PC di backtest",
     riga_round("C:\\FTMO", PCB, array=True), "BLOCCA"),
    ("535 C:\\FTMO sul VPS",
     riga_round("C:\\FTMO", VPS, array=True), "BLOCCA"),
    ("535 C:\\FTMO senza macchina dichiarata",
     riga_round("C:\\FTMO", None, array=True), "BLOCCA"),
    ("535 MACCHINA IGNOTA dichiarata, bersaglio per il resto buono",
     riga_round(BANCO, "PC-SCONOSCIUTO", array=True), "BLOCCA"),
    # -------- E ADESSO PROVO A ROMPERLO -----------------------------
    ("536 il BUCO MISURATO: REALE dentro l'array, nessuna macchina",
     riga_round("C:\\BCM_Reale", None, array=True), "BLOCCA"),
    ("536 REALE dentro l'array CON la deroga del PC di backtest",
     riga_round("C:\\BCM_Reale", PCB, array=True), "BLOCCA"),
    ("535 il 100k -V3 sul PC di backtest: la deroga NON lo copre",
     riga_round(V3, PCB, array=True), "BLOCCA"),
    ("535 il banco del VPS chiesto sul PC di backtest (li' non esiste)",
     riga_round(BANCO, PCB, array=True), "BLOCCA"),
    ("535 nome 8.3 del bersaglio buono sul PC di backtest",
     riga_round("C:\\PROGRA~1\\BCMMAR~1", PCB, array=True), "BLOCCA"),
    ("535 il '..' parte dal nome buono e ATTERRA sul 100k",
     riga_round(PICCOLO + "\\..\\BCM Markets MT5 Terminal -V3", PCB, array=True), "BLOCCA"),
    ("535 il '..' parte dal 100k e ATTERRA sul bersaglio: stesso posto",
     riga_round(V3 + "\\..\\BCM Markets MT5 Terminal", PCB, array=True), "PASSA"),
    ("535 RADICE del disco sul PC di backtest",
     riga_round("C:\\", PCB, array=True), "BLOCCA"),
    ("535 guardia col VERSO SBAGLIATO (-eq + throw): non dichiara niente",
     riga_round(PICCOLO, PCB, array=True, verso="-eq"), "BLOCCA"),
    ("535 guardia che NOMINA la macchina ma NON rifiuta (Write-Host)",
     riga_round(PICCOLO, PCB, array=True, rifiuta=False), "BLOCCA"),
    ("535 macchina scritta in minuscolo: e' la stessa macchina",
     riga_round(PICCOLO, "desktop-h4d7caj", array=True), "PASSA"),
    ("535 barre al contrario: stesso posto scritto in un altro modo",
     riga_round("C:/Program Files/BCM Markets MT5 Terminal", PCB, array=True), "PASSA"),
    ("535 separatore finale sul bersaglio buono",
     riga_round(PICCOLO + "\\", PCB, array=True), "PASSA"),
    ("535 forma con lo SPAZIO (non array), bersaglio buono su PC backtest",
     riga_round(PICCOLO, PCB, array=False), "PASSA"),
    ("535 il banco del VPS, dichiarato sul VPS: il caso di sempre",
     riga_round(BANCO, VPS, array=True), "PASSA"),
]

# DUE guardie che nominano DUE macchine diverse: non e' un'assenza, e' un
# difetto -- il cancello non sceglie al posto di chi scrive.
CASO_DISCORDE = riga_round(PICCOLO, PCB, array=True).replace(
    "$pin='", "if($env:COMPUTERNAME -ne 'VMI3047753'){ throw 'VIETATO' }; $pin='", 1)

def gira(argomenti):
    r = subprocess.run([sys.executable, CANCELLO] + argomenti,
                       capture_output=True, text=True, cwd=REPO)
    return r.returncode, r.stdout + r.stderr

def scrivi(cartella, nome, testo):
    p = os.path.join(cartella, nome)
    with open(p, "w") as f:
        f.write(testo)
    return p


# =====================================================================
#  IL CONFRONTO CHE IMPEDISCE ALLE DUE GUARDIE DI DIVERGERE (21/09/2026)
#
#  Adesso la stessa regola vive in DUE linguaggi: il blocco
#  GUARDIA_BANCO_POSITIVA_v2 nei tre .ps1 e la sua porta in Python dentro
#  controlla_riga.py. E' esattamente il difetto che il banco .ps1 e' nato
#  per prendere ("tre guardie diverse che credono di essere la stessa"),
#  con un linguaggio in piu' di mezzo: se divergono, lo strato 1 approva
#  una riga che poi lo .ps1 rifiuta, o peggio il contrario.
#  Quindi non ci si fida: si prendono I CASI VERI del banco .ps1 -- letti
#  dal suo sorgente, non ricopiati -- e si rigirano sulle funzioni Python.
#  Se una divergesse, e' un buco, non uno stile.
# =====================================================================
def confronto_con_banco_ps1():
    import re as _re
    sys.path.insert(0, QUI)
    import controlla_riga as C
    banco = os.path.join(QUI, "banco_guardia_macchina.ps1")
    if not os.path.exists(banco):
        return None, "banco .ps1 non trovato: confronto NON ESEGUITO"
    testo = open(banco).read()
    if "$casi = @(" not in testo:
        return None, "non trovo la tabella dei casi nel banco: confronto NON ESEGUITO"
    blocco = testo.split("$casi = @(")[1].split("\n)")[0]
    NOMI = {"VPS": "VMI3047753", "PCB": "DESKTOP-H4D7CAJ",
            "BANCO": "C:\\MT5_Backtest",
            "PICCOLO": "C:\\Program Files\\BCM Markets MT5 Terminal"}
    def val(x):
        x = x.strip()
        if x.startswith("$") and x[1:] in NOMI:
            return NOMI[x[1:]]
        m = _re.match(r'^\(\s*\$(\w+)\s*\+\s*"([^"]*)"\s*\)$', x)
        if m: return NOMI[m.group(1)] + m.group(2)
        m = _re.match(r'^\(\s*"([^"]*)"\s*\+\s*\$(\w+)\s*\+\s*"([^"]*)"\s*\)$', x)
        if m: return m.group(1) + NOMI[m.group(2)] + m.group(3)
        m = _re.match(r'^"(.*)"$', x, _re.S)
        if m: return m.group(1)
        raise Exception("caso del banco che non so leggere: " + x)
    n, ko = 0, []
    for riga in blocco.splitlines():
        m = _re.search(r'mac=(.+?);\s*ber=(.+?);\s*att="(\w+)"', riga)
        if not m:
            continue
        mac, ber, att = val(m.group(1)), val(m.group(2)), m.group(3)
        esito = "AMMESSO" if C.motivo_rifiuto_bersaglio(ber, mac) == "" else "RIFIUTATO"
        n += 1
        if esito != att:
            ko.append("mac=" + repr(mac) + " ber=" + repr(ber) +
                      " il banco .ps1 dice " + att + ", la porta Python dice " + esito)
    return (n, ko), ""

def main():
    casi = []
    tmp = tempfile.mkdtemp(prefix="controesempi_cancello_")

    # --- i cinque della classe 223, sulla RIGA -------------------------------
    for etichetta, bersaglio, atteso in [
        ("RIGA bersaglio C:\\BCM_Reale (REALE 10105439)",  "C:\\BCM_Reale", "BLOCCA"),
        ("RIGA bersaglio ...-V3 (100k 50504263)",          "C:\\Program Files\\BCM Markets MT5 Terminal -V3", "BLOCCA"),
        ("RIGA bersaglio piccolo 50503392 (40 sedie vive)","C:\\Program Files\\BCM Markets MT5 Terminal", "BLOCCA"),
        ("RIGA bersaglio C:\\MT5_Backtest (il banco)",     "C:\\MT5_Backtest", "PASSA"),
    ]:
        p = scrivi(tmp, "riga_" + str(len(casi)) + ".txt", riga_con_bersaglio(bersaglio))
        casi.append((etichetta, ["--riga", p], atteso))

    p = scrivi(tmp, "guardia.ps1", GUARDIA_LEGITTIMA)
    casi.append(("PS1 guardia legittima (nomina per RIFIUTARE)", ["--ps1", p], "PASSA"))

    # --- i quattro della classe 225, sul .md --------------------------------
    p = scrivi(tmp, "md_cattivo.md", MD_PROSA_INNOCUA_BLOCCO_CATTIVO)
    casi.append(("MD prosa innocua + blocco puntato sul REALE", ["--oggetto", "md", p], "BLOCCA"))
    p = scrivi(tmp, "md_senza_ling.md", MD_BLOCCO_SENZA_LINGUAGGIO)
    casi.append(("MD blocco SENZA linguaggio, bersaglio -V3", ["--oggetto", "md", p], "BLOCCA"))
    p = scrivi(tmp, "md_prosa_comando.md", MD_COMANDO_NELLA_PROSA)
    casi.append(("MD comando sul REALE scritto NELLA PROSA", ["--oggetto", "md", p], "BLOCCA"))
    p = scrivi(tmp, "md_buono.md", MD_BUONO)
    casi.append(("MD sano (prosa che NOMINA i vietati per dire di non toccarli)", ["--oggetto", "md", p], "PASSA"))

    # --- la classe 339: payload dentro il CONTENUTO di una raccolta innocua --
    p = scrivi(tmp, "payload_339.txt", PAYLOAD_RACCOLTA_339)
    casi.append(("RIGA classe 339: mshta/javascript: dentro Set-Content -Value di una 'raccolta'",
                 ["--riga", p], "BLOCCA"))

    # --- classi 535/536: la coppia MACCHINA + PERCORSO ----------------------
    for etichetta, testo, atteso in CASI_MACCHINA:
        q = scrivi(tmp, "mac_" + str(len(casi)) + ".txt", testo)
        casi.append((etichetta, ["--riga", q], atteso))
    q = scrivi(tmp, "mac_discorde.txt", CASO_DISCORDE)
    casi.append(("535 DUE macchine dichiarate, discordi", ["--riga", q], "BLOCCA"))

    # --- la riga vera di R125, che deve passare ------------------------------
    r125 = os.path.join(QUI, "righe", "RIGA_R125_DA_MANDARE.md")
    if os.path.exists(r125):
        casi.append(("MD vero: RIGA_R125_DA_MANDARE.md (firmato il 10/09)",
                     ["--oggetto", "md", r125], "PASSA"))

    print("=" * 78)
    print("  CONTRO-ESEMPI DEL CANCELLO -- rigirati il " +
          subprocess.run(["date", "+%Y-%m-%d %H:%M"], capture_output=True, text=True).stdout.strip())
    print("=" * 78)
    ko = 0
    for etichetta, argomenti, atteso in casi:
        rc, out = gira(argomenti)
        avuto = "BLOCCA" if rc == 1 else ("PASSA" if rc == 0 else "ERRORE(" + str(rc) + ")")
        ok = (avuto == atteso)
        if not ok:
            ko += 1
        n_bloc = out.count("\n    X [")
        print(("  OK   " if ok else "  KO   ") + etichetta.ljust(58) +
              " atteso " + atteso.ljust(7) + " avuto " + avuto +
              "  (bloccanti: " + str(n_bloc) + ")")
        if not ok:
            print("       ---- uscita del cancello ----")
            for r in out.splitlines():
                print("       " + r)
    print("-" * 78)
    if ko:
        print("  " + str(ko) + " CONTRO-ESEMPI SU " + str(len(casi)) +
              " NON SI COMPORTANO COME DEVONO: il cancello ha un buco. NON COMMETTERE.")
        return 1
    print("  tutti e " + str(len(casi)) + " i contro-esempi si comportano come devono.")

    esito, nota = confronto_con_banco_ps1()
    if esito is None:
        print("  ATTENZIONE: " + nota)
        return 1
    n, ko = esito
    if ko:
        print("  " + str(len(ko)) + " CASI SU " + str(n) + " DIVERGONO fra la guardia .ps1 e la")
        print("  sua porta in Python: DUE guardie che credono di essere la stessa. NON COMMETTERE.")
        for k in ko:
            print("     " + k)
        return 1
    print("  e i " + str(n) + " casi del banco .ps1 (banco_guardia_macchina.ps1) danno lo")
    print("  STESSO verdetto sulla porta in Python: le due guardie non sono divergute.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
