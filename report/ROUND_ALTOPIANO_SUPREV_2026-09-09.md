# 🏔️ R123 — **IL ROUND CHE CHIUDE LA QUESTIONE `SupRev DOW H1`**

**Dossier del cercatore di parametri · 09/09/2026 · branch `lavoro`**
Motore: `ABTG_SupRev_DOW_H1_Ottimizzato` · simbolo `U30USD` · **H1 FISSO**
Sedia di riferimento: **970916, SPENTA l'11/08/2026**

> 🎯 **La domanda, una sola:** il `PF OOS 1,43648` della cella
> `StMult 3.5 / AtrP 9 / NearAtr 1,0` sta **al CENTRO di un altopiano**, o
> **sporge da sola**? Perche' se sporge, era rumore — e la cella "verde per
> caso" e' quella che brucia la challenge.

---

## 🥇 LE TRE COSE CHE HO TROVATO OGGI, in ordine di peso

### 1. 🔴 **IL NUMERO CHE HA RIAPERTO QUESTO CANDIDATO E' STATO PRODOTTO DA UN BINARIO CHE NON ESISTE PIU'**

Questa e' la scoperta piu' importante del dossier, e **nessun referto la dice**.
`git log` su `mql5/Experts/ABTG_SupRev_DOW_H1_Ottimizzato.mq5`:

| commit | data e ora | cosa ha cambiato |
|---|---|---|
| `400a462` | **08/08/2026 06:54** | 👈 **qui sono committati i CSV di FASE 0**, quelli del `1,43648` |
| `3af47ed` | 08/08/2026 **11:48** | `LotByRisk()`: `OrderCalcProfit` al posto del tick value nudo |
| `f8ebc32` | 19/08/2026 07:47 | migrazione Guardian (fail-open nel tester) |
| `872dba8` | 08/09/2026 07:13 | **pavimento del lotto minimo PRIMA di `lotPend`** (v1.00 → 1.01) |

**I CSV sono usciti quasi CINQUE ORE prima del primo dei tre cambi.** E il terzo
non e' cosmetico: quando `totLot * InpFirstFraction` normalizza a zero, il codice
**vecchio** piazzava comunque il pendente (= un secondo trade), quello **nuovo**
lo salta (`mq5` righe 260-271). 👉 **`n = 118` e `n = 155` non sono garantiti dal
codice di oggi.**

🚨 **Conseguenza operativa immediata**: la soglia **T1** dei due file gemelli
gia' in cartella — `A1_SUPREV_DOW_H1_01_trailonst.txt` e `02_exitonflip.txt` —
dice *"se non riproduce → **FILE INVALIDO**, non si legge nient'altro"*.
**Scritta cosi' butterebbe un round per un cambio di codice documentato e
voluto.** Nei file R123 l'ho riscritta: la sentinella di continuita' **non e'
bloccante**, quella di determinismo si'. Segnalo il difetto, **non ho toccato i
due file altrui**.

### 2. 🏺 **L'ALTOPIANO NON ERA A ZERO: c'era gia' mezza mappa in archivio, del 26/07**

Il referto di stamattina dice *"attorno alla cella viva non c'e' nessun vicino in
spazio di parametri"*. **Vero per il round del 08/08 — ma NON per l'archivio.**
Scavando: `backtest_pipeline/ini/valid_SupRevScr_U30USD_H1.ini` +
`risultati_archivio/SupRev_nuovi_indici/642b6b88-valid_SupRevScr_U30USD_H1.csv`
(**27 passate OHLC**) e `valid_SupRevRT_U30USD_H1_realtick.csv` (**8 passate a
TICK REALI**), stesso simbolo, stesso TF, **stessa finestra**.

**Che sia la stessa finestra e' CONTROLLATO, non assunto**: la cella `3.5/9/3.0`
a tick fa **n = 273** sul periodo intero, e **118 (IS) + 155 (OOS) = 273 esatto**.

