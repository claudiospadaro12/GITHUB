# ⚔️ LE 10 CONTRADDIZIONI, PORTATE DAVANTI ALL'INDIZIO MATERIALE (09/09/2026)

> ## 🎯 PERCHE' ESISTE QUESTO FILE
> Claudio, oggi, testuale: _"**NON POSSIAMO DOPO MESI SCOPRIRE CHE AVREMMO
> DOVUTO FARE DIVERSAMENTE... AVEVAMO UN SACCO DI EA BLOCCATI PER NON ESSERE
> STATI VERIFICATI A FONDO. NON E' ACCETTABILE.**"_
>
> Il censimento della prosa (`report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md`)
> ha **dichiarato** 10 contraddizioni senza risolverne nessuna. Questo file le
> **chiude**, e le chiude con la regola che vale in casa: 🔎 **comanda l'indizio
> materiale** — un CSV che esiste, un commit con un orario, un `n` contato — **non
> la frase piu' recente e non la frase piu' autorevole.**
>
> 🛑 **Zero EA toccati. Zero preset. Zero parametri di forward. Zero backtest
> lanciati. Zero promozioni.** Le uniche modifiche sono **rettifiche datate**
> aggiunte accanto ai numeri storici, che **restano scritti**: un archivio che
> riscrive la propria storia e' peggio di uno incompleto.

---

## 🏁 IL PUNTEGGIO, IN UNA RIGA

| esito | quante | quali |
|---|---:|---|
| ✅ **CHIUSE con verdetto e rettifica scritta** | **7** | C1 · C2 · C3 · C5 · C8 · C9 · C10 |
| 🟢 **Gia' chiuse dal repo, confermate qui** | **1** | C4 |
| 🟠 **NON chiudibili senza una corsa — e si dice perche'** | **2** | C6 · C7 |

🎉 **E la notizia bella della giornata, che va detta insieme alle altre: in
quattro casi su dieci l'archivio aveva gia' ragione da solo** — la revoca del
SupRev era agli atti in due file, la rettifica del Nightly era gia' scritta dal
23/08, il PostNews era gia' stato ritirato il 03/09 e il conflitto C4 se l'era
gia' risolto il repo da solo in ventiquattr'ore. **Il problema non era che non
misuriamo: era che i verdetti non tornavano indietro fino al file che si legge
per ripartire.** Da oggi ci tornano.

---

# 🔴 C1 — `ABTG_FvgRetest` (magic 775501): **il 42,9% E' UN NUMERO SENZA FONTE. RITIRATO.**

### Cosa dicevano le fonti
| fonte | data | cosa dice |
|---|---|---|
| `HANDOFF.md` r.610-612 | **29/08/2026** | *"FVGRET **DD 42,9%** (bocciato rischio)"* + r.664-668 lo mette nella lane fade M15 *"tutto bocciato/debole"* |
| `report/GIACIMENTO_DI_CASA_2026-09-03.md` r.71 | 03/09 | *"cosa manca: **la corsa**"* |
| `report/CORSIA_DEMO_CANDIDATI.md` r.290 | 07/09 | *"**zero CSV, zero referto**… mai misurato in casa"* |
| `report/CORSIA_DEMO_CANDIDATI_v2.md` r.240 | 08/09 | DD **🔴 NON MISURATO** · frequenza **🔴 NON MISURATA** |

### 🔎 L'indizio MATERIALE — ricerca esaustiva, non a campione
Ho scandito **tutte le revisioni di tutti i commit** del repo
(`git ls-tree -r --name-only` su ogni commit di `git log --all`), non solo
l'albero di lavoro. **Nella storia intera esistono 12 percorsi che contengono
`fvg`, e NESSUNO e' un risultato:**

