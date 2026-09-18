# 🥊 R180 — IL DUELLO DEGLI INGRESSI **SUL DOW** (U30USD)

_Criteri congelati il **18/09/2026**, **PRIMA di qualunque numero**.
Nasce da una richiesta testuale di Claudio: **«FAI IL DUELLO SUI GEMELLI DOW E
SPX»**. Discende da **FIRMA 6** (`report/FIRME_2026-08-18.md`) e dai criteri
di **R83** (`prove/R83_INGRESSI_CRITERI.md`), che hanno fatto lo stesso duello
su **D30EUR** e **NASUSD** — **mai su U30USD**._

> 🎯 **LA DOMANDA, UNA SOLA:**
> **«A parità ASSOLUTA di tutto il resto (livello, orario, stop, gestione,
> uscite, filtri), quale STILE D'INGRESSO regge meglio sull'apertura del
> DOW?»**

🚫 **Questo round non promuove e non spegne niente.** Non tocca il forward, non
tocca preset, non propone taglie, non nomina il conto reale 10105439.

---

## 0. 🔴 IL NUMERO DEL ROUND: PERCHÉ **R180** E NON R141

La richiesta parlava di celle `R141u0/u1/u2`. **`R141` È GIÀ OCCUPATO** —
verificato meccanicamente, non a memoria:

```
ls backtest_pipeline/prove/ | grep -iE "^R141"
  R141a_momentum_NASUSD_r12.txt      R141b_momentum_U30USD_gemello.txt
  R141c_atrexh_M30_NASUSD.txt        R141d_hvancora_stopatr_M30_U30USD.txt
  R141e_daxva_buffer_M15_D30EUR.txt
```

Il numero più alto usato nel repo è **R179**. Questo round prende **R180**;
la sonda SPX prende **R185**. Riusare R141 avrebbe mescolato due round
diversi negli stessi CSV di `risultati_prove/`.

> 🔴 **E IL NUMERO VA VERIFICATO SUL WORKING TREE, NON SUL SOLO COMMIT.**
> Il 18/09 **un altro lavoro in corso sulla stessa copia** ha occupato **R181**
> (`R181_CROCE_SLIDE_CRITERI.md`, celle `R181a/b/c`) e poi lo ha **rinumerato in
> R183** con una sostituzione globale che ha toccato anche il blocco di questo
> round in `REGISTRO_TEST.md`. La sonda SPX e' stata spostata a **R185** proprio
> per stare fuori dalla zona contesa, e **R181-R184 vanno considerati occupati**
> finche' qualcuno non li rilegge. Classe di difetto nuova: *numeri di round
> assegnati in parallelo da lavori diversi sulla stessa copia*.

---

## 1. 🔎 IL CENSIMENTO CHE VIENE PRIMA — cosa esiste già, misurato

Fatto **meccanicamente** (script: `censimento` su 2.376 CSV, di cui **368** con
la colonna `InpEntryMode`), non a memoria. Risultato integrale nel referto
`report/DUELLO_GEMELLI_DOW_SPX_2026-09-18.md`. Qui il succo:

### 1a. 🪤 LA TRAPPOLA DEGLI ENUM — e va letta prima di ogni numero

I due EA **numerano le modalità in modo DIVERSO**:

| valore di `InpEntryMode` | `ABTG_Dow_Apertura_US` (`ENUM_ABTG_ENTRY`, r.170-178) | `ABTG_Apertura_3Ingressi` (`ENUM_ABTG_STYLE`, r.199-204) |
|---|---|---|
| **0** | BREAKOUT (stop) | **STOP** (= BREAKOUT) |
| **1** | GAPFILL | **LIMIT sul retest** (= RETEST) |
| **2** | **RETEST** | **MARKET alla chiusura** (= CLOSECONFIRM) |
| 3 / 4 / 5 / 6 | FADE / DELAYED / OPENCONFIRM / — | (non esposti) |

Il ponte è in `ABTG_Apertura_3Ingressi.mq5` r.561-565:
`ABTG_ST_STOP→ABTG_BREAKOUT` · `ABTG_ST_RETEST→ABTG_RETEST` ·
`ABTG_ST_CLOSECONF→ABTG_CLOSECONFIRM`.

