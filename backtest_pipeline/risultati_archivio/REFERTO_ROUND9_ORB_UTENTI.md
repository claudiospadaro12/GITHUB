# 🔬 REFERTO ROUND 9 — la ricetta degli utenti ABTG, misurata (e bocciata)

_Girato l'08/08/2026 notte sul laboratorio `ABTG_ORB_Ottimizzato`, tick reali, M5,
NASUSD, base = config da manuale del round 8 (OR 30' 14:30→15:00, chiusura M5
confermata, corpo 50%, EMA 9/21, volume ON). Il lancio ha spazzolato anche il TP:
griglia 4 modi SL × TP 1,0–3,0 × EMA200 on/off = **40 celle per finestra**.
File: `risultati_prove/ABTG_ORB_Ottimizzato/*_r9.csv`._

## Sanità

Le 4 celle in comune col round 8 riproducono **al centesimo** (IS +914,94 e
+1069,09; OOS +78,87 e +59,04): banco affidabile, confronti leciti.

_Nota d'archivio: il round è girato DUE volte — il lancio largo (40 celle, sul
sorgente del corso, file `*_r9largo.csv`) e il lancio pulito da 8 celle sul
laboratorio `ABTG_ORB_Ottimizzato` (TP 1:1 pinnato, file `*_r9.csv`). Le celle
sovrapponibili coincidono AL CENTESIMO (+678,51/+596,91 IS; −35,02/−19,81 OOS):
i due sorgenti sono equivalenti a parità di config (con la chiusura confermata
non ci sono pendenti, quindi il fix OneTradePerDay non entra in gioco). Il
verdetto vale per entrambi._

## Le tre affermazioni degli utenti, alla prova

1. **«Il rapporto 1:1 è il migliore»** — ROVESCIATA. Sulla riga dell'unico stop
   che funziona (estremo opposto), il TP 1,0 è il PEGGIORE fuori campione
   (−35,02 e −19,81); il migliore è il TP 3,0 (+151,36). La curva OOS cresce
   col TP, non decresce.
2. **«Stop = 50% dell'ampiezza»** — NETTAMENTE BOCCIATA. Lo stop a metà range
   (HALFRANGE) è negativo in TUTTE le 10 celle IS e TUTTE le 10 OOS
   (da −226 a −1.664). Anche ATR 1,5 e fisso-1000 sono rovinosi (fisso: DD
   fino al 40%). **Il breakout ha bisogno del respiro dell'intero range**:
   l'unica geometria di stop che tiene è quella del corso, l'estremo opposto.
3. **«Aggiungi la EMA 200»** — SENZA DIREZIONE. Aiuta a TP 1,5 (+102,75 contro
   +78,87), danneggia a TP 2,0/2,5/3,0 (−27,93/−209,35/−226,35 contro
   +59,04/+0,35/+151,36). Nessun pattern coerente: rumore, non filtro.

## Il tetto non si sposta

Miglior cella fuori campione dell'intera griglia: **PF 1,057** (TP 3R, +151,36
su 179 trade — 85 centesimi a trade). Il traguardo pre-dichiarato (PF OOS ≥1,10)
non è raggiunto da nessuna delle 40 celle. Con questo round il conteggio sul
Nasdaq arriva a **60 celle a tick reali senza un edge**: la conclusione
«sul NASUSD il breakout d'apertura al massimo pareggia» regge anche contro la
ricetta della community.

## Cosa resta in piedi

- La **direzione del TP** è l'unica informazione nuova: fuori campione più il
  target è ambizioso meglio va (1,0 rosso → 3,0 il migliore). Coerente con la
  natura trend-following della strategia: se il breakout è vero, corre.
  Da riverificare sui mercati non ancora bocciati (oro R10, DAX R11).
- I round che restano: **R10 (oro), R11 (DAX), R12 (geometria dell'articolo)** —
  su mercati o geometrie dove il verdetto non è ancora scritto.
