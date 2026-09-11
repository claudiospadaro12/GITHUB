# 🗣️ COME LAVORIAMO — checklist da raccontare a Emiliano

**Foglio da tenere aperto. Ogni riga è una frase che puoi dire.**

---

# 1️⃣ 🤖 GLI AGENTI — *"non è un'AI sola, sono nove specialisti"*

Claude Code non lavora da solo: lancia **agenti** in parallelo, ognuno con un
mestiere e con il **divieto di toccare quello che è vivo**.

| agente | cosa fa |
|---|---|
| 🔎 **cacciatore-strategie** | cerca motori nuovi su Code Base, GitHub, TradingView, paper |
| 🏦 **cacciatore-config-prop** | cerca **configurazioni vere** degli EA da prop e le regole delle prop |
| 🎚️ **cercatore-parametri** | scava nel NOSTRO archivio: *"questa manopola è già stata provata?"* |
| 🧑‍💻 **mql5-ea-developer** | scrive e corregge il codice degli EA |
| 🚦 **controllo-preventivo** | **il cancello**: niente esce senza il suo PASS |
| ✅ **verificatore-stringhe** | controlla ogni riga di comando **prima** che arrivi a me |
| 🛡️ **collaudatore-prop** | stress test: spread allargato, slippage, condizioni da broker prop |
| 🎧 **analista-trascrizioni** | digerisce le **live** e ne estrae ogni parametro e ogni numero |
| 🧭 **architetto-prop** | mette insieme tutto in un piano solo |

> 💬 **Da dire così**: *"Lanciamo 4-6 agenti insieme. Mentre uno scava
> nell'archivio, un altro scrive il round e un terzo controlla che non stiamo
> facendo cazzate. E nessuno di loro può toccare un conto."*

---

# 2️⃣ 🚦 I CANCELLI — *"niente esce senza un PASS, e sono due"*

| | |
|---|---|
| 🤖 **cancello deterministico** | uno script che **non ragiona, quindi non dimentica**: controlla le righe di comando contro tutti i difetti già pagati |
| 🧠 **cancello di giudizio** | un agente che legge e chiede: *"questa cosa fa davvero quello che promette?"* |

**Il primo che fallisce blocca. Se il controllo non è tornato, si aspetta.**

## 📓 E la memoria dei difetti
Ogni errore di **classe nuova** finisce in una checklist, **con la data e il
caso vero**. Siamo alla **classe 248**.
> 💬 *"Non è che non sbagliamo. È che ogni errore lo scriviamo, e lo stesso
> errore non lo rifacciamo due volte."*

---

# 3️⃣ 📊 IL PF E GLI ALTRI NUMERI — *il vocabolario, in italiano*

| sigla | cosa vuol dire | la nostra soglia |
|---|---|---|
| **PF** (Profit Factor) | quanto guadagna ogni euro perso. `1,30` = per ogni 100 persi ne guadagna 130 | ≥ **1,10** minimo |
| **DD** (Drawdown) | il buco massimo dal picco. **È un fatto accaduto, non una stima** | scarto secco sopra il **10%** |
| **n** | quante operazioni. Senza `n`, un PF non vuol dire niente | ≥ **150** in campione |
| **IS / OOS** | *in campione* = dove scegliamo · *fuori campione* = dove verifichiamo | si sceglie su IS, si giudica su OOS |

## 🔑 E la regola che vale più di tutte
> ## **CENTRO DELL'ALTOPIANO, MAI IL PICCO.**
> Se una configurazione è bellissima e quelle **accanto** sono brutte, **è
> fortuna, non un motore.** Si prende quella in mezzo a una zona buona.

💬 **Esempio vero di oggi**: ho trovato un PF **1,44** e l'ho **buttato**,
perché i suoi vicini stavano a 1,29 e 1,15 — e **in campione quella cella era
piatta**. Avremmo comprato il numero più bello della tabella e il secondo più
brutto.

---

# 4️⃣ 💸 IL CANCELLO DEL COSTO — *"prima di chiedersi se guadagna, chiedersi se paga il pedaggio"*

> **Lo stop deve valere almeno 40 volte lo spread.**

💬 *"Se il movimento tipico è piccolo rispetto a spread + commissione, si vince
spesso e si perde lo stesso. L'abbiamo misurato: **33 operazioni sull'oro
vinte 22 volte su 33 — e chiuse in perdita di 786 €.** Non era sfortuna: era
il pedaggio."*

---

# 5️⃣ 🧪 LA REGOLA CHE MI HANNO INSEGNATO A FORZA — *il CONTRO-ESEMPIO*

> ### **Prima di consegnare un numero, devo costruire IO il caso che lo farebbe sbagliare, e mostrare che non sbaglia.**

💬 *"Non basta che il risultato sia coerente con quello che mi aspettavo. Quella
non è verifica: è conferma. Bisogna **provare a rompere** la propria risposta."*

**Esempio di oggi**: sull'oro alle 15:30 il confronto non era *"c'è qualcosa?"*
ma *"**cosa fa un minuto preso a caso**?"*. Risposta: **la stessa identica
cosa** → niente da prendere.

---

# 6️⃣ ⚖️ LE REGOLE DI CASA — *le poche che decidono tutto*

| | |
|---|---|
| 📏 **Il campione si misura in OPERAZIONI, non in anni** | 150 operazioni valgono più di 10 anni con 40 trade |
| ⚖️ **Il vecchio giudica il RISCHIO, il recente il MERITO** | non si boccia un motore perché non guadagnava nel 2012; **si boccia se nel 2020 avrebbe fatto −25%** |
| 🪑 **Criteri di uscita firmati** | DD reale > DD promesso → revisione **immediata** |
| 🚫 **Niente griglie fitte su motori morti** | su un motore senza edge, una griglia più fitta trova solo **rumore** |
| 🔓 **Un candidato non si archivia** finché non è misurato in **due modi diversi** | *"non ha edge"* detto da una corsa sola è un'ipotesi |

---

# 7️⃣ 📦 QUANTO È GRANDE LA COSA — *i numeri, se te li chiede*

| | |
|---|---:|
| EA scritti | **111** |
| file di round preparati | **645** |
| CSV di risultati in archivio | **2.289** |
| referti scritti | **263** |
| commit su GitHub | **2.606** — di cui **87 oggi** |
| classi di difetto catalogate | **248** |

> 💬 *"Tutto è su GitHub. Ogni numero ha scritto **da quale file** viene. Se una
> cosa non è misurata, c'è scritto `NON MISURATO` — non un numero comodo."*

---

# 🎯 8️⃣ E SE TI CHIEDE *"MA FUNZIONA?"* — la risposta onesta

> 💬 *"Non ancora, e so esattamente perché: **abbiamo costruito prima i
> controlli e poi i motori**. Oggi ho quattro round pronti che valgono
> 24 minuti di computer, e fino a ieri non potevano nemmeno partire.*
>
> *Ma so anche cosa ci ha già salvato: **oggi ho buttato due configurazioni che
> sembravano d'oro e non lo erano**, e un errore di unità di misura che
> bruciava **l'80% del rischio in commissioni** senza che si vedesse.*
>
> *Quelle tre cose, senza i cancelli, sarebbero finite in campo."*

---

## 🔥 LA FRASE DA TENERE PER ULTIMA
> **"Non cerco l'EA che guadagna. Cerco il modo di sapere PRIMA se un EA
> guadagna — perché quello lo puoi rifare su cento motori."**
