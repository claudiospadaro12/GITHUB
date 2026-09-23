# 📐 COME SI LEGGONO I 13 ROUND — **scritto PRIMA che i numeri arrivino**

> ## 🔴 PERCHÉ QUESTO FOGLIO ESISTE
> Alle 19:13 del 23/09 è partita sul PC di backtest la corsa di **13 file prova ·
> 47 celle · 94 passate**. Fra poco arriveranno **tredici referti insieme**.
> 🔴 **Se decido COME leggerli dopo aver visto i numeri, sto scegliendo il criterio
> in funzione del risultato** — ed è esattamente il difetto che questa casa vieta
> (regola del 10/09, e le classi 664 e 675 scritte oggi).
> 👉 Quindi il criterio si congela **adesso**, a numeri ignoti. Quando lo zip arriva,
> questo foglio si applica: non si discute, si applica.

**Corsa**: pin `c3ac4ada` · deposito 100000 su tutti · `@FRAZIONEIS 0.40` dentro ogni file ·
tick reali (Modello 4) sui 9 file di R235/R234/R236a-b, **OHLC (Modello 1)** sui 4 di R236c-f.
**Pre-volo eseguito**: macchina `DESKTOP-H4D7CAJ` ✅ · compilatore ✅ · cartella dati certificata
via `origin.txt` ✅ · **`MaxBars = 100.000.000`** ✅ (niente finestre accorciate in silenzio) ·
**cache tick completa da `202409` su tutti e tre i simboli** ✅.

---

## 0️⃣ LA REGOLA CHE VIENE PRIMA DI TUTTE: **il cancello crociato**

| round | il cancello | se NON torna |
|---|---|---|
| **R234a** cella **H1** | deve riprodurre R110 corto puro: **IS `PF 1,23153 · DD 4,5113% · n 125`** e **OOS `PF 1,89147 · DD 2,6628% · n 302`** | 🔴 **non si legge NESSUNO dei tre file R234** — né b né c |
| **R235** cella **L+S** | identica **al centesimo** fra i gemelli dello stesso simbolo, e ancorata a R141: **`n IS 146 · n OOS 261`** | 🔴 non si legge nessuno dei quattro |
| **R237** *(non in questa corsa)* | celle AtrP **12** e **14** devono riprodurre i segni d'archivio | — |

🔴 **Si guarda QUESTO per primo, prima di qualunque PF.** Un banco che non riproduce un numero
noto non sta misurando ciò che crediamo, e ogni cifra che ne esce è aria.

⚠️ **E una conseguenza già scritta**: se il cancello crociato di R235 **passa** ma l'`n` non fa
146/261, **non è un guasto** — vuol dire che `@PERIODO` sposta l'`n`, cioè che la discrepanza
146/148/149 è **confermata**. È un risultato, non un incidente. Gli unici esiti che annullano
il round sono **cancello crociato KO** o **additività super-additiva**.

---

## 1️⃣ R235 — `IntradayMomentum`, il LATO ad asse (4 file, 16 passate, tick)

### ✅ COSA PUÒ DIRE
- 🟢 il **RISCHIO** (DD, Peggior Giornata): si legge **a qualunque n** (Emendamento B);
- 🟢 il **numero di operazioni PER LATO**, che **oggi non esiste come numero** ed è il punto del round;
- 🟢 il **rapporto `n(short)/n(long)`**, che è il test vero.

### 🔴 COSA NON PUÒ DIRE
🔴 **Il MERITO.** `@FRAZIONEIS 0.40` su n=261 dà **~146 IS / ~261 OOS** sulla cella L+S, e le celle
**pure** stanno sotto: long OOS 136-157, short OOS 104-125. **L'IS è sotto 150 già sulla L+S.**
Nessuna promozione, nessuno spegnimento, qualunque PF esca.

### 📊 IL TEST, coi quattro rami già congelati
Rapporto `R = n(short)/n(long)` in OOS:

| R | lettura |
|---|---|
| **0,00 – 0,12** | la **deriva** spiega tutto: nessun lato è migliore, e la mia attesa 52-60% long era sbagliata |
| **0,13 – 0,666** | 🟠 **terra di mezzo**: la deriva spiega una PARTE. Si riporta la **frazione spiegata** `R/0,128`, **non un verdetto** |
| **0,667 – 0,923** | la deriva **non basta**: lo short perderebbe molto meno di quanto la deriva imponga → **sarebbe lo SHORT ad avere il segnale migliore per operazione** |
| **> 0,923** | la mia lettura del meccanismo è sbagliata |
| 🔴 **fuori dai quattro** | se `n(long)+n(short) ≠ n(L+S)`, **il file è falsificato**: si è misurato il banco, non il motore |

