#!/usr/bin/env python3
"""Genera i disegni SVG quotati (frontale + laterale, mm) dell'espositore Zenit - nuovo layout.

Linguaggio ripreso dall'espositore attuale: struttura nera + pannello forato nero, testata bianca
con logo, fasce bianche a mensola con nome linea, pennelli NUDI appesi, rulli IN PIEDI in basso,
base nera con pannello web.  Miglioramenti: fasce con codice colore superficie (scala a 4 livelli),
guida alla scelta a livello occhi con QR, rulli in scomparti per misura con cartellino e campione di
pelo, scorta dietro sportello, testata intercambiabile, cartellini sotto ogni gancio.

TUTTE le misure sono IPOTESI parametriche: modificare VARIANTI e rilanciare
    python3 genera_disegni.py && NODE_PATH=$(npm root -g) node render_png.js
La larghezza W e' un parametro (A=500 principale, A100=1000 come l'originale, B=banco).
"""
import os, base64, random
from textwrap import wrap

HERE = os.path.dirname(os.path.abspath(__file__))
C = dict(blue="#3850A2", ink="#1D2126", metal="#262B31", metal2="#3A4048", grey="#6F7A8A", light="#D5DAE2",
         white="#FFFFFF", wood="#D9B27C", wood2="#B98A52", bristle="#F0E4BF", sleeve="#F4F0E2", tag="#FFF3B0",
         ferr="#B9C0CA")
SCALE4 = [("#3850A2", "LISCE", "pelo corto 4-5 mm", "cartongesso, smalti"),
          ("#2E8B8B", "POCO RUVIDE", "pelo medio 10-12 mm", "intonaco civile fine"),
          ("#E8731A", "RUVIDE", "pelo lungo 18-20 mm", "intonaco rustico"),
          ("#B23A2E", "MOLTO RUVIDE", "pelo extra 24-28 mm", "facciate, cemento")]

with open(os.path.join(HERE, "..", "..", "brand", "logo-zenit-web.png"), "rb") as _f:
    LOGO_URI = "data:image/png;base64," + base64.b64encode(_f.read()).decode()

# ----------------------------------------------------------------- PARAMETRI (mm)
COMMON = dict(
    upr=20,            # spessore montanti/fianchi neri
    panel_t=20,        # spessore pannello posteriore forato
    hook_len=150, per_hook=3,        # gancio L150, fino a 3 pennelli nudi per gancio (IPOTESI)
    roller_d=65, roller_gap=4, roller_max=250,
    tray_h=400, rim_h=70, steps=5, step_rise=32, inset=10, wall=8,
    fascia_h=60, fascia_proj=60, guide_h=250,
    sizes=[20, 23, 25],
    web="www.pennellificiozenit.it",
)
VARIANTI = {
 "A":    dict(COMMON, code="A", name="Da terra 50 cm (principale)", W=500, D=400, H=2200, base=220,
             secs=[dict(h=360, line="DAKOTA", sub="smalti e rifinitura", up=(1, 2), long=300, rl=140),
                   dict(h=320, line="NONSTOP", sub="uso generale", up=(1, 2, 3, 4), long=250, rl=120)], guide=True),
 "A100": dict(COMMON, code="A100", name="Da terra 100 cm (come l'originale)", W=1000, D=400, H=2200, base=220,
             secs=[dict(h=360, line="DAKOTA", sub="smalti e rifinitura", up=(1, 2), long=300, rl=140),
                   dict(h=320, line="NONSTOP", sub="uso generale", up=(1, 2, 3, 4), long=250, rl=120)], guide=True,
             sizes=[20, 23, 25, 20, 23, 25]),
 "B":    dict(COMMON, code="B", name="Da banco 50 cm (ridotto)", W=500, D=400, H=1100, base=40,
             secs=[dict(h=380, line="NONSTOP", sub="uso generale", up=(1, 2, 3, 4), long=300, rl=150)], guide=False),
}

