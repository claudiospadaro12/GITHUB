# ⚖️ R91 — CRITERI CONGELATI **PRIMA** DEI NUMERI — ✍️ **BOZZA DA FIRMARE**

> ## ✍️ FIRMA DI CLAUDIO: ______________________  (data/ora: ______________)
>
> **Finche' questa riga e' vuota, i numeri di R91 non si guardano.**
> Senza firma il round non parte e i CSV, se per qualunque motivo esistessero
> gia', restano sigillati.

_Scritto il **20/08/2026**, a numeri di R91 **MAI VISTI**: nessuna passata di
R91 e' stata girata, il file prova non e' stato lanciato, l'input nuovo
(`InpMinRR`) e' stato scritto oggi e **non e' mai stato compilato**._

I numeri di **R33 e R34 SI'**, sono visti: sono la riga di riferimento e stanno
scritti qui sotto al centesimo (§4.0). Vengono dai CSV gia' agli atti in
`backtest_pipeline/risultati_prove/ABTG_BreakingBand/r33/` e `r34/`.

---

## 0. 🤝 LA PROMESSA DI ONESTA' — e una dichiarazione scomoda che va fatta SUBITO

### 0.1 Questo round NON nasce cieco. Nasce da UN trade.

Gli altri round di casa nascono da un dossier scritto prima. **Questo no, e va
detto con parole chiare invece di nasconderlo:**

> **R91 nasce da UN SOLO trade del forward, osservato oggi 20/08/2026.**
> Sedia **`BB GBPUSD INV S`** (magic **772161**, conto piccolo 50503392):
> aperta **20/08 09:00:00** short a **1.36246**, chiusa **19:13:01** al **TAKE
> PROFIT 1.36221** = **+3,43 lordo / +2,69 netto** (commissione 0,74).
> Lo stop stava a **1.36610**.
> **Guadagno 2,5 pip contro un rischio di 36,4 pip: RR = 1 : 0,069.**

**Un trade non e' un campione.** Regola di casa, ripetuta mille volte: *tre trade
non sono un segnale*, e uno lo e' ancora meno. Quindi la scelta della cella
**non e' cieca** e va dichiarato l'unico modo in cui questo round e' onesto:

- ❌ **NON e' vero** che "il forward ha dimostrato che serve un filtro di RR".
  Il forward ha mostrato **un singolo esito**, per giunta **VINCENTE** (+2,69).
- ✅ **E' vero** che quel trade ha fatto **leggere il sorgente**, e nel sorgente
  c'e' un fatto strutturale che **non dipende da quel trade** e sarebbe li'
  anche se il trade non fosse mai esistito (§0.2).

**Il test dell'onesta', scritto prima come in R88:** *se quel trade avesse
chiuso in stop invece che in take profit, la cella di R91 sarebbe esattamente
la stessa* — perche' nasce dall'asimmetria letta nel codice, non dall'esito.

### 0.2 IL FATTO STRUTTURALE (letto nel codice, non dedotto dai risultati)

In `mql5/Experts/ABTG_BreakingBand.mq5` (v1.02, la versione che gira in campo):

| pezzo | da dove nasce | riga |
|---|---|---|
| **SL** | `InpSL_ATRmult * atr` = **3 x ATR fissi** (regola della guida) | 241 (input), ~1085 |
| **TP** | `double tp=(InpTPMode==1)?bandaRunner:mediana;` = **GEOMETRIA DELLE BANDE** | ~1096 |

**Le due misure non sono legate fra loro.** L'ATR e' congelato sulla volatilita'
del bulge; la mediana e' dove si trova la banda **adesso**, nella fase
post-bulge in cui le bande **si stanno restringendo per costruzione** (lo
pretende il codice stesso: `BandeInChiusura` e' obbligatoria per l'INVERSIONE).
Se all'ingresso il prezzo e' gia' quasi sulla mediana, **il TP nasce a due passi
e lo stop resta a tre ATR**.

