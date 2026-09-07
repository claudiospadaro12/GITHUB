# 🛑 CORSIA DEMO — `DAX REENTRY` LONG break 40: **NON ACCENDERE**

_Scritta il **07/09/2026**. Candidato 🥉 **G3** di `report/CORSIA_DEMO_CANDIDATI.md`.
Regole della corsia: `report/CORSIA_DEMO_REGOLE.md`._

> 🔴 **DA RIPETERE OGNI VOLTA CHE SI CITA QUESTO MOTORE: il lato SHORT è
> MISURATO E MORTO.** PF **0,38–0,54**, DD **8,8–23%** su tutte le celle
> 20/30/40. Se un giorno si accende, si accende **SOLO LONG**, e sta scritto
> nel preset, non lasciato al caso.
> _(fonte: `backtest_pipeline/risultati_archivio/REFERTO_DAXREENTRY_2026-08-31.md`)_

---

## ⚖️ IL VERDETTO IN UNA RIGA

**Il RISCHIO è il migliore di tutto il lotto. Il TRAGUARDO è fuori portata di un
fattore 2-3.** La regola della corsia dice che in quel caso **la sedia non entra**:
non è un giudizio sul motore, è un giudizio sullo **strumento**.

> `report/CORSIA_DEMO_REGOLE.md`, punto 2, testuale:
> _"**Il TRAGUARDO** — n = 150 operazioni, e la data stimata per arrivarci alla
> frequenza attesa. **Se la stima dice 4 anni, la sedia non entra**: il forward
> non è lo strumento nemmeno lì."_

**Qui la stima dice 4,6 anni nella lettura severa e 2,9 anni in quella
generosa. Tutte e due oltre il tetto dei ~18 mesi. È esattamente il caso che
la regola nomina.** Per questo **non ho scritto il preset**: la scheda si ferma
qui, con i numeri, per essere ripresa se e quando il quadro cambia.

---

## 2️⃣ IL TRAGUARDO — il conto che la boccia

**Frequenza misurata**, ricalcolata dai numeri primari (n=57 su 459 giorni
feriali, finestra tick 2024.09.26→2026.06.30, cella `InpBreakPts=40`, `InpSide=0`):

| | |
|---|---:|
| operazioni / giorno feriale | **0,1242** (57 / 459) |
| operazioni / mese (× 21,75) | **2,70** — coerente col _"~3-4 trade/mese per lato"_ del referto ✅ |

| lettura | cosa conta | feriali | durata | data |
|---|---|---:|---:|---|
| **A — forward DA SOLO** arriva a 150 | solo la demo | **1.208** | **55,6 mesi** (4,6 anni) | **~aprile 2031** |
| **B — il `n` della CELLA** (backtest 57 + forward 93) | la stessa lettura usata per NY RETEST | **749** | **34,5 mesi** (2,9 anni) | **~luglio 2029** |

❌ **Nessuna delle due sta sotto i 18 mesi.** E la differenza col NY RETEST è
strutturale, non marginale: là mancavano **35** operazioni, qui ne mancano **93**,
a una frequenza che è **la metà**.

📐 **La cella più veloce dello stesso lato non salva il candidato mandato**:
`InpBreakPts=20` LONG ha **n=92** → 4,36 op/mese → lettura B in **13,3 mesi**
(~ottobre 2027). Ma quella cella ha **PF 1,159 e DD 4,6%**: è **sotto la barra
PF ≥ 1,3**, quindi non è il candidato che il censimento ha promosso, ed è
**un'altra sedia, non questa**. 👉 **Lo metto agli atti come DECISIONE DI
CLAUDIO, non come sostituzione fatta da me**: si veda §"Se Claudio vuole
accenderla lo stesso".

### ⚠️ E anche il pavimento di frequenza dice la stessa cosa
La firma del 07/09 sposta il pavimento di **1,00 op/giorno** dalla **sedia** alla
**FAMIGLIA**. La famiglia `DaxReEntry` oggi ha **una sola sedia schierabile**
(D30EUR LONG, gli short sono morti misurati, gli altri simboli **NON MISURATI**):
la portata di famiglia coincide con quella della sedia, **0,12 op/gg**, cioè
**un ottavo** del pavimento. La firma del 07/09 **non la salva**: salva chi ha
una famiglia larga, e questa famiglia è larga uno.

---

## 3️⃣ IL DD PROMESSO — **2,9%** (sarebbe stato il cancello)

Lo scrivo comunque, perché se un giorno la sedia si accende questo è il numero,
e perché **è la parte del dossier che non ha nessun problema**.

| metrica (D30EUR M5, **tick reali BCM**, rischio **0,65%**, 2024.09.26→2026.06.30) | valore |
|---|---:|
| profit factor (break 40 LONG) | **1,69 – 1,80** |
| **drawdown equity** | **2,5 – 2,9%** → promesso: **2,9%** (il peggiore dei due) |
| peggior giornata | **−0,67%** |
| profitto | **+7.168 / +9.518** su deposito 100.000 |
| overnight veri | **0%** |
| autotest | **0 su 18** |
| n | **57** |