**PF, periodo intero, OHLC, TP_RR 3,0, NearAtr 1, H1:**

| StMult ＼ AtrP | **8** | **9** | **10** |
|---|---:|---:|---:|
| **2,5** | 0,868 *(n 475)* | 1,084 *(n 444)* | 1,221 *(n 454)* |
| **3,0** | 1,048 *(n 367)* | 1,095 *(n 349)* | 1,238 *(n 306)* |
| **3,5** | 1,015 *(n 318)* | 🎯 **1,334** *(n 273)* | **0,779** *(n 248)* |

**Le stesse celle a TICK REALI:** `3,0/9 → 1,040` · `3,0/10 → 1,081` ·
`3,5/9 → **1,195**` · `3,5/10 → **0,706**`.

🔴 **Un solo passo di periodo ATR fa cadere il PF di 0,49 punti a tick reali.**
E il **verso si inverte con lo StMult**: a 2,5 e 3,0 il PF *sale* da AtrP 8 a 10;
a 3,5 *crolla*. 👉 **L'archivio, da solo, prevede gia' che la cella viva sia una
CRESTA sull'asse `InpStAtrPeriod`.** Questo e' il fatto che ha riscritto tutto il
disegno del round (vedi §4: il passo su quell'asse **deve** essere 1, non 2).

### 3. 🔓 **`InpNearAtr` e' la manopola piu' vergine di tutta la famiglia**

Verificato il 09/09 su tutto il repo:
- `grep -rn "InpStAtrPeriod=.*||Y" backtest_pipeline/prove/` → **0 righe**
- `grep -rn "InpNearAtr=.*||Y" backtest_pipeline/prove/` → **0 righe**
- e la **colonna `InpNearAtr` di OGNI CSV SupRev/SupertrendReversal in archivio
  vale `1`**: 40+ file, XAUUSD · NASUSD · D30EUR · U30USD · 225JPY · F40EUR ·
  E50EUR · 100GBP · USOIL · UKOIL · XAGUSD e tutti i cross. **Nessuna eccezione,
  su nessun simbolo, su nessun TF.**

👉 **Non e' una casella provata. E' una casella LIBERA.** Esattamente il
giacimento del censimento del 09/09.

📌 `InpStMult` invece **e' stato asse 8 volte** (R18, R21, R22, R3_STREV_XAUUSD_H3,
R3_SupRev_NAS_H1, R3_Multi_Ott_XAUUSD, R3_SuperWave_DOW_H1,
ABTG_PivotSupertrendReversal) — **7 su 8 col passo 0,5**, e
`R3_STREV_XAUUSD_H3.txt` usa **esattamente `2.5||0.5||4.5`**, la mia identica
griglia. Ma **mai su questo motore**, e **mai con split IS/OOS su U30USD**.

---

## 📐 LA GRIGLIA PROPOSTA — R123, tre sezioni + un cancello

**Finestra** (la stessa del 08/08, **ricavata col conto, non ricordata**):
`walkforward_generico.ps1` r.661 fa `Meta = Inizio + floor(giorni × FrazioneIS)`.
Da `2024.09.26` a `2026.06.30` sono **642 giorni**, `floor(642 × 0,40) = 256` →
**Meta = 2025.06.09**.

> **IS `2024.09.26 → 2025.06.09`** (8,5 mesi) · **OOS `2025.06.10 → 2026.06.30`** (12,7 mesi)
> Coincide alla riga con `risultati_archivio/REFERTO_WEEKEND_FASE0.md` r.7. ✅

**Modello**: **4 — TICK REALI**, come il round del 08/08. Non e' screening.
**Deposito** 10000 · **rischio** 1,0% · **L+S** · `InpTP_RR` 3,0 · `InpTF` = 16385 (H1) pinnato.

