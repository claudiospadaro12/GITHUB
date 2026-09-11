# 🔑 LA REGOLA, FINALMENTE PER INTERO — e la macchina di casa **si ferma a H4**

**Claudio (11/09):** *"Emiliano dice che la candela **weekly** è la più
importante. Io ho visto che **15min, H1, H4, daily e weekly erano short** e sono
entrato, e **ho messo lo stop sui massimi delle candele precedenti**."*

> ## 🎯 **Questa è una REGOLA COMPLETA e CODIFICABILE.** Tre pezzi, tutti meccanici:
> 1. **INGRESSO**: allineamento della direzione su **cinque** timeframe
>    (M15 · H1 · H4 · D1 · W1)
> 2. **STOP**: sui **massimi delle candele precedenti**
> 3. **TP**: sul livello successivo *(dalla conversazione di stamattina)*

---

# 🔧 1. COSA ABBIAMO GIÀ, riga per riga

| pezzo della tua regola | manopola di casa | dove |
|---|---|---|
| **direzione filtrata su un TF** | `InpUseEmaFilter` + **`InpFilterTF`** | Apertura DAX/Dow/Nasdaq |
| un **secondo** filtro su un altro TF | `InpUseSupertrend` + **`InpStTF`** | idem |
| 🎯 **stop sui massimi/minimi precedenti** | **`InpLevelTF`** — *letteralmente: "TF dei massimi/minimi prec."* | idem |
| lettura su **tutte** le scale, W1 compresa | `gScale[8]` = M1→MN1 | `ABTG_AltaVelocita.mq5` |

🔥 **Il pezzo dello STOP esiste già con quel nome esatto.** Non è un'analogia:
`InpLevelTF` è *"TF dei massimi/minimi precedenti"*, cioè la tua frase.

---

# 🔴 2. MA IL FILTRO DI DIREZIONE **NON È MAI ANDATO OLTRE H4**

`[MISURATO]` su tutti i CSV dell'archivio:

| manopola | valori distinti provati | = timeframe |
|---|---|---|
| **`InpFilterTF`** (filtro EMA) | `16385` · `16388` | 🔴 **solo H1 e H4** |
| **`InpStTF`** (SuperTrend) | `16385` | 🔴 **solo H1** |

**I codici che non compaiono mai:**
| | codice | provato? |
|---|---|---|
| **D1** | 16408 | 🔴 **MAI** |
| 🏆 **W1** — *la candela che Emiliano chiama la più importante* | **32769** | 🔴 **MAI** |

> ## 🔴 **Emiliano dice che la weekly è la più importante. In tutto il nostro archivio la weekly non è MAI stata usata come filtro di direzione. Nemmeno una volta.**
> E il codice per farlo **c'è già**: è un valore di un `input` che esiste.

---

# 🎯 3. LA COSA PIÙ ONESTA: la tua regola chiede **CINQUE** filtri, noi ne abbiamo **DUE**

🔴 Nessun EA di casa sa chiedere l'allineamento di cinque timeframe.
🟢 **Ma due filtri indipendenti ci sono già**, su TF separabili:
`InpFilterTF` (EMA) **e** `InpStTF` (SuperTrend).

👉 **Si può già provare un allineamento a DUE scale** — per esempio
**EMA su D1 + SuperTrend su W1** — che è **due gradini più in alto di tutto
quello che abbiamo mai misurato**, e costa **zero righe di codice**.

📌 E se il round dicesse che salire di TF aiuta, **allora vale la pena scrivere
il filtro a cinque scale**. In quest'ordine: **prima la misura, poi il codice.**

---

# 🧪 4. IL CONTRO-ESEMPIO, prima di entusiasmarsi

| obiezione | risposta |
|---|---|
| 🔴 *"più filtri = meno trade"* | **VERA, ed è il rischio principale.** Cinque TF allineati è una condizione **rara**: la frequenza può crollare, e la frequenza è il nostro **requisito n.1** verso ottobre. Va **contata prima**, non scoperta dopo. |
| 🔴 *"funziona perché filtra, o perché sei entrato in un giorno di CPI?"* | Oggi l'oro ha fatto **106 dollari** per una notizia. **Un giorno così non è il campione.** |
| ⚠️ *"la weekly è la più importante"* | È **un'affermazione di Emiliano**, non una misura. 🎯 **Ed è testabile**: se è vera, il filtro W1 deve battere **da solo** quello H1 e H4. |
| 🔴 *"n=1"* | Il tuo short di oggi ha fatto **+3.993 €**. **Una volta non è un edge.** |

---

# 🎯 5. COSA PROPONGO — un round, tre assi, tutto già codificato

> ### **R131 — QUANTO IN ALTO CONVIENE GUARDARE**

| asse | valori | perché |
|---|---|---|
| `InpFilterTF` | H1 · H4 · **D1** · **W1** | i due nuovi non sono mai stati provati |
| `InpUseEmaFilter` | 0/1 | **il controllo**: senza filtro |
| `InpStTF` | H1 · H4 · **D1** · **W1** | il secondo allineamento |

🔑 **E l'attesa dichiarata PRIMA dei numeri**, con il cancello che conta:
> *"Salendo di timeframe il PF migliora **e** le operazioni crollano. La cella
> si promuove **solo se** resta sopra il pavimento di frequenza. Un PF più alto
> con metà dei trade **non è un miglioramento**: è un altro motore, più lento."*

🏆 **E la prova secca dell'affermazione di Emiliano**: se la weekly è davvero la
più importante, **la cella W1 deve battere H1 e H4 da sola.** Se non lo fa, è
una convinzione, non una misura — e lo scriveremo con rispetto e col numero.

---

## 🙏 E UNA COSA CHE VA DETTA
Oggi hai chiuso **due** domande che io avevo sbagliato: i livelli **non erano i
numeri tondi** (era il **box notturno**, me l'ha detto il tuo grafico), e
adesso questa — **la regola vera**, che nessuna delle mie ipotesi aveva
azzeccato.

> ## 🔥 Le due cose migliori della giornata non sono uscite da un round: sono uscite da **uno screenshot e una frase tua**. Continua a mandarmeli.