🔴 **Conseguenza: `InpEntryMode=2` sul Dow vivo È il retest, cioè la modalità
`1` del duello.** Chi copia il numero invece del significato misura un'altra
strategia e non se ne accorge.

### 1b. 📋 U30USD — che cosa è già misurato sul motore delle aperture

| modalità (semantica) | già misurata su U30USD? | dove | n (IS / OOS) | PF (IS / OOS) | DD |
|---|---|---|---|---|---|
| **BREAKOUT (stop)** | ✅ **SÌ** | `Apertura_nuovi_indici/valid_Apertura_U30USD_Dow.csv` (96 celle) · `Nasdaq_Apertura/apert_US_M5_doc_brk_realtick_U30USD.csv` (143 celle) | fino a 471 · 106-113 | max **0,997** · **1,106-1,214** | fino a **15,7%** · 10,9-13,8% |
| **RETEST (limit)** | ✅ **SÌ**, in 6 corse | `r6`, `r35`, `r46b`, `r47c`, `r47d`, `ptc`, `csv_r54` | vedi 1c | 0,77-1,38 / **1,01-1,68** | 2,5-9,9% |
| **CLOSECONFIRM (market alla chiusura)** | 🔴 **MAI** | — | — | — | — |
| FADE | ✅ SÌ | `apert_fade_realtick` | 324 (una corsa) | **0,806** | **19,7%** |
| DELAYED | ✅ SÌ | `apert_US_M5_doc_delay_realtick_U30USD.csv` | 2-168 | max **0,978** | fino a **24,3%** |

👉 **Quindi il retest NON è la cosa che manca.** Manca **(a)** la modalità
CLOSECONFIRM, mai girata su U30USD, e **(b)** soprattutto **il CONFRONTO AD
ARMI PARI**: le corse sopra hanno finestre, filtri, griglie e scopi diversi
fra loro — non sono un duello, sono sei round scollegati.

### 1c. 📏 IL CAMPIONE, ed è questa la scoperta che cambia il disegno

Dalle righe misurate di `r6` (stessa cella, taglio IS/OOS 0,40):

| lati | `InpRangeMinutes` | n IS | n OOS | PF IS | PF OOS | DD IS | DD OOS |
|---|---|---|---|---|---|---|---|
| **solo long** (cella viva) | 35 | **74** | **130** | 1,215 | 1,275 | 5,58% | 4,18% |
| **due lati** | 35 | **147** | **203** | 1,379 | 1,087 | 5,54% | 8,38% |
| due lati | 25 | 150 | 218 | 1,132 | 1,202 | 9,07% | 9,74% |
| due lati | 45 | 131 | 187 | 1,233 | 1,166 | 4,77% | 7,10% |

🔴 **Solo long, il pavimento dei 150 (Emendamento A) è IRRAGGIUNGIBILE su
questa finestra**: 74 + 130 = 204 operazioni in tutto, a qualunque taglio.
🟢 **Con i due lati diventa raggiungibile**: 147 + 203 = **350** operazioni
totali; a taglio **0,50** le due metà valgono **~175 e ~175**, sopra il
pavimento tutte e due.

👉 **Per questo il round ha DUE FAMIGLIE**, non una (§3).

### 1d. 🔴 SPXUSD — il falso positivo che ho quasi scritto

Un `grep SPXUSD` sui CSV **risponde SÌ in decine di file**. **È FALSO**, ed è
esattamente il contro-esempio che andava costruito prima di consegnare:
`SPXUSD` compare come valore della colonna **`InpCorrSymbol`** — il simbolo del
*filtro di correlazione*, che in tutte quelle righe è per giunta **SPENTO**
(`InpUseCorrelation=0`). Non è il simbolo negoziato.