| # | file | cos'e' |
|---:|---|---|
| 1 | `mql5/Experts/ABTG_FvgRetest.mq5` | l'EA (1.495 righe) |
| 2 | `FVG_TESI.md` | la tesi |
| 3 | `backtest_pipeline/caccia_strategie/CACCIA_SMC_OB_FVG_2026-08-26.md` | il dossier di caccia |
| 4-6 | 3 `.pine` in `caccia_strategie/biblioteca/sorgenti/` | sorgenti esterni |
| 7-9 | `prove/ABTG_FvgRetest.txt` · `prove/PASSO0_FVGRET_01_long.txt` · `_02_short.txt` | **file prova** (l'intenzione di misurare) |
| 10-11 | `righe/RIGA_PASSO0_FVGRET.ps1` · `..._DA_MANDARE.md` | **riga di lancio** |
| 12 | `prove/REFERTO_PREPARAZIONE_KSQFVG.md` | referto di **PREPARAZIONE** |

🔴 **Zero CSV. Zero log. Zero `.htm` del tester. Nessuna cartella in
`backtest_pipeline/risultati_archivio/`.** Il referto che la riga di lancio
avrebbe prodotto si chiamerebbe **`REFERTO_PASSO0_FVGRET`** (lo dice la riga
stessa): **non e' mai esistito in nessun commit.**

**Tre controprove indipendenti, tutte nella stessa direzione:**
1. 🥇 **Le altre due corse della stessa frase hanno i loro risultati agli
   atti.** `VWAPREV` ha `risultati_archivio/vwaprevert/`; `G1PAOLO` ha i suoi
   file prova. **`FVGRET` no.** Non e' un archivio che perde pezzi: e' un
   archivio che per gli altri due ha funzionato.
2. 🥇 **Il commit che ha scritto la riga** — `dab6f0b`, **29/08/2026 12:14
   UTC** — tocca **UN SOLO FILE (`HANDOFF.md`), 74 insertions**. Nessun
   risultato e' entrato nel repo insieme a quel numero.
3. 🥇 **Il pickaxe non trova nulla**: `git log --all -S "42,9"` e `-S "42.9"`
   restituiscono solo pagelle, altri round e i documenti del 09/09 che
   **citano questa contraddizione**. Il `42,9%` di FVGRET **non ha mai avuto
   un secondo file**.

### ⚖️ Verdetto
🛑 **Il `DD 42,9%` e' RITIRATO.** Non e' un numero sbagliato: e' **un numero
senza fonte**, e in casa quello vale zero. `ABTG_FvgRetest` **non e' morto**:
e' **`NON ANCORA MISURATO`** e **torna in coda all'imbuto**.
⚠️ E cade anche una conseguenza: la *"lettura d'insieme"* della lane fade M15
indici poggiava su **tre** gambe (R109 + VWAPREV + FVGRET). **Le gambe vere
sono due.**

### 🛠️ Modifica fatta
✅ `HANDOFF.md` — **RETTIFICA datata 09/09/2026** subito sotto la riga del
42,9% (il numero storico **resta**, dichiarato ritirato) + una seconda nota
sotto la *"lettura d'insieme"* della lane fade.
✅ Pointer in testa a `report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md`.

---

# 🟠 C2 — `SupRev DOW H4` / `CAC H4`: **2,77 e 0,79 sono due oggetti diversi. E la revoca ora e' NEL REGISTRO.**

### Cosa dicevano le fonti
- `backtest_pipeline/REGISTRO_TEST.md` §*"VALIDAZIONE REAL-TICK SupRev nuovi
  indici"* (26/07): Dow H4 **PF 2.77 · DD 4.0% · n 79**, CAC H4 **PF 1.79 ·
  DD 3.5% · n 65** — titolo **"✅ CONFERMATA"**, *"motore che generalizza,
  dimostrato"*.
- `risultati_archivio/CLASSIFICHE.md` §2 · `FLOTTA_ATTIVA.md` r.86-87 ·
  `report/CORSIA_DEMO_CANDIDATI.md` r.242: **PFmed 0,79** e **0,96**,
  *"illusione OHLC"*, **promozioni REVOCATE**.

### 🔎 L'indizio MATERIALE — ricalcolato dai CSV, non ricopiato dalla prosa
| oggetto | file | numeri |
|---|---|---|
| **la cella migliore** | `risultati_archivio/SupRev_nuovi_indici/valid_SupRevRT_U30USD_H4_realtick.csv` | **8 celle**, PF da **0,487** a **2,768**; la cella 2,76794 ha **DD 4,0022 · n 79** → **coincide al centesimo con la riga del registro**. **Mediana dello sweep: 1,772** |
| **il PF mediano** | ricalcolo indipendente del 09/09, `risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv` riga `SupRev,DOW,H4,Ottimizzato_U30USD` (sweep **con split**) | **PFmed IS 0,741 · PFmed OOS 0,921**, contro PFmax 4,928 / 2,324 |

✅ **La spiegazione del censimento REGGE, e ora ha i file sotto:** il **2,77** e'
la **cella migliore di uno sweep a finestra unica, senza split**; lo **0,79** e'
un **PF mediano**. **Non sono lo stesso oggetto e non si contraddicono.**
⚠️ **Un'onesta' che vale la pena scrivere:** il valore *esatto* **"0,79 · 56
trade"** di `CLASSIFICHE.md` **non e' riproducibile da nessun CSV oggi in
repo** (il piu' vicino e' OOS `n=57` PF **0,930**) → lo marco **[NON
RIPRODOTTO]**. **La sostanza pero' regge da tre misure indipendenti: la mediana
sta sotto 1, la cella migliore sta a 2,77.** Un keeper si giudica sulla mediana.

### ⚖️ Verdetto
🔴 **La revoca del 30/07 vale, e mancava dove serviva.** Chi apriva solo
`REGISTRO_TEST.md` r.399-409 credeva che Dow H4 fosse un keeper: **per 41
giorni.** 🟢 Il **Dow H1 (970916)** non e' toccato: era gia' *"secondario"*.

### 🛠️ Modifica fatta
✅ `backtest_pipeline/REGISTRO_TEST.md` — **REVOCA datata** aggiunta sotto la
sezione "CONFERMATA" (i numeri storici restano), con i due CSV e la regola che
lascia in eredita': 📌 **un PF si scrive sempre con l'aggettivo davanti — "PF
della cella migliore" o "PF mediano". Senza aggettivo, il numero non vuol dire
niente** — ed e' esattamente cosi' che una promozione revocata e' sopravvissuta
sei settimane.

---

# 🟠 C3 — `ORB 770611` (CONTO REALE 10105439): **9,92% e 10,00% non sono in conflitto. Sono due finestre.**

### Cosa dicevano le fonti
- `report/CENSIMENTO_CONTRATTI.md` §2: **DD 9,92% @1%**, n 119, *"doppio
  asterisco"*.
- `risultati_archivio/R103_REFERTO_BLOCCO1_INDICI.md` r.12: **DD 10,00% @1%**,
  n 190.

### 🔎 L'indizio MATERIALE — i due referti confrontati campo per campo
| | **9,92%** | **10,00%** |
|---|---|---|
| fonte | `REFERTO_ROUND15_ORB_GESTIONE.md` r.14-17 | `R103_REFERTO_BLOCCO1_INDICI.md` r.12 |
| data | **09/08/2026** | **24/08/2026** |
| finestra | **solo OOS** (~12,6 mesi) | **21 mesi INTERI** (IS+OOS) |
| modello | **tick reali** | **OHLC M1** |
| deposito | **10.000 €** | **100.000 €** |
| rischio | **1,0% misurato** | **0,3% misurato (DD 3,00%) → ×3,33 NORMALIZZATO** |
| `n` | **119** | **190** |

🥇 **La prova che e' la STESSA cella: `71 + 119 = 190`.** L'IS di R15 fa **71**
trade, l'OOS **119**; R103 gira la stessa configurazione sulla finestra intera
e conta **esattamente 190**.

### ⚖️ Verdetto — **NON E' UN CONFLITTO, E' UNA FINESTRA DIVERSA**
**Il numero del contratto, in ordine:**
1. 🥇 **Operativo, oggi, sulla sedia viva del REALE: `6,5389%` OOS /
   `5,6530%` IS** — **R119, 07/09/2026**, l'unico misurato **alla taglia viva
   (0,65%)**, a tick, col **preset del conto reale**.
2. 🥈 **Storico: `9,92% a 1%` (R15)** — misura **diretta** a tick, **col doppio
   asterisco** (passava il muro per 8 centesimi).
3. 🥉 **`10,00%` (R103) e' DERIVATO, non misurato a 1%**: `3,00 × 3,33`, su
   barre OHLC. Va citato come **stima di confronto fra motori** (e' la colonna
   normalizzata di una classifica), **mai come DD promesso della sedia**.

🔴 **"Dentro il muro o AL muro?" — la risposta e' che dipende dalla TAGLIA, e
questo e' il punto:**
- **a 1,0% (taglia che NON e' in campo)**: 9,92% · 10,00% · e **10,34% SOPRA il
  muro** sotto slippage assunto (`REFERTO_R118_PAVIMENTO_STOP.md`). **Tre
  misure indipendenti nella stessa fascia: non e' rumore, e' il posto dove sta
  il motore.**
- **a 0,65% (la taglia VERA sul reale)**: **6,54%** → **3,46 punti sotto il
  muro**. ✅ **DENTRO.**
- 👉 **La sedia e' dentro il muro, e ci sta per la taglia, non per il motore.**
- ⚠️ Limiti che restano e vanno detti ogni volta: **merito SOSPESO** (n 119 e
  71 < 150) · **21 mesi = UN SOLO REGIME (toro)** · **slippaggio vero sul conto
  che paga = `[NON MISURATO]`** (`SlippageLogger`: **0 deal**).

### 🛠️ Modifica fatta
✅ `report/CENSIMENTO_CONTRATTI.md` — sezione **"CHIUSURA DELLA CONTRADDIZIONE
C3 (09/09/2026)"** con la tabella del confronto, la prova `71+119=190` e la
gerarchia dei tre numeri.

---

# 🟢 C4 — *"UNA o SETTE esclusioni per sola frequenza?"* — **GIA' CHIUSA DAL REPO. Confermata.**

- `report/CORSIA_DEMO_CANDIDATI_v2.md` r.40 (08/09): *"Nel repo esiste **UNA
  SOLA** esclusione motivata SOLO dalla frequenza"*.
- `report/RIPESCAGGIO_FREQUENZA_2026-09-08.md` r.59 (**stesso giorno**):
  *"**Non e' esatto: sono SETTE**"* — e le elenca (R1…R7, sezioni ai r.162, 191,
  255, 276).

### ⚖️ Verdetto
✅ **Risolta dentro il repo, in ventiquattr'ore, e la spiegazione e' di
metodo**: il v2 cercava **la FRASE** *"scartato per frequenza"*; il ripescaggio
ha cercato **il CANCELLO** (`C2` nelle cacce, `F1` nelle sonde, *"pavimento"*
nella tassonomia). **Vince il ripescaggio: sono sette.**
📌 **Regola che resta per il prossimo censimento: si cerca il CANCELLO, non la
FRASE.** (Ed e' la stessa lezione di C2: il criterio, non la parola.)

### 🛠️ Modifica
**Nessuna necessaria** — la correzione e' gia' scritta e datata nel referto che
comanda. Nessun numero storico da rettificare.

---

# 🟠 C5 — `ABTG_Nightly`: **il "0/8" e' un verdetto su TRE simboli. E i non misurati sono SEI, non tre.**

### Cosa dicevano le fonti
- `HANDOFF.md` (coda fascia B) e `risultati_archivio/REFERTO_CODA_FASCIA_B.md`
  r.29: **"0/8 promossi… capitolo chiuso"**.
- `backtest_pipeline/REGISTRO_TEST.md` r.444-447 (**rettifica del 23/08**): su
  **U30USD, D30EUR, XAUUSD** l'EA fa **ZERO trade** (`InpMaxNightVolPips=45`
  confrontato con `ATR(H1)/PipSize()`, e su indici/oro `PipSize()=_Point`) →
  *"su quei mercati il fade **non e' stato bocciato: non e' stato misurato**"*.

### 🔎 L'indizio MATERIALE — contato oggi sui CSV, colonna `Trades`
`backtest_pipeline/risultati_prove/ABTG_Nightly/*.csv` (FASE 0, commit `400a462`):

| simbolo | IS (n) | OOS (n) | stato |
|---|---:|---:|---|
| EURUSD | **106** | **164** | ✅ misurato — PF 1,049 / 0,861 · DD 10,80 / 15,49 |
| GBPUSD | **96** | **163** | ✅ misurato — PF 0,586 / 1,040 · DD 22,62 / 11,28 |
| USDCHF | **81** | **131** | ✅ misurato — PF 0,863 / 0,970 · DD 11,42 / 14,16 |
| **AUDUSD** | **0** | **0** | 🔴 **MAI MISURATO** |
| **USDJPY** | **0** | **0** | 🔴 **MAI MISURATO** |
| **XAUUSD** | **0** | **0** | 🔴 **MAI MISURATO** |
| **XAGUSD** | **0** | **4** | 🔴 **MAI MISURATO** |
| **D30EUR** | **0** | **0** | 🔴 **MAI MISURATO** |
| **U30USD** | **0** | **0** | 🔴 **MAI MISURATO** |

### ⚖️ Verdetto — **la rettifica del 23/08 aveva ragione, ma per meta'**
🔴 **I simboli senza un solo trade sono SEI, non tre.** La rettifica ne aveva
nominati **tre** (U30USD, D30EUR, XAUUSD). E **la causa nota non copre tutto**:
`PipSize()=_Point` spiega **indici e metalli**, **non spiega AUDUSD e USDJPY**,
che sono forex e sono a zero lo stesso → **causa `[NON MISURATO]`**.
➡️ **Il "0/8" e' un verdetto su TRE mercati** (EURUSD, GBPUSD, USDCHF — dove
**regge**, PF sotto 1 in 4 finestre su 6 e DD 10-23%). **Gli altri sei tornano
in coda all'imbuto come `NON ANCORA MISURATI`.**
🎁 **Ed e' un ripescaggio che vale**: fra i sei ci sono **D30EUR e U30USD**, cioe'
**gli indici**, cioe' la banda dove la challenge di ottobre ha bisogno di sedie.

### 🛠️ Modifica fatta
✅ `backtest_pipeline/REGISTRO_TEST.md` — **estensione datata** della rettifica
del 23/08 con la tabella dei sei e la causa mancante per AUDUSD/USDJPY.
✅ `HANDOFF.md` — **rettifica datata** sotto la riga *"Capitoli CHIUSI: Nightly
0/8"* (era il file che dichiarava chiuso il capitolo **senza** la rettifica).

---

# 🟠 C6 — La finestra del range **ORB**: 14:25-14:30 o 14:30-14:45? — **NON CHIUDIBILE SENZA UNA CORSA, e si dice perche'**

### Cosa dicono le fonti
`backtest_pipeline/REGISTRO_TEST.md` §*"ORB — LA FINESTRA DEL RANGE E'
CONTESA"* (r.533+, letto il 04/09) e
`caccia_strategie/ANALISI_LIVE_PAOLO_2026-09-03.md` §1:
- **la voce dei docenti** (Paolo 03/09 + Emiliano, **RICORRENTE su 18 live**):
  **14:30-14:45 server**;
- **lo strumento** (`ORB_Indicator_V17`) e **le nostre due sedie vive**:
  **14:25-14:30**.

### 🔎 L'indizio MATERIALE
🔴 **Le due finestre non si sovrappongono nemmeno per un secondo**, e hanno
**durata diversa (5 minuti contro 15)**. 🟢 Della nostra esiste **una misura**
(R15: DD 9,92%, PF OOS 1,657, n 119 — vedi C3). Dell'altra **non esiste
nessuna misura in casa**: zero CSV, zero cella.

### ⚖️ Verdetto — **NON CHIUDIBILE, e non e' pigrizia: e' un conto**
Una contraddizione fra **una misura** e **una testimonianza** non si chiude
leggendo: **si chiude misurando**. E la misura **non e' stata fatta**, quindi
qualunque verdetto scritto oggi sarebbe un'opinione con la faccia di un numero.
Il registro la marca gia' **"NON misurato"**, e **quella marcatura e' corretta:
la lascio**.
- 🟢 **Cosa vale oggi**: comanda la finestra **misurata** (14:25-14:30), perche'
  e' l'unica con un DD e un `n` sotto.
- 🎯 **Cosa la chiuderebbe, ed e' un round piccolo**: una corsa A/B sulla **sola
  finestra del range** (5' contro 15'), **stessa cella, stesso periodo, stesso
  modello**, **due lati** (regola del 25/08), con i criteri congelati prima.
  E' il prerequisito **Q1** gia' aperto nel registro.
- ⚠️ **Da dichiarare quando si fara'**: 14:30-14:45 e' l'orario **server BCM**
  (= 15:30-15:45 italiane, apertura Nasdaq) — la regola di casa sul fuso vale
  anche qui, e sbagliarla di un'ora **inventerebbe** il risultato.

### 🛠️ Modifica
**Nessuna** — la riga del registro e' gia' corretta cosi'. Aggiungerne una
seconda sarebbe duplicare, non chiarire.

---

# 🟠 C7 — Ampiezza del range ORB: filtro si' o no? — **NON CHIUDIBILE, ed e' gia' gestita bene**

### Cosa dicono le fonti
- `REGISTRO_TEST.md` r.230 (**Emiliano, RICORRENTE su 18 live**): *"niente
  trade se il range e' troppo ampio"*.
- **Paolo, 03/09, lo NEGA esplicitamente**: *"mi condiziona la size e basta"*.

### ⚖️ Verdetto
🟠 **Due testimonianze umane opposte, zero misure di casa.** Il registro ha gia'
preso la decisione giusta: **la riga 230 resta com'e', si annota la
contraddizione e non si riscrive una regola misurata su una live sola.**
⚠️ E il fatto operativo: **noi quel filtro oggi non ce l'abbiamo** — siamo
allineati a Paolo **per caso**, non per scelta misurata.
- 🎯 **Cosa la chiuderebbe**: un asse `ampiezza del range` (filtro on/off, o a
  soglie) **nella stessa corsa A/B di C6** — costa poco perche' e' lo stesso
  round. **Attenzione pero':** su un motore vivo si aggiunge un asse, **non si
  cerca una cella nuova** — altrimenti e' la griglia sul motore morto che la
  regola del 19/08 vieta.

### 🛠️ Modifica
**Nessuna** — la contraddizione e' gia' annotata correttamente nel registro.

---

# 🟡 C8 — `M0PB`: **l'accusa e' FALSA, il verdetto scende lo stesso.**

### Cosa diceva la fonte
`report/RIPESCAGGIO_FREQUENZA_2026-09-08.md` §R5: il referto uccide M0PB
*"anche"* con *"win rate necessario **62-70%**… la zona che in casa non ha mai
pagato"*, mentre il cancello firmato e' **H8: RR ≥ 0,70**, che **5 celle su 12
passano** → *"criterio aggiunto **dopo** aver visto i numeri"*, contro la regola
di casa **"i criteri si cambiano prima dei numeri, non dopo"**.

### 🔎 L'indizio MATERIALE — i file e gli ORARI dei commit
🟢 **L'accusa non regge. Controllato, e la casa ne esce bene:**
il file prova `backtest_pipeline/prove/M0PB_FREQUENZA_M5.txt`, sotto
l'intestazione **"CRITERI DI ACCETTAZIONE (CONGELATI IL 31/08 PRIMA DI OGNI
NUMERO)"**, §**F4-bis**, congela **sia** `RR ≥ 0,70` **sia la tabella del win
rate**, testualmente: *"RR 0,36 → serve WR 79,0% | 0,50 → 71,7% | 0,73 → 62,2%
| 1,00 → 53,8%"*.