E i controlli che c'erano **non guardano il rapporto**:
- `tpOk` (~1102) verifica solo che la mediana **non sia gia' superata**;
- il minimo del broker (`StopsMinDist`) verifica solo che sia **legale**;
- `InpMinTPatATR` (riga 247) esisteva gia'... **ma vale `0.0` = SPENTO**, e
  comunque misurerebbe una **distanza**, non un **rapporto**.

📌 **[INFERITO, non misurato]** Il meccanismo che porta a un TP a 2,5 pip e'
probabilmente questo: l'INVERSIONE si arma sul **retest della banda** (che puo'
essere un **tocco di ombra**), mentre `Enter()` compra/vende al **prezzo
corrente** della barra dopo. Se la barra del tocco rientra e chiude vicino alla
mediana, **l'ingresso avviene lontano dalla banda testata e vicino
all'obiettivo**. Questo va **VERIFICATO** con la distribuzione del RR (§5), non
dato per buono.

---

## 1. 🎯 LA DOMANDA DEL ROUND — una sola, e la sua falsificazione

| | |
|---|---|
| **LA DOMANDA** | **Rifiutare gli ingressi in cui il TP non paga il rischio (`\|tp-entry\| / \|entry-sl\| < InpMinRR`) migliora l'ASPETTATIVA PER TRADE della Breaking Band, senza far scendere la famiglia sotto la soglia di misurabilita'?** |
| **FALSIFICAZIONE** | Se i trade tagliati dal filtro sono **in media VINCENTI**, il filtro **danneggia** e si butta — anche se qualche cella facesse un numero piu' bello. Il precedente di casa e' scritto e vale: *filtro aggiunto DOPO a un motore gia' tarato = 0 successi su 5* (R20, R12, R26, R45, R54). |

### 1.1 🔴 LA COSA PIU' IMPORTANTE DI TUTTO IL FILE

> ## **UN FILTRO DI RR NON E' AUTOMATICAMENTE UN MIGLIORAMENTO.**
>
> Sembra ovvio che "prendere solo trade che pagano" sia meglio. **Non lo e'**, e
> il motivo e' geometrico, non filosofico:
>
> - Il TP **vicino** e' anche il TP **FACILE**. Un obiettivo a 2,5 pip si
>   raggiunge quasi sempre: sono proprio quelli i trade con **win rate altissimo**.
> - Tagliandoli si tolgono **molte piccole vincite** e si lasciano in piedi i
>   trade con obiettivo lontano, che hanno **piu' tempo per andare in stop**.
> - Risultato possibile e perfettamente coerente: **win rate che crolla,
>   aspettativa che PEGGIORA, e magari PF che sale lo stesso** (il PF puo'
>   salire mentre il conto guadagna meno).
>
> **Per questo i cancelli di R91 si scrivono sull'ASPETTATIVA PER TRADE e sul
> NETTO, MAI sul win rate.** Il win rate in questo round e' una **spia
> diagnostica**, non un giudice: non promuove e non boccia niente.

### 1.2 ⚠️ Il cancello giudica il RR **ALL'INGRESSO**, non quello realizzato

`RefreshTakeProfit()` **sposta il TP a ogni barra** dietro la mediana che si
muove. Quindi un trade che nasce con RR 0,07 **puo' finire con un RR piu'
grande** se la mediana si allontana. `InpMinRR` non lo sa: taglia sulla foto
dell'ingresso. **E' un limite del filtro, dichiarato prima**, e va ripetuto nel
referto accanto a ogni conclusione.

---

## 2. 🧬 CONT o INV? — LA DECISIONE, MOTIVATA, PRESA PRIMA

**Il filtro e' stato messo su ENTRAMBI i pattern (continuazione e inversione).**
Le tre ragioni, tutte lette nel codice:

1. **Il TP e' lo STESSO per tutti e due.** `Enter()` e' una funzione sola: la
   riga `tp=(InpTPMode==1)?bandaRunner:mediana;` non guarda il pattern. Anche lo
   SL e' lo stesso (3 x ATR). **L'asimmetria non e' una proprieta' dell'INV: e'
   una proprieta' di `Enter()`.**