| file | asse | celle | valori | pinnati | magic |
|---|---|---:|---|---|---|
| `R123a_U30USD_00_gate` | **`InpMagic`** *(tecnico)* | 2 | 784100 / 784150 | tutto alla cella viva | — |
| `R123b_U30USD_01_stmult` | `InpStMult` | 5 | **2,5 · 3,0 · 3,5 · 4,0 · 4,5** | AtrP 9 · NearAtr 1,0 | 784110 |
| `R123c_U30USD_02_atrperiod` | `InpStAtrPeriod` | 7 | **6 · 7 · 8 · 9 · 10 · 11 · 12** | StMult 3,5 · NearAtr 1,0 | 784120 |
| `R123d_U30USD_03_nearatr` | `InpNearAtr` | 5 | **0,50 · 0,75 · 1,00 · 1,25 · 1,50** | StMult 3,5 · AtrP 9 | 784130 |

**Tutti i magic verificati VERGINI repo-wide il 09/09** (`grep -rl` su tutto il
repo, `.git` escluso → **0 file** per ciascuno). Non si riusa il `970916` della
sedia spenta: un CSV di R123 non deve poter essere riletto al posto di uno del 08/08.

### 📏 Perche' QUESTI passi — e non sono di gusto

**`InpStMult`, passo 0,5.** E' la semilarghezza della banda in ATR
(`mq5` r.373). Tocca tre cose insieme: quanto spesso la linea gira, quanto spesso
una candela la tocca (r.201-213) e dove finisce lo stop (r.245-248).
**Che 0,5 morda e' MISURATO**: ad AtrP 9 le operazioni sul periodo intero vanno
da **444 (2,5) → 349 (3,0) → 273 (3,5)**, cioe' **−22% di campione per passo**.
0,25 sarebbe il 7% della banda (rischio manopola inerte); 1,0 salterebbe i vicini
immediati, che sono proprio l'oggetto della domanda.
**Range 2,5-4,5, centrato esatto su 3,5**: in basso copre **tutto** il ventaglio
che la famiglia usa in campo (CAC H4 2,5 · DAX H4 3,0 · NAS H1 3,0 · DAX H1 3,5 ·
DOW H4 3,5 — `REGISTRO_TEST.md` r.168-170 e 402-404). **La cella viva sta al
bordo ALTO di quel ventaglio**, e sopra non ha mai misurato nessuno.

**`InpStAtrPeriod`, passo 1 — e qui il disegno e' cambiato per un fatto.**
La prima idea era `5/7/9/11/13` (passo 2). **Scartata**: avrebbe **saltato 8 e
10**, cioe' le due celle che l'archivio ha gia' misurato e che decidono la
domanda. Con `−0,49 di PF a tick per un passo`, il passo **deve** essere 1.
⚠️ **E' una manopola a DOPPIO EFFETTO, e va detto**: l'handle `hAtr` (r.133) e'
lo stesso che alimenta le bande (r.373), il filtro `closeNear` (r.206) e la
confluenza EMA (r.222). **Un crollo su questo asse non dice quale dei tre
effetti l'ha causato.** Nessun problema di dati a 6: `mq5` r.359 chiede
`InpStAtrPeriod + count + 220` = 231 barre.

**`InpNearAtr`, passo 0,25.** E' la tolleranza del *"chiude vicino"*
(r.206/213): filtro **puro sull'ingresso**, non tocca stop, target ne' uscita.
0,25 e' anche una scelta **aritmetica**: 0,25 e 0,5 sono esatti in binario e
`(1,5−0,5)/0,25 = 4` senza residuo. **Con passo 0,3 il conto delle celle
dipenderebbe dall'ultima cifra di un float** — e un round che perde una cella per
un arrotondamento e' un round buttato (classe gia' vista con i pin di stringa vuota).

---

## 🔮 L'ATTESA DICHIARATA, **prima dei numeri** — e **derivata**, non inventata

**La catena, in due passi, con le fonti.**