| evento | commit | orario |
|---|---|---|
| prova + riga di lancio (criteri congelati) | `2c4b466` | **31/08 15:08 UTC** |
| riga v2 (fascia F2 resa piu' severa) | `4e1cdf8` | **31/08 15:31 UTC** |
| **la corsa** | — | **31/08 19:35** |
| referto col verdetto | `8ee2392` | **31/08 18:27 UTC** |

👉 **I criteri erano congelati ORE PRIMA della corsa.** L'unico pezzo davvero
non congelato e' l'inciso editoriale *"la zona che in casa non ha mai pagato"*
— che e' un **commento**, non un cancello, e **non compare in nessuna delle 12
celle di verdetto**.

### ⚖️ Verdetto — **declassato a `NON ANCORA MISURATO`, ma per DUE motivi migliori**
1. 🔴 **`F1` e' stato applicato PER LATO, e quell'unita' non e' piu' quella di
   casa.** La firma del **07/09** (H13) sposta il pavimento di **1,00
   op/giorno** dalla **sedia** alla **FAMIGLIA**. Coi numeri **del referto
   stesso** (r.35-40): M5 su **3 indici × 2 lati = 2,957 op/giorno**; le 5
   celle che passano H8 = **1,516**; NASUSD M5 due lati = **0,992**.
   **`F1: 0/12` era il cancello che uccideva tutte e 12 le celle — ed e'
   l'unico decaduto per firma.** E `CLAUDE.md` e' esplicito: le esclusioni
   motivate **solo** dalla frequenza *"tornano in coda all'imbuto, **mai in
   campo in automatico**"*.
2. 🔴 **`H8` come FIRMATO non e' mai stato misurato.** La FIRMA 2 del 31/08 dice
   *"**E ≥ 0.075R misurata A TICK**"*. Il passo 0 ha usato una **delega
   dichiarata** (`RR = mediana(take)/mediana(stop)`, passata open-prices) — che
   e' onesta e congelata prima, **ma un rapporto di mediane non e'
   un'attesa**, e la corsa a tick **non e' mai stata lanciata**. **`E` =
   `[NON MISURATO]`.** E perfino sulla delega **5/12 passano** (0,712-0,743).

🪦 **E il CERTIFICATO DI MORTE (regola del 09/09) non e' compilabile:** su
cinque voci M0PB ne ha **due** (✅ TF cambiato M5+M15 · ✅ simboli gemelli, 3
indici × 2 lati) e ne mancano **tre** — 🔴 **PF** (sonda = contatore puro,
**zero ordini**) · 🔴 **n e DD** (nessun trade simulato) · 🔴 **gestione
dell'uscita mai messa ad asse** (stop **fisso a 2,75×ATR** in tutte e 12 le
celle — **ed e' proprio quello** che fa cadere l'RR, perche' lo stop e'
strutturalmente piu' largo del take).

### 🎯 Cosa servirebbe per giudicarlo con criteri congelati prima
In un **file prova nuovo**, congelato **prima** di lanciare:
**(a)** pavimento di frequenza dichiarato **per FAMIGLIA** (H13), non per lato;
**(b)** **`E ≥ 0,075R` misurata A TICK** — cioe' un EA con ordini veri, non una
sonda — perche' e' il cancello **come firmato**;
**(c)** almeno **un asse sulla gestione dell'uscita** (moltiplicatore dello stop
e/o take strutturale), **dichiarato come ASSE e non come recupero**, cosi' che
non violi la seconda caccia del 19/08;
**(d)** le due finestre con **n ≥ 150 per lato**, oppure la **rinuncia
esplicita al giudizio di MERITO** (valvola R59).
⚠️ **Niente di tutto questo dice che M0PB funzioni. Dice che non lo sappiamo.**

