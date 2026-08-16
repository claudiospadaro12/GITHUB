# 🎯 R66 — DOVE FINISCE L'ALTOPIANO DEL GAP (16/08/2026)

_Chiude la domanda lasciata aperta da R65: la cella promossa stava a
`gap 1,00`, che era **il valore piu' alto spazzolato**. Un altopiano che tocca
il bordo non e' un altopiano._

**Banco:** identico a R65. 225JPY M1, OHLC, IS 2024.09.26→2025.06.09, OOS
→2026.06.30, deposito 100.000, rischio 1%. `OR` e `TP_R` **pinnati** ai valori
della cella R65 (15 e 3,0): si muove **un asse solo**.

---

## 1. LA CURVA INTERA DEL GAP — R65 + R66 insieme

Diagonale simmetrica (`buy == sell`), a `OR 15 / TP_R 3`:

| gap % | IS profit | PF IS | n IS | **OOS profit** | **PF OOS** | n OOS | DD OOS |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 0,50 | −490,43 | 0,974 | 72 | **+9.082,59** | 1,273 | 116 | 13,51 |
| 0,75 | −1.346,85 | — | 51 | **+9.445,46** | 1,356 | 92 | — |
| **1,00** | **+2.437,54** | **1,306** | 39 | **+7.542,65** | **1,363** | 69 | 11,78 |
| 1,25 | −1.352,92 | 0,772 | 20 | +1.073,07 | 1,080 | 38 | 8,97 |
| 1,50 | +1.148,13 | 1,379 | 14 | +687,33 | 1,056 | 32 | 8,46 |
| 1,75 | −234,10 | 0,891 | 11 | **−890,92** | 0,913 | 23 | 6,92 |
| 2,00 | +361,77 | 1,313 | 8 | **−3.074,19** | 0,694 | 21 | 6,92 |

_(le prime tre righe vengono da R65, le ultime quattro da questo round)_

## 2. ✅ RISPOSTA ALLA DOMANDA: **oltre 1,00 muore. Il bordo non era il problema.**

**Esito B + C insieme**, entrambi previsti nel file prova:

- **l'OOS crolla** salendo: +7.543 → +1.073 → +687 → **−891** → **−3.074**;
- **il campione crolla con lui**: da 39 trade IS a **8**, e da 69 OOS a 21.

> 🎯 **`gap 1,00` non era il bordo tagliato di una salita: e' il punto oltre
> il quale la famiglia si spegne.** La cella scelta in R65 **e' confermata**,
> e adesso lo e' con l'altopiano guardato da entrambi i lati.

E si capisce anche **perche'**: alzando la soglia si tengono solo i gap piu'
grandi, che sono i piu' rari e i piu' violenti — cioe' **gap di rottura da
notizia**, non riallineamenti. La tesi "chi e' rimasto fuori insegue" vale
sui gap normali, non su quelli da news. **La soglia non e' un rubinetto di
qualita': oltre un certo punto cambia l'evento.**

## 3. 🔴 IL DETTAGLIO SCOMODO: l'altopiano IS non esiste

Guardando la colonna IS lungo tutto l'asse:

```
 −490 · −1.347 · [ +2.438 ] · −1.353 · +1.148 · −234 · +362
```

**`gap 1,00` e' un PICCO ISOLATO in campione: ha i vicini negativi da
entrambe le parti.** Non e' il centro di un altopiano — e' una punta.

E la colonna OOS dice **il contrario**, in modo quasi monotono:

```
 +9.083 · +9.445 · +7.543 · +1.073 · +687 · −891 · −3.074
```

**Fuori campione il massimo sta in BASSO (0,50-0,75), dove l'IS e' rosso.**

> **Sedicesima misura di Spearman IS→OOS negativa su diciassette.** Su
> quest'asse **l'IS non porta informazione**: il suo picco e' rumore, e la
> vera pendenza dell'OOS punta dalla parte opposta.

📌 **Cosa NON si fa**: spostare la cella su 0,75 perche' l'OOS e' piu' alto.
Quello e' scegliere guardando la finestra di verifica, ed e' il modo
canonico di fabbricarsi un numero che non si ripetera'. **La cella resta
`1,00`, scelta sull'IS come prevede il metodo.**

📌 **Cosa invece si puo' dire, ed e' un fatto:** l'edge di questa famiglia sta
nei **gap frequenti e piccoli**, non in quelli rari e grandi. Vale come
**tesi da scrivere prima** in un eventuale round futuro, non come scusa per
spostare la cella adesso.

## 4. 🚦 VERDETTO

> **La cella di R65 (`gap 1,00 / OR 15 / TP_R 3`) e' CONFERMATA**, e la
> domanda del bordo e' chiusa: oltre 1,00 la famiglia muore, sotto 1,00
> l'IS non sa scegliere.
>
> **Ma l'altopiano in campione non c'e': e' un picco.** Il che significa che
> quella cella **e' difendibile per metodo, non per robustezza del
> parametro** — e va scritto accanto al suo numero ogni volta che lo si cita.

**Lo stato di `ABTG_GapContinuation` dopo R65 + R66:**

| criterio | esito |
|---|---|
| campione (n ≥ 15) | ✅ 5.610 trade OOS |
| OOS > 0 e PF ≥ 1,10 | ✅ PF **1,398** a tick reali |
| DD e peggior giornata | ✅ 7,53% e −0,72% a taglia prop |
| verdetto a tick reali | ✅ passa e **migliora** |
| sospetto del gemello | ✅ sciolto: due eventi diversi |
| bordo della griglia | ✅ **chiuso da questo round** |
| **lato short** | ❌ **−2.182: non riempie il buco n.3** |
| altopiano del parametro | 🟡 **picco, non altopiano** |

**Resta un criterio non passato e un'avvertenza. Nessuno dei due si risolve
stanotte.**
