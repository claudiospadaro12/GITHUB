# 🔍 R123 BLOCCO C — LE SETTE CELLE, LETTE. Verdetto: **NON ANCORA MISURATO**

**12/09/2026.** Il blocco C di R123 (`InpStAtrPeriod`, asse mai messo ad asse
prima in 0 file prova su tutto il repo) era girato il **09/09 alle 19:32-19:53**
a **tick reali** e non era stato letto da nessuno. Sette celle IS + sette OOS,
**tempo macchina gia' pagato**.

## 📊 LE SETTE CELLE (verificate: 7 righe dati per file, delimitatore virgola)

Motore `ABTG_SupRev_DOW_H1_Ottimizzato` · `U30USD` H1 · `InpStMult 3.5` e
`InpNearAtr 1.0` **pinnati** · finestra `2024.09.26 → 2026.06.30`.

| `InpStAtrPeriod` | IS PF | IS DD% | IS n | OOS PF | OOS DD% | OOS n |
|---:|---:|---:|---:|---:|---:|---:|
| 6 | 0,556 | 8,13 | 104 | 0,914 | 8,97 | 202 |
| 7 | 0,851 | 5,10 | 117 | 0,882 | 6,34 | 165 |
| 8 | 0,781 | 9,11 | 136 | **1,164** | 6,73 | 179 |
| 9 | 0,988 | 6,17 | 117 | **1,389** | 5,91 | 152 |
| 10 | 0,888 | 7,06 | 111 | 0,610 | 8,66 | 128 |
| 11 | 0,836 | 6,08 | 129 | 0,559 | 9,23 | 108 |
| **12** | **1,177** | **4,93** | 106 | **1,359** | **2,84** | 133 |

## 🛑 PERCHE' NON SI PROMUOVE NIENTE, E NON SI CHIUDE NIENTE

**1. 🔴 Sei celle su sette hanno IS PF < 1,00.** L'unica sopra e' la **12**.

**2. 🔴 E la 12 sta sul BORDO della griglia.** La regola di casa e' **centro
dell'altopiano, MAI il picco** — e una cella di bordo **non puo' essere il
centro di niente**, perche' di cio' che sta oltre non sappiamo nulla. Non e'
pignoleria: in R70 i confronti fatti col picco si sono **ribaltati** quando
sono stati rifatti con la regola giusta.

**3. 🔴 La superficie IS e' FRASTAGLIATA**, non un altopiano:
`0,556 → 0,851 → 0,781 → 0,988 → 0,888 → 0,836 → 1,177`. Su e giu' quattro
volte. E' la firma che l'Emendamento A descrive per R70: con un campione
sottile la superficie e' irregolare e **la selezione inseguirebbe il rumore**.

**4. 🔴 Il campione non regge il giudizio di MERITO.** La colonna `n` dei nostri
CSV conta **DEAL di uscita, non POSIZIONI** (classe 226, verificata su 66 file
per-trade su 66). Con un fattore deal/posizione fra 1,0 e 2,3, le **posizioni**
di queste celle stanno fra ~45 e ~136: **sotto il pavimento di 150** di
Emendamento A, su **tutte e quattordici** le finestre. Quindi il **MERITO e'
sospeso**, per regola, non per opinione.

**5. 🟢 Il RISCHIO invece si giudica sempre**, e questa e' la buona notizia: DD
IS fra 4,93% e 9,11%, DD OOS fra 2,84% e 9,23%. **Nessuna cella sfonda il 10%**,
e la 12 e' la piu' bassa di tutte e due le colonne (4,93 / 2,84).

**6. 🟠 Un solo REGIME.** `@DAQUANDO 2024.09.26` = 21 mesi. Emendamento C: la
prova di regime batte la storia contigua, e **un solo regime non e' una prova**.

## 🎯 QUINDI: `[NON ANCORA MISURATO]`, e il numero che manca e' UNO

Non e' un motore senza edge: e' un motore la cui **griglia e' nel posto
sbagliato**. La cella migliore e' **all'estremo**, quindi la domanda vera —
*"oltre il 12 c'e' un ALTOPIANO o il 12 e' un PICCO di bordo?"* — **non e' mai
stata posta**.

📌 E questo e' esattamente il caso che il motto del 09/09 descrive: il candidato
e' fermo per un numero **MANCANTE**, non per un numero **BRUTTO**. *"Se potrebbe
passare, si insiste"* — e insistere qui vuol dire **una misura in piu'**, non un
criterio piu' morbido.

## ▶️ IL ROUND CHE LO CHIUDE: **R135a**, 8 celle, 16 passate

`backtest_pipeline/prove/R135a_U30USD_atrperiod_oltre12.txt` — stessa cella,
stessi pin (`StMult 3.5`, `NearAtr 1.0`), stessa finestra, **asse 13 → 20**.

🔒 **Le due uscite, scritte PRIMA dei numeri** (e sono nel file prova, non solo
qui):
- **(a) ALTOPIANO** — almeno **3 celle contigue con OOS PF > 1,1**: si prende la
  **centrale** e si passa alla **prova di regime**. 🚫 **Non si promuove qui**:
  il campione resta sotto il pavimento, quindi il merito resta sospeso.
- **(b) PICCO** — 13 e 14 tornano sotto 1: il 12 era **rumore di bordo**, e il
  blocco C si chiude con il **certificato di morte completo** (PF, n, DD,
  gestione, gemelli, TF) in `REGISTRO_TEST.md`.
- **(c) terza uscita dichiarata**: se l'altopiano **sale fino al 20**, l'asse e'
  **ancora sul bordo** e si dice — 🚫 non si promuove una cella di bordo per la
  seconda volta.

💰 **Costo**: 16 passate a tick reali, lo stesso ordine di grandezza di `r132c`
(16) e `r133c` (18) gia' in coda.

⏳ **NON l'ho messo in coda, ed e' una scelta**: le quattro righe di round in
coda **non hanno ancora girato nemmeno una volta** (il VPS gira il runner **v2**
e le rifiuta a G1). Aggiungere una quinta riga **prima** della prima notte buona
vorrebbe dire, se qualcosa va storto, non sapere **quale** riga l'ha fatto
andare storto. Entra in coda **dopo** la prima notte che torna sana.
