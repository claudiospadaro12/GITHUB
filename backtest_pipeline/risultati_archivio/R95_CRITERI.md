# 🧾 R95 — SWEEP + RECLAIM SUI CROSS JPY: **CRITERI (BOZZA, DA FIRMARE)**

> ## ⚠️ QUESTO FILE È UNA **BOZZA**. Nessun numero di R95 si guarda finché Claudio non lo firma.
> I criteri si congelano **prima** dei numeri, non dopo. Chi apre i CSV prima
> della firma ha già rotto il metodo, e il round non vale più niente.

_21/08/2026. Preparato da Claude su mandato **"prepara jpy"**._
_Numero **R95 verificato libero**: R92 = BULGE, R93 = FiboH4, R94 = Bollinger 37/1.4.
Nessuna occorrenza di "R95" nel repo prima di oggi._

| voce | valore |
|---|---|
| **EA** | `mql5/Experts/ABTG_LiquiditySweep.mq5` **v1.11** |
| **simbolo / TF** | **EURJPY · M15** |
| **file prova** | `prove/R95a..e_liqsweep_{m30,h1,h2,h3,h4}_EURJPY.txt` |
| **dimensione** | **15 celle × 2 finestre = 30 passate**, un solo simbolo |
| **modello** | **1 = OHLC M1** — obbligato (§2.3) |
| **rischio** | **1,00% pinnato** — assunzione di Claude, non una firma |
| **magic** | **779502** (griglia) · **779500 / 779501** (gemelli del PASSO 0) — tutti vergini, e **separati apposta**: `ExportTrades()` gira a ogni passata e il nome del per-trade contiene il **magic, non la finestra** (§1.2) |

---

## 0. 🎯 LA DOMANDA, E PERCHÉ È UNA TESI NUOVA E NON UNA TARATURA

> **"Sui cross JPY — dove R82 ha contato da 264 a 2.138 rotture per finestra e
> ha dimostrato che INSEGUIRLE non paga su nessuno dei sette — il RIENTRO dopo
> lo sweep ha un edge, una volta che il livello è costruito abbastanza fitto da
> produrre 150 operazioni in campione?"**

### 0.1 🚪 La porta di rientro C3, argomentata riga per riga

R82 ha chiuso la sedia BREAKOUT_JPY con **0 vincitori su 7** e ha scritto:
*"Porta di rientro C3: solo con una tesi NUOVA, non con una taratura."*
La regola della seconda caccia (19/08) dice la stessa cosa in altre parole:
**meccanismi alternativi sulla stessa inefficienza, MAI parametri diversi dello
stesso motore morto.** Ecco la dimostrazione, non l'affermazione:

| | motore morto (R82) | **questo (R95)** |
|---|---|---|
| **sorgente** | `ABTG_BreakoutCorso.mq5` | **`ABTG_LiquiditySweep.mq5` — un ALTRO EA** |
| **grilletto** | chiusura **oltre** il bordo del rettangolo | il prezzo **buca e RIENTRA**: si entra **contro** la rottura |
| **direzione** | con la rottura | **opposta** |
| **stop** | 1 pip oltre il bordo del rettangolo, **dalla parte da cui il prezzo viene** | oltre **l'estremo dello sweep** + 0,5 ATR, **dalla parte opposta** |
| **livello** | rettangolo mobile di 20 candele M15, **senza ancora** | swing simmetrico confermato su TF alto, **consumato una volta sola** |
| **indicatori** | Williams 140 + SuperTrend | **zero** |

> ✅ **Grilletto opposto, direzione opposta, stop dalla parte opposta, EA
> diverso.** Non è lo stesso motore con altri numeri: è **il motore che sta
> dall'altra parte dello stesso scambio**. La tesi economica lo dice esplicito:
> *chi entra sulla rottura è il carburante di chi la fade.*

### 0.2 🚫 E non è nemmeno "R89 con altri parametri"

R89 girava a **21 barre H4 per lato = 84 ORE** di accumulo. Questa scala sta
fra **2 e 48 ore**: **il punto di R89 non è dentro la griglia**, sta sopra il
gradino più alto. Non stiamo ripescando il suo intorno, stiamo in una zona di
densità **da 2 a 35 volte** più fitta.

