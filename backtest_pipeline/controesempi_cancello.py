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

MD_BUONO = """# Documento sano

Il banco e' `C:\\MT5_Backtest`, il demo di solo tester. Il driver muore da solo
se punta al 100k 50504263 (`... -V3`) o al REALE 10105439 (`C:\\BCM_Reale`):
sono nominati qui per dire che NON si toccano.

```powershell
""" + riga_con_bersaglio("C:\\MT5_Backtest") + """
```
"""

def gira(argomenti):
    r = subprocess.run([sys.executable, CANCELLO] + argomenti,
                       capture_output=True, text=True, cwd=REPO)
    return r.returncode, r.stdout + r.stderr

def scrivi(cartella, nome, testo):
    p = os.path.join(cartella, nome)
    with open(p, "w") as f:
        f.write(testo)
    return p

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
    return 0

if __name__ == "__main__":
    sys.exit(main())