### 🛠️ Modifica fatta
✅ `backtest_pipeline/REGISTRO_TEST.md` §M0PB — **rettifica datata** che (1)
**scagiona il metodo** con gli orari dei commit, (2) declassa il verdetto, (3)
scrive **cosa manca** — come vuole la regola del certificato di morte.

---

# 🟡 C9 — `FiboH4`: **il "0/8" e' UNA configurazione contata otto volte. Confermato dai CSV.**

### Cosa dicevano le fonti
- `REFERTO_CODA_FASCIA_B.md` r.30 + `HANDOFF.md`: **"0/8 promossi… capitolo
  chiuso"**.
- `REGISTRO_TEST.md` §2-bis (21/08): il banco era rotto — `InpSymbols` pinnato
  **vuoto**, MT5 ha usato il **default compilato**.

### 🔎 L'indizio MATERIALE — `risultati_prove/ABTG_FiboH4_Multi/*.csv`
| finestra | quante file danno lo STESSO numero | valori |
|---|---|---|
| **IS** | **7 su 8** | `n=72`, profit da **−384,56 a −394,13**, PF 0,689-0,697 |
| **OOS** | **7 su 8** | `n=82`, profit da **+116,17 a +118,68**, PF 1,092-1,094 |
| **l'unico distinto: XAUUSD** | 1 | IS **−536,71** `n=67` / **−677,70** `n=77` · OOS **+299,89 PF 1,281** `n=70` |