### ⚠️ UNO SFORAMENTO ATTESO, dichiarato prima
`T3` (DD ≤ 10,00% a rischio 1,0%) **verrà sforato su NASUSD IS: ~11,94% atteso**. È sulla cella di
riferimento **già bocciata da R98**, e **T3 resta vincolante sulle celle PURE**. Non è una scusa
preventiva: è una previsione. Su U30USD IS l'attesa è **~9,87%, sul filo**.

### 🪦 E il contesto che non si dimentica
R98 (23/08) ha **BOCCIATO** questo motore su NASUSD: **0/6**, cancello S0 *"matematicamente
impossibile"*, **−0,31 punti indice per operazione su 410**, già al netto dello spread.
👉 **Questo round non riapre R98: continua R141.** In `REGISTRO_TEST.md` lo stato resta quello di
oggi — **NON ANCORA MISURATO** — qualunque cosa esca.

---

## 2️⃣ R234 — `EMA200` corto, il TF ad asse (3 file, 30 passate, tick)

5 celle per file: **M30 · H1 · H2 · H3 · H4**.

### 💸 IL CANCELLO DEL COSTO, già compilato — e decide PRIMA del PF
Frontiera `40 × spread`, con lo spread **per barra** (il motore non ha filtro d'ora, classe 650):

| cella | U30USD (/2,60) | D30EUR (/2,70) | NASUSD (/2,40) |
|---|---|---|---|
| **M30** | 28,4× 🔴 | 16,9-19,3× 🔴 | 23,7× 🔴 |
| **H1** | **40,1× 🟠** *sul filo* | 23,9-27,2× 🔴 | 33,5× 🔴 |
| **H2** | 56,7× 🟢 | 33,9-38,5× 🔴 | 47,4× 🟢 |
| **H3** | 69,5× 🟢 | 41,4-47,1× 🟢 | 58,0× 🟢 |
| **H4** | 80,2× 🟢 | 47,9-54,5× 🟢 | 67,0× 🟢 |

🔴 **Una cella sotto 40× NON si promuove, qualunque PF faccia.** Si legge per dare la forma della
curva e si marca **ESCLUSA PER COSTO** col suo numero.
📌 E vale la **classe 666**: *"la gamba MEDIANA passa il 40×"*, **mai** *"la cella passa il 40×"*.

### 🔥 IL RISCALDAMENTO È UNA VARIABILE DELL'ASSE, non una costante
`@DAQUANDO 2024.09.26` è il pavimento dei dati: la EMA200 del TF della cella non esiste per 200
barre. Gamba IS bruciata: **M30 2,3% · H1 4,7% · H2 9,5% · H3 14,3% · H4 19,1%**.
👉 **Una parte del crollo di `n` al TF alto è impalcatura, non motore.** Ogni `n` della gamba IS si
legge come `n / (giorni VIVI della cella)`, non `n / 256`. **La gamba OOS è pulita.**

### 🧪 IL CONTRO-ESEMPIO, e quanto è larga la sua porta
Tesi comoda: *"il corto è del Dow"*. La falsifica **una** cella DAX o Nasdaq con `PF ≥ 1,10`,
`n ≥ 150` **e** costo passato.
🔴 **Col costo onesto le celle che possono falsificarmi sono H3/H4 sul DAX e H2/H3/H4 sul Nasdaq.**
Se nessuna arriva a `n ≥ 150`, **il round NON ha falsificato niente**: ha detto
**«NON ANCORA MISURATO»** — e va scritto così, **mai** *"confermato che il corto è del Dow"*.

---

## 3️⃣ R236a/b — buffer dello stop (2 file, 20 passate, tick)

> ## 🔴 **DUE CANCELLI NASCONO SOSPESI, E LO ZIP LO DICE DA SOLO**
> `SOSPESO_FASE1_T7.txt` è scritto **dentro** `ROUND_R236a\` e `ROUND_R236b\`.

| | stato |
|---|---|
| **T7** — il verdetto sul `40×` | 🔴 **NON PRONUNCIATO**: la base dello stop non è misurata (FASE 1 non eseguibile, classe 668) |
| **T3** — attribuzione del movimento di `n` | 🔴 **NON ESEGUITO** |
| **sopravvivenza** — confronto FRA celle | 🟢 **questo si legge**, e non ha bisogno della base |

🔴 **`ESITO: ROUND GIRATO` nel referto NON vuol dire cancello passato.** Se il referto di merito
apre senza la riga **«CANCELLO DEL COSTO: NON PRONUNCIATO»**, è scritto male.

### E cosa NON si può concludere sul PF
Effetto atteso cella 1 → cella 5: **+0,04**. Risoluzione del banco: **0,094 (n 62) → 0,248 (n 24)**.
👉 L'effetto sta **sotto** la risoluzione su tutte le tranche (0,15×–0,42×): **il round non può
CONFERMARE**. Si legge **solo un crollo NETTO** — `PF < 1,00` sulla cella 5, su **tutte e due** le
tranche **e tutti e due** i lati: **quattro numeri concordi**, non uno.

📌 E il quadro delle basi, già scritto: **due scenari su quattro non passano il 40× affatto**;
contro la frontiera **BCM a 24 ore (96,0 idx) nessuna cella passa su nessuna base** — il massimo
che il round produce è **32,4×**, l'81% della frontiera.

---

## 4️⃣ R236c/d — `InpSLLookback` in **OHLC** (2 file, 10 passate)

🟢 Domanda di **geometria**, non di statistica: *`ext(N)` batte mai `stLine`?*
🔴 **Banco OHLC**: i suoi numeri **non si confrontano** con quelli a tick (classe 604). Mai una
tabella che mette insieme le due cose.
🔴 E **nessuna soglia di monotonia sull'`n`** (classe 663): l'EA tiene **una posizione alla volta**,
quindi `n` può muoversi nei due versi senza che nessuna lettura sia sbagliata. Si guarda **quale
contatore si è mosso**, non se `n` sale o scende.

## 5️⃣ R236e/f — la finestra oraria in **OHLC** (2 file, 8 passate)

🟢 Misura **quanto campione costa** accendere la finestra — non serve più a passare il cancello.
🔴 **Il rapporto `n(accesa)/n(spenta)` è un SALDO, non un costo**: una gamba notturna **occupa** il
motore e gli impedisce di entrare di giorno; spegnere la notte **libera lo slot** e può **creare**
ingressi diurni. 👉 **Il rapporto può stare sopra 1,00 senza nessun errore.**

---

## 🧾 L'ORDINE IN CUI SI LEGGE LO ZIP

1. 🔍 **`RIEPILOGO_ROUND_PRONTI.txt`** → `CARTELLE ATTESE: 13 TROVATE: N`. Se **N ≠ 13**, la catena
   è rotta: si legge **quali mancano** e perché, prima di qualunque numero.
2. 🔴 **I due cancelli crociati** (R234a-H1 contro R110 · R235 L+S contro R141). Se falliscono,
   **ci si ferma qui**.
3. 💸 **Il cancello del costo**, cella per cella. Le celle sotto 40× si marcano **prima** di
   guardarne il PF, così il PF non influenza la marcatura.
4. 🛡️ **Il RISCHIO** (DD), che si legge a qualunque n.
5. 📈 **Il MERITO**, e **solo** sulle celle con `n ≥ 150` in OOS.
6. 🪦 **I verdetti**: nessuna promozione da nessuno di questi round. Chi non ha le cinque caselle
   del certificato resta **«NON ANCORA MISURATO»**, non «morto».

---

## ⚪ COSA QUESTO FOGLIO NON COPRE
- **Il tempo macchina reale**: la banda dichiarata era **25-80 minuti «e può sforare»**, ma con la
  cache tick già completa il sovraccarico dei 26 avvii non si paga. La riga `durata minuti:` del
  riepilogo è **la prima misura che avremo**: va registrata, non commentata.
- **`R237`**: non è in questa corsa. È scritto e corretto, ed è al cancello.
- **La FASE 1** di R236a/b: resta da scrivere come riga di lancio a sé. Finché non esiste,
  T7 e T3 restano sospesi **su ogni corsa futura**, non solo su questa.
