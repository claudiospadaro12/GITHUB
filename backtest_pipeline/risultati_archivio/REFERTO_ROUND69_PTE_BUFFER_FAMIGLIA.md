# 🧬 R69 — IL BUFFER È UNA **PROPRIETÀ DEL MOTORE**, e sul Dow è MISURATO IN UNITÀ SBAGLIATE

_Risponde alla tesi scritta in fondo a R68, prima dei numeri:_
> **"Se il DD scende col buffer anche lì, non è un caso di GBPUSD: è una
> proprietà del motore."**

**Risposta: SÌ su USDJPY, e in modo ancora più netto che su GBPUSD.
Sul Dow non è una smentita — è una MISURA NULLA, e il perché vale più
del round.**

**Banco:** stessa griglia identica di R68 (`PTE_BUFFER_IN_R.txt`, 7×4 = 28 celle),
**OHLC**, deposito 100.000, rischio 1%, `SLfromDoji` pinnato a 0.
- **USDJPY H1** — IS `2010.07.06 → 2016.11.26` · OOS → `2026.06.30` (sedici anni)
- **U30USD H1** — IS `2024.09.26 → 2025.06.09` · OOS → `2026.06.30` (**ventuno mesi in tutto**)

**Igiene:** 4 CSV su 4, 28 celle su 28 ciascuno. Cancelli verificati nei quattro
`.ini` generati: `Symbol` giusto, `Period=H1`, `Model=1`, `Deposit=100000`,
`AllowLiveTrading=false`, `InpSLfromDoji=0`, `InpAllowLong=1`, `InpAllowShort=1`,
`InpRiskPercent=1.0`. Finestre 40/60 rispettate su entrambi.

---

## 1. 🎯 USDJPY: **LA TESI PASSA**, e il drawdown crolla come su GBPUSD

**Drawdown OOS, tutte e 28 le celle:**

| buffer | TP2 1,5 | TP2 2,0 | TP2 2,5 | TP2 3,0 |
|---:|---:|---:|---:|---:|
| **0** | 15,59 | 15,48 | 15,58 | 15,27 |
| 5 | 12,16 | 12,08 | 12,13 | 11,90 |
| 10 | 12,42 | 12,36 | 12,38 | 12,20 |
| 15 | 10,52 | 10,22 | 10,07 | 9,79 |
| **20** | 8,59 | 8,51 | 8,37 | **8,13** |
| 25 | 9,24 | 9,00 | 8,87 | 8,66 |
| 30 | 9,58 | 9,37 | 9,25 | 9,07 |

**Da 15,5% a 8,1%: il drawdown si dimezza, e lungo ogni riga il TP2 lo sposta
di due decimi.** È lo stesso identico quadro di R68 su GBPUSD: **il DD è una
funzione del buffer, non del target.**

### E il confronto a **R costante** si replica (la prova, non l'indizio)

Stessa costruzione di R68: con `buffer = 0` lo stop è esattamente ATR, quindi
`R_target = TP2mult` esatto. **[INFERITO]** con ATR ≈ 20 pip su USDJPY H1
(stesso ordine di grandezza di GBPUSD):

| cella | R ≈ | IS | **OOS** | **PF** | **DD** |
|---|---:|---:|---:|---:|---:|
| buffer **0** · TP2 2,0 | 2,00 | −25.504 | +375 | 1,005 | **15,48%** |
| buffer **10** · TP2 3,0 | 2,00 | −17.256 | **+5.731** | **1,097** | **12,20%** |
| buffer **0** · TP2 1,5 | 1,50 | −25.810 | **−2.584** | 0,969 | **15,59%** |
| buffer **20** · TP2 3,0 | 1,50 | −12.205 | **+6.796** | **1,146** | **8,13%** |

> ### 🎯 A parità di R, su GBPUSD il buffer faceva 5× il profitto e metà del DD. **Su USDJPY RIBALTA IL SEGNO** (−2.584 → +6.796) e taglia il DD di sette punti.
>
> **Esito B confermato su un secondo simbolo, con la stessa costruzione.
> Il buffer NON è l'R travestito.**