**Passo 1 — correzione OHLC → TICK.** L'archivio ha **8 celle misurate in
entrambi i modi**, stesso simbolo/TF/finestra. L'OHLC sovrastima il PF di:

| cella | bias | cella | bias |
|---|---:|---|---:|
| 3,0/9/3,0 | +0,055 | 3,0/10/3,0 | +0,157 |
| 3,5/9/3,0 | +0,139 | 3,5/10/3,0 | +0,073 |
| 3,0/9/2,5 | +0,054 | 3,0/10/2,5 | +0,145 |
| 3,5/9/2,5 | +0,137 | 3,5/10/2,5 | +0,080 |

**Banda misurata: da +0,054 a +0,157 · mediana +0,106 · su 8 coppie.**

**Passo 2 — rapporto OOS / periodo intero.** Sulla cella viva, a tick:
`1,43648 / 1,19515 = **1,202**`.
⚠️ **E' misurato su UNA cella sola. E' l'anello debole della catena, e lo dico.**

### 📊 La previsione, cella per cella

| asse | cella | fonte | **PF OOS atteso** | **n OOS atteso** |
|---|---|---|---:|---:|
| StMult | 2,5 | OHLC 1,084 → tick ~0,98 | **~1,18** [1,11–1,24] | ~252 |
| StMult | 3,0 | **tick MISURATO 1,040** | **~1,25** | ~198 |
| StMult | **3,5** | **MISURATO** | **1,436** | **155** |
| StMult | 4,0 | [NON MISURATO] | [NON MISURATO] | ~121 🔻 |
| StMult | 4,5 | [NON MISURATO] | [NON MISURATO] | ~94 🔻 |
| AtrP | 6 / 7 | [NON MISURATO] | [NON MISURATO] | ~230 / ~200 |
| AtrP | 8 | OHLC 1,015 → tick ~0,91 | **~1,09** [1,03–1,16] | ~181 |
| AtrP | **9** | **MISURATO** | **1,436** | **155** |
| AtrP | 10 | **tick MISURATO 0,706** | **~0,85** | ~141 🔻 |
| AtrP | 11 / 12 | [NON MISURATO] | [NON MISURATO] | ~132 / ~125 🔻 |
| NearAtr | 1,25 / 1,50 | ragionamento sul codice | **possibile CLONE di 1,0** | 155–175 |
| NearAtr | 0,75 | ragionamento sul codice | 1,20–1,70 | 110–145 🔻 |
| NearAtr | 0,50 | ragionamento sul codice | 1,10–2,00 (banda larga) | 70–115 🔻 |

*(gli `n` attesi escono dalla proporzione fra le due finestre misurata sulla
cella viva — `118/273 = 0,432` in IS e `155/273 = 0,568` in OOS — e dal
decadimento del campione col moltiplicatore misurato in archivio, ~×0,78 ogni +0,5.
🔻 = atteso **sotto le 150 operazioni**.)*

**DD atteso**: 3-8% dove il PF sta sopra 1,10 · 6-14% dove crolla (a periodo
intero e a tick il DD sulle 8 celle misurate va da **9,09% a 13,30%**).
Riferimento della cella viva: **DD IS 6,30% · DD OOS 4,82%**.

### 🎲 **E ADESSO LA PREVISIONE SCOMODA, scritta prima**

> 🔴 **MI ASPETTO CHE IL ROUND DICA "PICCO", NON "ALTOPIANO".**
> Piatto lungo `InpStMult` (2,5 · 3,0 · 3,5 tutte sopra 1,20 con n > 150),
> **a lama di coltello lungo `InpStAtrPeriod`** (8 a ~1,09 e 10 a ~0,85).
> **Una CRESTA non e' un altopiano** — ed e' precisamente cio' che la regola di
> casa chiama rumore.

