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

## GATE DI REGIME MISURATO — IL GATE MORDE (griglia soglie, OHLC _EXT)

_Corsa: 30/08/2026 22:13, pin `6dcdca7d44fc6ec9b7b7bfadd89291e43f83ff29`. Cella
robusta + gate ON, sweep InpAdxMax (20-40) x InpAtrMinPts (0-300), 20 celle,
Modello 1 OHLC NASUSD_EXT 2020-2024. Zip: CRT_GATE_CORSA_20260830_2213.zip._

**Il gate ADX(D1) MORDE in modo ordinato e MIGLIORA OGNI metrica. Riferimento
ungated: +5744, n=320, PF ~1.18, DD 5.9%.**

| AdxMax | AtrMin | Profit | PF | n | DD% | vs ungated |
|---|---|---|---|---|---|---|
| 20 | 0 | +1106 | 1.29 | 57 | 1.69 | troppo stretto |
| **25** | **0** | **+9487** | **1.92** | 147 | **2.09** | PF picco, DD minima |
| **30** | **0** | **+10135** | **1.65** | 201 | **2.60** | Profit picco, n robusto |
| 35 | 0 | +6872 | 1.29 | 251 | 4.12 | si allarga |
| 40 | 0 | +5090 | 1.19 | 271 | 4.45 | ~ungated |

- **ADX e' la leva vera**: stringendo AdxMax i trade calano MONOTONI (271->57) e il
  profitto PICCA a AdxMax 25-30. E' il gate che TAGLIA i trade di crollo+trend
  (ADX alto) tenendo il chop (ADX basso). Il "Ret Gate Regime" (bloccati) sale
  ordinato: 394 (loose) -> 1825 (tight). Il gate e' COSTITUTIVO e ATTIVO, non decorativo.
- **ATR e' inutile qui**: a AtrMin 0 e 100 i risultati sono IDENTICI (l'ATR D1 e'
  sempre >=100 pt); a 200-300 taglia ma FA MALE (toglie chop buono). -> il gate e'
  ADX-only, ATR floor neutro. Semplifica.
- **L'ALTOPIANO** e' AdxMax 25-30 (NON un picco isolato: 25/30/35 tutti verdi).
  Centro robusto: **AdxMax=30, ATR neutro -> +10135, n=201, PF 1.65, DD 2.60%**.
  Contro l'ungated: **profitto ~2x, DD ~meta' (5.9->2.6), PF 1.18->1.65, n -37%**.

**IL GATE HA VINTO. Il CRT gated (ADX<=30 su D1) e' un motore diverso: taglia i
regimi perdenti, tiene il chop, DD dimezzato. La tesi per-regime e' confermata dal
gate.**

**I MURI CHE RESTANO (onesto, non e' ancora cassa):**
1. OHLC OTTIMISTA: +10135 e' FORMA. A tick e' piu' basso (ma il gate taglierebbe
   anche i trade di trend a tick -> il gated-tick dovrebbe battere l'ungated-tick).
2. VERDETTO TICK NEL CHOP IMPOSSIBILE su BCM (chop 2022/2023 pre-26/09/2024) ->
   Dukascopy per la cassa vera.
3. Il gate tiene il CRT FLAT nel toro attuale (ADX alto) -> deploy piccolo/osserv.
   e' SICURO (non perde nel toro, spara solo quando arriva il chop) -- come lo short.

**PROSSIMI PASSI**: (a) STAGE-2 per regime della cella AdxMax=30 (confermare che il
+ viene dal chop e crollo/toro sono ~flat); (b) valutare deploy piccolo chop-gated
(sicuro: flat nel toro); (c) Dukascopy per il verdetto tick nel chop.

## STAGE-2 GATED per REGIME (ADX<=30) — CONFERMA, E OGNI REGIME DIVENTA POSITIVO

_Corsa: 30/08/2026 22:29, pin `e2c527fbc4b7976324102312de2bf7386257883e`. Cella
vincente + GATE ON ADX(D1)<=30, gemelli 769103/769104 IDENTICI, 201 trade. Zip:
CRT_EXT_S2G_CORSA_20260830_2229.zip._

**Confronto UNGATED -> GATED per regime (la prova che il gate FUNZIONA):**

| regime | UNGATED n / net | GATED n / net | cosa ha fatto il gate |
|---|---|---|---|
| CROLLO 2020 | 30 / **-2760** | 8 / **+694** | tagliati 22 coltelli, sign FLIP |
| resto 2020 | 66 / +1221 | 38 / +1548 | tenuto+migliorato |
| TORO 2021 | 68 / **-609** | 57 / **+571** | sign FLIP (tolti i trend-trade) |
| ORSO 2022 | 73 / +2633 | 54 / **+3253** | meno trade, PIU' profitto |
| 2023 range | 83 / +5259 | 44 / +4070 | meno concentrato |
| **TOTALE** | 320 / **+5744** | 201 / **+10135** | +2x, ogni regime POSITIVO |

**IL GATE HA FATTO DI PIU' CHE TAGLIARE LE PERDITE:**
- **Ogni singolo regime e' ora POSITIVO** (crollo +694, resto2020 +1548, toro +571,
  orso +3253, 2023 +4070). NESSUN regime perdente. Win% su ovunque (56-68%).
