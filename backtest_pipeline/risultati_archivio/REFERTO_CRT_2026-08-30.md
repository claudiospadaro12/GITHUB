# CRT TURTLE SOUP — verdetto tick NASUSD: MOTORE SENZA EDGE (toro), 0/30 celle verdi

_Corsa: 30/08/2026 19:15, pin `493a333b5a29a4fd2cda4d08026f98a1839fee4c`. EA NUOVO
`ABTG_CRT_TurtleSoup` (compilato OK, 57 KB, primo compile riuscito). Modello 4 TICK
REALI, NASUSD M15, finestra 2024.09.26->2026.06.30 (21 mesi, un solo regime TORO),
walk-forward IS 40% / OOS 60%, rischio 0.65%, sweep 3 assi (WickFactor x MidGate x
Side) = 30 celle. Zip: CRT_CORSA_20260830_1915.zip._

## IL VERDETTO IN UNA RIGA
**Il motore CRT, sul toro a tick reali, NON HA EDGE: 0 celle su 30 con PF>=1, in
IS E in OOS. PF fra 0.43 e 0.73 ovunque. E' un bleeder, non un motore.**

## LA TABELLA (le "meno peggio", che restano PERDENTI)

| gamba | migliore cella | PF | profit | n | DD% | config |
|---|---|---|---|---|---|---|
| IS  | meno peggio | **0.656** | -11.002 | 222 | 13.7 | wick 2.5, midgate 1, **long only** |
| OOS | meno peggio | **0.726** | -10.229 | 276 | 12.8 | wick 4.0, midgate 1, **long only** |

- **0 celle con PF>=1** in entrambe le gambe (misurato, non stimato).
- PF range: IS 0.43-0.66, OOS 0.47-0.73. **Tutte perdenti.**
- DD dal 13% al 50% (il rischio 0.65% cappa la peggior giornata a ~2%, ma bleeda
  ogni giorno -> DD cumulativo enorme). Il PF ~0.5 e' la spia: perde ~meta' di
  quanto rischia.
- Le "meno peggio" sono tutte **long-only** col MidGate ON: perfino il fade
  long (comprare i dip) in un toro perde. Il fade short viene falciato dal trend.

## LA LETTURA (onesta, §5F)
- **Regola §5F / principio di Claudio**: un MOTORE buono si lavora, uno cattivo no.
  Qui il motore, sui dati che possiamo misurare (toro a tick), **non e' buono**:
  PF 0.5, non 0.9 marginale. Non c'e' niente da lucidare — la gestione non salva
  un ingresso che perde di suo.
- **Il caveat vero (non una scusa)**: il CRT e' un motore di FADE/reversal, e il
  TORO PULITO e' il suo PEGGIOR regime — i fade bleedano contro il trend (E3 perse
  -5604 nel toro 2017, stessa storia). Il tick BCM copre SOLO questo toro. Quindi
  il verdetto e' "morto NEL TORO", non "morto ovunque".
- **Ma la brutalita' conta**: anche tenendo conto del regime sbagliato, un motore
  con un edge latente di solito mostra PF vicino a 1 o qualche cella verde nel
  toro. Questo e' uniformemente rosso profondo (0.43-0.73). Segnale forte che e'
  un motore DEBOLE, non solo "in attesa del regime giusto".

## COSA RESTA (l'unica domanda onesta, non false hope)
Il CRT vive nella TEMPESTA (crollo 2020, orso 2022)? E' lo stesso test che ha
rivelato E3 regime-condizionale: screening OHLC su NASUSD_EXT 2020-2024 (crollo +
toro + orso). ESITO ATTESO, dichiarato prima: probabilmente rosso anche li' nel
toro 2021, forse verde SOLO nel crollo/orso -> mattone "storm-only" senza verdetto
tick possibile su BCM (servirebbe Dukascopy). Cheap da misurare, ma senza illudersi.

## DECISIONE
- **NON si lavora sul CRT as-is** (§5F: motore non buono nel dato misurabile).
- **NON si promuove, NON si deploya.**
- Opzione A: seppellirlo e passare agli altri 5 motori + i nuovi dei cacciatori.
- Opzione B (cheap tiebreaker): 1 screening OHLC _EXT multi-regime; se rosso anche
  li' -> sepoltura definitiva; se verde solo tempesta -> candidato storm-gated
  (come lo short), da Dukascopy per il tick. Decide Claudio.
- Registrato in REGISTRO_TEST.md come motore-senza-edge (toro tick).
