# 🔬 REFERTO ROUND 54 — i due lati mai misurati del Dow: **misurati, e bocciati**

_Girato il 14/08/2026 sera sul PC di backtest. U30USD M5, tick reali, deposito
100.000, rischio 1%. 16 passate (4 celle × 2 finestre × 2 EA), 4 CSV su 4
prodotti. Criteri congelati a numeri non visti in
`prove/R54_LATO_MAI_MISURATO_TESI.md` — si leggono prima delle tabelle._

---

## 0. Igiene, prima di tutto

- **Sweep gemello**: ogni cella è girata con due magic vergini (772601/772602
  e 772611/772612). **Tutte e 8 le coppie identiche al centesimo**, in tutti e
  quattro i CSV. Il banco è pulito.
- **Riproduzione della cella viva del Dow Apertura**: il nostro `1/0` fuori
  campione fa **+6.721,93 · PF 1,27013 · DD 4,3941%**. Il referto R46 riga 33
  ("A = LIVE") dice **+6.722 · 1,27 · 4,39**. Stessa cella, stesso numero.
- **Riproduzione della cella R15 dell'ORB**: il nostro `1/0` OOS fa PF **1,674**,
  DD **9,76%**, **n = 119**. R15 aveva PF 1,657, DD 9,92%, **n = 119** su
  deposito 10.000. Stesso identico numero di trade, PF e DD a due centesimi
  (scarto da arrotondamento del lotto sul deposito diverso).
- **Contabilità dei trade**: 74+73=147 e 130+73=203 (Dow); 71+64=135 e
  119+100=219 (ORB). Le celle `1/1` sono esattamente la somma delle due
  monodirezionali. Nessun trade perso per strada.
- La cella `0/0` fa 0 trade e 0,00 di profitto in tutti e quattro i CSV, come
  previsto dal criterio 1. **Si ignora.**

---

## 1. DOW APERTURA US — il tabellone