**E dico anche cosa mi farebbe cambiare idea, col numero**: se `AtrP 8` torna
**≥ 1,20 con n ≥ 150** *e* `AtrP 10` torna **≥ 1,20**. Perche' succeda, `AtrP 10`
deve avere un rapporto OOS/periodo-intero di **1,70** (`0,706 × 1,70 = 1,20`)
contro l'**1,202** misurato sulla cella viva. **Possibile**: vorrebbe dire che
tutto il rosso di `AtrP 10` sta nell'IS, cioe' che il problema e' **la finestra e
non il parametro** — che e' *esattamente la tesi che ha riaperto questo
candidato*. Se succede, e' **la scoperta del round**, non una sorpresa
imbarazzante. 😄

---

## 🧊 LE SOGLIE, **congelate ORA** (nei file prova, non a voce)

**La proposta ricevuta era**: *altopiano = ≥3 celle contigue con PF OOS ≥ 1,20 e
n ≥ 150 ciascuna.* **L'ho tenuta come nucleo (A1) e l'ho emendata in 7 punti**,
perche' cosi' com'era aveva due buchi: (a) con gli `n` previsti, su `StMult` la
sola terna possibile e' `{2,5 · 3,0 · 3,5}` — **tutta da un lato solo**, e una
terna sul bordo del campione e' quello che *sembra* un picco; (b) non diceva
niente sulle celle **clone**, che sono il modo piu' comune di credere di aver
misurato un altopiano.

| # | soglia | numero |
|---|---|---|
| **A1** | **ALTOPIANO** (merito) | ≥ **3 celle CONTIGUE** sullo stesso asse con, **ciascuna**, `PF OOS ≥ 1,20` **e** `n OOS ≥ 150` **e** `DD OOS ≤ 10,0%`, **e la cella viva dentro la terna** |
| **A2** | **il pavimento dei 150 e' ASIMMETRICO, apposta** | una cella con `n OOS < 150` **non puo' MAI contare a FAVORE** (merito sospeso, Emendamento A) ma **puo' contare CONTRO** come **pendenza** della superficie: una pendenza non ha bisogno di 150 operazioni per essere una pendenza. 👉 **Puo' negare un altopiano, non puo' fabbricarne uno** |
| **A3** | **anti-altopiano-finto** | 2 celle contigue con `n` identico e `PF` identico alla **4ª cifra** = **UNA cella misurata due volte**. Non contano. *(Il censimento del 09/09: **874 CSV su 1.960** con passate a esito identico.)* |
| **A4** | **PICCO** | cella viva `≥ 1,20` **e** entrambe le vicine dello stesso asse `< 1,05` → quell'asse dichiara PICCO, **e un solo asse a PICCO annulla il verdetto di altopiano dell'INTERO round** |
| **A5** | **asse inerte** | se tutte le celle di un asse cadono sotto A3, l'asse **esce dal denominatore** e si scrive *"manopola inerte, MISURATA"* — che e' un risultato, non un fallimento |
| **A6** | **verdetto di round** | "altopiano" solo se A1 passa sulla **maggioranza degli assi che si sono MOSSI** e **nessuno** ha dichiarato PICCO. Altrimenti: **"non c'e' una configurazione robusta"**, e si scrive cosi' |
| **A7** | **RISCHIO, a qualunque n** (Emendamento B) | `DD > 10,0%` in una qualsiasi delle due finestre → cella segnalata e **fuori dall'altopiano**, anche col PF bello |
| **A8** | **la scoperta che varrebbe piu' del round** | se una cella **diversa** dalla viva fa `PF IS ≥ 1,10` **e** `PF OOS ≥ 1,20` **e** `n ≥ 150` in **entrambe** le finestre → l'11/08 la sedia e' stata spenta su una **CELLA** sbagliata, non su un **MOTORE** sbagliato. **Va riportato in grassetto — e NON promuove niente**, perche' sarebbe una cella scelta guardando anche l'OOS |

