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

## 3. 🧪 IL PASSO ZERO — **la casa c'e' ancora, va solo identificata**

L'idea: accendere `ABTG_Guardian` su un conto di **taglia prop** e lasciarlo
misurare la flotta vera. La casa era **50504263** (demo BCM 100k, istanza
`-V3` del VPS), dry-run FTMO acceso il **09/08 alle 20:22** con 5 EA a
rischio 0,65%.

Il 17/08 Claudio ha cancellato un conto — _"non ho piu' quello da 109k"_ — ma
**ne ha ancora due: uno da 100k e uno da circa 5k.**

> ### 🔍 QUINDI LA PRIMA DOMANDA NON E' "CHE FACCIAMO", E' **"QUAL E' IL 100k"**
>
> ```
> powershell -ExecutionPolicy Bypass -File .\conto_attivo.ps1
> ```
> Legge il **giornale** di ogni terminale, l'unica fonte vera del conto
> collegato (`accounts.ini` elenca i conti *salvati*, e il 14/08 questa
> differenza aveva gia' fatto sbagliare una conclusione intera).
>
> | esce | vuol dire | cosa si fa |
> |---|---|---|
> | **`50504263`** | il dry-run del 09/08 **e' vivo** | 🟢 non si tocca niente: si raccolgono gli **otto giorni** gia' misurati |
> | **un numero nuovo** | il 100k e' un conto diverso | 🔧 si rifanno le **5 fasi** di `DEPLOY_GUARDIANO_100K.md`, che sono gia' scritte e testate |

### 3.1 ♻️ E i DATI del conto cancellato possono essere sopravvissuti
MT5 scrive i CSV nella **cartella dati**, non dentro il conto.
`ABTG_Trades_100k.csv`, gli `abtg_trades_*.csv` e le `pagella_*.txt` sul
Desktop possono essere ancora li'. Li cerca **`recupera_100k.ps1`** — legge,
copia sul Desktop, zippa, e **non cancella niente**.

### 3.2 🪑 E IL CONTO DA 5k RESTA IL FORWARD, non un banco prop
Il ~5k e' **50503392**: li' vive il forward e **non si tocca**. Non e' un
posto dove misurare le percentuali di una prop: a quella taglia il **lotto
minimo schiaccia il rischio** (e' lo stesso motivo per cui il driver ha
`-Deposito 100000`), e un solo trade e' gia' arrivato al **3,83% del conto**,
cioe' il **77% del margine giornaliero** di una prop
(`A1_A4_rischio_immediato.md`). Quelle sono le percentuali di un conto
piccolo, non di una challenge.

> **Il 100k misura. Il 5k opera. Non si scambiano.**

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
