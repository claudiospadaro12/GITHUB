# 🧪 REFERTO ROUND 55 — quanto slippage regge ogni cella

_Girato il 15/08/2026 sul PC di backtest. U30USD, tick reali, deposito 100.000.
40 passate (5 valori di slippage × 2 magic gemelli × 2 finestre × 2 EA), **4 CSV
su 4**. Prima corsa di `ABTG_PTE` v1.01 e `ABTG_ORB_Ottimizzato` v1.01 con
`InpSlippagePts`. Criteri congelati in `prove/R55_SCALABILITA_TESI.md` §4._

---

## 0. Igiene — e il controllo che valeva tutto il round

**Sweep gemello**: tutte e 20 le coppie identiche al centesimo. ✅

**Il controllo numero uno era: la riga a slippage 0 deve riprodurre i numeri
già noti della cella.**

| | R55 slip 0 (OOS) | riferimento noto |
|---|---|---|
| **ORB** | **+41.057,00 · PF 1,6742 · DD 9,7623 · n=119** | R54b (14/08): **+41.057,00 · 1,67419 · 9,7623 · 119** |
| **PTE** | +1.092,69 · PF 1,1709 · DD 3,2166 · **n=40** | R23a (coda, dep. 10k): +108,37 ×10 = +1.083,70 · PF 1,18 · DD 3,12 · **n=40** |

L'ORB è **identico al centesimo**: l'input nuovo, con default 0, non ha cambiato
una virgola. Il PTE combacia a meno dello 0,8% sul profitto (arrotondamento del
lotto su un deposito diverso) e ha lo **stesso numero di trade fuori campione**.

> ⚠️ **Uno scarto dichiarato**: in campione il PTE fa **28 trade** contro i **27**
> della coda a 10k. Un trade in più, quasi certamente perché a 100k il lotto
> minimo non schiaccia più un segnale che a 10k veniva saltato. Non inficia il
> round (tutte le righe hanno lo stesso n), ma va scritto.

---

## 1. PTE — ingresso A MERCATO (fuori campione)

| slippage (pt) | Profit | PF | DD | payoff | peggior giornata |
|---:|---:|---:|---:|---:|---:|
| **0** | **1.092,69** | **1,1709** | 3,2166% | 27,32 | −1,00% |
| 50 | 1.048,60 | 1,1629 | 3,2596% | 26,22 | −1,04% |
| 100 | 997,81 | 1,1538 | 3,2668% | 24,95 | −1,04% |
| 150 | 992,97 | 1,1529 | 3,2670% | 24,82 | −1,04% |
| **200** | 928,05 | **1,1415** | **3,2711%** | 23,20 | −1,06% |

**Costo per trade a 200 punti**: (1.092,69 − 928,05) / 40 = **−4,12 EUR**.
Con un R di ~1.000 EUR (la peggior giornata a −1,00% dice che 1R ≈ 1% del
conto), sono **lo 0,41% di un R**.

> ### 🟢 Il PTE scala benissimo — ed è l'opposto di quello che avevo previsto.
>
> A 200 punti (2 punti indice sul Dow) perde il **15% di profitto** ma resta a
> **PF 1,14**, e il **drawdown non si muove**: 3,2166% → 3,2711%, cinque
> centesimi in tutto.

## 2. ORB-EMA200 — ingresso a STOP (fuori campione)

| slippage (pt) | Profit | PF | **DD** | payoff |
|---:|---:|---:|---:|---:|
| **0** | **41.057,00** | **1,6742** | **9,7623%** | 345,02 |
| 50 | 39.336,26 | 1,6383 | 9,8820% | 330,56 |
| 100 | 38.271,02 | 1,6173 | 9,9499% | 321,61 |
| **150** | 36.958,61 | 1,5919 | 🔴 **10,2086%** | 310,58 |
| **200** | 35.755,10 | 1,5697 | 🔴 **10,3352%** | 300,46 |

**Costo per trade a 200 punti**: (41.057,00 − 35.755,10) / 119 = **−44,55 EUR**,
cioè **il 4,5% di un R** — **undici volte** la sensibilità del PTE.