> ### 🔴 IL NUMERO DI R89 CHE NON SI PUÒ CITARE, E VA SCRITTO ANCHE NEL REFERTO
> **"R89 ha dato PF IS 0,23"** è una frase vietata in questo round.
> Con **n IS = 14** quel numero è **rumore, non una misura del motore**. Il
> referto R89 lo dice testualmente: *"NON è una bocciatura del meccanismo: è la
> prova che con 21 barre H4 per lato i livelli sono troppo pochi."*
> **R95 parte da un motore MAI MISURATO, non da un motore bocciato.**

---

## 1. 🚧 PASSO 0 — **LA FINESTRA È DA MISURARE, E OGGI NON È VERIFICATA**

> ### 🔴 QUESTO È IL PUNTO CHE PUÒ BLOCCARE TUTTO IL ROUND. Si legge per primo.

### 1.1 Cosa ho **verificato** (e la bozza aveva ragione a metà)

`@DAQUANDO 2007.02.12` della bozza **non è inventata**: è nel CSV della sonda
del 17/08 (`sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`), riga `CADJPY` e
riga `NZDJPY`. **[MISURATO]** — la bozza è onesta su questo.

**Ma quella data non significa quello che sembra**, e tre cose lo dimostrano:

| # | reperto | fonte | conseguenza |
|---|---|---|---|
| **1** | tutte e sette le righe JPY dicono **`da scaricare (parziale)`** | sonda 17/08 | *sul server c'è, **sul nostro disco no***. Non è una finestra: è una promessa |
| **2** | `USDJPY` **100.008** barre H1, `EURJPY` **100.000** — con "prime date" 1971 e 1993 | sonda 17/08 §3-bis | **è il tetto "Max barre nel grafico"**, non lo storico. `100.000 / 6.240 = 16,0 anni` — il conto torna |
| **3** | *"Se il tetto valga anche per lo **Strategy Tester** **non lo so**. Non lo invento"* | referto sonda, `[INCERTO]` **mai chiuso** | l'unica corsa che lo chiudeva (griglia GBPUSD da 2000.01.01) **non risulta fatta** |

⚠️ **E su M15 il tetto morde 4 volte di più**: 100.000 barre M15 = **4,0 anni**,
non 16. Se il tester fosse capped, **la IS di R95 sarebbe VUOTA** e i CSV
uscirebbero comunque, pieni di numeri, tutti falsi.

### 1.2 E il precedente che obbliga a misurare: **R82 non ha mai verificato la sua**

`r82_csv/REFERTO_RACCOLTA_R82_giro1.txt`, testuale:
**`serie per-trade raccolte: 14 (solo finestra OOS)`**.

Quindi il referto R82 quando scrive *"copertura piena dichiarata: 264-2.138
operazioni per finestra"* sta dichiarando **un conteggio, non una data**. La sua
stessa nota di preparazione prometteva: *"al traguardo la copertura di OGNI
cross verrà verificata dai per-trade (data del primo trade + densità)"* — e per
la IS **non è stato fatto**, perché i per-trade della IS sono stati
sovrascritti da quelli della OOS (il nome del file contiene il magic, non la
finestra).

**E la densità lascia il dubbio aperto** [INFERITO, non misurato]:

| cross | n IS / 7,75 anni | n OOS / 11,63 anni | densità IS ÷ densità OOS |
|---|---:|---:|---:|
| USDJPY | 120/anno | 184/anno | 0,65 |
| EURJPY | 116/anno | 178/anno | 0,65 |
| **GBPJPY** | **34/anno** | **126/anno** | **0,27** ⚠️ |
| AUDJPY | 89/anno | 177/anno | 0,50 |
| CHFJPY | 64/anno | 153/anno | 0,42 |
| CADJPY | 73/anno | 177/anno | 0,41 |
| NZDJPY | 65/anno | 169/anno | 0,38 |

**Sette su sette con la IS più rada della OOS non è una prova di buchi** (il
mercato cambia, e il motore di R82 aveva un filtro di trend), **ma è
esattamente il sintomo del difetto n.18 della checklist**, e su GBPJPY è
violento. **Non si eredita una finestra su questa base.**

### 1.3 ✅ COME SI CHIUDE — ed è dentro la riga di lancio, non è un compito a casa

**PASSO 0-A · si scarica.** `scarica_storico.ps1 -Simboli "EURJPY" -Da
1995.01.01 -Timeframes "M1,M15" -SenzaTick -Auto`, poi si legge la colonna di
stato: `COMPLETO` / `MANCA STORICO LOCALE` / `IL BROKER NON HA PIÙ STORICO`.

