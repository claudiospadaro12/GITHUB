# ⚠️ IL DD DELLA SEDIA CHE STA OPERANDO — **il conto torna, e proprio per questo è un problema**

> Nato la notte del 24/09 leggendo R239. **Non è un round, è un controllo su una sedia viva.**
> 🔴 **Nessun parametro è stato toccato.** Questo foglio porta un numero davanti a Claudio: la
> decisione è sua, come tutte quelle sul rischio.

---

## 1️⃣ I DUE NUMERI, che vengono da posti diversi e **dicono la stessa cosa**

**Il CONTRATTO** (`report/CENSIMENTO_CONTRATTI_v2.md`, sedia `770101` DAX Apertura):
> **`4,3501%` di DD @ rischio `0,65%`** · **[MISURATO]** · su 270 uscite → 193 posizioni

**La MISURA di stanotte** (R239b, lato lungo puro = la sedia com'è schierata):
> **`14,14%` di DD @ rischio `2,00%`**, deposito 100.000, OOS 12,7 mesi, tick reali

**Il DD scala con il rischio per operazione.** Quindi:

```
4,3501%  x  (2,00 / 0,65)  =  13,38%   <- quello che il CONTRATTO implica alla taglia viva
                              14,14%   <- quello che R239 ha MISURATO
                              +5,6%    <- scarto
```

# 🎯 I due numeri concordano. La sedia si comporta ESATTAMENTE come dice il suo contratto.

🟢 Questa è una buona notizia sul **banco**: la nostra catena di misura è coerente, e due strade
indipendenti danno lo stesso numero.

---

## 2️⃣ 🔴 E QUI STA IL PROBLEMA, che non è nella sedia ma nella TAGLIA

La sedia `770101` gira sulla challenge FTMO `541452707` a **`InpRiskPercent = 2,00`**.
Il tetto di perdita totale della challenge è **10%**, ed è **STATICO**: l'equity non deve mai
scendere sotto il **90% del saldo iniziale** (`docs/REGOLAMENTO_FTMO_2026-08.md` r.26-27 —
**72.000 su 80.000**). Il limite giornaliero è **5% sull'EQUITY**, col riferimento al **balance
delle 00:00**.
✏️ **CORRETTO il 24/09**: la prima stesura citava `PIANO_CHALLENGE_OTTOBRE_v2.md` r.268. 🔴 **Fonte
sbagliata** — quella riga è una nota di archiviazione dentro la sezione in cui FundedNext sostituisce
FTMO. Il numero era giusto, la fonte no, e una fonte sbagliata su una regola di challenge è un
difetto come gli altri.

| | valore |
|---|---:|
| DD che il contratto della sedia implica alla taglia viva | **~13,4%** |
| DD misurato da R239 alla stessa taglia | **14,14%** |
| **Tetto della challenge** | 🔴 **10%** |

# La sedia è dimensionata in modo che UNA SUA CATTIVA SERIE NORMALE ecceda il tetto della challenge.

👉 **Non è un guasto, non è una sorpresa, non è degrado**: è aritmetica che era già in casa. Il
contratto diceva `4,35% @ 0,65%`, e nessuno aveva fatto la moltiplicazione per la taglia a cui la
sedia è stata poi schierata.

---

## 3️⃣ ⚖️ LA CLAUSOLA ONESTA, perché il numero non dica più di quello che sa

🔴 **`14,14%` è la PEGGIORE escursione su 12,7 mesi, non la perdita attesa in una challenge.**
Una challenge dura settimane, non un anno: **può benissimo finire prima che quella serie capiti.**
👉 La frase giusta **non** è *"perderemo il 14%"*. È: **"la sedia è tarata in modo che una brutta
serie normale — una che nei dati capita — chiuda la challenge"**.

E le tre differenze banco/campo restano dichiarate: feed **BCM `D30EUR`** contro **FTMO `GER40`**,
deposito **100.000** contro saldo vivo **~78.242**, magic diverso. 🔴 **Ma il DD è una percentuale, e
una percentuale non si sposta di quattro punti cambiando feed.**

⚠️ **E il `4,3501%` del contratto è misurato a deposito 10.000.** Il censimento stesso mette
l'asterisco: a 100.000 il DD promesso è `[NON MISURATO]`, e per sola proporzione starebbe a `≈4,69%`.
🟢 Usando **quello**, il conto peggiora ancora: `4,69 × (2,00/0,65) = **14,43%**`, cioè **ancora più
vicino al 14,14% misurato**. La conclusione non cambia in nessuna delle due strade.

---

## 4️⃣ 📌 E LA COSA CHE R239 AGGIUNGE, che non era nel contratto

| DAX OOS, rischio 2,00% | DD |
|---|---:|
| **lungo puro** (com'è schierata) | 14,14% |
| **long + short** (se si accendesse il corto) | 🔴 **20,53%** |

👉 La domanda *"completiamo il lato corto?"* aveva **due** risposte, e vanno lette insieme:
il corto **perde da solo** (PF 0,957 su n=259) **e raddoppierebbe il problema del drawdown.**

---

## 5️⃣ 🙋 COSA DECIDE CLAUDIO — e io non tocco niente

Il criterio firmato il **18/08** dice: *"DD forward > DD promesso dal backtest → revisione
IMMEDIATA"*. 🔴 **Qui è un caso diverso e più scomodo: è il DD PROMESSO stesso a eccedere il tetto
della challenge**, e lo si poteva sapere prima di schierare.

Le tre strade, coi numeri accanto — **nessuna è mia da prendere**:

| strada | effetto sul DD atteso | costo |
|---|---|---|
| **A. Abbassare il rischio** della sedia da `2,00%` a **`1,40%`** | ~13,4% → **~9,4%**, sotto il tetto | il profitto scala allo stesso modo: −30% |
| **B. Lasciare com'è** | resta ~13-14% | si accetta che una brutta serie chiuda la challenge |
| **C. Misurare prima** il DD a 100.000 invece di scalarlo | toglie l'unica proporzione rimasta | ~10 minuti di macchina |

🟢 **La C costa quasi niente e chiude l'ultimo `[NON MISURATO]` della catena.** Se vuole, la preparo.

🔴 **E l'ultima riga, che vale per tutte e sei le sedie**: questo conto l'ho fatto su `770101` perché
R239 l'ha misurata. **Le altre cinque girano anche loro a `2,00%`, e il loro contratto è scritto a
`0,65%`.** La stessa moltiplicazione non è stata fatta per nessuna. 👉 **È il primo lavoro che
propongo per domani**, e costa **zero macchina**: sta tutto nel censimento.


---

## 🔴 AGGIORNAMENTO DEL 24/09 — **il conto è stato fatto su tutte e sei, e il quadro è peggiore**

`report/IL_DD_DELLE_SEI_SEDIE_2026-09-24.md`:

# DUE sedie su sei sfondano il 10% DA SOLE in OOS. TRE contando anche l'IS.

| sedia | DD @ 2,00% | > 10%? |
|---|---:|:--|
| `771531` EMA200 Dow | **15,66%** (IS 11,47%) | 🔴 **sì, in tutte e due** |
| `770101` DAX Apertura | **14,50%** (IS 10,82%) | 🔴 **sì, in tutte e due** |
| `770202` Dow Apertura | 8,79% · **IS 11,35%** | 🟠 solo IS |
| `770511` · `770260` · `770411` | 7,8-8,4% · 7,9% · 3,8% | 🟢 no |

## 🧱 E IL NUMERO DI PORTAFOGLIO **ESISTE, ED È MISURATO**
`report/DD_PORTAFOGLIO_FTMO_2026-09-20.md` r.108-117, a rischio **2,00%**:
- **DD dal picco: 13,91%** · peggior giornata **−6,87%** (26/02/2026) · **2 giornate oltre il muro del 5%**
- 🔴 **Monte Carlo: il 12,4% delle sequenze sfonda il 10% statico** — contro **1,7%** a rischio 1,00%.
  **×7,3, non ×2.**
- ⚠️ Ed è un **PAVIMENTO**: misurato su **4 sedie su 6** (mancano due **correlate** a quelle presenti)
  e aggregato **per giorno**, quindi cieco al flottante intragiornaliero.

🟢 **E la notizia buona, che va detta**: la **diversificazione funziona** — la somma dei DD fa 19,28%,
i combinati **5,19%**. 👉 **Il problema non è che si sommano: è la TAGLIA.**

🟢 **E una firma di Claudio ha già tolto una sedia dalla lista**: il 21/09 alle 20:22 (*"ACCENDILA AL
50%"*) la `770260` è passata a `InpTP1_ClosePct=50`, e la cella nuova misura **7,86% / 7,31%** —
l'unico contratto del progetto **misurato alla taglia E al deposito veri**. La vecchia faceva 12,36%
in IS: **avrebbe sfondato**.