2. **Anche la CONTINUAZIONE puo' entrare vicino all'obiettivo.** Entra al
   **tocco della banda opposta** con `InpContRequireNarrow=true`, cioe' **con le
   bande gia' in chiusura**: la distanza banda-mediana e' ~2 sigma di bande che
   si stanno restringendo, mentre lo stop resta ancorato all'ATR del bulge. Lo
   stesso identico scollamento.
3. **Un filtro condizionato al pattern sarebbe una scelta fatta sui risultati.**
   Restringerlo all'INV solo perche' il trade osservato era un INV significa
   **tarare sul singolo caso**: e' esattamente il curve fitting che qui e'
   vietato.

### 2.1 E allora COME si misurano separatamente? Gratis, dalla mappa di R33.

Non serve nessun input in piu': **le tre sedie sono gia' un esperimento
separato**, perche' R33 ha assegnato a ogni mercato **un pattern solo**.

| file prova | simbolo | `InpPatternMode` | cosa misura il filtro RR |
|---|---|---|---|
| `R91b_rr_EURUSD.txt` | EURUSD | **0 = solo CONT** | 🧪 **effetto PURO sulla CONTINUAZIONE** |
| `R91c_rr_AUDUSD.txt` | AUDUSD | **1 = solo INV** | 🧪 **effetto PURO sull'INVERSIONE** |
| `R91a_rr_GBPUSD.txt` | GBPUSD | **2 = combinato** | ⚗️ effetto sulla **MISCELA** (non separabile) |

> ⚠️ **Da scrivere nel referto:** su GBPUSD **non si puo' dire quale pattern e'
> stato tagliato**. Se serve, e' un altro round (due passate con
> `InpPatternMode` 0 e 1 su GBPUSD).

---

## 3. 🪟 LE FINESTRE, E IL CANARINO CHE COMANDA QUESTO ROUND

### 3.1 La finestra: **pin identico a R33/R34**, per confronto alla pari

| voce | valore | fonte |
|---|---|---|
| simboli / TF | **GBPUSD · EURUSD · AUDUSD, H1** (`InpTF=16385`) | `R34a/b/c` |
| storico | **`@DAQUANDO 2024.09.26`** | identico a R33/R34 (muro dei dati di BCM) |
| fine | **`2026.06.30`** (default `-Fino`) | `walkforward_generico.ps1` |
| split | **40/60** (`-FrazioneIS 0.40`, default) | idem |
| **IS** | **2024.09.26 → 2025.06.09** | 642 giorni x 0,40 = 256 giorni |
| **OOS** | **2025.06.10 → 2026.06.30** | ~12,7 mesi |
| deposito | **100.000** (`-Deposito 100000`) | **obbligatorio**: e' l'unico modo di riprodurre R34 al centesimo |
| dato | **TICK REALI BCM** (come R33/R34) | non OHLC: qui il merito sarebbe leggibile, se ci fosse il campione |