**PASSO 0-B · si alza il tetto.** L'`.ini` del tester porta
`[Charts] MaxBars=2000000000`. ⚠️ **[INFERITO]**: che il tester onori quella
riga **non è misurato**. Per questo esiste il PASSO 0-C, che non si fida.

**PASSO 0-C · si MISURA sul per-trade, ed è il gate vero.** Due passate
**singole gemelle** (magic **779500** e **779501** — **non** il 779502 della
griglia), cella **più densa** della scala (**M30 / 4 barre**), `InpVerbose=1`,
finestra **intera** 2015.07.01 → 2026.06.30. Il per-trade va **in sosta con nome
proprio subito dopo le passate, prima dei controlli**: l'artefatto di un gate
deve esistere **anche quando il gate esce rosso**, che è il caso in cui serve.

| # | esito | conseguenza **congelata** |
|---|---|---|
| **G1** | per-trade assente o < 2 righe | 🔴 **ROUND FERMO.** Non si lancia niente |
| **G2** | **prima data > 2016.01.01** | 🔴 **ROUND FERMO.** I dati non coprono la finestra: si ridichiara e si rifà il PASSO 0 |
| **G2** | la data **non si legge** | 🔴 **ROUND FERMO** — *"non ho potuto misurare"* **non è** *"ho misurato e va bene"* |
| **G3** | i due gemelli **non** identici | 🔴 **ROUND FERMO** — banco sporco (checklist punto 5) |
| **G4** | `tetto livelli raggiunto` nei log | 🔴 **ROUND FERMO** — il tetto morde già sulla cella densa (§3.1-bis) |
| **G4** | **zero log del tester letti** | 🔴 **ROUND FERMO** — *un gate che non legge niente non è un gate verde*. Il conteggio dei log letti va **nel referto** |
| — | tutto ok | 🟢 si parte, e la **frequenza misurata** della cella densa va scritta nel referto **accanto alla previsione di §3.2** |

> ⚠️ **I log del tester stanno in TRE radici**, e quella degli **agent** non è
> sotto la cartella dati del terminale (`%APPDATA%\MetaQuotes\Tester\...`).
> Con una radice sola G4 sarebbe **verde per costruzione**.

> 💰 **Costa 2 passate su 30 e può salvare la notte intera.** È la lezione di
> R82 pagata in anticipo invece che a posteriori.

---

## 2. 🪟 LA FINESTRA PROPOSTA — dimensionata sulle **OPERAZIONI**, come vuole l'Emendamento

### 2.1 I numeri

| voce | valore |
|---|---|
| `@DAQUANDO` | **2015.07.01** |
| `Fino` | **2026.06.30** (default del driver) |
| totale | 4.017 giorni = **11,0 anni** |
| split | **40/60** (default del driver) |
| **IS** | **2015.07.01 → 2019.11.23** — **4,40 anni** — [CALCOLO: floor(4017 × 0,40) = 1606 giorni] |
| **OOS** | **2019.11.24 → 2026.06.30** — **6,60 anni** — [CALCOLO] |

⚠️ Le date IS/OOS sono **calcolate, non lette**: si verificano sull'anteprima
`.ini` del giro a vuoto. **Se il driver spezza diversamente, vale il driver.**

### 2.2 🧪 IL REGIME CONTENUTO — va scritto accanto a **OGNI** numero

**E la scelta della finestra è fatta apposta perché il rischio stia in
ENTRAMBE le metà.** Questo è un motore controtendenza sui cross JPY: il modo in
cui muore è la serie di stop dentro un movimento violento. Una finestra che li
evita non misura niente.

| finestra | cosa contiene, e perché è ostile a questo motore |
|---|---|
| **IS 2015-2019** | crollo cinese **ago-2015**, **Brexit giu-2016** (GBPJPY −1.500 pip in ore), shock di volatilità **feb-2018**, **flash crash del 3 gen 2019** (cross JPY spostati del 4-8% in minuti, sul thin book di Tokyo) |
| **OOS 2019-2026** | **crollo COVID mar-2020**, **carry mania 2022-2024** (i trend più violenti del decennio = il nemico dichiarato di questo motore), **unwind del carry ago-2024** |

