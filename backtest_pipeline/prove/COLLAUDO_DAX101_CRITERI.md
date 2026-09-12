# CRITERI CONGELATI — COLLAUDO PROP di `770101` `ABTG_DAX_Apertura_EU` D30EUR M5 LONG

**Scritto il 12/09/2026, e committato PRIMA del file prova e PRIMA di qualunque
numero di tick reali della scala di spread.** Questo file e' il metro: se il
verdetto del referto non si legge contro queste righe, non e' un collaudo.

---

## 0. LA CELLA ESATTA, senza scorciatoie

| | |
|---|---|
| EA | `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` |
| simbolo · TF · lato | `D30EUR` · **M5** · **LONG ONLY** (`InpAllowShort=false`) |
| magic di provenienza | **770101** (sedia viva sul demo `50503392`) |
| preset vivo | `mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set` |
| referto di validazione | `backtest_pipeline/risultati_prove/aperture_r47/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_r47{a,b}.csv` (tick reali, Modello 4, deposito 100.000, rischio 1,0%) |
| dossier che la promuove | `report/LA_SECONDA_SEDIA_2026-09-12.md` |
| banco | `Modello 4` = **TICK REALI**, deposito **100000**, rischio **1,0** (pinnato, come R47), finestra **2024.09.26 → 2026.06.30**, `FrazioneIS 0,40` |

**Le due celle sotto collaudo, e sono due perche' la firma e' aperta:**

| | `InpTP1_ClosePct` | PF OOS | DD OOS | posizioni OOS | peggior giornata (equity, dall'EA) |
|---|---:|---:|---:|---:|---:|
| **VIVA** | **50** | 1,39709 | 7,2328% | 193 | **−1,0780%** |
| **REGALO** | **0** | 1,49140 | 6,2719% | 193 | **−1,0793%** |

Tutto il resto identico, verificato input per input (`report/LA_SECONDA_SEDIA_2026-09-12.md` §3.4).

---

## 1. LA SCALA DI STRESS, completa

### A. SPREAD (il gradino che decide — a tick reali, riga `Spread=` dell'`.ini`)

Base **MISURATA**, non stimata: `backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_D30EUR.csv`,
**30.974.789 tick**, ora **SERVER**. L'ora di lavoro del motore e' l'apertura
europea: `InpSessionHour=8` (= 09:00 italiane).

| ora server | mediana idx | p95 idx | max idx |
|---:|---:|---:|---:|
| **08** (l'ora del motore) | **1,70** | **2,70** | 12,0 |
| 09 | 1,70 | 1,90 | 11,9 |
| 10 | 1,70 | 1,90 | 11,9 |

Contro-verifica sull'ora vera d'ingresso: in forward il riempimento del BUY LIMIT
di retest cade alle ore **8 (19 volte su 35)**, 9 (8), 10 (2), poi 12/13/16 (2+2+2)
— `data/statements/trades_auto.csv`, magic 770101. Mediana pesata su quelle ore:
**1,689 idx**. 👉 **la base 1,70 e' la piu' pessimista delle tre ore principali** e
si usa quella.

**Conversione dichiarata: 1 punto indice = 100 punti MT5** (`ABTG_SpreadOrario.mq5` r.57,
valida sui tre indici). Quindi i gradini della riga `Spread=` sono:

| gradino | spread idx | **`-Spread`** (punti MT5) |
|---|---:|---:|
| **base** (tick registrati) | 1,70 | **0** (= spread corrente, dichiarato agli atti) |
| **+25%** | 2,125 | **213** (2,125 × 100, arrotondato) |
| **+50%** | 2,55 | **255** |
| **+100%** | 3,40 | **340** |

🚦 **E prima dei gradini il CANARINO, che e' lo stesso file girato due volte**
(`-Spread 0` contro `-Spread 99999`) su una tranche unica che copre l'OOS.
Motivo: **non e' misurato che MT5 onori la riga `Spread=` a Modello 4** — e lo
dice il driver stesso a schermo (`walkforward_generico.ps1` r.950-955).
👉 **Se K1 == K2 alla cifra, la riga e' IGNORATA e la PROVA A e' MORTA: si
scrive «non misurabile», MAI «robusta allo spread».**

### B. SLIPPAGE / LATENZA — post-processing, e con un limite che cambia il modello

🔴 **La scala di casa «peggiora ogni INGRESSO A MERCATO di N punti» NON E'
APPLICABILE a questa cella, e non e' un'omissione: e' un fatto di codice.**
`InpEntryMode=2` (`ABTG_RETEST`) entra con **`BuyLimit`** — `ABTG_DAX_Apertura_EU.mq5`
r.1504. Un ordine LIMIT non si riempie *peggio* per latenza: si riempie **al
prezzo o meglio**, oppure **non si riempie**. Peggiorare il prezzo d'ingresso
modellerebbe una cosa che non esiste.

👉 Quindi la scala di latenza si applica **all'USCITA** (lo stop e' un ordine di
mercato quando scatta), su **ogni posizione**, in **punti indice**:
**0 / 1 / 2 / 5 idx**. La scala e' in punti INDICE e non MT5 perche' lo
sforamento **gia' misurato** nei per-trade e' di quest'ordine (mediana 0,28 idx,
p90 3,23 idx, max 6,41 idx su 15 posizioni delle 193 che perdono piu' di 1 R).

**[APPROSSIMAZIONE DICHIARATA]** non modella requote, rifiuti, slippage
favorevole, ne' il **cambio di selezione** (con lo spread piu' largo un LIMIT si
riempie in giorni diversi). E' una stima **pessimistica controllata**, non una
simulazione. Il pavimento vero e' quello del tester; il reale puo' solo essere
peggio (`misura_slippage.py`, riga dei limiti).