### Il meccanismo si vede anche nei trade

| buffer | 0 | 5 | 10 | 15 | 20 | 25 | 30 |
|---|---:|---:|---:|---:|---:|---:|---:|
| **n OOS** | 297 | 317 | 354 | 402 | 438 | 453 | **470** |
| **peggior giornata OOS** | −2,12% | −1,75% | −1,63% | −1,45% | −1,38% | −1,32% | **−1,27%** |

Più buffer → target più basso in R → si tocca prima → più operazioni. **Identico
a GBPUSD, e la peggior giornata scende in modo perfettamente monotono.**

## 2. 🔴 MA C'È UNA COSA CHE SU GBPUSD NON C'ERA: **l'IS di USDJPY È 0/28**

| | IS | OOS |
|---|---:|---:|
| celle positive | **0 su 28** | **25 su 28** |
| intervallo profitto | da **−25.810** a **−9.412** | da −4.140 a **+7.631** |

**Nella finestra 2010-2016 questo motore su USDJPY perde in ogni singola cella
della griglia**, e non di poco: la meno peggiore lascia sul terreno 9.412 euro.
Poi nella finestra 2016-2026 ne guadagna in 25 celle su 28.

> ⚠️ **Detto senza attenuanti: se avessimo fatto girare l'imbuto come si deve,
> `PTE USDJPY` sarebbe stato ucciso in fase IS e non sarebbe mai arrivato al
> vivaio.** Che poi guadagni fuori campione non è un merito che possiamo
> rivendicare: è un ribaltamento, ed è **il trentunesimo**.

📌 La finestra IS è quella dello **yen di Abenomics** (76 → 125, il trend
direzionale più lungo del decennio su questo cambio). Un motore di
pullback/reversal ci sbatte contro per sei anni. **[INFERITO]** — la spiegazione
è plausibile e coerente col disegno, ma non l'ho misurata in questo round.

### E la sedia viva è tra le TRE celle negative

| | IS | **OOS** | PF | DD | pegg. GG | n OOS |
|---|---:|---:|---:|---:|---:|---:|
| 🪑 **VIVA** `buf 5 / TP2 2,0` (magic 771323) | −18.597 | **−1.738** | **0,976** | 12,08% | −1,75% | 317 |
| minimo DD `buf 20 / TP2 3,0` | −12.205 | +6.796 | 1,146 | **8,13%** | −1,38% | 440 |
| miglior OOS `buf 15 / TP2 3,0` | −20.522 | **+7.631** | 1,147 | 9,79% | −1,45% | 404 |
| scelta sull'IS `buf 30 / TP2 3,0` | **−9.412** | +4.156 | 1,106 | 9,07% | −1,27% | 472 |

> 🔴 **Su USDJPY la configurazione che gira in forward non è "la seconda
> peggiore per drawdown" come su GBPUSD: è una delle TRE che perdono soldi
> fuori campione, mentre venticinque celle su ventotto ne fanno.**