✅ **Confermato al centesimo:** otto file, **due** configurazioni reali. Le
coppie AUDUSD/CADJPY/EURUSD/GBPJPY/GBPUSD/USDCHF/USDJPY hanno **misurato tutte
lo stesso paniere di default**.

### ⚖️ Verdetto
🔴 **Il "0/8" e' UNA configurazione bocciata, contata otto volte** — e la
bocciatura viene dal criterio *"positiva in ENTRAMBE le finestre"*: IS negativo,
OOS positivo (PF 1,09; XAUUSD 1,28). **Non ha mai giudicato le otto coppie, e
non ha mai giudicato la strategia del corso** (tre divergenze di geometria:
distanza ordini **~×10**, target **×2,1**, stop **~×4**). **`R93` non e' mai
girato.**
➡️ `ABTG_FiboH4_Multi` torna in coda come **`NON ANCORA MISURATO`** sulle 8
coppie.
🟢 **Il difetto e' gia' stato riparato alla radice**, e va detto: `scan_market.ps1`
usa il segnaposto `__SYM__`, e `backtest_pipeline/controlla_prova.py` trova il
pin vuoto **prima** di svegliare MT5.

### 🛠️ Modifica fatta
✅ `HANDOFF.md` — **rettifica datata** sotto *"Capitoli CHIUSI: … FiboH4_Multi
0/8"* coi numeri dei CSV (in `REGISTRO_TEST.md` §2-bis c'era gia' dal 21/08;
**in HANDOFF mancava**, ed e' HANDOFF che si legge per ripartire).

