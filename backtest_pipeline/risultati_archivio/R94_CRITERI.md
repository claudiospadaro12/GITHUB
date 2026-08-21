# ⚖️ R94 — CRITERI **BOZZA**, NON FIRMATI — la cella Bollinger (37 · 1.4) sul Breaking Band

> ## ✋ QUESTO FILE NON E' FIRMATO.
> Scritto il **21/08/2026** da un agente, a numeri di R94 **mai visti** (nessuna
> passata girata). **Senza la firma di Claudio, R94 non parte e i numeri non si
> guardano.** Regola di casa, non trattabile: *i criteri si congelano prima dei
> numeri, non dopo.*
>
> ⚠️ **E la prima decisione da prendere non e' "firmo / non firmo" ma
> "questo round serve?"** — l'agente che l'ha scritto dichiara che
> **"archiviata" e' un esito legittimo e possibile gia' adesso**, e i motivi
> stanno nel §0.2. La proposta e' presentata *perche' sia decidibile*, non
> perche' vada lanciata.

**Numero del round:** R94. R93 e' gia' **prenotato** dal
`caccia_strategie/DOSSIER_NEWS_FILTER_2026-08-21.md` per il filtro news del
FiboH4 — quindi il primo libero e' il 94.

**Banco:** `ABTG_BreakingBand` **v1.03** · H1 · 3 simboli · **4 celle per
simbolo × 2 finestre = 24 passate** · tick reali BCM · deposito 100k · rischio
1,0% · **6 file prova** `prove\R94{a,b,c}_bb_{GBPUSD,EURUSD,AUDUSD}_p{20,37}.txt`
· driver `walkforward_generico.ps1`, lanciato da **`lancia_r94.ps1`** · riga di
lancio: **`backtest_pipeline/righe/RIGA_R94_BB37.md`**.

---

## 0. 🤝 LA PROMESSA DI ONESTA'

### 0.1 Da dove nasce, alla lettera

Nasce dalla proposta **P-PB3** dell'analisi Point Break del 18/08
(`ANALISI_POINTBREAK_2026-08-18.md:905-909`): il PIANO DI TRADING di Christian
Bertacchi prescrive **Bande di Bollinger periodo 37, deviazione 1.4**
(slide 3, confermato dal grafico di slide 4 — dichiarato **due volte** dalla
fonte, non dedotto). La nostra famiglia **Breaking Band** lavora sulle
Bollinger: aggiungere quella cella "costa quasi nulla".

**Costa quasi nulla e' vero. Che valga qualcosa non e' dimostrato**, ed e' il
motivo per cui questo file esiste invece di una riga di lancio.

### 0.2 LE TRE COSE SCOMODE, SCRITTE PRIMA (non dopo)

**(a) 🧬 Si trapianta un PARAMETRO senza la sua TESI.**
Il 37/1.4 nasce su un motore **diverso**: mean-reversion che entra *fuori* dalle
bande, su **D1/H12**. La sua tesi e' *"bande strette = violate spesso = piu'
estremi da fadare"*. Il Breaking Band fa un'altra cosa (bulge → ritracciamento
→ tocco/retest, TP sulla mediana) su **H1**. La regola di casa
(`caccia_strategie/LEGGIMI.md`) dice *"si raccoglie la MECCANICA e la TESI, mai
il risultato"*: qui la meccanica passa, la tesi **no**.

**(b) 🔢 Il campione della famiglia non permette un giudizio di MERITO.**
Base misurata in R34, tick reali:

| sedia | pattern | n IS | n OOS | frequenza |
|---|---|---:|---:|---|
| GBPUSD | CONT + INV | 13 | 26 | 2,05 op/mese |
| EURUSD | solo CONT | **4** | 13 | 1,02 op/mese |
| AUDUSD | solo INV | **5** | 11 | 0,87 op/mese |

L'Emendamento della Finestra chiede **≥150 operazioni**; R91 aveva gia'
dichiarato *"n < 30 → il MERITO e' SOSPESO"*. Con 11-26 trade OOS
**nessuna cella di R94 puo' essere promossa**, qualunque numero faccia. Un IS a
n=4 non e' una finestra, e' un aneddoto.

**(c) 🎣 Senza un vincolo, questo round e' PESCA.**
Quattro celle × tre simboli = 12 combinazioni su un campione minuscolo: la
probabilita' che *almeno una* sia bella per caso e' alta. E' esattamente la
"cella verde per caso" che la Regola della Seconda Caccia indica come **quella
che brucia la challenge**.

### 0.3 IL VINCOLO CHE RENDE IL ROUND ONESTO — e senza il quale va archiviato

