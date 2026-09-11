# 🥇 ORO ALLE 15:30 — **LA MISURA È GIRATA.** 3.375.800 barre, 2.511 giornate

**Domanda di Claudio (11/09):** *"L'analisi che ti avevo chiesto ieri sull'oro,
sull'apertura delle 15.30, che risultati ha ottenuto?"*

## 🔴 PRIMA LA VERITÀ SULLO STATO: **ieri la misura NON era stata fatta**

Ieri (10/09) avevamo consegnato **tre cose vere**: il verdetto di **COSTO**, la
prova **sperimentale** delle tue 33 operazioni a mano, e la **caccia esterna**.
E avevamo **scritto e collaudato lo strumento** — ma **non l'avevamo girato**:
il referto di ieri chiudeva con *"le tre cose che mancano"*.

✅ **Oggi l'ho girato.** I dati non erano sul PC di backtest: lo strumento se li
scarica da solo. **Ci sono voluti 9 secondi di lettura.** 😅

| | |
|---|---|
| barre M1 lette | **3.375.800** (IS) + **1.508.566** (OOS) |
| finestra | **2006-03-19 → 2015-12-31** (IS) · **2016-2020** (cassaforte OOS) |
| giornate complete | **2.511** (IS) · **1.123** (OOS) |
| righe scartate / OHLC incoerenti | **0 / 0** |
| collaudo dell'orologio | ✅ picco inverno 13:30, estate 12:30, **spostamento −60 min → il file è in UTC**, come dichiarato |
| autotest dello strumento | ✅ **14/14** |
| referti grezzi | `backtest_pipeline/risultati_prove/sonda_oro_20260911/` |

---

# 1. 🎯 LA TUA DOMANDA LETTERALE: *"fa breakout o fa su e giù di colore?"*

> ## **FA SU E GIÙ DI COLORE. E lo fa PIÙ di una monetina.**

| le 5 candele M1 dopo l'apertura | misurato | n |
|---|---:|---:|
| **5 su 5 dello STESSO colore** | **4,78%** ± 0,85 | 2.511 |
| ⚖️ **la stessa cosa a testa e croce** | **6,25%** | — |
| serie massima = **2** (il caso più comune) | **45,56%** | 2.511 |
| **2 cambi di colore** (il caso più comune) | **37,55%** | 2.511 |

🔴 **4,78% contro 6,25%: l'oro all'apertura fa CINQUE CANDELE UGUALI MENO SPESSO
DI UNA MONETINA.** Non è tendenza: se mai è il contrario.

## E l'operazione, **più di una volta su due, non esiste proprio**

| | misurato |
|---|---:|
| **NESSUNA rottura** del range | 🔴 **55,24%** |
| rottura LONG | 21,66% |
| rottura SHORT | 23,06% |
| **INVERSIONE** (chiude contro la rottura) | **48,80%** — *una monetina* |
| almeno **4 candele su 5** nella direzione | solo **16,56%** |

---

# 2. 🧪 IL CONTRO-ESEMPIO — ed è qui che la misura diventa una risposta

⚠️ *"Su e giù di colore" da solo non dimostra niente: magari TUTTI i minuti del
giorno fanno così.* Per questo lo strumento misura **anche un minuto A SORTE**
preso fra le 07:00 e le 19:00, appaiato sugli stessi giorni.

| | **APERTURA USA** | **MINUTO A SORTE** | differenza |
|---|---:|---:|---|
| 5 su 5 stesso colore | 4,78% | **4,58%** | +0,20 pt ± 1,21 → 🔴 **RUMORE** |
| nessuna rottura | 55,24% | **56,93%** | 🔴 **RUMORE** |
| inversione | 48,80% | **49,22%** | −0,42 pt ± 4,32 → 🔴 **RUMORE** |
| k ≥ 4 nella direzione | 16,56% | **16,05%** | +0,52 pt ± 3,19 → 🔴 **RUMORE** |
| **MFE mediano** | **0,70 $** | **0,44 $** | 🟢 **1,60x** |
| **MAE mediano** | **0,64 $** | **0,40 $** | 🔴 **1,61x** |
| rapporto MFE/MAE | 1,087 | **1,095** | 🔴 **identico** |

> ## 🔑 ECCO LA RIGA CHE VALE TUTTA LA GIORNATA
> **All'apertura l'oro si muove il 60% IN PIÙ. Ma si muove di più IN TUTTE E DUE
> LE DIREZIONI, esattamente nella stessa proporzione (1,60x a favore, 1,61x
> contro).** Più benzina, stesso testa-e-croce.
>
> 👉 **L'apertura porta VOLATILITÀ, non DIREZIONE.** E la volatilità senza
> direzione, con un pedaggio da pagare, è **una macchina per perdere piano.**

Stesso esito contro gli altri due controlli (un'ora dopo, e un'ora quieta):
**tutte e quattro le statistiche di colore e direzione DENTRO IL RUMORE.**

---

# 3. 💰 E IL COSTO NON PERDONA — con numeri nuovi, non quelli di ieri

| | misurato |
|---|---:|
| range mediano dei 5 minuti | **1,57 $** |
| pavimento **DI LAVORO** (40x il costo pieno 0,2003 $) | **8,01 $** |
| **quante volte più grande dovrebbe muoversi** | 🔴 **5,10x** |
| giornate che arrivano al pavimento di lavoro | 🔴 **0,52%** (13 su 2.511) |
| stop che sopravvive all'80% delle escursioni contrarie (P80 MAE) | 1,45 $ = **7,2x** il costo |
| pavimento **DURO** (13,3x) | **2,66 $** |