**Il REGIME contenuto, da scrivere accanto a ogni numero:** UNO SOLO — forex
2024-2026 (dollaro debole nella seconda meta' della finestra). Niente 2015,
niente 2020, niente 2022. **R91 misura l'effetto di un cancello dentro un
regime, non la robustezza di regime** (quella e' la regola C dell'Emendamento
ed e' un altro round).

### 3.2 🐤 IL CANARINO DELLA FREQUENZA — **il vincolo piu' stretto di R91**

Questa e' la parte che va letta due volte, perche' qui **il campione e' gia'
minuscolo PRIMA di filtrare**, e il filtro lo puo' solo ridurre:

| sedia | n OOS base | mesi | **trade / mese** |
|---|---:|---:|---:|
| BB GBPUSD (CONT+INV) | **26** | 12,7 | **2,05** |
| BB EURUSD (solo CONT) | **13** | 12,7 | **1,02** |
| BB AUDUSD (solo INV) | **11** | 12,7 | **0,87** |
| **FAMIGLIA** | **50** | 12,7 | **3,94** |

Il **criterio di uscita delle sedie del 18/08** giudica il MERITO di una
famiglia a **20 operazioni** e fa il **tagliando a 6 mesi**. A 3,94 trade/mese
la famiglia BB arriva a 20 operazioni in **~5,1 mesi**: entra nel tagliando
**per un soffio**. Quindi:

| taglio del filtro | trade/mese famiglia | mesi per 20 op | verdetto |
|---:|---:|---:|---|
| 0% (oggi) | 3,94 | 5,1 | ✅ misurabile |
| **-30%** | 2,76 | **7,2** | 🐤 **CANARINO: si sfora il tagliando** |
| **-50%** | 1,97 | **10,2** | ⛔ **VETO: la sedia diventa non misurabile** |

> ### 🔴 CONSEGUENZE, ACCETTATE IN ANTICIPO
> 1. **Una cella che taglia piu' del 30% dei trade NON si propone**, per quanto
>    bella sia. Comprare "qualita'" pagando in **cecita'** e' un cattivo affare:
>    una sedia che non si puo' misurare non si puo' nemmeno licenziare.
> 2. **Una cella che taglia piu' del 50% e' bocciata secca**, senza discussione.
> 3. **Il MERITO e' SOSPESO in tutto R91** (valvola R59): il campione base e'
>    **11-26 trade per cella**, **sotto 30**. Da R91 **non puo' uscire nessuna
>    promozione automatica**: esce una **proposta motivata**, o niente.
> 4. Il **RISCHIO si legge lo stesso** (regola B dell'Emendamento: *un drawdown
>    e' un fatto accaduto, non una stima*).

### 3.3 E l'IS? Si legge, ma per **due** simboli su tre e' un aneddoto

| finestra IS | n | leggibile? |
|---|---:|---|
| GBPUSD IS | **13** | solo come **spia di rischio** (sotto 30) |
| EURUSD IS | **4** | ❌ **aneddoto**: quattro trade non sono una finestra |
| AUDUSD IS | **5** | ❌ **aneddoto** |

⚖️ **Correzione R90 applicata anche qui (non retroattiva):** il cancello
storico *"PF IS >= 1,10"* **NON si applica** — giudicherebbe il MERITO sulla
finestra vecchia, cioe' l'opposto della regola B. L'IS di R91 serve a **una cosa
sola**: verificare che il filtro non produca un **ribaltone di segno** fra le
due finestre (se in IS aiuta e in OOS distrugge, o viceversa, e' rumore).

---

## 4. 🚪 I CANCELLI — le soglie NUMERICHE, congelate

### 4.0 ✅ LA RIGA DI SANITA' — da riprodurre AL CENTESIMO, prima di tutto

**La cella `InpMinRR=0` DEVE ridare esattamente questi numeri.** Vengono dai CSV
di R34 (deposito 100.000, tick reali, stesso pin, stesso driver):

| sedia | finestra | **Profit** | **EP/trade** | **PF** | **Equity DD %** | **n** |
|---|---|---:|---:|---:|---:|---:|
| **GBPUSD** (patt. 2) | IS | +2.667,18 | 205,16769 | 2,72613 | 1,6960 | **13** |
| **GBPUSD** (patt. 2) | **OOS** | **+3.160,10** | **121,54231** | **1,73020** | **3,4801** | **26** |
| **EURUSD** (patt. 0) | IS | +1.457,02 | 371,15500 | 53,79058 | 0,7797 | **4** |
| **EURUSD** (patt. 0) | **OOS** | **+2.069,82** | **159,21692** | **3,86266** | **1,2722** | **13** |
| **AUDUSD** (patt. 1) | IS | +1.291,32 | 258,26400 | 47,99127 | 0,6753 | **5** |
| **AUDUSD** (patt. 1) | **OOS** | **+1.840,67** | **167,33364** | **2,74743** | **1,2695** | **11** |

> 🛑 **SE LA CELLA `InpMinRR=0` NON RIPRODUCE QUESTE RIGHE, IL ROUND SI FERMA.**
> Vorrebbe dire che `InpMinRR=0` **non e' un no-op**, cioe' che la v1.03 ha
> cambiato qualcosa che non doveva cambiare. Si cerca prima il perche'. E' lo
> stesso controllo che ha validato la v1.01 in R55.

#### ⚠️ Discrepanza gia' nota fra referto e CSV — **da chiarire, non da nascondere**
Il `REFERTO_ROUND34` e `report/CONTRATTI_SEDIE.md` scrivono per GBPUSD
**"+3.345, DD 1,9%"**; il CSV `r34` dice **+3.160,10, Equity DD 3,4801%**.
Sono **due strumenti diversi** [INFERITO]: il CSV e' l'`Equity DD %` del tester,
l'1,9% e' presumibilmente il **DD della serie dentro il simulatore di
portafoglio**. **In R91 vale la colonna del CSV**, perche' e' quella che il
driver riprodurra'. Il numero del contratto (DD promesso 1,9%) **non si tocca e
non si confronta con questo**: e' il metro del forward, non del tester.
👉 **TODO agli atti** (§7).

### 4.1 🥇 CANCELLO A — **IL FILTRO AIUTA** (il cancello CENTRALE)

Si legge **in OOS**, sedia per sedia. Servono **tutte e cinque**.

| # | soglia | numeri per sedia (GBPUSD / EURUSD / AUDUSD) | da dove esce |
|---|---|---|---|
| **A1** 🥇 | **L'aspettativa dei trade TAGLIATI dev'essere NEGATIVA.** Si calcola per differenza: `(Profit_base - Profit_cella) / (n_base - n_cella)`. | deve venire **< 0** | **E' LA MISURA DEL ROUND.** Se e' >= 0 il filtro ha tagliato, in media, **vincenti**: qualunque altro numero diventa irrilevante. Non serve nessuno strumento nuovo: esce dai due CSV. |
| **A2** | **Netto OOS >= 90% del netto base** | **>= 2.844,09** / **>= 1.862,84** / **>= 1.656,60** | Il conto si misura in **soldi**, non in eleganza. Si accetta di pagare al massimo il **10%** del profitto per comprare qualita'. |
| **A3** | **Aspettativa per trade OOS >= +20% sulla base** | **>= 145,85** / **>= 191,06** / **>= 200,80** | Meno di +20% su 11-26 trade **non e' distinguibile dal rumore**: un solo trade in piu' o in meno muove l'EP del 4-9%. Sotto quella soglia si scrive "nessuna differenza misurabile". |
| **A4** | **PF OOS >= PF base** **E** **DD OOS <= DD base + 0,30 punti** | PF >= 1,73020 / 3,86266 / 2,74743 · DD <= 3,7801 / 1,5722 / 1,5695 | Il filtro non puo' peggiorare ne' l'efficienza ne' il rischio: **e' un filtro, non un trade-off**. |
| **A5** 🐤 | **Taglio dei trade <= 30%** | **n OOS >= 18** / **>= 9** / **>= 8** | §3.2, il canarino della frequenza. **Non trattabile.** |

### 4.2 ⚫ CANCELLO B — **IL FILTRO DANNEGGIA** (bocciatura secca)

Basta **UNA**:

- **B1** 🥇 **Aspettativa dei trade tagliati >= 0** → il filtro sta togliendo
  vincitori. **Fuori, comunque vada il resto.** *(E' l'ipotesi PIU' PROBABILE
  a priori, §1.1: va scritta nel referto come tale, non come sorpresa.)*
- **B2** **Netto OOS < 70% della base** (< 2.212,07 / < 1.448,87 / < 1.288,47)
  **oppure PF OOS < 1,10** (il cancello storico di R33).
- **B3** 🐤 **Taglio > 50%** (n OOS < 13 / < 6 / < 5).
- **B4** **DD OOS > DD base + 1,00 punto** (> 4,4801 / > 2,2722 / > 2,2695).

### 4.3 ⚪ CANCELLO C — **IL PAREGGIO**, dichiarato e non tirato

Se una cella sta **dentro il 10% di netto e dentro 0,3 punti di DD** dalla base,
e' un **PAREGGIO**: si scrive *"nessuna differenza misurabile"* e **non si
cambia niente**. **La cella in campo vince i pareggi per default**: cambiare un
parametro vivo costa un `.ex5` nuovo, un forward nuovo e la storia azzerata —
un pareggio non lo paga.

### 4.4 🎚️ LA REGOLA DI SELEZIONE — centro dell'altopiano, MAI il picco

Va **dichiarata insieme al numero**, altrimenti il numero non vuol dire niente
(lezione R70):

1. L'asse ha **4 celle ordinate** (0 / 0,5 / 1,0 / 1,5): la risposta dev'essere
   **ORDINATA**. Se 0,5 aiuta, 1,0 distrugge e 1,5 aiuta di nuovo → **rumore**,
   nessuna proposta.
2. Una cella si propone **solo se la sua vicina di un passo la accompagna**:
   entro **20% di PF** e **1,5 punti di DD**. Una cella che sporge da sola si
   scrive a referto come **"picco isolato, non proposto"**.
3. **COERENZA FRA SEDIE:** il filtro e' una correzione **strutturale**, quindi
   deve muoversi **nella stessa direzione su almeno 2 simboli su 3**. Se aiuta
   solo su GBPUSD (n=26, il campione piu' grande ma pur sempre 26), **e'
   pescaggio**, non un effetto.
4. Il **conteggio operazioni (n) va scritto accanto a OGNI numero**. Un numero
   senza n non entra nel referto.

---

## 5. 🔬 LA DIAGNOSTICA CHE VALE ANCHE SE IL FILTRO PERDE

Anche se **tutte** le celle > 0 vengono bocciate, R91 porta a casa una cosa che
oggi **non sappiamo**: **la distribuzione del RR all'ingresso della Breaking
Band**.

La v1.03 logga il RR **a ogni ingresso eseguito**, anche con `InpMinRR=0`
(riga: `... TP(mediana) 1.36221 RR 0.069 lot ...`). Quindi dalla passata base:

- **quanti** dei 26/13/11 trade nascono sotto RR 0,5 / 1,0 / 1,5;
- se il caso del forward (RR 0,069) e' **un'eccezione o la norma**;
- se sono concentrati su un pattern (verifica dell'ipotesi §0.2).

> 📌 **La raccolta DEVE includere il log del tester** (`Esperti`/`Giornale`)
> della passata `InpMinRR=0`, non solo i CSV. Senza log, la distribuzione si
> ricostruisce **solo per differenza** fra celle: si perde il "chi", resta il
> "quanti". Va messo nella riga di raccolta quando verra' scritta.
>
> ⏰ **E vale la regola di casa sulle ore**: i log del tester sono in **ora
> locale del PC**, il grafico e' in **ora server**. Non confrontare le due cose.

---

## 6. 🛑 IL VINCOLO — R91 PROPONE, CLAUDIO DECIDE

1. **NESSUN DEPLOY AUTOMATICO.** Da R91 non esce nessun `.set` in campo, nessun
   cambio a una sedia viva, nessun EA riattaccato a un grafico.
2. **Le tre sedie BB in campo NON si toccano mentre R91 gira.** Girano con
   `InpMinRR=0` (che nella v1.03 e' il default: **comportamento identico**).
3. **Se una proposta passasse tutti i cancelli**, la via di casa e' la **sedia
   gemella in parallelo con magic nuovo** (mai la sostituzione di
   772161/772162/772163), + aggiornamento di `report/CONTRATTI_SEDIE.md` con
   **DD e frequenza promessi nuovi** — perche' e' su quelli che il criterio di
   uscita del 18/08 misurera' il forward. **E la frequenza promessa CAMBIA per
   costruzione** se il filtro taglia: va riscritta, non ereditata.
4. **Un solo cambio alla volta.** `InpMinRR` e basta. Se dai numeri saltasse
   fuori che il vero problema e' il **prezzo di ingresso** (§0.2), quello e'
   **R92**, non una seconda modifica dentro R91.
5. **Ricompilare la v1.03 significa un `.ex5` nuovo per TUTTE E TRE le sedie
   vive.** Va fatto con la trafila degli screenshot + verifica `.chr` (legge
   dello screenshot), e va verificato che i **preset vecchi si carichino ancora**
   (`InpMinRR` e' in coda al suo gruppo: MT5 usa il default 0 per gli input
   assenti dal `.set` — **atteso, da confermare a schermo al primo caricamento**).

---

## 7. 📋 COSA DEVE CONTENERE IL REFERTO DI R91 (checklist)

- [ ] La **riga di sanita'** (§4.0) riprodotta al centesimo, dichiarata per
      prima. Se non torna: si scrive "round fermo" e si chiude li'.
- [ ] **n IS e n OOS accanto a OGNI numero**, senza eccezioni.
- [ ] **L'aspettativa dei trade TAGLIATI** (A1/B1), calcolata e scritta per
      **ogni cella di ogni simbolo**: e' la misura del round.
- [ ] Il **taglio in %** dei trade, cella per cella, col canarino di §3.2.
- [ ] La **distribuzione del RR** della cella base (§5), o la dichiarazione che
      il log non e' stato raccolto.
- [ ] Il **regime** dichiarato accanto a ogni tabella (§3.1).
- [ ] La **regola di selezione** dichiarata insieme alla cella eventualmente
      proposta (§4.4).
- [ ] Le celle bocciate scritte **per nome**, col cancello che le ha bocciate.
- [ ] Il **canarino del merito sospeso** (n < 30) ripetuto nel referto.
- [ ] La **differenza CONT (EURUSD) vs INV (AUDUSD)** letta esplicitamente, e la
      dichiarazione che su GBPUSD **non e' separabile**.
- [ ] Distinzione esplicita **[MISURATO] / [INFERITO] / [DICHIARATO]**.
- [ ] I **TODO aperti** (§8) chiusi o riportati.

---

## 8. 📌 TODO APERTI, agli atti PRIMA del round

1. **Discrepanza R34 referto (+3.345 / DD 1,9%) vs CSV r34 (+3.160,10 / DD
   3,4801%)** — §4.0. Da chiarire quale strumento ha prodotto il numero del
   contratto. **Non blocca R91** (che usa il CSV), **blocca** invece qualunque
   confronto fra forward e "DD promesso".
2. **I `.set` del vivaio BB non sono in repo** (`mql5/Presets/` non ha file
   BreakingBand): il pin di R91 e' preso dai file prova `R34a/b/c` + i default
   della v1.02. Se sul VPS i preset avessero un valore diverso da un default,
   **R91 misurerebbe una cella che non e' in campo**. 👉 **verifica da fare sul
   VPS prima del lancio** (screenshot o `.chr`).
3. **Log del tester da raccogliere** (§5), non solo i CSV.
4. **La v1.03 non e' mai stata compilata.** Prima di qualunque lancio: `F7` in
   MetaEditor, **0 errori 0 warning**, e il gate del pin che confronta il file
   su `lavoro` HEAD (vedi il difetto del gate segnalato in
   `CODA_PROSSIMA_SESSIONE.md`, ancora aperto).
5. **La riga di lancio NON e' in questo file** e non e' stata scritta: la scrive
   un altro agente **dopo** la firma, con l'`irm` che riscarica script e prove da
   `lavoro` e con la riga di raccolta finale (Desktop + `Compress-Archive`).
