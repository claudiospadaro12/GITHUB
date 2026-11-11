#!/usr/bin/env python3
"""Genera i disegni SVG (frontale + laterale, quote in mm) dell'espositore Zenit.
Tutte le misure sono IPOTESI parametriche: modificare i dizionari VARIANTI e rilanciare
    python3 genera_disegni.py
poi render_png.js per le anteprime PNG.  Nessuna dipendenza esterna.
"""
import math, os
from textwrap import wrap

HERE = os.path.dirname(os.path.abspath(__file__))
# Blu e grigio scuro dal logo Zenit; arancio e sabbia restano segnaposto
C = dict(blue="#3850A2", orange="#F08A1C", sand="#F4F1EA", ink="#283030", grey="#6F7A8A",
         light="#D5DAE2", white="#FFFFFF", wood="#B9814A", bristle="#E6D3A0", sleeve="#EFE6D2")

import base64
with open(os.path.join(HERE, "..", "..", "brand", "logo-zenit-web.png"), "rb") as _f:
    LOGO_URI = "data:image/png;base64," + base64.b64encode(_f.read()).decode()

# ----------------------------------------------------------------- PARAMETRI (mm)
COMMON = dict(
    spine=20,            # spessore montante centrale / pannello posteriore
    upr=20,              # spessore fianchi
    inset=10,            # arretramento fronte vaschetta rispetto al bordo base
    incl=15,             # inclinazione vaschette (gradi)
    tray_pitch=170,      # passo verticale tra vaschette
    tray_t=6,            # spessore vaschetta
    lip_h=35,            # altezza sponda anteriore (cartellino prezzo)
    roller_d=65,         # diametro rullo confezionato (ipotesi)
    roller_gap=10,       # gioco tra rulli affiancati
    blister_w=70, blister_h=170, blister_t=12,   # blister pennelli (ipotesi)
    hook_pitch=80, hook_len=150, blister_per_hook=8,
)
VARIANTI = {
 "A": dict(COMMON, code="A", name="Variante A - da terra, 2 facce",
           W=500, D=400, H=2200, faces=2, base=120, header=250, promo=160, pegrows=4,
           trays=[250, 230, 200, 100], hdr_t=60,
           logo=(190, 110), h1=34, h2=20, tw=330, plabel=(22, 16)),
 "B": dict(COMMON, code="B", name="Variante B - da banco, 1 faccia",
           W=450, D=300, H=880, faces=1, base=30, header=100, promo=0, pegrows=2,
           trays=[200, 100], hdr_t=40,
           logo=(130, 62), h1=24, h2=14, tw=0, plabel=(0, 0)),
}
ROWNAMES = ["Pennelli piatti (blister)", "Pennelli per smalti/rifinitura", "Pennellesse e tondi", "Pennelli per radiatori e vari"]
TRAYNAMES = {250: "rulli 250 mm", 230: "rulli 230 mm", 200: "rulli 200 mm", 180: "rulli 180 mm", 100: "mini-rulli 100 mm"}

