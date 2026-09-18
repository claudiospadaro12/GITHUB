# 🥊 IL DUELLO SUI GEMELLI — **DOW pronto a partire, SPX fermo a una sonda**

**18/09/2026** · branch `lavoro` · richiesta testuale di Claudio:
**«FAI IL DUELLO SUI GEMELLI DOW E SPX»**
🚫 **Niente è stato lanciato.** MT5 sta sulla macchina di Claudio: qui si
preparano le prove e si congelano i criteri.

---

## 🎬 IN TRE RIGHE

1. 🟢 **Sul DOW il duello è pronto**: sette file prova generati
   meccanicamente, criteri congelati, magic vergini, cancello strato 1
   superato. **~15 minuti di macchina** (stima con base dichiarata).
2. 🔴 **Su SPXUSD il duello NON PARTE**, e la ragione non è pigrizia: **sul
   motore delle aperture, su SPXUSD, non esiste NEMMENO UNA RIGA in tutto il
   repo**, e la profondità dei **tick reali** di quel simbolo non è mai stata
   misurata. Prima la sonda, poi il duello.
3. 🎁 **Due regali trovati dal censimento**, che nessuno aveva scritto: il
   **PASSO 0 di R83 sul Dow è già risolto** (68,5 milioni di tick dal
   2024.09.26, `COMPLETO`), e **la famiglia a DUE LATI porta il campione sopra
   il pavimento dei 150**, cosa che solo-long non può fare su questa finestra.

---

## 1. 🔎 IL CENSIMENTO — meccanico, non a memoria

Strumento nuovo, riusabile: **`backtest_pipeline/censimento_entrymode.py`**.
Legge **2.376 CSV**, ne trova **368 con la colonna `InpEntryMode`**, e attribuisce
il simbolo **dal nome del file**, mai dal contenuto.

### 1a. 🪤 IL FALSO POSITIVO CHE HO COSTRUITO APPOSTA PER ROMPERE LA MIA RISPOSTA

`grep SPXUSD` sui CSV **risponde SÌ in decine di file.** Se mi fossi fermato lì
avrei scritto «SPX è già stato misurato». **È FALSO**: in tutte quelle righe
`SPXUSD` è il valore della colonna **`InpCorrSymbol`** — il simbolo del *filtro
di correlazione* — e quel filtro è per giunta **SPENTO** (`InpUseCorrelation=0`).
Non è il simbolo negoziato.

👉 Per questo lo strumento ricava il simbolo dal **nome del file**, e il limite
è dichiarato dentro lo script: i CSV che non hanno il simbolo nel nome restano
fuori dal conteggio, e la copertura è stampata come numero.

### 1b. 🪤 LA SECONDA TRAPPOLA: **`InpEntryMode` NON SIGNIFICA LA STESSA COSA NEI DUE EA**

| valore | `ABTG_Dow_Apertura_US` (`ENUM_ABTG_ENTRY`, r.170-178) | `ABTG_Apertura_3Ingressi` (`ENUM_ABTG_STYLE`, r.199-204) |
|---|---|---|
| **0** | BREAKOUT (stop) | STOP (= BREAKOUT) |
| **1** | GAPFILL | **LIMIT sul retest** (= RETEST) |
| **2** | **RETEST** | **MARKET alla chiusura** (= CLOSECONFIRM) |

Il ponte è in `ABTG_Apertura_3Ingressi.mq5` **r.561-565**.
🔴 **Quindi `InpEntryMode=2` sul Dow vivo È il retest, cioè la modalità `1` del
duello.** Chi copia il numero invece del significato misura un'altra strategia
e non se ne accorge: è la trappola n.1 di questo round, ed è scritta nei
criteri e in testa a ogni file prova.

### 1c. 📋 U30USD — la tabella completa di ciò che esiste