| cella | IS profit | IS PF | IS DD | IS n | OOS profit | OOS PF | OOS DD | OOS n |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| **solo LONG** (com'è oggi) | +2.811,84 | 1,222 | 5,67% | 74 | **+6.721,93** | **1,270** | **4,39%** | 130 |
| **solo SHORT** (mai misurato) | **+6.463,44** | **1,511** | **2,68%** | 73 | −2.591,58 | 0,840 | 8,62% | 73 |
| long + short | +9.461,23 | 1,372 | 5,53% | 147 | +3.926,85 | 1,096 | 8,68% | 203 |

### Verdetto sullo short — criterio 3

**BOCCIATO.** PF fuori campione **0,840**, richiesto ≥ 1,10. E **non** per
campione piccolo: n = 73, ben sopra la soglia di 30 del criterio 2. È una
bocciatura **per merito**, non un "non misurabile". La domanda aperta da sei
settimane ha una risposta.

### Verdetto sul long+short — criterio 4

**BOCCIATO due volte.** Serviva più profitto OOS **e** un DD non peggiore:
fa **meno** profitto (+3.927 contro +6.722, −42%) **e** un DD quasi doppio
(8,68% contro 4,39%). Il long-only resta.

### 🔁 IL 28° RIBALTAMENTO — ed è il risultato più importante del round

Guarda la colonna IS: **in campione lo short è la cella MIGLIORE**. Più
profitto del long (+6.463 contro +2.812), PF più alto (1,511 contro 1,222) e
DD meno della metà (**2,68% contro 5,67%**). Chiunque avesse tarato guardando
dentro il campione avrebbe **acceso lo short**, e con entusiasmo.

Fuori campione quella stessa cella va **in rosso** (−2.592, PF 0,840, DD che
triplica a 8,62%). **9.000 € di differenza fra le due finestre sulla stessa
identica ricetta.**

Il long-only, che in campione era il fanalino, fuori campione è il migliore
delle tre celle su **tutte e tre** le colonne che contano.

> Non è una curiosità statistica: è la dimostrazione, sui nostri dati, che
> **il lato spento in R6 era la scelta giusta** — e che lo sarebbe stato anche
> se qualcuno avesse fatto la prova guardando l'IS, purché non si fermasse lì.

---

## 2. ORB-EMA200 DOW — il tabellone

| cella | IS profit | IS PF | IS DD | IS n | OOS profit | OOS PF | OOS DD | OOS n |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| **solo LONG** (com'è oggi) | +9.509,39 | 1,250 | 7,89% | 71 | **+41.057,00** | **1,674** | **9,76%** | 119 |
| **solo SHORT** (mai misurato sul Dow) | −11.183,48 | 0,681 | 13,72% | 64 | **−25.603,48** | **0,520** | **26,37%** | 100 |
| long + short | −2.821,60 | 0,961 | 11,48% | 135 | +5.525,75 | 1,047 | 17,16% | 219 |

### Verdetto sullo short — criterio 3

**DISTRUTTO, e coerentemente.** Rosso in **entrambe** le finestre, PF 0,681
dentro e **0,520** fuori, con un DD del **26,37%** — due volte e mezzo il
tetto prop. Fallisce tutti e tre i cancelli. n = 64 e 100: misurabile senza
alibi.

### Verdetto sul long+short — criterio 4

**BOCCIATO due volte, in modo brutale.** +5.526 contro +41.057 (**−87% di
profitto**) e DD da 9,76% a **17,16%**. Aggiungere lo short a questa cella
non la diversifica: la sabota. E ricordiamo il doppio asterisco di R15 — lì il
DD passava per 8 centesimi. Qui lo sfonda.

### Nessun ribaltamento

Sull'ORB il lato è **stabile fra le finestre**: long verde in tutte e due,
short rosso in tutte e due, e il segno non cambia mai. Diversamente dal Dow
Apertura, qui non c'è ambiguità da regime.

---

## 3. Le ipotesi scritte prima: quale ha vinto

Il §3 della tesi metteva in fila due possibilità. La risposta è **diversa
per i due EA**, e questo è già di per sé un risultato.

**ORB-EMA200 → [IPOTESI B], asimmetria strutturale.** Lo short non è
"specularmente rosso": è molto peggio di così, ed è rosso in modo **coerente
su entrambe le finestre**. Sull'apertura del Dow la rottura al ribasso della
open range, filtrata EMA200, si comporta da trappola sistematica — non da
immagine allo specchio del long.

**Dow Apertura → nessuna delle due, e la cosa è informativa.** Lo short non è
"rosso ma non catastrofico" (A) e non è "sempre molto peggio" (B): è **il
migliore dentro e negativo fuori**. Cioè il lato, su questa cella, **non è
stabile**. Va letto come rumore di regime, non come struttura.

**[INCERTO], e resta incerto:** come dichiarato al §3 della tesi, ventun mesi
di un solo regime **non separano** l'asimmetria del mercato da quella del
periodo. Questo round non chiude quella domanda — la rende solo molto meno
urgente, perché nessuna delle due celle short si avvicina ai cancelli.

---

## 4. Cosa cambia (criterio 5)

**Niente sul forward. Come scritto prima di guardare i numeri.**

E stavolta i numeri dicono esattamente la stessa cosa: le due celle vive
girano **già** nella configurazione migliore delle tre, fuori campione, su
profitto **e** su drawdown. Non c'era niente da correggere — ma adesso lo
sappiamo, invece di sperarlo.

**Criterio 6 non si attiva**: nessuno dei due short è verde, quindi R6 e
R13/R14/R15 **non vanno riletti**. Al contrario: R54 li conferma dall'esterno,
misurando l'alternativa che loro non avevano misurato.

**Criterio 7**: questa è la **quarta** guardata all'OOS del Dow (R14, R15,
R46, R54). Pesa in classifica, ed è scritto qui perché pesi davvero. Nessuna
cella nuova è stata promossa — il che, in una quarta guardata, è la cosa più
sana che potesse succedere.

---

## 5. Il conto del censimento R52

Delle **11 celle col lato spento a mano**, due erano misurabili subito. Sono
state misurate tutte e due, in una sera. **Restano 9**, tutte in attesa di
dati che oggi non abbiamo (di Pepperstone non c'è un byte: conto demo non
creato, ricognitore in timeout, 0 file).

La riga onesta del censimento — _"un terzo delle celle vive ha un lato spento
a mano, e quei lati sono stati giudicati dentro la stessa finestra amica del
long"_ — resta in piedi per le altre nove. Per queste due, il sospetto è stato
**verificato e archiviato**.