# ----------------------------------------------------------------- derivati
def derive(c):
    c = dict(c)
    n = len(c["trays"])
    c["peg_h"] = c["H"] - c["base"] - n * c["tray_pitch"] - c["promo"] - c["header"]
    c["row_p"] = c["peg_h"] / c["pegrows"]
    assert c["blister_h"] + 30 <= c["row_p"], "passo righe troppo piccolo"
    c["usable_w"] = c["W"] - 2 * c["upr"]
    a = math.radians(c["incl"]); c["a"] = a
    r = c["roller_d"] / 2; c["r"] = r
    c["s0"] = r * (1 + math.sin(a)) / math.cos(a)
    c["xs"] = (c["D"] - c["spine"]) / 2 if c["faces"] == 2 else c["D"] - c["spine"]  # faccia montante lato fronte
    c["tray_d"] = c["xs"] - c["inset"]
    c["pitch_r"] = c["roller_d"] + 2
    k = 0
    while True:   # quante file di rulli entrano nella profondita' utile
        xc = c["s0"] * math.cos(a) + k * c["pitch_r"] * math.cos(a) - r * math.sin(a)
        if xc + r <= c["tray_d"] + 0.01: k += 1
        else: break
    c["rows"] = k
    c["across"] = [int((c["usable_w"] + c["roller_gap"]) // (L + c["roller_gap"])) for L in c["trays"]]
    c["roller_cap"] = [ac * k for ac in c["across"]]
    c["hooks"] = int(c["usable_w"] // c["hook_pitch"])
    c["brush_cap"] = c["pegrows"] * c["hooks"] * c["blister_per_hook"]
    c["rolls_face"] = sum(c["roller_cap"])
    return c

def tray_hb(c, i): return c["base"] + i * c["tray_pitch"]
def roller_ycs(c, i, row):
    """quota centro rullo (riga 'row' dalla sponda) e ascissa dal fronte"""
    a, r = c["a"], c["r"]; s = c["s0"] + row * c["pitch_r"]
    return (c["inset"] + s * math.cos(a) - r * math.sin(a),
            tray_hb(c, i) + c["tray_t"] + s * math.sin(a) + r * math.cos(a))

# ----------------------------------------------------------------- helper SVG
class Cv:
    def __init__(s, c, ml, mr, mt, mb, scale):
        s.c, s.ml, s.mr, s.mt, s.mb, s.scale, s.o = c, ml, mr, mt, mb, scale, []
    def X(s, x): return s.ml + x
    def Y(s, h): return s.mt + s.c["H"] - h
    def add(s, t): s.o.append(t)
    def rect(s, x, h, w, hh, fill="none", stroke="none", sw=1.5, rx=0, extra=""):  # x,h = angolo basso-sx in mm
        s.add(f'<rect x="{s.X(x):.1f}" y="{s.Y(h+hh):.1f}" width="{w:.1f}" height="{hh:.1f}" rx="{rx}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}" {extra}/>')
    def line(s, x1, h1, x2, h2, stroke=None, sw=1.5, dash="", cap="butt"):
        d = f' stroke-dasharray="{dash}"' if dash else ""
        s.add(f'<line x1="{s.X(x1):.1f}" y1="{s.Y(h1):.1f}" x2="{s.X(x2):.1f}" y2="{s.Y(h2):.1f}" stroke="{stroke or C["ink"]}" stroke-width="{sw}" stroke-linecap="{cap}"{d}/>')
    def poly(s, pts, fill="none", stroke="none", sw=1.5, extra=""):
        p = " ".join(f"{s.X(x):.1f},{s.Y(h):.1f}" for x, h in pts)
        s.add(f'<polygon points="{p}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}" {extra}/>')
    def circ(s, x, h, r, fill="none", stroke="none", sw=1.5, dash=""):
        d = f' stroke-dasharray="{dash}"' if dash else ""
        s.add(f'<circle cx="{s.X(x):.1f}" cy="{s.Y(h):.1f}" r="{r:.1f}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}"{d}/>')
    def text(s, x, h, t, size=22, anchor="start", fill=None, weight="normal", raw=False, style=""):
        px, py = (x, h) if raw else (s.X(x), s.Y(h))
        t = t.replace("&", "&amp;")
        s.add(f'<text x="{px:.1f}" y="{py:.1f}" font-size="{size}" text-anchor="{anchor}" fill="{fill or C["ink"]}" font-weight="{weight}" {style}>{t}</text>')
    def vdim(s, x, h1, h2, label, side="left", size=22, ext_to=0, bold=False):
        X, y1, y2 = s.X(x), s.Y(h1), s.Y(h2)
        for h in (h1, h2):
            s.line(ext_to, h, x + (8 if side == "left" else -8) * 0, h, stroke=C["grey"], sw=0.8, dash="3 4")
        s.add(f'<line x1="{X:.1f}" y1="{y1:.1f}" x2="{X:.1f}" y2="{y2:.1f}" stroke="{C["ink"]}" stroke-width="1.4"/>')
        for y in (y1, y2):
            s.add(f'<line x1="{X-6:.1f}" y1="{y+6:.1f}" x2="{X+6:.1f}" y2="{y-6:.1f}" stroke="{C["ink"]}" stroke-width="1.6"/>')
        tx, an = (X - 9, "end") if side == "left" else (X + 9, "start")
        s.text(tx, (y1 + y2) / 2 + size * 0.35, label, size, an, weight="bold" if bold else "normal", raw=True)
    def hdim(s, x1, x2, h, label, size=22, ext_from=None, below=True, bold=False):
        Y = s.Y(h); X1, X2 = s.X(x1), s.X(x2)
        if ext_from is not None:
            for x in (x1, x2):
                s.line(x, ext_from, x, h, stroke=C["grey"], sw=0.8, dash="3 4")
        s.add(f'<line x1="{X1:.1f}" y1="{Y:.1f}" x2="{X2:.1f}" y2="{Y:.1f}" stroke="{C["ink"]}" stroke-width="1.4"/>')
        for x in (X1, X2):
            s.add(f'<line x1="{x-6:.1f}" y1="{Y+6:.1f}" x2="{x+6:.1f}" y2="{Y-6:.1f}" stroke="{C["ink"]}" stroke-width="1.6"/>')
        s.text((X1 + X2) / 2, Y + size + 4 if below else Y - 7, label, size, "middle", weight="bold" if bold else "normal", raw=True)
    def label(s, x, h, title, lines=(), tsize=22, size=19, width=31, color=None):
        """blocco testo a destra del disegno, centrato verticalmente su h"""
        wl = []
        for l in lines: wl += wrap(l, width)
        n = 1 + len(wl); lh = size * 1.3
        y0 = s.Y(h) - (n * lh) / 2 + tsize * 0.85
        s.text(s.X(x), y0, title, tsize, weight="bold", fill=color or C["blue"], raw=True)
        for i, l in enumerate(wl):
            s.text(s.X(x), y0 + tsize * 0.3 + (i + 1) * lh, l, size, fill=C["ink"], raw=True)
    def out(s, path):
        W = s.ml + s.c["W_draw"] + s.mr; H = s.mt + s.c["H"] + s.mb
        head = (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W:.0f} {H:.0f}" width="{W*s.scale:.0f}" height="{H*s.scale:.0f}" '
                f'font-family="DejaVu Sans, Arial, Helvetica, sans-serif">'
                f'<defs><pattern id="peg" width="25" height="25" patternUnits="userSpaceOnUse"><circle cx="12.5" cy="12.5" r="2.3" fill="#B9B2A3"/></pattern>'
                f'<pattern id="hatch" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)"><line x1="0" y1="0" x2="0" y2="8" stroke="#B8C0CC" stroke-width="1.5"/></pattern></defs>'
                f'<rect width="{W:.0f}" height="{H:.0f}" fill="#FFFFFF"/>')
        open(path, "w", encoding="utf-8").write(head + "\n".join(s.o) + "</svg>")

def title_block(cv, c, vista, extra):
    W = c["W_draw"]
    cv.text(-cv.ml + 30, cv.mt - 100, "ESPOSITORE ZENIT - " + c["name"], 34, weight="bold", fill=C["blue"], raw=True) if False else None
    cv.text(30, cv.mt - 95, "ESPOSITORE ZENIT  |  " + c["name"], 34, weight="bold", fill=C["blue"], raw=True)
    cv.text(30, cv.mt - 55, f"{vista}  |  quote in mm  |  schema per preventivo, ipotesi da confermare", 21, fill=C["grey"], raw=True)
    fl = cv.Y(0)
    y = fl + 205
    cv.text(30, y, f"Capacita' indicativa per faccia: {c['brush_cap']} pennelli in blister + {c['rolls_face']} rulli", 21, weight="bold", fill=C["ink"], raw=True)
    if c["faces"] == 2:
        cv.text(30, y + 30, f"Totale 2 facce: {2*c['brush_cap']} pennelli + {2*c['rolls_face']} rulli", 21, weight="bold", fill=C["ink"], raw=True)
    y += 30 if c["faces"] == 2 else 0
    cv.text(30, y + 30, extra, 19, fill=C["grey"], raw=True)
    y += 0
    for i, (col, nm) in enumerate([(C["blue"], "blu brand (placeholder)"), (C["orange"], "arancio brand (placeholder)"), (C["sand"], "sabbia neutro")]):
        x = 30 + i * 330
        cv.add(f'<rect x="{x}" y="{y+48:.0f}" width="26" height="26" fill="{col}" stroke="{C["grey"]}" stroke-width="1"/>')
        cv.text(x + 36, y + 68, nm, 19, fill=C["ink"], raw=True)

# ----------------------------------------------------------------- VISTA FRONTALE
def front(c, path):
    c["W_draw"] = c["W"]
    W, H, base = c["W"], c["H"], c["base"]
    cv = Cv(c, 400, 470, 190, 370, 0.9)
    n = len(c["trays"]); upr = c["upr"]
    tray_top = base + n * c["tray_pitch"]
    promo_top = tray_top + c["promo"]
    peg_top = promo_top + c["peg_h"]
    hdr_bot = H - c["header"]
    cv.line(-60, 0, W + 60, 0, sw=2.5)                                   # pavimento
    cv.rect(0, base, W, hdr_bot - base, fill=C["sand"], stroke=C["ink"], sw=1.5)   # corpo
    cv.rect(upr, promo_top, W - 2 * upr, c["peg_h"], fill="url(#peg)")           # pannello forato
    cv.rect(upr, promo_top, W - 2 * upr, c["peg_h"], stroke=C["grey"], sw=1)
    # --- fascia promo + tasche
    if c["promo"]:
        cv.rect(upr, tray_top, W - 2 * upr, c["promo"], fill=C["white"], stroke=C["grey"], sw=1)
        cv.text(upr + 14, tray_top + c["promo"] - 38, "SCEGLI IL RULLO", c["plabel"][0] - 2, weight="bold", fill=C["blue"])
        cv.text(upr + 14, tray_top + c["promo"] - 62, "per la tua superficie", c["plabel"][1], fill=C["ink"])
        for k, (col, nm) in enumerate([("#3850A2", "LISCE"), ("#2E8B8B", "POCO R."), ("#E8731A", "RUVIDE"), ("#B23A2E", "MOLTO R.")]):
            bx = upr + 14 + k * 47
            cv.rect(bx, tray_top + 22, 43, 36, fill=col, rx=4)
            for d_ in range(3):
                cv.circ(bx + 10 + d_ * 11.5, tray_top + 40, 4.2 if d_ <= k - 1 else 1.8, fill=C["white"])
            cv.text(bx + 21.5, tray_top + 8, nm, 8, "middle", fill=C["ink"], weight="bold")
        for j in range(2):
            px = W - upr - 20 - 100 * (2 - j) - 10 * (1 - j) + 0
            cv.rect(px + 6, tray_top + 60, 88, 90, fill=C["white"], stroke=C["grey"], sw=1)             # depliant che sporge
            cv.rect(px + 6, tray_top + 132, 88, 18, fill=C["orange"] if j else C["blue"])
            cv.rect(px, tray_top + 10, 100, 80, fill="#D9E3F2", stroke=C["ink"], sw=1.2, extra='fill-opacity="0.55"')
    # --- vaschette rulli
    for i, L in enumerate(c["trays"]):
        hb = tray_hb(c, i); ac = c["across"][i]
        x0 = upr + (c["usable_w"] - (ac * L + (ac - 1) * c["roller_gap"])) / 2
        for row in reversed(range(c["rows"])):
            _, yc = roller_ycs(c, i, row)
            for k in range(ac):
                x = x0 + k * (L + c["roller_gap"])
                cv.rect(x, yc - c["r"], L, c["roller_d"], fill=C["sleeve"], stroke=C["ink"], sw=1.1, rx=9)
                cv.rect(x + L * 0.25, yc - c["r"] + 12, L * 0.5, c["roller_d"] - 24, fill=C["blue"] if (i + k) % 2 == 0 else C["orange"], rx=3, extra='fill-opacity="0.9"')
                cv.rect(x, yc - c["r"], 9, c["roller_d"], fill="#C9BFA6", stroke=C["ink"], sw=1.0, rx=4)
                cv.rect(x + L - 9, yc - c["r"], 9, c["roller_d"], fill="#C9BFA6", stroke=C["ink"], sw=1.0, rx=4)
        cv.rect(upr, hb, c["usable_w"], c["lip_h"], fill=C["white"], stroke=C["ink"], sw=1.3)     # sponda
        cv.rect(upr, hb, c["usable_w"], 5, fill=C["blue"])
        cv.rect(upr + 4, hb + 6, 26, 26, fill="url(#hatch)", stroke=C["ink"], sw=1)             # campione di pelo/texture applicato
        nt = int((c["usable_w"] - 40) // 80)
        for k in range(nt):                                                                      # cartellini prezzo
            tx = upr + 40 + (c["usable_w"] - 40 - nt * 80) / 2 + k * 80 + 8
            cv.rect(tx, hb + 9, 64, 20, fill="#FFF3B0", stroke=C["grey"], sw=0.8, rx=2)
            cv.text(tx + 32, hb + 14, "€", 15, "middle", fill=C["ink"], weight="bold")
        # etichetta a destra
        cv.line(W, hb + 60, W + 12, hb + 60, stroke=C["grey"], sw=1)
        cv.label(W + 18, hb + c["tray_pitch"] / 2 - 4, f"Vaschetta {i+1}: {TRAYNAMES[L]}",
                 [f"{ac} affiancati x {c['rows']} file = {c['roller_cap'][i]} pz"], tsize=21, size=19, width=34)
    # --- ganci e blister
    hk = c["hooks"]; x0 = upr + (c["usable_w"] - hk * c["hook_pitch"]) / 2
    for r_ in range(c["pegrows"]):
        bt = peg_top - 10 - r_ * c["row_p"]
        col = C["blue"] if r_ % 2 == 0 else C["orange"]
        for k in range(hk):
            cx = x0 + k * c["hook_pitch"] + c["hook_pitch"] / 2
            bx = cx - c["blister_w"] / 2
            cv.rect(bx, bt - c["blister_h"], c["blister_w"], c["blister_h"], fill=C["white"], stroke=C["grey"], sw=1.1, rx=3)
            cv.rect(bx, bt - 30, c["blister_w"], 30, fill=col, rx=3)
            cv.rect(cx - 7, bt - 112, 14, 62, fill=C["wood"], rx=5)                  # manico
            cv.rect(cx - 17, bt - 132, 34, 22, fill="#AEB6C2", stroke=C["grey"], sw=0.8)  # ghiera
            cv.rect(cx - 19, bt - 168 + 20, 38, 36, fill=C["bristle"], stroke=C["grey"], sw=0.8, rx=2)  # setole
            cv.circ(cx, bt - 14, 4, fill=C["ink"])                                    # gancio
            cv.rect(cx - 30, bt - c["blister_h"] - 26, 60, 20, fill="#FFF3B0", stroke=C["grey"], sw=0.8, rx=2)
            cv.text(cx, bt - c["blister_h"] - 21, "€", 15, "middle", weight="bold")
        mid = bt - c["row_p"] / 2 + 4 if False else bt - c["blister_h"] / 2
        cv.line(W, mid, W + 12, mid, stroke=C["grey"], sw=1)
        cv.label(W + 18, mid, f"Riga {r_+1}: {ROWNAMES[r_]}", [f"{hk} ganci x {c['blister_per_hook']} blister = {hk*c['blister_per_hook']} pz"], tsize=21, size=19, width=34)
    if c["promo"]:
        m = tray_top + c["promo"] / 2
        cv.line(W, m, W + 12, m, stroke=C["grey"], sw=1)
        cv.label(W + 18, m, "Fascia grafica + 2 tasche", ["portadepliant formato DL (99x210), visibile h 140"], tsize=21, size=19, width=34)
    # --- testata
    cv.rect(0, hdr_bot, W, c["header"], fill=C["blue"], stroke=C["ink"], sw=1.5)
    lw, lh = c["logo"]
    cv.rect(c["upr"] + 5, hdr_bot + (c["header"] - lh) / 2, lw, lh, fill=C["white"], stroke=C["white"], sw=2.5, rx=8)
    ih = lh - 12; iw = ih * 2000 / 1040
    if iw > lw - 12: iw = lw - 12; ih = iw * 1040 / 2000
    cv.add(f'<image x="{cv.X(c["upr"] + 5 + (lw - iw) / 2):.1f}" y="{cv.Y(hdr_bot + (c["header"] + ih) / 2):.1f}" width="{iw:.1f}" height="{ih:.1f}" href="{LOGO_URI}"/>')
    tx = c["upr"] + 5 + lw + 22
    if c["faces"] == 2:
        qx = W - c["upr"] - 70; qy = hdr_bot + c["header"] - 86
        cv.rect(qx, qy, 62, 62, fill=C["white"], stroke=C["white"], sw=1)
        cv.text(qx + 31, qy + 28, "QR", 20, "middle", fill=C["ink"], weight="bold")
        cv.text(qx + 31, qy + 8, "guida scelta", 9, "middle", fill=C["ink"])
    cv.text(tx, hdr_bot + c["header"] / 2 - 4, "PENNELLI", c["h1"], fill=C["white"], weight="bold")
    cv.text(tx, hdr_bot + c["header"] / 2 - 4 - c["h1"] - 6, "E RULLI", c["h1"], fill=C["white"], weight="bold")
    cv.text(tx, hdr_bot + c["header"] / 2 - 2 * c["h1"] - 22, "per ogni superficie.", c["h2"], fill="#FFD9A0")
    m = hdr_bot + c["header"] / 2
    cv.line(W, m, W + 12, m, stroke=C["grey"], sw=1)
    cv.label(W + 18, m, "Testata (esempio headline)", [f"Pannello grafico {W} x {c['header']}, logo Zenit in alto a sinistra. Stampa fronte e retro (faccia B uguale o diversa)."] if c["faces"] == 2 else [f"Pannello grafico {W} x {c['header']}, logo Zenit a sinistra."], tsize=21, size=19, width=34)
    # --- base
    cv.rect(0, 0, W, base, fill="#3A4558", stroke=C["ink"], sw=1.5)
    cv.line(0, base / 2, W, base / 2, stroke="#8791A3", sw=1, dash="6 5") if base > 60 else None
    if base >= 100:
        cv.text(W / 2, base / 2 + 22, "SCORTA (sportello) + BASE", 18, "middle", fill=C["white"], weight="bold")
        cv.text(W / 2, base / 2 - 24, "scorta integrata, piedini / ruote opz.", 17, "middle", fill="#D8DEE8")
    cv.line(W, base / 2, W + 12, base / 2, stroke=C["grey"], sw=1)
    cv.label(W + 18, base / 2 - (0 if base >= 100 else 45), f"Base {W} x {c['D']} x {base}", ["Zona bassa = scorta ad alta rotazione dietro sportello chiudibile; zavorrata, antiribaltamento; ruote Ø60 opz." if base >= 100 else "Zoccolo zavorrato con piedini antiscivolo in gomma."], tsize=21, size=19, width=34)
    # --- quote
    xo = -60
    segs = [(0, base)]
    segs += [(base, tray_top)]
    if c["promo"]: segs += [(tray_top, promo_top)]
    segs += [(promo_top, peg_top), (hdr_bot, H)]
    if abs(peg_top - hdr_bot) > 0.5: segs.insert(-1, (peg_top, hdr_bot))
    for a_, b_ in segs:
        cv.vdim(xo, a_, b_, f"{b_-a_:.0f}", ext_to=0)
    cv.vdim(-175, 0, H, f"{H} totale", bold=True, ext_to=0)
    cv.hdim(0, W, -85, f"{W}", bold=True, ext_from=0)
    cv.hdim(0, upr, -85 - 0, "", ext_from=None) if False else None
    title_block(cv, c, "VISTA FRONTALE (faccia A)", "Prodotti disegnati a scopo illustrativo; misure confezioni e referenze reali da confermare. Retro: " + ("faccia B speculare." if c["faces"] == 2 else "non prevista (faccia singola, appoggio a parete/banco)."))
    cv.out(path)

# ----------------------------------------------------------------- VISTA LATERALE
def side(c, path):
    c["W_draw"] = c["D"]
    D, H, base = c["D"], c["H"], c["base"]
    cv = Cv(c, 400, 470, 190, 370, 0.9)
    n = len(c["trays"])
    tray_top = base + n * c["tray_pitch"]
    promo_top = tray_top + c["promo"]
    peg_top = promo_top + c["peg_h"]
    hdr_bot = H - c["header"]
    xs, sp, faces = c["xs"], c["spine"], c["faces"]
    mx = lambda x, f: x if f == 0 else D - x
    def mrect(x1, x2, h, hh, f, **kw):
        a_, b_ = sorted((mx(x1, f), mx(x2, f))); cv.rect(a_, h, b_ - a_, hh, **kw)
    def mpoly(pts, f, **kw): cv.poly([(mx(x, f), h) for x, h in pts], **kw)
    def mline(x1, h1, x2, h2, f, **kw): cv.line(mx(x1, f), h1, mx(x2, f), h2, **kw)
    def mcirc(x, h, f, *a, **kw): cv.circ(mx(x, f), h, *a, **kw)
    cv.line(-60, 0, D + 60, 0, sw=2.5)
    # base + ruote opzionali
    cv.rect(0, 0, D, base, fill="#3A4558", stroke=C["ink"], sw=1.5)
    if base >= 100:
        for xw in (50, D - 50): cv.circ(xw, 30, 30, stroke="#E8EDF5", sw=1.8, dash="6 4")
        cv.line(0, 60, D, 60, stroke="#8791A3", sw=1, dash="6 5")
    # montante centrale
    sx0 = xs if faces == 2 else xs
    cv.rect(xs, base, sp, hdr_bot - base, fill="#E7E2D6", stroke=C["ink"], sw=1.5)
    for h in range(int(promo_top), int(peg_top), 25): cv.circ(xs + sp / 2, h + 12, 2, fill="#8E887A")
    # testata
    hx0 = (D / 2 - c["hdr_t"] / 2) if faces == 2 else D - c["hdr_t"]
    cv.rect(hx0, hdr_bot, c["hdr_t"], c["header"], fill=C["blue"], stroke=C["ink"], sw=1.5)
    cv.rect(hx0, H - 8, c["hdr_t"], 8, fill=C["orange"])
    # vaschette, rulli
    for f in range(faces):
        for i, L in enumerate(c["trays"]):
            hb = tray_hb(c, i); d = c["tray_d"]; xf = c["inset"]; t = c["tray_t"]; dh = d * math.tan(c["a"])
            mpoly([(xf, hb), (xf + d, hb), (xf + d, hb + dh)], f, fill="url(#hatch)", stroke=C["grey"], sw=0.8)
            mpoly([(xf, hb), (xf + d, hb + dh), (xf + d, hb + dh + t), (xf, hb + t)], f, fill=C["blue"], stroke=C["ink"], sw=1)
            mrect(xf, xf + 5, hb, c["lip_h"], f, fill=C["white"], stroke=C["ink"], sw=1.2)
            mrect(xf - 2, xf + 7, hb + 8, 18, f, fill="#FFF3B0", stroke=C["grey"], sw=0.8) if False else None
            for row in range(c["rows"]):
                xc, yc = roller_ycs(c, i, row)
                mcirc(xc, yc, f, c["r"], fill=C["sleeve"], stroke=C["ink"], sw=1.3)
                mcirc(xc, yc, f, 11, fill="#C9BFA6", stroke=C["ink"], sw=1)
    # ganci e blister
    for f in range(faces):
        for r_ in range(c["pegrows"]):
            bt = peg_top - 10 - r_ * c["row_p"]; hy = bt - 14
            hx = xs - c["hook_len"]
            mline(xs, hy, hx, hy, f, sw=3.2, stroke=C["ink"])
            mline(hx, hy, hx - 2, hy + 9, f, sw=3.2, stroke=C["ink"])
            for j in range(c["blister_per_hook"]):
                bx = xs - 18 - j * (c["blister_t"] + 2)
                mrect(bx - c["blister_t"] / 2, bx + c["blister_t"] / 2, bt - c["blister_h"], c["blister_h"], f,
                      fill=C["white"] if j else "#FFFFFF", stroke=C["grey"], sw=0.9)
            mrect(xs - 18 - 7 * 14 - 6, xs - 18 + 6, bt - 30, 30, f, fill=C["blue"] if r_ % 2 == 0 else C["orange"], extra='fill-opacity="0.85"') if False else None
    # tasche portadepliant
    if c["promo"]:
        for f in range(faces):
            pb = tray_top + 14
            mpoly([(xs, pb), (xs - 40, pb), (xs - 40, pb + 12), (xs, pb + 100)], f, fill="#D9E3F2", stroke=C["ink"], sw=1.2)
            mrect(xs - 28, xs - 8, pb + 20, 120, f, fill=C["white"], stroke=C["grey"], sw=1)
    # quote verticali
    xo = -60
    segs = [(0, base), (base, tray_top)]
    if c["promo"]: segs.append((tray_top, promo_top))
    segs += [(promo_top, peg_top), (peg_top, hdr_bot), (hdr_bot, H)]
    for a_, b_ in segs:
        if b_ - a_ > 0.5: cv.vdim(xo, a_, b_, f"{b_-a_:.0f}")
    cv.vdim(-175, 0, H, f"{H} totale", bold=True)
    # quote orizzontali (profondita')
    fl = 0
    d, inset = c["tray_d"], c["inset"]
    if faces == 2:
        cv.hdim(0, inset, -45, f"{inset}", size=18, ext_from=0)
        cv.hdim(inset, xs, -45, f"{d:.0f}", size=20, ext_from=0)
        cv.hdim(xs, xs + sp, -45, f"{sp}", size=18, ext_from=0)
        cv.hdim(xs + sp, D - inset, -45, f"{d:.0f}", size=20, ext_from=0)
        cv.hdim(D - inset, D, -45, f"{inset}", size=18, ext_from=0)
    else:
        cv.hdim(0, inset, -45, f"{inset}", size=18, ext_from=0)
        cv.hdim(inset, xs, -45, f"{d:.0f}", size=20, ext_from=0)
        cv.hdim(xs, D, -45, f"{sp}", size=18, ext_from=0)
    cv.hdim(0, D, -105 - (30 if faces == 2 else 0), f"{D} profondita'", bold=True, ext_from=-45)
    # callout laterali
    R = D + 18
    def lab(h, title, lines, y=None):
        cv.line(D + 2, h, D + 14, h, stroke=C["grey"], sw=1)
        cv.label(R, h if y is None else y, title, lines, tsize=21, size=19, width=34)
    lab(H - c["header"] / 2, "Testata", [f"spessore {c['hdr_t']}, pannello stampato" + (" fronte/retro" if faces == 2 else "")])
    lab(peg_top - c["row_p"] / 2, "Ganci su pannello forato", [f"asta Ø5 x L {c['hook_len']}, passo verticale {c['row_p']:.0f}; {c['blister_per_hook']} blister (sp. {c['blister_t']}) per gancio"])
    if c["promo"]: lab(tray_top + c["promo"] / 2, "Tasca portadepliant", ["sporgenza 40, formato DL"])
    lab(base + c["tray_pitch"] * (n - 1) / 2 + 60, f"Vaschette x{n} per faccia", [f"inclinate {c['incl']}°, profondita' utile {d:.0f}, sponda h{c['lip_h']} con cartellino prezzo; {c['rows']} file di rulli"])
    lab(base / 2, "Base con scorta", [f"{D} x {base}; vano scorta con sportello; baricentro basso (verifica ribaltamento a carico del fornitore)." + (" Ruote Ø60 opz." if base >= 100 else " Piedini antiscivolo.")], y=None if base >= 100 else -45)
    title_block(cv, c, "VISTA LATERALE" + (" (sezione, entrambe le facce)" if faces == 2 else " (sezione)"), "Il montante centrale regge i ganci su entrambe le facce; le vaschette poggiano su un cuneo/struttura inclinata." if faces == 2 else "Il pannello posteriore regge ganci e vaschette; appoggio a parete o banco.")
    cv.out(path)

if __name__ == "__main__":
    for k, v in VARIANTI.items():
        c = derive(v)
        front(dict(c), os.path.join(HERE, f"espositore-{k}-frontale.svg"))
        side(dict(c), os.path.join(HERE, f"espositore-{k}-laterale.svg"))
        print(k, "rulli/vaschetta", c["roller_cap"], "file", c["rows"], "ganci/riga", c["hooks"],
              "pennelli/faccia", c["brush_cap"], "rulli/faccia", c["rolls_face"], "peg_h", c["peg_h"], "row_p", round(c["row_p"], 1))
