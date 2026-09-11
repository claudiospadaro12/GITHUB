# 🔥 "TP SUL LIVELLO SUCCESSIVO" — **è già scritta in DIECI nostri EA, e non è MAI stata accesa**

**Claudio (11/09):** *"Si potevano mettere due ordini pendenti e quello che si
attivava, l'altro si cancellava. **TP sul livello o supporto successivo**."*

---

# 🔧 1. PRIMA MI CORREGGO — il mio contro-esempio di 20 minuti fa era zoppo

Avevo scritto questa riga:
> *"OCO acceso → **stop preso sul sell**, rally perso"*

🔴 **Quel "stop preso" me lo sono INVENTATO.** Non l'ho misurato: ho **assunto**
che la gamba short venisse stoppata. E con la tua regola del TP **è probabile
che invece guadagnasse**:

| | `[LETTO DAL GRAFICO]` |
|---|---|
| lo spike è sceso, in **una candela M5** | da ~4336 a ~**4290** = **46 dollari** |
| un TP piazzato **entro 46 $** sotto l'ingresso | 🟢 **veniva preso** |

👉 **Con il TP sul movimento, oggi la gamba SELL incassava.** Il mio
contro-esempio confrontava la tua idea **con metà della tua idea** — l'OCO senza
il TP. **Non è un contro-esempio: è un errore di lettura della proposta.**

## ⚖️ E allora le due strategie sono queste, ed è un confronto onesto

| | **A — la tua** (OCO + TP sul livello) | **B — com'è oggi** (niente OCO, TP fisso) |
|---|---|---|
| filosofia | 🎯 **prendi il primo impulso, incassa, esci** | resta dentro, prendi anche il ritorno |
| trade per evento | **1** | fino a **2** |
| oggi, sullo spike giù | 🟢 **incassava ~46 $** | incassava, ma restava esposto |
| oggi, sul rally +106 | 🔴 **fuori** | 🟢 **dentro** |
| whipsaw | 🟢 **una gamba sola** | 🔴 **doppio stop possibile** |

**Nessuna delle due è ovviamente migliore. È una misura, non un'opinione.**

---

# 🔥 2. E ADESSO LA SCOPERTA — **la tua regola è GIÀ CODIFICATA**

`ABTG_DAX_Apertura_EU.mq5` r.329-331:
```
input bool   InpUseRoundLevels  = false;  // Usa i numeri tondi come 1o obiettivo
input double InpRoundStep       = 100.0;  // Passo della griglia (in PREZZO)
input double InpRoundMinDistPts = 50;     // Distanza minima dall'ingresso
```
E r.1905-1906, **al posto del TP a multipli di R**:
```
if(InpUseRoundLevels && InpRoundStep > 0)
   target = NextRoundLevel(openP, dirSign, InpRoundStep, InpRoundMinDistPts*_Point);
else
   target = openP + dirSign*riskDist*InpTP1_R;
```
`NextRoundLevel()` (r.2040-2054) fa **esattamente** quello che hai detto: prende
il prossimo livello nella direzione del trade, e **se è troppo vicino salta al
successivo**.

## 🔴 IN QUANTI EA STA, E QUANTE VOLTE È STATA ACCESA

| | |
|---|---|
| EA di casa che ce l'hanno | 🟢 **10** (Apertura DAX · Dow · Nasdaq · 3Ingressi · Marco · Live5m…) |
| righe di CSV con quella colonna | **5.068** |
| valori distinti trovati | 🔴 **`['0']`** |

> ## 🔴 **Cinquemilasessantotto corse. Il valore è SEMPRE ZERO. Non è mai stata accesa nemmeno una volta.**
> È **un'altra manopola morta nel cassetto**, come `InpMinStopPts` stamattina —
> e questa l'hai trovata tu **descrivendo a parole una funzione che qualcuno
> aveva già scritto e nessuno aveva mai provato.**

---

# ⚠️ 3. MA TRE COSE VANNO DETTE PRIMA DI ESULTARE

### 🔴 A. Nella sedia news **non c'è**
`ABTG_PostNews.mq5`: il TP è **fisso in pip** (`InpTPpips`, r.97) e basta.
`grep` di `support|resist|pivot|swing|level`: 🔴 **niente.** Gli unici `iHigh`/
`iLow` (r.314-315) servono a costruire il range delle due candele, non il TP.
👉 Per la sedia news **la tua regola va portata dentro: è codice, non un preset.**

### 🟠 B. "Supporto successivo" **non è un numero** finché non è una regola
`NextRoundLevel` implementa **UNA** versione: i **numeri tondi**. Ma
*"il supporto successivo"* può voler dire almeno quattro cose diverse:
minimo del giorno prima · minimo/massimo delle ultime N candele · l'estremo del
consolidamento pre-notizia · un numero tondo.
🔴 **Sono quattro strategie diverse con quattro risultati diversi.** Quella che
c'è già in casa è la quarta — la più semplice da misurare, ed è gratis.

### 🟠 C. Su una notizia il livello tondo può essere **già dentro lo spike**
Oggi il prezzo ha fatto **46 dollari in una candela**: con `InpRoundStep=100`
il livello successivo sarebbe stato a **4300** — preso subito. Con step 50, a
**4300** pure. 👉 **Su un evento il TP strutturale rischia di essere troppo
vicino**, ed è per questo che esiste `InpRoundMinDistPts`. **Va tarato, non
acceso e via.**

---

# 🎯 4. COSA PROPONGO — due round, tutti e due economici

| round | asse | dove | costo |
|---|---|---|---|
| 🥇 **il regalo gratis** | `InpUseRoundLevels` 0/1 × `InpRoundStep` × `InpRoundMinDistPts` | sulle **Aperture**, dove il codice c'è già | **una corsa** |
| 🥈 la tua versione completa | OCO + TP strutturale su `PostNews` | **richiede codice nuovo** | prima il primo |

🔑 **Si parte dal primo perché non costa niente e risponde alla stessa domanda**:
*"un obiettivo su un livello batte un obiettivo a multipli di rischio?"*
Se la risposta è sì sulle Aperture, **portarla nella sedia news diventa una
scelta con un numero dietro**, non una speranza.

> ## 🔥 Oggi hai trovato due manopole morte nel cassetto descrivendole a parole. `InpMinStopPts` stamattina, `InpUseRoundLevels` adesso. **Cinquemila corse e nessuno l'aveva mai girata.**
