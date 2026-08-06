# FASE H — il drawdown. Risposta secca: **no.**

07/08/2026. 64 pass a tick reali, DAX e Nasdaq, finestre IS e OOS.
Griglia: `InpRetestOffsetPts` ∈ {0, 100, 200, 300} × `InpAtrSlMult` ∈ {1,0 · 1,5 · 2,0 · 2,5},
con `InpSLMode = 1` (stop calcolato sull'ATR invece che sul range).

Tutto il resto è **il candidato validato**: `RETEST` · range 35 · buffer 500, rischio 1%,
TP 3R + parziale 50% + breakeven, trailing base candela **M5** — cioè esattamente la
gestione che gira in forward.

---

# La domanda e la risposta

**Domanda:** il candidato DAX fa +1198,79 con PF 1,237 ma un drawdown del **10,49%**.
Rapporto resa/DD 0,65, contro l'1,5 che una prop chiede. **Sostituire lo stop preso dal
range con uno stop ad ATR riduce il drawdown senza buttare via il profitto?**

**Risposta: no, lo peggiora — su tutte e due le cose insieme.**

| | profitto OOS | PF | Equity DD % |
|---|---:|---:|---:|
| **riferimento — stop dal RANGE** (B1) | **+1198,79** | **1,237** | **10,49%** |
| miglior cella ad ATR (offset 300, ×2,5) | +734,00 | 1,118 | 12,36% |
| stessa geometria del candidato (offset 200, ×2,5) | +496 | 1,076 | 14,70% |

**Nessuna delle 16 celle ATR batte il riferimento.** Non una sola, né sul profitto né sul
drawdown. Lo stop preso dal range vince a mani basse.

**Il candidato non si tocca.** La FASE H ha fatto il suo mestiere: ha chiuso una strada.

---

# La griglia — DAX, fuori campione

profitto / PF / DD%

| offset | ATR ×1,0 | ATR ×1,5 | ATR ×2,0 | ATR ×2,5 |
|---|---|---|---|---|
| 0 | −1970 · 0,807 · **24,7%** | −83 · 0,991 · 20,8% | +526 · 1,065 · 17,9% | +458 · 1,066 · 14,0% |
| 100 | −1381 · 0,864 · 22,0% | −251 · 0,972 · 20,7% | +32 · 1,004 · 19,8% | +112 · 1,016 · 14,7% |
| 200 | −1048 · 0,898 · 23,9% | −291 · 0,967 · 22,1% | +349 · 1,047 · 16,8% | +496 · 1,076 · 14,7% |
| 300 | −937 · 0,905 · 20,5% | +133 · 1,015 · 18,2% | +656 · 1,091 · 14,5% | **+734 · 1,118 · 12,4%** |

## 🟢 E qui c'è la cosa che vale davvero: **16 celle su 16 dicono la stessa cosa**

Leggi le righe da sinistra a destra. **In ognuna delle quattro, allargare lo stop alza il
profitto e abbassa il drawdown insieme.** Sempre. In tutte e quattro le righe il DD scende
in modo **monotòno** dal moltiplicatore 1,0 al 2,5:

```
offset 0    24,7% -> 20,8% -> 17,9% -> 14,0%
offset 100  22,0% -> 20,7% -> 19,8% -> 14,7%
offset 200  23,9% -> 22,1% -> 16,8% -> 14,7%
offset 300  20,5% -> 18,2% -> 14,5% -> 12,4%
```

**Il drawdown non lo fa la geometria: lo fa lo stop stretto.** E siccome il lotto è calcolato
sul rischio, uno stop più largo significa **posizione più piccola con più respiro** — che è
esattamente la forma che serve a una prop.

Lo stesso segnale si vede in campione (IS), dove la riga offset 300 va da −1382 a +313
salendo con il moltiplicatore.

**Il riferimento vince perché lo stop dal range è ancora più largo del ×2,5.** La curva
non ha ancora girato: **al ×2,5 sta ancora migliorando.** Non sappiamo dov'è il massimo.

---

# ⚠️ Il controllo che va fatto PRIMA di credere a questa conclusione

Il numero di trade **cala** man mano che lo stop si allarga:

| | ×1,0 | ×1,5 | ×2,0 | ×2,5 |
|---|---:|---:|---:|---:|
| DAX OOS, offset 0 | 324 | 319 | 301 | 283 |
| DAX OOS, offset 300 | 324 | 304 | 282 | **270** |

**Da 324 a 270: il 17% dei trade sparisce.** Con `InpOneTradePerDay = 1` e nessun filtro di
range acceso (`InpMinRangePts = 0`, `InpMaxRangePts = 0`, `InpSkipIfTight = 0`), quei trade
non dovrebbero mancare.

L'ipotesi più probabile: **stop più largo → lotto più piccolo → sotto il lotto minimo del
broker → il trade viene saltato.** Se è così, una parte del "miglioramento" non viene dallo
stop largo ma dal **filtro involontario** che scarta le giornate a range ampio.

**Finché non è verificato, la regola "stop più largo = meglio" resta una tendenza forte, non
una conclusione.** È lo stesso tipo di trappola del bug del breakeven al lotto minimo.

---

# 📉 IS e OOS non sono d'accordo. Ancora.

| | miglior cella IS | cosa fa quella cella in OOS |
|---|---|---|
| DAX | **offset 100 · ×2,0** → +1012, DD 7,7% | **+32**, DD 19,8% |

La cella migliore in campione, fuori campione **non guadagna niente e raddoppia il
drawdown**. La migliore in OOS (offset 300 · ×2,5) in campione era una cella di mezzo
(+313).

**Quarta conferma consecutiva** che l'IS serve a dire *se una regione esiste*, mai a
scegliere quale cella prendere.

---

# 🔴 Nasdaq: **zero celle positive su 16** fuori campione

| offset | ATR ×1,0 | ATR ×1,5 | ATR ×2,0 | ATR ×2,5 |
|---|---|---|---|---|
| 0 | −2445 | −1353 | −1071 | −718 |
| 100 | −2701 | −1237 | −1009 | −707 |
| 200 | −2100 | −1434 | −756 | −563 |
| 300 | −1939 | −1394 | −980 | **−329** |

La cella meno peggiore perde 329 €. **PF massimo 0,944: nemmeno una configurazione arriva a
1,0.** Vale la stessa tendenza del DAX — allargare lo stop riduce il danno — ma partendo da
un sistema che non guadagna, riduce solo la velocità con cui perde.

**È il quinto test indipendente che l'apertura Nasdaq fallisce:**
geometria breakout · costo/slippage · geometria retest · realismo dei riempimenti · **stop e
drawdown**. Resta in piedi solo `RangeMode = 2` (C6), che è la configurazione che gira in
forward e non è mai stata testata.

---

# 🚨 La scoperta laterale, ed è quella che pesa di più per una prop

Colonna **Peggior Giornata %**, al rischio dell'1%:

| | peggior giornata |
|---|---|
| DAX, tutte e 32 le celle (IS+OOS) | da **−1,02%** a **−1,28%** |
| Nasdaq OOS, tutte le celle | da −0,87% a −0,97% |
| **Nasdaq IS, le quattro celle ad ATR ×1,0** | **−5,19% · −5,20% · −5,23% · −5,24%** |

Quattro celle diverse, **la stessa giornata**, e una perdita di **oltre cinque volte il
rischio nominale** su un sistema che fa **un trade al giorno**.

Il meccanismo è coerente con tutto il resto: stop strettissimo → lotto enorme → un salto di
prezzo attraverso lo stop viene moltiplicato per quel lotto. **Lo stop stretto non alza solo
il drawdown medio: crea la coda.**

Con una regola prop da −5% giornaliero, **quella giornata sola avrebbe chiuso il conto**, al
rischio dell'1%.

Sul DAX la stessa colonna non si muove mai da ~1,1× il rischio nominale: **lì il
dimensionamento tiene.**

⚠️ Vale il limite già noto (B10): questa metrica misura **un EA alla volta**, non il
portafoglio. La giornata vera è la somma di tutti quelli accesi sul simbolo.

---

# Cosa si fa

## Deciso adesso, senza altri test

1. **Il candidato DAX resta com'è:** `RETEST` · range 35 · buffer 500 · offset 200, **stop
   dal range**. La FASE H non ha trovato niente di meglio: ha confermato la scelta.
2. **Lo stop ad ATR è archiviato** per le aperture. Non è una strada.

## Il test successivo, che adesso è ovvio

3. **Verificare i trade che spariscono** (il 17%). Serve prima di tutto il resto: se
   l'effetto è il lotto minimo, metà di questa fase va riletta.
4. **Estendere il moltiplicatore a 3,0 / 3,5 / 4,0** per trovare dove la curva gira, e
   soprattutto **misurare quanto vale in ATR lo stop dal range** — così sappiamo se il
   riferimento è già il massimo o se sta solo più a destra di dove abbiamo guardato.

## Sulla flotta

5. **L'apertura Nasdaq ha fallito cinque test su cinque.** Prima di lasciarla accesa al 2%
   va fatto C6, e se anche quello fallisce la decisione è una sola.