✅ **Rischio 0,65% già nel banco**, nessuna riscalatura
(`backtest_pipeline/righe/RIGA_DAXREENTRY.ps1` riga 45: `$Deposito = 100000`;
`prove/ABTG_DaxReEntry.txt`: `InpRiskPercent=0.65`).
✅ **Cancello S0 CHIUSO e larghissimo**: take mediano LONG **+76,8 punti indice**
contro spread D30EUR misurato **1,6–1,7 punti** in sessione (03/09, 252M tick)
= **~45×** contro un cancello di 2,5–3×.
✅ **6/6 celle long verdi**, PF ordinato col filtro, DD in discesa, SL-fraction
insensibile = **banda vera, non picco**. _(Al contrario del NY RETEST.)_

🔴 **E la contro-evidenza, dichiarata:** i 21 mesi tick sono **un solo regime
(toro)**, e un **long-only** in un toro **parte avvantaggiato per costruzione**.
Il referto lo dice, il censimento lo ripete. Con n=57 e un regime solo, il
PF 1,69–1,80 **non è una promessa**: è il numero di una finestra.

---

## 4️⃣ IL TAGLIANDO — non si apre, quindi non si fissa

Non c'è un tagliando a 6 mesi perché non c'è una sedia. **La data da segnare è
un'altra**, ed è il momento in cui il quadro può cambiare davvero:

🗓️ **~luglio 2027** — quando la finestra tick BCM avrà **~10 mesi in più**, la
stessa cella `break=40 LONG` dovrebbe avere **n ≈ 84** in backtest puro
(57 + 10×2,70). Ancora sotto 150, ma con una lettura in più: **il primo pezzo di
storia fuori dal toro 2024-2026**, se il regime nel frattempo gira.

---

## 🔓 SE CLAUDIO VUOLE ACCENDERLA LO STESSO — cosa serve, e quanto costa

Non è una porta chiusa a chiave: è un **no motivato**, e si riapre con una firma.
Tre strade, in ordine di costo crescente e di onestà decrescente:

| # | strada | cosa cambia | costo | onestà |
|---:|---|---|---|---|
| 1 | **Accendere `break=20` LONG** invece di `break=40` | traguardo B a **13,3 mesi** (~ott 2027) = **dentro il tetto** | preset + magic (**769310**, verificato libero) | 🟠 la cella è **sotto la barra** PF 1,159: si accenderebbe per **misurare la banda**, non l'edge. Va scritto così, non come "il candidato G3" |
| 2 | **Accendere `break=40` accettando il 2029** | niente | preset + magic | 🔴 è esattamente ciò che la regola chiama _"un ingombro, non un esperimento"_ |
| 3 | **Allargare la FAMIGLIA** (stesso meccanismo su U30USD / NASUSD / E50EUR) | la portata di famiglia sale, e la firma del 07/09 morde davvero | **una corsa di passo 0 per simbolo**, criteri congelati prima | 🟢 **è la strada giusta**, ed è quella che la firma del 07/09 indica: _"la portata la fa il numero di simboli, non la velocità del motore"_ |

👉 **La mia proposta è la 3**, e non costa una sedia demo: costa **una riga di
lancio**. Se il meccanismo regge su un secondo indice, la famiglia diventa
accendibile per intero e il traguardo si dimezza da solo.

---

## 🪪 MAGIC RISERVATO (per non perdere il lavoro)

| | |
|---|---|
| **769310** | verificato **VERGINE** repo-wide il 07/09/2026: `grep -rn "769310" . --exclude-dir=.git` → **0 occorrenze**. Riservato a questa sedia se un giorno si accende. **NON è 769300**, che è il magic del round e non va mai riusato in campo. |

---

## 🛑 E LA FRASE CHE VALE COMUNQUE

**La corsia demo non è una porta verso il conto reale.** Nemmeno se un giorno
questa sedia si accende: tornerebbe **in coda all'imbuto** col suo n finalmente
pieno, e da lì si giudicherebbe col merito come tutte. Il passaggio ai soldi veri
resta una **firma specifica su un numero misurato**.

---

## ✅ COSA RESTA A VERBALE, ANCHE COL NO

1. Il **cancello S0 è chiuso** (era aperto al 31/08): rapporto take/spread ~45×.
   Questa è **una misura acquisita**, e non va rifatta.
2. Il **lato SHORT è morto con un numero** e non torna in discussione senza un
   **meccanismo diverso** (Regola della Seconda Caccia), mai un'altra griglia.
3. Il **DD 2,5–2,9% a 0,65%** e la **peggior giornata −0,67%** sono i migliori
   numeri di rischio dell'intero censimento del 07/09. **Il motore non è
   bocciato: è troppo lento perché il forward lo possa giudicare.**