### C. COMMISSIONI E NOTTE

- **Commissione: 0,00 — MISURATA, non assunta.** `data/statements/trades_auto.csv`,
  magic 770101 su D30EUR: **35 posizioni su 35 con `commission = 0.00`**; e su
  **tutti** i magic degli indici del conto (237 posizioni fra D30EUR e U30USD)
  il valore distinto e' **uno solo: 0.00**. 👉 La regola `0,004% del nozionale in
  valuta base` e' scritta per le **coppie** e qui **non si usa**: il pedaggio
  all-in di questa sedia **e' lo spread e nient'altro**.
- **Swap: 0,00 — e per COSTRUZIONE, non per fortuna.** `InpCloseHour=17`
  `InpCloseMin=30` `InpCloseAtEnd=true`: la sedia e' piatta prima della
  mezzanotte. Misurato: **0 posizioni su 35 tenute oltre la mezzanotte**.
  ⚠️ Che lo strumento sappia addebitare swap e' provato dallo **stesso file**:
  D30EUR con `magic 0` (operativita' non-EA) porta swap **−12,34 / −4,80 / −3,33**.
  👉 Lo swap di questa sedia e' zero **perche' non dorme**, e se qualcuno le
  spostasse `InpCloseHour` cambierebbe anche questo.
- 🔴 **Il profilo commissioni della PROP VERA e' `[NON MISURATO]`.** Nessuna
  scheda di cacciatore in `caccia_strategie/` porta un profilo commissioni
  firmato per la prop scelta. Qui si collauda contro **BCM**, e va detto.

---

## 2. LE SOGLIE DI SOPRAVVIVENZA — congelate adesso

Metro: i muri firmati il 18/08 (`report/FIRME_2026-08-18.md`) — pausa **4,0%**,
emergenza giornaliera **4,9%**, emergenza totale **9,9%**, cap rischio aperto
**C1 3,25%**; e il pavimento di casa `PF >= 1,10`.

### S1 — PASS (la sedia regge le condizioni peggiori)
Al gradino **+50% di spread**, **tutte e quattro** le condizioni, sulla finestra **OOS**:
1. **profitto > 0** e **PF >= 1,10**;
2. **DD di equity <= 8,0%** (il contratto in essere e' 7,2328%; il muro e' 9,9%: 8,0% lascia 1,9 punti di margine a un solo seggio);
3. **peggior giornata di equity >= −2,50%** (la meta' del muro giornaliero del 5%, e piu' che doppio del −1,0780% misurato);
4. **posizioni OOS >= 150**.

### S2 — FRAGILE
Passa tutte e quattro a **+25%** ma **non** a **+50%**. Allora il referto scrive
**quanto margine reale** ha, **in punti indice di costo extra per posizione**, e
la decisione passa a Claudio. **Non e' una bocciatura e non e' una promozione.**

### S3 — BOCCIATO
Una sola di queste basta:
- il **segno si ribalta** (profitto <= 0) gia' a **+25%**;
- il **DD di equity supera 9,9%** in **qualunque** gradino della scala;
- la **peggior giornata di equity supera −4,9%** in qualunque gradino;
- le posizioni OOS scendono **sotto 150** a qualunque gradino (qui varrebbe come
  fatto di forma: a spread forzato la selezione **puo'** cambiare).

### S4 — LA VALVOLA DI CASA, che non si tocca
**Il campione sottile sospende il giudizio sul MERITO, mai sul RISCHIO.** Un DD
accaduto vale a qualunque `n`. Quindi: un gradino con poche posizioni non puo'
**promuovere**, ma puo' **bocciare** sul DD e sulla peggior giornata.

### S5 — LA FRONTIERA DEL COSTO, ricalcolata a OGNI gradino
Pavimento di **lavoro 40x**, pavimento **DURO 13,3x**. Si dichiara, per ogni
gradino: il rapporto sulla **mediana** dello stop **e** la **quota di posizioni
sotto 13,3x**. 🔴 **Una quota sopra 13,3x che nasconde un quinto delle posizioni
sotto il DURO non e' un PASS di costo**: il duro si legge sul **minimo**, non
sulla mediana.

### S6 — IL REGALO (`InpTP1_ClosePct` 50 → 0) si giudica SOLO cosi'
Si raccomanda la manopola a 0 **se e solo se** batte la 50 su **PF E DD E
peggior giornata** in **tutti e quattro** i gradini della scala. 🔴 **Se si
invertisse a un solo gradino, la raccomandazione cade** — ed e' esattamente il
contro-esempio che va costruito, perche' chiudere il parziale a 0 tiene la
posizione intera piu' a lungo.

### S7 — QUELLO CHE QUESTO COLLAUDO NON COPRE, e va riscritto nel referto
requote · rifiuti d'ordine · l'esecuzione della **prop vera** · la **prova di
regime** (21 mesi BCM su D30EUR, stato `COMPLETO`: **un solo toro**) · lo spread
**al minuto** dentro l'ora 08 (l'istogramma e' orario, e l'ora 08 e' l'apertura:
i rapporti sono **ottimisti per costruzione**).

---

## 3. IL DECISO IN ANTICIPO, per ciascun esito

| esito | decisione **dichiarata adesso** |
|---|---|
| **PASS** a +50% (e sopravvivenza a +100%) | La sedia e' **schierabile il 1 ottobre** sul piano del costo. Resta `[FIRMA DI CLAUDIO]` la taglia. |
| **PASS** a +50% ma **cedimento a +100%** | Schierabile **con il numero del margine scritto accanto**: si dichiara a quale spread muore, e Claudio decide se il broker prop ci arriva. |
| **FRAGILE** (S2) | **Non va in campo il 1 ottobre come seconda sedia.** Si consegna il margine e la proposta di riparazione (candidata nominata: `InpMaxSpread`, che oggi vale **0** = nessun limite). |
| **BOCCIATO** (S3) | **Raccomandazione di NON schierarla**, col gradino e il numero. 🛑 Nessuno spegnimento automatico: la sedia in forward non si tocca. |

🛑 **A10 — questo collaudo non promuove niente**, non cambia un preset, non
accende una sedia, non tocca il forward, non nomina il conto reale. **Taglie e
parametri di rischio sono di Claudio**: qui si misura e si propone.
