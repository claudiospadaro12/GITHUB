# 📝 R102 — **LA CLASSIFICA LUNGA** — 🖊️ **BOZZA PER LA FIRMA DI CLAUDIO**

> ## 🗣️ LA DOMANDA CHE HA FATTO NASCERE IL ROUND (Claudio, 23/08 sera, in chat)
>
> **_"Vorrei che mi facessi una classifica di guadagno su 100k con più anni…
> Breaking Band mi hai detto 133k ma con 10 anni di storico avrebbe fatto lo
> stesso?"_**
>
> ⚠️ **QUESTO DOCUMENTO È SCRITTO A NUMERI DI R102 MAI VISTI.** I criteri si
> cambiano **PRIMA** dei numeri, mai dopo. Finché non c'è la firma, la riga non
> si manda.

**Oggetto**: le celle **VIVE** della flotta **NON-oro** e **NON-indice** —
forex e argento — misurate sulla **finestra più lunga che il broker permette,
simbolo per simbolo**.
**Driver**: `backtest_pipeline/righe/RIGA_R102_CLASSIFICA_LUNGA.ps1`
(marcatore `MARCATORE_RIGA_R102_v1`).
**File prova**: `backtest_pipeline/prove/R102_<ea>_<simbolo>_<magic>.txt`,
**uno per sedia** — 20 file.
**Macchina**: è quella di **R100** (`RIGA_R100_ORO_FLOTTA.ps1`, pin `adbc27c`
più le correzioni del verificatore fino a HEAD), **generalizzata a simboli
diversi**. Riusati **invariati**: driver-schema, parser B corretto
(`Bilancio` fra i sinonimi, netto = Profitto+Commissioni+Swap), gate gemelli,
gate della prima operazione a due misure indipendenti, `exit 0` esplicito,
ripresa `-SoloSedia`, tabella madre.

---

## 0. 🚫 REGOLA ZERO — **CHE COSA QUESTO ROUND NON È**, ed è il cuore

### 0.1 L'Emendamento regola B non è una postilla: è la cornice

Il 16/08 Claudio ha congelato la **regola B**:

> ### ⚖️ **Il VECCHIO giudica il RISCHIO. Il RECENTE giudica il MERITO.**

