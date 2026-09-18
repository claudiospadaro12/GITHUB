# -*- coding: utf-8 -*-
"""
md2pdf_collega.py -- converte un documento Markdown in un PDF leggibile,
pensato per i documenti che escono verso un COLLEGA (Marco Garbuglia e altri).

Richiesta di Claudio, 18/09/2026: "File per marco generami sempre dei pdf
x favore. Anche x altri colleghi. E' piu' semplice."

USO:
    python3 backtest_pipeline/md2pdf_collega.py <input.md> [output.pdf]

PERCHE' NON BASTAVA UN CONVERTITORE QUALUNQUE
  I nostri .md sono pieni di emoji, e le emoji PORTANO INFORMAZIONE:
  il rosso e' un difetto, il verde una misura che tiene, l'arancione un
  dubbio. I font standard del PDF (Helvetica, Type1, WinAnsi) NON hanno i
  glifi delle emoji: lasciate cosi' diventano quadratini neri o spariscono,
  e con loro sparisce il senso.
  Quindi qui le emoji SEMANTICHE diventano etichette ASCII COLORATE
  ([!] rosso, [ok] verde, [~] arancione), e le decorative si tolgono.
  Il colore fa il lavoro che faceva l'emoji.

LIMITI DICHIARATI, perche' un convertitore che tace e' peggio di uno che
manca:
  - il Markdown supportato e' quello che usiamo davvero: titoli #..####,
    tabelle | |, liste - e 1., **grassetto**, `codice`, > citazioni,
    blocchi ``` e righe ---. NON: immagini, note a pie' di pagina, HTML.
  - una tabella con piu' di 9 colonne viene stretta: il PDF la rimpicciolisce
    invece di tagliarla, e lo dichiara in console.
  - i link Markdown diventano il loro TESTO, non sono cliccabili.
"""
import os
import re
import sys

from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.units import mm
from reportlab.platypus import (BaseDocTemplate, Frame, PageTemplate, Paragraph,
                                Spacer, Table, TableStyle)

INK  = colors.HexColor("#16202A")
SOFT = colors.HexColor("#4B5A67")
RULE = colors.HexColor("#C9D3DB")
RED  = colors.HexColor("#8C3A31")
GRN  = colors.HexColor("#1C5A56")
AMB  = colors.HexColor("#8A6116")
BOXN = colors.HexColor("#EDF1F4")
HEAD = colors.HexColor("#DCE4EA")

# --- emoji SEMANTICHE -> etichetta ASCII (il colore lo decide chi legge il marcatore)
SEMANTICHE = [
    (u"\U0001F534", "[!] "), (u"❌", "[no] "), (u"\U0001F6AB", "[no] "),
    (u"\U0001F7E2", "[ok] "), (u"✅", "[ok] "),
    (u"\U0001F7E0", "[~] "), (u"⚠️", "[!] "), (u"⚠", "[!] "),
    (u"\U0001F7E1", "[~] "), (u"⏸️", "[-] "), (u"⚪", "[-] "),
    (u"\U0001F535", "[i] "), (u"⬅️", "-> "), (u"\U0001F449", "=> "),
    (u"➡️", "=> "), (u"⬆️", "^ "),
]

def pulisci(t):
    """Emoji semantiche -> etichette; tutto il resto fuori da Latin-1 via."""
    for e, tag in SEMANTICHE:
        t = t.replace(e, tag)
    t = (t.replace(u"—", "--").replace(u"–", "-")
          .replace(u"‘", "'").replace(u"’", "'")
          .replace(u"“", '"').replace(u"”", '"')
          .replace(u"×", "x").replace(u"≥", ">=").replace(u"≤", "<=")
          .replace(u"→", "->").replace(u"⇒", "=>").replace(u"…", "..."))
    fuori = []
    out = []
    for c in t:
        if ord(c) < 256:
            out.append(c)
        else:
            if c.strip():
                fuori.append(c)
    testo = "".join(out)
    testo = re.sub(r"[ \t]{2,}", " ", testo)
    return testo.strip(), fuori

def colore_di(t):
    if t.startswith("[!]") or t.startswith("[no]"):
        return RED
    if t.startswith("[ok]"):
        return GRN
    if t.startswith("[~]"):
        return AMB
    return None

def inline(t):
    """**grassetto**, `codice`, [testo](url) -> markup di reportlab."""
    t = t.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    t = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", t)
    t = re.sub(r"\*\*\*(.+?)\*\*\*", r"<b><i>\1</i></b>", t)
    t = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", t)
    t = re.sub(r"(?<!\*)\*([^*]+)\*(?!\*)", r"<i>\1</i>", t)
    t = re.sub(r"`([^`]+)`", r'<font face="Courier" size="8.2">\1</font>', t)
    return t

