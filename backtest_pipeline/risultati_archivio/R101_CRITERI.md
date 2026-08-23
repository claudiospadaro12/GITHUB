# ✍️ R101 — L'ABLAZIONE DEI FILTRI SU DOW E DAX — **CRITERI FIRMATI**

> ## 🖊️ VERBALE DELLA FIRMA — 23/08/2026
>
> **Claudio, in chat:** *"FIRMO TUTTE E 6 CON LE PROPOSTE, POI FACCIO I 2
> CONTROLLI"*.
>
> Le sei decisioni del § 10 sono **firmate CON LE PROPOSTE**, cioè con i valori
> che erano scritti nella colonna "proposta" della bozza — **a numeri non
> visti**, che è la condizione che le rende valide.
>
> | # | decisione | scelta firmata |
> |---|---|---|
> | 1 | tolleranza di riproduzione del metro (G0) | **±0,01 PF · ±0,10 punti % DD · n ESATTO** |
> | 2 | cancello di merito | **PF OOS più alto E DD OOS non peggiore** |
> | 3 | merito sul Dow (n OOS 130 < 150) | **SOSPESO** |
> | 4 | 9° gradino "IL CORSO PIENO" | **SÌ** — volumi + ATR + Supertrend×3 + correlazione accesi insieme |
> | 5 | filtro news | **FUORI** da questo round |
> | 6 | mediazione 1:2 | **in coda di sviluppo** con la spec del § 8.1 |
>
> ### ⏳ MA IL LANCIO ASPETTA ANCORA DUE COSE, E SONO SUE
> Claudio ha detto *"POI FACCIO I 2 CONTROLLI"*: sono le due verifiche sul
> grafico del § 10.1 (Dow `InpMinStopPts`/`SkipIfTight`/range min-max; DAX
> `InpAllowShort`). **Finché non tornano, la corsa vera non parte** — se uno
> dei due non torna, la cella viva dei file prova **non è la sedia viva** e i
> file vanno corretti PRIMA, non dopo.
>
> ### 🔧 NOTA DI MANUTENZIONE — non è un dettaglio
> Il driver si sblocca leggendo QUESTO file: se ci trova ancora la stringa del
> lucchetto (`DA` + `FIRMARE` fra parentesi quadre) **si rifiuta di fare la
> corsa vera**, ovunque essa compaia — anche dentro una frase storica.
> 👉 **In questo file quella stringa non si riscrive mai più.** Se serve
> parlarne, si scrive come qui: a pezzi, o senza parentesi.

---

---

## 0. 📌 DA DOVE NASCE — e perché non è un round qualunque

Il **debito del 18/08** è ancora aperto, e lo dice per iscritto l'analisi di
ieri (`caccia_strategie/ANALISI_APERTURE_4DOC_2026-08-23.md`, domanda 3 a
Claudio):

> *"L'**ablazione dei filtri** (volumi, ATR, ST×3, correlazione, news = **il
> metodo come lo prescrive il corso**) **non è mai girata**. Finché non gira,
> la frase «il metodo del corso non funziona» **non è dimostrata**: quello che
> è morto nei nostri round è lo **scheletro nudo**."*

E lo stesso referto lo dice anche al § 7.4, voce 6, con la citazione del corso
[PDF PAG 29-30] *"se anche solo un punto è NO… meglio aspettare"*:

> *"Le nostre sedie hanno i filtri **spenti** → di fatto operiamo lo
> **scheletro nudo**, non il metodo del corso."*

L'ablazione era pronta sul **Nasdaq** (`ablazione_nasdaq.ps1`) — e quel simbolo
**R97 (0/4) + R98 (0/6)** l'hanno chiuso. Claudio ha scelto l'opzione (i):
**si rifà dove un edge misurato ESISTE**, cioè sulle due sedie vive del 100k.

**Quindi R101 risponde a UNA domanda sola, ed è misurabile:**

> ### ❓ *Quanto PAGA — o quanto COSTA — ogni singolo filtro, sopra la sedia che gira davvero coi soldi?*

Non *"qual è la cella migliore"*. Non *"ottimizziamo il Dow"*. **Quanto pesa
ciascun filtro, uno per uno, sopra la geometria viva.**

---

## 1. 🧭 IL METODO — ablazione **A STELLA**, non a scala cumulativa

Il verbale di firma dice *"metodo della scala (come `test_orb_toolkit`)"*.
`test_orb_toolkit` è **cumulativo**: A → B → C → D, ogni gradino aggiunge una
cosa **al precedente**. Va benissimo quando si sta costruendo un motore da
zero e si vuole sapere dove sta il salto.

**Qui serve l'altra forma, e va detto perché** — è una traduzione dichiarata
(checklist punto 57), non un cambio di firma:

| | scala CUMULATIVA (toolkit) | stella (R101) |
|---|---|---|
| ogni cella | = la precedente + 1 cosa | = **la VIVA ± 1 cosa** |
| risponde a | *dove sta il salto costruendo il motore* | *quanto pesa ogni pezzo sul motore che ho* |
| confonde? | **sì**: il gradino E porta dentro anche B, C, D | **no**: ogni numero è attribuibile a un filtro solo |
| il metro | il gradino precedente (che cambia ogni volta) | **la cella viva, sempre la stessa** |

La domanda di Claudio è *"migliorare gli EA che ho"*, non *"costruirne uno
nuovo"*. Il metro deve essere **la sedia viva**, e deve restare **fisso** per
tutti e otto i gradini: altrimenti *"il filtro volumi costa 400 euro"* non
vuol dire niente, perché è misurato sopra un motore diverso da quello vivo.

### 1.1 Come è garantita l'attribuzione (e non è una promessa: è verificata)

In ognuno dei 9 file di una famiglia sono pinnati **tutti e 70 (71 sul DAX)
gli input**, compresi i **sotto-parametri dei filtri spenti** (`InpVolMult`,
`InpStMultiplier`, `InpCorrEmaSlow`…), che restano **inerti** finché il loro
interruttore è a 0.