> 🎯 **Se sopravvive a questa OOS, il numero significa qualcosa.** Se muore lì,
> muore per la ragione che avevamo previsto — e va scritto che l'avevamo
> previsto, non spacciato per scoperta.

### 2.3 ⛔ PERCHÉ **NON** SI VA A TICK REALI, e perché non è un ripiego mascherato

I tick di BCM partono dal **2024.07.05** (referto del 15/08, su GBPUSD — l'unico
simbolo per cui una riga `TICK` sia mai stata prodotta). Su una finestra che
parte dal 2015 **non esistono**. Quindi **Modello 1, OHLC M1**, come il giro 1
di R82. Conseguenza **congelata**:

> ### 🔴 **R95 NON PUÒ PRODURRE UNA SEDIA. NON PUÒ PROPORNE UNA. NON PUÒ TOCCARE NIENTE IN FORWARD.**
> Il massimo che può produrre è **il permesso** di fare un giro a tick reali
> sulla coda 2024.07 → 2026.06, e solo dopo un walk-forward vero, e solo dopo
> il demo. **Ogni numero del referto porta scritto "OHLC, non tick".**

### 2.4 ⚖️ Perché **non** si torna al 2007 (regola C dell'Emendamento)

Diciannove anni contigui **diluiscono**: la regola C dice che la prova di
regime batte la storia lunga. Undici anni bastano largamente al campione
(§3) e contengono **sei** eventi di stress nominati. Andare al 2007 aggiunge
dilution, aggiunge rischio dati, e non aggiunge una domanda.

---

## 3. 🐤 IL CANARINO DELLA FREQUENZA — **si legge PRIMA del conto economico**

### 3.1 🔧 E ora esce dai DATI, non da una `Print` (difetto chiuso oggi)

La riga `[LIQSWEEP][CONTEGGIO]` sta in `OnDeinit`. **In OTTIMIZZAZIONE MT5 non
esegue le `Print` degli agent**: il canarino sarebbe sparito proprio nelle 30
passate che servono a misurarlo. Nella **v1.10** dell'EA i quattro conteggi sono
**quattro COLONNE del CSV** (`stats[10..13]` nel frame):

`Livelli Creati` · `Livelli Consumati` · `Livelli Invalidati` · `Segnali Scartati` · **`Livelli Buttati`** (v1.11)

**La logica del segnale non è stata toccata, e il diff è dichiarato per intero:**
`diff_blocco_segnale.py` su 8 blocchi → **7 a diff 0** (`AggiornaSwing`,
`ScansionaLivelli`, `Enter`, `SweepAlto_Calc`, `SweepBasso_Calc`,
`EstremoConfermato_Calc`, `OnTick`) e **`LivelloAggiungi` a diff 1**, che è la
riga `gLivButtati++` e nient'altro. **[MISURATO]**

### 3.1-bis 🧱 `Livelli Buttati`: perché esiste, ed è il canarino più importante

Un livello sparisce **solo** se uno sweep lo consuma o una chiusura oltre lo
invalida. **In un trend lungo di un lato, gli swing dell'altro lato non vengono
mai né toccati né rotti**: l'array cresce in modo **monotono**. Quando
`InpMaxLivelli` morde, si butta **il più vecchio — cioè il più ampio**, proprio
quello su cui il reclaim varrebbe di più.

Il conto, fatto e non stimato: a `M30×4` §3.2 prevede **2.773 livelli/anno**
(~1.390 per lato). Con un tetto di **500** si riempirebbe in **~4 mesi** di
trend — e **EURJPY dal marzo 2020 (~115) al luglio 2024 (~175) è quattro anni
quasi in linea retta**. L'**unwind del carry di agosto 2024**, che §2.2 nomina
come *lo* stress test della OOS, avrebbe trovato i livelli più ampi **già
buttati**: i reclaim che il round vuole misurare **non esisterebbero per
costruzione** nelle celle dense.

**Tetto portato a 2.000** (4× il costo di `ScansionaLivelli`, morso spostato a
~17 mesi) — ma il tetto non basta: **serve l'artefatto che dice se ha morso**, e
`Livelli Creati` **non lo dice** (viene incrementato anche per un livello poi
buttato). Da qui la colonna nuova.

### 3.2 📐 L'ASPETTATIVA DI FREQUENZA, dichiarata **PRIMA** — e falsificabile