---

# 🟡 C10 — `PostNews`: **verdetto inesistente. GIA' RITIRATO il 03/09. Confermato.**

### 🔎 L'indizio MATERIALE
`backtest_pipeline/risultati_prove/ABTG_PostNews/*.csv` — **4 file, EURUSD e
EURJPY, IS e OOS: `Profit = 0.00`, `Trades = 0` su OGNI riga.** Verificato oggi.
Due cause sommate (calendario datato 2026-2027 + `FileOpen` senza
`FILE_COMMON`), entrambe gia' scritte in `REGISTRO_TEST.md` §2-ter.

### ⚖️ Verdetto
✅ **Non e' un verdetto ribaltato: e' un verdetto INESISTENTE**, e il repo lo
aveva **gia' ritirato il 03/09/2026**. **Quattro CSV con `Trades 0` non misurano
una strategia debole: non misurano niente.** Chi cita *"PostNews senza edge"*
col numero del 07/08 **cita il vuoto**.

### 🛠️ Modifica
**Nessuna necessaria** — `REGISTRO_TEST.md` §2-ter e' gia' corretto e datato.
⚠️ **Segnalo solo dove il verdetto vecchio sopravvive**, per chi passera' di
li': `HANDOFF.md` r.1812 elenca *"PostNews ×2"* fra le voci Tier 1 della
**pulizia VPS del 10/08**. 🟢 **Quella riga NON va corretta**: e' il **verbale
storico di un'operazione fatta**, non un giudizio sul motore. Correggerla
sarebbe riscrivere la storia — la cosa che questo documento esiste per evitare.

