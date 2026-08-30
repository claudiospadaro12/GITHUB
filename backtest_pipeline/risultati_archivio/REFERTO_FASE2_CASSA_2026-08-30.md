# FASE 2 CASSAFORTE a tick: l'OHLC era OTTIMISTA — long sottile, simmetrico rosso in OOS, e una RISERVA che pesa

_Corsa: 30/08/2026 09:07, pin `18199ef187514f90b8648b81e83b4be672ba7f77`. Model 4
TICK, NASUSD BCM M15, rischio 0.65%, parziale rimessa (50%@1R + BE + runner
uncap), fuso 14:30 server. Finestra 2024.09.26->2026.06.30 (un solo regime
rialzista). IS/OOS = due meta' lette come CONTESTO (non selezione). Gemelli
IDENTICI. Zip: FASE2_CASSA_CORSA_20260830_0907.zip._

## LA TABELLA

| cella | lati | n IS | PF IS | n OOS | PF OOS | DD% OOS | prof OOS | asp/tr OOS | pegg.gio |
|---|---|---|---|---|---|---|---|---|---|
| 00_simm | long+short | 263 | 1.370 | 383 | **0.796** | 19.09 | -18229 | -47.6 | -1.81 |
| 01_long | solo long | 192 | 1.446 | 297 | **1.083** | 11.73 | +5227 | +17.6 | -0.97 |

## ⚠️ LA RISERVA CHE VIENE PRIMA DI TUTTO (RILIEVO del referto)
**Profondita' tick NASUSD NON MISURATA.** A Model 4, se i tick reali non ci sono,
MT5 non si ferma: ripiega e produce numeri PLAUSIBILI E FALSI. **Ogni numero qui
va letto con questa riserva finche' non gira `misura_tick` su NASUSD.** Il verdetto
sotto e' PROVVISORIO: prima si verifica che i tick ci siano davvero.

## LA LETTURA (coi criteri congelati, e con la riserva sopra)

**1. L'OHLC era OTTIMISTA — confermato, come temuto.** FASE 1 (OHLC) dava il
drive-following long a PF ~1.32-1.37; a tick l'edge del LONG scende a **PF 1.083
OOS** (asp +17.6/trade). Lo spread+slippage si mangia la maggior parte del
margine OHLC. E' la lezione "OHLC inganna" applicata: il forma verde c'era, il
costo reale lo assottiglia parecchio.

**2. Il SIMMETRICO PERDE in OOS (PF 0.796).** Su una finestra SENZA crolli, lo
short e' quasi solo COSTO (FASE 1: lo short rende solo nei crolli rapidi, qui
assenti). E il costo NON e' piccolo: trascina il long da 1.083 a 0.796,
dall'utile alla perdita. asp/trade: long +17.6 -> simmetrico -47.6. **Lo short
always-on NON e' dispiegabile su un regime rialzista.**

**3. Anche il LONG degrada IS->OOS** (1.446 -> 1.083) e ha DD 11.73% (sopra un
muro 10%). E' un edge SOTTILE e in calo nella seconda meta'. Non e' un candidato
forward confidente cosi' com'e'.

**4. Il rischio non e' la peggior giornata (bassa: -0.97/-1.81%, la parziale
funziona) ma la FREQUENZA**: DD 11.7% (long) / 19.1% (simm) da perdite
consecutive. La parziale ha domato il singolo giorno, non la serie.

## COSA IMPARIAMO (il valore vero di questo round)
- **Il long drive-following e' l'unico pezzo con edge a tick**, ma sottile
  (PF 1.083) e da abbassare-di-costo. Non promuovibile oggi, non morto.
- **Lo short va GATED, non always-on.** FASE 1: rende +1587/trade nei crolli,
  ~0 nell'orso choppy, negativo in toro/range. La cassaforte lo conferma: sempre
  acceso su un toro = drag netto. Il disegno giusto e' **long base + short
  ACCESO SOLO dal regime** (EMA H4 ribassista / alta volatilita') -- esattamente
  il candidato `SHORTGATE_NAS_BREAKDOWN` della caccia 29/08. I due fili si
  uniscono qui.
- **Il costo e' il nemico**: l'edge sottile a tick dice che il cancello S0
  (spread reale, mai misurato su NASUSD) e' load-bearing. Va misurato lo spread
  (Spread Logger 74148) prima di qualunque promozione.

## AGGIORNAMENTO 30/08: RISERVA TICK SCIOLTA -> i numeri REGGONO
`misura_tick` su NASUSD (referto in `misura_tick/`): **166.509.474 tick REALI dal
2024.09.26** (come U30USD). La finestra cassaforte 2024.09.26->2026 e' coperta
INTERAMENTE da tick veri: **i numeri sotto NON sono il ripiego di MT5, sono
reali.** Il verdetto da provvisorio diventa CONFERMATO.

## VERDETTO (confermato dai tick reali)
La FASE 2 NON promuove un candidato forward oggi. Ma NON e' un buco nell'acqua:
1. **Dati VERI** (166M tick dal 2024.09.26): l'OHLC era ottimista, a tick l'edge
   e' sottile ma reale sul long, negativo sul simmetrico. Fatto accertato.
2. **Se i tick sono reali**: il long e' un edge sottile da difendere sul costo;
   lo short va staccato dal simmetrico e messo dietro un GATE di regime.
3. **Robustezza-per-regime**: gia' verde a OHLC (FASE 1). Il nodo e' il COSTO,
   non il regime.

Nessun forward toccato. G5 rispettato: e' una MISURA.