| modalità (semantica) | misurata? | dove | n | PF | DD |
|---|---|---|---|---|---|
| **BREAKOUT (stop)** | ✅ SÌ | `Apertura_nuovi_indici/valid_Apertura_U30USD_Dow.csv` (96 celle) · `Nasdaq_Apertura/apert_US_M5_doc_brk_realtick_U30USD.csv` (143 celle) | fino a 471 · 106-113 | max **0,997** · 1,106-1,214 | fino a **15,7%** · 10,9-13,8% |
| **RETEST (limit)** | ✅ SÌ, **6 corse** | `r6` · `r35` · `r46b` · `r47c` · `r47d` · `ptc` · `csv_r54` | IS 56-150 / OOS 96-218 | IS 0,77-1,38 / **OOS 1,01-1,68** | 2,5-9,9% |
| **CLOSECONFIRM (market a chiusura)** | 🔴 **MAI** | — | — | — | — |
| FADE | ✅ SÌ | `apert_fade_realtick` | 324 | **0,806** | **19,7%** |
| DELAYED | ✅ SÌ | `apert_US_M5_doc_delay_realtick_U30USD.csv` (157 celle) | 2-168 | max **0,978** | fino a **24,3%** |

✅ **La premessa della richiesta è CONFERMATA e va completata**: il retest sul
Dow è misurato in 6 corse (non 5), l'OOS è positivo in tutte, e **la modalità
mai girata è la CLOSECONFIRM**. Ma — ed è il punto — **manca soprattutto il
CONFRONTO AD ARMI PARI**: quelle sei corse hanno finestre, filtri, griglie e
scopi diversi fra loro. Non sono un duello: sono sei round scollegati.

### 1d. 🔴 SPXUSD — il verdetto secco

