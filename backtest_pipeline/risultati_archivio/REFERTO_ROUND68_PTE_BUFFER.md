# 🎯 R68 — IL BUFFER DELLA PTE **HA VITA PROPRIA**, e dimezza il drawdown

_Risponde alla domanda di R68: tolto l'effetto sul target, il buffer conta
ancora? **Sì, moltissimo — e non era quello che mi aspettavo.**_

**Banco:** GBPUSD H1, **OHLC**, deposito 100.000, rischio 1%.
IS **2010.07.06 → 2016.11.26** · OOS → **2026.06.30** (sedici anni).
**28 celle**: `SLbufferPips` {0,5,10,15,20,25,30} × `TP2_ATRmult` {1,5-3,0}.
`SLfromDoji` pinnato a 0. **28 celle su 28 positive fuori campione.**

---

## 1. 🔑 IL CONFRONTO A **R COSTANTE** — ed e' la prova

Con `buffer = 0` lo stop e' esattamente ATR, quindi **`R_target = TP2mult`
esatto**. Era la scorciatoia che rendeva il round possibile senza misurare
l'ATR. Ora si confrontano celle **con lo stesso R** ma buffer diverso
(**[INFERITO]** con ATR ≈ 20 pip su GBPUSD H1):

| cella | R ≈ | IS | **OOS** | **PF** | **DD** |
|---|---:|---:|---:|---:|---:|
| buffer **0** · TP2 2,0 | 2,00 | +24 | +1.726 | 1,027 | **17,91%** |
| buffer **10** · TP2 3,0 | 2,00 | **+2.179** | **+8.310** | **1,191** | **8,88%** |
| buffer **0** · TP2 1,5 | 1,50 | −570 | +86 | 1,001 | **18,02%** |
| buffer **20** · TP2 3,0 | 1,50 | **+4.582** | **+3.401** | **1,095** | **9,57%** |

> ### 🎯 **A parità di R, le versioni col buffer fanno 5 volte il profitto e METÀ del drawdown.**
>
> **Esito B, e senza ambiguità: il buffer NON è l'R travestito. Fa una cosa
> sua, e quella cosa vale moltissimo.**

## 2. 📉 IL SEGNALE PIÙ PULITO DELLA GRIGLIA: il drawdown

**Drawdown OOS, tutte e 28 le celle:**

| buffer | TP2 1,5 | TP2 2,0 | TP2 2,5 | TP2 3,0 |
|---:|---:|---:|---:|---:|
| **0** | 18,02 | 17,91 | 17,50 | 17,11 |
| 5 | 13,13 | 13,38 | 13,04 | 12,69 |
| 10 | 9,26 | 9,50 | 9,21 | 8,88 |
| 15 | 9,55 | 9,78 | 9,51 | 9,25 |
| 20 | 9,82 | 10,05 | 9,80 | 9,57 |
| 25 | 8,32 | 8,53 | 8,32 | 8,10 |
| **30** | **6,71** | **6,70** | **6,50** | **6,32** |

**Il DD scende col buffer e non si muove quasi per niente col target.**
Da **18%** a **6,3%**, mentre lungo ogni riga il TP2 sposta il DD di due
decimi. **Il drawdown è una funzione del buffer, punto.**

### Il meccanismo, in una riga

Con `buffer = 0` lo stop sta **esattamente a un ATR**: viene preso dal
rumore ordinario. Ogni pip di buffer lo allontana dal rumore. **Il buffer non
è una rifinitura dello stop: è ciò che decide quante volte vieni fermato per
niente.**

## 3. 🔴 E LA CONFIGURAZIONE VIVA È QUASI LA PEGGIORE

`InpSLbufferPips = 5` — quello che gira in forward — ha **DD 13,38%**:
seconda peggiore di sette, battuta solo dallo stop nudo a buffer 0.
**È a un passo dal non avere buffer affatto.**

## 4. ⚖️ MA IL CRITERIO CONGELATO **NON È SODDISFATTO**, e vale più della tentazione

Il criterio 2, scritto prima dei numeri: _"una configurazione entra in
discussione **solo se abbassa il DD SENZA perdere profitto OOS**"_.

| | IS | OOS | PF | DD | pegg. GG |
|---|---:|---:|---:|---:|---:|
| **VIVA** `buf 5 / TP2 2,0` | −1.068 | **+3.932** | 1,074 | 13,38% | −1,71% |
| centro altopiano `buf 25 / TP2 2,5` | +4.127 | +3.357 | **1,106** | **8,32%** | −1,35% |
| miglior IS `buf 20 / TP2 2,5` | **+5.501** | +3.001 | 1,084 | 9,80% | −1,39% |
| miglior OOS `buf 30 / TP2 3,0` | +1.268 | +5.823 | 1,214 | **6,32%** | −1,32% |

La candidata scelta col metodo (**centro dell'altopiano, mai il picco** →
`buffer 25`) **abbassa il DD di 5 punti ma perde 575 di profitto OOS**.

> 🔴 **Quindi non entra. Criterio applicato.**
>
> E lo dico sapendo che scambiare 575 euro di profitto per **cinque punti di
> drawdown** è, in ottica prop, un affare. **Ma il criterio era scritto
> prima, e si cambiano i criteri prima dei numeri, non dopo.**

📌 **È esattamente il caso che la discussione sui "cancelli a due livelli"
aveva previsto**: un cancello unico boccia una configurazione che è peggiore
per *rendimento* e migliore per *sopravvivenza*. Se un giorno si separano i
due cancelli, questa cella è il primo esempio da rileggere.

## 5. ✍️ E RITIRO UN'IPOTESI CHE AVEVO FATTO IN R67

In R67 avevo scritto che se il buffer si fosse rivelato solo un R travestito,
_"la PTE avrebbe un parametro in meno"_. **È il contrario.** Il buffer fa un
lavoro che nessun altro parametro fa, e la PTE **non ha un parametro di
troppo: ne ha uno tarato male.**

---

## 6. 🚦 VERDETTO

> **Il buffer ha vita propria: a R costante dimezza il drawdown e
> quintuplica il profitto OOS. E il valore che gira (5) è il secondo
> peggiore dei sette.**
>
> **Ma non si cambia niente**: il criterio congelato non è soddisfatto, è
> OHLC e non un verdetto, ed è un simbolo solo di una famiglia da tre.

**Il seguito, in ordine e con la tesi già scritta:**
1. **Ripetere su Dow e USDJPY** (celle 7 e 9 di R52) — la PTE è una famiglia
   e i verdetti sono di famiglia. **Se il DD scende col buffer anche lì, non
   è un caso di GBPUSD: è una proprietà del motore.**
2. Solo dopo, **tick reali** sulla cella che sopravvive ai tre simboli.
3. E allora — **non prima** — la decisione se toccare il forward, che resta
   di Claudio e non di questo referto.
