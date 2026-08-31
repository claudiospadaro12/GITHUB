# NY SESSION RETEST — PASSO 0, corsa 1 (H1): MOTORE STRUTTURALMENTE MUTO SU H1

_Corsa VERA: 31/08/2026 09:51, pin e985144, U30USD H1 tick 2024.09.26->2026.06.30,
cella fissa gate-OFF, gemelli 769501/769502. Compile OK (67KB, primo compile).
La spia nuova (v2: riconta le operazioni) ha alzato 2 PROBLEMI: per-trade con la
SOLA intestazione. Zip NYRETEST_CORSA_20260831_0951._

## LA MISURA: 0 trade su 459 giorni — e i contatori dicono ESATTAMENTE perche'

9256 OnNewBar = 7083 (fuori seduta/contesto) + 2171 (pos 0 / pendenza VWAP
non calcolabile) + 2 (fuori seduta tardiva). Trades=0, Apri Chiamate=0,
Long/Short Cand=0. L'AMBIENTE e' SANO (D1 via CopyRates ok, EMA ok, tick ok —
lezione CRT gia' incassata): e' GEOMETRIA.

**La catena:** la seduta 14:30->20:55 server contiene 6 barre H1 (open 15..20).
La prima e' esclusa per regola (pos 0: mai ingresso). La pendenza VWAP chiede
InpVwapSlopePeriod=5 barre DI SEDUTA -> l'unica barra che potrebbe tradare e'
quella delle 20:00, che chiude alle 21:00: OLTRE il flat 20:55 -> bloccata.
**Zero ingressi possibili PER COSTRUZIONE.** (Il verificatore l'aveva
segnalato in NON COPERTO: "su H1 le barre decisionali sono 6". La misura
dice che non e' poco: e' zero.)

## DECISIONE (ingegneria, non parametri-fishing)
Il TF di lavoro del motore va a **M15** (~25 barre di seduta: la pendenza a 5
respira). NON e' un cambio di tesi: l'EA legge il trend su H1 con un handle
DEDICATO proprio perche' il grafico doveva stare piu' in basso (come il
request.security del Pine sorgente). Il prova e' aggiornato (@PERIODO M15,
motivazione misurata dentro), wrapper v3, stessa cella, stessi gemelli,
stessi criteri congelati. La corsa H1 resta agli atti come misura valida:
"frequenza su H1 = 0 per costruzione".