**Ancoraggio [MISURATO]:** R89 su GBPUSD, H4/21 barre, ha fatto **38 trade in
1,99 anni = 19,1 trade/anno**, con una densità teorica di **72,6 livelli/anno**
→ **conversione 0,263 trade per livello**.

**Modello [INFERITO]:** su una serie senza memoria un estremo confermato da `N`
barre per lato compare circa ogni `2N+1` barre → `livelli/anno ≈ 2 × barre_anno / (2N+1)`.
Trasporto GBPUSD → EURJPY: **[INFERITO, non misurato]**.

| ore/lato | cella | livelli/anno | **trade/anno** | **n IS atteso** | **n OOS atteso** | **n IS se ÷2** |
|---:|---|---:|---:|---:|---:|---:|
| 2 | M30×4 | 2.773 | 730 | 3.210 | 4.816 | 1.605 |
| 4 | H1×4 | 1.387 | 365 | 1.605 | 2.408 | 803 |
| 4 | M30×8 | 1.468 | 386 | 1.700 | 2.549 | 850 |
| 6 | M30×12 | 998 | 263 | 1.156 | 1.734 | 578 |
| **8** | **H1×8** | 734 | **193** | **850** | **1.275** | 425 |
| **8** | **H2×4** | 693 | **182** | **803** | **1.204** | 401 |
| 12 | H1×12 | 499 | 131 | 578 | 867 | 289 |
| 12 | H3×4 | 462 | 122 | 535 | 803 | 268 |
| 16 | H2×8 | 367 | 97 | 425 | 637 | 212 |
| 16 | H4×4 | 347 | 91 | 401 | 602 | 201 |
| 24 | H2×12 | 250 | 66 | 289 | 433 | 144 |
| 24 | H3×8 | 245 | 64 | 283 | 425 | 142 |
| 32 | H4×8 | 184 | 48 | 212 | 319 | 106 |
| 36 | H3×12 | 166 | 44 | 193 | 289 | 96 |
| 48 | H4×12 | 125 | 33 | **144** ⚠️ | 217 | 72 |
| _(84)_ | _R89, H4×21_ | _73_ | _19_ | _84_ | _126_ | _42_ |

### 3.3 📏 QUANTI ANNI SERVONO — la risposta chiesta, in chiaro

Soglia dell'Emendamento: **150 IS e 150 OOS**. Con lo split 40/60 il vincolo
che morde è **la IS**: servono **≥ 34 trade/anno**.

| cella | anni per 150 IS + 150 OOS | con la stima **dimezzata** |
|---|---:|---:|
| **H1×8 (8 ore, il centro previsto)** | **1,6 anni** | 3,1 anni |
| H2×8 (16 ore) | 3,1 anni | 6,2 anni |
| H4×8 (32 ore) | 6,3 anni | 12,5 anni |
| H4×12 (48 ore, la cima) | 9,1 anni | **18,2 anni** ⚠️ |
| _R89, H4×21 (84 ore)_ | _15,7 anni_ | _31 anni_ |

> ### ✅ **LA FINESTRA ESISTE — per 13 celle su 15 anche con la stima dimezzata.**
> Gli **11,0 anni** proposti coprono con margine tutta la metà bassa e media
> della scala. **Le due celle in cima (36h e 48h) sono a rischio canarino**, ed è
> **dichiarato adesso**: se cadono sotto 150 IS **non sono una bocciatura del
> motore**, sono la conferma del difetto di R89 — e si scrive quella frase.
>
> 🔴 **E la stessa cosa detta al contrario, perché è il rischio vero:** la
> cima della scala **non è misurabile con nessuna finestra che abbiamo**. Per
> dare 150 IS a `H4×21` servirebbero **31 anni** nel caso pessimistico.
> **Quel punto è morto per costruzione, non per merito.**

### 3.4 🚦 Il canarino, cella per cella — **conseguenze congelate**