🔴 **Anche lo stop "giusto" (1,45 $) sta sotto il pavimento DURO.** Non sfonda
solo la regola di lavoro: sfonda anche quella minima.

💵 **E il netto lordo a fine 5 minuti, mediano: `0,00 $`.** Esatto. **Zero.**
Prima di pagare un centesimo di spread o commissione. 😐

---

# 4. 📏 LE MEDIE 9 E 21 — la tua intuizione, misurata sul serio

Le abbiamo messe alla prova nella versione **migliore** (le medie **INCLINATE**
nel verso, non l'incrocio che su M1 arriva tardi):

| | con la condizione | senza | esito |
|---|---:|---:|---|
| quanto spesso si accende | **81,7%** dei giorni con rottura | — | 🔴 **non filtra: doppia la rottura** |
| MFE mediano | **0,65 $** | **0,80 $** | 🔴 **−18,7%: PEGGIORA** |
| k ≥ 4 nella direzione | — | — | −3,01 pt ± 5,99 → **RUMORE** |

🔴 Stesso esito per **tutte e sei** le varianti dichiarate (incrocio, incrocio
fresco, incrocio sulla barra): **tutte DENTRO IL RUMORE**, e quasi tutte con
l'MFE che **cala** quando la condizione si accende.

😄 Socio, l'intuizione era buona e andava provata — **ma il numero dice di no**,
e i due bracci più promettenti li abbiamo pure misurati **al meglio possibile**.

---

# 5. 🔒 LA CASSAFORTE 2016-2020 — aperta per CONFERMARE, non per scegliere

Il verdetto era già scritto sull'IS. L'OOS l'ho aperto solo per vedere se lo
smentiva. **Non lo smentisce — lo peggiora:**

| | IS 2006-2015 | **OOS 2016-2020** |
|---|---:|---:|
| 5 su 5 stesso colore | 4,78% | **4,19%** |
| nessuna rottura | 55,24% | **52,45%** |
| **inversione** | 48,80% | 🔴 **54,78%** |
| rapporto MFE/MAE | 1,087 | 🔴 **0,794** *(sotto 1: va più contro che a favore)* |
| netto lordo mediano 5 min | 0,00 $ | 🔴 **−0,11 $** |
| serve un movimento… | 5,10x | 🔴 **6,25x** più grande |

> ### 🔴 In OOS il MAE mediano SUPERA l'MFE mediano. Il trade, in mediana, va più contro che a favore — **prima di pagare il pedaggio.**

---

# 6. ⚖️ IL VERDETTO, e cosa NON dice

## ✅ COSA È MISURATO ADESSO

Il certificato di morte a 5 caselle, **ieri ne aveva UNA**. Oggi:

| # | casella | ieri | oggi |
|---|---|:---:|---|
| 1 | **PF misurato** | ❌ | ⚠️ n/a — **non è un backtest** (nessuna uscita simulata) |
| 2 | **n e DD** | ❌ | ✅ **n = 2.511 + 1.123**, su due epoche |
| 3 | **gestione dell'uscita ad asse** | ❌ | ✅ **profilo minuto per minuto, j=1..10** |
| 4 | **simboli gemelli** | ❌ | ✅ **4 gruppi di controllo**, incluso il minuto a sorte |
| 5 | **TF cambiato** | ✅ | ✅ M30 il più basso ammesso, H1 il gradino robusto |

> ## 🪦 **Il METODO DEL COLLEGA — oro, M1, 5 minuti dall'apertura USA — adesso è MISURATO, e il verdetto è: NON C'È NIENTE DA PRENDERE.**
> Non "costa troppo" (quello era ieri). **Non c'è proprio il fenomeno**: il
> comportamento delle candele all'apertura è **indistinguibile da un minuto preso
> a caso**, in due epoche indipendenti, su 3.634 giornate.
> E in più costa 5-6 volte quello che rende.

## 🚫 COSA QUESTA MISURA **NON** DICE — e non lo dirò

- ❌ **Non è BCM**: il feed è Oanda. Regola F6: misura di **OCCASIONI**, non un
  verdetto su un broker. ⚠️ Ma la direzione dell'errore è nota: BCM ha uno
  spread **peggiore**, non migliore.
- ❌ **Non è un backtest.** Nessuna uscita simulata, nessun costo dedotto dagli
  MFE/MAE. Chi legge 0,70 $ senza togliere 0,2003 legge un numero che non esiste.
- ❌ **Non copre il 2021-2026.** Il campione finisce nel 2020. 🔴 `[NON MISURATO]`
- ❌ **Non boccia l'oro**, e non boccia la rottura del range: boccia **questa
  finestra su questo TF**. 🟢 Da **M30 in su la frontiera del costo passa** (M30
  +9,7%, H1 +55%), e lì il meccanismo resta **NON ANCORA MISURATO** — cioè aperto.

---

## 🎁 IL REGALO INATTESO — 4,9 MILIONI DI BARRE M1 DI ORO, GRATIS

Lo strumento si è scaricato da solo **2006→2020 di oro M1**, e la lettura gira a
**375.000 barre al secondo**. 👉 Adesso abbiamo in casa un **campo di prova
sull'oro che prima non avevamo**, e costa **9 secondi** interrogarlo.

**Non ci accontentiamo. 🔥 La domanda di ieri adesso ha un numero sotto.**
