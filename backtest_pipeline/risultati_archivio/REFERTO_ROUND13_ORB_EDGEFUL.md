# 🔬 REFERTO ROUND 13 — la geometria edgeful, e il PRIMO altopiano della batteria

_Girato l'08/08/2026 notte sul laboratorio `ABTG_ORB_Ottimizzato`, tick reali, M5,
NASUSD, SOLO LONG, OR 15' (14:30→14:45 server), pendenti STOP, TP a multipli del
range, sessione fino alle 21:00 server, niente parziale/BE/trailing. Lancio
allargato: **48 celle** = 4 stop × TP 0,5/1,0/1,5× × EMA200 on/off × tetto range
off/0,8%. File: `risultati_prove/ABTG_ORB_Ottimizzato/*_r13.csv`._

## 1. Il claim della fonte è smentito (di nuovo)

edgeful sosteneva che il **target 50% del range** fosse la chiave (82,6% di
vincite su... 23 trade). Sulla nostra finestra da 30 mesi: con gli stop della
regione buona il TP 0,5× è rosso o piatto (IS −388/−237 con EMA200; OOS
+67…+416). Terza fonte di fila coi numeri fuori scala rispetto alla realtà
misurabile. Anche il tetto 0,8% è quasi ininfluente sul Nasdaq (taglia ~4
giorni su 137: i range da 0,8%+ sono rari).

## 2. Ma la griglia allargata ha trovato un ALTOPIANO — il primo vero

**Regione: SOLO LONG + EMA200(M5) + stop ATR 1,5 o 50% range + TP 1,0–1,5×
l'ampiezza.** Otto celle, TUTTE positive in entrambe le finestre — mai successo
in 100+ celle precedenti sul Nasdaq:

| stop / TP | IS | OOS |
|---|---:|---:|
| ATR / 1,5× (tetto 0,8) | +555,60 · PF 1,101 · 74 | **+1609,61 · PF 1,156 · 135 · DD 12,3%** |
| ATR / 1,5× (no tetto) | +605,37 · PF 1,101 · 81 | +1497,85 · PF 1,143 · 136 |
| ATR / 1,0× (0,8 / no) | +544,24 · PF 1,107 / +436,91 | +1120,82 · PF 1,121 / +1001,62 · PF 1,107 |
| 50% / 1,5× (0,8 / no) | +1194,52 · PF 1,219 / +1057,59 · PF 1,181 | +1185,58 · PF 1,114 / +1078,83 · PF 1,102 |
| 50% / 1,0× (0,8 / no) | +958,42 · PF 1,195 / +738,65 | +599,82 · PF 1,064 / +495,89 · PF 1,052 |

Fuori dalla regione: EMA200 OFF = pareggio diffuso (PF 1,02–1,13 ma DD alti),
stop FIXED = disastro come sempre, TP 0,5× piatto. L'ingrediente portante è
**l'EMA200 long-only**: in R9 non funzionava, ma là era un'altra base (chiusura
confermata, entrambe le direzioni, TP in R, stop estremo opposto). Le
interazioni contano — ed è il motivo per cui i verdetti valgono per la BASE su
cui sono misurati, mai in astratto.

## 3. I freni, scritti prima che l'entusiasmo li allenti

1. **~150 celle esaminate sul NASUSD in batteria**: la probabilità che un
   altopiano emerga per selezione è concreta. Regola pre-dichiarata: **banco
   vergine prima di crederci** → round 14 sul Dow (U30USD, MAI toccato dal
   motore ORB), traguardo scritto nel file prova PRIMA dei numeri.
2. **Niente candidatura prop comunque**: DD OOS 11–15% all'1% — sopra il
   criterio del 10%. Anche se il Dow conferma, il DD va capito (probabile
   figlio del "niente BE/trailing": la gestione attiva è il vicinato naturale
   di un eventuale round 15).
3. Campioni IS modesti (73–81 trade) e finestra OOS del Nasdaq ormai
   guardata molte volte: vale mezzo punto per definizione.

## Verdetto

Il round chiude la geometria edgeful (bocciata come dichiarata dalla fonte) e
apre la **prima pista viva della famiglia ORB**: trend-following long
sull'apertura USA filtrato dalla EMA200. Vita o rumore lo decide il **banco
vergine R14 sul Dow** — criteri già scritti. Nessun cambio a niente di live.

## Dove sono i numeri

`backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/*_r13.csv`.