| esito **in IS**, per cella | conseguenza |
|---|---|
| **n IS ≥ 150** | 🟢 la cella si legge sul **MERITO** (con §2.3: non promuove) |
| **30 ≤ n IS < 150** | 🟠 **MERITO SOSPESO** (valvola R59). Si legge **solo il RISCHIO**, e si scrive nel referto invece di far finta di niente |
| **n IS < 30** *oppure* **Livelli Creati IS < 30** | 🔴 **cella NON MISURABILE**, e la conclusione **non è sull'edge** |
| **meno di 5 celle su 15 con n IS ≥ 150** | 🔴 **il ROUND è non misurabile**: la scala non ha prodotto il campione, e la domanda resta aperta |
| **`Livelli Buttati` > 0** (qualunque cella) | 🔴 **quella cella è misurata con la STRUTTURA AMPUTATA**: il tetto ha buttato livelli vivi, e i più ampi. **Si dichiara e NON si legge sul merito.** Se sono le celle dense, il verdetto sulla metà bassa della scala **non c'è** |

**E i due conteggi si leggono insieme, perché distinguono due diagnosi diverse
gratis:** livelli **tanti** e consumati **pochi** → è il **GRILLETTO** che non
scatta; livelli **pochi** → è la **DEFINIZIONE DELLO SWING**.

### 3.5 🔗 IL CONTROLLO DELLE COPPIE — gratis, e falsifica la lettura

Cinque gradini di ore sono descritti da **due celle di file diversi**: 4h, 8h,
12h, 16h, 24h. **Se le due metà di una coppia danno numeri lontani** (fuori dal
20% di PF che §4 usa come tolleranza), **la lettura "conta l'accumulo in ore" è
sbagliata** e il round si legge come 5 scale separate, non come una. **Va
scritto nel referto in ogni caso**, anche quando torna.

---

## 4. 🎚️ LA REGOLA DI SELEZIONE — **centro dell'altopiano, MAI il picco**

Non trattabile, e va dichiarata **insieme a ogni numero** o il numero non vuol
dire niente (Emendamento, regola A). Motivo misurato: **12 correlazioni di
Spearman IS→OOS negative su 13** — il picco IS non regge.

1. Si ordinano le **15 celle per ORE DI ACCUMULO** (2 → 48). È una scala, si
   legge come una scala.
2. **Vicino** = la cella immediatamente sopra e immediatamente sotto nella
   scala ordinata (**non** "un passo di un asse": gli assi qui sono due nomi
   della stessa grandezza).
3. Una cella si può nominare **centro di altopiano** solo se **TUTTE** le sue
   vicine dirette stanno dentro **20% di PF** e **1,5 punti percentuali di DD**
   da lei (soglia identica a `R88_CRITERI.md` §3 e `R89_CRITERI.md` §4).
4. Una cella che **sporge da sola** è **rumore**: si scrive *"picco isolato, non
   proposto"*. Anche se è la più bella della tabella. **Soprattutto** se è la
   più bella della tabella.
5. **`n` IS e `n` OOS accanto a OGNI numero.** Etichette **[MISURATO] /
   [INFERITO] / [DICHIARATO]** su ogni riga.

---

## 5. 🚪 I CANCELLI — le soglie NUMERICHE, congelate

### 5.0 🧪 Sanità, prima di tutto
1. **Gemelli identici** nel PASSO 0 (779500 vs 779501). Divergono → **round fermo**.
2. **Autotest** (`InpAutoTest`) letto **una volta**, nella passata singola del PASSO 0.
3. **15 righe per finestra in ogni CSV.** Un numero diverso = cache del tester,
   o l'enum che non ha spazzolato: **il round non si legge**.
4. **`InpTF_Struttura` va verificato nell'anteprima `.ini`**: deve passare il
   **numero** (30 / 16385 / 16386 / 16387 / 16388), non il nome dell'enum.
5. **I cinque file prova differiscono in 2 righe su 31** (`InpTF_Struttura`,
   `InpComment`) — **verificato a diff il 21/08**, e la riga di lancio lo rifà.

### 5.1 🟢 CANCELLO A — quando una cella **"PASSA"**

Passare **non è una promozione** (§2.3): è il permesso di proporre un giro a
tick reali. Servono **tutte e cinque**:

| # | soglia | da dove esce il numero |
|---|---|---|
| **A1** | **PF OOS ≥ 1,20** | Cancello storico di casa **1,10** (R15), **+0,10** che è il margine di rumore congelato in `R84_ABLAZIONE_CRITERI.md` §5. Il sovrapprezzo c'è perché R95 chiede di **riaprire un capitolo chiuso** (R82 0/7, R42 0/24+0/24, R45 0/48): **riaprire costa più che confermare.** Identico ad A1 di R89 |
| **A2** | **PF IS > 1,00** e **segno del profitto coerente fra IS e OOS** | Lezione USDJPY di R20: *"IS rosso + OOS verde è la configurazione PIÙ pericolosa"* — senza criteri congelati la si promuove dicendo "guarda l'out-of-sample!" |
| **A3** | **DD OOS ≤ 15,0%** | Muro prop **10%** di DD totale (`report/METRO_PROP.md`); passate a **1,00%** contro taglia di campo **0,65%**: 10% ÷ 1,538 = 15,4% → **15,0**. ⚠️ **[INFERITO per scalatura lineare, NON misurato]** → R55-bis obbligatorio su qualunque cella proposta |
| **A4** | **Peggior Giornata % non peggiore di −7,5%** | Muro prop giornaliero **5%**, stessa scalatura: 5% ÷ 1,538 = 7,7% → **7,5**. 🎯 **È il cancello che conta di più**: un motore controtendenza sui cross JPY muore di **serie di stop**, e il muro giornaliero butta fuori anche col DD totale intatto |
| **A5** | **n IS ≥ 150** | Emendamento della finestra, regola A. Sotto → §3.4 |

### 5.2 ⚫ CANCELLO B — **bocciatura secca**. Basta **una**

