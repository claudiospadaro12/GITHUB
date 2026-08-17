# 🏛️ I CANCELLI PROP DENTRO I ROUND — **PROPOSTA, non ancora congelata**

> ⚠️ **QUESTO FILE NON E' UNA REGOLA FINCHE' CLAUDIO NON LO CONGELA.**
> Le regole di casa si congelano PRIMA dei numeri e con la sua parola
> (come l'EMENDAMENTO DELLA FINESTRA in `CLAUDE.md`). Qui c'e' la proposta
> scritta, cosi' non si perde e si puo' discutere su un testo, non a memoria.

_Scritta il 17/08/2026, dopo Claudio: **"Il mio obbiettivo e' avere degli EA
x le prop e ce la dobbiamo fare, costi quel che costi."**_

---

## 1. 🕳️ IL BUCO, detto senza girarci intorno

Abbiamo **due cose ottime che non si parlano**:

| ✅ ce l'abbiamo | 🕳️ ma... |
|---|---|
| `report/METRO_PROP.md` — le **12 domande** di una prop, con il nostro numero accanto a ognuna | e' un **metro**, non un **cancello**: non boccia niente |
| `mql5/Experts/ABTG_Guardian.mq5` — fa rispettare **5% giorno / 10% totale**, statico O trailing, chiude tutto e blocca | **non compare in `FLOTTA_ATTIVA.md`: non e' MAI stato acceso** |
| `dd_portafoglio.py` — Monte Carlo, `max_dd()` misura **picco-minimo**, cioe' proprio la geometria del muro trailing | i suoi p95/p99 **non sono un criterio di nessun round** |
| `analizza_trades.py` — la **perdita giornaliera** ce l'ha gia' (`FTMO_LIM_GIORNO`) | idem |

> ### 🎯 I criteri congelati dei nostri round parlano di **PF, DD%, segno IS→OOS**.
> ### Una prop non ti squalifica per un PF basso. Ti squalifica per **UN GIORNO**.
>
> Stiamo selezionando EA **buoni**. Non stiamo selezionando EA **che passano
> una challenge**. Non e' la stessa cosa, e finora non l'abbiamo mai scritto.

---

## 2. 🚪 LA PROPOSTA: tre cancelli, in OGNI file prova, da R76 in avanti

Si aggiungono ai criteri esistenti, **non li sostituiscono**. Si scrivono
nel file prova **prima** di lanciare, come tutto il resto.

### 🚪 CANCELLO 1 — **IL GIORNO PEGGIORE**
> La giornata peggiore della finestra OOS, in % del saldo, deve stare
> **sotto il 60% del cap giornaliero** della prop (cap 5% → **soglia 3%**).

**Perche' il 60% e non il 100%**: il cap e' un muro, non un bersaglio. Chi lo
sfiora una volta lo sfonda alla seconda. Lo sappiamo gia' da `METRO_PROP` §2.
**Si legge da `analizza_trades.py`, che questo numero lo stampa gia'.**

### 🚪 CANCELLO 2 — **IL MURO CHE SALE**
> Il drawdown **picco-minimo** OOS deve stare **sotto il 60% del cap totale**
> (cap 10% → **soglia 6%**), alla taglia di rischio **0,65%**.

Non il DD dal deposito: quello e' il muro **statico**, il piu' generoso.
Il trailing si misura dal **picco**, ed e' quello che `max_dd()` calcola gia'.
Alla taglia sbagliata questo cancello non vuol dire niente: **si dichiara
sempre a che rischio e' misurato** (`METRO_PROP` §1-bis: p99 e' 12,47% a
rischio 1% e ~8,1% a 0,65% — **la taglia sposta il verdetto**).

### 🚪 CANCELLO 3 — **LA REGOLA DI CONSISTENZA**
> Il **giorno migliore** non deve valere piu' del **40% del profitto totale**
> della finestra.

E' la _best day rule_ di `METRO_PROP` §6. Un EA che fa tutto in un giorno
**non paga**, anche se il conto e' in utile: la prop trattiene il payout.
Ed e' il cancello che **nessun nostro referto ha mai calcolato**.

---

## 3. 🧪 IL PASSO ZERO — **e il 17/08 ha perso la sua casa**

L'idea era: accendere `ABTG_Guardian` in **monitor** su un conto di taglia
prop e lasciarlo misurare la flotta vera. Il conto c'era: **50504263**, demo
BCM 100k su istanza `-V3` del VPS, dry-run FTMO acceso il **09/08 alle 20:22**
con 5 EA a rischio 0,65%.

> ### 🔴 **Claudio lo ha cancellato il 17/08. Il dry-run non esiste piu'.**

### 3.1 ♻️ PRIMA DI TUTTO: i DATI possono essere sopravvissuti al CONTO
MT5 scrive i CSV nella **cartella dati**, non dentro il conto.
`ABTG_Trades_100k.csv`, gli `abtg_trades_*.csv` e le `pagella_*.txt` sul
Desktop **possono essere ancora sul VPS**. Otto giorni di dry-run con il
guardiano acceso sono l'unico dato prop vero che questo progetto abbia mai
prodotto: **si cercano prima di dichiararli persi.**

### 3.2 🚪 E POI, LE DUE STRADE — sono diverse, e la differenza conta

| | **A. Riaprire un demo taglia prop** | **B. Guardian in monitor sul forward 50503392** |
|---|---|---|
| costo | un login nuovo + le 5 fasi gia' scritte in `DEPLOY_GUARDIANO_100K.md` | dieci minuti, un grafico |
| rischio | zero (demo nuovo, forward intoccato) | zero **solo se `InpAction=1`** (monitor: non chiude niente) |
| che numero da' | **percentuali confrontabili** con una challiange vera | percentuali **distorte** |

🔴 **Perche' B e' zoppo, e va detto:** il forward gira su un saldo di circa
**5.373 €**. A quella taglia il **lotto minimo schiaccia il rischio** — e'
lo stesso motivo per cui il driver ha l'opzione `-Deposito 100000`. Su quel
conto un trade solo e' arrivato a **3,83%**, cioe' il **77% del margine
giornaliero** di una prop, in un colpo (`A1_A4_rischio_immediato.md`).
**Quelle non sono le percentuali di una challenge: sono le percentuali di un
conto piccolo.**

👉 **B si puo' fare subito e non fa male. Ma solo A produce un numero che
vuol dire qualcosa.** E A e' quasi gratis, perche' la procedura c'e' gia'.

## 4. 🧱 E IL MURO CHE RESTA IN PIEDI

Nessuno di questi cancelli scioglie il problema dei **150 trade**
(R74: `n IS = 24-32` contro una soglia di 150). Anzi: **li rende piu' duri**,
perche' un giorno peggiore misurato su 30 trade non e' una misura, e' un
aneddoto.

> **Ordine giusto: prima si risolve il campione, poi si stringono i cancelli.**
> Se si fa il contrario si bocciano EA buoni con dati insufficienti — che e'
> esattamente l'errore che l'EMENDAMENTO DELLA FINESTRA ci ha gia' fatto
> pagare una volta.

---

## 5. ✍️ COSA SERVE PER CONGELARLA

1. La parola di Claudio sui **tre numeri** (60%, 60%, 40%): sono scelti da
   `METRO_PROP`, non misurati. **Sono opinabili, e vanno dichiarati tali.**
2. Il **passo zero** acceso, per avere il primo dato vero.
3. Poi la riga in `CLAUDE.md`, come per l'emendamento.