---

# 🎣 I CANDIDATI CHE TORNANO NELL'IMBUTO PER EFFETTO DI QUESTE CHIUSURE

> 🛑 **RIGA CHE VIENE PRIMA DI TUTTE: NESSUNO DI QUESTI VA IN CAMPO.** Tornano
> **in coda all'imbuto** come **`NON ANCORA MISURATI`**, non in forward e non
> su una sedia. **Mai in campo in automatico** (`CLAUDE.md`, firma del 07/09).
> **Decide Claudio.**

| # | candidato | perche' torna | cosa manca per giudicarlo | da |
|---:|---|---|---|---|
| 1 | **`ABTG_FvgRetest`** (magic 775501, D30EUR) | il DD 42,9% e' **ritirato**: non e' mai stato misurato | **la corsa**. EA, file prova e riga di lancio **esistono gia' e sono pronti** (`righe/RIGA_PASSO0_FVGRET.ps1`) → costo ≈ **un passo 0** | **C1** |
| 2 | **`M0PB`** (3 indici, M5+M15) | `F1` decaduto per firma (07/09, famiglia) + `H8` come firmato **mai misurato** | un file prova nuovo coi 4 punti di §C8: famiglia · **E a tick** · **un asse sull'uscita** · n≥150 o merito sospeso | **C8** |
| 3 | **`ABTG_Nightly`** su **D30EUR** | **0 trade** (baco `PipSize()`), mai misurato | fix del filtro `InpMaxNightVolPips` vs `ATR(H1)/PipSize()` sugli indici, poi passo 0 | **C5** |
| 4 | **`ABTG_Nightly`** su **U30USD** | idem | idem | **C5** |
| 5 | **`ABTG_Nightly`** su **XAUUSD** | idem | idem | **C5** |
| 6 | **`ABTG_Nightly`** su **XAGUSD** | **0 IS / 4 OOS**: campione inesistente | idem | **C5** |
| 7 | **`ABTG_Nightly`** su **AUDUSD** | **0 trade** e **causa `[NON MISURATO]`** (e' forex: il baco `PipSize()` NON lo spiega) | 🔎 **prima capire PERCHE' fa zero**, poi misurare | **C5** |
| 8 | **`ABTG_Nightly`** su **USDJPY** | idem — **0 trade, causa ignota** | idem | **C5** |
| 9 | **`ABTG_FiboH4_Multi`** sulle **8 coppie** | il "0/8" e' **una** configurazione contata otto volte; il pin `InpSymbols` era vuoto | rilancio col pin **verificato** (`controlla_prova.py` gia' lo intercetta) → **8 misure vere invece di 1** | **C9** |
| 10 | **`R93`** (geometria FiboH4 **del corso**) | **non e' mai girato**: divergenze ×10 / ×2,1 / ×4 mai misurate | la gamba **B** di R93 con `ABTG_FiboH4_Corso.mq5` | **C9** |

