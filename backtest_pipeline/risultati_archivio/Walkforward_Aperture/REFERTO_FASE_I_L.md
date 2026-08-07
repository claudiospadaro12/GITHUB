# FASE I e FASE L — 07/08/2026

Due domande, due risposte. Una **annulla una decisione già presa in forward**, l'altra
chiude il Nasdaq d'apertura.

⚠️ **Prima di tutto: come si è comportato MT5 sugli enum.** Non spazzola *tutti* i valori
dell'enum: spazzola **tutti i membri dell'enum compresi fra `start` e `stop`**, ignorando lo
`step`. Con `InpTrailTF=5||1||4||5||Y` sono usciti **M1, M2, M3, M4, M5** — cinque celle, non
ventidue. È più preciso di quanto avessi scritto, e cambia come si progettano le fasi:
**gli estremi contano, lo step no.**

---

# FASE I — il timeframe del trailing

Configurazione: `BREAKOUT`, range 15, buffer 300, gestione accesa (TP 3R + parziale 50% +
breakeven), rischio 1%, `TRAIL_PREVBAR`. Sweep su `InpTrailTF`.

## ❌ Il controllo dichiarato è FALLITO — e questo è il risultato

Prima di lanciare avevo scritto:

> *«Sul DAX questa fase serve anche da controllo del metodo: **deve ritrovare M5 meglio di
> M1**, altrimenti la misura è sbagliata e non mi fido del resto.»*

**Non l'ha ritrovato.** Ma la ragione non è che la misura è rotta: è che **la misura del
05/08 era in campione.**

### DAX — profitto per timeframe

| | M1 | M2 | M3 | M4 | M5 |
|---|---:|---:|---:|---:|---:|
| **IS** | −493,33 | −203,67 | +206,81 | +139,48 | **+347,62** |
| **OOS** | **−855,73** | −1253,58 | −1040,55 | −1081,92 | **−1298,56** |

**In campione vince M5 e perde M1. Fuori campione vince M1 e perde M5.**
I due estremi si scambiano di posto; i tre in mezzo restano nell'ordine.

```
DAX   IS   migliore -> peggiore:   M5  M3  M4  M2  M1
DAX   OOS  migliore -> peggiore:   M1  M3  M4  M2  M5
Spearman IS -> OOS sul profitto:   -0,60
```

**Il 05/08 il DAX è stato spostato da M1 a M5 in forward** sulla base di *«440 trade: M1 −801
· M5 −79»*. Quel numero **è compatibile con la riga IS di questa tabella**, non con la riga
OOS. È stata una scelta in campione, applicata a soldi veri.

### Nasdaq — profitto per timeframe

| | M1 | M2 | M3 | M4 | M5 |
|---|---:|---:|---:|---:|---:|
| **IS** | **+469,39** | +156,74 | +171,84 | +63,75 | +156,84 |
| **OOS** | −550,34 | **−340,50** | −1567,25 | −1579,43 | −1513,57 |

```
Spearman IS -> OOS sul profitto:   +0,30
```

Qui l'ordine regge meglio, e dice una cosa netta: **M1 e M2 stanno davanti, M3/M4/M5 stanno
molto indietro** — in tutte e due le finestre.

## 🔴 Conseguenza immediata: l'esperimento che avevo proposto era sbagliato

Dopo la pagella del 06/08 avevo scritto che l'esperimento da fare era **spostare il trailing
delle aperture Nasdaq da M1 a M5**. I numeri dicono il contrario:

```
Nasdaq OOS:   M1 -550,34      M5 -1513,57
```

**M5 sarebbe costato quasi tre volte tanto.** Il 17% di movimento catturato il 06/08 è un
problema vero, ma **non si risolve allungando il timeframe del trailing.**

## ⚠️ Due limiti da tenere, prima di usare questi numeri

1. **Tutte e dieci le celle OOS sono negative.** Questa fase gira su `BREAKOUT` range 15, che
   è la geometria che abbiamo già bocciato. Stiamo ordinando *modi di perdere*: dire quale
   trailing è meno peggio su un sistema che perde **non dimostra** quale sia il migliore su
   un sistema che guadagna. **La fase va rifatta sul candidato validato** (`RETEST` 35/500/
   offset 200) prima di toccare qualsiasi cosa.