> 🎯 **La domanda di R94 NON e' "quale cella rende di piu'". E' "la geometria
> 37/1.4 produce piu' OPERAZIONI?"**

Motivo meccanico, leggibile prima di misurare: **deviazione 1.4 = bande piu'
strette = piu' tocchi e piu' retest**, e il tocco della banda e' l'innesco di
entrambi i pattern. Se il conteggio sale in modo netto, la famiglia guadagna un
**campione leggibile**, che oggi non ha — e *quello* sarebbe il risultato utile,
molto piu' del profitto di 26 trade.

**Conseguenza operativa, congelata qui:** in R94 il **profitto non si guarda**
finche' il cancello di frequenza (§3) non e' superato. Se non lo e', la cella si
archivia **senza aprire la colonna Profit**.

---

## 1. 🎯 LA DOMANDA — e la sua falsificazione

**Domanda:** su `ABTG_BreakingBand` a parita' di tutto il resto, la geometria
Bollinger **37 / 1.4** cambia il numero di operazioni rispetto alla **20 / 2.0**
oggi in campo? E quale dei due parametri lo fa — il **periodo** o la
**deviazione**?

**Falsificazione dichiarata:** se il conteggio operazioni OOS **non sale** (o
scende) su tutti e tre i simboli, la risposta e' **no** e la proposta P-PB3 e'
**archiviata definitivamente**, con la riga scritta nel REGISTRO_TEST dei caduti
perche' nessuno la riproponga.

**Il fattoriale 2×2 non e' un lusso**: senza le celle miste (37/2.0 e 20/1.4)
un eventuale effetto non sarebbe attribuibile. Il periodo 37 ha una fonte in
casa (`BREAKING_BAND_TESI.md`: BB 37/3 sugli **indici**), la deviazione 1.4 no.

---

## 2. 🧪 IL DISEGNO

| | |
|---|---|
| EA | `ABTG_BreakingBand` v1.03 (nessuna modifica al sorgente: `InpBBPeriod` e `InpBBDev` esistono dalla v1.00) |
| TF | H1 (`InpTF=16385`) |
| Finestra | `@DAQUANDO 2024.09.26`, split 40/60 del driver → IS 2024.09.26-2025.06.09, OOS 2025.06.10-2026.06.30 |
| Dato | **tick reali BCM**, "Ogni tick basato su tick reali" |
| Deposito | 100.000 (per riprodurre R34 al centesimo) |
| Rischio | **1,0%** — vedi §2.1 |
| Celle | `InpBBPeriod` ∈ {20, 37} × `InpBBDev` ∈ {1.4, 2.0} |
| Simboli/pattern | GBPUSD patt.2 (CONT+INV) · EURUSD patt.0 (CONT) · AUDUSD patt.1 (INV) |
| Artefatti | **6 file prova**: per ogni simbolo un gemello **P20** e un gemello **P37**. Dentro un file si muove **una variabile sola** (la deviazione); fra i due file se ne muove **un'altra sola** (il periodo) |
| Fermi | `InpStdPeriod=20`, `InpStdSmaPeriod=50`, `InpMinRR=0`, `InpTPMode=0`, `InpBulgeWidthMult=1.35`, `InpBulgeNetMoveATR=1.0`, `InpRetestBufferATR=0.15` |