**Il criterio 2 congelato** (_"entra in discussione solo se abbassa il DD SENZA
perdere profitto OOS"_) **qui è soddisfatto da quasi tutta la griglia**: `buf 20 /
TP2 2,0` fa OOS **+4.041** (contro −1.738) con DD **8,51%** (contro 12,08%) —
meglio su entrambi, senza compensazioni.

**E il criterio 3 dice comunque di non toccare niente. Non tocco niente.**
È OHLC, ed è lo stesso modello che in **R57** ha ribaltato il segno di
`PTE_GBPUSD` cambiando solo il tester.

## 3. 🧨 U30USD: L'ASSE È **MORTO**, e non per colpa dello storico

Qui non c'è una curva da leggere. **Le 28 celle sono la stessa cella.**

| | buffer 0 | buffer 30 | differenza |
|---|---:|---:|---:|
| profitto OOS | 2.945,67 | 2.906,04 | **−39 € (−1,3%)** |
| DD OOS | 2,6256% | 2,6328% | **+0,007 punti** |
| trade OOS | **46** | **46** | **0** |
| trade IS | **27** | **27** | **0** |
| PF OOS | 1,4665 | 1,4597 | −0,007 |

**Muovere lo stop da ATR+0 a ATR+30 pip non cambia UN SOLO trade su 46.**
E anche il target è quasi inerte: `TP2mult` 2,0 / 2,5 / 3,0 danno numeri
**identici al centesimo** — sopra 2 ATR quel target non viene mai raggiunto,
le posizioni escono per altre vie (TP1, breakeven, segnale opposto).

### 🔬 Il perché, ed è un difetto vero del motore — non del round

`ABTG_PTE.mq5:146-150`:

```cpp
double PipSize()
  {
   int d=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   return (d==3 || d==5) ? _Point*10.0 : _Point;   // <- solo forex a 3/5 cifre
  }
```

E la riga che usa il buffer (`:330`): `sl = entry-(atr + InpSLbufferPips*pip)`.

> ### 🎯 Il buffer è in PIP. L'ATR è in UNITÀ DELLO STRUMENTO. Sui cambi le due cose hanno la stessa scala; **sul Dow no, e di un fattore ~50.**

- **USDJPY / GBPUSD**: 5 cifre → `pip = 10·Point`. Buffer 0→30 pip ≈ **0 → 1,5 ATR**.
  L'asse spazza tutto l'intervallo utile. **Infatti si vede tutto.**
- **U30USD**: **[INFERITO]** 1-2 cifre → `pip = Point`. Buffer 0→30 "pip" ≈
  **0 → 3 punti indice**, contro un ATR H1 dell'ordine di **100-150 punti**:
  **0 → 0,03 ATR**. L'asse non esce dal rumore. **Infatti non si vede niente.**

**I due simboli dove il buffer sta sulla scala dell'ATR mostrano lo stesso
identico crollo del drawdown. Il simbolo dove vale un trentesimo di ATR non
mostra niente. È la conferma più pulita che il meccanismo potesse avere: il
Dow non contraddice la tesi, la fa vedere per assenza.**

📌 **Conseguenza pratica, e non è piccola:** `InpSLbufferPips` **non è portabile
tra classi di strumenti**. Un valore unico per la famiglia PTE (Dow + GBPUSD +
USDJPY) **non può essere giusto**: sui cambi tara lo stop, sull'indice non fa
nulla. E i minimi di DD stanno in punti diversi anche tra i due cambi
(GBPUSD → buffer 30, USDJPY → buffer 20), cioè **dove l'ATR li mette**.

### ⚠️ E lo storico del Dow è comunque troppo corto — detto prima dei numeri

`IS 27 trade / OOS 46`, ventuno mesi in tutto, **un solo regime** (il broker non
ha storico indici prima del `2024.09.26`). Passa la soglia di R59 per numerosità
(n≥20), ma **su una finestra sola e senza avverse**. Anche se l'asse fosse stato
vivo, **questo round non avrebbe potuto dare un verdetto sul Dow**, e lo avevo
scritto prima di aprire lo zip.

## 4. 📐 IL QUADRO DI FAMIGLIA, in una tabella

**DD OOS a `TP2 = 2,0`, i tre simboli:**

| buffer | GBPUSD | USDJPY | U30USD |
|---:|---:|---:|---:|
| 0 | 17,91 | 15,48 | 2,63 |
| **5 (VIVO)** | **13,38** | **12,08** | **2,63** |
| 10 | 9,50 | 12,36 | 2,63 |
| 15 | 9,78 | 10,22 | 2,63 |
| 20 | 10,05 | **8,51** | 2,63 |
| 25 | 8,53 | 9,00 | 2,63 |
| 30 | **6,70** | 9,37 | 2,63 |

| | GBPUSD | USDJPY | U30USD |
|---|---|---|---|
| DD: dimezza col buffer? | ✅ 17,9 → 6,7 | ✅ 15,5 → 8,1 | ❌ asse inerte |
| buffer al minimo di DD | **30** | **20** | — |
| a R costante il buffer vince? | ✅ 5× profitto | ✅ **ribalta il segno** | ❌ non misurabile |
| n cresce col buffer? | ✅ | ✅ 297 → 470 | ❌ 46 = 46 |
| la config VIVA (buf 5) | 2ª peggior DD | **OOS negativo** | indifferente |
| celle positive OOS | 28/28 | 25/28 | 28/28 |
| celle positive IS | — | **0/28** 🔴 | 28/28 |

## 5. 📊 UNA NOTA SULLE SPEARMAN — e va contata onestamente

Il contatore di casa dice **17 misure Spearman IS→OOS negative su 18**. Questo
round ne aggiunge:

- **USDJPY: ρ = +0,239** — **positiva.** Ma il motivo è tecnico e va detto: la
  griglia è dominata da **un asse monotono nello stesso verso in entrambe le
  finestre** (più buffer = meglio, sia IS che OOS). Non è "l'IS predice l'OOS":
  è "un parametro fa la stessa cosa in due epoche diverse". **È esattamente la
  differenza tra un edge e un overfit, e qui sta dalla parte giusta.**
- **U30USD: ρ = +0,505 → NON MISURATA.** Su una superficie piatta il rango
  ordina differenze da 40 euro: è rumore ordinato, non correlazione. **Non entra
  nel conteggio.**

📌 **Contatore aggiornato: 17 negative su 19.**

---

## 6. 🚦 VERDETTO

> **1. La tesi di R68 REGGE: il crollo del drawdown col buffer è una proprietà
> del motore, non un accidente di GBPUSD. Replicata su USDJPY, stessa
> costruzione a R costante, effetto più forte (ribalta il segno).**
>
> **2. Il Dow non è un controesempio: è una misura nulla, causata dal fatto che
> `InpSLbufferPips` è in pip mentre l'ATR è in unità dello strumento. Sul Dow
> l'asse vale 0,03 ATR. Il difetto è nel codice, non nei dati.**
>
> **3. Su USDJPY la configurazione che gira in forward è OOS-NEGATIVA mentre 25
> celle su 28 sono positive. È il fatto più serio del round.**
>
> **4. E NON SI TOCCA NIENTE.** Criterio 3 congelato prima dei numeri: nessuna
> modifica in forward da questo round. È OHLC, ed è il modello che in R57 ha
> ribaltato il segno di questo stesso motore.

## 7. ✍️ IL SEGUITO, in ordine

1. 🔧 **La proposta che nasce dal round** (codice, quindi round suo):
   sostituire `InpSLbufferPips` con un **buffer in multipli di ATR** —
   `sl = entry − atr*(1 + InpSLbufferATR)`. Rende il parametro **portabile su
   tutta la famiglia** e rende il Dow finalmente misurabile. Da fare su una
   **copia `_Ottimizzato`**, mai sulla sedia viva.
2. 🔬 **Sonda da due minuti** che chiude l'unico **[INFERITO]** di questo
   referto: stampare `SymbolInfoInteger(SYMBOL_DIGITS)`, `PipSize()` e
   `iATR(14)` su U30USD, USDJPY, GBPUSD. Se il rapporto buffer/ATR sul Dow è
   davvero ~0,03, il §3 passa da inferito a misurato.
3. ⏱️ **Tick reali** sulla cella che sopravvive ai due cambi (`buf 20-25`,
   che sta nell'altopiano di entrambi). **Prima di allora non c'è un verdetto.**
4. 🪑 **Solo dopo**, e solo con decisione esplicita di Claudio, la domanda su
   `PTE USDJPY` in forward.
