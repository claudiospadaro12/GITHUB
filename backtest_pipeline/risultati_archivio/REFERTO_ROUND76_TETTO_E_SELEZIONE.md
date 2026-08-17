# 🔓 R76 — **IL TESTER LEGGE DAL 2000.** E per la prima volta la regola della finestra è SODDISFATTA.

> ## ✍️ CORREZIONE (aggiunta con R77, stesso giorno)
> **Questo round ha girato con `InpTP1_ATRmult = 0`**, non con lo `0.5` delle
> sedie del vivaio R23: il file prova `PTE_FINESTRA_VECCHIA_O_RECENTE.txt` non
> pinna quel parametro e passa il default del sorgente. È lo stesso difetto
> trovato fra R72 e R73.
> - ✅ **I confronti fra celle restano validi** (tutte hanno lo stesso `TP1`).
> - 🔴 **La riga chiamata "VIVA" NON è la sedia viva**: va letta come
>   **`buffer 5 (TP1=0)`**.
> - 🔴 **RITIRATA la frase «su tredici anni la configurazione viva avrebbe
>   sfondato il muro della prop»**: quel 13,7% è di una configurazione che in
>   forward non gira. Il fatto che *`buffer 0` e `buffer 5` sfondino* resta,
>   ma riferito a `TP1=0`.
>
> La corsa che chiude il punto è **R78**, con `TP1` pinnato a 0,5.

_Chiude l'`[INCERTO]` aperto dalla sonda: il tetto delle 100.000 barre
bloccava anche lo Strategy Tester?_

**Banco:** `ABTG_PTE` · GBPUSD H1 · **OHLC** · griglia di R68/R71 (28 celle) ·
rischio 1% · `-DaQuando 2000.01.01 -FrazioneIS 0.5`.
**IS `2000.01.01 → 2013.03.31`** (13,2 anni) · **OOS `2013.04.01 → 2026.06.30`** (13,2 anni).
Igiene: 2 CSV su 2, 28 celle su 28, `FromDate` onorata nelle `.ini`.

---

## 1. 🔓 LA RISPOSTA: **IL 2000 SI LEGGE**

| | n IS | n OOS |
|---|---:|---:|
| R71 (dal 2016, 5,25 anni di IS) | 190-256 | 159-281 |
| **R76 (dal 2000, 13,2 anni di IS)** | **440-631** | **461-695** |

**Il numero di operazioni scala con gli anni: il tester ha letto davvero dal
2000.** Il tetto delle 100.000 barre che fermava le serie del terminale al
`2010.07.06` **non ferma lo Strategy Tester**.

> ### ⚠️ Quello che NON posso dire: **se sia sempre stato così, o se sia perché il tetto è stato alzato poco prima di questa corsa.**
> Le due cose sono successe nello stesso momento e **non le so separare**.
> È una domanda per Claudio, non una deduzione: *hai alzato "Max barre nel
> grafico" prima o dopo aver lanciato?* Se **prima**, la causa resta aperta;
> se **dopo**, il tester non è mai stato capped e **avevamo ventisei anni
> disponibili da sempre.**

## 2. 🎯 E PER LA PRIMA VOLTA IN TUTTA LA SERIE: **LA SELEZIONE NON È SOSPESA**

Il punto A chiede **150 trade nell'IS e 150 nell'OOS**. Qui: **440-631 e
461-695**. **Passata, e di quattro volte.**

**Profitto medio IS per riga di buffer** (è su questo che si sceglie):

| buffer | 0 | 5 | 10 | 15 | 20 | 25 | 30 |
|---:|---:|---:|---:|---:|---:|---:|---:|
| media IS | −15.625 | −9.358 | −5.711 | −8.220 | −8.975 | **−4.272** | **−3.941** |

Le tre righe migliori sono `10`, `25`, `30` → **centro = `buffer 25`**, e sulla
colonna il TP migliore in IS è `2,0`.

| | IS | **OOS** | PF | **DD** | pegg. GG | n OOS |
|---|---:|---:|---:|---:|---:|---:|
| 🪑 **VIVA** `buf 5 / TP 2,0` | −9.118 | **+5.747** | 1,068 | **16,11%** | — | 523 |
| 🎯 **SCELTA COL METODO** `buf 25 / TP 2,0` | −4.076 | **+8.919** | **1,185** | **8,99%** | −1,35% | **663** |
| picco IS (vietato) `buf 30 / TP 2,0` | −3.763 | +10.101 | | 6,80% | | 692 |
| miglior OOS possibile `buf 10 / TP 2,5` | | +11.906 | 1,172 | 9,51% | | 590 |

> ## 🎯 **La cella scelta col metodo batte quella viva su ENTRAMBI i fronti: +8.919 contro +5.747 di profitto, e 8,99% contro 16,11% di drawdown.**
>
> **Il criterio 2 — _"abbassa il DD SENZA perdere profitto OOS"_ — è
> SODDISFATTO. Per la prima volta, e con una selezione che il campione
> autorizza davvero.** Cattura **74,9%** dell'ottimo raggiungibile.