- **PF OOS < 1,10** — sotto il cancello storico di casa;
- **IS negativo** (A2 fallito);
- **DD OOS > 15,0%** **oppure** **Peggior Giornata peggiore di −7,5%** →
  bocciata **per RISCHIO**, **qualunque sia il PF e qualunque sia `n`**.
  **Il giudizio di rischio non si sospende mai** (Emendamento, regola B: *"si
  boccia se avrebbe fatto un drawdown del 25%, perché un drawdown è un fatto
  accaduto"*);
- **n IS < 30** → **non è una bocciatura**: è **"non misurabile"** (§3.4).

### 5.3 🏁 VERDETTO DI ROUND — congelato prima

| esito | condizione | cosa si scrive, e cosa si fa |
|---|---|---|
| 🟢 **la scala ha un centro** | esiste un **centro di altopiano** (§4) che passa **tutti** i cancelli A | *"il rientro dopo lo sweep ha un segno su EURJPY, OHLC, in questa finestra"*. **Si propone UN giro a tick reali sulla coda 2024.07-2026.06.** Niente altro |
| 🟠 **solo picchi isolati** | celle promosse ma nessuna con vicine dentro tolleranza | 🔴 **NON SI PROPONE NIENTE.** Si scrive *"picchi isolati: la superficie insegue il rumore"*. È la lezione di R70 |
| 🔴 **zero celle passano A** | nessuna cella | **il meccanismo del rientro non ha edge su EURJPY in questa finestra.** Verdetto valido, ed è l'esito **più probabile** |
| 🔴 **bocciata per rischio** | A3 o A4 falliti sulle celle con campione | **il verdetto di rischio vale anche se il PF è bello.** E vale la previsione di §2.2: l'avevamo detto prima |
| ⛔ **non misurabile** | meno di 5 celle su 15 con n IS ≥ 150 | *"la scala non ha prodotto il campione"*. **La conclusione NON è sull'edge**, ed è vietato scriverla come se lo fosse |

### 5.4 🚫 COSA **NON** SI POTRÀ DIRE, coi dati che avremo

Questa sezione esiste perché è la parte che si dimentica quando i numeri sono belli.

1. ❌ **Non si potrà dire "funziona".** OHLC M1, non tick: per regola di casa
   **l'OHLC non dà verdetti di promozione**. Un motore che entra su una
   chiusura di rientro con lo stop strutturale vicino è **proprio** il tipo che
   l'OHLC tratta bene e i tick trattano male.
2. ❌ **Non si potrà dire niente sui cross JPY come famiglia.** Un simbolo solo.
   E anche se ne girassimo sette, **la regola firmata ammette UNA sedia sola**.
3. ❌ **Non si potrà dire "il DD sarà quello".** A 0,65% invece che 1,00% il DD
   **non scala linearmente** — è [INFERITO], mai misurato. Serve R55-bis.
4. ❌ **Non si potrà dire niente su spread e slippage.** Un broker, un feed,
   costi di quel feed. Sui cross JPY minori lo spread notturno è la voce che
   uccide un motore ad alta frequenza, **e questo round non lo misura**.
5. ❌ **Non si potrà dire che l'orario aiuta.** La finestra di sessione è
   **spenta**, apposta: filtro appiccicato a motore già tarato = **0 successi su
   5** (R20, R12, R26, R45, R54). È un round successivo.
6. ❌ **Non si potrà citare il PF 0,23 di R89** come misura di niente (§0.2).
7. ❌ **Non si potrà dire "riproviamo con un altro cross"** se boccia. Sarebbe
   la seconda griglia sul motore morto, cioè esattamente ciò che la regola
   della seconda caccia vieta.

---

## 6. 🪑 LA REGOLA DI PORTAFOGLIO — già firmata, e vale qui

> ### **DALLA FAMIGLIA JPY ENTRA AL MASSIMO UNA SEDIA. MAI IL PANIERE.**
> Firmata in `prove/TORNEO_JPY_CRITERI.md` prima di R82 e ribadita nel referto
> R82 §5. Vale **qualunque cosa dicano i numeri**.

E vale anche **dentro** questo round: se più celle passassero, **non sono più
sedie**, sono più letture della stessa. Ne esce **una proposta sola**, ed è il
**centro dell'altopiano**, non la migliore.

📌 Oggi la famiglia JPY in campo è governata anche dal **criterio di uscita
delle sedie** (18/08): RISCHIO per sedia sempre, MERITO per famiglia a 20
operazioni, TAGLIANDO a 6 mesi.

---

## 7. ✅ LA CHECKLIST DEL REFERTO — cosa deve esserci, o il referto non è chiuso

- [ ] **PASSO 0 per primo**: esito dello scarico storico (0-A), prima data del
      per-trade, gemelli, tetto livelli, **numero di log del tester letti**, e il
      **verdetto scritto per esteso** (§1.3). *"NON LETTO" non è "non ha morso".*
- [ ] **Il canarino PRIMA del conto economico**: le **5** colonne nuove
      (`Livelli Creati/Consumati/Invalidati/Buttati`, `Segnali Scartati`), cella
      per cella, col verdetto di §3.4.
- [ ] **`Livelli Buttati` cella per cella**, e la dichiarazione esplicita per
      ogni cella con valore > 0 (§3.1-bis).
- [ ] **La frequenza MISURATA contro la previsione di §3.2**, e di quanto ho
      sbagliato. Se la previsione era rotta, si dice.
- [ ] **La scala ordinata per ORE**, non per PF.
- [ ] **Il controllo delle 5 coppie** (§3.5), anche quando torna.
- [ ] **`n` IS e `n` OOS accanto a ogni numero**, con [MISURATO]/[INFERITO].
- [ ] **La regola di selezione dichiarata** insieme a ogni cella nominata.
- [ ] **"OHLC, non tick"** su ogni numero.
- [ ] **Il REGIME contenuto** accanto a ogni finestra.
- [ ] **§5.4 ricopiato**: cosa non si può dire.
- [ ] **Il commit** dell'EA e dei file prova che hanno girato davvero.

---

## 8. ✍️ COSA DEVE FIRMARE CLAUDIO

| # | cosa | valore proposto |
|---|---|---|
| **F1** | la **finestra** | `2015.07.01 → 2026.06.30`, split 40/60, **subordinata al PASSO 0** |
| **F2** | la **dimensione** | 15 celle × 2 finestre = **30 passate**, **EURJPY solo** |
| **F2-bis** | il **tetto dei livelli** | `InpMaxLivelli` = **2.000**, con `Livelli Buttati > 0` = cella non leggibile sul merito (§3.1-bis) |
| **F3** | il **rischio delle passate** | **1,00%** (assunzione di Claude; la taglia di campo resta 0,65%) |
| **F4** | i **cancelli A1-A5** | PF OOS ≥ 1,20 · PF IS > 1,00 · DD OOS ≤ 15,0% · Peggior Giornata ≥ −7,5% · n IS ≥ 150 |
| **F5** | la **bocciatura secca** | §5.2, **rischio mai sospeso** |
| **F6** | la **regola di selezione** | centro dell'altopiano sulla scala delle ore, **mai il picco** |
| **F7** | il **tetto**: R95 non produce sedie | §2.3 |

> ⚠️ **Finché queste sette righe non sono firmate, questo file resta una BOZZA
> e la riga di lancio non si manda.**
