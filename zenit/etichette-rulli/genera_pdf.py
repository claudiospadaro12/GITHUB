#!/usr/bin/env python3
"""Genera PDF e PNG di anteprima delle etichette rulli Zenit.

Uso:
  python3 genera_pdf.py                 # anteprima (foglio con tutte le etichette) -> output/anteprima.pdf + .png
  python3 genera_pdf.py --stampa        # una etichetta per pagina a misura esatta -> output/stampa.pdf
  python3 genera_pdf.py --dati altro.json

Usa Chrome/Chromium headless gia' installato nel sistema (nessuna dipendenza Python esterna;
per il PNG serve pdftoppm di poppler-utils).
"""
import argparse, json, shutil, subprocess, sys, tempfile
from pathlib import Path

QUI = Path(__file__).resolve().parent


def trova_chrome():
    for n in ("google-chrome", "chromium", "chromium-browser", "chrome"):
        p = shutil.which(n)
        if p:
            return p
    sys.exit("Chrome/Chromium non trovato nel PATH")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dati", default=str(QUI / "prodotti.json"))
    ap.add_argument("--stampa", action="store_true", help="una etichetta per pagina, misura esatta, senza margini")
    ap.add_argument("--dpi", type=int, default=200)
    a = ap.parse_args()

    dati = json.loads(Path(a.dati).read_text(encoding="utf-8"))
    w, h = dati["formato"]["larghezza_mm"], dati["formato"]["altezza_mm"]
    n = len(dati["prodotti"])
    html = (QUI / "template.html").read_text(encoding="utf-8")
    html = html.replace("__DATI__", json.dumps(dati, ensure_ascii=False).replace("</", "<\\/"))

    if a.stampa:
        page = f"@page {{ size:{w}mm {h}mm; margin:0 }} body{{background:#fff}}"
        html = html.replace("<script id=\"dati\"", "<script>window.__PROD__=true</script><script id=\"dati\"")
        nome = "stampa"
    else:
        # foglio di anteprima: margine 10 mm, didascalia + etichetta per prodotto
        pw, ph = w + 20, n * (h + 8 + 8) + 20
        page = f"@page {{ size:{pw}mm {ph}mm; margin:0 }}"
        html = html.replace(".sheet { display:flex;", ".sheet { padding-top:10mm !important; display:flex;")
        nome = "anteprima"
    html = html.replace("</style>", page + "</style>", 1)

    # le immagini (logo) sono relative alla cartella: scrivo l'HTML qui accanto, poi lo cancello
    out = QUI / "output"
    out.mkdir(exist_ok=True)
    tmp = QUI / "_render.html"
    tmp.write_text(html, encoding="utf-8")
    pdf = out / f"{nome}.pdf"
    try:
        subprocess.run([trova_chrome(), "--headless", "--no-sandbox", "--disable-gpu", "--no-pdf-header-footer",
                        "--virtual-time-budget=4000", f"--print-to-pdf={pdf}", tmp.as_uri()],
                       check=True, capture_output=True)
    finally:
        tmp.unlink(missing_ok=True)
    print("PDF:", pdf)

    if shutil.which("pdftoppm"):
        subprocess.run(["pdftoppm", "-png", "-r", str(a.dpi), str(pdf), str(out / nome)], check=True)
        print("PNG:", ", ".join(sorted(str(p) for p in out.glob(f"{nome}*.png"))))
    else:
        print("pdftoppm non trovato: PNG non generato")


if __name__ == "__main__":
    main()