### 2.1 ⚠️ UNA DECISIONE CHE E' DI CLAUDIO, NON DELL'AGENTE — il rischio
R92 e' stato firmato a **0,80%** (era 1,00). R94 e' scritto a **1,0%** per una
ragione tecnica: **il canarino (§4) confronta col R34, che gira all'1,0%.**
Cambiando rischio il confronto salta. Le due strade sono entrambe legittime:
- **1,0%** → canarino valido, ma il round non parla la lingua di R92;
- **0,80%** → coerente con la firma piu' recente, ma la base R34 va **rimisurata
  prima** (2 passate in piu').

👉 **Da decidere in firma. L'agente non sceglie.**

### 2.2 🚫 COSA NON SI TOCCA
La sedia viva **`BB GBPUSD INV S` (magic 772161)** e le sue sorelle in forward
**non vengono toccate da questo round**: R94 gira nel tester con i magic del
driver. Nessun preset del VPS viene modificato.

---

## 3. 🚧 I CANCELLI — in ordine, e il primo blocca gli altri

### 🥇 CANCELLO 1 — FREQUENZA (l'unico che decide)
Soglie per simbolo, scalate sulla base di ciascuna sedia:

| simbolo | n OOS base | ✅ campione leggibile | 🟡 non decisivo | ❌ archiviata secca |
|---|---:|---|---|---|
| GBPUSD | 26 | **≥ 60** | 27-59 | ≤ 26 |
| EURUSD | 13 | **≥ 30** | 14-29 | ≤ 13 |
| AUDUSD | 11 | **≥ 30** | 12-29 | ≤ 11 |

**Regola d'insieme (Emendamento, punto A):** la cella deve salire su **almeno 2
simboli su 3**. Un solo simbolo che sale mentre gli altri due scendono e' rumore,
non un effetto — e si archivia.

### 🥈 CANCELLO 2 — RISCHIO (si legge SEMPRE, a qualunque n)
Se una cella fa **DD > 8%** (il doppio abbondante del 3,48% della base OOS
GBPUSD), la cella e' **fuori** anche se la frequenza sale. Un drawdown e' un
fatto accaduto, non una stima: questo cancello **non e' sospeso dal campione
piccolo**.

### 🥉 CANCELLO 3 — MERITO: **SOSPESO PER DICHIARAZIONE**
Con n OOS < 30 il merito **non si giudica**. Se il cancello 1 passa, l'esito
massimo di R94 e' una **PROPOSTA motivata** di un round successivo con la nuova
geometria e un campione vero — **mai una promozione, mai un deploy**.

### 📐 La misura che va scritta accanto a ogni riga
`aspettativa dei trade AGGIUNTI = (Profit_cella − Profit_base) / (n_cella − n_base)`.
Se viene **negativa**, la cella ha comprato frequenza pagandola con operazioni
perdenti: **e' un peggioramento anche se n sale**, e va detto.

---

## 4. 🐤 IL CANARINO — si legge PRIMA di tutto il resto

La cella **20 / 2.0** deve riprodurre R34 **al centesimo** su tutti e tre i
simboli (righe nei file prova). Se non torna, si e' mosso qualcosa che non
doveva muoversi: **il round si ferma e si cerca il perche'**, non si prosegue.

---

## 5. 📋 COSA ESCE DA R94 — i tre esiti possibili, scritti prima

1. **ARCHIVIATA** (cancello 1 fallito su ≥2 simboli): riga nel REGISTRO_TEST dei
   caduti, P-PB3 chiusa, il 37/1.4 non si ripropone piu' senza una tesi nuova.
2. **NON DECISIVO** (zona gialla): si scrive il numero, si archivia comunque, e
   si dichiara che la famiglia resta con il campione che ha.
3. **PROPOSTA** (cancello 1 passato + cancello 2 pulito): si propone a Claudio un
   round successivo **su campione vero** con la geometria nuova. Nessun deploy,
   nessun cambio di preset in forward.

> ❌ **Non esiste un quarto esito.** In particolare **non esiste** l'esito
> "la cella rende di piu', la mettiamo in campo": con 11-26 operazioni quel
> passo non e' consentito da nessuna regola di casa.

---

## 6. ✍️ FIRMA DI CLAUDIO

_(vuota — questo file e' una BOZZA)_

Da riempire con la parola esatta di Claudio, la data, e la scelta esplicita
sul **rischio** (§2.1). Se la decisione e' **"non serve, archivia"**, va scritta
qui lo stesso: un round non lanciato con la ragione scritta vale piu' di un
round lanciato per non lasciare la casella vuota.


---

# ✍️ FIRMA DI CLAUDIO — R94 BOLLINGER 37/1.4, 21/08/2026, **PRIMA DEI NUMERI**

> **"metro,frequenza, firmo r93, r94 lancia, e prepara jpy"**
> — Claudio, 21/08/2026, in chat.

La parola **"r94 lancia"** firma i criteri e autorizza la corsa.

Dichiarazione di cecita': al momento della firma **nessun numero di questi round
e' stato prodotto, letto o guardato**. Nessuno dei due EA nuovi e' mai stato
compilato. Le soglie NON sono state toccate dalla firma.


## La domanda, che NON e' "quanto rende"
La famiglia BreakingBand gira su **n OOS di 11 / 13 / 26**: con quei campioni il
**merito e' sospeso per dichiarazione**. R94 chiede una cosa sola:
**la frequenza sale?** (deviazione 1.4 = bande piu' strette = piu' tocchi).

> **Se la frequenza non sale, il profitto non si guarda nemmeno.** Congelato qui.

Fattoriale **2x2**, 24 passate, per separare il **periodo** (che una fonte in casa ce
l'ha: BB 37/3 sugli indici) dalla **deviazione** (che non ce l'ha: viene dal corso).

## Assunzione dichiarata da Claude, NON firmata da Claudio: il rischio
Claudio ha firmato "lancia" **senza pronunciarsi sul rischio**, che era la richiesta
n.4 dell'agente (1,0% "canarino valido" contro 0,80% della firma R92).
**Assunzione presa: si resta all'1,0%**, e il motivo e' che R94 misura la
**FREQUENZA** contro la **base gia' misurata della famiglia**, che gira all'1,0%:
cambiare rischio renderebbe il confronto con la base **non comparabile**, e la
frequenza e' la grandezza che il rischio non tocca.
⚠️ **Claudio puo' ribaltare questa assunzione con una parola**, e in quel caso la
base va rimisurata insieme alla cella.

---

# 🔧 NOTA TECNICA POST-FIRMA — 21/08/2026, scritta a numeri ANCORA MAI VISTI

**Cosa e' cambiato dopo la firma, e perche' NON tocca la firma.**

Al momento della firma il disegno era **3 file prova con DUE assi ciascuno**
(`InpBBPeriod` × `InpBBDev`). Passandolo da `backtest_pipeline/controlla_prova.py`
il controllo lo ha **bocciato**, e aveva ragione:

```
- 2 assi Y: un file prova misura UNA variabile alla volta (InpBBPeriod, InpBBDev)
```

Riscritto in **6 file prova con UN asse ciascuno**: per ogni simbolo un gemello
**P20** (periodo pinnato a 20) e un gemello **P37** (periodo pinnato a 37),
entrambi con l'unico asse `InpBBDev` = 1.4 / 2.0.

> ✅ **Le celle misurate sono le STESSE, una per una**, e il conto torna
> identico a quello firmato: **12 celle, 24 passate**, stesso fattoriale 2×2,
> stesse soglie, stesso rischio, stessa finestra.
> 🔄 **E' cambiata solo la forma degli artefatti**, non il contenuto della
> misura. Le soglie **non sono state toccate**, il canarino nemmeno.
> ⚠️ **Se Claudio ritiene che anche la forma facesse parte di cio' che ha
> firmato, lo dica: si rifa' prima di lanciare, non dopo.**

Verifica successiva, dopo la riscrittura:
```
file: 6 | celle totali: 12 | passate (celle x 2 finestre): 24 | problemi: 0
ESITO: OK
```

## 🔎 Il buco chiuso mentre si scriveva la riga di lancio

Scrivendo `lancia_r94.ps1` e' saltato fuori un difetto **del giro a vuoto**, che
vale per **tutti** i round di questa casa e non solo per R94:

> 🔴 **`walkforward_generico.ps1 -SoloControllo` NON COMPILA.**
> Esce alla **riga 503**; la compilazione sta alla **riga 603**.
> Quindi un `#include` mancante o di versione sbagliata **non si vede nel giro a
> vuoto** e salta fuori **a corsa avviata**, come `undeclared identifier` dentro
> il driver — esattamente il difetto **33-bis** della checklist, che era stato
> scritto guardando un altro sintomo.

`lancia_r94.ps1` lo chiude per conto suo: **compila lui**, da riga di comando,
**anche in `-SoloControllo`**, e verifica che il `.ex5` sia stato **riscritto
adesso** (coppia sorgente/binario, punto 27). Costa dieci secondi.
📌 **Il fix vero** — far compilare il driver anche in `-SoloControllo`, o
almeno dirlo — **resta in coda come lavoro a se'**, e sta scritto qui perche'
non si perda.

## 🧪 Cosa e' stato verificato prima di consegnare

| controllo | strumento | esito |
|---|---|---|
| file prova | `controlla_prova.py` | ✅ 6 file, 12 celle, 24 passate, 0 problemi |
| driver PowerShell | `lint_ps1.py` | ✅ 0 problemi |
| sintassi PowerShell | parser vero (`Parser::ParseFile`) | ✅ 0 errori |
| ASCII puro nel `.ps1` | conteggio byte > 127 | ✅ 0 |
| estrazione `#include` | eseguita sul sorgente vero | ✅ trova `ABTG_PausaGuardian.mqh`, salta `Trade/Trade.mqh` |
| difetto 33 (secondo artefatto) | eseguito su `walkforward_generico.ps1` | ✅ 0 occorrenze dell'EA nel driver |
| il rischio cambia `n`? | lettura del sorgente | ✅ no: Guardian fail-open nel tester, nessun kill switch giornaliero, `InpMaxPositions` conta posizioni. Unico residuo: `lot<=0` (riga 1133), **contato dal funnel** |

⚠️ **Quello che NON e' verificato:** la riga **non e' mai stata eseguita su
Windows**. Il parser conferma la sintassi, non il comportamento. Per questo il
**BLOCCO 1 (giro a vuoto) va mandato per primo**.