🟢 **`ABTG_PostNews`** e' gia' rientrato in coda il **03/09** (C10): **non lo
riconto qui**, altrimenti sarebbe un ripescaggio contato due volte — esattamente
il difetto che C9 ci ha appena insegnato a non fare. 😄

### 📐 Come leggere questa tabella senza farsi male
- ✅ **Sono 10 righe, ma NON sono 10 motori**: sono **4 motori** (`FvgRetest`,
  `M0PB`, `Nightly`, `FiboH4`) × i simboli/gambe che nessuno aveva misurato.
- 🎯 **E la riga 1 e' quella che costa meno di tutte**: `FvgRetest` ha **EA
  scritto, prova pronta e riga di lancio pronta**. Con l'obiettivo del **1°
  ottobre** in testa, e' l'unico dei dieci che puo' passare da *"non misurato"*
  a *"misurato"* **in una corsa**.
- ⚠️ **E il limite che vale per tutti e quattro**: nessuno di loro ha **PF, n e
  DD** oggi. Fino a quando non li ha, **nessuno di questi e' un candidato: e'
  una domanda aperta.** La differenza fra le due cose e' l'intera ragione per
  cui esiste questo documento.

---

## 🛠️ ELENCO COMPLETO DELLE MODIFICHE FATTE (tutte rettifiche datate, zero cancellazioni)

| file | cosa | §|
|---|---|---|
| `HANDOFF.md` | **RETTIFICA 09/09**: `DD 42,9%` FVGRET **ritirato** (numero storico lasciato in chiaro) | C1 |
| `HANDOFF.md` | **RETTIFICA 09/09**: `FVGRET` tolto dalla *"lettura d'insieme"* della lane fade M15 (le gambe vere sono **due**, non tre) | C1 |
| `HANDOFF.md` | **RETTIFICA 09/09** sotto *"Capitoli CHIUSI"*: tabella dei **6 simboli Nightly a zero trade** + `FiboH4` = **una** config contata otto volte | C5 · C9 |
| `backtest_pipeline/REGISTRO_TEST.md` | **REVOCA 30/07 scritta il 09/09** sotto la sezione SupRev *"CONFERMATA"*, coi due CSV e la regola dell'aggettivo sul PF | C2 |
| `backtest_pipeline/REGISTRO_TEST.md` | **ESTENSIONE 09/09** della rettifica Nightly del 23/08: i non misurati sono **sei**, e per AUDUSD/USDJPY la causa e' `[NON MISURATO]` | C5 |
| `backtest_pipeline/REGISTRO_TEST.md` | **RETTIFICA 09/09** §M0PB: metodo **scagionato** cogli orari dei commit, verdetto **declassato**, scritto **cosa manca** | C8 |
| `report/CENSIMENTO_CONTRATTI.md` | **CHIUSURA C3**: tabella del confronto R15/R103, prova `71+119=190`, gerarchia dei tre numeri del contratto | C3 |
| `report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md` | pointer in testata a questo verbale + esito di C1 e C8 | — |

### 🚫 Cosa NON e' stato toccato, dichiarato
**Nessun EA. Nessun preset. Nessun `.set`. Nessun magic. Nessun parametro di
forward. Nessuna sedia accesa o spenta. Nessun backtest lanciato. Nessuna
promozione. Nessun numero storico cancellato.** E **nessun commit**: committa
Claudio.

---

## 🔭 LE TRE COSE CHE QUESTA GIORNATA LASCIA IN EREDITA'

1. 📌 **Un PF senza aggettivo non e' un numero.** *"PF della cella migliore"* o
   *"PF mediano"*: senza, si sopravvive 41 giorni con una promozione revocata
   nel registro (**C2**).
2. 📌 **Un verdetto va contato una volta sola.** Sette file identici sono **una**
   misura, non sette (**C9**); e un motore a **zero trade** non e' un motore
   debole, e' **niente** (**C5**, **C10**).
3. 📌 **Il numero che non ha un file non esiste.** E se sta in `HANDOFF.md` — il
   documento che si legge per ripartire — **fa danno per settimane** (**C1**).
   👉 **La contromisura e' gratis: ogni numero nuovo si scrive nello stesso
   commit del file che lo genera.** Se non c'e' il file, non si scrive il
   numero.

_🎯 E il perche' di tutto questo, per non perderlo di vista: la challenge parte
**ai primi di ottobre**. Ogni riga tolta dal cimitero e rimessa in coda e' una
**sedia possibile** che sei settimane fa avevamo dato per morta senza guardarla.
Oggi ne abbiamo ritrovate **quattro**. **Non male per una giornata passata a
rileggere.** 🚀_

---

_Compilato il **09/09/2026** in sola lettura d'archivio + rettifiche datate.
Ogni numero qui viene da un file citato per nome; dove il file non c'e', c'e'
scritto **`[NON MISURATO]`** o **`[NON RIPRODOTTO]`**._