### 📐 **REGOLA DI SELEZIONE, dichiarata INSIEME al numero**
> **Centro dell'altopiano, MAI il picco.** Se il centro coincide con `3,5 / 9 /
> 1,0`, la cella viva e' **confermata** e non si tocca niente. Se il centro e'
> **un'altra** cella, si scrive e si dichiara, e quella cella va a una prova
> **nuova fuori campione**: non entra in campo da qui.
> *(In R70 i confronti fatti col picco si sono **ribaltati** quando sono stati
> rifatti con questa regola.)*

### 🛡️ Le DUE sentinelle, e non sono la stessa cosa

| | cosa | bloccante? |
|---|---|---|
| **S1** | **DETERMINISMO — cancello G1.** Le due celle gemelle `784100`/`784150` devono dare numeri **identici a 1 centesimo** di Profit *(precedente: G1 passato **949/949**, `MANOPOLE_INERTI_2026-09-09.md` r.40)* | ✅ **SI'.** Se fallisce, il problema e' **la macchina** e non si legge nient'altro |
| **S2** | **CONTINUITA' col 08/08.** `n IS 118 · PF IS 0,92343 · n OOS 155 · PF OOS 1,43648` | ❌ **NO** — per i tre commit di §1. Se fallisce, il round si legge lo stesso (tutte le celle girano sullo **stesso** binario) ma **il referto deve aprire dicendo che il `1,43648` agli atti non e' piu' il numero di questo motore** |

📌 **Su S2, attesa direzionale**: il fix del 08/09 puo' solo **togliere** pendenti,
non aggiungerne → mi aspetto `n IS 100-118` e `n OOS 132-155`. **Un `n` piu' ALTO
di 118/155 e' un segnale che e' cambiato qualcos'altro, e va indagato.**
Il **PF** e' quasi invariante a un riscalamento uniforme del lotto (attesa ±0,08);
**Profit e DD% no** — sono le grandezze che un cambio di sizing riscala, e **non
ho un'attesa stretta su di loro, quindi non la invento**.

---

## 💰 IL COSTO IN TEMPO MACCHINA — e l'analogia, dichiarata

**Analogia**: `backtest_pipeline/risultati_archivio/r88_csv/REFERTO_R88.txt`.
E' **il round piu' vicino che abbiamo**: **stesso simbolo `U30USD`**, **stessa
data d'inizio `2024.09.26`**, **tick reali**, stesso driver.
Punti misurati: `4 celle → 1,3 / 1,2 / 1,1 min` · `8 celle → 2,1 min` ·
`48 celle → 8,0 min`. Regressione lineare su quei 5 punti:

> **tempo ≈ 0,65 + 0,154 × celle** (minuti)

| round | file | celle | passate | **stima** |
|---|---|---:|---:|---:|
| **R123** | 4 file | **19** | **38** | **≈ 5,5 min** |
| R124 | 1 file | 4 | 8 | ≈ 1,3 min |
| *(gia' in cartella)* | A1_01 + A1_02 | 4 | 8 | ≈ 1,9 min |
| | **TOTALE** | **27** | **54** | **≈ 8,7 min** |

⚠️ **Il limite dell'analogia, detto**: R88a girava `ABTG_ORB_Ottimizzato`, che fa
~1 trade/giorno; SupRev su H1 arriva a **~450 operazioni** sulle celle a StMult
basso, quindi piu' lavoro di gestione ordini. Il replay dei tick e' identico e
domina, ma **applico un fattore di sicurezza 3× e aggiungo l'avvio + la
compilazione**: 👉 **stima onesta R123 = 10-25 minuti · tutto insieme = sotto i
40 minuti.**

> 😄 **Tradotto: il round che decide il candidato piu' prezioso che abbiamo costa
> meno di una pausa caffe'.** Non e' una ragione per lanciarlo — ma e' una
> ragione molto forte per non rimandarlo.

---

## ➕ LA COSA IN PIU' — `InpTrailOnST` / `InpExitOnFlip` / `InpFirstFraction`

**Risposta secca: NO, non nello stesso round. E per due di loro il lavoro e' gia' fatto.**

**Perche' non nello stesso round** — non e' il costo (1,3 min): e' che R123
chiede *"la cella viva sta al centro di un altopiano?"*, e per rispondere **tutto
cio' che non e' l'asse deve restare alla configurazione d'archivio**, altrimenti
S2 perde il riferimento e il confronto col `1,43648` muore. Mescolarle le
renderebbe illeggibili entrambe.

**Lo stato reale, censito oggi:**

| manopola | su QUESTO motore | dove sta |
|---|---|---|
| `InpTrailOnST` | ✅ **file gia' pronto e validato** | `prove/A1_SUPREV_DOW_H1_01_trailonst.txt` (magic 970960) |
| `InpExitOnFlip` | ✅ **file gia' pronto e validato** | `prove/A1_SUPREV_DOW_H1_02_exitonflip.txt` (magic 970961) |
| `InpFirstFraction` | 🔴 **buco vero** → **l'ho scritto** | `prove/R124a_U30USD_04_firstfraction.txt` (magic 784140) |

🔎 **E il buco non era ovvio.** Il round R120 mette ad asse le uscite Supertrend
su **quattro** motori — `SupRev_NAS_H1`, `SuperWave_DOW_H1`,
`SupertrendReversal_Multi`, `SupRev_DAX_H4` — e
**`ABTG_SupRev_DOW_H1_Ottimizzato` NON C'E'**. Il **R121** proposto in
`report/ROUND_USCITE_SUPERTREND_2026-09-09.md` §9 mette `InpFirstFraction` su
NASUSD e sul SuperWave DOW: **di nuovo, non su questo motore.**
👉 *(nota di coordinamento: R121 e R122 sono gia' prenotati da quel dossier —
per questo il round dell'altopiano e' **R123** e quello della frazione **R124**.)*

**R124a, asse**: `0,3333` (il default, e la sentinella) · `0,5333` · `0,7333` ·
`0,9333`. **Buco dichiarato e voluto**: l'asse **non e' centrato** e sotto 0,3333
non misura niente — perche' la domanda qui non e' *"esiste un altopiano attorno a
1/3"* ma **"la gamba pendente serve?"**, e quella si risponde andando verso 1.
Un asse centrato richiederebbe valori sotto 0,13, dove la tranche a mercato
finisce sotto il lotto minimo e **si misurerebbe il pavimento, non il parametro**.

---

## 🕳️ I BUCHI DICHIARATI DI R123 — quello che questo round **NON** dira'

1. 🔴 **LA SUPERFICIE COMPLETA.** Tre file = **tre sezioni ortogonali** passanti
   per il punto vivo. **Zero celle diagonali.** E le diagonali contano: nel
   censimento OHLC, `3,5/10` fa **0,779** mentre `3,0/10` fa **1,238** — il
   comportamento sull'asse AtrP **cambia segno** a seconda dello StMult.
   **Tre tagli non sono una mappa.** *(Una griglia piena 5×7 costerebbe 35 celle
   = ~6 min, ma violerebbe "una variabile per file prova".)*
2. 🔴 **PROVA DI REGIME: assente.** 21 mesi di tick BCM sugli indici = **un solo
   toro**. Emendamento della Finestra regola **C non soddisfatta**, e non lo sara'
   alla fine del round. 👉 **Niente di quello che esce di qui e' promuovibile.**
3. 🔴 **PEGGIOR GIORNATA: [NON MISURATO] e non producibile.** L'EA non scrive un
   CSV riga-per-operazione: la colonna non esiste nel CSV di ottimizzazione MT5.
   Restera' `[NON MISURATO]` **anche dopo** la corsa. *(Con DD 6,30%/4,82% il
   muro prop giornaliero del 5% resta dentro il cono del possibile — ma dentro il
   cono non vuol dire misurato.)*
4. 🔴 **LATO SHORT DA SOLO: [NON MISURATO].** Qui gira L+S come la sedia viva.
   La **regola dei due lati del 25/08** chiede il lato separato: e' un round suo.
5. 🔴 **TAGLIA:** si gira a **1,0%**, non a 0,65%. Scelta consapevole — a 0,65%
   S2 perderebbe il riferimento d'archivio. Domanda separata, file separato.
6. 🔴 **`InpTP_RR` con split: mai fatto su questo motore.** L'archivio lo ha
   girato (2,0/2,5/3,0) ma **solo a periodo intero**. Non e' in R123: sarebbe un
   quarto asse.
7. ⚪ **Guardian**: `InpUsaGuardian=true` e' il default, ma nel tester le sue
   GlobalVariable non esistono e la guardia **lascia passare tutto** (fail-open
   dichiarato nel sorgente, r.34-42). I numeri restano confrontabili col 08/08.
8. ⚪ **`InpNewsCurrencies` non pinnato di proposito**: il pin di una stringa a
   valore **vuoto** viene **ignorato** da MT5 (classe FiboH4,
   `controlla_prova.py` controllo 3). Il default compilato e' gia' la stringa
   vuota che serve.

---

## 🙋 LE DUE DOMANDE PER CLAUDIO

1. **Vuoi che R124a giri insieme a R123**, o dopo? Costa 1,3 minuti e chiude la
   terza manopola mai messa ad asse **su questo motore specifico**. Il mio
   consiglio: **insieme**, sono file separati e non si contaminano.
2. **La soglia A1 la vuoi a 1,20 o a 1,10?** Ho scelto **1,20** e l'ho motivata
   (1,10 e' il cancello di *ammissione* di un candidato; qui la domanda e' se il
   **1,436 REGGE**, e una cella che scivola a 1,12 accanto a una che fa 1,44
   descrive **una discesa**, non un piano). **Ma e' una soglia, e le soglie si
   cambiano PRIMA dei numeri, non dopo.** Se la vuoi a 1,10, si cambia adesso —
   fra dieci minuti non piu'.

---

## ✅ STATO DELLA CONSEGNA

**Cinque file prova, tutti PASS, tutti ASCII PURO:**

```
=== CONTROLLO FILE PROVA ===
  R123a_U30USD_00_gate.txt          pin=41 celle=2  OK
  R123b_U30USD_01_stmult.txt        pin=41 celle=5  OK
  R123c_U30USD_02_atrperiod.txt     pin=41 celle=7  OK
  R123d_U30USD_03_nearatr.txt       pin=41 celle=5  OK
  R124a_U30USD_04_firstfraction.txt pin=41 celle=4  OK