Filtrando per **simbolo negoziato**, su SPXUSD esistono **solo** due scansioni
di `ABTG_GoldenCross` (H1 e H4, `InpEntryMode` sempre 0 e inerte per quell'EA).

> ## 🔴 **Sul motore delle aperture, su SPXUSD, ZERO righe in tutto il repo.**

### 1e. 📜 IL VERDETTO SCRITTO CHE ORDINA QUESTO ROUND

`REGISTRO_TEST.md`, sezione **R83** (il duello già girato su NASUSD e D30EUR),
riga 3412:

> 📌 **«Regola che ne esce, ed è generale: *ogni estensione a un altro indice
> RIFÀ il duello, non eredita il RETEST*.»**

Ed è misurato che serve: **la stessa regola d'ingresso cambia SEGNO fra i due
mercati** — DAX retest **OOS PF 1,188** (l'unica cella positiva in entrambe le
finestre), Nasdaq retest **OOS PF 0,624 con DD 29,14%**, il peggiore dei tre.
**Il Dow non può ereditare né l'uno né l'altro.**

---

## 2. 🎁 I DUE REGALI DEL CENSIMENTO

### 2a. 🟢 IL **PASSO 0 DI R83 SUL DOW È GIÀ RISOLTO** — e nessuno lo aveva scritto

R83 §3 dichiarava: *«la profondità dei TICK REALI degli indici a BCM non è mai
stata misurata»*. **Oggi sul Dow e sul DAX lo è**, e il file è in repo:

```
backtest_pipeline/risultati_archivio/ABTG_StoricoScaricato.csv   (commit 70b289d5, 08/09/2026)
  D30EUR,TICK,35496307,2024.09.26,-,COMPLETO
  U30USD,TICK,68558736,2024.09.26,-,COMPLETO
```

✅ **R180 gira a tick reali su tutta la finestra, e non è un'assunzione.**
🔴 **NASUSD e SPXUSD non sono in quel file**: per loro il PASSO 0 resta aperto.

### 2b. 🟢 **I DUE LATI PORTANO IL CAMPIONE SOPRA IL PAVIMENTO**

Righe misurate di `r6` (stessa cella, taglio IS/OOS 0,40):

| lati | `InpRangeMinutes` | n IS | n OOS | PF IS | PF OOS | DD IS | DD OOS |
|---|---|---:|---:|---:|---:|---:|---:|
| **solo long** (cella viva) | 35 | **74** | **130** | 1,215 | 1,275 | 5,58% | 4,18% |
| **due lati** | 35 | **147** | **203** | 1,379 | 1,087 | 5,54% | 8,38% |
| due lati | 25 | 150 | 218 | 1,132 | 1,202 | 9,07% | 9,74% |

🔴 **Solo long, il pavimento dei 150 è IRRAGGIUNGIBILE su questa finestra**:
74+130 = **204 operazioni in tutto**, a qualunque taglio.
🟢 **Due lati: 147+203 = 350 operazioni**; a taglio **0,50** le due metà valgono
**~175 e ~175**, **sopra il pavimento tutte e due**.

👉 Per questo il round ha **DUE FAMIGLIE**, e la scelta è dichiarata prima dei
numeri — non aggiustata dopo.

---

## 3. 🧬 COSA HO PREPARATO — sette celle

| cella | file prova | famiglia | `InpEntryMode` | motore vero | magic |
|---|---|---|---|---|---|
| **u0** | `R180u0_stop_U30USD.txt` | L solo long | 0 | BREAKOUT | 777410/777411 |
| **u1** | `R180u1_limit_U30USD.txt` | L solo long | 1 | RETEST — **= sedia viva** | 777420/777421 |
| **u2** | `R180u2_conferma_U30USD.txt` | L solo long | 2 | **CLOSECONFIRM — mai girata su U30USD** | 777430/777431 |
| **u0b** | `R180u0b_stop_U30USD.txt` | B due lati | 0 | BREAKOUT | 777440/777441 |
| **u1b** | `R180u1b_limit_U30USD.txt` | B due lati | 1 | RETEST | 777450/777451 |
| **u2b** | `R180u2b_conferma_U30USD.txt` | B due lati | 2 | CLOSECONFIRM | 777460/777461 |
| **uV** | `R180uV_canarino_vivo_U30USD.txt` | canarino | **2** (enum dell'EA **VIVO**) | **EA `ABTG_Dow_Apertura_US`** | 777490/777491 |

**Il numero del round è R180, non R141**: `R141` è già occupato da cinque file
prova (`R141a_momentum_NASUSD_r12.txt` … `R141e_daxva_buffer_M15_D30EUR.txt`).
Il numero più alto usato nel repo è R179.

### 🔴 MAGIC VERGINI — il comando e il risultato

```
for m in 777410 777411 777420 777421 777430 777431 \
         777440 777441 777450 777451 777460 777461 777490 777491; do
  grep -rIl --exclude-dir=.git --exclude-dir=.claude -w "$m" . | wc -l
done
```
**0 file per tutti e quattordici.** Eseguito prima di scrivere i file prova, e
il comando è ricopiato **dentro ogni file prova**.

---

## 4. 🧪 IL CONTRO-ESEMPIO — costruito prima, ed eseguito

**Se il round NON misurasse quello che promette**, le celle differirebbero in
qualcosa oltre l'ingresso. Non è una promessa: **i sei file non sono scritti a
mano**, li genera `backtest_pipeline/prove/R180_GENERA.py` da **una sola**
struttura di parametri. La verifica:

```
diff <(grep -v '^#' R180u0_stop_U30USD.txt) <(grep -v '^#' R180u1_limit_U30USD.txt)
  17c17  InpEntryMode=0 -> 1        89c89  InpMagic
diff <(grep -v '^#' R180u1_limit_U30USD.txt) <(grep -v '^#' R180u2_conferma_U30USD.txt)
  17c17  InpEntryMode=1 -> 2        89c89  InpMagic
diff <(grep -v '^#' R180u1_limit_U30USD.txt) <(grep -v '^#' R180u1b_limit_U30USD.txt)
  5c5 @FRAZIONEIS 0.40 -> 0.50   25c25 InpAllowShort=0 -> 1   89c89 InpMagic
```

✅ **DUE sole differenze dentro una famiglia. TRE fra le famiglie. Nient'altro.**

### 4a. ⚠️ I PARAMETRI CHE DEVONO PER FORZA DIVERGERE — dichiarati

| cosa | cella viva `770202` | qui | perché |
|---|---|---|---|
| `InpRiskPercent` | 0,65% (100k) | **1,0%** | convenzione di banco: si confrontano MOTORI, non TAGLIE. Il DD a 0,65% resta un **APPROSSIMATO lineare** |
| `InpUsaGuardian` | true | **l'input NON ESISTE** nell'EA del duello | nel canarino l'EA vivo gira col Guardian **spento** apposta |
| `InpVerbose` | true | false | non serve a nessun cancello qui |
| `InpRetestOffsetPts=400` | attivo | scritto in tutte e sei, **agisce solo in modalità 1** | 🟠 **asimmetria strutturale**: il retest ha una manopola che le altre due non hanno, e non si può togliere senza smettere di misurare la cella viva |
| `InpMinStopPts=500`, `InpSkipIfTight=false` | valori vivi | **scritti a mano** | 🔴 **NON sono i default del sorgente** (0 e `true`): senza queste due righe si misurerebbe un'altra strategia |
| `InpTP1_R=1.0`, `InpTP1_ClosePct=50` | valori vivi | **scritti a mano** | 🔴 idem (default 0,5 e 0). È **esattamente** la classe di errore che il progetto ha già pagato due volte |

🔴 **E la divergenza da R83 che va detta forte: qui il filtro EMA è ACCESO**
(1/50 su H4), perché **è la cella viva del Dow**. In R83 tutti i filtri erano
spenti. Conseguenza onesta: **R180 e R83 non si sommano riga per riga.**

---

## 5. 🐤 I CANARINI

- **(b) VINCOLANTE** — `uV` (EA **vivo**, `RETEST`) contro `u1` (EA del duello,
  modalità 1): stessi Profit, PF, Trades, DD. 🔴 **Se non coincidono, il round
  si FERMA.** 🟢 Precedente che dà fiducia: in R83 i canarini sui due core
  coincisero **al centesimo** (291/291 e 311/311 trade identici).
- **(c) NON vincolante** — `u1` dovrebbe atterrare vicino alla riga `r6`
  (IS n=74 PF 1,215 · OOS n=130 PF 1,275). ⚠️ **Modello e deposito della corsa
  `r6` non sono registrati da nessuna parte**: la parte robusta è il **numero di
  operazioni**, non il PF.
- **(d)** `InpAutoTest=1`: le righe `[3ING][AUTOTEST]` le produce
  **un'ESECUZIONE**, non il tasto F7 (difetto n.20 della checklist).

---

## 6. 🔭 SPXUSD — LA SONDA, e perché il duello non parte

Criteri congelati in **`backtest_pipeline/prove/R185_SONDA_SPXUSD_CRITERI.md`**.

| domanda | risposta oggi |
|---|---|
| BCM quota SPXUSD? | ✅ SÌ |
| profondità **BARRE** | ✅ **2024.09.26**, `COMPLETO` (sonda 17/08) |
| profondità **TICK REALI** | 🔴 **MAI MISURATA** |
| **specifiche di contratto** (lotto min, valore punto, spread) | 🔴 **MAI MISURATE** |
| motore delle aperture su SPXUSD | 🔴 **ZERO righe** |

Le **tre domande** con i cancelli già congelati: **Q1 tick** (PASS / PARZIALE
con finestra riscritta / FAIL → solo OHLC dichiarato come screening, mai
verdetto), **Q2 pavimento del lotto** (se il lotto minimo rischia più dell'1%,
PF e DD descrivono una taglia che non esiste — classe 229), **Q3 frontiera del
costo `stop ≥ 40 × spread`** (se M5 la sfonda, si dichiara escluso **per costo,
col numero accanto**, e il duello si riscrive su M15/M30).

📌 **`SPXUSD_EXT` esiste** (M1 2010→2026, import del 26/08) ma **non serve qui**:
è OHLC, è un altro simbolo, ed è marcato *«solo prova di regime»*.

🎁 **Proposta, non fatto compiuto**: nella stessa corsa sondare **anche
NASUSD** — i suoi tick non sono mai stati misurati ed è il **PASSO 0 ancora
aperto di R83**. 🟠 Costa: i tick sono pesanti (U30USD ne ha 68,5 milioni).

🔴 **E l'avvertenza che vale una challenge**: `scarica_storico.ps1 -Auto`
**senza** `-TerminaleBacktest` **chiude TUTTI i terminali**, compreso il **conto
REALE 10105439 con posizioni aperte**. Sul VPS è **obbligatorio**
`-TerminaleBacktest "C:\MT5_Backtest"` (demo **50504400**).

---

## 7. ⏱️ IL COSTO — **è una STIMA, e la base è dichiarata**

**R180**: 7 file × 2 celle × 2 finestre = **28 passate**.

| base MISURATA | ritmo | 28 passate |
|---|---|---:|
| **R88a** (tick reali, M5, 21 mesi — 96 passate in 8,0 min) | 0,083 min/passata | **~2,3 min** |
| **R112** (stesso EA/simbolo/finestra/modello, 8 avvii di terminale) | 0,375 min/passata | **~10,5 min** |

👉 **Banda 2,3–10,5 min; per pianificare si usa 15 minuti** (R180 ha 7 avvii).
🔴 **[NON MISURATO]**: la costruzione della **cache tick** al primo avvio su
U30USD (**68,5 milioni di tick**). Se la cache non c'è già, il primo avvio può
costare più di tutto il resto. Si misura al primo giro.

**R185 (sonda SPX)**: **30-180 min per simbolo, [NON MISURATO]**. Base: l'`.ini`
di R83 prescrive `-TimeoutMin 180` per due simboli; la corsa dell'08/09 ha
scaricato 104 milioni di tick in una notte **senza cronometro registrato**.

---

## 8. 🛑 CHE COSA QUESTO ROUND **NON** PUÒ MISURARE — per nome

1. 🔴 **La robustezza di regime.** 21 mesi, **un regime e mezzo**. Niente 2020,
   niente 2022 — e non è una scelta: **BCM non ha di più** sugli indici.
2. 🔴 **Il pavimento dei 150 sulla famiglia L**: **non lo supera**, atteso
   **74 IS / 130 OOS** (misurato). La famiglia B lo supera **atteso ~175/175**,
   ⚠️ **ma solo sulla modalità RETEST**: per la 0 e la 2 il numero di
   riempimenti **è esattamente ciò che il round deve misurare**, quindi **non è
   predicibile** e può cadere sotto 150. Se succede, quella cella nasce col
   merito sospeso — è un risultato, non un fallimento.
3. 🔴 **Lo slippage.** `InpSlippagePts=0`, e nel motore lo slippage peggiora
   **solo gli ordini STOP**: **la modalità 0 è avvantaggiata**. Se vince la 0,
   la vittoria ha **l'asterisco**.
4. 🔴 **Lo spread di una prop vera, i requote, i rifiuti**: fuori dal tester.
   Lo stress a scala è **collaudo**, non questo round.
5. 🔴 **Il confronto riga per riga con R83** (filtri spenti lì, EMA accesa qui).
6. 🔴 **SPXUSD**, finché la sonda non risponde.

---

## 9. ✅ CANCELLO STRATO 1 — superato

```
python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/R180u*.txt
  7 file | 14 celle | 28 passate | problemi: 0 | ESITO: OK
```

🔴 **Trappola trovata mentre lo verificavo, e vale la pena scriverla**: se si passa
un solo `--ea` su tutto il gruppo, lo strumento risponde **FALLITO** con
*«input SCONOSCIUTO all'EA: InpUsaGuardian»*. **Non e' un difetto dei file**: sei
celle girano su `ABTG_Apertura_3Ingressi` e la settima (`uV`) sull'EA **vivo** del
Dow, che ha quell'input. Senza `--ea`, lo strumento deduce l'EA dalla riga
`#  EA: <nome>` in testa a ogni file e li giudica tutti correttamente.
⚠️ **Lo stesso vale per il driver: `uV` non si lancia con l'EA del duello.**
Verifica in più, fatta a parte: **ogni nome di input dei sette file esiste
davvero nell'EA di destinazione** (zero nomi sconosciuti — un nome inesistente
MT5 lo ignora **in silenzio**), e gli input non pinnati sono **solo** quelli
inerti (filtro notizie spento, leve R30 spente, `InpCorrSymbol` col filtro
spento), **col default del sorgente identico al valore della cella viva**.

🔴 **Manca ancora lo strato 2** (agente `controllo-preventivo`) sulla **riga di
lancio**, che qui non è stata scritta: si scrive quando Claudio dice quale
macchina usa, e passa dal cancello **prima** di partire.

---

## 10. 🎯 DOVE SIAMO, rispetto al 1° OTTOBRE

Questa è **preparazione**, non una sedia in più: va detto. 🟢 Ma è preparazione
che **toglie un'incognita a una sedia che esiste già** — `770202` gira in campo
col retest, **e nessuno ha mai verificato che il retest sia la scelta giusta
SU QUEL MERCATO**. R83 ha dimostrato che su un altro indice la stessa scelta
era **la peggiore delle tre, con DD 29%**. Quindici minuti di macchina per
sapere da che parte sta il Dow sono quindici minuti ben spesi. 💪
