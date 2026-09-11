# 🔴 IL PEZZO CHE MANCAVA — **quella perdita l'hai fermata tu, non una regola**

**Claudio (11/09):** *"Non c'è commento."*
👉 La chiusura dello short da **0,50** del 09/09 (−63,44 $, −2.723,64 €)
**non è stata fatta dallo stop.**

---

## 🎯 1. COSA DIMOSTRA ESATTAMENTE — e cosa NON dimostra

✅ **Dimostra**: non è stato lo stop a chiudere quella posizione.
❌ **Non dimostra** che lo stop non esistesse: poteva esserci, **più lontano**, e
tu hai chiuso a mano prima che venisse toccato.

**Ma i due rami finiscono nello stesso posto:**

| ramo | cosa vuol dire |
|---|---|
| **A — lo stop non c'era** | 🔴 la perdita si è fermata **perché hai guardato lo schermo**. Il limite era **la tua attenzione**, non una regola. |
| **B — c'era, oltre 63,44 $** | su 20 lotti quello stop valeva **oltre 109.358 € = oltre il 100,3% del conto**. Cioè **non era uno stop: era una formalità**. |

> ## 🔴 **In tutti e due i rami, su 20 lotti quel trade non aveva un limite compatibile col conto.**

---

## 📏 2. E I NUMERI DELLA CHALLENGE, per chiudere il cerchio

| limite | valore su 109k | su **20 lotti** si rompe a |
|---|---:|---:|
| Max Daily Loss **5%** | 5.450 € | 🔴 **3,16 dollari** |
| Max Loss **10%** | 10.900 € | 🔴 **6,32 dollari** |

📌 **Quella posizione è andata 63,44 dollari contro.** Con 20 lotti sarebbe stata
**venti volte** oltre il limite che chiude una challenge — e **nulla, nel modo in
cui era impostata, l'avrebbe fermata prima.**

---

# 🟢 3. E LA MACCHINA CHE ABBIAMO IN CASA **NON PUÒ FARLO**

`ABTG_PostNews.mq5` r.476-478:
```
double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
```

> ## 🎯 **Senza distanza di stop, il lotto è ZERO. L'EA non apre. Punto.**
> Non è prudenza, non è un'opzione, non è un parametro: **è la prima riga della
> funzione.** Un nostro EA **non sa** aprire una posizione senza stop.

E il resto viene di conseguenza, **per aritmetica**:
```
stop sul livello  ->  distanza  ->  LOTTO  ->  rischio costante 0,65%
```
🔑 **La taglia smette di essere una decisione e diventa un risultato.**
Con lo stop a 63,44 $ la macchina avrebbe aperto **0,13 lotti**, non 0,50.
E **20 lotti** non sono nemmeno raggiungibili: richiederebbero uno stop a
**41 centesimi**, e nessun livello d'oro sta lì.

---

# ⚖️ 4. IL VERBALE, che è quello che serve fra tre settimane

**Sul conto da 109k, fra il 9 e l'11 settembre:**
- 🟢 **+13,62%** in tre giorni, conto tornato al centesimo;
- 🟢 **quattro direzioni su cinque giuste**, e oggi un ingresso a **72 secondi**
  da quello che il nostro EA avrebbe scelto da solo;
- 🔴 **la somma dei movimenti in dollari è −31,23**: il guadagno viene dalla
  taglia, non dalle letture;
- 🔴 **la posizione più grande era 40× la più piccola**, che è la pratica che
  FTMO vieta **con quelle parole**;
- 🔴 **e almeno una posizione non aveva un limite automatico.**

## 🛑 E LA RIGA CHE NON CAMBIA
**Le taglie e il rischio sono TUOI.** Non li tocco, non li toccherò, e non ti
faccio la predica: è il tuo conto e le tue decisioni.
👉 **Il mio compito è che tu decida con il numero davanti.** Il numero è che
**tredici dollari d'oro separavano "challenge passata" da "conto azzerato"**, e
che **nessuno stop stava guardando.**

---

## 🎯 5. LA PROPOSTA, ed è piccola
Non ti chiedo di cambiare come tradi. Ti chiedo **una cosa sola**, e la
faccio io:

> **Portiamo il TUO metodo dentro la NOSTRA macchina.**
> Tu dai i livelli (entrata, TP, stop). `LotByRisk()` dà il lotto.
> **Il risultato è che il trade da 20 lotti non è "sconsigliato": non esiste.**

E il primo passo è già in coda: il round **`InpUseRoundLevels`** sulle Aperture —
il codice c'è, **una corsa**, e in **5.068 corse non è mai stato acceso**.

> ## 🔥 Hai letto la CPI meglio del nostro EA. Adesso diamo al tuo occhio un motore che non sa perdere il conto.