2. **Le metriche non concordano.** Sul DAX OOS il profitto e il payoff medio danno M1 come
   migliore, ma il **Profit Factor** dà M4 (0,828 contro 0,777 di M1). M1 perde meno in
   totale e per trade, ma con un rapporto peggiore fra vincite e perdite lorde. Quando due
   metriche non concordano, la cella non è un vincitore: è un pareggio.

**Quindi: non si cambia niente sul trailing, né sul DAX né sul Nasdaq.**

---

# FASE L — da dove si prende il range. La vecchia C6.

Configurazione: `RETEST`, buffer 500, offset 200, gestione accesa, 1%.
Sweep su `InpRangeMode` × `InpRangeMinutes` {15, 35}.

```
0 = OPENING   primi N minuti DOPO l'apertura
1 = PREV      massimo/minimo dei 60 minuti PRIMA
2 = PREVBAR   massimo/minimo della candela precedente su H1
```

## ✅ Un controllo di coerenza che passa

Con `RangeMode` 1 e 2 le righe a range 15 e a range 35 sono **identiche al centesimo**.
È **giusto che lo siano**: `InpRangeMinutes` lo usa solo `OPENING`. Il rilevatore delle
"righe identiche = un ramo che non gira" qui si accende come previsto, e conferma che
i tre rami fanno davvero cose diverse.

## 🔴 Nasdaq, fuori campione: la configurazione ACCESA è la peggiore delle tre

| RangeMode | range | Profit | PF | Equity DD % |
|---|---:|---:|---:|---:|
| 0 OPENING | 35 | **+107,19** | 1,022 | 7,88% |
| 0 OPENING | 15 | −681,90 | 0,886 | 11,70% |
| 1 PREV | — | −1600,74 | 0,798 | 17,35% |
| **2 PREVBAR** | — | **−2444,14** | **0,665** | **26,29%** |

**`ABTG_Nasdaq_Apertura_US` e `ABTG_Nasdaq_Apertura_US_Ottimizzato` girano
`ABTG_DEF_RANGE_MODE 2`** — verificato nel codice. Cioè **PREVBAR, la riga peggiore della
tabella**: −2444 € fuori campione, Profit Factor 0,665, drawdown **26,29%** al rischio
dell'1%. Al 2%, che è quello che gira, il drawdown va oltre il 50%.

**C6 è chiusa, ed è la sesta bocciatura.** L'ultima ipotesi in piedi sul Nasdaq d'apertura
non solo non salva niente: è la configurazione **peggiore** delle tre, e sta girando adesso.

## DAX, in campione

| RangeMode | Profit | PF | DD |
|---|---:|---:|---:|
| 1 PREV | +509,69 | 1,109 | 10,86% |
| 2 PREVBAR | +380,16 | 1,080 | 10,00% |
| 0 OPENING (35) | −9,02 | 0,998 | 8,41% |
| 0 OPENING (15) | −1241,91 | 0,760 | 17,04% |

In campione `PREV` e `PREVBAR` battono l'apertura classica. **Ma questa fase ha appena
mostrato, sul trailing, che l'IS può invertirsi del tutto fuori campione**, e il DAX gira
`RangeMode 0`. **Serve `DAX_L_rangemode_OOS` prima di dire qualsiasi cosa**, ed è uno dei due
file che mancano.

---

# Cosa si fa

## Deciso

1. **Niente cambi al trailing**, su nessun EA. La misura che aveva motivato il passaggio a M5
   sul DAX era in campione e fuori campione si inverte. Il forward attuale resta com'è
   finché la fase non è rifatta sulla geometria giusta.
2. **L'apertura Nasdaq è chiusa come ricerca.** Sei test indipendenti falliti, e la
   configurazione accesa è la peggiore misurata: PF 0,665 e DD 26,29% all'1%.
   **Va spenta o portata a rischio simbolico. È una decisione di Claudio, non un test.**

## Da fare

3. **Rifare la FASE I sul candidato** `RETEST` 35/500/offset 200 — ordinare i trailing su un
   sistema che perde non dice quale vince su un sistema che guadagna.
4. **Mancano due CSV**: `DAX_L_rangemode_OOS` e `NASDAQ_L_rangemode_IS`.
5. **Errore mio nella progettazione della fase**: ho pinnato `InpBufferPoints = 300` su
   entrambi i simboli. È il buffer del Nasdaq live; il DAX live usa **200**. Le righe DAX
   della FASE I non corrispondono quindi a nessuna configurazione reale. Non cambia le
   conclusioni (il confronto fra timeframe è interno alla stessa configurazione), ma va
   corretto prima di rifarla.