def S(nome, **kw):
    base = dict(fontName="Helvetica", fontSize=9.3, leading=13.2, textColor=INK,
                alignment=TA_LEFT, spaceAfter=5)
    base.update(kw)
    return ParagraphStyle(nome, **base)

ST = {
    "p":  S("p"),
    "h1": S("h1", fontName="Helvetica-Bold", fontSize=16, leading=19, spaceBefore=15, spaceAfter=6),
    "h2": S("h2", fontName="Helvetica-Bold", fontSize=11.6, leading=14.5, spaceBefore=12, spaceAfter=4),
    "h3": S("h3", fontName="Helvetica-Bold", fontSize=9.8, leading=12.8, spaceBefore=8, spaceAfter=2, textColor=SOFT),
    "h4": S("h4", fontName="Helvetica-Bold", fontSize=9.3, leading=12.2, spaceBefore=6, spaceAfter=2, textColor=SOFT),
    "li": S("li", leftIndent=10, bulletIndent=2, spaceAfter=2),
    "q":  S("q", leftIndent=9, textColor=SOFT, fontName="Helvetica-Oblique", spaceAfter=4),
    "code": S("code", fontName="Courier", fontSize=8.0, leading=10.4, leftIndent=6, spaceAfter=3),
    "cell": S("cell", fontSize=7.9, leading=10.2, spaceAfter=0),
    "cellh": S("cellh", fontSize=7.9, leading=10.2, fontName="Helvetica-Bold", spaceAfter=0),
}

def riga_tabella(l):
    parti = [c.strip() for c in l.strip().strip("|").split("|")]
    return parti

