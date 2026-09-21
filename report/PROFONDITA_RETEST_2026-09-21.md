# 📐 LA PROFONDITÀ DEL RETEST — tre round in un pomeriggio, e un «no» che vale

**21/09/2026** · nato da un'osservazione di Claudio guardando un movimento del Dow
preso in pieno dalla direzione e mancato dagli ordini:
*«SIAMO SICURI CHE LA DISTANZA DEL RETEST NON SIA TROPPA»*

---

## 🔴 LA RIGA CHE CONTA

> **R198 dice NO, e lo dice forte: sul Nasdaq `770260` lo `0` che abbiamo in campo
> è l'UNICA cella positiva fuori campione. Le altre tre vanno tutte in perdita, e
> la più profonda porta il drawdown al 26,1%.**
>
> **Due misure indipendenti dicevano di andare più profondi. Erano tutte e due
> sbagliate per questa sedia. Il round le ha fermate prima che toccassero una
> challenge pagata.**

---

## 1. 📊 I NUMERI — `NASUSD` M5 dal 2024.09.26, tick reali, banco 80.000

| offset | punti | **IS: n · PF · DD** | **OOS: n · PF · DD** | profitto OOS |
|---:|---:|---|---|---:|
| 🔵 **0** | 0,0 | 82 · 1,116 · 12,36% | **102 · 🟢 1,149 · 9,12%** | 🟢 **+7.689** |
| 200 | 2,0 | 82 · 1,283 · 9,82% | 99 · 🔴 0,955 · 14,63% | 🔴 −2.278 |
| 400 | 4,0 | 81 · 1,286 · 9,61% | 96 · 🔴 0,838 · 22,95% | 🔴 −7.651 |
| 600 | 6,0 | 78 · **1,300** · 9,09% | 96 · 🔴 0,838 · 🔴 **26,11%** | 🔴 −7.840 |

## 2. 🧭 CONTRO L'ATTESA DICHIARATA PRIMA

**Il contro-esempio che avevo scritto** era: *«se `n` crolla passando da 0 a 200
(più del 10%), lo zero è giusto dov'è»*.
👉 **`n` NON è crollato**: 102 → 99 = **−2,9%**. La profondità è davvero quasi
gratis in ingressi, come sul Dow.

🔴 **Ma a bocciarla è stata un'altra cosa, e più grave**: il PF fuori campione
**collassa** (1,149 → 0,955 → 0,838) e il DD **esplode** (9,12% → 26,11%).
📌 Il contro-esempio giusto non era quello che avevo previsto. **Aver dichiarato
UN contro-esempio non basta: il round va letto tutto**, non solo nella casella
dove ci si aspettava la sorpresa.

## 3. ⚠️ IS E OOS PUNTANO IN DIREZIONI OPPOSTE — ed è il segnale, non il rumore

- **IS**: più profondo = meglio, monotòno (1,116 → 1,300), DD in calo.
- **OOS**: più profondo = peggio, monotòno (1,149 → 0,838), DD che triplica.

🔴 **Chi avesse scelto sull'IS avrebbe preso il `600`** — la cella con il PF più
alto dentro campione — **e si sarebbe portato in campo un drawdown del 26,1%**, su
un conto con il muro al 10%. **È il curve fitting fotografato in diretta.**

🟢 La regola di casa *«IS e OOS devono concordare di SEGNO»* qui non è una formula:
è ciò che separa `+7.689` da `−7.840`.

## 4. 🧪 E LE DUE MISURE CHE MI AVEVANO CONVINTO? SBAGLIATE TUTTE E DUE

| fonte | diceva | verdetto di R198 |
|---|---|---|
| **R197B** (Dow, stesso giorno) | offset 0 = peggiore cella | 🔴 **non trasferibile**: sul Nasdaq lo 0 è la migliore |
| archivio `NASDAQ_E_retest_fill_FULL` | 0→300: PF 0,799 → 0,869, **stesso simbolo** | 🔴 **nemmeno il VERSO si trasferisce** |

📌 Avevo dichiarato nel file prova che di quell'archivio *«solo il VERSO è
trasferibile, non i livelli»*. **Era troppo generoso: non si trasferisce neanche
il verso.** Quel file misura una configurazione con PF sotto 1 in ogni cella —
cioè un motore diverso. Da oggi: **una misura fatta su una configurazione che non
guadagna non presta il suo verso a una che guadagna.**

## 5. ✅ VERDETTO

> ### 🔵 **`InpRetestOffsetPts = 0` sul Nasdaq `770260`: CONFERMATO. Niente si tocca.**
> ### 🔵 **`InpRetestOffsetPts = 400` sul Dow `770202`: CONFERMATO da R197B** (centro dell'altopiano, miglior DD OOS).
> ### 🟢 **Il RETEST resta su tutte e tre le sedie** — R197A: col breakout la finestra IS del Dow va in perdita.

⚠️ **Campione**: 78-102 operazioni per cella, **tutte sotto 150**. Indizio forte,
non verdetto definitivo — ma il segno della divergenza IS/OOS è troppo grande per
essere rumore di campionamento.

🟠 **Resta aperto, e non è questo round**: il DD della cella in campo (IS 12,36%,
OOS 9,12%) è dello stesso ordine del muro FTMO al 10%. Il modo e la profondità
d'ingresso **non lo risolvono**. È il prossimo problema vero di questa sedia.

## 6. 🏆 COSA HA PRODOTTO LA DOMANDA DI CLAUDIO, in mezza giornata

1. il Dow ha finalmente il suo studio (era l'unica delle tre senza);
2. **il retest confermato su tutte e tre**, con i numeri invece che con l'abitudine;
3. `400` sul Dow confermato come centro d'altopiano, non come picco;
4. 🔴 **una manopola che stavamo per girare nel verso sbagliato su una challenge
   pagata, fermata da un round da tre minuti.**
