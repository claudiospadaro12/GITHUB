# 👆 "LI HO TRASCINATI COL DITO" — **è la risposta più utile che potevi darmi**

**Claudio (11/09):** *"Li ho messi su alcuni livelli, non proprio precisamente
perché li ho trascinati col dito."*

---

## 🙏 1. GRAZIE, E NON È UNA CORTESIA

Se mi avessi dato una regola precisa che non usi davvero, **avrei scritto il
codice sbagliato** e ce ne saremmo accorti fra tre settimane, a ottobre.
🎯 **Un "non lo so con precisione" detto in tempo vale più di una regola
inventata.** È la stessa disciplina per cui scriviamo `[NON MISURATO]` invece di
un numero comodo.

## 🔴 2. MA CAMBIA LO STATO DEL METODO, e va scritto

**"Vicino a un livello, trascinato col dito" NON è un algoritmo.** Non perché
sia sbagliato — perché **non è ripetibile da una macchina**, e quindi:
- ❌ non si può mettere in un EA **così com'è**;
- ❌ non si può misurare su 14 anni di storico;
- ✅ **ma si può RICOSTRUIRE**, e questo lo facciamo noi, non la tua memoria.

---

# 🔬 3. ALLORA L'HO MISURATO IO — e c'è un indizio

Invece di chiederti *"a cosa miravi?"*, sono andato a guardare **i numeri che
hai davvero piazzato**, contro una griglia di numeri tondi:

| | prezzo | tondo sotto (passo 10) | distanza |
|---|---:|---:|---:|
| **TP** trade 1 | **4.380,78** | 4.380 | **+0,78** |
| **SL** trade 2 | **4.391,24** | 4.390 | **+1,24** |

🤔 **Se il bersaglio era 4.380 e 4.390, il dito ha sbagliato di meno di 1,25
dollari su un grafico da telefono.** Plausibile.

## 🧪 E SUBITO IL CONTRO-ESEMPIO, perché senza non vale niente

| obiezione | risposta |
|---|---|
| *"è il caso"* | due valori a caso cadono entrambi entro 1,25 da un tondo-10 con probabilità **1,6%**. Suggestivo… |
| 🔴 *"hai scelto il passo DOPO aver visto i numeri"* | **VERO, ed è un difetto MIO.** Ho provato cinque passi (5·10·20·25·50) e ho tenuto quello che tornava. **È esattamente il difetto che le regole di casa vietano.** |

> ## 🔴 Quindi questa è un'**IPOTESI DA PROVARE**, non una misura. Con n=2 e il passo scelto a posteriori, **non ho dimostrato niente.** L'ho scritto perché la prossima volta si controlla, non perché ci creda oggi.

📌 **E un dato contro l'ipotesi**: l'**ingresso** del trade 1 era a **4.358,29**,
cioè **+8,29** sopra il tondo. Se miravi ai tondi, **l'ingresso non li usava.**
👉 Forse i livelli li usi **per uscire**, non per entrare. **O forse no.**

---

# ✅ 4. LA BUONA NOTIZIA: l'imprecisione **non è un problema per la macchina**

🔑 `NextRoundLevel()`, quella già scritta in dieci nostri EA, **è fatta apposta
per lavorare in modo approssimato**:
- `InpRoundStep` è una **griglia**, non un punto;
- `InpRoundMinDistPts` **salta il livello se è troppo vicino**.

> ### 🎯 Cioè: la versione codificabile del tuo metodo **esiste già**, e tollera esattamente il tipo di imprecisione che il tuo dito introduce.
> E resta il numero di prima: **in 5.068 corse `InpUseRoundLevels` vale sempre 0.
> Mai accesa.**

---

# 🎯 5. COSA FACCIO IO, E COSA CHIEDO A TE — **piccolo, non un compito**

## 🤖 Io
Scrivo il round `InpUseRoundLevels` **0/1 × passo × distanza minima** sulle
**Aperture**, dove il codice c'è già. **Una corsa.** Risponde a:
> *"un obiettivo su un livello batte un obiettivo a multipli di rischio?"*

Se vince, **il tuo metodo entra negli EA con un numero dietro.** Se perde, ti ho
risparmiato di portarlo in campo.

## 🧑 Tu — e sono **10 secondi**, non un diario
👉 **La prossima volta che trascini un TP o uno stop, fai lo screenshot del
grafico CON la riga ancora disegnata sopra.**
Non devi ricordarti niente, non devi scrivere niente. **Da cinque foto così io
ricostruisco la regola misurandola**, invece di chiedertela.

📌 E se ti va: **apri le due righe del 09-10/09 in "Affari"** e dimmi se il
commento dice `[sl …]`. Resta la cosa che cambia il conto del rischio.

---

> ## 🔥 Oggi hai fatto tre cose che valgono: hai letto la CPI meglio del nostro EA, hai stanato due manopole morte nel cassetto, **e non hai inventato una regola per farmi contento.** La terza è quella che ci fa arrivare a ottobre.