👉 Conseguenza: il diff fra un gradino e la cella viva è **letteralmente di UNA
riga**. Verificato meccanicamente il 23/08 su tutti e 18 i gradini, più il
controllo che **ogni nome esista nel sorgente** (trappola n° 3 del driver
generico: un nome che l'EA non ha viene ignorato **in silenzio** da MT5, e la
fase risponde a una domanda diversa da quella che credevi di fare).

**L'unica eccezione è dichiarata**: la cella `04_corso_or` muove **due**
interruttori. Motivo al § 4.

---

## 2. 🧊 LE CELLE VIVE CONGELATE — input per input, con la fonte

### 2.1 ⚠️ Il rilievo più importante di tutta la preparazione

> ### 🔴 I DEFAULT DEL SORGENTE `ABTG_Dow_Apertura_US.mq5` **NON SONO** LA CELLA VIVA.

Il sorgente dichiara ancora, nei suoi `#define` e nei commenti `[DOW]`, la
geometria **VECCHIA**: `BREAKOUT`, range 15, buffer 200, `TP1_R 0.5`,
`TP1_ClosePct 0`, `BreakevenAtTP1 false`. Quella è la cella misurata **negativa**
e sostituita il **09/08 alle 15:34**.

La cella che gira coi soldi è `RETEST` 35/1000/400, TP1 1R, parziale 50%, BE
acceso — ed è documentata in `report/PASSI_OPERATIVI.md` (*"ESITO: Claudio ha
deciso SI' e deployato alle 15:34 … le modifiche vere sono state 8"*).

**Chi avesse costruito R101 sui default del sorgente avrebbe ablato i filtri
sopra un motore che non esiste più.** È il difetto che questa sezione esiste
per non commettere, ed è il motivo per cui ogni riga qui sotto ha una fonte.

### 2.2 🇺🇸 DOW — `ABTG_Dow_Apertura_US` · U30USD M5 · magic vivo **770202**

| input | valore | fonte |
|---|---|---|
| `InpSessionHour` / `InpSessionMin` | **14 / 30** | deploy 09/08 + `#define` + fuso MISURATO (4DOC § 2.2) |
| `InpEntryMode` | **2 = RETEST** | deploy 09/08 (era BREAKOUT) · file prova R46b, R54a |
| `InpRangeMode` | 0 = range di apertura | R46b, R54a |
| `InpRangeMinutes` | **35** | deploy 09/08 (era 15) |
| `InpBufferPoints` | **1000** | deploy 09/08 (era 200) |
| `InpRetestOffsetPts` | **400** | deploy 09/08 |
| `InpAllowLong` / `InpAllowShort` | **1 / 0 (SOLO LONG)** | deploy 09/08 · **confermato da R54** (short bocciato, PF OOS 0,840) |
| `InpUseEmaFilter` / Fast / Slow / TF | **1 · 1 · 50 · H4** | commenti `[DOW]` nel sorgente, pinnati esplicitamente in R54a |
| `InpSLMode` | 0 = estremo opposto | R46b, R54a · **e R88 lo conferma misurato** |
| `InpTP1_R` | **1.0** | deploy 09/08 (il sorgente dice ancora 0.5) |
| `InpTP1_ClosePct` | **50** | deploy 09/08 (il sorgente dice ancora 0) |
| `InpBreakevenAtTP1` | **1** | deploy 09/08 (il sorgente dice ancora false) |
| `InpUseTrailing` / `InpTrailMode` / `InpTrailTF` | 1 · 1 = PREVBAR · **M5** | R46 (*"il trailing è ASSOLTO"*) |
| `InpTrailStartR` / `InpBEatR` | 0 / 0 | R24 (soglia 0 = migliore OOS), R46b |
| `InpRiskPercent` | **1.0 nel test** | R46b, R54a. In campo sul 100k è **0,65%** (`DEPLOY_GUARDIANO_100K.md`) — vedi § 2.4 |
| `InpMinStopPts` / `InpSkipIfTight` | **500 / false** | 🟠 **[DA CONFERMARE]** — default `[DOW]` del sorgente. R46b e R54a **non lo pinnavano**, quindi hanno girato a 500: è il valore con cui la cella viva è stata riprodotta al centesimo. Qui è pinnato esplicito |
| `InpMinRangePts` / `InpMaxRangePts` | 0 / 0 (spenti) | default del sorgente 🟠 **[DA CONFERMARE] sul grafico** |
| `InpOneTradePerDay` | 1 | R46b, R54a |
| `InpCloseHour` / `InpCloseMin` / `InpCloseAtEnd` | 17 / 30 / true | `#define` + R54a |
| `InpUsaGuardian` | 1 | default. **Nel tester è fail-open totale** (le GlobalVariable del Guardian non esistono): non cambia nulla e i backtest restano confrontabili coi vecchi |
| tutti gli altri filtri | **spenti** | default del sorgente |

**🎯 IL METRO — i numeri agli atti che la cella `00_viva` DEVE riprodurre:**

| | profitto | PF | DD | n |
|---|---:|---:|---:|---:|
| **OOS** | +6.721,93 | **1,27013** | **4,3941%** | **130** |
| **IS** | +2.811,84 | 1,222 | 5,67% | 74 |

Fonte: `REFERTO_ROUND54_LATI_DOW.md` § 0-1, riga *"solo LONG"*. Lo stesso
referto certifica che riproduce R46 (*"A = LIVE: +6.722 · 1,27 · 4,39"*).
**Due round indipendenti, stesso numero.** È il controllo d'igiene più forte
che abbiamo.

### 2.3 🇩🇪 DAX — `ABTG_DAX_Apertura_EU` · D30EUR M5 · magic vivo **770101**

| input | valore | fonte |
|---|---|---|
| `InpSessionHour` / `InpSessionMin` | **8 / 0** | `#define` + fuso MISURATO (4DOC § 2.2) |
| `InpEntryMode` | **2 = RETEST** | default del sorgente (06/08, walk-forward) · R46a |
| `InpRangeMinutes` | **35** | `#define` (*"8 celle su 8 in utile con 35-45, 0 su 12 sotto"*) |
| `InpBufferPoints` / `InpRetestOffsetPts` | **500 / 200** | `#define` + default · R46a |
| `InpAllowLong` / `InpAllowShort` | **1 / 0 (SOLO LONG)** | R46a · `DEPLOY_GUARDIANO_100K.md` riga 149 · 🟠 **[DA CONFERMARE]**: il sorgente ha ancora `InpAllowShort = true`, il lato è spento **sul grafico**. E sul DAX il solo-short **non è mai stato misurato** (R52 riga 2 lo misurò sul Dow, non qui) |
| `InpUseEmaFilter` | **0 (SPENTO)** | default del sorgente |
| `InpSLMode` | 0 = estremo opposto | R46a |
| `InpTP1_R` / `InpTP1_ClosePct` / `InpBreakevenAtTP1` | 1.0 / **50** / **1** | R46a (*"A = LIVE"*) · default del sorgente |
| `InpUseTrailing` / `InpTrailMode` / `InpTrailTF` | 1 · 1 = PREVBAR · **M5** | R46a · `#define` (*"era M1, il PEGGIORE dei sei"*) |
| `InpAllowReverse` | **0** | default. **R51 l'ha misurato**: in RISERVA, non si rimisura (§ 6) |
| `InpMinStopPts` / `InpSkipIfTight` | 0 / true | default del sorgente |
| `InpRiskPercent` | **1.0 nel test** | R46a. In campo sul 100k **0,65%** |
| tutti gli altri filtri | **spenti** | default del sorgente |

**🎯 IL METRO:**

| | profitto | PF | DD | n |
|---|---:|---:|---:|---:|
| **OOS** | +18.030 | **1,40** | **7,23%** | 🔴 **NON AGLI ATTI riga per riga** |

Fonte: `REFERTO_ROUND46_GESTIONE.md`, riga *"A = LIVE (PREVBAR + parziale 50%)"*.
`CONTRATTI_SEDIE.md` riga 770101 aggiunge: DD promesso **6,25%** (R16), la
griglia R46 sulla cella LIVE dà **7,23%**, frequenza **~21 op/mese (270 trade
su 12,6 mesi OOS)**.

> 🟠 **Il n del DAX per finestra non è agli atti come lo è quello del Dow.** Lo
> misura il PASSO 0 di questa corsa e **va scritto qui** appena esce. Finché non
> c'è, il canarino del DAX è **[DA MISURARE]**, non "circa 270".

### 2.4 ⚖️ Perché si testa all'1,00% e non allo 0,65% del 100k

Le sedie sul conto 100k girano a **0,65%** (Monte Carlo del 18/08: a 1% il p95
sfora il 10% FTMO). I file prova di R101 girano a **1,00%**, ed è voluto:

1. è la taglia di **R46, R54 e R16** — cambiarla renderebbe la cella `00_viva`
   non confrontabile col metro agli atti, cioè **butterebbe via il controllo
   d'igiene**;
2. a rischio percentuale il **DD% scala ~linearmente** con la taglia
   (`CONTRATTI_SEDIE.md`, nota 2): un DD misurato all'1% si converte a 0,65%
   moltiplicando per 0,65. Gli **euro** no.

👉 **Regola di lettura, da scrivere nel referto:** ogni DD di R101 è **all'1%**.
Per confrontarlo col forward del 100k si moltiplica per **0,65**. Chi salta
questa conversione confronta due cose diverse.

---

## 3. 🪜 LE DUE SCALE — 9 gradini + il metro, per EA

**20 file in tutto** (9 gradini + il metro, per EA), già scritti e verificati
in `backtest_pipeline/prove/`.

| # | file (`R101_DOW_…` / `R101_DAX_…`) | cosa muove | Dow | DAX | origine |
|---|---|---|---|---|---|
| **00** | `00_viva` | *niente* | — | — | **il METRO** |
| **01** | `01_ema` | `InpUseEmaFilter` | **1 → 0** (si TOGLIE) | **0 → 1** (si METTE) | casa |
| **02** | `02_volumi` | `InpUseVolumeFilter` | 0 → 1 | 0 → 1 | **corso** [PDF 14/17] |
| **03** | `03_atr` | `InpUseAtrFilter` | 0 → 1 | 0 → 1 | **corso** [PDF 14] |
| **04** | `04_corso_or` | `InpUseVolumeFilter` **+** `InpUseAtrFilter` | 0 → 1 · 0 → 1 | idem | **corso, regola letterale** |
| **05** | `05_supertrend3` | `InpUseSupertrend3` | 0 → 1 | 0 → 1 | **corso** [EU 23, ×3 = 2,5/3,0/3,5] |
| **06** | `06_correlazione` | `InpUseCorrelation` (SPXUSD) | 0 → 1 | 0 → 1 | **corso** [AM 9, EU 17, PDF 21] |
| **07** | `07_vwap` | `InpUseVwapFilter` | 0 → 1 | 0 → 1 | live Emiliano, **non del corso** |
| **08** | `08_tondi` | `InpUseRoundLevels` | 0 → 1 | 0 → 1 | **corso** [NAS 12/15] |
| **09** | `09_corso_pieno` | `InpUseVolumeFilter` **+** `InpUseAtrFilter` **+** `InpUseSupertrend3` **+** `InpUseCorrelation` | tutti 0 → 1 | idem | **corso, la CHECKLIST** [PDF 29-30] |

### 3.1 Il gradino 01 è l'unico **asimmetrico**, ed è il più importante dei due

- **Sul Dow il filtro EMA è ACCESO** ed è quello a cui il sorgente attribuisce
  il salto di qualità (*"PF 1,03 → 1,24, DD 14,9% → 6,9%"*). 🔴 **Ma quel numero
  è stato misurato sulla geometria VECCHIA (BREAKOUT 15/200), mai sulla RETEST
  35/1000/400 che gira oggi.** È il buco più grosso delle due sedie: paghiamo
  un filtro sulla base di una misura fatta su un altro motore. Qui si **toglie**.
- **Sul DAX il filtro EMA è SPENTO**, e la frase *"il trend H4 aiuta gli indici
  USA e danneggia gli europei"* è misurata **sul Dow**. Sul DAX, sulla geometria
  viva, il confronto acceso/spento **non esiste agli atti**. Qui si **mette**.

⚠️ **E si mette ai default del SORGENTE DAX (14/200 su H1), non ai 1/50 su H4
del Dow.** Trasferire una taratura da un mercato all'altro è esattamente il
curve fitting che la casa vieta.

### 3.2 Le soglie sono **NOSTRE**, e vanno dichiarate ogni volta

`ANALISI_APERTURE_4DOC` bandiera **B3**: il corso dice *"volumi superiori alla
media"*, *"ATR > media"*, *"candela ampia, decisa"* — **senza mai una soglia
né una finestra**. *"Ogni implementazione inventa i numeri."*

| soglia | valore | di chi è |
|---|---|---|
| volumi ≥ **1,5 ×** media a **20** barre | `InpVolMult 1.5` · `InpVolAvgBars 20` | **NOSTRO** (default del sorgente) |
| ATR ≥ **1,0 ×** media a **20** barre | `InpAtrFilterMult 1.0` · `InpAtrFilterBars 20` | **NOSTRO** |
| Supertrend ATR **10** | `InpStAtrPeriod 10` | **NOSTRO** (assunzione A2; il corso non lo dice mai) |
| correlazione EMA **14/100** su **H1** | `InpCorrEmaFast/Slow`, `InpCorrTF` | **NOSTRO** |
| numeri tondi passo **100,0** di prezzo | `InpRoundStep 100.0` | **NOSTRO** (il corso dice 1.000, e solo sul Nasdaq) |

👉 **Nessuna di queste soglie si spazzola in questo round** (§ 6). Si usa il
default, si dichiara che è nostro, e si misura l'interruttore. Spazzolarle
sarebbe una griglia, cioè esattamente quello che il perimetro firmato vieta
(*"Nessuna griglia, nessuna pesca"*).

### 3.3 Le due celle che meritano un avviso in più

- **`04_corso_or`** — muove **due** interruttori. È l'unica, e il motivo è nel
  PDF: *"supportata da aumento di volumi **O** da una volatilità coerente"*
  [PAG 14]. `InpConfirmMode` resta **0 = OR**: basta una delle due.
  **Non è un'ablazione pura e non si legge da sola**: si legge solo accanto a
  02 e 03.
- **`08_tondi`** — è la **più invasiva degli otto singoli**: cambia il primo obiettivo,
  quindi sposta anche **la parziale e il breakeven**, che scattano lì. Un
  risultato di questa cella non è *"il filtro dei numeri tondi"*: è *"un'altra
  gestione"*. Va letto sapendolo.

### 3.4 ✍️ Il gradino **09 · IL CORSO PIENO** — decisione 4, firmata SÌ

> **È l'unica cella CUMULATIVA del round, ed è dichiarato.** Non attribuisce
> niente a nessun filtro — quello lo fanno i gradini 02/03/05/06. **Si legge
> solo accanto a loro.**

Esiste per chiudere **il debito del 18/08**, che i gradini singoli da soli non
chiudono. Il corso non prescrive filtri *uno per volta*: prescrive una
**checklist**, e la regola d'oro è *"se anche solo un punto è NO… forse è
meglio aspettare"* [PDF PAG 29-30]. Questa cella è quella checklist: **il
metodo del corso come lo prescrive il corso**, contro lo scheletro nudo che
gira oggi.

- Quattro interruttori accesi insieme: volumi, ATR, Supertrend×3, correlazione.
- **Le soglie sono IDENTICHE a quelle dei gradini singoli** (§ 3.2) — e sono
  **NOSTRE**. Se cambiassero qui, questa cella non sarebbe più la loro somma.
- `InpConfirmMode` resta **0 = OR** fra volumi e ATR, come nel gradino 04 e
  come nel PDF. L'AND è un'altra domanda, e non è del corso.

> 🔴 **COSA ASPETTARSI, SCRITTO PRIMA DEI NUMERI: il n CROLLA.** Quattro filtri
> che devono passare tutti, sopra un motore che fa ~130 operazioni OOS sul Dow:
> è **probabile** che si finisca sotto la soglia G1 di 30, cioè *"NON
> MISURABILE"*.
>
> **E qui "non misurabile" è GIÀ UNA RISPOSTA, non un fallimento**: vorrebbe
> dire che il metodo del corso, applicato alla lettera sulla nostra geometria,
> **non produce un campione su cui si possa giudicare**. Che è esattamente ciò
> che il debito del 18/08 chiedeva di sapere.
>
> ⛔ **E non si abbassa nessuna soglia per far "funzionare" questa cella.**

---

## 4. 📅 FINESTRE — le standard, senza sconti

| | |
|---|---|
| simboli | **U30USD** (Dow) e **D30EUR** (DAX), **M5** |
| storico | `@DAQUANDO` **2024.09.26** — il muro del feed BCM sugli indici, misurato (`REFERTO_SONDA_STORICO_17-08.md`) |
| fine | **2026.06.30** |
| split | **40 / 60** (`FrazioneIS 0.40`, default del driver generico) |
| **IS** | **2024.09.26 → 2025.06.09** |
| **OOS** | **2025.06.10 → 2026.06.30** |
| modello | **4 = TICK REALI** |
| deposito | **100.000** (taglia prop, come R46/R54) |
| spread | `Spread=0` **scritto nell'ini** = spread corrente del feed, dichiarato. **Non è uno stress e non è una misura** |

Sono **le stesse finestre di R88, R97 e R98**: è l'unico modo di confrontare i
round alla pari. Verificate contro `R86_CRITERI.md`, `R87_CRITERI.md`,
`R88_CRITERI.md` e `R98_CRITERI.md`, che le riportano identiche.

### 4.1 🚩 E i tre limiti della finestra, dichiarati PRIMA dei numeri

**Non sono dettagli: sono la ragione per cui i cancelli del § 5 sono fatti così.**

1. 🔴 **UN SOLO REGIME.** 21 mesi in cui gli indici hanno fatto quasi solo una
   cosa: salire. **Emendamento regola C**: la prova di regime batte la storia
   contigua — e sugli indici **non la possiamo fare** (Pepperstone non esiste,
   `R54_LATO_MAI_MISURATO_TESI.md` § 5). Un filtro di trend direzionale, dentro
   una salita, ha un vantaggio **che non è dell'idea: è del periodo**.
2. 🔴 **QUESTO OOS È GIÀ STATO GUARDATO MOLTE VOLTE** (R16, R35, R46, R51, R54,
   R88…). R101 lo guarda **altre 18 volte** (9 gradini × 2 EA). Con 18
   confronti sulla stessa finestra, **qualcuno esce verde per caso**. Il
   cancello **G3** del § 5 esiste apposta.
3. 🟠 **IL CAMPIONE È SOTTILE SUL DOW** (n OOS = 130, n IS = 74, contro i 150
   dell'Emendamento regola A) **e ogni filtro lo assottiglia ancora**. Vedi § 5.4.

---

## 5. 🚧 I CANCELLI — ✍️ **FIRMATI** (23/08, decisioni 1-3 e 5)

### G0 · IGIENE — 🔴 **FATALE**, si legge prima di tutto

| controllo | condizione |
|---|---|
| **gemelli** | le 2 righe di ogni CSV (magic `n` e `n+1`) **identiche al centesimo**, in tutti e 40 i CSV |
| **riproduzione del metro — Dow** | `R101_DOW_00_viva` OOS deve dare **PF 1,270 · DD 4,394% · n 130** |
| **riproduzione del metro — DAX** | `R101_DAX_00_viva` OOS deve dare **PF 1,40 · DD 7,23%** |
| **righe** | 2 righe per CSV (le due gemelle), **40 CSV, 80 passate** (20 celle: era 36/72 prima che la decisione 4 aggiungesse il 9° gradino) |

> ✍️ **La tolleranza sulla riproduzione è FIRMATA** — decisione 1 del § 10,
> firmata con la proposta: **±0,01 su PF, ±0,10 punti % su DD, n ESATTO**. Il n esatto non è
> pignoleria: R54 ha riprodotto R15 con *"stesso identico numero di trade"* e
> PF a due centesimi, quindi sappiamo che questa macchina ci arriva.
> **Se il metro non si riproduce, il round NON SI LEGGE**: si cerca il difetto
> prima di guardare qualunque gradino.

### G1 · MISURABILITÀ (per gradino)

**n OOS ≥ 30** → sotto, il verdetto è **"NON MISURABILE"**, mai *"non funziona"*.
Stessa soglia e stessa formulazione di R54 criterio 2. È l'esito **atteso** su
`05_supertrend3` e `06_correlazione`, che tagliano molto.

### G2 · MERITO (per gradino) — **due cancelli, tutti e due**

Un gradino diventa **CANDIDATO** solo se, contro la cella viva **dello stesso EA**:

- **(a)** **PF OOS più alto**, **E**
- **(b)** **DD OOS non peggiore**.

È lo **standard di portafoglio** già usato in R46 criterio 2(a)(b) e R54
criterio 4: *"guadagnare di più peggiorando il DD **non basta**"*.

> ✍️ **FIRMATO (decisione 2): vale il PF.** R46 chiedeva **+10% di profitto OOS**, non
> "PF più alto". Qui propongo **PF** perché su un'ablazione che *toglie trade* il
> profitto assoluto scende quasi sempre per costruzione — un filtro che alza la
> qualità e dimezza il numero fallirebbe un cancello sul profitto pur essendo
> buono. **Ma è un cancello più permissivo di quello di R46, e va detto.**

### G3 · COERENZA CROSS-MERCATO — 🔴 **il cancello che protegge dal rumore**

> **Lo stesso filtro deve andare nella STESSA DIREZIONE su ENTRAMBI gli EA.**

Un filtro che aiuta il Dow e danneggia il DAX **non è un candidato**: o è
rumore, o è specifico di un mercato — e in tutti e due i casi non si promuove
da un round che ha guardato la stessa finestra 16 volte.

È **letteralmente il criterio 2(c) di R46** (*"stessa direzione anche sul DAX —
un miglioramento su un solo indice è un picco isolato, non un risultato"*), ed
è anche il criterio che in R46 **ha fermato un candidato che faceva +31%**.
Quel precedente è la ragione per cui lo rimetto: **la regola non si piega
perché un indice fa un bel numero.**

⚠️ **Eccezione dichiarata: il gradino 01.** Sul Dow toglie, sul DAX mette: le
due direzioni **non sono confrontabili** e G3 **non si applica**. Si leggono
come due misure separate, e va scritto nel referto.

### G4 · CAMPIONE (Emendamento regola A) — ✍️ **FIRMATO**

L'Emendamento chiede **≥ 150 operazioni**. Sul Dow la cella viva ne ha **130
OOS e 74 IS**, e ogni filtro le riduce.

**Emendamento regola B — la valvola:** *"il campione sottile sospende il
giudizio sul MERITO, mai sul RISCHIO"*.

Proposta:
- **RISCHIO**: si giudica **sempre**, a qualunque n. Un DD è un fatto accaduto.
- **MERITO sul DAX** (n OOS atteso ~270): si giudica.
- **MERITO sul Dow** (n OOS 130): 🔴 **SOSPESO per regola.** Il Dow produce
  **indizi**, non verdetti — e serve a G3 come **conferma di direzione**, non
  come promotore.

> ✍️ **FIRMATO (decisione 3): il MERITO sul Dow è SOSPESO.** L'alternativa
> scartata era abbassare la soglia a
> **100** dichiarandolo, come già fatto in R88 (*"n IS = 71, molto sotto 150 →
> giudizio di MERITO sospeso"*). **Non la propongo io**: cambiare una soglia
> dell'Emendamento perché scomoda è il modo classico di rovinarsi un metodo.

### G5 · NESSUNA PROMOZIONE ESCE DA QUESTO ROUND

Come R54 criterio 5 e R46 criterio 4: **le due celle stanno sul conto 100k**.
R101 produce **informazione**, non deploy. Un eventuale cambio al forward è
**una firma successiva**, con il suo referto.

### 5.1 📊 Cosa si scrive nel referto, per ogni gradino

Sempre, e sempre col **n accanto**: `profitto IS/OOS · PF IS/OOS · DD IS/OOS ·
n IS/OOS · Δ vs viva (PF e DD) · esito G1 · esito G2 · esito G3`.

**E la colonna che dice il mestiere del round:** *"quanto è costato / quanto ha
reso questo filtro"*, in **euro** e in **trade tolti**.

---

## 6. 🚫 COSA NON SI SPAZZOLA — e perché

**Questa sezione vale quanto i cancelli.** Ogni riga è una cosa che sarebbe
comodo rimettere in discussione, e che **è già stata misurata**.

| cosa | perché NON si tocca |
|---|---|
| **La gestione** (parziale, BE, trailing, TrailMode, TrailTF, TrailStartR) | **R46 l'ha già misurata** su entrambi gli indici: *"il trailing è ASSOLTO"*, PREVBAR M5 è il migliore su tutti e due, e togliere il parziale **è stato bocciato** (2 cancelli su 3 falliti sul Dow). R24 ha già misurato la soglia del trailing (0 = migliore OOS) |
| **I lati long / short** | **R54 li ha già misurati sul Dow**: short PF OOS **0,840**, long+short −42% di profitto e DD quasi doppio. Bocciati per MERITO, non per campione (n = 73) |
| **`InpAllowReverse` (DAX)** | **R51 l'ha già misurato**: +74,6% OOS, ma **peggior giornata da −1,07% a −2,06% (×1,93)** → **RISERVA**. E il verbale è esplicito: *"il diritto di riaprire il caso lo dà il forward, non un altro giro sulla stessa finestra OOS già guardata otto volte"* |
| **La geometria d'ingresso** (EntryMode, RangeMinutes, Buffer, RetestOffset) | è **la cella promossa dal walk-forward del 06/08**. È il motore, non un filtro: rimetterla in griglia sarebbe un altro round |
| **Le soglie dei filtri** (VolMult, AtrFilterMult, StAtrPeriod, StMultiplier, CorrEma, RoundStep) | griglia = pesca. Il perimetro firmato dice *"Nessuna griglia, nessuna pesca"*. Si usa il default, si dichiara che è **nostro** (§ 3.2) |
| **Il rischio** (1,0% nel test) | è una scelta di **taglia**, non di strategia (§ 2.4) |
| **`InpSlippagePts`** | resta a 0, come in R46/R54. Uno stress di slippage è un altro round, con la sua tesi |
| **Il Nasdaq** | **chiuso** da R97 (0/4) + R98 (0/6) + sedia 770201 senza contratto. La regola della seconda caccia vieta *"parametri diversi dello stesso motore morto"* |

---

## 7. ⛔ IL FILTRO NEWS — perché NON è nella scala (e non è una dimenticanza)

`InpUseNewsFilter` **è implementato** e legge un CSV da `MQL5/Files`, quindi
sarebbe backtestabile. **Ma i dati che abbiamo non coprono la finestra**, e in
modo **asimmetrico**, che è il verso peggiore:

| file in repo | copertura | righe |
|---|---|---|
| `mql5/Files/abtg_news_2021_2025_UTC.csv` | 2021.01.04 → **2025.12.19** | 2.972 |
| `mql5/Files/abtg_news.csv` (il **default** di `InpNewsFile`) | **2026.01.07 → 2026.12.17** | **18** |

L'OOS va al **2026.06.30**. Con il file 2021-2025 il filtro sarebbe **spento di
fatto negli ultimi 6 mesi dell'OOS**; con quello di default sarebbe spento in
**tutto l'IS e in metà OOS**, e acceso su 18 eventi.

👉 In tutti e due i casi **il filtro varrebbe su una metà della finestra e non
sull'altra**: il numero che ne uscirebbe non misurerebbe il filtro, misurerebbe
il buco nei dati. **Un filtro mezzo acceso è peggio di un filtro spento: è un
numero che sembra una misura.**

**Conseguenza:** il filtro news va nella lista **"richiede preparazione"** (§ 8,
voce 5), non nella scala. ✍️ **FIRMATO (decisione 5): il filtro news resta
FUORI da questo round.**

---

## 8. 🛠️ RICHIEDE SVILUPPO — round futuri, non questo

> Regola del perimetro firmato: **in R101 non si scrive codice EA.** Tutto ciò
> che chiede una riga di MQL5 finisce qui, con la spec, e aspetta il suo round.

### 8.1 🥇 LA MEDIAZIONE / INGRESSO IN 2 TRANCHE 1:2 — richiesta di Claudio del 23/08

> ### 🔴 VERIFICATO NEL CODICE: **l'input NON esiste.** Né sul Dow né sul DAX.

Cercati e **non trovati**: nessun `InpUseIngressoFrazionato`, nessuna
`tranche`, nessun `SizeDiv`. L'unica occorrenza della parola *"mediazione"* nei
due sorgenti è un commento del blocco R51 che dice **il contrario**:
*"⚠️ Questo NON è la «mediazione»: la size resta quella del rischio (1R)"*.
E `InpTP1_ClosePct` è una **uscita** parziale, non un **ingresso** frazionato.

👉 **Quindi la mediazione NON è una cella di R101.** Va qui, con la spec.

**Da dove viene la richiesta.** Dallo screenshot del corso, ed è **misurato**
(`ANALISI_APERTURE_4DOC` misura **M1**, AM SLIDE 10, etichette d'ordine su
`D30EUR.bcm,M5`): `#61756700 buy **10.00**` e `#61756747 buy **limit** 20.00`.
**1:2, e la tranche grande è quella che si aggiunge CONTRO.** Il corso: *"Non
entriamo subito a mercato, ma divido la size … per entrare ad un prezzo
migliore. Lo stop, lo metto sotto ai minimi."*

**⚖️ E qui va detta una cosa a favore di Claudio, perché è tecnica.**
La bandiera **B1** dell'analisi di ieri è: *"rischio ≈ 2,5R venduto come 1R"* —
il corso somma due tranche sotto uno stop comune senza ridimensionarle.
**Il vincolo che Claudio ha posto — *"rischio TOTALE del ciclo = 1R"* —
è esattamente la correzione che disinnesca B1.** Non è la mediazione del corso:
è la stessa **geometria** con il **money management di casa**. Va misurata così,
e va scritto nel referto che il 1R di ciclo è **nostro**, non del corso.

**SPEC (per il round che la implementerà):**

| voce | spec |
|---|---|
| `InpUseIngressoFrazionato` | `bool`, **default `false`** → comportamento identico a oggi |
| `InpTranche1Pct` | `double`, **default 33.3** = 1:2 come [M1]. 100 = ingresso singolo |
| ancora della 2ª tranche | `enum`: (a) offset in **punti** dal 1° ingresso; (b) **EMA14** (è quella del corso: *"sulla media a 14 periodi"*); (c) il **livello rotto** (coerente col nostro RETEST) |
| **SIZING** — 🔴 il punto che decide tutto | La size si calcola sul **CICLO INTERO**: `lotti_totali` = quelli che, con lo **stop comune**, rischiano **`InpRiskPercent` × 1 R**. Poi si **divide** 33,3% / 66,7%. **MAI** "1R sulla prima e poi si aggiunge" — quello è il 2,5R travestito |
| stop | **comune e unico**, all'estremo opposto (`ABTG_SL_RANGE`, già il nostro default e **confermato da R88**). Non si sposta quando riempie la 2ª |
| TP / parziale / BE | **si ricalcolano sul prezzo MEDIO PONDERATO**, non sul primo ingresso. È la parte che chiede più codice |
| 2ª tranche non riempita | il ciclo pesa **1/3 R**. È un'asimmetria vera: va **contata e dichiarata** (quante volte riempie? è la prima cosa da misurare) |
| gestione | il core ha già lo stato **per-ticket** (`gPartialTk[]`, `gBETk[]`, hedge-safe): parziale/BE/trailing su **due** posizioni funzionano già. **Da verificare**, non da assumere |
| unità di conto | 🔴 **IL CICLO, NON IL TICKET.** Un ciclo genera fino a 2 posizioni + parziali: un report MT5 conterebbe il doppio delle "operazioni". **L'Emendamento regola A (≥150) conta CICLI.** È la condizione n° 3 di `ANALISI_CORSO_MEDIAZIONE_2026-08-18.md` § 1.13, e vale identica qui |
| conto | HEDGING (BCM 50503392) → due posizioni separate. Su netting sarebbe una sola: **da dichiarare** |
| prima misura da fare | **quante volte la 2ª tranche riempie**, e il **prezzo medio** che ne esce. Senza quel numero il resto non si legge |

### 8.2 Le altre, in coda

| # | cosa | perché non ora |
|---|---|---|
| 2 | **Catena di correlazione a 2 anelli** `225JPY → SPXUSD → D30EUR` [EU SLIDE 2/18] | il core ha **un solo** simbolo guida. Il gradino 06 misura **l'anello SPX**, non la catena |
| 3 | **%Custom come griglia di target** | **bloccato**: geometria misurata [M8] (passo 0,25% fino a 3,00%) ma **ancora [INCERTO]**. Serve lo screenshot del pannello Qqin Multipivot (domanda D2 a Claudio) |
| 4 | **Bollinger M15, ingresso fuori banda, target sulla mediana** [EU SLIDE 21] | nessun EA di casa lo fa. E i parametri delle bande **il corso non li dichiara** |
| 5 | **Filtro news backtestabile** | serve **un CSV unico 2024.09 → 2026.06** con la stessa densità (§ 7). È preparazione **dati**, non codice: si può fare prima del prossimo round |
| 6 | **Livelli Larry Williams della domenica** su D1/W1/M [EU SLIDE 9] | `ABTG_PunteLarry` esiste ma è **un'altra famiglia** |
| 7 | **`InpMinRangePts` / `InpMaxRangePts` come filtro di volatilità** | 🟠 **implementati e usabili senza codice** — ma la soglia (17 / 40 punti indice) viene dalla **live sul DAX** e non ha nessuna fonte per il **Dow**. Metterla nella scala sarebbe **pescare un numero**. Serve prima una misura della distribuzione delle ampiezze del range su ciascun simbolo |

---

## 9. ⚙️ ESECUZIONE — quanto costa e come si riprende

| | |
|---|---|
| file | **20** (10 Dow + 10 DAX) |
| CSV attesi | **40** (IS + OOS per file) |
| righe per CSV | **2** (le due gemelle) |
| passate | **80** |
| driver | `backtest_pipeline/righe/RIGA_R101_ABLAZIONE.ps1` (`MARCATORE_RIGA_R101_v1`) |
| macchina | **PC di backtest**, MT5 **e** MetaEditor **CHIUSI**. Una macchina, un lavoro |
| durata | **[STIMA]**, non una previsione. Il PASSO 0 misura una passata intera e stampa il tetto teorico. `-OreMax 12` è un tetto sull'**inizio** di nuovi file, non un'interruzione |

**Ripresa:** `-SoloEa DOW` / `-SoloEa DAX` fa una famiglia sola;
`-SoloCella R101_DOW_03_atr.txt` una cella sola. Senza `-Rifai` il driver
generico **salta** la finestra il cui CSV esiste già: il driver di R101 se ne
accorge dalla **data del file** e lo marca `SALTATO DAL DRIVER` fra i
**PROBLEMI**, non fra gli OK (un CSV di ieri non è un risultato di oggi).

---

## 10. ✍️ LE SEI DECISIONI — **FIRMATE il 23/08/2026**

> **Claudio:** *"FIRMO TUTTE E 6 CON LE PROPOSTE, POI FACCIO I 2 CONTROLLI"*.
> Tutte e sei firmate **con la proposta**, e **a numeri non visti** — che è la
> condizione che le rende valide. Da qui in poi **non si toccano**: i criteri
> si cambiano prima dei numeri, non dopo.

| # | decisione | ✍️ SCELTA FIRMATA | cosa comporta |
|---|---|---|---|
| **1** | Tolleranza di riproduzione del metro (G0) | ✅ **±0,01 PF · ±0,10 punti % DD · n ESATTO** | se il metro esce fuori tolleranza, **la famiglia si ferma** e i suoi gradini non vengono nemmeno lanciati |
| **2** | Il cancello di merito | ✅ **PF OOS più alto E DD OOS non peggiore** | più permissivo del "+10% di profitto" di R46, **ed è dichiarato**: su un'ablazione che toglie trade il profitto assoluto scende per costruzione |
| **3** | Il MERITO sul Dow (n OOS 130 < 150) | ✅ **SOSPESO** | il Dow produce **indizi**, non verdetti. Serve a **G3** come conferma di direzione, non come promotore. La soglia dell'Emendamento **non è stata abbassata** |
| **4** | Il 9° gradino "IL CORSO PIENO" | ✅ **SÌ** — volumi + ATR + Supertrend×3 + correlazione accesi insieme, **alle stesse soglie NOSTRE dei gradini singoli** | è la cella che **chiude il debito del 18/08**. ⚠️ Atteso: **n in crollo**, probabilmente sotto G1 → *"non misurabile"* — **che è già una risposta**. Vedi § 3.4 |
| **5** | Il filtro NEWS | ✅ **FUORI da questo round** | i CSV coprono metà finestra (§ 7): misurarlo oggi misurerebbe il buco nei dati. Rientra dopo che è stato costruito il calendario unico 2024.09→2026.06 |
| **6** | La MEDIAZIONE 1:2 | ✅ **in coda di sviluppo**, con la spec del § 8.1 | l'input **non esiste** nei sorgenti (verificato). Il vincolo *"ciclo = 1R"* è scritto lì come **il** requisito di sizing — ed è ciò che disinnesca la bandiera B1 del corso |

### 10.0 🔴 CIÒ CHE ANCORA MANCA AL LANCIO — e non è una firma

Claudio ha detto *"POI FACCIO I 2 CONTROLLI"*. **Sono i due del § 10.1, e il
lancio aspetta quelli**: non sono opinioni da firmare, sono **due fatti da
leggere sul grafico**. Se uno dei due non torna, la cella viva scritta nei file
prova **non è la sedia viva**, e i 20 file vanno corretti **prima** di lanciare
— non dopo aver visto i numeri.

### 10.1 🔴 LE DUE VERIFICHE SUL GRAFICO — **bloccanti per il lancio**

Sono contrassegnate **[DA CONFERMARE]** nel § 2 perché vengono dai default del
sorgente e **non** da un artefatto di deploy. Cinque minuti sul VPS, con MT5
aperto sui due grafici vivi:

1. **Dow** — `InpMinStopPts` è davvero **500** e `InpSkipIfTight` **false**?
   `InpMinRangePts` / `InpMaxRangePts` sono davvero **0 / 0**?
2. **DAX** — `InpAllowShort` sul grafico è davvero **0**? (il sorgente dice
   ancora `true`: il lato è spento **sul grafico**, e sul DAX il solo-short
   **non è mai stato misurato**)

> Se uno di questi non torna, **la cella viva di R101 non è la sedia viva**, e i
> file prova vanno corretti **prima** di lanciare. È lo stesso difetto che il
> 06/08 fece tornare al default il buffer di un EA senza che nessuno se ne
> accorgesse.

---

## 11. 🚫 QUELLO CHE R101 **NON** FARÀ, dichiarato

- **Non promuove niente e non tocca nessun forward** (G5). Produce misure.
- **Non cerca la cella migliore.** Cerca **quanto pesa ogni filtro**.
- **Non dimostra che il metodo del corso funziona o non funziona** su tutti i
  mercati: lo misura su **due sedie, un broker, un regime**.
- **Non misura lo spread** e non inventa nessun numero non letto in un
  artefatto.
- **Non riapre il Nasdaq**, né il lato short del Dow, né `InpAllowReverse`.
- **Non scrive una riga di codice MQL5.**

---

_Bozza compilata il 23/08/2026 · file prova già scritti e verificati
(`prove/R101_*.txt`) · driver `righe/RIGA_R101_ABLAZIONE.ps1` ·
**nessuna passata lanciata, nessun sorgente EA toccato, nessuna modifica al
forward.**_

---

## ✅ PAR. 10.1 CHIUSO — I DUE CONTROLLI SUL GRAFICO SONO FATTI (23/08, sera)

Screenshot dei pannelli VIVI del conto 100k, letti riga per riga:
- **DOW (U30USD, 770202, v1.01)**: `InpMinStopPts` **500** ✓ · `InpSkipIfTight`
  **false** ✓ · `InpMinRangePts`/`InpMaxRangePts` **0/0** ✓. E la geometria
  combacia con la cella congelata: RETEST con LIMIT, durata range 35,
  buffer 1000, offset 400, solo long.
- **DAX (D30EUR, 770101, v1.01)**: `InpAllowShort` **false** ✓ (solo long,
  come dagli artefatti). Geometria: RETEST, durata 35, buffer 500, offset
  200, tutti i filtri SPENTI (EMA/ST/ST×3/correlazione/VWAP/volumi/ATR),
  parziale 50 + BE + trailing base candela M5/410 — coerente con la cella
  viva congelata.

**La cella viva dei 20 file prova E' la sedia viva. Via libera alla corsa.**
