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

---

## PASSO 0 SU M15 (corsa VERA 10:08, pin c673b98): IL MOTORE PARLA — E UNA FALLA NEL FLAT

_Freschezza: modo CORSA, compile 67KB 10:08:32, per-trade 769501=623 | 769502=623
(gemelli IDENTICI), PROBLEMI 0. Zip NYRETEST_CORSA_20260831_1008._

### LA MISURA (retest NUDO, gate regime OFF — e' la baseline voluta)
- **n = 623 deal / 460 posizioni** in 459 giorni (~1 posizione/giorno) ->
  n >> 150: alla taratura il MERITO si potra' giudicare (R59 soddisfatta).
- **PF 0.998, profit -199** su 100k: il retest nudo e' in PAREGGIO PERFETTO.
  (Confronto: il CRT nudo era PF 0.46. Qui il gate costitutivo slope+espansione
  ha una base da cui puo' realisticamente estrarre — e' il quadro ideale per
  la taratura, che era lo scopo del passo.)
- Mediana take: WIN +87.8 punti indice (n=310) / LOSS -57.1 (n=313) -> il
  take mediano paga ampiamente lo spread del Dow.
- LATI: LONG n=351, +2450, win 51.9% | SHORT n=272, -2650, win 47.1% ->
  il lato corto zavorra (toro), il lungo galleggia.
- DD 12.97%, peggior giornata -2.89%, autotest 0, RegimeKo=0 (gate OFF vero).
- Scala per la taratura: mediane slope/espansione da leggere nel per-trade
  al round successivo (gate ON vs OFF attorno alla mediana).

### 🔴 VIOLAZIONE DEL VINCOLO DURO (dichiarata): 30 chiusure OLTRE il flat
30 deal su 623 chiusi alle 23:05 / 00:18 / 01:34 / 07:15 — domeniche sera,
festivi USA (Memorial Day, Labor Day, Juneteenth), settimane DST di marzo.
Net di quei deal: +7360 (FORTUNA, non merito: e' gap risk weekend/festivo
non protetto). **Per la lettera del vincolo congelato il file e' INVALIDO
come prova di "zero overnight"** — le misure di scala (frequenza, mediane,
lati) restano fatti misurati.

**CAUSA (letta nel sorgente):** DopoOrarioFlat_Calc confronta solo l'ORA DEL
GIORNO (>=20:55). Se il mercato non ha tick fra le 20:55 e la mezzanotte
(festivo, venerdi' corto, sfasamento DST), a mezzanotte la condizione si
RESETTA e la posizione dorme fino allo SL o alla riapertura (weekend incluso).

**FIX (v4, 31/08):** FLAT DI RECUPERO — se una posizione risulta aperta da un
GIORNO DI CALENDARIO PRECEDENTE (GiornoChiave_Calc, robusto a cavallo di
mese/anno, autotestato), si chiude al PRIMO tick disponibile a qualunque ora.
Limite residuo dichiarato: senza tick non si chiude nulla — l'esposizione
minima fino alla prima riapertura e' irreducibile senza calendario festivi.
Il PASSO 0 va RIFATTO con la v4 per avere il file valido agli atti.

---

## ✅ PASSO 0 VALIDO (corsa v5, 10:36, pin 50551fa): LA MISURA E' AGLI ATTI

_Freschezza piena: modo CORSA, compile 68KB, per-trade 625=625 (gemelli
identici), cache 0/0, PROBLEMI 0. Il conteggio overnight e' AUTOMATICO
(open_time vs close_time). Zip NYRETEST_CORSA_20260831_1036._

**LA MISURA DEL RETEST NUDO (gate regime OFF, la baseline della taratura):**
- n = 625 deal / 462 posizioni in 459 giorni (~1/gg) -> merito giudicabile.
- **PF 1.002, +214** su 100k: pareggio perfetto. DD 12.87%,
  **peggior giornata -2.01%** (era -2.89 con la falla del flat: il flat di
  recupero ha tagliato la coda peggiore).
- Mediana take: WIN +87.6 punti indice / LOSS -58.0 -> RR implicito ~1.5,
  paga lo spread con margine.
- LATI: LONG +4789 (52.7% win) / SHORT -4575 (47.1%) -> nel toro lo short
  zavorra: dato per la taratura (e per un eventuale InpAllowShort al verdetto,
  DA MISURARE non da assumere).
- **Overnight veri: 18/625 (2.88%) < soglia 5% firmata** -> RILIEVO dichiarato
  (assenza di tick: festivi/weekend USA), file VALIDO. Autotest 0.

**PROSSIMO ROUND (taratura del gate, criteri gia' congelati nel prova):** il
gate slope+espansione deve MORDERE (trade e PF che cambiano in modo ordinato
alle soglie vs OFF; OFF==ON = decorativo = scarto). Base di partenza in
pareggio: qualunque selettivita' vera si vede subito.
