# 🔬 REFERTO ROUND 15 — la gestione doma il DD: primo candidato nato in laboratorio

_Girato il 09/08/2026 sul laboratorio `ABTG_ORB_Ottimizzato`, tick reali, M5,
U30USD. Lancio allargato: **64 celle** = 4 stop × TP 1,0/1,5× × parziale off/50%
× trailing EMA9 off/on × EMA200 off/on (tetto 0,8% pinnato). Cancello
pre-dichiarato in `R15_ORB_gestione_DD.txt`: almeno una cella con PF OOS ≥ 1,10
**E** DD OOS < 10% **E** n ≥ 30, restando positiva in IS.
Sanità: le 4 celle-base riproducono R14 AL CENTESIMO._

## Il cancello è passato — da UNA cella

**Stop 50% range + EMA200 + TP 1,5× + trailing EMA9 + niente parziale:**

| finestra | Profit | PF | DD | n |
|---|---:|---:|---:|---:|
| IS | +867,42 | 1,223 | 8,63% | 71 |
| OOS | **+4002,54** | **1,657** | **9,92%** | 119 |

## Le tre scoperte di gestione

1. **Il trailing EMA9 è l'ingrediente che trasforma la pista** — e porta il
   **13° ribaltamento IS→OOS**: in campione il trailing sembra COSTARE
   (+2156,84 senza contro +867,42 con), fuori campione è l'opposto
   (+1730,32 → +4002,54, DD 16,7% → 9,9%). Scegliendo dall'IS avremmo tenuto
   la versione senza trailing, che fallisce il criterio DD. Sul vicino TP 1,0×
   stessa storia (OOS +1861→+3102, DD 14,3→11,2).
2. **Il parziale 50% a 1R indebolisce l'IS ovunque** (fino a portarlo sotto
   zero): bocciato. Sul Dow il runner va lasciato correre col trailing, non
   dimezzato presto — coerente con la lezione R9 ("il target ambizioso paga").
3. La combinazione trailing+EMA200 aiuta l'OOS anche sugli altri stop
   (ATR: +3221 PF 1,49 DD 8,4; OPPRANGE: +1807 PF 1,68 DD 4,1) **ma lì l'IS è
   rosso o piatto**: solo il 50%-range regge in entrambe le finestre.
   I verdetti valgono per la base misurata, l'ennesima volta.

## Verdetto e onestà

Formalmente **5 criteri prop su 5**: (1) verde in entrambe ✓ (2) PF OOS 1,657 ✓
(3) vicinato positivo su TP/parziale/trailing ✓ (4) DD 9,92% < 10% ✓
(5) n=119 ✓. → **Primo candidato interamente nato in laboratorio**, con DOPPIO
ASTERISCO dichiarato:
- il criterio DD passa per 8 centesimi e NON su tutto l'altopiano (TP 1,0× è
  a 11,2%): è una cella di confine, non un plateau di sicurezza;
- terza guardata all'OOS del Dow (R14+R15) → mezzo punto, più il vento di
  regime long già refertato in R14.
Il cancello era pre-scritto (selezione meccanica, non pesca a posteriori), ma
**la conferma può darla solo il forward** — su DEMO, come da ROTTA_PROP:
mai live da un backtest.

## La firma completa del candidato (per l'eventuale forward demo)

> `ABTG_ORB_Ottimizzato` su **U30USD M5**, magic 770611: solo long ·
> OR 15' (14:30→14:45 server) · pendenti STOP (buffer 10) · EMA200 M5 ·
> SL 50% del range · TP RANGE 1,5× · trailing EMA9 M5 attivo · niente
> parziale (TP1Pct=0) · tetto range 0,8% · un trade/giorno · chiusura 21:00
> · rischio 1% · news OFF. (In prova: `InpSLMode=3, InpTPMode=1,
> InpTPRangeMult=1.5, InpUseTrailEMA=1, InpExitOnEmaClose=0, InpTP1Pct=0,
> InpUseEma200Filter=1, InpMaxRangePct=0.8`.)

La decisione di attaccarlo a un grafico demo è di Claudio. Il laboratorio,
da parte sua, ha finito il giro: da "strategia da chiudere" a candidato con
asterischi in una notte e mezza di misure oneste.

## Dove sono i numeri

`backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/*_r15.csv`.
