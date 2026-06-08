#!/usr/bin/env python3
# Genera uno schemino "ROTTURA vs RITEST" da tenere sul telefono.
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch

# formato verticale tipo telefono
fig = plt.figure(figsize=(6, 10), dpi=160)
fig.patch.set_facecolor("#0e1117")

ROSSO = "#e7483b"
VERDE = "#1faa59"
BLU   = "#3a82f7"
GIALLO= "#f2c14e"
TXT   = "#f0f0f0"
GRIGIO= "#9aa0a8"

# ---------- TITOLO ----------
fig.text(0.5, 0.965, "DOVE ENTRARE", ha="center", color=TXT,
         fontsize=22, fontweight="bold")
fig.text(0.5, 0.937, "Rottura  vs  Ritest  —  XAUUSD", ha="center",
         color=GRIGIO, fontsize=12)

# =========================================================
#  PANNELLO 1 — ROTTURA (sbagliato / in ritardo)
# =========================================================
ax1 = fig.add_axes([0.10, 0.595, 0.82, 0.30])
ax1.set_facecolor("#161b22")
for s in ax1.spines.values():
    s.set_color("#30363d")
ax1.set_xticks([]); ax1.set_yticks([])
ax1.set_xlim(0, 10); ax1.set_ylim(0, 10)

# prezzo che scende: laterale poi crollo
x = [0,1,2,3,4,5,5.6,6.2,6.8,7.4,8,9]
y = [8,7.8,8.1,7.9,8,7.8,6.2,4.8,4.2,4.0,4.1,3.9]
ax1.plot(x, y, color=GRIGIO, lw=2)
# livello di rottura
ax1.axhline(7.6, xmin=0.02, xmax=0.55, color=GIALLO, ls="--", lw=1.5)
ax1.text(0.3, 7.95, "supporto", color=GIALLO, fontsize=9)
# punto di ingresso "rottura" (in pieno candelone)
ax1.scatter([6.2], [4.8], s=180, color=ROSSO, zorder=5, edgecolor="white", lw=1.2)
ax1.text(6.45, 5.2, "ENTRI QUI\n(in ritardo)", color=ROSSO, fontsize=10,
         fontweight="bold", va="center")
ax1.set_title("1)  ROTTURA  =  insegui il candelone",
              color=ROSSO, fontsize=13, fontweight="bold", loc="left", pad=8)
ax1.text(0.2, 1.2, "stop lontano  •  rischio grande  •  spesso rimbalza contro",
         color=GRIGIO, fontsize=9)

# =========================================================
#  PANNELLO 2 — RITEST (giusto)
# =========================================================
ax2 = fig.add_axes([0.10, 0.225, 0.82, 0.30])
ax2.set_facecolor("#161b22")
for s in ax2.spines.values():
    s.set_color("#30363d")
ax2.set_xticks([]); ax2.set_yticks([])
ax2.set_xlim(0, 10); ax2.set_ylim(0, 10)

# crollo, poi rimbalzo fino al supporto rotto, rifiuto, e giu di nuovo
x2 = [0,1,2,2.6,3.2,3.8,4.4,5.0,5.6,6.2,6.8,7.6,8.4,9.2]
y2 = [8,7.8,7.9,6.4,5.0,4.4,5.0,5.8,6.4,6.5,5.8,4.8,4.0,3.6]
ax2.plot(x2, y2, color=GRIGIO, lw=2)
# livello supporto rotto = ora resistenza
ax2.axhline(6.5, xmin=0.02, xmax=0.98, color=GIALLO, ls="--", lw=1.5)
ax2.text(0.3, 6.8, "supporto rotto = ora resistenza", color=GIALLO, fontsize=9)
# punto di ingresso ritest (sul rifiuto della resistenza)
ax2.scatter([6.2], [6.5], s=200, color=VERDE, zorder=5, edgecolor="white", lw=1.2)
ax2.text(6.5, 7.4, "ENTRI QUI\n(sul rifiuto)", color=VERDE, fontsize=10,
         fontweight="bold", va="center")
# stop stretto
ax2.annotate("", xy=(6.2, 7.2), xytext=(6.2, 6.5),
             arrowprops=dict(arrowstyle="-", color=ROSSO, lw=1.4))
ax2.text(5.0, 7.25, "stop\nstretto", color=ROSSO, fontsize=8, ha="right")
ax2.set_title("2)  RITEST  =  aspetti il pullback",
              color=VERDE, fontsize=13, fontweight="bold", loc="left", pad=8)
ax2.text(0.2, 1.2, "stop vicino  •  rischio piccolo  •  tanto spazio a favore",
         color=GRIGIO, fontsize=9)

# =========================================================
#  REGOLE D'ORO
# =========================================================
fig.text(0.5, 0.175, "REGOLE D'ORO", ha="center", color=GIALLO,
         fontsize=14, fontweight="bold")

regole = [
    "1.  La DIREZIONE la da' l'Ichimoku (sopra/sotto la nuvola).",
    "2.  NON entri sul candelone: aspetti che torni a respirare.",
    "3.  Entri sul RITEST del livello + candela di rifiuto.",
    "4.  Stop oltre il livello. Se non rifiuta, niente trade.",
    "5.  Non indovini il fondo: il TRAILING ti fa uscire.",
]
y0 = 0.135
for r in regole:
    fig.text(0.09, y0, r, color=TXT, fontsize=10.5, ha="left")
    y0 -= 0.027

fig.text(0.5, 0.012,
         "Hai ragione sulla direzione? Bene. Ma conta DOVE entri.",
         ha="center", color=GRIGIO, fontsize=9, style="italic")

fig.savefig("/home/user/GITHUB/mql5/cheatsheet_rottura_vs_ritest.png",
            facecolor=fig.get_facecolor())
print("OK")
