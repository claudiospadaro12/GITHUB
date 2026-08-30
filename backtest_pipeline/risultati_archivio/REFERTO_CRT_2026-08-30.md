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

## AGGIORNAMENTO — TIEBREAKER DI REGIME (_EXT OHLC 2020-2024): NON SEPPELLITO

_Corsa: 30/08/2026 19:44, pin `6a0b10de1a3b3af27a50c48c69abc9013aebf920`. Modello 1
OHLC, NASUSD_EXT M15 (392 MB storico), finestra 2020-2024 (crollo 2020 + toro 2021 +
orso 2022 + 2023), sweep 3 assi, flat 16:00 NY. Zip: CRT_EXT_CORSA_20260830_1944.zip._

**La tempesta cambia il quadro: 13 celle su 30 con PF>=1 (verde sul TOTALE
2020-2024, INCLUSO il toro 2021 che a fade fa male).**

| cella | PF | profit | n | DD% | config |
|---|---|---|---|---|---|
| robusta (n alto) | **1.18** | **+5744** | 320 | 5.9 | wick 2.0, mid 0, **side 2** |
| miglior PF | 1.50 | +2915 | 50 | 2.1 | wick 3.5, mid 1, long (n thin) |
| coerente | 1.11 | +2654 | 205 | 5.1 | wick 3.5, mid 0, side 2 |

- **13/30 verdi, PF fino a 1.50, DD basso (2-6%)**: NON e' un outlier isolato, e'
  una fascia verde coerente. La cella robusta (n=320, PF 1.18, DD 5.9%) e' netta.
- **Il contrasto col tick e' REALE**: il tick 2024-2026 e' un toro a bassa
  volatilita' (il peggio per un fade) -> 0/30. Il 2020-2024 ha crollo+orso (la
  volatilita' che il fade ama) -> verde. Stesso motore, regime diverso.

**I DUE MURI, dichiarati (niente hype):**
1. **OHLC INGANNA ed e' OTTIMISTA**: il tick e' PF 0.5 nel toro, quindi i numeri
   veri sono PIU' BASSI. Il +5744 e' forma, non cassa.
2. **VERDETTO TICK NELLA TEMPESTA IMPOSSIBILE su BCM** (muro dati 26/09/2024):
   il verde viene (quasi certo) dal crollo/orso, che a tick BCM non raggiungiamo.
   Serve Dukascopy per il verdetto vero.

**CONSEGUENZA**: il CRT NON e' morto -- e' un motore STORM-CONDIZIONALE, come lo
short e come E3: vive in volatilita', muore nel toro calmo. Non deployabile as-is
(il forward oggi e' un toro calmo -> perderebbe), ma non da buttare.

**STAGE-2 (prossimo, cheap)**: la cella robusta (side 2, wick 2.0, mid 0) da sola,
magic dedicato, per-trade CSV segmentato per regime -> confermare che il verde
viene dal crollo 2020 + orso 2022 (non da un artefatto OHLC di un periodo). Se
confermato: candidato storm-gated, da Dukascopy per il tick e da accoppiare a un
gate di volatilita'/regime (misurato, non appiccicato).

## STAGE-2 — la cella robusta PER REGIME (per-trade CSV, gemelli identici)

_Corsa: 30/08/2026 20:14, pin `ad60f874ec888a2ec2dee75454c9e19d74a17647`. Cella
robusta (wick 2.0, mid 0, side 2), gemelli 769101/769102 IDENTICI (determinismo OK),
320 trade su 2020-2024. Zip: CRT_EXT_S2_CORSA_20260830_2014.zip._

| regime | n | tot_net | asp/tr | win% | segno |
|---|---|---|---|---|---|
| **CROLLO 2020** (feb-apr) | 30 | **-2760** | -92.0 | 46.7 | 🔴 PERDE |
| resto 2020 (ripresa/chop) | 66 | +1221 | +18.5 | 60.6 | 🟢 |
| **TORO 2021** (trend liscio) | 68 | -609 | -8.9 | 52.9 | 🔴 piatto |
| **ORSO 2022** (grind ribassista) | 73 | +2633 | +36.1 | 53.4 | 🟢 |
| **2023** (range/chop) | 83 | **+5259** | +63.4 | 62.7 | 🟢 il grosso |
| TOTALE | 320 | +5744 | +17.9 | | |

Lati: LONG +2541 (n=151), SHORT +3203 (n=169) -> **due lati veri, lo short paga
di piu'** (riempie il buco short).

**LA TESI "storm" ERA IMPRECISA — la misura la CORREGGE (onesto):**
- 🔴 **NON e' un motore da CROLLO**: nel crollo covid 2020 PERDE -2760 (-92/trade).
  Un turtle-soup che fada gli sweep in un crollo violento prende il coltello che
  cade. Il crash e' il suo nemico, non il suo regime.
- 🔴 **NON e' un motore da TREND liscio**: toro 2021 piatto/rosso (atteso).
- 🟢 **E' un motore da CHOP / RANGE / GRIND**: vince nell'orso-a-gradini 2022
  (+2633), nel range 2023 (+5259, il grosso) e nella ripresa-chop resto-2020
  (+1221). Vuole mercati bilaterali, volatili ma NON in crollo direzionale.
- => e' una **mean-reversion CONDIZIONATA AL REGIME DI RANGE**, non "storm-only".

**I DUE MURI + UN TERZO (concentrazione):**
1. OHLC OTTIMISTA: coerente col tick (2024-2026 = toro liscio-ish -> PF 0.5, cioe'
   perde nel liscio, esatto). I numeri veri a tick sono piu' bassi.
2. VERDETTO TICK NEL REGIME GIUSTO IMPOSSIBILE su BCM: il chop 2022/2023 e' pre
   26/09/2024 -> nessun tick. Il tick BCM copre solo il toro (dove perde). Serve
   Dukascopy per il verdetto vero nel regime di range.
3. CONCENTRAZIONE 2023: +5259 dei +5744 vengono dal 2023. Il SEGNO e' coerente in
   3 regimi di chop su 5, ma la TAGLIA dell'edge e' 2023-pesante -> incerta.

**VERDETTO STAGE-2: NON deployabile ORA (il forward e' un toro -> perderebbe, come
il tick), ma NON morto. E' un motore da RANGE, regime-condizionale. Per renderlo
dispiegabile servono DUE cose insieme: (a) un GATE DI REGIME che lo accenda solo
in chop/range bilaterale e lo spenga in crollo e in trend liscio (misurato); (b)
Dukascopy per il verdetto tick nel regime giusto. Strada lunga. Parcheggiato come
candidato CHOP-GATED, thesis raffinata, registrato.**
