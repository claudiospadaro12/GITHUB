# ⚖️ R90 — LA PROVA DI REGIME DELLO STOP LARGO (ORB · U30USD) — **BOZZA DA FIRMARE**

> ## ✍️ FIRMA DI CLAUDIO: ______________________  data: ____/____/2026  ora: ______
>
> **Finche' questa riga e' vuota, i numeri di R90 non si guardano.**
> Il round non si lancia, e se qualcuno lo lancia lo stesso i CSV restano
> sigillati come la notte del 19/08.

---

## 0. 🕶️ DICHIARAZIONE DI CIECO — cosa sapevo quando ho scritto questo file

_Scritto il **20/08/2026, mattina** (ora italiana; **ora server BCM = ora
italiana − 1**), dall'architetto, su richiesta di Claudio ("facciamo C e poi
A", cioe' **prima la prova di regime, poi la finestra**)._

| cosa | lo so? |
|---|---|
| I numeri di **R90** (le quattro finestre di regime) | ❌ **NO. Non esistono: nessuna passata e' girata, e i dati su cui girera' non sono nemmeno stati scaricati** (§3.3). |
| I numeri di **R88** (tick reali, finestra 2024-2026) | ✅ **SI', e sono agli atti**: `REFERTO_ROUND88_ORB_MIGLIORAMENTO.md`, CSV in `r88_csv/`, commit `72e94b1`. |

### 🤝 La promessa di onesta', e qui va detta al contrario del solito

**Le due celle di R90 NON sono state scelte da un'esplorazione nuova: sono
state scelte da R88, cioe' guardando dei numeri.** Non lo nascondo, perche' e'
esattamente il punto debole di questo round e va scritto prima:

- la cella **stop largo** e' la riga che in R88 ha fatto il DD piu' basso in
  entrambe le finestre (4,78% e 3,84%). L'ho scelta **dopo** aver visto quel
  numero;
- quindi R90 **non e' una scoperta**: e' una **prova di falsificazione** di un
  fatto gia' misurato in un regime solo. La domanda non e' *"quale cella e' la
  piu' bella?"* (a quella non si puo' piu' rispondere in cieco), ma *"il
  vantaggio gia' visto **sopravvive** dove non e' stato trovato?"*;