# ----------------------------------------------------------------- derivati
def derive(c):
    c = dict(c)
    uw = c["W"] - 2 * c["upr"]; c["uw"] = uw
    c["y0"] = c["base"] + 10                       # piano vasca (fronte)
    c["tray_top"] = c["base"] + c["tray_h"]
    c["rows"] = int((c["D"] - c["panel_t"] - c["inset"] - c["wall"] + c["roller_gap"]) // (c["roller_d"] + c["roller_gap"]))
    assert c["y0"] + (c["rows"] - 1) * c["step_rise"] + c["roller_max"] <= c["tray_top"] + 1, "rulli oltre la vasca"
    c["nc"] = len(c["sizes"]); c["cw"] = (uw - (c["nc"] + 1) * 4) / c["nc"]
    c["across"] = int((c["cw"] + c["roller_gap"]) // (c["roller_d"] + c["roller_gap"]))
    c["roll_cap"] = c["nc"] * c["across"] * c["rows"]
    z = c["tray_top"]; zones = []
    zones.append(("rulli", z, z + c["fascia_h"], None)); z += c["fascia_h"]      # fascia RULLI (sopra la vasca)
    for s in c["secs"]:
        zones.append(("sec", z, z + s["h"], s)); z += s["h"]
        zones.append(("fascia", z, z + c["fascia_h"], s)); z += c["fascia_h"]
        # geometria ganci
        lw = int(0.42 * uw); s["nl"] = int(lw // 38); s["lx"] = 0; s["lw"] = s["nl"] * 38
        rw = uw - s["lw"] - 14 - 20; s["rw"] = rw
        s["nu"] = int(rw // 112); s["nd"] = int(rw // 78)
        s["pos"] = s["nl"] + s["nu"] + s["nd"]; s["cap"] = s["pos"] * c["per_hook"]
        assert 71 + 2 * s["rl"] <= s["h"], "sezione troppo bassa per le due file"
        assert 15 + s["long"] + 24 <= s["h"], "pennello lungo non entra"
    c["guide_y"] = None
    if c["guide"]:
        c["guide_y"] = (z, z + c["guide_h"]); z += c["guide_h"]
    c["hdr_bot"] = z; c["header"] = c["H"] - z
    assert c["header"] >= 150, "testata troppo bassa"
    c["zones"] = zones
    c["brush_pos"] = sum(s["pos"] for s in c["secs"]); c["brush_cap"] = c["brush_pos"] * c["per_hook"]
    return c

# ----------------------------------------------------------------- helper SVG
class Cv:
    def __init__(s, c, ml, mr, mt, mb, scale):
        s.c, s.ml, s.mr, s.mt, s.mb, s.scale, s.o = c, ml, mr, mt, mb, scale, []
    def X(s, x): return s.ml + x
    def Y(s, h): return s.mt + s.c["H"] - h
    def add(s, t): s.o.append(t)
    def rect(s, x, h, w, hh, fill="none", stroke="none", sw=1.5, rx=0, extra=""):
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
    def vdim(s, x, h1, h2, label, size=22, ext_to=0, bold=False):
        X, y1, y2 = s.X(x), s.Y(h1), s.Y(h2)
        for h in (h1, h2): s.line(ext_to, h, x, h, stroke=C["grey"], sw=0.8, dash="3 4")
        s.add(f'<line x1="{X:.1f}" y1="{y1:.1f}" x2="{X:.1f}" y2="{y2:.1f}" stroke="{C["ink"]}" stroke-width="1.4"/>')
        for y in (y1, y2):
            s.add(f'<line x1="{X-6:.1f}" y1="{y+6:.1f}" x2="{X+6:.1f}" y2="{y-6:.1f}" stroke="{C["ink"]}" stroke-width="1.6"/>')
        s.text(X - 9, (y1 + y2) / 2 + size * 0.35, label, size, "end", weight="bold" if bold else "normal", raw=True)
    def hdim(s, x1, x2, h, label, size=22, ext_from=None, bold=False):
        Y = s.Y(h); X1, X2 = s.X(x1), s.X(x2)
        if ext_from is not None:
            for x in (x1, x2): s.line(x, ext_from, x, h, stroke=C["grey"], sw=0.8, dash="3 4")
        s.add(f'<line x1="{X1:.1f}" y1="{Y:.1f}" x2="{X2:.1f}" y2="{Y:.1f}" stroke="{C["ink"]}" stroke-width="1.4"/>')
        for x in (X1, X2):
            s.add(f'<line x1="{x-6:.1f}" y1="{Y+6:.1f}" x2="{x+6:.1f}" y2="{Y-6:.1f}" stroke="{C["ink"]}" stroke-width="1.6"/>')
        s.text((X1 + X2) / 2, Y + size + 4, label, size, "middle", weight="bold" if bold else "normal", raw=True)
    def callouts(s, xr, items, tsize=21, size=18, width=36, gap=14):
        """etichette a destra, ordinate per quota e distanziate automaticamente; items=(h, titolo, [righe])"""
        blocks = []
        for h, title, lines in items:
            wl = []
            for l in lines: wl += wrap(l, width)
            lh = size * 1.3; ht = tsize * 1.25 + len(wl) * lh
            blocks.append([s.Y(h), title, wl, ht, 0.0])
        blocks.sort(key=lambda b: b[0])
        cur = -1e9
        for b in blocks:
            top = max(b[0] - b[3] / 2, cur + gap); b[4] = top; cur = top + b[3]
        for yh, title, wl, ht, top in blocks:
            s.add(f'<polyline points="{s.X(xr)-26:.1f},{yh:.1f} {s.X(xr)-10:.1f},{yh:.1f} {s.X(xr)-2:.1f},{top+tsize*0.6:.1f}" fill="none" stroke="{C["grey"]}" stroke-width="1"/>')
            s.text(s.X(xr), top + tsize * 0.9, title, tsize, weight="bold", fill=C["blue"], raw=True)
            for i, l in enumerate(wl):
                s.text(s.X(xr), top + tsize * 1.25 + (i + 1) * size * 1.3 - 3, l, size, raw=True)
    def out(s, path):
        W = s.ml + s.c["W_draw"] + s.mr; H = s.mt + s.c["H"] + s.mb
        rnd = random.Random(7); qr = ""
        head = (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W:.0f} {H:.0f}" width="{W*s.scale:.0f}" height="{H*s.scale:.0f}" '
                f'font-family="DejaVu Sans, Arial, Helvetica, sans-serif">'
                f'<defs><pattern id="peg" width="25" height="25" patternUnits="userSpaceOnUse"><rect width="25" height="25" fill="#1D2126"/><circle cx="12.5" cy="12.5" r="2.4" fill="#4C535D"/></pattern>'
                f'<pattern id="hatch" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)"><line x1="0" y1="0" x2="0" y2="8" stroke="#B8C0CC" stroke-width="1.5"/></pattern>'
                f'<pattern id="fur" width="6" height="9" patternUnits="userSpaceOnUse"><line x1="1" y1="0" x2="1" y2="6" stroke="#CFC6A8" stroke-width="1"/><line x1="4" y1="3" x2="4" y2="9" stroke="#E4DCC2" stroke-width="1"/></pattern></defs>'
                f'<rect width="{W:.0f}" height="{H:.0f}" fill="#FFFFFF"/>')
        open(path, "w", encoding="utf-8").write(head + "\n".join(s.o) + "</svg>")

def chip(cv, x, h, lvl, w=34, hh=28, faded=False):
    """riquadro colore superficie con 3 puntini di rugosita' crescente (lvl 1..4: 0,1,2,3 puntini grandi)"""
    col = SCALE4[lvl - 1][0]
    op = ' fill-opacity="0.25"' if faded else ""
    cv.rect(x, h, w, hh, fill=col, rx=4, extra=op)
    for d_ in range(3):
        cv.circ(x + w * 0.22 + d_ * w * 0.28, h + hh / 2, hh * (0.17 if d_ < lvl - 1 else 0.08), fill=C["white"] if not faded else "#999")

def fake_qr(cv, x, h, size, seed=3):
    """QR SEGNAPOSTO (non scansionabile): solo per mostrare ingombro e posizione"""
    n = 21; u = size / n; rnd = random.Random(seed)
    cv.rect(x, h, size, size, fill=C["white"], stroke=C["ink"], sw=1)
    def finder(cx, cy):
        cv.rect(x + cx * u, h + (n - cy - 7) * u, 7 * u, 7 * u, fill=C["ink"])
        cv.rect(x + (cx + 1) * u, h + (n - cy - 6) * u, 5 * u, 5 * u, fill=C["white"])
        cv.rect(x + (cx + 2) * u, h + (n - cy - 5) * u, 3 * u, 3 * u, fill=C["ink"])
    for i in range(n):
        for j in range(n):
            if (i < 8 and j < 8) or (i > n - 9 and j < 8) or (i < 8 and j > n - 9): continue
            if rnd.random() < .5: cv.rect(x + i * u, h + (n - 1 - j) * u, u, u, fill=C["ink"])
    finder(0, n - 7); finder(n - 7, n - 7); finder(0, 0)

def brush(cv, cx, top, w, L, kind):
    """pennello NUDO appeso (setole in basso), top = quota del foro del manico"""
    wood = C["wood"]
    if kind == "long":                    # pennello lungo/radiatore
        hl, hw, fh, bh = L * 0.60, 13, L * 0.08, L * 0.30
        cv.rect(cx - hw / 2, top - hl, hw, hl, fill=wood, stroke=C["wood2"], sw=0.8, rx=5)
        cv.rect(cx - w / 2 + 2, top - hl - fh, w - 4, fh, fill=C["ferr"], stroke=C["grey"], sw=0.8)
        cv.rect(cx - w / 2 + 1, top - L, w - 2, bh, fill=C["bristle"], stroke=C["grey"], sw=0.8, rx=2)
        cv.rect(cx - w / 2 + 1, top - L, w - 2, bh, fill="url(#fur)")
    elif kind == "soffitto":              # pennellessa da soffitto: testa larga, manico corto
        hl, hw, fh, bh = L * 0.36, 16, L * 0.10, L * 0.54
        cv.rect(cx - hw / 2, top - hl, hw, hl, fill=wood, stroke=C["wood2"], sw=0.8, rx=6)
        cv.rect(cx - w / 2 + 3, top - hl - fh, w - 6, fh, fill=C["ferr"], stroke=C["grey"], sw=0.8)
        cv.rect(cx - w / 2 + 1, top - L, w - 2, bh, fill=C["bristle"], stroke=C["grey"], sw=0.8, rx=2)
        cv.rect(cx - w / 2 + 1, top - L, w - 2, bh, fill="url(#fur)")
    else:                                 # piatto/tondo medio
        hl, hw, fh, bh = L * 0.50, 15, L * 0.10, L * 0.40
        cv.rect(cx - hw / 2, top - hl, hw, hl, fill=wood, stroke=C["wood2"], sw=0.8, rx=6)
        cv.rect(cx - w / 2 + 2, top - hl - fh, w - 4, fh, fill=C["ferr"], stroke=C["grey"], sw=0.8)
        cv.rect(cx - w / 2 + 1, top - L, w - 2, bh, fill=C["bristle"], stroke=C["grey"], sw=0.8, rx=2)
        cv.rect(cx - w / 2 + 1, top - L, w - 2, bh, fill="url(#fur)")
    cv.circ(cx, top - 7, 3.2, fill="#2A2F36")                      # foro del manico
    cv.circ(cx, top + 1, 3.2, fill="#8C939E")                      # gancio
    tw = min(w + 4, 44) if kind == "long" else 46
    cv.rect(cx - tw / 2, top - L - 24, tw, 18, fill=C["tag"], stroke=C["grey"], sw=0.7, rx=2)
    cv.text(cx, top - L - 24 + 4.5, "€", 12, "middle", weight="bold")

def fascia_front(cv, c, y, name, sub, chips, big=True):
    upr, uw = c["upr"], c["uw"]
    cv.rect(upr - 6, y + 2, uw + 12, c["fascia_h"] - 4, fill=C["white"], stroke=C["grey"], sw=1.2)
    cv.rect(upr - 6, y + 2, uw + 12, 4, fill=C["blue"])
    if name == "RULLI":
        cv.text(upr + 12, y + 28, "RULLI", 34, weight="bold", fill=C["blue"])
        cv.text(upr + 12, y + 12, "scegli per superficie e misura", 15, fill=C["ink"])
    else:
        cv.text(upr + 12, y + 33, "LINEA", 14, weight="bold", fill=C["grey"])
        cv.text(upr + 62, y + 28, name, 34, weight="bold", fill=C["blue"])
        cv.text(upr + 12, y + 12, sub, 15, fill=C["ink"])
    x0 = upr + uw - 12 - 4 * 38
    for k in range(4):
        chip(cv, x0 + k * 38, y + 16, k + 1, faded=(k + 1) not in chips)

# ----------------------------------------------------------------- VISTA FRONTALE
def front(c, path):
    c["W_draw"] = c["W"]
    W, H, base, upr, uw = c["W"], c["H"], c["base"], c["upr"], c["uw"]
    cv = Cv(c, 400, 480, 190, 400, 0.9)
    cv.line(-60, 0, W + 60, 0, sw=2.5)
    # struttura nera e pannello forato
    cv.rect(0, base, W, H - base, fill=C["metal"], stroke=C["ink"], sw=1.5)
    cv.rect(upr, c["tray_top"], uw, c["hdr_bot"] - c["tray_top"], fill="url(#peg)")
    # ---- vasca rulli a gradini, scomparti per misura
    y0 = c["y0"]; cw = c["cw"]; ac = c["across"]; rows = c["rows"]
    cv.rect(upr, y0 - 2, uw, c["tray_top"] - y0 + 2, fill="#14171B")
    for i, L in enumerate(c["sizes"]):
        x0 = upr + 4 + i * (cw + 4)
        cv.rect(x0, y0, cw, c["tray_top"] - y0, fill="#2A2F36")
        bx = x0 + (cw - (ac * c["roller_d"] + (ac - 1) * c["roller_gap"])) / 2
        for k in reversed(range(rows)):
            fy = y0 + c["rim_h"] * 0 + k * c["step_rise"]
            for a in range(ac):
                rx = bx + a * (c["roller_d"] + c["roller_gap"]); lvl = (i * ac + a) % 4 + 1
                sh = 0.0 + k * 0.0
                cv.rect(rx, fy, c["roller_d"], L * 10, fill="none") if False else None
                Lm = L * 10
                cv.rect(rx, fy, c["roller_d"], Lm, fill=C["sleeve"], stroke=C["ink"], sw=1, rx=9)
                cv.rect(rx, fy, c["roller_d"], Lm, fill="url(#fur)", rx=9)
                cv.rect(rx, fy + Lm - 16, c["roller_d"], 16, fill=SCALE4[lvl - 1][0], rx=7, extra='fill-opacity="0.9"')
                if k:
                    cv.rect(rx, fy, c["roller_d"], Lm, fill="#000", rx=9, extra=f'fill-opacity="{0.07 * k:.2f}"')
        # sponda anteriore con cartellino e campione di pelo
        cv.rect(x0, y0, cw, c["rim_h"], fill=C["white"], stroke=C["ink"], sw=1.2)
        cv.rect(x0, y0, cw, 5, fill=C["blue"])
        cv.text(x0 + 8, y0 + c["rim_h"] - 31, f"{L} cm", 28, weight="bold", fill=C["blue"])
        cv.rect(x0 + cw - 38, y0 + c["rim_h"] - 38, 30, 30, fill="#E9E2CB", stroke=C["ink"], sw=1, rx=3)
        cv.rect(x0 + cw - 38, y0 + c["rim_h"] - 38, 30, 30, fill="url(#fur)", rx=3)
        cv.rect(x0 + 8, y0 + 9, cw - 16, 22, fill=C["tag"], stroke=C["grey"], sw=0.8, rx=2)
        cv.text(x0 + cw / 2, y0 + 14, "€ 0,00", 15, "middle", weight="bold")
    # ---- zone sopra la vasca
    for kind, ya, yb, s in c["zones"]:
        if kind == "rulli": fascia_front(cv, c, ya, "RULLI", "", (1, 2, 3, 4))
        elif kind == "fascia": fascia_front(cv, c, ya, s["line"], s["sub"], s["up"])
        elif kind == "sec":
            top = yb; lx = upr + 8
            for k in range(s["nl"]):
                brush(cv, lx + 19 + k * 38, top - 15, 30, s["long"], "long")
            rx0 = upr + 8 + s["lw"] + 14 + 10
            hk1 = top - 15; hk2 = top - 47 - s["rl"]
            for k in range(s["nu"]): brush(cv, rx0 + 56 + k * 112, hk1, 100, s["rl"], "soffitto")
            for k in range(s["nd"]): brush(cv, rx0 + 39 + k * 78, hk2, 64, s["rl"], "piatto")
    # ---- guida alla scelta a livello occhi
    if c["guide"]:
        g0, g1 = c["guide_y"]
        cv.rect(upr - 6, g0 + 2, uw + 12, g1 - g0 - 4, fill=C["white"], stroke=C["grey"], sw=1.2)
        cv.rect(upr - 6, g1 - 6, uw + 12, 4, fill=C["blue"])
        cv.text(upr + 14, g1 - 40, "GUIDA ALLA SCELTA", 30, weight="bold", fill=C["blue"])
        cv.text(upr + 14, g1 - 60, "Quale rullo per la tua superficie?", 16)
        gw = min(uw - 130, 420)
        for k, (col, nm, pelo, ex) in enumerate(SCALE4):
            yy = g1 - 78 - 38 - k * 36
            chip(cv, upr + 14, yy, k + 1, w=40, hh=30)
            cv.text(upr + 64, yy + 18, nm, 17, weight="bold", fill=col)
            cv.text(upr + 64, yy + 3, f"{pelo} - {ex}", 12, fill=C["ink"])
        qs = 96
        fake_qr(cv, upr + uw - qs - 12, g0 + 38, qs)
        cv.text(upr + uw - qs / 2 - 12, g0 + 22, "Scansiona: guida", 12, "middle", weight="bold")
        cv.text(upr + uw - qs / 2 - 12, g0 + 10, "completa e prezzi", 12, "middle", weight="bold")
    # ---- testata
    hb, hh = c["hdr_bot"], c["header"]
    cv.rect(upr, hb, uw, hh, fill=C["white"], stroke=C["grey"], sw=1)
    cv.line(upr, hb, upr + uw, hb, stroke=C["blue"], sw=4)
    lw = min(uw * 0.72, 340) if hh >= 300 else 190; lh = lw * 1040 / 2000
    lcx = W / 2 if hh >= 300 else upr + 80 + lw / 2
    lcy = hb + hh * (0.60 if hh >= 300 else 0.55)
    cv.add(f'<image x="{cv.X(lcx - lw / 2):.1f}" y="{cv.Y(lcy + lh / 2):.1f}" width="{lw:.1f}" height="{lh:.1f}" href="{LOGO_URI}"/>')
    s_ = 30
    ix = upr + uw - 14 - 2 * s_ - 8; iy = H - 14 - s_
    cv.rect(ix, iy, s_, s_, fill="#C13584", rx=8); cv.circ(ix + s_ / 2, iy + s_ / 2, 7, stroke=C["white"], sw=2.2)
    cv.circ(ix + s_ * 0.76, iy + s_ * 0.78, 1.8, fill=C["white"])
    cv.rect(ix + s_ + 8, iy, s_, s_, fill="#1877F2", rx=8)
    cv.text(ix + s_ + 8 + s_ * 0.62, iy + 5, "f", 28, "middle", fill=C["white"], weight="bold")
    # bollino + bandiera
    bx, by = upr + 14 + 24, H - 14 - 24
    cv.circ(bx, by, 24, stroke=C["blue"], sw=2)
    cv.text(bx, by + 2, "MADE IN", 9, "middle", weight="bold", fill=C["blue"])
    cv.text(bx, by - 10, "ITALY", 11, "middle", weight="bold", fill=C["blue"])
    fx, fy = upr + 14, hb + 14
    for k, col in enumerate(["#009246", "#FFFFFF", "#CE2B37"]):
        cv.rect(fx + k * 13, fy, 13, 26, fill=col, stroke=C["grey"], sw=0.6)
    if hh >= 300:
        cv.text(W / 2, lcy - lh / 2 - 26, "PENNELLI E RULLI", 36, "middle", weight="bold", fill=C["blue"])
        cv.text(W / 2, lcy - lh / 2 - 54, "per ogni superficie", 22, "middle", fill=C["ink"])
        qs = 90
        fake_qr(cv, upr + uw - qs - 12, hb + 36, qs, seed=5)
        cv.text(upr + uw - qs / 2 - 12, hb + 22, "QR catalogo", 12, "middle", weight="bold")
        cv.text(upr + 60, hb + 14, c["web"], 16, fill=C["blue"], weight="bold")
    else:
        qs = 56
        fake_qr(cv, upr + uw - qs - 12, hb + 20, qs, seed=5)
        cv.text(upr + uw - 12 - qs / 2, hb + 10, "QR", 11, "middle", weight="bold")
        cv.text(upr + 80, hb + 12, c["web"], 13, fill=C["blue"], weight="bold")
    # ---- base con sportello e pannello web
    if base >= 150:
        cv.rect(upr + 6, 14, uw - 12, base - 28, fill="#14171B", stroke=C["metal2"], sw=1.2)
        cv.rect(upr + 20, 40, uw - 40, base - 80, fill=C["white"], stroke=C["grey"], sw=1)
        cv.text(W / 2, base / 2 - 8, c["web"], 22, "middle", fill=C["blue"], weight="bold")
        cv.circ(W - upr - 32, base - 26, 5, fill="#9AA3AF")           # serratura
        cv.text(W / 2, 24, "sportello scorta", 13, "middle", fill="#9AA3AF")
    else:
        cv.text(W / 2, base / 2 - 5, "zoccolo nero con piedini antiscivolo", 13, "middle", fill="#9AA3AF")
    for fx_ in (30, W - 30): cv.rect(fx_ - 10, -6, 20, 6, fill="#4A5059")
    # ---- quote verticali
    pts = [0, base, c["tray_top"]]
    for kind, ya, yb, s in c["zones"]: pts.append(yb)
    if c["guide"]: pts.append(c["guide_y"][1])
    pts = sorted(set(pts + [c["hdr_bot"], H]))
    for a_, b_ in zip(pts, pts[1:]): cv.vdim(-60, a_, b_, f"{b_-a_:.0f}")
    cv.vdim(-175, 0, H, f"{H} totale", bold=True)
    if c["guide"]:
        e0 = 1400; e1 = 1700
        cv.text(-30, e1 + 8, "140-170", 13, "end", fill="#E8731A", weight="bold")
        cv.line(-3, e0, -26, e0, stroke="#E8731A", sw=2); cv.line(-3, e1, -26, e1, stroke="#E8731A", sw=2)
        cv.add(f'<line x1="{cv.X(-14):.1f}" y1="{cv.Y(e0):.1f}" x2="{cv.X(-14):.1f}" y2="{cv.Y(e1):.1f}" stroke="#E8731A" stroke-width="5" opacity="0.5"/>')
    cv.hdim(0, W, -85, f"{W}", bold=True, ext_from=0)
    # ---- callouts
    items = []
    items.append((H - hh / 2, "Testata intercambiabile", [f"Pannello bianco {W-2*upr} x {hh}, inserto sfilabile dall'alto nei profili neri. Logo, Instagram/Facebook, QR, Made in Italy come l'originale."])) if True else None
    if c["guide"]:
        g0, g1 = c["guide_y"]
        items.append(((g0 + g1) / 2, "Guida alla scelta (occhi)", [f"{uw} x {g1-g0}, centro a {int((g0+g1)/2)} mm (da {g0} a {g1}). Scala 4 livelli + QR. Barra arancio = zona occhi 140-170 cm."]))
    for kind, ya, yb, s in c["zones"]:
        if kind == "fascia":
            items.append(((ya + yb) / 2, f"Fascia LINEA {s['line']}", [f"h {yb-ya}, aggetto {c['fascia_proj']}; uso '{s['sub']}' + colori superficie"]))
        elif kind == "sec":
            items.append(((ya + yb) / 2, f"Ganci {s['line']}: {s['pos']} posti", [f"{s['nl']} lunghi + {s['nu']} soffitto + {s['nd']} piatti, cartellino sotto ogni gancio; fino a {c['per_hook']} pz/gancio = {s['cap']} pz"]))
        elif kind == "rulli":
            items.append(((ya + yb) / 2, "Fascia RULLI", ["colori superficie come la guida"]))
    items.append(((c["y0"] + c["tray_top"]) / 2, f"Vasca rulli in piedi: {c['nc']} scomparti", [f"misure {'/'.join(str(x) for x in c['sizes'])} cm, {c['across']} x {c['rows']} file a gradini = {c['roll_cap']} rulli; sponda con prezzo e campione pelo"]))
    items.append((base / 2, f"Base e scorta {W} x {c['D']} x {base}" if base >= 150 else f"Zoccolo h {base}", ["sportello chiudibile con scorta, pannello bianco con indirizzo web"] if base >= 150 else ["piedini antiscivolo; non c'e' scorta (variante ridotta)"]))
    cv.callouts(W + 40, items)
    title_block(cv, c, "VISTA FRONTALE")
    cv.out(path)

def title_block(cv, c, vista):
    cv.text(30, cv.mt - 100, "ESPOSITORE ZENIT  |  " + c["name"], 34, weight="bold", fill=C["blue"], raw=True)
    cv.text(30, cv.mt - 62, f"{vista}  |  quote in mm  |  schema per preventivo: tutte le misure sono ipotesi da confermare", 20, fill=C["grey"], raw=True)
    y = cv.Y(0) + 190
    cv.text(30, y, f"Capacita' indicativa: {c['brush_pos']} posti gancio (fino a {c['brush_cap']} pennelli nudi) + {c['roll_cap']} rulli in piedi", 20, weight="bold", raw=True)
    cv.text(30, y + 28, "Struttura metallo nero + pannelli stampati. Lunghezza pennelli 15-30 cm,", 17, fill=C["grey"], raw=True)
    cv.text(30, y + 50, "rulli max 25 cm / Ø 6,5 cm: ipotesi. QR = segnaposto non scansionabile.", 17, fill=C["grey"], raw=True)
    for i, (col, nm, _, _) in enumerate(SCALE4):
        x = 30 + (i % 2) * 300; yy = y + 72 + (i // 2) * 30
        cv.add(f'<rect x="{x}" y="{yy:.0f}" width="26" height="22" rx="3" fill="{col}"/>')
        cv.text(x + 34, yy + 18, f"{i+1} {nm.lower()}", 17, raw=True)

# ----------------------------------------------------------------- VISTA LATERALE
def side(c, path):
    c["W_draw"] = c["D"]
    D, H, base, pt = c["D"], c["H"], c["base"], c["panel_t"]
    cv = Cv(c, 400, 480, 190, 400, 0.9)
    cv.line(-60, 0, D + 60, 0, sw=2.5)
    xp = D - pt                                              # fronte pannello posteriore
    # base
    cv.rect(0, 0, D, base, fill=C["metal"], stroke=C["ink"], sw=1.5)
    if base >= 150:
        cv.rect(0, 20, 6, base - 40, fill=C["white"], stroke=C["grey"], sw=0.8)
        cv.text(D / 2, base / 2 - 6, "scorta (sportello frontale)", 18, "middle", fill="#C7CED8")
        cv.line(10, 70, D - 10, 70, stroke="#6B7380", sw=1, dash="6 5")
    # fianchi: sagoma tratteggiata (vasca a tutta profondita', poi strisce)
    cv.poly([(0, base), (D, base), (D, c["tray_top"]), (D - 40, c["tray_top"]), (D - 40, c["hdr_bot"]), (D, c["hdr_bot"]), (D, c["tray_top"])], fill="none")
    cv.rect(0, base, D, c["tray_top"] - base, fill="url(#hatch)", stroke=C["ink"], sw=1.2, extra='fill-opacity="0.55"')
    # pannello posteriore forato
    cv.rect(xp, base, pt, H - base, fill="url(#peg)", stroke=C["ink"], sw=1.2)
    # vasca a gradini + rulli
    y0 = c["y0"]; rows = c["rows"]
    cv.rect(0, base, 2, 10, fill=C["ink"])
    for k in range(rows):
        xk = c["inset"] + c["wall"] + k * (c["roller_d"] + c["roller_gap"]); fy = y0 + k * c["step_rise"]
        cv.rect(xk, y0 - 2, c["roller_d"] + c["roller_gap"], fy - y0 + 2, fill=C["metal"], stroke=C["ink"], sw=0.8)
    for k in reversed(range(rows)):
        xk = c["inset"] + c["wall"] + k * (c["roller_d"] + c["roller_gap"]); fy = y0 + k * c["step_rise"]
        cv.rect(xk, fy, c["roller_d"], c["sizes"][-1] * 10, fill="none") if False else None
        cv.rect(xk, fy, c["roller_d"], 250, fill=C["sleeve"], stroke=C["ink"], sw=1.2, rx=9)
        cv.rect(xk + 4, fy + 4, 10, 242, fill="url(#fur)")
    cv.rect(c["inset"], y0 - 2, c["wall"], c["rim_h"] + 2, fill=C["white"], stroke=C["ink"], sw=1.2)   # sponda frontale
    # fasce a mensola (aggetto)
    for kind, ya, yb, s in c["zones"]:
        if kind in ("fascia", "rulli"):
            cv.rect(xp - c["fascia_proj"], ya + 2, c["fascia_proj"], c["fascia_h"] - 4, fill=C["white"], stroke=C["grey"], sw=1.2)
            cv.rect(xp - c["fascia_proj"], ya + 2, c["fascia_proj"], 4, fill=C["blue"])
        if kind == "sec":
            top = yb
            for hy, ln, col in ((top - 15, s["long"], 0.55), (top - 47 - s["rl"], s["rl"], 0.9)):
                cv.line(xp, hy, xp - c["hook_len"], hy, sw=3.2)
                cv.line(xp - c["hook_len"], hy, xp - c["hook_len"], hy + 9, sw=3.2)
                for j in range(c["per_hook"]):
                    bx = xp - 24 - j * 26
                    cv.rect(bx - 10, hy - ln, 20, ln, fill=C["bristle"], stroke=C["grey"], sw=0.9, rx=3, extra=f'fill-opacity="{col}" stroke-opacity="{col}"')
                    cv.rect(bx - 5, hy - ln * 0.6, 10, ln * 0.6, fill=C["wood"], stroke="none", extra=f'fill-opacity="{col}"')
    # guida alla scelta, testata
    if c["guide"]:
        g0, g1 = c["guide_y"]
        cv.rect(xp - 14, g0, 14, g1 - g0, fill=C["white"], stroke=C["grey"], sw=1.2)
    hb, hh = c["hdr_bot"], c["header"]
    cv.rect(D - 70, hb, 70, hh, fill=C["white"], stroke=C["ink"], sw=1.5)
    cv.rect(D - 12, hb, 12, hh, fill=C["metal"], stroke=C["ink"], sw=1)
    cv.line(D - 70, hb, D, hb, stroke=C["blue"], sw=4)
    # quote verticali
    pts = [0, base, c["tray_top"]]
    for kind, ya, yb, s in c["zones"]: pts.append(yb)
    if c["guide"]: pts.append(c["guide_y"][1])
    pts = sorted(set(pts + [hb, H]))
    for a_, b_ in zip(pts, pts[1:]): cv.vdim(-60, a_, b_, f"{b_-a_:.0f}")
    cv.vdim(-175, 0, H, f"{H} totale", bold=True)
    # quote orizzontali
    i_, w_ = c["inset"], c["wall"]
    cv.hdim(0, i_, -45, f"{i_}", size=17, ext_from=0)
    cv.hdim(i_, xp, -45, f"{xp-i_}", size=19, ext_from=0)
    cv.hdim(xp, D, -45, f"{pt}", size=17, ext_from=0)
    cv.hdim(0, D, -105, f"{D} profondita'", bold=True, ext_from=-45)
    cv.hdim(xp - c["hook_len"], xp, c["tray_top"] + c["fascia_h"] + 520 if False else c["hdr_bot"] - 30 if False else H - c["header"] + 40 if False else c["tray_top"] + 80, f"gancio {c['hook_len']}", size=16) if False else None
    items = [(H - hh / 2, "Testata intercambiabile", [f"spessore 70, inserto stampato sfilabile; profili neri da 12"])]
    if c["guide"]:
        g0, g1 = c["guide_y"]; items.append(((g0 + g1) / 2, "Guida alla scelta", ["pannello sporgente 14 sul pannello forato, a ~150-173 cm"]))
    for kind, ya, yb, s in c["zones"]:
        if kind == "fascia": items.append(((ya + yb) / 2, "Fascia a mensola", [f"aggetto {c['fascia_proj']}, h {c['fascia_h']}"]))
        if kind == "sec": items.append(((ya + yb) / 2, "Ganci e pennelli nudi", [f"asta Ø5 x L {c['hook_len']}; fino a {c['per_hook']} pennelli per gancio, due file di ganci; pannello forato Ø5 passo 25"]))
    items.append(((c["y0"] + c["tray_top"]) / 2, "Vasca a gradini", [f"{c['rows']} file in profondita', alzata {c['step_rise']} per vedere il pelo, rulli in piedi Ø{c['roller_d']} x max {c['roller_max']}, sponda h {c['rim_h']}"]))
    items.append((base / 2, "Base / scorta" if base >= 150 else "Zoccolo", ["vano con sportello frontale; zavorra e antiribaltamento da verificare"] if base >= 150 else ["appoggio su banco/piedini"]))
    cv.callouts(D + 40, items, width=38)
    title_block(cv, c, "VISTA LATERALE (sezione)")
    cv.out(path)

if __name__ == "__main__":
    for k, v in VARIANTI.items():
        c = derive(v)
        front(dict(c), os.path.join(HERE, f"espositore-{k}-frontale.svg"))
        if k != "A100": side(dict(c), os.path.join(HERE, f"espositore-{k}-laterale.svg"))
        print(k, "scomparti", c["nc"], "x", c["across"], "x", c["rows"], "file =", c["roll_cap"], "rulli;",
              [(s["line"], s["nl"], s["nu"], s["nd"], s["pos"]) for s in c["secs"]], "posti", c["brush_pos"], "pennelli max", c["brush_cap"],
              "header", c["header"], "guida", c["guide_y"], "hdr_bot", c["hdr_bot"])