file: 5 | celle totali: 23 | passate: 46 | problemi: 0
ESITO: OK
```
`LC_ALL=C grep -c '[^ -~\t]'` → **0 byte non-ASCII** su tutti e cinque.

🚦 **Manca il PASS dell'agente `controllo-preventivo`** e la **riga di lancio**
(che non ho scritto: non e' compito mio e va comunque per il doppio cancello).
**Niente esce verso il VPS finche' quel PASS non e' tornato.**

🚫 **Non ho eseguito nessun backtest** (MT5 gira sul VPS) · **non ho toccato EA,
preset o forward** · **non ho committato** · **non ho promosso niente**.

---

> 💪 **Il punto in una riga.** Non stiamo allargando la griglia su un motore
> morto — sarebbe la trappola del 19/08. Stiamo **chiudendo una domanda aperta su
> una cella che ha `PF 1,44` e `DD 4,8%` su 155 operazioni fuori campione**, e la
> stiamo chiudendo **in tutti e due i sensi possibili**: se i vicini reggono, una
> sedia torna in gioco con una ragione; se sporge da sola, lo scriviamo e non ci
> bruciamo la challenge con una cella verde per caso. 🏔️
> **In 10 minuti di macchina. Non ci accontentiamo, ma non ci illudiamo.**