- per questo **la griglia e' vietata**: due celle, parametri congelati, zero
  ottimizzazione. Se in R90 si spazzolasse un asse, si starebbe cercando la
  cella bella nei dati vecchi — cioe' il curve fitting con piu' anni
  (`PROVA_REGIME_CRITERI.md` §1: *"vietato cercare parametri nuovi sui dati
  vecchi"*).

📌 E c'e' un motivo strutturale che rende la scelta meno arbitraria di quanto
sembri: la cella stop largo **non e' una cella nuova**, e' la regola del corso
(ToolKit ABTG §5.1, stop all'estremo opposto del range) e la cella che **R15
aveva gia' visto nel 2026** (OOS PF 1,68 · DD 4,1%) e scartato per un cancello
di merito sulla finestra vecchia. Tre incontri indipendenti con lo stesso
oggetto, non un pescaggio.

---

## 1. 🎯 LA DOMANDA DEL ROUND — una sola

> ### **Lo stop largo tiene il drawdown basso in TUTTI i regimi, o solo nel toro 2024-2026?**

Il fatto da cui si parte, **misurato** (R88, U30USD, **tick reali**, M5,
deposito 100.000, rischio 1%, slippage 0):

| cella | IS 2024.09.26→2025.06.09 | | | | OOS 2025.06.10→2026.06.30 | | | |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| | **PF** | **DD** | profit | **n** | **PF** | **DD** | profit | **n** |
| **SEDIA VIVA** `SLMode=3` buf 0 · TP range 1,5 | 1,250 | **7,8885%** | +9.509,39 | **71** | 1,6742 | **9,7623%** | +41.057,00 | **119** |
| **STOP LARGO** `SLMode=0` buf 500 · TP in R 1,5 | 1,063 | **4,7839%** | +1.190,21 | **71** | 1,8385 | **3,8395%** | +23.003,35 | **119** |

_(fonte riga per riga: `r88_csv/ABTG_ORB_Ottimizzato_U30USD_IS_r88a.csv` e
`..._OOS_r88a.csv`, colonne `Equity DD %` e `Trades`. Il **n della cella stop
largo non era nel referto R88**: l'ho estratto dai CSV per scrivere questo
file, ed e' **identico** a quello della sedia viva — vedi il canarino §7.1.)_

**Il vantaggio esiste in due finestre indipendenti. Ma sono lo stesso
regime**: Dow 2024-2026, prevalentemente rialzista (R14: *"vento di regime
long"*). La regola C dell'Emendamento della Finestra dice esattamente cosa
manca: **la prova di regime batte la storia contigua**. Questo e' quel round.

### 🔪 La falsificazione, scritta prima

> **Se in anche UNA sola delle quattro finestre di regime lo stop largo fa un
> drawdown PEGGIORE della sedia viva, la tesi cade**: il DD basso non sarebbe
> una proprieta' della geometria dello stop, ma una proprieta' del toro
> 2024-2026 — e allora **R90 non propone niente**, si scrive a referto quale
> regime l'ha smontata, e la sedia resta com'e'.

---

## 2. 🧊 LE DUE CELLE — congelate, copiate, non scelte qui

Ogni input e' **copiato** da `prove/R88a_stoplargo_U30USD.txt` (corpo pinnato)
e dalle due righe CSV qui sopra. **Vietato cambiarne uno.**

| | SEDIA VIVA (`ORB_VIVA`) | STOP LARGO (`ORB_LARGO`) |
|---|---|---|
| `InpSLMode` | **3** (HALFRANGE, 50% del range) | **0** (OPPRANGE, estremo opposto) |
| `InpSLBufferPts` | **0** | **500** (= **5 punti indice**: 100 punti MT5 = 1 punto indice su U30USD, misurato R55) |
| `InpTPMode` | **1** (TP in multipli del RANGE) | **0** (TP in **R** sullo stop) |
| `InpTPRangeMult` | **1.5** | 1.5 *(inerte con TPMode=0)* |
| `InpTP_R` | 1.5 *(inerte con TPMode=1)* | **1.5** |
| tutto il resto | **identico**: OR 14:30-14:45 server, solo long, EMA200 on, tetto range 0,8%, trailing EMA9, TP1Pct=0, fine giornata 21:00, rischio 1%, slippage 0 | **identico** |

⏰ **Orari, sempre nei due fusi**: il range e' **14:30 → 14:45 ORA SERVER BCM**
= **15:30 → 15:45 ora italiana**; fine giornata **21:00 server = 22:00 IT**.
Il fuso d'origine della regola e' l'**apertura di Wall Street (09:30 New
York)**. Nei file prova gli orari sono in **ora server**, come sempre.

⚠️ **Il rischio pinnato e' 1,00%, che NON e' la taglia di campo** (in campo la
sedia 770611 gira a **0,3%**). E' il valore comune che rende le celle
confrontabili fra loro e con R15/R54b/R55/R88. Ogni DD di questo round va
letto **a rischio 1%**; il riporto alla taglia di campo e' una proporzione
**[INFERITO]**, non una misura.

---

## 3. 🪟 LE QUATTRO FINESTRE — e perche' NON sono quelle di R50

### 3.1 🔴 Le finestre della macchina esistente NON sono riusabili tali e quali

La macchina delle quattro finestre esiste ed e' collaudata (R50 · R56 · R59 ·
R80, driver `prova_regime.ps1`, criteri `prove/PROVA_REGIME_CRITERI.md`).
**Ma e' stata costruita su altri simboli**, e va detto prima di riusarla:

| fatto | fonte | conseguenza per il Dow |
|---|---|---|
| R50/R56/R59/R80 girano su `GBPUSD_EXT`, `EURUSD_EXT`, `USDJPY_EXT`, `XAUUSD_EXT`… — **8 simboli, tutti forex e oro** | `REFERTO_SONDA_STORICO_17-08.md` §3 | ❌ **nessun indice**: quelle corse non contengono il Dow |
| Le date sono scelte per il **forex** (LATERALE = 2019) | `PROVA_REGIME_CRITERI.md` §3 | ⚠️ 2019 sul **Dow non e' laterale**: e' un toro pieno. Riusare quella data sarebbe **etichettare male un regime**, cioe' rispondere a un'altra domanda |
| U30USD su BCM parte dal **2024.09.26**, stato **`COMPLETO`** | sonda 17/08 | 🔴 **Non e' il muro del nostro disco: e' il muro del broker.** Prima di quella data BCM non ha U30USD **ne' a tick ne' a barre** |

> ### 🎯 Quindi: **le finestre di R50 si RIUSANO per tre quarti** (ORSO,
> CROLLO, TORO: sono regimi macro, e sul Dow descrivono la stessa cosa che
> descrivevano sul forex), **e la quarta si CAMBIA** perche' sul Dow sarebbe
> falsa. La sostituzione e' motivata sotto, ed e' dichiarata **prima** dei
> numeri.

### 3.2 📅 LE QUATTRO FINESTRE DI R90

| # | finestra | date (incluse) | perche' proprio questa, sul **DOW** | da dove viene |
|---|---|---|---|---|
| **a** | 🐂 **TORO** | **2021.01.01 → 2021.12.31** | Dow in salita ordinata per dodici mesi, volatilita' bassa, nessun crollo dentro. E' il regime **piu' simile** a quello in cui il vantaggio e' stato trovato: se lo stop largo vincesse **solo qui**, avremmo la conferma che e' un effetto di regime | **IDENTICA a R50/R56/R59** |
| **b** | 🐻 **ORSO** | **2022.01.01 → 2022.10.31** | il mercato orso vero del Dow: massimo del 4 gennaio 2022, minimo di fine settembre/ottobre, **circa −20%**, inflazione e rialzi dei tassi. E' il buco storico del nostro campione | **IDENTICA a R50/R56/R59** |
| **c** | ↔️ **LATERALE** | **2015.01.01 → 2015.12.31** | **SOSTITUISCE il 2019 di R50.** Sul Dow il 2015 e' l'anno che apre e chiude quasi allo stesso punto oscillando dentro una banda, con il **flash crash di agosto 2015** dentro: e' il regime che fa **whipsaw sull'EMA200**, cioe' il nemico naturale di questa cella. Il 2019, invece, sul Dow e' **+22%**: chiamarlo "laterale" sarebbe una bugia sull'etichetta | 🆕 **NUOVA, proposta qui** (motivazione sopra) |
| **d** | 💥 **CROLLO** | **2020.02.01 → 2020.04.30** | shock Covid: sul Dow e' il crollo piu' rapido della sua storia, con **circuit breaker** e gap. E' la finestra che misura *"quanto puo' farmi male"* | **IDENTICA a R50/R56/R59** |
| **d-bis** | 💥 **CROLLO_ANNO** *(di riserva, si attiva solo se scatta §6.3)* | **2020.01.01 → 2020.12.31** | l'emendamento E.6 del 15/08: tre mesi non fanno campione, l'anno intero si' | **IDENTICA a R59** |

🔎 **Le etichette di regime sopra sono [DICHIARATE], non ri-misurate qui.**
Nessun agente ha rifatto il conto del rendimento del Dow anno per anno dentro
questo file. **Obbligo a referto**: accanto a ogni finestra va scritto il
**rendimento vero dell'indice in quella finestra**, letto dai dati che
useremo. Se un'etichetta non regge al dato (per esempio: se il 2015 sul nostro
feed non risulta laterale), **l'etichetta si corregge e il verdetto di quella
finestra si legge per quello che e'**, non per come l'avevo chiamata.