- **I due regimi che PERDEVANO hanno FLIPPATO di segno**: crollo -2760->+694,
  toro -609->+571. Il gate ha rimosso i trade ad ADX alto (direzionali/coltello)
  DENTRO ogni periodo, tenendo i momenti non-trend (chop-like) che pagano ovunque.
- **CONCENTRAZIONE 2023 CROLLATA**: da 92% del totale (ungated) a 40% (gated).
  Il motore non e' piu' 2023-dipendente -> molto piu' robusto.
- Aspettativa/trade **quasi TRIPLICATA**: +17.9 -> +50.4.

**LETTURA**: il gate ADX<=30 non e' un "chop-only switch": e' un SELETTORE DI
QUALITA' che tiene i momenti non-direzionali (dove il fade struttura paga) e
scarta i direzionali (dove muore), in OGNI regime. E' costitutivo e MISURATO.

**IL MURO CHE RESTA (e la strada che si APRE):**
- OHLC OTTIMISTA: +10135 e' FORMA. Serve il tick.
- MA: il tick BCM 2024-2026 (toro) e' un regime che l'UNGATED perdeva (PF 0.5).
  Il gate taglia i trend-trade -> **un GATED TICK su NASUSD BCM 2024-2026 e'
  FATTIBILE (tick c'e') e testa se il gate porta il tick da PF 0.5 a >=1 nel
  regime ATTUALE**. Se verde -> edge TICK-VERIFICATO nel toro di oggi ->
  DEPLOYABILE ora, SENZA aspettare Dukascopy. E' il prossimo round giusto.

## GATED TICK BCM -- 1o TENTATIVO: 0 TRADE, baco di SCALA ATR scovato (non un verdetto)

_Corsa: 30/08/2026 22:45, pin 6cef95d. Gemelli 769105/769106 su NASUSD BCM tick
2024-2026. RISULTATO: 0 trade. NON e' un verdetto -- e' un baco tecnico, scovato
dai contatori diagnostici._

- OnNewBar 37313, Ret No Pattern 34740 -> **2573 PATTERN rilevati** (il motore vede
  i setup). **Ret Gate Regime = 2573**: il gate ha BLOCCATO TUTTI. Trade = 0.
- Params confermati: RegimeGate=1, RegimeTF=16408 (D1), AdxMax=30, **AtrMinPts=100**,
  CloseHour=21.

**CAUSA (baco di scala ATR, feed-dipendente):** su _EXT (S2G) lo stesso gate a
ATR=100 lasciava passare 201 trade; su BCM NATIVO 0. Il _Point di NASUSD BCM
differisce dal custom _EXT -> l'ATR convertito (atrPrezzo/(InpMT5PerPuntoIndice*
_Point)) esce SOTTO 100 sempre -> la condizione ATR>=100 blocca tutto. L'ATR era
gia' inutile nella griglia (AtrMin 0==100 su _EXT). Pinnato a 100 credendolo neutro:
su BCM e' un muro.

**FIX: InpAtrMinPts 100 -> 0** (ATR OFF, solo ADX<=30). E' anche il discriminante:
se con ATR=0 appaiono trade -> era l'ATR (confermato, e leggiamo il PF vero); se
restano 0 -> ADX>30 sempre (toro forte, gate flat) o D1 no-data. Round rifatto con ATR=0.

