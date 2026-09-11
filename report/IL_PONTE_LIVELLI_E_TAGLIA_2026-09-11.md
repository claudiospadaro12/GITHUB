# 🌉 "TP E STOP SUI LIVELLI" — **è la risposta che aspettavo**, e chiude il cerchio

**Claudio (11/09):** *"Ho messo il tp e gli stop sui livelli."*

🔥 **Questa è una REGOLA, non un'intuizione. E le regole si codificano.**
Era la domanda che ti avevo fatto un'ora fa (*"perché il TP proprio a 4.380,78?"*)
e la risposta vale più del trade.

---

# 🌉 1. IL PONTE — e risolve **da solo** il problema della taglia

## Il punto che cambia tutto
🔑 **Se lo stop sta su un LIVELLO, la sua distanza cambia a ogni trade.**
E allora la **taglia deve cambiare all'inverso**, per tenere il rischio costante.

👉 **È esattamente quello che fa `LotByRisk()` nei nostri EA**, e su 109k con lo
0,65% di casa (**708 EUR**) darebbe:

| stop dal livello | lotti | perdita se preso |
|---:|---:|---:|
| 2,00 $ | **4,11** | 709 € |
| 5,00 $ | **1,64** | 708 € |
| **8,20 $** | **1,00** | 708 € |
| 20,00 $ | **0,41** | 708 € |
| 63,44 $ | **0,13** | 709 € |

## 🔴 E adesso lo stesso conto **al contrario** — ed è il numero che chiude il discorso

| taglia usata | lo stop DOVREBBE stare a |
|---:|---:|
| **20,00 lotti** | 🔴 **0,41 dollari** |
| 1,00 lotto | 8,22 dollari |
| 0,50 lotti | 16,44 dollari |

> ## 🔴 **Nessun livello d'oro sta a 41 centesimi di distanza.**
> **"20 lotti" e "stop su un livello" non possono coesistere.**
> Il motore di taglia avrebbe **rifiutato quel trade per costruzione** — non per
> prudenza, per **aritmetica**.

### 🎯 E questa è la cosa bella
**Il tuo metodo e il nostro motore non sono in conflitto: sono le due metà
della stessa macchina.**

| | chi ce l'ha |
|---|---|
| **dove entrare, dove uscire** (i livelli) | 🧑 **tu** — e oggi hai battuto il nostro EA di 72 secondi |
| **con quanti lotti** (rischio costante) | 🤖 **noi** — `LotByRisk()`, già scritto e collaudato |

👉 **Messi insieme, il trade da 20 lotti non è "sconsigliato": è IMPOSSIBILE.**
Non serve disciplina, serve una divisione.

---

# 🔴 2. MA UNA MISURA NON TORNA, e te la devo dire

Lo short da **0,50** del 09/09 è andato **63,44 dollari CONTRO** prima di chiudersi.

🤔 **Se lo stop era su un livello, allora delle due l'una:**
- il livello stava **63 dollari** sotto l'ingresso → è un livello enorme per uno
  short d'oro intraday;
- oppure **quello stop non c'era**, o è stato spostato.

📌 **Non lo so, e non lo invento**: la schermata *Posizioni* non mostra il motivo
di chiusura. Sulle operazioni di oggi il motivo c'era (`[tp 4380.78]`,
`[sl 4391.24]`); su quelle del 09-10/09 no.

🙋 **Mi basta che tu apra quelle due righe in "Affari"** e mi dica se il commento
dice `[sl ...]` oppure niente. **Cambia tutto il conto del rischio che ti ho
fatto un'ora fa**, e preferisco rifarlo giusto che lasciarlo spaventoso.

---

# ❓ 3. E LA DOMANDA CHE MI SERVE PER SCRIVERE IL CODICE

**"I livelli" può voler dire almeno quattro cose**, e sono **quattro EA diversi**:

| | come lo legge una macchina | in casa? |
|---|---|---|
| 🔢 **numeri tondi** (4350, 4400) | `NextRoundLevel()` | 🟢 **già scritto, in 10 EA** |
| 📈 massimo/minimo **precedenti** | `iHigh`/`iLow` su N barre | 🟡 pezzi sparsi |
| 📊 estremo del **consolidamento** prima della notizia | il range che `PostNews` già costruisce | 🟢 c'è |
| ✍️ livelli che **disegni tu** a mano | 🔴 **non codificabile** così com'è | ❌ |

🔴 **E ricordo il numero di prima**: `InpUseRoundLevels` esiste in **dieci** nostri
EA e in **5.068 corse** vale **sempre 0**. **Mai acceso.**

👉 **Dimmi quale dei quattro** — o, meglio ancora: **guarda il trade di oggi e
dimmi perché il TP stava a 4.380,78 e non a 4.385.** Da quella frase esce
l'algoritmo.

---

> ## 🔥 Un'ora fa avevo scritto: *"se c'è una regola dietro quel TP, è la cosa più preziosa di oggi"*. **C'era.** E la sua conseguenza è che la taglia smette di essere una scelta e diventa un risultato.