### 3.3 🗃️ IL TIPO DI DATO — e la conseguenza, scritta PRIMA

> ## 🔴 Nessuna delle quattro finestre e' eseguibile a TICK REALI. Nessuna.
> Il broker non ha il Dow prima del **26/09/2024** (`COMPLETO` = non manca sul
> nostro disco, **non ce l'ha lui**).

| finestra | dato | modello tester | vale per… |
|---|---|---|---|
| TORO 2021 · ORSO 2022 · LATERALE 2015 · CROLLO 2020 | **barre M1 OHLC** importate da **Dukascopy `USA30IDXUSD`** (dati dal **2012**, sonda del 15/08) → simbolo custom **`U30USD_EXT`** | **Modello 1 (OHLC M1)** | ✅ **SOLO il RISCHIO** |
| finestra recente 2024.09.26 → 2026.06.30 | **tick reali BCM** | Modello 4 | ✅ rischio **e** merito — **gia' misurata da R88, NON si rimisura in R90** |

> ### ⛔ LA RIGA CHE VA LETTA DUE VOLTE
> **I numeri delle quattro finestre di regime valgono SOLO per il RISCHIO
> (drawdown), MAI per il merito (PF, profitto).** Non perche' siamo prudenti:
> perche' sono **barre**, e su un breakout intraday su M5 il modello OHLC non
> conosce la sequenza dentro il minuto (stop e target nella stessa barra =
> ordine deciso dal tester, non dal mercato). **[INFERITO]**: per questo motivo
> il DD misurato su OHLC e' plausibilmente **ottimista**. Due conseguenze:
> 1. un DD che **su OHLC** e' gia' brutto, e' **doppiamente** brutto;
> 2. il confronto ha senso solo **RELATIVO, dentro lo stesso feed** (cella
>    contro cella, stessa finestra). **Mai** "OHLC 2015 contro tick 2026":
>    spread, commissioni e modello sono diversi (regola gia' congelata in
>    `PROVA_REGIME_CRITERI.md` §2).

### 3.4 🧱 PREREQUISITI DEI DATI — R90 non si lancia finche' non sono tutti verdi

Nessuno di questi e' stato fatto. Sono tutti cancelli **gia' congelati
altrove**: qui si elencano, non si inventano.

| # | cancello | dove e' scritto | stato |
|---|---|---|---|
| P0 | la **misura della profondita' tick di U30USD** (`scarica_storico.ps1 -Simboli "D30EUR,U30USD" -Timeframes "M1,H1" -Da 2015.01.01 -Auto`) | CODA §4 | ⏳ **in corso**. Se — contro le attese — i tick andassero **piu' indietro** del 26/09/2024, questo file **si riscrive** e si usa il tick per le finestre che ci stanno |
| P1 | `dukascopy_m1.py --autotest` (6/6) e `--validazione` col confronto sul grafico nativo del **16/06/2025** | `REFERTO_DUKASCOPY_FATTIBILITA.md` §4 e §7 | ❌ mai girato su dati veri (la rete e' bloccata dal cloud: **gira sul PC di Claudio**) |
| P2 | import in `U30USD_EXT` con **shift calibrato = +5** (come gli 8 forex). Altro numero → **ci si ferma** | idem §3b e §6 | ❌ |
| P3 | **CANCELLO ZERO**: differenza media ≤ **0,05%** del prezzo e copertura ≥ **80%** sulla sovrapposizione col nativo (26/09/2024 → oggi, ~11 mesi) | `PROVA_REGIME_CRITERI.md` §2 | ❌ |
| P4 | **CANARINO DI RIPRODUZIONE** (lezione R80) — vedi §7.2: **e' il cancello che rende leggibile tutto il resto** | qui | ❌ |
| P5 | il driver `prova_regime.ps1` ha le finestre **scritte fisse** (riga ~70) e **non contiene il 2015**. Serve o un parametro finestra, o un driver dedicato | qui | ❌ **non fatto da questo agente** |

> ⚠️ **P5 non e' un dettaglio.** Se i file di R90 si passassero al driver
> com'e', girerebbero **2019 al posto del 2015** (e anche CROLLO_ANNO senza
> chiederlo): i numeri uscirebbero, avrebbero l'aria giusta, e
> **risponderebbero a un'altra domanda**. E' esattamente il modo in cui un
> round si rovina in silenzio.

---

## 4. 🚪 I CANCELLI NUMERICI — scritti secondo la **regola B**

> **Il VECCHIO giudica il RISCHIO. Il RECENTE giudica il MERITO.**
> (Emendamento della Finestra, regola B, congelato il 16/08.)

### 4.1 🩸 IL RISCHIO — si giudica su **tutte e quattro** le finestre

| # | cancello | soglia | da dove esce il numero |
|---|---|---|---|
| **C1** 🥇 | **CONFRONTO — il cancello centrale del round** | **DD(stop largo) ≤ DD(sedia viva) + 0,10 punti percentuali**, in **OGNI** finestra misurabile | E' la traduzione numerica della domanda. La tolleranza di **0,10 pp** e' un margine di arrotondamento del tester dichiarato prima, non uno sconto: oltre quella, il confronto e' **perso** |
| **C2** 🔴 | **MURO ASSOLUTO — vale a QUALUNQUE n** | **DD(stop largo) > 20,00%** in una qualunque finestra → **bocciatura secca**, comunque vada C1 | E' la soglia storica di casa: criterio A di `PROVA_REGIME_CRITERI.md` (*"e comunque mai il 20%"*). Un drawdown e' un fatto accaduto (valvola R59): non si annulla dicendo "erano pochi trade" |
| **C3** 🟠 | **ALLARME PROP — si scrive, non boccia da solo** | **DD > 10,00%** in una qualunque finestra | E' il muro di una challenge (`METRO_PROP.md`). A rischio 1% e in quel regime, quella cella avrebbe **fatto fallire** il conto. Non boccia da solo perche' il dato e' OHLC e la taglia di campo e' 0,3% — ma **entra nel `PIANO_PROP.md` come limite dichiarato**, e va scritto in prima pagina del referto |
| **C4** ⚪ | **PEGGIOR GIORNATA** | peggio di **−7,50%** in una finestra → si legge come C2 | Soglia gia' di casa (R86, R89). **⚠️ MA**: il CSV che il driver produce e' un CSV di **ottimizzazione** (`Profit, PF, Equity DD %, Trades`) e **NON contiene la peggior giornata**. Se non si aggiunge una passata singola con report completo, **C4 si dichiara NON MISURATO** — e "non misurato" si scrive, non si stima |

### 4.2 🏅 IL MERITO — **solo sulla finestra piu' recente**, e su nessun'altra

Misurato a **tick reali** da R88, **agli atti**. R90 **non lo rimisura**: lo
cita e lo verifica.

| # | cancello | soglia | verifica |
|---|---|---|---|
| **M1** | PF della cella stop largo sulla finestra recente | **≥ 1,40** | ✅ **1,8385** [MISURATO R88] |
| **M2** | PF(stop largo) ≥ PF(sedia viva), stessa finestra | — | ✅ **1,8385 vs 1,6742** [MISURATO R88] |
| **M3** | campione della finestra recente | **n ≥ 95** | ✅ **119** [MISURATO R88] |

### 4.3 🛠️ LA CORREZIONE, DICHIARATA — e vale **da questo round**, non all'indietro

> **In R90 NON esiste nessun cancello di MERITO sulle finestre vecchie.**

- ❌ **Il cancello "PF IS ≥ 1,10" di R88 (A3) NON si applica.** E' il cancello
  che ha bloccato R88 (PF IS dello stop largo = 1,063), e giudicava il
  **merito** sulla finestra **vecchia**: l'esatto contrario della regola B.
  **R88 resta non promosso** — un criterio firmato vale per il round in cui e'
  stato firmato — ma **da R90 in avanti quel cancello non si riscrive**.
- ❌ **Non si applica nemmeno il criterio B di R50** (*"PF ≥ 0,90 nelle
  finestre avverse"*): e' anch'esso un cancello di merito su finestra vecchia.
  Il suo contenuto di **rischio** e' gia' dentro il DD — un motore che
  sanguina lentamente **produce drawdown**, e C1/C2/C3 lo vedono.
- ✅ **Cosa si scrive lo stesso**: PF, profitto e payoff delle quattro
  finestre vanno **a referto in tabella**, con `n` accanto, come **diagnosi**.
  Si scrivono e **non giudicano**. Un numero che non giudica va etichettato
  come tale, altrimenti fra sei mesi qualcuno lo usera' per decidere.

---

## 5. 🧱 LA REGOLA DI ROBUSTEZZA — **in tutte e quattro, non nella media**

> ### Lo stop largo passa **solo se il suo DD e' ≤ di quello della sedia viva
> in TUTTE E QUATTRO le finestre.** Non nella media. In tutte.

**Perche' non la media**: una media assorbe il disastro. Se lo stop largo
facesse 2% · 3% · 2% e **14%** nell'orso, la media direbbe 5,25% e sembrerebbe
ottima — ma in prop **si fallisce nell'orso, non nella media**. Un vantaggio
che sparisce in un regime **non e' un vantaggio: e' una proprieta' di quel
regime**, ed e' esattamente cio' che questo round e' nato per scoprire.

**R90 PROPONE lo stop largo se e solo se, tutte insieme:**

1. ✅ **C1 in ogni finestra misurabile** (nessuna eccezione, nessuna media);
2. ✅ **nessun C2** (nessun DD > 20% in nessuna finestra, a qualunque n);
3. ✅ **almeno TRE finestre su quattro misurabili** (§6);
4. ✅ **M1 + M2 + M3** (gia' verdi da R88);
5. ✅ **il canarino di riproduzione P4/§7.2 e' verde**, altrimenti i numeri
   delle quattro finestre non si leggono affatto.

**Altrimenti**: nessuna proposta, e a referto si scrive **in prima riga quale
finestra l'ha fermata e con quale numero**. Una tesi smontata da un regime e'
un risultato pieno, non un fallimento del round.

📌 E la proposta, **se esce, si chiama con il suo nome**: *"stessa strategia,
rischio piu' basso"* — **non** *"strategia migliore"*. Il merito resta sospeso
per la regola A (n = 71/119, sotto 150) e non lo sblocca nessuna finestra
OHLC. (Corollario gia' scritto in `R88_CRITERI.md` §5.)

---

## 6. 🔢 IL CONTEGGIO OPERAZIONI ATTESO — e la conseguenza, decisa PRIMA

### 6.1 La stima, e come e' fatta

Frequenza misurata della cella: **71 trade / ~175 giorni di borsa** (IS) e
**119 / ~267** (OOS) = **~0,42 trade per giorno di borsa** [MISURATO in R88,
il rapporto e' **INFERITO** dal calendario].

| finestra | giorni di borsa (circa) | **n atteso** | note che abbassano il conto |
|---|---:|---:|---|
| 🐂 TORO 2021 | ~252 | **90 – 115** | nessuna: e' il regime amico della cella |
| 🐻 ORSO 2022 (10 mesi) | ~210 | **30 – 70** | ⚠️ la cella e' **solo long con filtro EMA200**: in un orso il filtro blocca gran parte dei giorni. **Puo' scendere sotto 30** |
| ↔️ LATERALE 2015 | ~252 | **60 – 110** | l'EMA200 in whipsaw taglia qualcosa |
| 💥 CROLLO 2020 (3 mesi) | ~62 | **0 – 15** | 🔴 **due soppressori insieme**: EMA200 (il Dow sta sotto per quasi tutta la finestra) **e** `InpMaxRangePct=0.8` — nel marzo 2020 il range dei primi 15 minuti superava regolarmente l'**1,5-3%** del prezzo, cioe' **oltre il tetto**: quei giorni la cella **non entra proprio** |

### 6.2 🚦 La conseguenza, congelata prima di vedere i numeri (valvola R59)

| campione nella finestra | cosa si puo' dire |
|---|---|
| **n ≥ 30** | ✅ finestra **MISURABILE**: C1 vale e puo' **far passare** o **far cadere** lo stop largo |
| **n < 30** | 🟡 finestra **NON MISURABILE per il confronto**: **non puo' far PASSARE** lo stop largo. Il numero si scrive, il verdetto no |
| **n = 0** (per entrambe le celle) | ⬜ finestra **SCOPERTA**: quel regime **non e' stato provato**. Si dichiara, non si riempie |

> ### ⚠️ L'ASIMMETRIA, che e' il cuore della valvola R59 — e non e' una scappatoia
> **Un campione sottile sospende il giudizio sul MERITO, mai sul RISCHIO.**
> Quindi, con n < 30:
> - ❌ quella finestra **non conferma** il vantaggio (non puo' dire "e' meglio");
> - ✅ ma un **DD oltre C2 in quella finestra BOCCIA lo stesso**, perche' un
>   drawdown **e' successo**.
>
> Si sospende *"quanto e' bravo"*, mai *"quanto puo' farmi male"*.

### 6.3 🩹 La riserva, decisa prima: se il CROLLO esce vuoto

Se **CROLLO 2020.02-04** risulta non misurabile (n < 30) o scoperto (n = 0):

1. si lancia la finestra di riserva **CROLLO_ANNO 2020.01.01 → 2020.12.31**
   (gia' congelata dall'emendamento E.6, usata in R59), che contiene lo shock
   **e** il rimbalzo, e in cui l'EMA200 torna favorevole da giugno;
2. se anche quella resta sotto 30, R90 esce con l'etichetta
   **🔴 "REGIME DI CROLLO NON COPERTO"** scritta **in prima pagina del
   referto**, e la stessa etichetta va nel `PIANO_PROP.md`. La proposta, se
   c'e', vale **con quel buco dichiarato**: e' precisamente il caso in cui *un
   piano che sembra completo e' peggio di un piano corto*.

📌 E c'e' una lettura da scrivere comunque, che vale piu' di un PF: **se nel
crollo la cella non opera perche' il tetto di range la blocca, quella e' una
proprieta' difensiva del motore**, e va detta — ma va detta come *"non ha
operato"*, mai come *"ha retto"*. Non sono la stessa frase.

---

## 7. 🐤 I CANARINI — gratis, e si leggono PRIMA dei numeri veri

### 7.1 Il numero di operazioni **deve** essere identico fra le due celle

**[MISURATO in R88]**: `n = 71` in IS e `n = 119` in OOS **per entrambe le
celle**. Ed e' spiegato dal sorgente: le due celle differiscono solo su
**stop e target**, cioe' sulle **uscite** e sul **lotto**; gli ingressi
(pendenti STOP a 10 punti oltre il livello, `InpOneTradePerDay=1`) sono
identici.

> Quindi in **ogni** finestra di R90 ci si aspetta **n(largo) = n(viva)**.
> **Se in una finestra i due n differiscono, qualcosa ha toccato gli
> INGRESSI: il round si ferma e si cerca il perche' prima di leggere altro.**

### 7.2 🔬 IL CANARINO DI RIPRODUZIONE — il cancello P4, che rende leggibile tutto

Prima delle quattro finestre si lancia **una quinta corsa, sulle stesse due
celle**, sulla finestra di **sovrapposizione** — `2024.09.26 → 2026.06.30`,
dove abbiamo **sia i tick BCM sia le barre Dukascopy**:

| esito su `U30USD_EXT` (OHLC) | cosa vuol dire |
|---|---|
| ✅ **DD(largo) < DD(viva)** **e** **PF(largo) > PF(viva)** | il feed OHLC **riproduce il VERSO** del fatto misurato a tick (R88). Le quattro finestre si possono leggere **per il rischio** |
| ❌ il verso si **inverte** | il modello OHLC **non sa rispondere a questa domanda** su questo motore. **R90 si ferma**: le quattro finestre non si leggono, e si scrive che il limite e' del dato, non della cella |

⚠️ **Non si chiede la riproduzione al centesimo**: e' un altro feed, un altro
modello e un altro spread — pretenderla sarebbe un cancello impossibile
(lezione R80: `_EXT` riprodusse R56 al centesimo perche' era **lo stesso
feed**; qui non lo e'). Si chiede il **verso**. E si scrivono comunque i valori
assoluti e lo scarto dal tick: **e' la misura dell'errore del Modello 1 su
questo motore**, un numero che oggi non abbiamo e che servira' a ogni round
futuro sugli indici.

### 7.3 Igiene del driver (gia' di casa)

- **righe gemelle del magic** identiche al centesimo in ogni CSV (32/32 in
  R50, 70/70 in R59): se due gemelle divergono, il CSV non si legge;
- **32 CSV attesi**… qui: **2 celle × 4 finestre = 8 CSV** (+2 del canarino
  §7.2, +2 se scatta la riserva §6.3). Se ne manca uno, si dichiara quale.

---

## 8. 🛑 IL VINCOLO — R90 **PROPONE**. Claudio decide. E la via di casa e' la GEMELLA

1. **Nessun deploy automatico.** Da R90 non esce nessun `.set`, nessun cambio
   alla sedia viva, nessun EA attaccato a un grafico. Esce **un referto con una
   proposta**, o **nessuna proposta**.
2. 🔴 **Anche se passa TUTTO, la messa in campo e' una decisione separata di
   Claudio.** Passare i cancelli e' condizione **necessaria**, mai sufficiente.
3. 🪑 **La via di casa e' la SEDIA GEMELLA IN PARALLELO, mai la sostituzione.**
   E' la regola del progetto (*"gli `_Ottimizzato` girano in parallelo agli
   originali, magic diversi, mai sostituirli"*): la sedia **770611 resta
   accesa e non si tocca**, lo stop largo entra — se entra — come **sedia
   nuova con magic vergine**. Proposta: **770612** (770601 = ORB del corso,
   770611 = il nostro). ⚠️ **Il magic va verificato libero** contro
   `FLOTTA_ATTIVA.md` e `censimento_ordini.ps1` **prima** dell'uso: qui e'
   proposto, non assegnato.
4. **Prima del campo servono comunque tre cose** (gia' congelate in
   `R88_CRITERI.md` §6.4):
   - **R55-bis** sulla cella nuova: lo stop largo **cambia il lotto**, e la
     pendenza dello slippage e' stata misurata su un'altra taglia. Senza,
     il DD basso e' una promessa non collaudata;
   - il **contratto della sedia** in `report/CONTRATTI_SEDIE.md` con **DD e
     frequenza promessi**, perche' e' su quelli che il criterio di uscita del
     18/08 misurera' il forward;
   - **forward demo**, mai live da un backtest (ROTTA_PROP).
5. **Un solo cambio alla volta.** La cella stop largo muove **quattro input
   insieme** (SLMode, buffer, TPMode, TP in R): e' un blocco unico perche' col
   TP in R il target **segue** lo stop, ma va detto a referto che R90 misura
   **un pacchetto**, non un parametro. Scomporlo, se servira', e' un altro
   round.

---

## 9. 📋 CHECKLIST DEL REFERTO DI R90

- [ ] Il **canarino di riproduzione** (§7.2) come **prima** cosa scritta.
- [ ] **n accanto a OGNI numero**, senza eccezioni — e il controllo
      `n(largo) = n(viva)` finestra per finestra (§7.1).
- [ ] Il **regime dichiarato** accanto a ogni tabella, **col rendimento vero
      dell'indice in quella finestra** (§3.2).
- [ ] **Tipo di dato accanto a ogni tabella**: `OHLC M1 Dukascopy — vale solo
      per il RISCHIO`.
- [ ] La tabella C1 finestra per finestra: **DD(largo) vs DD(viva)**, con la
      colonna "passa / non passa".
- [ ] Le finestre **non misurabili** (n < 30) e **scoperte** (n = 0) dichiarate
      per nome (§6.2).
- [ ] C3 (DD > 10%) riportato **in prima pagina** se scatta, e portato in
      `report/PIANO_PROP.md`.
- [ ] C4 dichiarato **NON MISURATO** se il CSV non porta la peggior giornata.
- [ ] Distinzione esplicita **[MISURATO] / [INFERITO] / [DICHIARATO]**.
- [ ] Gli **orari sempre nei due fusi** (server BCM e italiana).
- [ ] Il commit che era sulla **punta di `lavoro`** all'ora della corsa.

---

## 10. 🚫 COSA QUESTO ROUND **NON** PUO' DIRE — anche se passa tutto

1. ❌ **Non puo' dire che lo stop largo e' "migliore".** Il merito resta
   sospeso (n < 150, regola A) e le quattro finestre sono **barre**, non tick.
   Al massimo dice: **"stesso motore, drawdown piu' basso, in quattro regimi
   diversi"**.
2. ❌ **Non puo' promettere il DD futuro.** *"Il DD peggiore possibile resta
   sconosciuto per definizione"* (`PROVA_REGIME_CRITERI.md` §5).
3. ❌ **Non tara niente.** Sul feed esterno **non si sceglie mai un
   parametro**: due celle congelate, e basta.
4. ❌ **Non chiude la questione del campione.** Restano vere le due strade di
   R88 §6: misurare davvero i tick (P0) e, se un giorno ci fossero, rifare
   **questo stesso round a tick reali**.
5. ❌ **Non dice niente sul DAX, sul Nasdaq o sugli altri ORB.** Un simbolo,
   un motore, una domanda.

---

## 11. 📮 COSA MANCA E CHI LO PORTA

| # | cosa manca | chi | domanda esatta |
|---|---|---|---|
| 1 | **profondita' tick vera di U30USD** | **Claudio** (PC di backtest, riga gia' in CODA §4) | *"la riga TICK di U30USD dice 2024.09.26 o qualcosa di piu' vecchio?"* |
| 2 | **i dati Dukascopy del Dow 2015-2022** (P1→P3) | **Claudio** + agente pipeline | *"`--autotest` e `--validazione` passano? Lo shift calibra +5? Il cancello zero passa sulla sovrapposizione?"* |
| 3 | **il driver che accetta le finestre di R90** (P5) | agente driver | *"`prova_regime.ps1` puo' ricevere UNA finestra per lancio senza toccare le cinque gia' congelate?"* |
| 4 | **la riga di lancio** (con `irm` + raccolta Desktop + zip) | agente riga di lancio, **dopo** P0-P3 | — |
| 5 | **la firma** | **Claudio** | §0 |

---

_Fine della bozza. **Nessun numero di R90 e' stato visto, perche' nessun numero
di R90 esiste.** I numeri di R88 citati qui sono tutti tracciabili ai CSV in
`risultati_archivio/r88_csv/`._
