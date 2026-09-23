# 📐 COME SI LEGGE R238 — **congelato mentre la corsa gira, a numeri IGNOTI**

> Claudio ha lanciato R238 alle ~23:00 del 23/09. Questo foglio si scrive **adesso**,
> mentre la macchina macina. 🔴 Se decidessi la soglia **dopo** aver visto il PF,
> sceglierei il criterio in funzione del risultato — il difetto del 10/09, e la
> **classe 689** registrata stasera (*"l'ho scritta prima rende un cancello ONESTO,
> non VALIDO"*). Qui si scrive prima **e** si verifica contro il codice.

---

## 0️⃣ CIÒ CHE È GIÀ CONGELATO ALTROVE, e non si ridiscute

Sta nei file prova e nel `NON_PROMUOVIBILE.txt` dentro lo zip:
- 🔴 **nessuna promozione e nessuno spegnimento**, qualunque PF esca — il divieto poggia
  sull'`n` (corto 16 IS / 24 OOS · lungo 45/76 e 37/52: **sotto 150**);
- 🔴 **cancello del costo SOSPESO** (serve la FASE 1);
- 🔴 **falsificazione per contatori NON FATTA**, e si sapeva prima del lancio;
- 🔴 lo **spread** è un'**incognita dichiarata** del delta OHLC→tick.

---

## 1️⃣ LA MISURA CHE CONTA NON È IL PF. È IL **RAPPORTO FRA LE DUE CELLE**

Il PF assoluto a tick reali su `n=24` non dice niente sul merito. Quello che le due celle
**dentro la stessa corsa** possono dire — stesso banco, stesso deposito, stesso modello — è
**quanto vale accendere la finestra**.

**Riferimento OHLC (R236e, corto, OOS):** `PF(ON)/PF(OFF) = 3,729 / 1,671 = **2,232**`

### 📊 I QUATTRO RAMI, su `R_tick = PF(ON)/PF(OFF)` del CORTO in OOS

| `R_tick` | lettura |
|---|---|
| **≥ 1,80** (≥ 80% del vantaggio OHLC) | 🟢 **IL VANTAGGIO SOPRAVVIVE.** Non promuove nulla (n=24), ma la finestra diventa un candidato serio e la prova successiva è quella che alza l'`n` |
| **1,20 – 1,79** | 🟠 **sopravvive RIDOTTO.** Si riporta la **frazione conservata** `R_tick / 2,232`, **non un verdetto** |
| **0,80 – 1,19** | 🔴 **IL VANTAGGIO SPARISCE: era l'OHLC.** Porta chiusa, riga in `REGISTRO_TEST.md` |
| **< 0,80** | 🔴 **la finestra PEGGIORA a tick reali.** Porta chiusa, e la lezione è più forte: l'OHLC non era solo ottimista, era **invertito** |

🔴 **E la soglia degli 1,80 è dichiarata per quello che è: una CONVENZIONE**, non una misura.
Vale come linea tracciata prima, non come legge di natura. Se il risultato cade a `1,79` o
`1,81` si scrive **"sul confine"**, non si arrotonda verso la conclusione comoda.

---

## 2️⃣ IL RISCHIO — si legge **a qualunque n** (Emendamento B)

In OHLC la finestra **dimezzava** il DD del corto: `1,039% → 0,509%`.
- 🟢 Se a tick reali il DD della cella **ON** resta sotto quello della cella **OFF**, il
  guadagno di tranquillità è reale e **si scrive comunque**, anche se il rapporto dei PF cade.
- 🔴 Se il DD della cella ON **supera** quello della OFF, allora **anche il "dimezza il DD"
  era un artefatto dell'OHLC** — ed è una conclusione che vale quanto l'altra.

---

## 3️⃣ IL CONTROLLO GRATIS: **il LUNGO**

In OHLC il lungo dava **0,990 in tutte e due le celle** — la finestra lì non faceva niente.
- 🟢 Se a tick reali il lungo resta **piatto** fra ON e OFF, il confronto sul corto è pulito.
- 🔴 **Se il lungo si muove molto**, la finestra sta facendo qualcosa che in OHLC non si
  vedeva, e **il confronto sul corto va riletto prima di concludere**.

---

## 4️⃣ E IL NUMERO CHE ESCE COMUNQUE, qualunque ramo tocchi

**Quanto l'OHLC era ottimista su questo motore.** È un numero che **non esiste in archivio** e
che serve a leggere **ogni futuro round OHLC** di casa.
🔴 Si scrive come **indicazione, mai come numero d'archivio**: manca il controllo di invariante
(i contatori dell'imbuto non arrivano — dichiarato prima del lancio).

---

## 🚦 L'ORDINE IN CUI SI APRE LO ZIP

1. `RIEPILOGO_R238.txt` → **rc** dei due round e **CATENA COMPLETA 2 su 2**
2. `NON_PROMUOVIBILE.txt` → prima di guardare **qualunque** numero
3. Il **LUNGO** (R238b), che è il controllo gratis del punto 3
4. Solo allora il **CORTO** (R238a) e il rapporto `R_tick`
5. I **DD** delle quattro celle