Filtrando per **simbolo negoziato**, su SPXUSD esistono **solo** due scansioni
di `ABTG_GoldenCross` (H1 e H4, `InpEntryMode` sempre a 0 e inerte per
quell'EA). **Sul motore delle aperture, su SPXUSD, ZERO righe.**

➡️ **E prima del duello SPX manca un dato più basilare: la profondità dei dati
BCM su SPXUSD non è mai stata misurata.** Vedi `R185_SONDA_SPXUSD_CRITERI.md`.

---

## 2. 🟢 IL PASSO 0 DI R83 È GIÀ RISOLTO SUL DOW (e nessuno lo aveva scritto)

R83 §3 dichiarava: _«la profondità dei TICK REALI degli indici a BCM non è mai
stata misurata»_. **Sul Dow e sul DAX oggi è misurata**, e il file è in repo:

```
backtest_pipeline/risultati_archivio/ABTG_StoricoScaricato.csv   (commit 70b289d5, 08/09/2026)
  D30EUR,TICK,35496307,2024.09.26,-,COMPLETO
  U30USD,TICK,68558736,2024.09.26,-,COMPLETO
```

✅ **Quindi R180 gira a `-Modello 4` (tick reali) su tutta la finestra, e non è
un'assunzione: è una riga di un referto.**
🔴 **NASUSD e SPXUSD NON sono in quel file**: per loro il PASSO 0 resta aperto.

---

## 3. 🧬 LE CELLE — sette, due famiglie

| cella | file | famiglia | `InpEntryMode` | motore vero | magic (2 gemelli) |
|---|---|---|---|---|---|
| **u0** | `R180u0_stop_U30USD.txt` | **L** solo long | 0 | BREAKOUT (stop) | 777410 / 777411 |
| **u1** | `R180u1_limit_U30USD.txt` | **L** solo long | 1 | RETEST (limit) — **= sedia viva** | 777420 / 777421 |
| **u2** | `R180u2_conferma_U30USD.txt` | **L** solo long | 2 | CLOSECONFIRM (market) — **codice mai girato su U30USD** | 777430 / 777431 |
| **u0b** | `R180u0b_stop_U30USD.txt` | **B** due lati | 0 | BREAKOUT | 777440 / 777441 |
| **u1b** | `R180u1b_limit_U30USD.txt` | **B** due lati | 1 | RETEST | 777450 / 777451 |
| **u2b** | `R180u2b_conferma_U30USD.txt` | **B** due lati | 2 | CLOSECONFIRM | 777460 / 777461 |
| **uV** | `R180uV_canarino_vivo_U30USD.txt` | canarino | **2** (enum dell'EA VIVO = RETEST) | **EA `ABTG_Dow_Apertura_US`** | 777490 / 777491 |

- **Famiglia L** = la cella viva `770202` alla lettera (`InpAllowShort=0`),
  taglio **@FRAZIONEIS 0,40** (lo stesso delle corse già misurate: permette il
  confronto diretto con `r6`).
- **Famiglia B** = stessa cella con **i due lati** (`InpAllowShort=1`), taglio
  **@FRAZIONEIS 0,50**. Serve a due cose insieme: la **regola dei due lati**
  del 25/08 e il **pavimento dei 150**.

### 🔴 MAGIC VERGINI — il comando e il risultato, dichiarati

```
for m in 777410 777411 777420 777421 777430 777431 \
         777440 777441 777450 777451 777460 777461 777490 777491; do
  grep -rIl --exclude-dir=.git --exclude-dir=.claude -w "$m" . | wc -l
done
```
**Risultato: 0 file per TUTTI E QUATTORDICI.** Eseguito il 18/09/2026 su
`lavoro`, prima di scrivere i file prova.

---

## 4. 🔒 COSA È CONGELATO — e il CONTRO-ESEMPIO costruito prima

1. **L'ingresso è l'UNICA variabile dentro una famiglia.** Non è una promessa:
   i sei file **non sono scritti a mano**, li genera
   `prove/R180_GENERA.py` da **una sola** struttura di parametri.
2. **Il contro-esempio, eseguito e riportato qui.** Se il round NON misurasse
   quello che promette, i file differirebbero in qualcosa oltre l'ingresso.
   Verifica meccanica (rifare a ogni modifica):

```
diff <(grep -v '^#' R180u0_stop_U30USD.txt) <(grep -v '^#' R180u1_limit_U30USD.txt)
  17c17   InpEntryMode=0...  -> InpEntryMode=1...
  89c89   InpMagic=777410... -> InpMagic=777420...
diff <(grep -v '^#' R180u1_limit_U30USD.txt) <(grep -v '^#' R180u2_conferma_U30USD.txt)
  17c17   InpEntryMode      89c89  InpMagic
diff <(grep -v '^#' R180u1_limit_U30USD.txt) <(grep -v '^#' R180u1b_limit_U30USD.txt)
  5c5     @FRAZIONEIS 0.40 -> 0.50
  25c25   InpAllowShort=0  -> 1
  89c89   InpMagic
```
   **DUE sole differenze dentro la famiglia, TRE fra le famiglie. Nient'altro.**
3. **Nessuna griglia.** L'unico asse spazzolato è la coppia di magic gemelli
   (controllo d'identità): `celle=2` per file, confermato dal cancello.
4. **Un magic per cella, mai segnali miscelati.**
5. **Il round non tocca il forward.** Al massimo **UNA** modalità per mercato
   potrà mai andare in campo: le tre si innescano sullo stesso evento, quindi
   sarebbero posizioni correlate e mangerebbero tre volte il cap **C1 (3,25%)**.

### 4a. ⚠️ I PARAMETRI CHE DEVONO PER FORZA DIVERGERE — dichiarati, non nascosti

| cosa | cella viva `770202` | qui | perché |
|---|---|---|---|
| `InpRiskPercent` | **0,65%** (100k) / 1,0% (piccolo) | **1,0%** | convenzione di banco: si confrontano MOTORI, non TAGLIE. 🔴 Il DD a 0,65% resta un **APPROSSIMATO lineare**, mai una misura |
| `InpUsaGuardian` | **true** | **l'input NON ESISTE** nell'EA del duello | l'EA del duello è un fork del motore Nasdaq. Nel canarino `uV` l'EA vivo gira col Guardian **spento** apposta, per confrontare due motori uguali |
| `InpVerbose` | true | **false** | non serve a nessun cancello qui e gonfierebbe il log |
| `InpRetestOffsetPts=400` | attivo | scritto in **tutte e sei**, ma **agisce solo in modalità 1** | 🟠 **asimmetria strutturale dichiarata**: il retest ha una manopola che le altre due non hanno. Non si può togliere senza smettere di misurare la cella viva |
| `InpAllowShort` | false | **false in L, true in B** | è l'asse della famiglia, mai una variabile dentro la famiglia |
| leve **R30** (`InpUseVolRegime`, `InpUseSRFilter`) | **non esistono** nell'EA vivo | **pinnate SPENTE** | senza questo pin il canarino non potrebbe coincidere |

🔴 **E la divergenza da R83 che va detta forte: qui il filtro EMA è ACCESO**
(`InpUseEmaFilter=1`, 1/50 su H4). In R83 tutti i filtri erano spenti. Qui non
si può: **è la cella viva del Dow**. Spegnerlo vorrebbe dire duellare su una
cella che in campo non esiste. Conseguenza onesta: **R180 non è confrontabile
riga per riga con R83** — i due round rispondono alla stessa domanda su due
configurazioni diverse.

---

## 5. 🐤 I CANARINI — senza di loro il duello non conta

**(b) VINCOLANTE — `uV` contro `u1`.** L'EA vivo del Dow in `RETEST` e l'EA del
duello in modalità 1 devono dare **gli stessi Profit, PF, Trades, DD**, con
stesso `@DAQUANDO`, `@FINOA`, `@FRAZIONEIS`, `-Modello`, `-Deposito`.
🔴 **Se non coincidono, il round si FERMA.** Non si spiega la differenza a
posteriori: si cerca la divergenza nel codice. Un duello fra un EA e un clone
che non è un clone non misura gli ingressi, **misura un bug**.

**(c) NON vincolante — il numero già misurato.** `u1` (famiglia L, taglio 0,40)
dovrebbe atterrare vicino alla riga `r6` `InpRangeMinutes=35` solo long:
**IS n=74, PF 1,21486, DD 5,58% · OOS n=130, PF 1,27507, DD 4,18%**.
⚠️ **Perché non è vincolante, detto onestamente:** il **modello** e il
**deposito** della corsa `r6` **non sono registrati da nessuna parte** (nessuno
script né referto li riporta). La parte robusta del confronto è **n=74 / n=130**
(il numero di operazioni non dipende dal deposito); PF e DD sì.

**(d) L'AUTOTEST.** `InpAutoTest=1` in tutte le celle del duello: l'EA stampa
`[3ING][AUTOTEST]` in `OnInit`. 🔴 Quelle righe le produce **un'ESECUZIONE**,
non il tasto F7 (difetto n.20 della checklist).

---

## 6. ⚖️ I CRITERI DI LETTURA — congelati adesso, prima dei numeri

Si leggono **Profit, PF, Equity DD %, Trades** per IS, OOS e totale, **per
famiglia separatamente**.

1. **Il verdetto è PER FAMIGLIA e PER MERCATO.** Una modalità può vincere a due
   lati e perdere solo long: è un risultato, non una contraddizione.
2. **CAMPIONE — Emendamento A + valvola R59.**
   - cella con **n < 30** in una finestra → **merito NON MISURABILE**;
   - cella con **n < 150** in una finestra → **merito SOSPESO per campione**, e
     il numero si scrive lo stesso, **con la sospensione accanto**;
   - 🔴 **il RISCHIO non si sospende MAI.** Un DD accaduto è un fatto a
     qualunque n.
   - ⚠️ **Atteso dichiarato prima:** la **famiglia L è sotto il pavimento per
     costruzione** (74/130 misurati sul retest). Il suo merito nasce sospeso.
     La famiglia B è quella che può pronunciarsi.
3. **Il numero di trade è INFORMAZIONE, non un difetto.** Il limit riempie meno
   (no-fill), la conferma entra più tardi: **quante entrate perde ciascuno
   rispetto alla 0** è metà della risposta e va scritto.
4. **VINCE una modalità solo se**, nella sua famiglia:
   **PF sul campione intero ≥ baseline + 0,10** (baseline del Dow = **modalità
   1, il retest**, perché è ciò che gira) **E** segno **non ribaltato** fra IS e
   OOS **E** DD **non peggiore di più di 1,0 punto percentuale**.
5. **Altrimenti: «le tre modalità non sono distinguibili su questa finestra».**
   Esito **legittimo e probabile**, da scrivere senza giri di parole.
6. **ZERO vincitori è un esito valido.**
7. **RISCHIO — soglia dura, indipendente dal merito:** qualunque cella con
   **Equity DD ≥ 10%** (muro totale di casa) su questa finestra va segnalata in
   rosso nel referto, **anche se vince il duello**. 🔴 Nota misurata: le corse
   già fatte su U30USD hanno toccato **15,7% (breakout)**, **19,7% (fade)** e
   **24,3% (delayed)** — su questo simbolo il muro **è stato sfondato davvero**.
8. **R180 non promuove niente in forward.** Un eventuale vincitore passa dal
   processo completo: prova di regime, walk-forward, collaudo prop (spread a
   scala + latenza), contratto DD+frequenza, **firma di Claudio**.

---

## 7. 🛑 CHE COSA QUESTO ROUND **NON** PUÒ MISURARE — l'elenco, per nome

1. 🔴 **La ROBUSTEZZA DI REGIME.** Finestra 2024.09.26→2026.06.30 = **21 mesi,
   un regime e mezzo** (toro USA + correzione 2025). **Niente 2020, niente
   2022.** E non è una scelta: la sonda del 17/08 misura che **BCM non ha di
   più** sugli indici (verdetto `COMPLETO` a 2024.09.26).
2. 🔴 **Il pavimento dei 150 sulla famiglia L**: **non lo supera**, e il numero
   atteso è **74 IS / 130 OOS** (misurato, non stimato). La famiglia B lo
   supera **atteso ~175/175** — ⚠️ **atteso sulla sola modalità RETEST**: per la
   0 e la 2 il numero di riempimenti **è precisamente ciò che il round deve
   misurare**, quindi **non è predicibile** e potrebbe cadere sotto 150. Se
   succede, quella cella nasce col merito sospeso: è un risultato, non un
   fallimento del round.
3. 🔴 **Lo SLIPPAGE.** `InpSlippagePts=0` in tutte e sei le celle, e nel motore
   lo slippage peggiora **solo gli ordini STOP**: **la modalità 0 è
   AVVANTAGGIATA**. Se vince la 0, **la vittoria ha l'asterisco** e serve un
   giro 2 con un valore **misurato**, mai inventato.
4. 🔴 **Requote, rifiuti, esecuzione della prop vera**: fuori portata del
   tester, sempre.
5. 🔴 **Il costo dello SPREAD in apertura.** `InpMaxSpread=0` (filtro spento) e
   questa sedia entra **alle 14:30 server**, il minuto in cui lo spread è più
   largo della giornata. I tick reali portano lo spread registrato, **non**
   quello di una prop in fase di challenge. Lo stress a scala è **collaudo**,
   non questo round.
6. 🔴 **Il confronto con R83.** Lì i filtri erano spenti, qui l'EMA è accesa
   (§4a). I due round **non si sommano**.
7. 🔴 **SPXUSD.** Non è in questo round, e non ci può essere finché la sonda
   R185 non risponde.

---

## 8. ⏱️ ORDINE DI ESECUZIONE E COSTO — **è una STIMA, e la base è dichiarata**

1. **Giro a vuoto** su tutti e sette i file (`-SoloControllo`). **1-2 min.**
   Deve stampare `celle per finestra: 2` per ciascuno.
2. **AUTOTEST + CANARINO**: prima `uV`, poi `u1`. **Si confrontano PRIMA di
   girare il resto.** Se non coincidono → STOP.
3. **Le altre cinque celle.**

**Il conto:** 7 file × 2 celle × 2 finestre (IS+OOS) = **28 passate**.

| base MISURATA | ritmo | 28 passate |
|---|---|---|
| **R88a** (tick reali, M5, 21 mesi, 96 passate in 8,0 min) | 0,083 min/passata | **~2,3 min** |
| **R112** (stesso EA/simbolo/finestra/modello, 8 avvii di terminale) | 0,375 min/passata | **~10,5 min** |

👉 **Banda 2,3–10,5 min. Per pianificare si usa 15 minuti** (R180 ha **7**
avvii di terminale, più di entrambe le basi).
🔴 **[NON MISURATO]**: il tempo di **costruzione della cache tick** al primo
avvio su U30USD (**68,5 milioni di tick**). Se la cache non c'è già sul PC di
backtest, il primo avvio può costare molto più del resto messo insieme. Si
misura al primo giro, non si stima.

⚠️ **UNA MACCHINA, UN LAVORO**: un solo MT5 sul PC di backtest. R180 non gira
accanto ad altri round.

---

## 9. 📎 TRACCIABILITÀ

- EA del duello: `mql5/Experts/ABTG_Apertura_3Ingressi.mq5` (v1.00, 96 input)
- EA del canarino: `mql5/Experts/ABTG_Dow_Apertura_US.mq5` (v1.01, 81 input)
- Generatore delle celle: `backtest_pipeline/prove/R180_GENERA.py`
- Fonte della cella viva: `mql5/Presets/ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set`
  (foto del `.chr` del **06/09/2026**) + `prove/R103_ABTG_Dow_Apertura_US_U30USD_770202.txt`
- Profondità dati: `risultati_archivio/ABTG_StoricoScaricato.csv` (08/09/2026)
- Criteri padre: `prove/R83_INGRESSI_CRITERI.md` · Firma: `report/FIRME_2026-08-18.md`
- Sonda gemella: `prove/R185_SONDA_SPXUSD_CRITERI.md`
- Cancello strato 1 superato: **7 file, 14 celle, 28 passate, 0 problemi, ESITO OK**
  (18/09/2026), con la riga giusta:
  ```
  python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/R180u*.txt
  ```
  🔴 **E NON con `--ea` su tutto il gruppo**: sei celle girano su
  `ABTG_Apertura_3Ingressi`, la settima (`uV`) sull'EA **vivo** del Dow.
  Forzare un solo `--ea` su tutto il glob fa uscire un **FALLITO FALSO**
  (`input SCONOSCIUTO all'EA: InpUsaGuardian`), che non e' un difetto dei file
  ma della riga di controllo. Senza `--ea` lo strumento deduce l'EA dalla riga
  `#  EA: <nome>` in testa a ciascun file, ed e' il modo corretto qui.
  ⚠️ **Vale anche per il driver**: `uV` NON si lancia con l'EA del duello.