def converti(src, dst):
    testo = open(src, encoding="utf-8").read()
    righe = testo.split("\n")
    flow = []
    scartate = []
    larghe = []
    i = 0
    while i < len(righe):
        l = righe[i]
        s = l.strip()

        if not s:
            i += 1
            continue

        # blocco di codice
        if s.startswith("```"):
            i += 1
            buf = []
            while i < len(righe) and not righe[i].strip().startswith("```"):
                buf.append(righe[i])
                i += 1
            i += 1
            for b in buf:
                p, f = pulisci(b)
                scartate.extend(f)
                flow.append(Paragraph(inline(p) or "&nbsp;", ST["code"]))
            flow.append(Spacer(1, 3))
            continue

        # riga orizzontale
        if re.fullmatch(r"-{3,}|\*{3,}|_{3,}", s):
            flow.append(Spacer(1, 3))
            flow.append(Table([[""]], colWidths=[165*mm], rowHeights=[0.6],
                              style=TableStyle([("BACKGROUND", (0,0), (-1,-1), RULE)])))
            flow.append(Spacer(1, 5))
            i += 1
            continue

        # tabella
        if s.startswith("|") and i + 1 < len(righe) and re.match(r"^\s*\|[\s:|-]+\|\s*$", righe[i+1]):
            intest = riga_tabella(s)
            i += 2
            corpo = []
            while i < len(righe) and righe[i].strip().startswith("|"):
                corpo.append(riga_tabella(righe[i].strip()))
                i += 1
            nc = len(intest)
            if nc > 9:
                larghe.append(nc)
            dati = []
            hp, f = zip(*[pulisci(c) for c in intest]) if intest else ([], [])
            for x in f: scartate.extend(x)
            dati.append([Paragraph(inline(c), ST["cellh"]) for c in hp])
            for r in corpo:
                r = (r + [""] * nc)[:nc]
                cel = []
                for c in r:
                    p, ff = pulisci(c)
                    scartate.extend(ff)
                    st = ST["cell"]
                    col = colore_di(p)
                    if col is not None:
                        st = ParagraphStyle("c", parent=ST["cell"], textColor=col)
                    cel.append(Paragraph(inline(p), st))
                dati.append(cel)
            w = 165.0 / nc
            t = Table(dati, colWidths=[w*mm]*nc, repeatRows=1)
            t.setStyle(TableStyle([
                ("BACKGROUND", (0,0), (-1,0), HEAD),
                ("GRID", (0,0), (-1,-1), 0.4, RULE),
                ("VALIGN", (0,0), (-1,-1), "TOP"),
                ("TOPPADDING", (0,0), (-1,-1), 2.5),
                ("BOTTOMPADDING", (0,0), (-1,-1), 2.5),
                ("LEFTPADDING", (0,0), (-1,-1), 3),
                ("RIGHTPADDING", (0,0), (-1,-1), 3),
            ]))
            flow.append(t)
            flow.append(Spacer(1, 6))
            continue

        p, f = pulisci(s)
        scartate.extend(f)

        m = re.match(r"^(#{1,4})\s+(.*)$", p)
        if m:
            liv = len(m.group(1))
            flow.append(Paragraph(inline(m.group(2)), ST["h%d" % liv]))
            i += 1
            continue

        if p.startswith(">"):
            q = p.lstrip(">").strip()
            q = re.sub(r"^#{1,6}\s*", "", q)
            if q:
                st = ST["q"]
                col = colore_di(q)
                if col is not None:
                    st = ParagraphStyle("qq", parent=ST["q"], textColor=col,
                                        fontName="Helvetica-Bold")
                flow.append(Paragraph(inline(q), st))
            i += 1
            continue

        m = re.match(r"^([-*+]|\d+\.)\s+(.*)$", p)
        if m:
            b = "•" if not m.group(1)[0].isdigit() else m.group(1)
            corpo = m.group(2)
            st = ST["li"]
            col = colore_di(corpo)
            if col is not None:
                st = ParagraphStyle("ll", parent=ST["li"], textColor=col)
            flow.append(Paragraph(inline(corpo), st, bulletText=b))
            i += 1
            continue

        # \U0001F534 UN PARAGRAFO MARKDOWN FINISCE A RIGA VUOTA, NON A FINE RIGA.
        # Prima processavo riga per riga: un **grassetto** aperto su una riga e
        # chiuso su quella dopo non veniva MAI convertito, e usciva nel PDF con
        # gli asterischi in chiaro. Trovato rileggendo il PDF generato, non il
        # codice: il testo diceva "**e' entrato nel nostro repo**".
        pezzi = [p]
        j = i + 1
        while j < len(righe):
            nxt = righe[j].strip()
            if not nxt:
                break
            if (nxt.startswith("#") or nxt.startswith("|") or nxt.startswith(">")
                    or nxt.startswith("```")
                    or re.fullmatch(r"-{3,}|\*{3,}|_{3,}", nxt)
                    or re.match(r"^([-*+]|\d+\.)\s+", nxt)):
                break
            q2, f2 = pulisci(nxt)
            scartate.extend(f2)
            if q2:
                pezzi.append(q2)
            j += 1
        p = " ".join(pezzi)
        i = j

        st = ST["p"]
        col = colore_di(p)
        if col is not None:
            st = ParagraphStyle("pp", parent=ST["p"], textColor=col)
        flow.append(Paragraph(inline(p), st))
        continue

    doc = BaseDocTemplate(dst, pagesize=A4,
                          leftMargin=22*mm, rightMargin=22*mm,
                          topMargin=18*mm, bottomMargin=18*mm,
                          title=os.path.basename(src), author="Progetto ABTG")
    frame = Frame(22*mm, 18*mm, 166*mm, 261*mm, id="f")

    def piede(canv, d):
        canv.saveState()
        canv.setFont("Helvetica", 7.4)
        canv.setFillColor(SOFT)
        canv.drawRightString(188*mm, 11*mm, "pag. %d" % canv.getPageNumber())
        canv.restoreState()

    doc.addPageTemplates([PageTemplate(id="tpl", frames=[frame], onPage=piede)])
    # \U0001F534 il conteggio si prende PRIMA: doc.build() CONSUMA la lista e la
    # lascia vuota. La prima versione stampava "elementi impaginati: 0" su un
    # PDF di cinque pagine piene -- un contatore che mente e' peggio di nessun
    # contatore, perche' fa sospettare il file invece dello strumento.
    n_flow = len(flow)
    doc.build(flow)

    pers = sorted(set(scartate))
    print("scritto: %s" % dst)
    print("  elementi impaginati: %d" % n_flow)
    if larghe:
        print("  [!] tabelle con %s colonne: strette per stare in pagina"
              % ", ".join(str(x) for x in sorted(set(larghe))))
    if pers:
        print("  [!] %d caratteri non-Latin1 TOLTI (decorativi): %s"
              % (len(pers), " ".join(pers[:40])))
    else:
        print("  nessun carattere perso")
    return dst

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)
    src = sys.argv[1]
    dst = sys.argv[2] if len(sys.argv) > 2 else os.path.splitext(src)[0] + ".pdf"
    converti(src, dst)