### 2o TENTATIVO (ATR=0, pin 9e99e48): ANCORA 0 TRADE, gateBlk=2573

> ⚠️ **INVALIDATO IL 31/08 — CORSA MAI ESEGUITA.** Il generico ha trovato i CSV
> del 1o tentativo nella stessa workdir e ha SALTATO le passate (`-Rifai` non
> passato, generico:615): lo zip conteneva i numeri del 22:45, non una corsa
> nuova. Vedi la sezione "CORREZIONE DEL 31/08" in fondo. La diagnosi del muro
> ATR (trovata per lettura del codice) resta valida; questa "misura" no.

Con l'ATR spento il gate blocca ANCORA tutti i 2573 pattern (gateBlk=2573, 0 trade).
Quindi NON era (solo) l'ATR. Restano DUE ipotesi, e vanno separate:
- **(a) ADX(D1) > 30 per tutti i 2573**: il toro 2024-2026 e' cosi' trendante che
  il daily ADX non scende mai <=30 -> il gate tiene il CRT FLAT = COMPORTAMENTO
  GIUSTO (non perde nel regime sbagliato; e' la tesi "deploy sicuro").
- **(b) D1 no-data nel tester tick**: iADX/iATR su D1 non popolano in Modello 4 su
  simbolo nativo -> RegimeGateOk torna sempre false -> blocca tutto = BACO (live
  non tradebbe MAI, nemmeno nel chop -> inutile).
  NB: se ADX leggesse 0 (empty), 0<=30 sarebbe TRUE -> passerebbe. Blocca -> ADX
  legge >30 OPPURE CopyBuffer/BarsCalculated fallisce.

**IL DISCRIMINANTE (prossimo round, decisivo): InpAdxMax=100** (ADX<=100 sempre
vero) con ATR=0. Se appaiono trade -> il gate LEGGE il D1 (nessun baco), e lo 0 a
ADX<=30 era regime VERO (toro forte, gate flat = deploy sicuro). Se restano 0 ->
baco D1-no-data nel tester tick, da correggere nell'EA prima di ogni deploy.

**NOTA STRATEGICA (onesta)**: comunque vada, il payoff del CRT e' DIFFERITO -- vive
nel chop, che a tick BCM non raggiungiamo (serve Dukascopy), e nel toro attuale sta
(giustamente) flat = zero reddito ORA. Gli altri 5 motori (Chaos, DAX ReEntry, Dow
ModelB, H1 Retest, DAX ValueArea) sono non testati e potrebbero dare un mattone
deployabile nel regime ATTUALE. Dopo il discriminante, valutare il pivot.

### DISCRIMINANTE (pin 343e139, AdxMax=100, ATR=0): 0 TRADE -> BACO D1 CONFERMATO

Con InpAdxMax=100 (ADX<=100 e' SEMPRE vero, l'ADX va 0-100) + ATR=0, il gate blocca
ANCORA tutti i 2573 pattern (gateBlk=2573, 0 trade). Logica ferrea: se entrambe le
condizioni-soglia sono sempre vere, l'unico modo di bloccare e' RegimeGateOk()=false
per DATO MANCANTE. **CONFERMATO: iADX/iATR su D1 NON popolano nel tester Modello 4
(tick) su simbolo NATIVO BCM -> RegimeGateOk torna sempre false -> gate blocca tutto.**
NON e' il regime (ADX>30): e' un baco tecnico di lettura del D1 nel tester tick.

**PERCHE' su OHLC _EXT funzionava e su tick BCM no**: _EXT e' Modello 1 su simbolo
CUSTOM (D1 costruito dall'M1 importato -> disponibile); BCM tick e' Modello 4 su
simbolo NATIVO (il D1 higher-TF non viene servito all'handle come atteso).

**IMPLICAZIONE**: il gate FUNZIONA (provato su OHLC, ogni regime verde) e LIVE l'iADX
(D1) funziona (dati reali). Il baco e' SOLO nel tester tick -> NON possiamo
BACKTESTARE il gated a tick su BCM finche' l'EA non legge il D1 in modo robusto nel
tester. FIX EA necessario (warmup/robustezza dell'handle D1, o misura di regime
calcolata dalle barre M15 aggregate a giorno senza handle D1 separato). Poi rifare
il gated tick.

## CHIUSURA DELLA GIORNATA CRT (30/08, 23:30) — PARCHEGGIO ONESTO

> ⚠️ **INVALIDATO IL 31/08 — LE DUE CORSE "FINALI" NON SONO MAI PARTITE.**
> Stessa causa del 2o tentativo: workdir riusate senza `-Rifai` → il generico
> ha saltato tutto e i wrapper hanno raccolto i CSV stantii (header VECCHIO a
> 24 colonne, per-trade NON TROVATI, numeri byte-identici). La conclusione
> "anche CopyRates non consegna dati" e' COSTRUITA SU CODICE MAI ESEGUITO:
> l'EA v2 (CopyRates) e la v3 (fallback M15) non sono MAI stati visti dal
> tester. Vedi "CORREZIONE DEL 31/08" in fondo. Il parcheggio e' SOSPESO:
> prima si rifanno le corse per davvero.

Round finale (EA corretto con CopyRates, pin 1ae826a):
- GATED TICK (ADX<=30): 0 trade, gateBlk=2573.
- DIAG (ADX<=100, soglie sempre-vere): ANCORA 0 trade, gateBlk=2573.
Compilazioni fresche (68/70 KB): l'EA corretto E' girato. Il codice della lettura
regime e' stato riletto riga per riga: shift 1, riordino, minimi corretti. Eppure
RegimeGateOk torna sempre false -> anche CopyRates(D1) non consegna dati usabili
nel tester tick su nativo, in un modo che le griglie non mostrano piu'.

**LIMITE DIAGNOSTICO RAGGIUNTO (dichiarato):** dalle griglie headless non si vede
altro. Il prossimo passo utile e' un TEST SINGOLO MANUALE nel tester MT5 (GUI) con
l'EA instrumentato a stampare PERCHE' RegimeGateOk fallisce (got di CopyRates,
GetLastError, nAtr/nAdx, adx calcolato) e lettura del Giornale. E' un'altra
sessione di lavoro, non un altro giro di griglia.

**STATO FINALE DEL CRT (bilancio della giornata, tutto misurato):**
- Motore nudo: MORTO nel toro a tick (0/30, PF 0.5). VIVO nel chop su OHLC.
- GATE ADX<=30 su OHLC: VALIDATO e favoloso (+10135, ogni regime positivo,
  DD dimezzato, concentrazione risolta). La tesi chop-gate e' CONFERMATA su OHLC.
- Verdetto TICK del gated: NON OTTENIBILE oggi (baco lettura D1 nel tester tick,
  3 tentativi + fix + discriminanti). NON deployabile senza tick valido (regola).
- PARCHEGGIATO come candidato forte con 2 strade riaperte quando si vuole:
  (a) debug manuale MT5 col Giornale (1 sessione); (b) Dukascopy per il verdetto
  nel SUO regime (chop). I magic 7691xx restano riservati al CRT.

**PIVOT DICHIARATO:** il valore adesso e' nei 5 motori costruiti e MAI testati
(Chaos Lyapunov - riga gia' PRONTA -, DAX ReEntry, Dow ModelB, H1 NY Retest, DAX
ValueArea): possono dare un mattone deployabile nel regime ATTUALE.

---

## 🚨 CORREZIONE DEL 31/08 (mattina) — QUATTRO CORSE SU SEI NON SONO MAI PARTITE

_Scoperta analizzando lo zip DIAG delle 06:32 del 31/08 (pin 8d71a3b, EA v3):
CSV con l'header VECCHIO a 24 colonne (senza "Gate Via D1"/"Gate Via M15" che
la v3 appena compilata stampa), per-trade NON TROVATI, gateBlk=2573
byte-identico al giorno prima. Impossibile: o il CSV mentiva, o la corsa non
era mai partita. Era la seconda._

**LA CAUSA (una riga, `walkforward_generico.ps1:615`):** se il CSV col tag
della passata esiste gia' nella workdir e `-Rifai` non e' passato, il generico
stampa `gia' fatto, salto` e NON esegue. E' una feature (riprendere griglie
interrotte), ma i wrapper TICK_G e TICK_DIAG riusano la stessa workdir a ogni
lancio → dal secondo lancio in poi TUTTO viene saltato e lo zip impacchetta i
CSV del giro prima come fossero freschi.

**IL CENSIMENTO CORRETTO delle 6 corse tick della saga:**

| Ora | Round | Pin | EA | Eseguita? |
|---|---|---|---|---|
| 30/08 22:45 | TICK_G (ATR=100) | 6cef95d | v1 handle | ✅ VERA (workdir vergine) |
| 30/08 22:52 | TICK_G "ATR=0" | 9e99e48 | v1 | ❌ SALTATA (CSV stantio) |
| 30/08 23:07 | DIAG (ADX≤100) | 343e139 | v1 | ✅ VERA (workdir vergine) |
| 30/08 23:26 | TICK_G "CopyRates" | 1ae826a | v2 | ❌ SALTATA |
| 30/08 23:29 | DIAG "CopyRates" | 1ae826a | v2 | ❌ SALTATA |
| 31/08 06:32 | DIAG v3 | 8d71a3b | v3 | ❌ SALTATA |

**COSA RESTA IN PIEDI (misurato su corse VERE):**
- Il baco degli HANDLE iADX/iATR D1 nel tester tick su nativo e' PROVATO:
  la DIAG delle 23:07 (vera, soglie sempre-vere ADX≤100+ATR=0) ha dato 0 trade
  con 2573 pattern → RegimeGateOk()=false per dato mancante. Questo regge.
- Il gate ADX≤30 VALIDATO su OHLC (+10135, ogni regime positivo) regge: quelle
  erano corse OHLC su workdir proprie, mai riusate.

**COSA CADE (conclusioni su codice mai eseguito):**
- "Anche CopyRates fallisce" → MAI MISURATO. La v2 non e' mai girata.
- "La v3 non risolve" → MAI MISURATO. La v3 non e' mai girata.
- Il "LIMITE DIAGNOSTICO RAGGIUNTO" e il parcheggio della chiusura → SOSPESI.
  Il verdetto tick del gated CRT e' forse a UNA corsa vera di distanza.

**IL FIX (fatto, 31/08):** `-Rifai` aggiunto all'`$argv` del generico in
ENTRAMBI i wrapper (`RIGA_CRT_TICK_G.ps1`, `RIGA_CRT_TICK_DIAG.ps1`) — un
wrapper di verdetto non riprende mai: rifa'. Classe nuova aggiunta a
`CHECKLIST_RIGA_DI_LANCIO.md` (skip-senza-Rifai + controllo di freschezza:
header coerente con l'EA compilato, per-trade presenti, numeri non identici).

**PROSSIMO PASSO:** rilanciare la DIAG (v3, ADX≤100) col pin nuovo — stavolta
girera' davvero — e leggere n + "Gate Via D1"/"Gate Via M15". Poi TICK_G per
il verdetto.

## ✅ DIAG VERA (31/08 08:23, pin ba56eeb, EA v3): IL GATE RICEVE I DATI — VIA D1

_Prima esecuzione REALE della v3 (freschezza verificata: modo CORSA, compile
81KB 08:23:13, per-trade 2/2, header a 26 colonne). Zip
CRT_TICK_DIAG_CORSA_20260831_0823._

- **Trades = 2039** (era 0). **Gate Via D1 = 1269, Gate Via M15 = 0**: il
  CopyRates(D1) introdotto in v2 LEGGE il daily nel tester tick — il baco era
  SOLO negli handle iADX/iATR (provato il 30/08 alle 23:07), il fallback M15
  della v3 non e' mai servito. Ret Gate Regime = 156 = solo warmup iniziale.
- Gemelli 769107/769108 byte-identici: determinismo OK.
- Controprova di coerenza: ADX<=100 = gate spento -> PF 0.462, -75354,
  DD 76.5% — nel range dell'ungated morto (0.43-0.73). Il banco e' lo stesso.

**CONSEGUENZA: la strada al verdetto tick e' APERTA. Prossima corsa: TICK_G
(ADX<=30), stesso pin — IL verdetto del gated CRT nel toro.**