E non è un'opinione: **è nata da un caso MISURATO**. In R69, l'IS di
`PTE USDJPY` sulla finestra **2010-2016** (lo yen dell'Abenomics) dà **0 celle
positive su 28**; l'OOS recente ne dà **25 su 28**. Quella finestra **bocciava
per un'epoca morta**, non per un difetto del motore.

> ## 🔴 CONSEGUENZA, ED È LA RIGA PIÙ IMPORTANTE DI TUTTO IL DOCUMENTO
>
> **Il profitto che R102 misura sulla finestra VECCHIA NON giudica il MERITO di
> nessuna sedia.** Un `+133.000` su trent'anni **non è un permesso** ad alzare
> il rischio; un `-2.000` **non è una bocciatura**. Le uniche due letture
> legittime sono:
>
> | etichetta | domanda a cui risponde | strumento |
> |---|---|---|
> | **[ROBUSTEZZA]** | l'edge **attraversa i regimi**, o è **figlio del 2024-26**? | profitto/PF/n su finestra lunga, su finestra comune, nelle 4 finestre di regime, **e la spina dorsale anno per anno** |
> | **[RISCHIO]** | **quanto avrebbe perso** | DD lungo, DD di regime, **peggior giornata**, e il `2x` sul DD promesso |
>
> **Ogni colonna del referto porta la sua etichetta stampata accanto.** Non è
> decorazione: è la contromisura al modo più facile di sbagliare con questo
> round, cioè leggere una classifica di robustezza come una classifica di
> merito.

### 0.2 E le altre cose che il round NON è

- **NON promuove e NON boccia niente.** L'unico esito possibile per una sedia
  è: il contratto regge, oppure va in **REVISIONE** sulla corsia **RISCHIO**
  (firma 18/08), oppure **NON MISURABILE**.
- **NON è uno sweep e NON cerca celle.** Una cella sola per sedia, quella
  **VIVA**, congelata. L'unico asse `Y` è `InpMagic`, che è la **coppia
  gemella di controllo**. 🔴 **Se una sedia esce male, la risposta NON è
  "proviamo un'altra cella sulla finestra lunga": quello sarebbe pescare**
  (regola della seconda caccia: su un motore senza edge un'altra griglia trova
  solo picchi di rumore).
- **NON tocca nessuna sedia viva.** Magic **vergini** del blocco `79xxxx`:
  verificato **magic per magic, tutti e 300**, zero occorrenze in tutto il
  repo. Tutti i magic vivi del censimento `.chr` del 23/08 e i blocchi già
  spesi (`7799xx` di R99, `78xxxx` di R100) sono **vietati e controllati nel
  codice**.
- **NON è un permesso**, ed è la §4.

---

## 1. 🔬 IL BANCO, E I SUOI DUE LIMITI — dichiarati prima dei numeri

### 1.1 Modello **OHLC su M1**, e non c'è alternativa

I **tick reali di BCM partono dal 2024.07.05**. Su venti o trent'anni **non
esistono**, e nessuna riga può inventarli. Quindi:

- 🔻 **DD e peggior giornata sono un LIMITE INFERIORE del rischio.** L'OHLC non
  vede i percorsi dentro la barra: il vero è **peggiore**, mai migliore.

### 1.2 🟡 E IL SECONDO LIMITE È NUOVO, perché R99/R100 non misuravano il profitto

R99 e R100 erano round di **puro rischio**: leggevano solo il DD, e il PF/profitto
stava nei CSV *"perché il CSV è quello che l'EA scrive, non perché entri in un
verdetto"*. **R102 il profitto lo legge e lo mette in classifica**, quindi il
suo limite va scritto qui, non in fondo:

> ### 💸 **IL PROFITTO CHE ESCE È UNA STIMA DEL LORDO, E GENEROSA.**
> - **`Spread=0` nell'ini** = spread **CORRENTE** del terminale. Non è lo
>   spread storico: nel 1993, e ancora nel 2005, era **molte volte più largo**.
>   Su una strategia a molte operazioni la differenza col vero è **grande**, ed
>   è tutta **a sfavore**.
> - **Nessuno slippage, nessun requote, riempimenti ideali.**
> - Nessun **costo di rollover storico** diverso da quello che il tester applica
>   oggi.
>
> 👉 **UN NUMERO DI PROFITTO DI R102 NON È UN GUADAGNO.** È un **ordine di
> grandezza per confrontare le sedie fra loro**, sullo stesso banco e con gli
> stessi difetti. La frase da usare con Claudio è *"su questo banco avrebbe
> fatto X"*, mai *"avrebbe guadagnato X"*.

📌 **E vale anche per il `133k` della domanda**: qualunque sia il numero da cui
viene, prima di confrontarlo con quello di R102 bisogna sapere **con quale
modello, quale spread e quale finestra** era stato prodotto. Se non lo
sappiamo, i due numeri non si confrontano — si affiancano dichiarando la
differenza.

---

## 2. 🪑 IL PERIMETRO — chi c'è, chi non c'è, e perché

### 2.1 🔴 CHI NON C'È, e non è una scelta: è **MISURATO**

| escluso | motivo | fonte |
|---|---|---|
| **Gli 10 INDICI** (`D30EUR` `U30USD` `NASUSD` `SPXUSD` `225JPY` `F40EUR` `E35EUR` `E50EUR` `100GBP` `200AUD`) e le **2 ENERGIE** (`UKOIL` `USOIL`) | prima data **`2024.09.26`**, verdetto **`COMPLETO`**. 🎯 **`COMPLETO` è la parola che chiude la questione: non manca sul disco — IL BROKER NON CE L'HA.** Ventun mesi non sono una finestra lunga | `REFERTO_SONDA_STORICO_17-08.md` §3 |
| **L'ORO** (`XAUUSD`) | **già fatto**: R99 (`SupertrendReversal_Ottimizzato` 970901 — DD 9,02% su 22 anni, peggior giornata −0,68%, n=657) e **R100** (le altre 12 sedie oro, stessa macchina, 2004.06.11→2026.06.30). **Si CITANO, non si rifanno** | `R99_REFERTO.md`, `R100_REFERTO.md` |

> ⚠️ **E la conseguenza va detta ad alta voce**: di famiglie come **GapFill** e
> **PunteLarry** R102 misura **solo la metà forex**. `GapFill DOW` e
> `GapFill NIKKEI`, `PunteLarry DOW`, `PTE DOW`, `SuperWave DOW` restano fuori
> **per lo stesso motivo degli indici**. Una "classifica della flotta" che non
> contiene il Dow **non è la classifica della flotta**, ed è giusto saperlo
> prima di leggerla.
>
> 📌 Per gli indici la strada esiste ed è **l'import Dukascopy dal 2012**
> (macchina già collaudata in R56: 6 simboli, 15,2 M barre M1, zero scartate).
> **È un round diverso.**

### 2.2 🟢 LA COSA BUONA, e va detta: **in R102 non esiste il GRUPPO 2 di R100**

R100 aveva dovuto inventare una *"taglia di riferimento 1,00% dichiarata"* per
**nove sedie su dodici**, perché il loro rischio vivo **non esisteva come
misura** (assenti da tutti e sette i censimenti `.chr` del 17-19/08). Il
referto R100 metteva agli atti il prerequisito: **serve un censimento `.chr`
nuovo del VPS**.

> ### ✅ **QUEL CENSIMENTO ADESSO ESISTE:**
> `risultati_archivio/censimento_rischio_2026-08-23_1549.txt` — **56 sedie,
> misurato il 23/08/2026 alle 15:49**, cioè lo stesso giorno.
>
> **Tutte e venti le sedie di R102 hanno il rischio vivo MISURATO lì dentro.**
> Nessuna taglia di riferimento, nessun DD-per-1% da riscalare: il DD e il
> profitto che escono sono **quelli della sedia**.

### 2.3 📋 L'ELENCO — 20 sedie misurate, 1 dichiarata e non misurabile

Colonne: **rischio** e **commento** = MISURATI nel `.chr` del 23/08 15:49 ·
**@DAQUANDO** = MISURATO nella sonda del 17/08 (colonna `PrimaDataTF`, TF H1) ·
**cella** = artefatto di **deploy** nominato · **DD promesso** = estratto dal
driver da `CONTRATTI_SEDIE.md` **al pin** (i valori qui sotto sono la
**verifica eseguita** dal banco di prova, non un ricordo).

#### 🎯 BREAKING BAND — è la domanda esplicita di Claudio, e va per prima

| id | EA | simbolo | TF | @DAQUANDO | anni | magic | risk | cella (fonte) | DD prom. |
|---|---|---|---|---|---:|---|---:|---|---:|
| **C01** | `ABTG_BreakingBand` | **GBPUSD** | H1 | **1993.05.11** | 33,1 | 772161 | 1,0% | `deploy_vivaio_bb.ps1` · `VIVAIO_BB_GBPUSD` · pattern **2 (entrambi)** | 1,9% |
| **C02** | `ABTG_BreakingBand` | **EURUSD** | H1 | **1971.01.03** ⚠️ | (vedi §4) | 772162 | 1,0% | `VIVAIO_BB_EURUSD` · pattern **0 (CONT)** | 1,2% |
| **C03** | `ABTG_BreakingBand` | **AUDUSD** | H1 | **1993.04.26** | 33,2 | 772163 | 1,0% | `VIVAIO_BB_AUDUSD` · pattern **1 (INV)** | 1,2% |

#### 🪑 Le altre diciassette

| id | EA | simbolo | TF | @DAQUANDO | anni | magic | risk | cella (fonte) | DD prom. |
|---|---|---|---|---|---:|---|---:|---|---:|
| C04 | `ABTG_PTE` | GBPUSD | H1 | 1993.05.11 | 33,1 | 771322 | **0,5%** | `deploy_pte_gbpusd_b25.ps1` · buf 5 / TP2 2,0 | ⚠️ **AMBIGUO** |
| C05 | `ABTG_PTE` | GBPUSD | H1 | 1993.05.11 | 33,1 | 771332 | **0,5%** | idem · buf **25** / TP2 **3,0** (candidata R78) | ⚠️ **AMBIGUO** |
| C06 | `ABTG_PTE` | USDJPY | H1 | 1971.01.03 ⚠️ | (§4) | 771323 | 1,0% | `deploy_vivaio_r23.ps1` · `VIVAIO_PTE_USDJPY` | 3,97% |
| C07 | `ABTG_SuperWave` | GBPUSD | **H4** | 1993.05.11 | 33,1 | 770532 | 1,0% | `VIVAIO_SW_GBPUSD` — **grafico H4, `InpTF` H2** 🔴 | 1,04% |
| C08 | `ABTG_EasyTrend` | CHFJPY | H1 | 1992.02.18 | 34,4 | 772421 | 1,0% | `deploy_vivaio_ez.ps1` · TP_R 1,5 | 6,27% |
| C09 | `ABTG_EasyTrend` | GBPUSD | H1 | 1993.05.11 | 33,1 | 772422 | 1,0% | idem · TP_R 1,5 | 4,58% |
| C10 | `ABTG_EasyTrend` | AUDJPY | H1 | 1993.05.16 | 33,1 | 772423 | 1,0% | idem · TP_R **1,0** | 4,29% |
| C11 | `ABTG_CostToCost` | EURJPY | **H4** | 1993.04.26 ⚠️ | (§4) | 772361 | 1,0% | `deploy_vivaio_cost.ps1` · exit **2 (flip)** | 9,33% |
| C12 | `ABTG_CostToCost` | GBPCAD | **H4** | 2007.08.21 | 18,9 | 772362 | 1,0% | idem · exit **1 (R-based)** | 6,18% |
| C13 | `ABTG_CostToCost` | **XAGUSD** | **H4** | **2008.11.07** | 17,6 | 772363 | 1,0% | idem · exit **0 (cost puro)** | 4,48% |
| C14 | `ABTG_GapFill` | GBPUSD | H1 | 1993.05.11 | 33,1 | 772231 | 1,0% | `deploy_vivaio_gap.ps1` · fill **100** | 2,4% |
| C15 | `ABTG_GapFill` | EURUSD | H1 | 1971.01.03 ⚠️ | (§4) | 772232 | 1,0% | idem · fill **50** | 1,5% |
| C16 | `ABTG_GapFill` | AUDUSD | H1 | 1993.04.26 | 33,2 | 772233 | 1,0% | idem · fill **100** | 1,9% |
| C17 | `ABTG_PunteLarry` | EURAUD | H1 | 2004.06.16 | 22,0 | 772342 | 1,0% | `deploy_vivaio_larry.ps1` · punta/R/**L+S** | 3,7% |
| C18 | `ABTG_PunteLarry` | GBPJPY | H1 | 1993.04.18 | 33,2 | 772344 | 1,0% | idem · punta/R/**solo L** | 2,7% |
| C19 | `ABTG_PunteLarry` | GBPUSD | H1 | 1993.05.11 | 33,1 | 772345 | 1,0% | idem · libro/FPO/**solo S** | 5,1% |
| C20 | `ABTG_PunteLarry` | EURCAD | H1 | 1999.08.01 | 27,0 | 772346 | 1,0% | idem · punta/FPO/**solo L** | 4,8% |

> 🔴 **C07 È LA TRAPPOLA DA NON RIPETERE.** `ABTG_SuperWave GBPUSD` gira su un
> grafico **H4** con **`InpTF` = H2 (16386)** — sta scritto in maiuscolo in
> `deploy_vivaio_r23.ps1`: *"InpTF resta H2!"*. Il generatore dei file prova di
> R100 **derivava** `InpTF` dal timeframe del grafico: applicato qui, avrebbe
> misurato **un'altra sedia**. In R102 `InpTF` è **esplicito per sedia** e il
> generatore non lo deriva più.

### 2.4 ⛔ DICHIARATA E NON MISURABILE (1)

| EA | simbolo | magic | rischio | perché |
|---|---|---|---|---|
| `BREAKOUT_EA_JPY_v3` | USDJPY | **n/d** | **n/d** | 🔴 **IL SORGENTE NON ESISTE NEL REPO.** Misurato: zero file `BREAKOUT_EA_JPY_v3.mq5` (esistono `BREAKOUT_EA_JPY.mq5` e `BREAKOUT_EA_JPY_Multi.mq5`, che sono **altri EA**). Senza sorgente non c'è niente da compilare e niente da misurare. Nel `.chr` del 23/08 15:49 la riga **c'è ancora** e **non ha nemmeno un input di rischio leggibile** |

⚠️ **E non è una sedia qualunque**: è una delle **DUE SEDIE SENZA CONTRATTO**
del 18/08 (`CONTRATTI_SEDIE.md`), famiglia **SCARTATA pre-progetto** (paniere 7
cross JPY 2022-24: **−20.853 €, PF 0,67-0,95 su TUTTE, DD 30-48%**), e il 21/08
Claudio ha deciso **"A, SU JPY"**. 👉 **Questo "non misurabile" NON è un via
libera: è il rilievo**, ed è **lo stesso del 18/08**, ancora aperto sei giorni
dopo.

---

## 3. 📐 I NUMERI CHE R102 PRODUCE — e le loro etichette

### 3.1 Per ogni sedia, cinque cose

| # | numero | etichetta | strumento |
|---|---|---|---|
| **A** | **profitto / PF / DD / n** sulla **finestra LUNGA** del suo simbolo | [ROBUSTEZZA] + [RISCHIO] | `OptResults`, due passate **gemelle** |
| **B** | gli stessi sulla **finestra COMUNE** `2009.01.01 → 2026.06.30` | [ROBUSTEZZA] | idem |
| **C** | gli stessi dentro le **4 finestre di regime** di casa | [ROBUSTEZZA] + [RISCHIO] | idem |
| **D** | la **PEGGIOR GIORNATA in %** (muro prop giornaliero **5%**) | [RISCHIO] | deal del report `.htm`, netto = Profitto+Commissioni+Swap |
| **E** | la **SPINA DORSALE ANNO PER ANNO**: anno \| n \| netto \| cumulato | [ROBUSTEZZA] | idem |

**E una sola decisione MECCANICA**, ereditata **invariata** dalla firma del
18/08 e da R99/R100:

> ➡️ se il **DD lungo** di una sedia supera il **DOPPIO del DD promesso** in
> `CONTRATTI_SEDIE.md`, quella sedia va in **REVISIONE** sulla corsia
> **RISCHIO**, **senza altre discussioni**. Se non lo supera, il contratto
> resta **e ora ha vent'anni sotto**.

### 3.2 🏆 **LA FINESTRA COMUNE — è LA colonna della classifica**, ed è il punto da firmare

Le finestre lunghe hanno lunghezze **diversissime**: GBPUSD 33 anni, XAGUSD
17,6, GBPCAD 18,9. **Sommare o ordinare i profitti di finestre diverse
produrrebbe una classifica della PROFONDITÀ DELLO STORICO, non delle sedie**:
una sedia mediocre su GBPUSD batterebbe una sedia ottima su XAGUSD solo perché
ha avuto quindici anni in più per accumulare.

> ### ✅ **La tabella madre è ORDINATA SULLA FINESTRA COMUNE `2009.01.01 → 2026.06.30`** — 17,5 anni che **tutti e dodici i simboli hanno**.

**Perché il 2009 e non il 2008**: il simbolo più corto della lista è **XAGUSD
(2008.11.07, MISURATO)**, ed è lui a legare tutti gli altri.

> ### 🖊️ **DECISIONE 1 CHE RESTA A CLAUDIO**
> **Togliendo `CostToCost XAGUSD` (C13)** dal round, il vincolo diventa
> `GBPCAD 2007.08.21` e la finestra comune potrebbe scendere a
> **`2008.01.01 → 2026.06.30`** — cioè **prendersi dentro tutta la crisi del
> 2008**, che è la finestra di stress più interessante che abbiamo.
> - **A)** teniamo XAGUSD e la comune parte dal **2009** _(proposta del
>   preparatore: una sedia viva non si esclude da una classifica per comodità)_;
> - **B)** togliamo XAGUSD dalla classifica comune (**resta** nella tabella con
>   la sua finestra lunga) e la comune parte dal **2008**.

### 3.3 ⚖️ Le taglie diverse, e come si leggono

Diciotto sedie girano a **1,0%**, le due PTE GBPUSD a **0,5%**. **In euro non
sono confrontabili.** Il referto lo scrive sotto la tabella: per metterle sulla
stessa riga il loro numero va **raddoppiato**, **[APPROSSIMATO lineare]**,
convenzione di `CONTRATTI_SEDIE.md` §COME LEGGERE I NUMERI punto 2.

🔵 **Perché non si misura tutto a 1,00% e via**: perché il numero smetterebbe di
essere **quello della sedia viva**, e la corsia RISCHIO (il `2x`) va calcolata
sulla taglia vera. Si misura **alla taglia viva** e si dichiara la conversione.

### 3.4 🧮 L'indice di ROBUSTEZZA — **è un'etichetta, non un verdetto**

Quante delle **cinque** finestre di misura (COMUNE + le 4 di regime) chiudono
in **profitto**. Serve a dire in una riga *"il guadagno viene da tutte le
epoche"* oppure *"viene da una sola"*.

- ✅ **Porta sempre il DENOMINATORE VERO.** Una finestra `NON APPLICABILE` o non
  misurata **non conta come negativa**: si toglie dal denominatore e si
  dichiara. *"2 su 5"* e *"2 su 3, più 2 non misurate"* sono **due frasi
  diverse**, e il referto stampa la seconda.
- 🔴 **Non promuove e non boccia.** Nessuna soglia, nessun `k/5` minimo. È una
  descrizione.

### 3.5 🦴 LA SPINA DORSALE ANNO PER ANNO — **la risposta letterale alla domanda**

Dai deal del report `.htm` della passata singola: per **ogni anno solare** della
finestra dichiarata, **n operazioni** e **netto in euro** (+ cumulato).

Questo è ciò che permette di rispondere a *"con 10 anni avrebbe fatto lo
stesso?"* **guardando**, invece di stimare: si prende il cumulato dell'ultimo
decennio e lo si confronta col totale.

**[APPROSSIMATO], e resta scritto**: è il **flusso di cassa delle chiusure
realizzate**, non l'equity e **non il drawdown**. Una posizione aperta a
dicembre e chiusa a gennaio conta **tutta nell'anno della chiusura**.

### 3.6 🚦 GATE 4 — LA DENSITÀ, ed è **nuovo** e serve

> ### 🧨 **LA SONDA MISURA LA PRIMA DATA, NON LA DENSITÀ. E la differenza è enorme.**

Dal CSV della sonda del 17/08, colonne `PrimaDataD1` e `BarreD1`:

| simbolo | prima data dichiarata | barre D1 sul disco | anni "veri" a ~260 gg/anno |
|---|---|---:|---:|
| `EURUSD` | **1971.01.03** | 6.820 | **~26** |
| `USDJPY` | **1971.01.03** | 6.726 | **~26** |
| `EURJPY` | **1993.04.26** | 6.726 | ~26 |
| `GBPUSD` | 1993.05.11 | 6.412 | ~25 (su 33 nominali) |

🎯 **Una serie che il broker dichiara dal 1971 con 6.800 barre giornaliere NON è
"cinquantacinque anni di storico": è una serie RADA.** E ci sono due ragioni
indipendenti per non fidarsi delle date più vecchie:

1. **L'euro non esisteva prima del 1999.01.04.** Le serie `EURUSD`, `EURJPY`,
   `EURAUD`, `EURCAD` dichiarate prima di quella data sono **ricostruite**
   (tipicamente dall'ECU o dal marco): sono un **calcolo**, non un prezzo di
   mercato su cui qualcuno abbia potuto operare.
2. **Nel 1971 lo yen era agganciato a 360** (Bretton Woods, fine ad agosto '71;
   fluttuazione dal 1973). Un backtest che opera lì dentro non descrive niente.

> ### ✅ **COME R102 LO GESTISCE — e la scelta è: MISURARE, non tagliare a occhio**
>
> **Non si sceglie un pavimento a gusto.** Si usa la data della sonda così com'è
> e si aggiunge il **GATE 4**: per ogni sedia il referto stampa **quanti anni
> solari della finestra dichiarata hanno ZERO operazioni**, li elenca, e scrive:
>
> > _"la finestra NOMINALE è N anni, quella EFFETTIVAMENTE OPERATA è M. Ogni
> > volta che si dice «N anni di storico» su questa sedia, il numero da dire è
> > il secondo."_
>
> Così la classifica non può più contenere la frase *"trent'anni di storico"* su
> una sedia che ha operato in venti.

> ### 🖊️ **DECISIONE 2 CHE RESTA A CLAUDIO**
> Il driver ha lo switch **`-PavimentoData`** (default **vuoto = nessun
> pavimento**). Se la prima corsa mostra che le serie ricostruite fanno perdere
> ore o producono operazioni finte, **si rilancia con
> `-PavimentoData 1999.01.04` senza cambiare il pin**, e il referto lo dichiara
> in testa.
> - **A)** prima corsa **senza pavimento**, si guarda il GATE 4 e si decide dopo
>   _(proposta del preparatore: prima si misura, poi si taglia)_;
> - **B)** pavimento **`1999.01.04`** da subito su tutto — meno ore di macchina,
>   ma è una scelta fatta **prima** di aver visto il dato.

### 3.7 📅 Le finestre, per intero

| finestra | periodo | è un criterio? | da dove viene |
|---|---|---|---|
| **LUNGA** | `@DAQUANDO` del simbolo → `2026.06.30` | ✅ sì | sonda 17/08 |
| **COMUNE** | `2009.01.01 → 2026.06.30` | ✅ sì — **è la classifica** | legata da XAGUSD (§3.2) |
| **ORSO** | `2022.01.01 → 2022.10.31` | ✅ sì | `prova_regime.ps1` righe 69-75 (R50/R56/R59, R99, R100) |
| **CROLLO** | `2020.02.01 → 2020.04.30` | ✅ sì | idem |
| **TORO** | `2021.01.01 → 2021.12.31` | ✅ sì | idem |
| **LATERALE** | `2019.01.01 → 2019.12.31` | ✅ sì | idem |
| **CRISI2008** | `2008.07.01 → 2008.12.31` | ❌ **DIAGNOSTICA, non un criterio** | R99 §8.1, stessa logica delle due diagnostiche oro |

🔵 **La finestra che un simbolo NON HA esce `NON APPLICABILE`, e non gira.** Su
`XAGUSD` (storico dal 2008.11.07) la diagnostica CRISI2008 coprirebbe **due mesi
su sei**: farla girare zitta darebbe un numero che **sembra** confrontabile con
quello degli altri. È un dato, non un guasto, e va scritto così.

---

## 4. ⚙️ LE TRADUZIONI ESECUTIVE — dichiarate, non nascoste nel codice

### 4.1 Il PASSO 0-A si fa **per SIMBOLO**, non per sedia

Dodici simboli distinti, venti sedie. Su **GBPUSD** ci sono **sette** sedie:
scaricarne le barre sette volte sarebbe tempo buttato. Si scaricano
**M1 + H1/H2/H4/D1** dalla data della sonda, **senza tick**.

🔴 **E il verdetto si CONFRONTA con la data dichiarata** (lezione R95/R99): se
il broker risponde una `PrimaDataServer` **più recente** di quella misurata il
17/08, la finestra di quella sedia **non è quella scritta nel file prova**, e il
driver lo scrive nei **PROBLEMI** *prima* che si legga un numero.

🟡 Il verdetto **non-`COMPLETO` sull'M1 è ATTESO** (`scarica_storico.ps1` dà 120
secondi per timeframe): va nelle **NOTE**, non nei PROBLEMI — checklist 47, una
spia che non può che essere rossa non la legge più nessuno. **La misura che
decide resta la prima operazione.**

### 4.2 Il gate della prima operazione è **RELATIVO**, non a data fissa

R100 aveva due date fisse (`2005.12.31`, `2010.01.01`) perché il simbolo era
uno solo. Qui la finestra cambia sedia per sedia:

- prima operazione entro **`@DAQUANDO` + 24 mesi** → **FINESTRA PIENA**;
- oltre → **FINESTRA ACCORCIATA**: **PROBLEMA scritto**, la corsa **prosegue**,
  e il referto stampa gli **anni EFFETTIVAMENTE coperti** accanto a ogni numero;
- prima operazione dopo il **`2019.01.01`** → **FUORI CLASSIFICA**: la sua
  finestra non contiene nemmeno le quattro finestre di regime, quindi la domanda
  del round **non ha strumento** su quella sedia. 🔵 **NON è un FATALE**: i
  numeri si stampano lo stesso (una sedia che ha girato non si butta via), ma
  **non entrano nella classifica** e il perché è scritto sulla sua riga.

**Restano FATALI per sedia** (la sedia si dichiara NON MISURATA, la corsa passa
alla seguente): nessun `OptResults`, righe ≠ 2, colonne assenti o illeggibili,
**gemelli divergenti**, gate 1 completamente muto, `n = 0`.

### 4.3 Il DD promesso: **per colonna**, col vincolo su **simbolo** *e* **magic**

Funzione di R100, generalizzata sul simbolo. Il vincolo sul **magic** qui non è
teorico: **distingue le due PTE GBPUSD** (`771322` storica e `771332` B25), che
hanno **stesso EA, stesso simbolo e contratti diversi**. Verificato eseguendo:
pescano **righe diverse**.

🔴 **E si rifiuta di leggere un numero scritto a UN'ALTRA TAGLIA.** Verificato
eseguendo sul file vero: **18 sedie su 20** danno `DD PROMESSO ESTRATTO`; le due
**PTE GBPUSD** danno **`DD PROMESSO AMBIGUO`**, perché i loro contratti sono
scritti a due taglie (*"2,64% — a 0,5% ≈ 1,3%"*). Su quelle due il **`2x` resta
NON CALCOLABILE**, e la riga va nel referto **verbatim**.
👉 _Un denominatore letto alla taglia sbagliata è peggio di un denominatore
mancante._ **E non è un via libera: è un rilievo**, e si chiude riscrivendo
quelle due celle del contratto **alla taglia viva** — che è **una firma**.

### 4.4 Si compila **una volta per EA**, non una per sedia

Sette EA, venti sedie. Backup datato `.prima_r102_<stamp>` di `.mq5` **e**
`.ex5`, verdetto sul `LastWriteTime`, ripristino del `.mq5` se fallisce
(checklist 54).

### 4.5 🎯 Il **quarto strumento** per la peggior giornata, dove c'è

**Sei EA su sette** hanno l'OPTFRAME esteso con la colonna **`Peggior Giornata %`
calcolata dentro l'EA**: su quelle sedie il numero esce da **due strumenti
indipendenti** e il referto li stampa entrambi. **`ABTG_SuperWave` NON ce l'ha**
(misurato nel sorgente: header senza quella colonna), e su C07 il referto scrive
che la seconda misura **non esiste**.

### 4.6 🔢 I magic

Blocco **`79xxxx`**, **VERGINE**. Schema `79SSNN`: `SS` = numero della sedia
(01-20), `NN` = lo slot (`10/11` gemelle lunga · `12` singola lunga · `20/21`
COMUNE · `30/31` ORSO · `40/41` CROLLO · `50/51` TORO · `60/61` LATERALE ·
`70/71` CRISI2008). **Verificato: tutti e 300 i magic, zero occorrenze nel
repo** — non il prefisso, i numeri.

---

## 5. ⏱️ DURATA, CODA E RIPRESA — **e qui bisogna essere onesti**

### 5.1 🚦 LA CODA: R102 gira **DOPO R101**

**Una macchina, un lavoro.** R101 (ablazione dei filtri su Dow e DAX) è
**pinnato, firmato e in attesa dei due controlli sul grafico**; i suoi due
controlli sono **FATTI e verdi** (commit `7070437`). **R102 non parte finché
R101 non ha finito e mandato il suo zip.** Due tester sullo stesso terminale si
rubano la cache e i frame, e il risultato non si legge più.

### 5.2 ⌛ Quanto ci mette — **[STIMA], misurata in durata simulata**

| pezzo | conto | anni-sedia |
|---|---|---:|
| PASSO 0 per sedia | 3 passate × finestra lunga (media ~24 anni) | **~72** |
| le 6 finestre per sedia | COMUNE 17,5×2 + ORSO 0,83×2 + CROLLO 0,25×2 + TORO 1×2 + LATERALE 1×2 + 2008 0,5×2 | **~42** |
| **per sedia** | | **~114** |
| **× 20 sedie** | | **~2.280** |

Riferimento: **R100 valeva ~886 anni-sedia ed era stimato 2-6 ore.**

> ### ⏳ **ORDINE DI GRANDEZZA ATTESO: 6-16 ORE DI TESTER.**
> 🔴 **PIÙ IL COLLO DI BOTTIGLIA VERO, che non è il tester: lo SCARICO DELLE
> BARRE M1 DI DODICI SIMBOLI da vent'anni.** Può valere **altre ore** e nessuno
> di noi l'ha mai misurato su dodici simboli in fila. R100 ne scaricava **uno**.
> 👉 **Questa stima è la parte meno affidabile del documento, ed è giusto che si
> veda.**

### 5.3 🧱 **PER QUESTO IL ROUND SI LANCIA A BLOCCHI**

`-SoloSedia` accetta un **ELENCO** (`-SoloSedia C01,C02,C03`). **Non è un
ripiego: è il modo previsto.** Blocchi proposti, e il primo è la domanda di
Claudio:

| blocco | sedie | perché |
|---|---|---|
| **1** | `C01,C02,C03` | **BREAKING BAND** — è la domanda esplicita |
| **2** | `C14,C15,C16` | GapFill forex (motore veloce, poche operazioni) |
| **3** | `C17,C18,C19,C20` | PunteLarry forex |
| **4** | `C11,C12,C13` | CostToCost (H4: più veloce) |
| **5** | `C08,C09,C10` | EasyTrend |
| **6** | `C04,C05,C06,C07` | PTE + SuperWave |

⚠️ **Ogni blocco scrive una cartella e uno zip suoi sul Desktop, e il referto lo
dichiara**: *"un blocco NON è il round"*. **Vanno mandati tutti**, non solo
l'ultimo.

### 5.4 🔁 La ripresa, **detta com'è** (checklist 59)

| pezzo | rilancio liscio della stessa riga | quanto pesa |
|---|---|---|
| **PASSO 0** — singola + 2 gemelle sulla finestra lunga | **SI RIFÀ, per ogni sedia della lista** | ~72 anni-sedia = **~63%** |
| le **6 finestre** col CSV già presente | saltate e dichiarate (1 PROBLEMA per ognuna, con la data del file) | ~42 anni-sedia = **~37%** |

Ed è **voluto**: la peggior giornata e la spina dorsale si leggono dal report
`.htm`, che sta nella **sosta**, e la sosta **si svuota a ogni giro**
(checklist 56). Una sedia "saltata" tornerebbe **senza due dei cinque numeri**.
👉 **La ripresa che costa poco è `-SoloSedia` con l'elenco delle sedie non
fatte.** `-Rifai` rifà tutto.

---

## 6. 📋 COSA PUÒ USCIRE DA R102, E COSA NO

**Può uscire:**
1. **LA TABELLA MADRE**, ordinata sulla **finestra COMUNE**: `pos | sedia |
   simbolo | rischio | profitto-COM | PF-COM | DD-COM | n-COM | profitto-LUNGA |
   DD-LUNGA | n-LUNGA | peggior giornata | robustezza`;
2. i **cinque numeri** (A-E) per ogni sedia misurata, con la **spina dorsale
   anno per anno**;
3. il verdetto meccanico **`2x`** sulla corsia RISCHIO, dove il denominatore
   esiste;
4. **PROPOSTE da firmare a parte**: riscrivere alla **taglia viva** i due
   contratti PTE GBPUSD oggi ambigui; riempire il contratto di
   `BREAKOUT_EA_JPY_v3` **o dichiararne formalmente lo stato**;
5. il **rilievo di perimetro**: senza gli indici, questa **non** è la classifica
   della flotta.

**Non può uscire:**
- ❌ nessuna promozione, nessuna bocciatura **di merito**, nessun cambio di
  parametri, nessuna sedia nuova, nessuna sedia spenta;
- ❌ nessun **guadagno**: il profitto è una stima del lordo (§1.2);
- ❌ nessun numero a **tick reali**, nessuna misura di spread;
- 🔴 ❌ **e soprattutto: NESSUN DRAWDOWN DI PORTAFOGLIO.** Venti sedie non fanno
  un DD pari alla somma dei loro né pari al massimo: dipende da **quanto si
  sovrappongono nel tempo**, e questo round le misura **una per una**. ⚠️ **E
  qui la domanda morde**: **sette** di queste venti sedie stanno sullo **stesso
  simbolo, GBPUSD** (C01, C04, C05, C07, C09, C14, C19). È **un round diverso**
  (macchina R16/R34/R37/R41) ed è **la domanda successiva ovvia**.

---

## 7. 🧾 DA DOVE VIENE OGNI PEZZO — la mappa delle fonti

| pezzo | fonte | stato |
|---|---|---|
| l'Emendamento regola B | `CLAUDE.md` §EMENDAMENTO, congelato 16/08 | ✅ **REGOLA DI CASA** |
| il caso PTE USDJPY 0/28 → 25/28 | R69 | ✅ MISURATO |
| il `2x` sul DD promesso | firma 18/08, corsia RISCHIO (`report/FIRME_2026-08-18.md`) | ✅ **FIRMATO** |
| `@DAQUANDO` di ogni simbolo | `REFERTO_SONDA_STORICO_17-08.md` + CSV `215D85D7_ABTG_InfoBroker.csv` colonna `PrimaDataTF` | ✅ MISURATO |
| barre D1 e densità delle serie | stesso CSV, colonna `BarreD1` | ✅ MISURATO |
| esclusione indici/energia | stessa sonda, verdetto `COMPLETO` a `2024.09.26` | ✅ MISURATO |
| esclusione oro | R99 e R100, già agli atti | ✅ FATTO |
| rischio / magic / commento delle 20 sedie | `censimento_rischio_2026-08-23_1549.txt` | ✅ **MISURATI, del 23/08** |
| celle (input) delle 20 sedie | `deploy_vivaio_bb.ps1`, `_gap.ps1`, `_larry.ps1`, `_cost.ps1`, `_ez.ps1`, `_r23.ps1`, `deploy_pte_gbpusd_b25.ps1` | ✅ MISURATE (artefatti di deploy) |
| gli **altri** input delle celle | default del sorgente al pin | 🟡 **[DA CONFERMARE]** col `.chr` |
| che i default nuovi siano NEUTRI | `git diff` fra il pin di deploy e HEAD: l'unico input aggiunto ovunque è `InpUsaGuardian=true` (+ `InpMinRR=0.0` sul BB, `0 = SPENTO = comportamento 1.02`). Nel tester il Guardian è **fail-open totale** | ✅ MISURATO |
| DD promesso di ogni sedia | `report/CONTRATTI_SEDIE.md` al pin, **per colonna** | ✅ ESTRATTO E VERIFICATO (18 estratti, 2 ambigui) |
| assenza del sorgente `BREAKOUT_EA_JPY_v3` | ricerca in `mql5/Experts/` | ✅ MISURATA (0 file) |
| `ABTG_SuperWave` senza `Peggior Giornata %` | header dell'OPTFRAME nel sorgente | ✅ MISURATA |
| le 4 finestre di regime | `prova_regime.ps1` righe 69-75 (R50/R56/R59) | ✅ AGLI ATTI |
| la finestra COMUNE 2009 | legata da XAGUSD 2008.11.07 | 🟡 **DECISIONE 1, §3.2** |
| il pavimento sulle serie ricostruite | euro dal 1999.01.04 (fatto storico), yen sganciato dal 1973 | 🟡 **DECISIONE 2, §3.6** |
| verginità dei 300 magic `79xxxx` | ricerca **magic per magic** su tutto il repo | ✅ MISURATA (0 occorrenze) |
| la stima 6-16 ore | conto in anni-sedia contro R100 | 🔴 **[STIMA], la parte meno affidabile** |

---

## 8. ✅ CHE COSA È GIÀ STATO VERIFICATO — **eseguendo**, non rileggendo

Checklist punto **63**: *"il parse si FA, non si dichiara impossibile"*.

| controllo | come | esito |
|---|---|---|
| il `.ps1` **parsa** | `pwsh` (installato in `/opt/pwsh`) + `[Parser]::ParseFile` | ✅ **0 errori** |
| i 20 **file prova** passano i gate veri | banco di prova, sui file veri | ✅ **20/20** |
| le due **fabbriche di `.ini`** (OTT + SINGOLA) e i loro gate | eseguite per tutte e 20 | ✅ **20/20** |
| version, magic di sorgente, include Guardian, OPTFRAME, `MarkSrc` | letti nei **sorgenti veri** | ✅ **20/20** |
| i **7 `MarkLog`** | provati sul campione **POSITIVO** *e* su quello **NEGATIVO** (checklist 55) | ✅ **7/7 presi, 7/7 falsi positivi respinti** |
| `DataSimulata` contro la trappola dei millesimi | riga con orologio reale 2026 + data tester 2011 | ✅ legge **2011** |
| `LeggiDeal` | **due** report finti, **con e senza** la colonna `Commento` in coda (checklist 58) | ✅ stesso risultato, netto **+497 / −902** |
| il netto = Profitto+Commissioni+Swap e le migliaia con lo **spazio** | stesso campione (`100 497.00`) | ✅ |
| la **spina dorsale** per anno | stesso campione | ✅ 2011 +497 (n 1), 2012 −902 (n 1) |
| i numeri sotto **cultura it-IT** | `1.27013`, `9 005.54` | ✅ `1,27013` e `9005,54` (non `127013`) |
| `Fmt2` / `FmtEuro`: "non misurato" ≠ "negativo" ≠ "zero" | tre casi | ✅ |
| `DDPromesso` sul `CONTRATTI_SEDIE.md` **vero** | 20 sedie | ✅ 18 estratti, **2 AMBIGUI attesi** |
| il vincolo **magic** (le due PTE GBPUSD) | eseguito | ✅ righe **diverse** |
| il vincolo **simbolo** (Larry GBPUSD non pesca l'oro) | eseguito | ✅ |
| `XAGUSD` copre la COMUNE e **non** copre CRISI2008 | date confrontate | ✅ |

🟡 **CHE COSA NON È STATO VERIFICATO, e va detto**: tutto quello che richiede
**MT5** — la compilazione vera, il comportamento del tester su `FromDate=1971`,
la durata reale, il fatto che il report `.htm` del terminale di Claudio abbia
davvero l'intestazione italiana attesa. **Il giro a vuoto (`-SoloControllo`)
copre gli artefatti; i numeri li può dare solo la corsa.**

---

## 9. 🖊️ LE DECISIONI CHE RESTANO A CLAUDIO — **la firma**

| # | decisione | proposta del preparatore |
|---|---|---|
| **1** | **Finestra COMUNE**: `2009` con XAGUSD dentro, oppure `2008` togliendo XAGUSD dalla classifica (§3.2) | **A) 2009 con XAGUSD dentro** |
| **2** | **Pavimento** sulle serie ricostruite (EUR pre-1999, USDJPY pre-1993): subito o dopo aver visto il GATE 4 (§3.6) | **A) prima corsa senza pavimento, si guarda e si decide** |
| **3** | **Perimetro**: 20 sedie o solo Breaking Band (le 3 della domanda) | **20 sedie, ma lanciate a BLOCCHI, Breaking Band per primo** (§5.3) |
| **4** | **La coda**: R102 dopo R101, confermato? (§5.1) | **sì — una macchina, un lavoro** |
| **5** | I **due contratti PTE GBPUSD** riscritti alla taglia viva (0,5%), così il `2x` diventa calcolabile (§4.3) | **sì, ed è una firma a parte** — R102 può girare lo stesso, con il `2x` NON CALCOLABILE dichiarato |
| **6** | `BREAKOUT_EA_JPY_v3`: si scrive un contratto o si **dichiara formalmente lo stato**? (§2.4) — è aperta dal 18/08 | **dichiarare lo stato**: senza sorgente non è misurabile, e una sedia viva senza metro non dovrebbe restare accesa |

---

## ✍️ FIRMA

> **BOZZA. Non firmata.** Finché questa riga non è sostituita dalle parole di
> Claudio in chat, `RIGA_R102_CLASSIFICA_LUNGA.ps1` **non si manda** — e il
> `-SoloControllo` **non è** l'eccezione: anche lui scarica artefatti al pin e
> installa un include sul terminale che ha in mano il conto vero.