> ### 🔴 L'ORB non muore di PF. Muore di DRAWDOWN.
>
> Il PF regge benissimo (1,57 anche a 200 punti). Ma **il DD sfonda il 10% con
> appena 150 punti, cioè 1,5 punti indice di slippage.**
>
> R15 aveva promosso questa cella con **DD 9,92%**, e il referto stesso lo
> scriveva col **DOPPIO ASTERISCO**: _"il criterio DD passa per 8 centesimi e
> NON su tutto l'altopiano: è una cella di confine, non un plateau di
> sicurezza"_.
>
> **R55 misura quanto è sottile quel confine: un punto e mezzo di slippage.**

---

## 3. 🔄 Le ipotesi erano sbagliate, e il motivo è più utile del verdetto

**Ipotesi 1 della tesi** — _"le celle a mercato e a stop perdono edge in modo
proporzionale, e basta uno slippage del 7,5% di R per azzerarla"_.
**Falsificata nei fatti**: 200 punti sul Dow costano lo 0,41% di R al PTE e il
4,5% all'ORB. Nessuna delle due si avvicina all'azzeramento.

**E la mia mappa "a mercato = fragile, a stop = fragile, a limit = robusto" era
la lente sbagliata.** I due EA hanno lo stesso identico slippage in punti e una
sensibilità che differisce di **undici volte**. Il tipo di ordine non la spiega.

> ## Quello che la spiega è la LARGHEZZA DELLO STOP.
>
> Il lotto si calcola sul rischio: `lotto = R / distanza_dello_stop`. Stop
> stretto → **più lotti** → ogni punto di slippage costa di più.
>
> L'ORB ha lo stop al **50% del range di apertura** — strettissimo. Il PTE ha
> lo stop a **1 ATR + buffer** — largo. Da qui l'undici a uno.

**È la stessa lezione della FASE H, arrivata da un'altra porta.** Il 07/08 il
referto H diceva: _"il drawdown non lo fa la geometria, lo fa lo stop stretto —
stop largo = posizione piccola con più respiro"_. Allora riguardava il DD;
adesso si scopre che **la stessa grandezza governa anche la resistenza a
un'esecuzione peggiore**. Una cella con lo stop stretto è fragile due volte.

## 4. ⚖️ Verdetto secondo i criteri congelati

**Criterio 2** — _"una cella scala se resta positiva OOS con slippage pari al
10% di un R"_:

| | slippage per arrivare al 10% di R | esito |
|---|---|---|
| **PTE** | ~4.900 punti (**49 punti indice**) | 🟢 **SCALA** — soglia irraggiungibile nella realtà |
| **ORB** | ~445 punti (**4,5 punti indice**) | 🟡 raggiungibile, ma **il PF resta sopra 1** |

**Ma il criterio prop del progetto è più stretto del criterio 2**, e va
applicato: **DD < 10%**. Con quello:

> **PTE: SCALA.** Il DD non si muove di cinque centesimi in tutto l'intervallo.
>
> **ORB: VIVE SOLO A TAGLIA PICCOLA.** Perde il cancello prop a **1,5 punti
> indice** di slippage — e sta sul conto 100k.

**Criterio 1**: nessun cambio ai parametri vivi esce da qui, e infatti non ne
esce nessuno. `InpSlippagePts` resta a **0** su entrambi gli EA.

**Criterio 4**: questo round **non autorizza nessuna taglia**. Dice solo quali
celle sopravvivono a un'esecuzione peggiore. La taglia la decide il forward.

## 5. Cosa portarsi via

1. **La domanda "conviene un conto grosso?" ha una risposta parziale, e non è
   quella che pensavo**: il portafoglio non è fragile in blocco. **Le celle con
   lo stop largo scalano; quelle con lo stop stretto no.** È un criterio nuovo,
   misurabile, e si applica a tutte e 32 le celle vive leggendo `InpSLMode` —
   non serve un altro round per sapere quali guardare.
2. **L'ORB Dow va segnato in classifica come "vive solo a taglia piccola"**.
   Non si tocca il forward (criterio 1), ma quando si parlerà di taglie, quella
   cella parte già fuori.
3. **Quello che questo round NON dice**: il riempimento parziale e la
   profondità del book. MT5 non li modella, e nessun backtest lo farà mai. A
   177 lotti sul DAX resta una domanda aperta a cui **solo il forward a taglia
   crescente** può rispondere.