## 3. 📉 TREDICESIMA E QUATTORDICESIMA CONFERMA — su tredici anni per parte

| buffer | 0 | 5 | 10 | 15 | 20 | 25 | 30 |
|---:|---:|---:|---:|---:|---:|---:|---:|
| **DD IS** | **25,19** | 21,07 | 17,15 | 17,29 | 16,00 | 12,53 | **11,20** |
| **DD OOS** | **19,89** | 16,11 | 9,97 | 9,78 | 10,04 | 8,99 | **6,80** |

**Da 25% a 11% in campione, da 20% a 6,8% fuori.** La relazione regge anche
sulla finestra più lunga mai misurata su questo motore.

### 🧱 E qui il muro della prop diventa concreto

A rischio **0,65%** (quello di casa, da MC p99):

| | DD IS scalato | dentro il muro del 10%? |
|---|---:|---|
| `buffer 0` | **16,4%** | 🔴 **NO — sfondato** |
| `buffer 5` (la viva) | **13,7%** | 🔴 **NO** |
| `buffer 25` | 8,1% | ✅ sì |
| `buffer 30` | **7,3%** | ✅ sì |

> 🎯 **Su tredici anni, la configurazione che gira in forward avrebbe rotto il
> muro della prop. Quella scelta col metodo no.** Non è una preferenza di
> stile: è la differenza fra un conto vivo e un conto chiuso.

## 4. ✍️ E CORREGGO UNA FRASE DI R71

In R71 avevo scritto, in grassetto: **«NON È IL CALENDARIO, È IL 2021»**.
Con la finestra lunga non regge come l'avevo messa:

| finestra IS su GBPUSD | celle positive |
|---|---|
| **2000-2013** (R76) | **0 / 28** 🔴 |
| 2010-2016 (R68) | maggioranza 🟢 |
| 2016-2021 (R71) | **0 / 28** 🔴 |
| 2019-2022 (R70) | 3 / 28 🔴 |
| 2013-2026 · 2021-2026 (OOS) | **28 / 28** 🟢 |

**Non c'è UN punto di svolta: ci sono epoche buone e cattive che si
alternano.** La regola C (_il regime conta più della storia contigua_) esce
**rafforzata**; la sua versione con una data sopra, **ritirata**.

📌 **Spearman IS→OOS = +0,546**, la settima positiva di fila su questa griglia.
Il motivo resta quello scritto in R71: **qui c'è un asse con dentro un effetto
fisico**, non una taratura.

---

## 5. 🚦 VERDETTO

> **1. 🔓 Il tester legge dal 2000: n IS 440-631, n OOS 461-695. La regola
> della finestra è soddisfatta per la prima volta, e di quattro volte.**
>
> **2. 🎯 La selezione non è più sospesa, e la cella scelta col metodo
> (`buf 25 / TP 2,0`) batte la viva su profitto E drawdown: +8.919 contro
> +5.747, 8,99% contro 16,11%.**
>
> **3. 🧱 A 0,65% di rischio, su tredici anni, la configurazione viva avrebbe
> sfondato il muro del 10%. Quella scelta no.**
>
> **4. 📉 Tredicesima e quattordicesima conferma del buffer sul drawdown.**
>
> **5. ✍️ Ritirata la frase «è il 2021»: sono epoche che si alternano.**

## 6. 🔴 E PERCHÉ **ANCORA** NON SI TOCCA NIENTE

**Questo round è OHLC.** R73, a **tick reali**, ha misurato che la stessa
candidata **perde un terzo del profitto** contro la viva. Le due cose non si
contraddicono — **rispondono su finestre diverse** (13 anni contro 2) e con
**modelli diversi** — ma la regola di casa è chiara: **OHLC propone, i tick
decidono.**

🔴 **E il round a tick reali su tredici anni NON SI PUÒ FARE**: i tick di BCM
partono dal 2024.07.05. **Questa è la tensione vera del progetto, e adesso ha
un nome preciso**: possiamo avere *o* la finestra lunga *o* il riempimento
vero, mai tutti e due.

## 7. ➡️ IL SEGUITO

1. ❓ **La domanda a Claudio**: il tetto l'hai alzato **prima o dopo** questa
   corsa? Cambia cosa scriviamo sui round passati.
2. 🔁 **Rifare R71 sui due cambi con la finestra lunga** (`-DaQuando 2000.01.01`)
   — adesso che si può, e con la selezione valida su entrambi.
3. 📥 **Dukascopy per gli indici**: resta l'unico buco vero: lì il broker è
   `COMPLETO` a 21 mesi e non c'è tetto da alzare.
4. 🪑 **La PTE in forward resta com'è** — nove round, due proposte, zero
   parametri toccati.
