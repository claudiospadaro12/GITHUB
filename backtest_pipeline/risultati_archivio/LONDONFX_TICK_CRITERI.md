# 🧾 LONDONFX — IL ROUND A **TICK REALI**: **CRITERI (BOZZA, DA FIRMARE)**

> ## ⚠️ QUESTO FILE È UNA **BOZZA**. Nessun numero di questo round si guarda finché Claudio non lo firma.
> I criteri si congelano **prima** dei numeri, non dopo. Chi apre un CSV prima
> della firma ha già rotto il metodo, e il round non vale più niente.
> **In questo giro NON è stato girato NIENTE, NON è stato compilato NIENTE.**

_03/09/2026, ~09:25. Preparato da Claude su mandato di Claudio: **"PREPARA LA
BOZZA DEI CRITERI"**._
_Numero di round proposto: **R116** — **verificato libero oggi** (`grep -rno "R116"`
su tutto il repo → **0 occorrenze**; R115 è l'ultimo assegnato). ⚠️ Da
**ri-verificare** il giorno del lancio: fra oggi e allora qualcuno può prenderlo._

| voce | valore proposto |
|---|---|
| **EA** | `mql5/Experts/ABTG_LondonFx.mq5` — **DA SCRIVERE** (contenitore + 3 motori a interruttore, §3) |
| **simboli / TF** | **EURUSD · M15** e **GBPUSD · M15** — le **due gambe che hanno passato il PASSO 0** |
| **modello** | **4 = Ogni tick basato su TICK REALI** — è il punto del round (F6 di casa: i verdetti di merito solo a tick) |
| **finestra** | **2024.07.05 → 2026.06.30** — dal **pavimento tick misurato** (§2) |
| **ora di sessione** | **08:00–16:00 ORA SERVER, CONGELATA** (§2.4) |
| **rischio** | **0,65% — la taglia di campo**, non 1,00% (§5.3: così il DD si legge contro il muro prop **senza scalature inferite**) |
| **dimensione** | **6 celle × 2 finestre = 12 passate** + **2 gemelli** di determinismo = **14 passate**. Fase 2 (R55-bis) solo sulle celle che passano |
| **magic** | blocco **`7740xx`** — **verificato VERGINE oggi** (75 occorrenze della stringa `7740` nel repo, **tutte dentro decimali di CSV**, zero come magic). Da ri-verificare al lancio |

---

## 0. 🎯 LA DOMANDA DEL ROUND, IN UNA RIGA

> **"Il canale di Londra + RSI, misurato a TICK REALI con lo spread VERO del
> broker, produce un'aspettativa `E ≥ 0,075R` per operazione su EURUSD e GBPUSD
> M15 — e, se sì, è il SEGNALE a produrla o il CONTENITORE (sessione + flat +
> tetti)?"**

Due domande in una, e sono **la stessa misura**: le tre varianti di motore
girano **dentro lo stesso contenitore, nella stessa corsa** (§3). L'ablazione
**non è un extra**: senza di lei un eventuale verde non si sa a chi attribuirlo.

### 0.1 🔢 IL NUMERO CHE DEVE STARE IN CIMA, PRIMA DI TUTTI GLI ALTRI

La geometria della fonte è **TP 150 tick / SL 80 tick** su feed a 5 decimali =
**TP 15,0 pip / SL 8,0 pip**. Quindi **1R = 8,0 pip**, e:

| voce | in pip | in frazione di **R** |
|---|---:|---:|
| **il cancello H8** (`E ≥ 0,075R`, FIRMA 2 del 31/08) | **0,60 pip** | 0,075 R |
| spread di **convenzione** su EURUSD (`~1,0 pip`) **[MAI MISURATO]** | 1,00 pip | **0,125 R** |
| spread **prudenziale assunto** EURUSD (§5.5) | 1,50 pip | **0,188 R** |
| spread **prudenziale assunto** GBPUSD (§5.5) | 2,00 pip | **0,250 R** |
| slippage prudenziale (5 punti MT5) — R55 | 0,50 pip | 0,063 R |

> ### 🔴 **IL COSTO È DA 1,7 A 3,3 VOLTE L'EDGE RICHIESTO.**
> Per **netto** 0,60 pip a operazione il motore deve produrne **1,6–2,6 lordi**.
> Non è impossibile (la MFE mediana del PASSO 0 è 10–16,3 pip), ma **decide il
> round il COSTO, non il segnale** — ed è esattamente perché si va a tick veri:
> **sul tick reale lo spread non si assume, si paga.**

### 0.2 🔮 LA PREVISIONE DICHIARATA **PRIMA** DEI NUMERI (falsificabile)

Il PASSO 0 ha misurato, su EUR_M15 / RSI / ora 8 / lato long: **MFE mediana
13,4 pip, MAE mediana 11,8 pip** (a 12 barre, **limiti superiori**, referto
03/09). **La MAE mediana (11,8) è SOPRA lo stop della fonte (8,0).**

> **[INFERITO, non misurato]** Se l'escursione avversa mediana supera lo stop,
> **la maggioranza dei segnali tocca lo stop prima del take** → win rate atteso
> **sotto il 50%**, plausibilmente **intorno o sotto il 42,0%** che serve a
> pareggiare il cancello a 1 pip di costo. **L'esito più probabile di questo
> round, scritto prima di guardare, è un NO.**
>
> ⚠️ Il limite di questa previsione, dichiarato: la MAE a 12 barre **non
> conosce l'ORDINE degli eventi dentro la barra**. Un segnale può toccare +15
> prima di −11,8. **Quell'ordine lo vede solo il tick**, ed è il motivo per cui
> il round esiste invece di essere sostituito da questo paragrafo.

### 0.3 🚫 E non è una seconda griglia su un motore morto

LondonFx **non è mai stato bocciato**: ha **passato** il PASSO 0 su entrambe le
gambe (EURUSD 19/24, GBPUSD 24/24, referto del 03/09). La regola della **seconda
caccia** (19/08) qui non si applica: non stiamo ripescando parametri di un
motore 0/N, stiamo facendo **la prima misura di merito** di un motore mai
misurato sul merito. **[FATTO]**

---

## 1. 🧊 COSA NON SI TOCCA — la bozza congelata del PASSO 0 resta in piedi

I criteri **F1 · F1-bis · F2 · F3 · F4 · F4-bis(H8) · F5 · F6 · F7** stanno in
`prove/LONDONFX_FREQUENZA_M15.txt` (e nella gemella M5), congelati il 31/08
**prima di ogni numero**. **Questo documento NON li riscrive e non li
contraddice**: parlano di un altro oggetto (la **SONDA**, un contatore) e di
un'altra domanda (**occasioni e geometrie**, non merito).

**Ciò che questo round EREDITA da lì, e che non si rimette in discussione:**

| eredità | valore | stato |
|---|---|---|
| RR nominale della fonte | **1,875** (TP 150 / SL 80 tick) | [MISURATO nel sorgente Pine] |
| soglia RSI simmetrica | `InpRsiSoglia = 80` → short a **20** | [DICHIARATO in F5] — ⚠️ **è l'unica cosa che si rimette in discussione, e solo perché F5 lo chiede: §7** |
| ora di sessione attesa | **8 server** = Londra esatta | [DICHIARATO in F7 **prima** dei numeri] |
| medie del canale | **SMA 5** su massimi e minimi | congelate ai default dell'autore |
| RSI | **periodo 5** | congelato |
| flat incondizionato a fine sessione | sì (`strategy.close_all`) | congelato |

⚠️ **Le fasce F2 di M5 rimaste SOSPESE non entrano in questo round**: il round
gira **solo su M15**, dove il PASSO 0 ha dato **VIVO senza sospensioni** su
tutte e tre le ore, su entrambi i simboli. **Questo round NON dipende dal
74148 per essere ammesso** — e §5.5 spiega perché anzi **lo chiude**.

---

## 2. 🪟 IL BANCO — finestra, modello, ora

### 2.1 La finestra, e da dove esce il numero

| voce | valore | fonte |
|---|---|---|
| `@DAQUANDO` | **2024.07.05** | **pavimento TICK REALI forex BCM, MISURATO il 01/09 dal Diario del tester**: `EURUSD/GBPUSD: ticks data begins from 2024.07.05 00:00` (`NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md`) |
| `@FINOA` | **2026.06.30** | fine standard di casa |
| totale | **725 giorni = 1,99 anni ≈ 23,8 mesi** | [CALCOLO] |
| giorni di borsa attesi | **~505–520** | [CALCOLO: 725 × 5/7 − festivi] |
| split | **40/60** (default del driver) | — |
| **IS** | **2024.07.05 → 2025.04.21** — 290 giorni, ~207 di borsa | [CALCOLO — **da verificare sull'anteprima `.ini`**; se il driver spezza diversamente, **vale il driver**] |
| **OOS** | **2025.04.22 → 2026.06.30** — 435 giorni, ~311 di borsa | [CALCOLO] |

**Perché si parte dal 2024.07.05 e non dal 2024.09.26 del PASSO 0:** perché
2024.07.05 è **il primo giorno in cui i tick sono VERI**, e questo round vive di
tick veri. Si guadagnano **83 giorni (+13% di campione)**. **Conseguenza da
dichiarare in ogni tabella**: la finestra **non è la stessa** del PASSO 0 → i
conteggi non sono confrontabili riga per riga con quelli del 03/09, **solo per
ordine di grandezza**.

### 2.2 🧱 Il tetto delle ~100.000 barre **non morde**, ed è calcolato

`96 barre M15 al giorno × ~520 giorni di borsa ≈ **50.000 barre**` — **metà del
tetto**. [CALCOLO] Sul M5 avrebbe morso (~150.000): **è una delle ragioni per
cui questo round è M15 e basta.**

### 2.3 ⚠️ IL LIMITE VERO DI QUESTA FINESTRA, scritto prima

**UN SOLO REGIME.** Ventiquattro mesi di forex major 2024-2026 sono **un
campione di operazioni ampio e un campione di REGIMI da uno**. L'Emendamento
della finestra dice due cose e vanno separate:

- **Regola A (l'unità di misura è l'OPERAZIONE):** ✅ **soddisfatta con largo
  margine** (§4).
- **Regola C (la prova di regime batte la storia contigua):** ❌ **NON
  soddisfatta.** Questo round **non ha una prova di regime**.
- **Regola B (il vecchio giudica il RISCHIO):** ❌ **non misurabile qui** — vedi
  §6, che è una **proposta**, non una decisione.

> 🔴 **Conseguenza congelata: da questo round NON esce una sedia.** Esce, al
> massimo, una **candidata**, e solo dopo la prova di rischio di §6 e dopo il
> forward demo. Ogni numero del referto porta scritto **"un solo regime"**.

### 2.4 🕗 L'ORA: **si CONGELA a 8**, e questa è la scelta che propongo

**Le tre ore del PASSO 0 (4 / 6 / 8) NON tornano come asse.** Motivazione, in
quattro punti:

1. **L'ora 8 era la previsione DICHIARATA PRIMA dei numeri**, non il risultato
   pescato dopo: il prova F7 scrive, il 31/08, *"la lettura NEW YORK (cella 8) è
   la più probabile, perché 03:00-11:00 in ora di New York fa esattamente
   08:00-16:00 ora di Londra… il default del sorgente `.mq5` è quindi 8"*.
   **Congelarla ora non è selezionare un vincitore: è tenere la previsione.**
2. **La catena dei fusi ha una risposta FISICA, non statistica**: server BCM =
   ora italiana − 1 = **ora di Londra**. L'ora 8 **è** la sessione di Londra.
   Un asse su un parametro che ha una risposta fisica è una manopola, non una
   domanda.
3. **T10 — sweepare per far passare un cancello è vietato.** Con tre ore in
   asse, se l'ora 8 fallisse e la 4 passasse, la tentazione di leggere "il
   motore funziona alle 4" sarebbe irresistibile e **sarebbe curve fitting su un
   asse a 3 valori**. Togliere la tentazione **prima** costa zero.
4. **Costo:** tre ore × 3 motori × 2 gambe × 2 finestre = **36 passate a tick
   reali** invece di 12. Il tick reale è la risorsa cara della casa.

> 🔎 **E le ore 4 e 6 non spariscono: diventano una PROVA DI FRAGILITÀ,
> facoltativa e POSTERIORE.** Regola dichiarata adesso: se — **e solo se** — la
> cella ora=8 **passa tutti i cancelli**, si rilancia la sola cella promossa
> alle ore **4 e 6** per vedere **quanto è sensibile all'ora**. Serve a
> **indebolire** la promozione, mai a sostituirla: **se 8 muore, 4 e 6 non si
> guardano nemmeno.** Questa asimmetria è la clausola severa, ed è dichiarata.

### 2.5 🖥️ Vincoli operativi del banco (dalla nota del 01/09)

Le corse a tick su finestre lunghe hanno **saturato 16 GB con 8 agenti** ("no
memory for ticks generating"). **Massimo 4 agenti, RAM pulita, PC di backtest.**
E il difetto noto: **l'anteprima `.ini` del giro a vuoto scrive `Model=4`
hardcoded** — qui `4` è **proprio quello che vogliamo**, quindi l'anteprima
**non può fare da prova**: il modello si verifica sul **report finale del
tester**, non sull'anteprima.

---

## 3. 🏗️ L'EA CONTENITORE — `ABTG_LondonFx`, e i TRE MOTORI

### 3.1 Il principio, che è tutto il round

> ### **IL CONTENITORE È IDENTICO PER I TRE MOTORI. BIT PER BIT.**
> Se il contenitore cambia fra un motore e l'altro, l'ablazione **misura il
> contenitore** e la domanda del §0 resta senza risposta. Cambia **una sola
> riga**: `InpMotore`.

| # | `InpMotore` | motore | ruolo |
|---|---|---|---|
| **1** | `CANALE_NUDO` | chiusura fuori dal canale SMA5(high)/SMA5(low) | **ramo di CONTROLLO** dell'ablazione 1 (l'autore dichiara l'RSI *opzionale*) |
| **2** | `CANALE_RSI` | canale + conferma RSI(5) 80/20 | 🎯 **LA BASELINE. È il candidato.** È la configurazione che ha passato il PASSO 0 |
| **3** | `ALLINEA_5MEDIE` | allineamento SMMA 3/6/9/50 + EMA200 (P2 del 28/08, stesso autore, stessa coppia, stessa sessione, **MAI GIRATO**) | **secondo ramo di controllo**: un segnale *completamente diverso* nello stesso contenitore |

### 3.2 🔴 LA SOGLIA DI SOMIGLIANZA, DICHIARATA **PRIMA** (è ciò che il mandato chiede)

**"I tre vanno uguale"** significa, e **solo** questo, misurato **in OOS, per
gamba**:

| # | condizione | soglia |
|---|---|---|
| **S1** | **massimo scarto di aspettativa** fra i tre motori | `max(E) − min(E) ≤ **0,05 R**` |
| **S2** | **segno del profitto totale** | **identico** su tutti e tre |
| **S3** | campione | **n ≥ 150 per OGNI motore** su quella gamba |

> **Da dove esce lo 0,05R, e non è un numero pescato:** il cancello di ammissione
> alla flotta è **0,075R** (H8, FIRMA 2 del 31/08). **0,05R = due terzi del
> cancello.** Due motori che distano meno di due terzi della soglia di
> ammissione **non si distinguono in modo che cambi una decisione di
> ammissione**: sono lo stesso oggetto ai fini pratici. Con S1 verde,
> **il segnale non conta e il CONTENITORE È L'EDGE.**

**Le tre conseguenze, congelate:**

| esito | cosa si scrive, e cosa si fa |
|---|---|
| 🟠 **S1+S2+S3 tutti veri** | *"i tre motori vanno uguale: il contenitore è l'edge, il segnale non conta"*. **NESSUNA sedia sul segnale LondonFx.** L'oggetto di studio diventa **il contenitore** (sessione + flat + tetti), e serve un round nuovo con una domanda nuova |
| 🟢 **il motore 2 stacca gli altri due di > 0,05R** | il **segnale guadagna il suo posto**: il filtro RSI e il canale fanno un lavoro che il contenitore da solo non fa |
| 🔴 **il motore 1 (NUDO) è il migliore** | 💡 **è la conferma della lezione di casa** *"filtro appiccicato a motore già tarato = 0 successi su 5"*. **Ma non si promuove il nudo**: sarebbe promuovere il ramo di controllo, cioè scegliere il picco. Si scrive, e diventa **la tesi di un round successivo** |
| 🟠 **n < 150 su un motore** | **confronto SOSPESO su quel motore** (valvola R59). **Non si conclude né "uguale" né "diverso"**, e si scrive |

**S4 (informativa, non un cancello):** **correlazione dei P&L giornalieri** fra
i tre motori. Se ≥ **0,80**, è un secondo indizio che siano lo stesso oggetto.
Si legge dai per-trade, **si riporta sempre**, non decide niente da sola.

### 3.3 🧰 IL CONTENITORE, riga per riga (tutto congelato, niente in asse)

| voce | valore congelato | perché |
|---|---|---|
| sessione | **08:00 → 16:00 ora server**, fine esclusa | §2.4 |
| **flat di fine sessione** | **SÌ, non disattivabile** | è nella fonte (`strategy.close_all` incondizionato) |
| ultimo ingresso ammesso | **nessun taglio**: si entra fino all'ultima barra della sessione | fedeltà alla fonte. ⚠️ **canarino obbligatorio**: la % di trade chiusi **dal FLAT** (§4.3) |
| posizioni contemporanee | **1** (`pyramiding 1` della fonte) | ⇒ **rischio aperto ≤ 0,65%**, ben sotto il **cap C1 di 3,25%**: il cap **non morde mai** in questo round, e va scritto |
| tetto ingressi/giorno | **6** (`max_intraday_filled_orders(6)` della fonte) | ⚠️ **vale per TUTTI E TRE i motori**, anche per il motore 3 il cui autore usava 2: contenitore identico batte fedeltà del ramo di controllo. **Dichiarato** |
| cap di perdita giornaliera | **2,0% dell'equity** (`max_intraday_loss(2, percent_of_equity)` della fonte) | ⚠️ a rischio 0,65% sono **~3 stop pieni**: il cap **morderà spesso**, tronca le giornate brutte e **regala metà del cancello A5**. Va detto, non incassato (§5.4) |
| TP / SL | **fissi: 15,0 / 8,0 pip su ENTRAMBE le gambe** | §3.4 |
| gestione (parziale / pari / trailing) | **TUTTA SPENTA** | la lezione dell'EA oro: *"parziale precoce + breakeven immediato tappavano i vincenti mentre lo SL prendeva perdite piene"*. La gestione è **un round successivo**, non un ingrediente del primo |
| filtro spread | `InpMaxSpread = 0` = **SPENTO** | lezione R55: **lo spread si MISURA, non si filtra** (§5.5) |
| `InpSlippagePts` | **0** nella corsa principale | l'asse costi è la **fase 2** (§5.6) |
| rischio | **0,65%** | §5.3 |
| Guardian | **acceso**, come le sedie di campo | coerenza col campo |

### 3.4 ⚖️ LA GEOMETRIA RESTA QUELLA DELLA FONTE — anche su GBPUSD, e **soprattutto** su GBPUSD

TP 15,0 / SL 8,0 pip sono numeri **nati su EURUSD**. Su GBPUSD l'**ATR mediano
di sessione M15 misurato dal PASSO 0 è 8,58 pip**: lo stop della fonte vale
**~1 ATR**, cioè è **strettissimo**.

> **Non si adatta.** Adattare lo stop simbolo per simbolo, prima di avere una
> misura, è **pescare la geometria che fa passare il cancello (T10)**. La
> geometria si **trasporta dichiarandolo**, e se GBPUSD muore per stop troppo
> stretto, **quello È il risultato** — ed è un risultato utile (dice che il
> motore è EURUSD-nativo).

### 3.5 🔀 LA SCELTA CHE DEVE FARE CLAUDIO: **portare il motore 3 dentro, o no?**

Il motore 3 **esiste già**, ma **in un altro EA**: `mql5/Experts/ABTG_AllineaLondra.mq5`
(scritto il 28/08, verificato due volte dalla checklist, **MAI GIRATO**). Ha un
contenitore **suo** (sessione 03:00-10:45, ultimo ingresso 08:45, tetto 2/giorno,
**TP in R**, parziale + pari + trailing, ATR-SL).

| opzione | costo | rischio |
|---|---|---|
| **(i) PORTARE il motore 3 dentro `ABTG_LondonFx`** ✅ *raccomandata* | ~mezza giornata di lavoro in più | **nessuno sul metodo**: contenitore identico **garantito dal codice**. `ABTG_AllineaLondra` **resta intatto** col suo PASSO 0 già pinnato |
| (ii) far girare `ABTG_AllineaLondra` a parte, allineandolo **per input** | quasi zero | 🔴 **rompe l'ablazione**: le uscite non si possono allineare per input (TP in R contro TP fisso in pip). Misurerebbe *"due EA diversi"*, non *"due segnali nello stesso contenitore"* |
| (iii) rimandare il motore 3 a un round successivo | zero | 🟠 il round **perde metà della sua domanda** — e il mandato dice che l'ablazione **è parte del round, non un extra** |

---

## 4. 🐤 IL CANARINO DELLA FREQUENZA — si legge **PRIMA** del conto economico

### 4.1 L'aspettativa dichiarata **PRIMA**, e falsificabile

**Ancoraggio [MISURATO, PASSO 0 03/09]:** EUR_M15 / RSI / ora 8 → **2,26
segnali/giorno long**, ~2,0-2,3 short → **~4,4 al giorno, due lati**.
GBP_M15 / RSI → **2,2-2,4 per lato** → **~4,6/giorno**.

**Modello [INFERITO, non misurato]:** con **1 posizione per volta** e una durata
tipica di 4-6 barre M15 (1,0-1,5 ore) dentro una sessione di 8 ore, una parte
dei segnali arriva **a posizione aperta** e viene soppressa. Conversione
segnale→operazione stimata **0,60-0,75**.

| motore | segnali/gg (2 lati) | conversione | **trade/gg** | **n IS** (~207 gg) | **n OOS** (~311 gg) | **n IS se conversione ÷2** |
|---|---:|---:|---:|---:|---:|---:|
| **2 · CANALE_RSI** (baseline) | ~4,4 | 0,60–0,75 | **2,6–3,3** | **540–680** | **810–1.030** | **270–340** |
| 1 · CANALE_NUDO | ~16 ⚠️ | limitata dal **tetto 6/gg** e da 1 posizione per volta | **~6 (al tetto)** | ~1.240 | ~1.870 | — |
| 3 · ALLINEA_5MEDIE | **mai misurato** | — | **[IGNOTO]** | **[IGNOTO]** | **[IGNOTO]** | — |

> ### ✅ **Il campione NON è il problema di questo round** — e va detto perché è raro.
> Anche dimezzando la conversione, la baseline dà **270+ operazioni in IS** e
> **400+ in OOS**: la soglia dell'Emendamento (**≥150**) passa **con margine
> doppio**, e passa **anche per LATO**. È il motivo per cui questo round si può
> giudicare sul **MERITO** e non solo sul rischio.
> 🔴 **Ma il motore 3 è un buco nero: nessuno ha mai contato i suoi segnali.** Se
> esce sotto 150, il confronto S1 su quel ramo **è SOSPESO** (§3.2, riga S3).

### 4.2 🚦 Il canarino, motore per motore — conseguenze congelate

| esito **per motore, per gamba, per finestra** | conseguenza |
|---|---|
| **n ≥ 150** | 🟢 si legge sul **MERITO** |
| **30 ≤ n < 150** | 🟠 **MERITO SOSPESO** (valvola R59): si legge **solo il RISCHIO**, e si **scrive** |
| **n < 30** | 🔴 **NON MISURABILE**, e la conclusione **non è sull'edge** |
| **n ≥ 150 per gamba ma < 150 per LATO** | 🟠 il verdetto di gamba si legge; il verdetto **di quel lato** è **sospeso sul merito** (regola dei due lati, 25/08) |
| **meno di 4 celle su 6 con n ≥ 150 in entrambe le finestre** | 🔴 **round non misurabile**: la domanda resta aperta |

### 4.3 🔧 LE COLONNE OBBLIGATORIE — o il referto non è chiuso

Escono **dai DATI** (frame/CSV e per-trade), non da `Print` (in ottimizzazione MT5
non esegue le `Print` degli agent — lezione R95 §3.1):

1. **`Segnali Generati`** · 2. **`Segnali Soppressi Posizione Aperta`** ·
3. **`Segnali Soppressi Tetto Giorno`** · 4. **`Giorni col Tetto Colpito`** ·
5. **`Giorni Fermati dal Cap 2%`** · 6. **`Trade Chiusi dal FLAT (%)`** ·
7. **`Spread Mediano all'Ingresso (pip)`** · 8. **`Spread P95 all'Ingresso (pip)`**.

> 🔴 **DUE LETTURE CHE SENZA QUESTE COLONNE NON ESISTONO:**
> - se **`Giorni col Tetto Colpito` > 20%** su un motore, quel motore ha girato
>   **strozzato dal contenitore**: il suo posto nel confronto S1 è **dichiarato
>   contaminato** e si legge come confronto *operativo*, **non** come prova
>   segnale-contro-contenitore. **È il caso ATTESO per il motore 1 (nudo).**
> - se **`Trade Chiusi dal FLAT` > 40%**, il round sta misurando **l'orologio**,
>   non il motore, e va scritto in quei termini.

---

## 5. 🚪 I CANCELLI — le soglie NUMERICHE, congelate

### 5.0 🧪 Sanità, prima di tutto (se cade una, il round non si legge)

1. **Gemelli identici**: due passate con lo stesso input e magic diverso →
   **identiche al centesimo**. Divergono → **round fermo, banco sporco**.
2. **Autotest** (`InpAutoTest`) **0 falliti**, letto **in colonna**, non nei log.
3. **Numero di righe atteso in OGNI CSV**. Un numero diverso = cache del tester
   o enum non spazzolata → **il round non si legge**.
4. **`Model=4` verificato sul report del tester**, **non** sull'anteprima `.ini`
   (§2.5).
5. **Prima data del per-trade ≥ 2024.07.05 e < 2024.08.05.** Se il primo trade è
   molto più tardi, i dati non coprono la finestra → **round fermo**.
6. **Riga del Diario `ticks data begins from`** letta e **ricopiata nel referto**
   per **entrambi** i simboli. *"Non l'ho letta"* ≠ *"i tick c'erano"*.
7. **Il conteggio dei log del tester letti** va nel referto (lezione R95 G4: un
   gate che non legge niente non è un gate verde). ⚠️ I log stanno in **tre
   radici**, quella degli agent **non** è sotto la cartella dati del terminale.

### 5.1 🟢 CANCELLO A — quando una cella **PASSA**. Servono **tutte e sei**

Passare **non è una promozione**: è **il permesso di chiedere la prova di
rischio di §6** e poi il forward demo.

| # | soglia | da dove esce il numero |
|---|---|---|
| **A1** | **`E` OOS ≥ 0,075 R**, **misurata a tick e AL NETTO dei costi** | **FIRMA 2 del 31/08**, testuale. Non è negoziabile e non è mia |
| **A2** | **PF OOS ≥ 1,15** | cancello storico di casa **1,10** (R15) + margine di rumore. 🔎 **Il legame aritmetico va dichiarato**: con la geometria della fonte (RR 1,875) `E = 0,075R ⇔ PF ≈ 1,12` e `PF = 1,15 ⇔ E ≈ 0,093R` → **A2 è LEGGERMENTE PIÙ SEVERO di A1**, ed è **voluto e dichiarato** (regola di casa: l'ambiguità si scioglie verso la clausola severa) |
| **A3** | **segno del profitto COERENTE fra IS e OOS**, e **PF IS > 1,00** | lezione USDJPY di R20: *"IS rosso + OOS verde è la configurazione PIÙ pericolosa"*. ⚠️ Qui IS/OOS **non** servono a selezionare (§5.2): servono come **due campioni indipendenti della STESSA configurazione congelata** |
| **A4** | **DD OOS ≤ 8,0%** (a rischio **0,65%**) | muro prop **10%** (`report/METRO_PROP.md`) **meno il 20% di margine**. 🎯 **Letto DIRETTAMENTE, senza scalature**: è il motivo per cui si gira a 0,65% e non a 1,00% (§5.3) |
| **A5** | **Peggior Giornata non peggiore di −4,0%** | 🔑 **il cancello più bello del round**: **a 4,0% il Guardian METTE IN PAUSA la giornata** (pacchetto firmato il 18/08). Una cella con una giornata peggiore di −4,0% descrive **una giornata che sul campo NON SAREBBE ESISTITA**: il suo backtest **non è riproducibile**, prima ancora che rischioso |
| **A6** | **n OOS ≥ 150** (e **n IS ≥ 150**) **per gamba** | Emendamento della finestra, **regola A**. Sotto → §4.2 |

### 5.2 🎚️ LA REGOLA DI SELEZIONE — **non c'è, e questo è il punto**

> ### 🚫 **QUESTO ROUND NON HA UNA GRIGLIA, QUINDI NON HA UN PICCO DA SCEGLIERE.**
> Tutti i parametri di motore sono **congelati ai valori della fonte**. Le sei
> celle **non sono candidate in gara**: sono **2 gambe × 3 rami di
> un'ABLAZIONE**. Di conseguenza:
> - ❌ **è VIETATO nominare "la cella migliore"**;
> - ❌ **è VIETATO promuovere il motore 1 o il motore 3** (sono i controlli);
> - ❌ **è VIETATO scegliere la gamba che va meglio**: le due gambe si leggono
>   **entrambe**, e una gamba verde + una rossa **non è "il motore funziona"**;
> - ✅ **l'unica cosa promuovibile è il motore 2**, su ciascuna gamba
>   **separatamente**, e solo passando **tutti** i cancelli A.
>
> 💡 **Il beneficio nascosto, da scrivere nel referto:** con **zero parametri
> tarati da noi**, l'intera finestra è **out-of-sample rispetto alla fonte** (i
> numeri vengono da un Pine del 2020, su un altro decennio). È il caso più
> pulito che la casa abbia avuto: **non c'è niente da walk-forwardare perché non
> c'è niente di fittato.** Va detto — ed è anche il motivo per cui **una
> bocciatura qui è molto informativa**.

### 5.3 💶 IL RISCHIO DELLE PASSATE: **0,65%**, e perché cambia rispetto a R95

R95 girava a **1,00%** per confrontabilità, e ha dovuto marcare il suo cancello
di DD **[INFERITO per scalatura lineare, NON misurato]** (10% ÷ 1,538 = 15,0%).

Qui si gira **direttamente alla taglia di campo, 0,65%**, per tre ragioni:

1. **Il DD si legge contro il muro prop SENZA nessuna inferenza.** Una
   scalatura in meno = un [INFERITO] in meno.
2. **Il cap di perdita giornaliera del 2% è una % dell'equity**: la sua
   interazione col rischio per trade **è parte della meccanica**, non una
   normalizzazione. A 1,00% morderebbe dopo 2 stop, a 0,65% dopo ~3: **girare a
   una taglia diversa da quella di campo misurerebbe un altro motore.**
3. Il cap **C1** (3,25% di rischio aperto) è definito come **5 SL vivi a
   0,65%**: la taglia di campo è quella su cui i vincoli di casa sono scritti.

⚠️ **Prezzo da pagare, dichiarato**: i profitti in euro **non** sono
confrontabili con R82/R86/R89/R95 (che girano a 1,00%). **Si confrontano `E` in
R, PF e DD%**, che sono le grandezze giuste comunque.

### 5.4 🎁 IL REGALO DEL CAP 2%: **A5 è in parte garantito per costruzione**

Con il cap di perdita giornaliera al **2,0%**, la peggior giornata **non può**
scendere molto sotto −2% (tranne per lo slippage sull'ultima operazione e per il
gap di apertura di una posizione già aperta). **Quindi A5 (−4,0%) passerà quasi
sicuramente.** Va scritto **prima**: *"A5 è passato anche grazie a un cap che sta
nella fonte, non a un merito del segnale"*. **Il merito che non si è guadagnato
non si incassa.**

🔴 **E il contrario è la vera notizia**: se **A5 fallisce lo stesso**, vuol dire
che il cap **non funziona come crediamo** (ordine degli eventi, gap, slippage) →
**il round si ferma e si indaga il contenitore**, prima ancora del merito.

### 5.5 💸 IL COSTO — e come questo round **chiude** il buco del 74148 invece di dipenderne

**Dipendenza dichiarata, in chiaro:** il `RealCost Spread P95 Logger` (Code Base
**74148**) è **promosso dal 23/08 e MAI USATO**; **sette** dossier di caccia
hanno dovuto marcare **[SPREAD NON MISURATO]**. Questo round **non aspetta**
quella misura, per due motivi:

1. **A Modello 4 su tick REALI, lo spread lo porta il flusso dei tick**: sulla
   finestra ≥ 2024.07.05 il tester lavora con il bid/ask **registrato dal
   broker**, non con una media. **[INFERITO dalla documentazione MT5 — e questo
   round lo VERIFICA, vedi il punto 2]**.
2. **L'EA MISURA LO SPREAD ALL'INGRESSO** e lo esporta: `(ask−bid)/_Point` nel
   momento esatto dell'operazione, **mediana e P95** (§4.3, colonne 7-8) — lo
   stesso pattern già scritto nella `ABTG_SondaOrologio` (`InpMaxSpreadPts = 0`:
   *"lo spread si MISURA, non si filtra"*, lezione R55).

> ### 🎁 **Conseguenza: questo round PRODUCE il numero che manca a tutta la casa**
> (spread BCM su EURUSD e GBPUSD, nella sessione di Londra, ora per ora) —
> **anche se boccia tutto il resto.** Il numero va **estratto e archiviato lo
> stesso**, e chiude la voce **H12** del PIANO_PROP.

**E LO SPREAD PRUDENZIALE, se la misura NON arrivasse** (colonna vuota, tick
generati per un buco, EA che non la scrive): il verdetto si rilegge **applicando
a mano un costo di 1,50 pip su EURUSD e 2,00 pip su GBPUSD**, cioè **0,188R e
0,250R per operazione**. Da dove escono:
- la **convenzione** di casa è **1,0 pip su EURUSD** [MAI MISURATA];
- si aggiunge **+50%** perché **l'apertura di Londra è una fascia di
  allargamento**, non un'ora media;
- il rapporto **EUR:GBP ≈ 1:1,33** è l'ordinamento standard fra i due major, e
  il PASSO 0 lo vede indirettamente (*"il Cable è più largo dell'euro e si
  sente"*).
📌 Marcati **[ASSUNTO PRUDENZIALE, NON MISURATO]** ovunque compaiano. **Un
candidato che passa solo con lo spread di convenzione (1,0) e muore col
prudenziale (1,5) NON è un candidato**: è la clausola severa, applicata.

### 5.6 🪓 SLIPPAGE — **R55-bis è OBBLIGATORIO, ed è FASE 2 di QUESTO round**

R55 (15/08) ha misurato che la fragilità allo slippage **non la fa il tipo di
ordine, la fa la LARGHEZZA DELLO STOP**: l'ORB (stop stretto) era **11 volte**
più sensibile del PTE. **Qui lo stop è 8,0 pip: è la classe dell'ORB.**

| slippage | in pip | **in frazione di R (SL 8 pip)** |
|---:|---:|---:|
| 2 punti MT5 | 0,20 | **2,5%** |
| **5 punti MT5** | **0,50** | **6,3%** |

**FASE 2, congelata adesso (non è un salvataggio postumo):** ogni cella che
passa i cancelli A si **rilancia** con `InpSlippagePts` = **0 / 2 / 5**.

> 🔴 **IL VERDETTO SI LEGGE A 5 PUNTI (0,5 pip).** 0 e 2 sono la sensibilità.
> Se `E` scende sotto **0,075R** a 5 punti, la cella è **"vive solo a taglia
> piccola"** — esattamente l'etichetta che R55 ha appiccicato all'ORB — e
> **NON si propone.** Ambiguità → clausola severa, dichiarata.

### 5.7 ⚫ CANCELLO B — **bocciatura secca**. Basta **una**

- **`E` OOS < 0,050 R** → sotto due terzi del cancello firmato;
- **PF OOS < 1,10** → sotto il cancello storico di casa;
- **IS negativo** (A3 fallito);
- **DD OOS > 10,0%** → **sfonda il muro prop alla taglia di campo**;
- **Peggior Giornata peggiore di −5,0%** → **sfonda il muro prop giornaliero**;
- ➡️ le ultime due bocciano **per RISCHIO**, **qualunque sia il PF e qualunque
  sia `n`**. **Il giudizio di rischio non si sospende mai** (Emendamento,
  regola B).
- **n IS < 30** → **non è una bocciatura**: è **"non misurabile"** (§4.2).

### 5.8 🔒 LE FASCE, VERIFICATE DISGIUNTE — nessun punto cade in due clausole

Il difetto che ha morso il PASSO 0 (*"la bozza congelava la PROSA e non il
criterio"*) è stato **ri-controllato qui, riga per riga**. Fra "passa" e "bocciata
secca" esiste **sempre** una **terza fascia esplicita = NON PASSA** (nessuna
proposta, nessuna bocciatura del meccanismo):

| grandezza | 🟢 PASSA | 🟠 NON PASSA (zona morta) | ⚫ BOCCIATA SECCA |
|---|---|---|---|
| `E` OOS | ≥ 0,075 R | 0,050 ≤ E < 0,075 R | < 0,050 R |
| PF OOS | ≥ 1,15 | 1,10 ≤ PF < 1,15 | < 1,10 |
| DD OOS | ≤ 8,0% | 8,0% < DD ≤ 10,0% | > 10,0% |
| Peggior Giornata | ≥ −4,0% | −5,0% ≤ PG < −4,0% | < −5,0% |
| `n` OOS (gamba) | ≥ 150 | 30 ≤ n < 150 (merito sospeso) | — (n < 30 = non misurabile) |

**Regola generale, congelata:** *qualunque* valore che dovesse risultare
ambiguo, illeggibile o coperto da due letture **si scioglie verso la clausola
PIÙ SEVERA**, e **la scelta si dichiara nel referto**. Non si aggiusta la fascia
dopo aver visto il numero.

### 5.9 🏁 VERDETTO DI ROUND — congelato prima

| esito | condizione | cosa si scrive, e cosa si fa |
|---|---|---|
| 🟢 **il segnale ha un segno** | il **motore 2** passa **tutti** i cancelli A **su almeno una gamba**, supera la **FASE 2** (§5.6) e **S1 è FALSO** (i tre motori NON vanno uguale) | *"il canale di Londra + RSI ha un'aspettativa positiva a tick reali su \<gamba\>, su un solo regime"*. → **si chiede la PROVA DI RISCHIO di §6.** **Nessuna sedia, nessun forward, ancora** |
| 🟠 **passa, ma il contenitore spiega tutto** | il motore 2 passa **ma S1+S2+S3 sono VERI** | *"il contenitore è l'edge, il segnale non conta"*. **NIENTE sedia sul segnale**: si apre un round **sul contenitore** |
| 🟠 **passa il lordo, muore il netto** | passa a slippage 0 e **cade in FASE 2** | *"vive solo a taglia piccola"* (etichetta R55). **Non si propone** |
| 🔴 **zero celle passano A** | nessuna gamba | **il motore non ha edge a tick reali su questa finestra.** Verdetto **valido e pieno** — ed è l'esito **più probabile** (§0.2) |
| 🔴 **bocciata per rischio** | A4 o A5 falliti | **vale anche col PF bello.** Il rischio non si sospende mai |
| ⛔ **non misurabile** | meno di 4 celle su 6 con n ≥ 150 in entrambe le finestre, **oppure** un gate di sanità §5.0 rosso | *"il banco non ha prodotto la misura"*. **La conclusione NON è sull'edge**, ed è vietato scriverla come se lo fosse |

### 5.10 🚫 COSA **NON** SI POTRÀ DIRE, coi dati che avremo

*Questa sezione esiste perché è la parte che si dimentica quando i numeri sono belli.*

1. ❌ **Non si potrà dire "regge nel tempo".** **Un solo regime, 24 mesi**
   (§2.3). Nessuna prova di regime, nessuna finestra ostile dichiarata.
2. ❌ **Non si potrà dire "il DD sarà quello".** È il DD di **un** broker, su
   **un** feed, in **un** regime, con il Guardian che nel backtest **non**
   interviene come sul campo.
3. ❌ **Non si potrà dire "il forex BCM ha questi spread"** in generale: si potrà
   dire *"EURUSD/GBPUSD, sessione di Londra, 2024.07-2026.06"*, che è già
   moltissimo rispetto a oggi.
4. ❌ **Non si potrà promuovere il ramo di controllo** (motore 1 o 3), nemmeno se
   è il più bello della tabella. **Soprattutto** se è il più bello (§5.2).
5. ❌ **Non si potrà dire "basta cambiare l'ora"** se ora=8 muore (§2.4).
6. ❌ **Non si potrà dire "su GBPUSD serve uno stop più largo"** e rilanciare:
   sarebbe pescare la geometria (§3.4). Sarebbe una **tesi nuova**, in un
   **round nuovo**, con criteri firmati prima.
7. ❌ **Non si potrà passare al forward** senza §6 e senza il contratto della
   sedia scritto (DD e frequenza promessi).

---

## 6. ⚖️ LA PROVA DI RISCHIO SUL VECCHIO — **PROPOSTA, NON DECISIONE**

**Il problema, in una riga:** l'Emendamento, **regola B**, dice *"il VECCHIO
giudica il RISCHIO"*. Ma **i tick veri esistono solo dal 2024.07.05**: sul
vecchio, il rischio si può misurare **solo con dati di qualità inferiore**. Le
quattro strade, con l'obiezione di ciascuna **scritta prima**:

| # | strada | pro | 🔴 l'obiezione, che è seria |
|---|---|---|---|
| **R-A** | **tranche a TICK GENERATI** (Modello 4 pre-pavimento: MT5 li fabbrica dalle M1), 2015→2024.07, **letta SOLO sul rischio** | stesso EA, stesso modello, una corsa | **lo spread è RICOSTRUITO, non vero.** Su un motore con SL 8 pip il costo è la voce dominante → **anche il DD esce ottimistico**. Un rischio misurato con un costo finto è un rischio finto |
| **R-B** | **Modello 1, OHLC M1** su finestra lunga (stile R95) | i dati M1 forex BCM sono misurati dal 1999 | ⚠️ **peggiore di R-A**: l'OHLC **non conosce l'ordine intrabar**, ed è **proprio il modello che lusinga i motori con lo stop stretto** (regola di casa). Il DD uscirebbe **troppo bello** |
| **R-C** | **PROVA DI REGIME a 4 finestre** (toro / orso / laterale / crollo), macchina già fatta in R50-R56-R59, su dati vecchi | risponde alla **regola C**, non solo alla B | stessa obiezione sui costi di R-A/R-B, **più** il campione per finestra da verificare |
| **R-D** | **non si fa**: si dichiara che il rischio è misurato su **24 mesi / un regime**, e si scarica tutto sul **criterio di uscita delle sedie** (RISCHIO per sedia sempre + tagliando 6 mesi) | onesto, costo zero | 🔴 **contraddice la regola B**: metterebbe in campo una sedia il cui rischio non è mai stato visto in un mercato ostile |

> ### 💡 LA MIA RACCOMANDAZIONE (decide Claudio)
> **R-C, ma come ROUND SEPARATO E SUCCESSIVO**, non dentro questo.
> Due ragioni:
> 1. **Mescolare due qualità di dato nella stessa corsa rende illeggibili
>    entrambe.** Questo round misura **il MERITO su tick veri**. Il rischio sul
>    vecchio è **un'altra misura, con un'altra affidabilità**, e merita un
>    referto suo che dichiari la degradazione.
> 2. Così la **regola vincolante** diventa semplice e si può firmare oggi:
>    > 🔒 **NESSUNA SEDIA LONDONFX ENTRA IN CAMPO PRIMA CHE LA PROVA DI RISCHIO
>    > SUL VECCHIO ESISTA.** Questo round può, al massimo, **guadagnarsi il
>    > diritto di chiederla.**
>
> E in **ogni** caso, qualunque strada si scelga, la clausola di lettura è la
> stessa: **su dati pre-2024.07.05 si legge SOLO il RISCHIO (DD, peggior
> giornata, perdite consecutive). Mai il merito. Mai il PF. Mai `E`.**

---

## 7. 🎚️ F5 — LA SOGLIA RSI DELLO SHORT: **20 (simmetrica) o 10 (autore)?**

**Va congelata PRIMA, e la decide Claudio.** Il fatto agli atti: l'autore usa
soglie **asimmetriche 80/10**; noi abbiamo misurato il PASSO 0 con **un solo
`InpRsiSoglia = 80` → short a 20**, cioè **più permissivo dell'autore**. Il prova
lo dichiarava **prima** dei numeri (F5): *"il nostro lato SHORT conta PIÙ segnali
di quanti ne conterebbe il sorgente"*.

| | **Opzione A — SIMMETRICA (short a 20)** ⭐ *raccomandata* | **Opzione B — FEDELE ALL'AUTORE (short a 10)** |
|---|---|---|
| **pro** | ✅ è **la configurazione che ha PASSATO il PASSO 0**: cambiarla ora vuol dire misurare **un motore diverso da quello promosso** · ✅ **stesso metro sui due lati** (regola dei due lati, 25/08) · ✅ campione short abbondante → verdetto sul merito **leggibile** su entrambi i lati · ✅ l'80/10 dell'autore **non ha una motivazione dichiarata** sulla pagina: è **un numero tarato sul passato di qualcun altro** | ✅ fedeltà alla fonte (e la fonte è ciò che si sta testando) · ✅ soglia **più selettiva** = meno segnali di qualità potenzialmente più alta · ✅ se il round boccia, la bocciatura riguarda **il motore dell'autore**, senza il nostro "però" |
| **contro** | ⚠️ è **una nostra deviazione dalla fonte**: se lo short passa, **va scritto che è passato su una soglia più permissiva dell'originale** | 🔴 **rompe la continuità col PASSO 0**: i conteggi short del 03/09 **non varrebbero più** · 🔴 lo short **potrebbe scendere sotto 150** → merito **sospeso su un lato intero** (§4.2) · 🔴 soglia **asimmetrica** = due metri per due lati |
| **conseguenza congelata se scelta** | se lo short passa **e il long no**, il referto **DEVE** scrivere: *"lo short è passato con soglia 20, più permissiva del 10 della fonte"* | se lo short cade sotto 150 op, il suo verdetto è **SOSPESO**, non negativo |

> ⚠️ **Opzione C (girare tutte e due) è SCONSIGLIATA**: raddoppia le passate e
> soprattutto **crea la tentazione di tenere la soglia che passa** = T10 in
> purezza. Se Claudio la vuole comunque, va firmata **anche** la regola che
> dichiara **quale delle due è la BASELINE** e che **l'altra non può
> promuovere**, solo indebolire.

---

## 8. 🚫 COSA **NON** SI FA IN QUESTO ROUND

1. ❌ **Nessuna griglia di parametri del motore.** SMA 5, RSI 5, soglia 80,
   TP 150 / SL 80 tick, sessione 8 ore: **tutti ai valori del sorgente**.
2. ❌ **Nessuno sweep dell'ora** (§2.4).
3. ❌ **Nessun adattamento della geometria per simbolo** (§3.4).
4. ❌ **Nessuna gestione**: parziale, breakeven, trailing **spenti** (§3.3).
5. ❌ **Nessun filtro aggiunto** (news, volatilità, trend HTF): filtro
   appiccicato a motore già tarato = **0 successi su 5** in casa.
6. ❌ **Nessun simbolo in più.** Solo le **due gambe che hanno passato il PASSO
   0**. USDJPY resta fuori (e la sonda rifiuterebbe di partire col pip
   sbagliato).
7. ❌ **Nessun M5.** Il PASSO 0 ha lasciato fasce **SOSPESE** su M5 e il tetto
   delle 100k barre morde (§2.2).
8. ✅ **Gli assi dichiarati sono DUE e sono entrambi ablazioni, non manopole:**
   **gamba** (2) × **motore** (3).

---

## 9. ✅ LA CHECKLIST DEL REFERTO — o il referto non è chiuso

- [ ] **I gate di sanità §5.0 per primi**, con i **numeri**: gemelli, autotest,
      righe per CSV, `Model=4` **dal report**, prima data del per-trade, riga
      `ticks data begins from` **ricopiata**, **quanti log del tester letti**.
- [ ] **Il canarino PRIMA del conto economico**: le **8 colonne obbligatorie**
      di §4.3, motore per motore, gamba per gamba.
- [ ] **`Giorni col Tetto Colpito`** e **`Trade Chiusi dal FLAT (%)`** con le due
      dichiarazioni di §4.3 se sforano.
- [ ] **La frequenza MISURATA contro la previsione di §4.1**, e **di quanto ho
      sbagliato**. Se la previsione era rotta, si dice.
- [ ] **Lo SPREAD MISURATO** (mediana + P95, per gamba) — **anche se il round
      boccia tutto**: chiude **H12** (§5.5).
- [ ] **`n` IS e `n` OOS accanto a OGNI numero**, e **per LATO**.
- [ ] Etichette **[MISURATO] / [INFERITO] / [DICHIARATO] / [ASSUNTO
      PRUDENZIALE]** su ogni riga.
- [ ] **L'ABLAZIONE S1/S2/S3** risolta con i numeri, **con la soglia 0,05R
      ricopiata accanto**.
- [ ] **"un solo regime"** e **"tick reali dal 2024.07.05"** accanto a ogni
      finestra.
- [ ] **La FASE 2 (slippage)** su ogni cella che passa, col verdetto letto **a 5
      punti**.
- [ ] **§5.10 ricopiato**: cosa non si può dire.
- [ ] **La previsione di §0.2** ripresa e giudicata: **avevo detto NO — cos'è
      successo?**
- [ ] **Il commit** dell'EA e dei file prova **che hanno girato davvero**.

---

## 10. ✍️ COSA DEVE FIRMARE CLAUDIO

| # | cosa | valore proposto |
|---|---|---|
| **F1** | la **finestra e il banco** | **2024.07.05 → 2026.06.30**, **Modello 4 tick REALI**, split 40/60, **M15**, gambe **EURUSD + GBPUSD** |
| **F2** | **l'ORA CONGELATA a 8** (08:00-16:00 server) | niente sweep dell'ora; 4 e 6 solo come **prova di fragilità POSTERIORE**, e **solo se 8 passa** (§2.4) |
| **F3** | **l'EA contenitore e i 3 motori** | nuovo `ABTG_LondonFx.mq5`, contenitore **identico bit per bit**, opzione **(i)**: il motore 3 si **PORTA DENTRO** (§3.5) |
| **F4** | **la soglia di somiglianza dell'ablazione** | **S1: `max(E) − min(E) ≤ 0,05R`** (= ⅔ del cancello H8) + **S2 stesso segno** + **S3 n≥150 per motore** → *"il contenitore è l'edge"* (§3.2) |
| **F5** | **la soglia RSI dello short** | **Opzione A — simmetrica, short a 20** (§7). ⚠️ **è la riga che Claudio deve decidere davvero** |
| **F6** | **il rischio delle passate** | **0,65% = taglia di campo** (non 1,00%), così il DD si legge senza scalature inferite (§5.3) |
| **F7** | **i sei cancelli A1-A6** | `E` OOS ≥ **0,075R** netta · PF OOS ≥ **1,15** · segno IS/OOS coerente e PF IS > 1,00 · DD OOS ≤ **8,0%** · Peggior Giornata ≥ **−4,0%** · **n ≥ 150** per gamba e per finestra |
| **F8** | **la bocciatura secca e le fasce disgiunte** | §5.7 + §5.8, **rischio mai sospeso**, ambiguità → **clausola severa dichiarata** |
| **F9** | **il costo** | spread **MISURATO dall'EA all'ingresso** (`InpMaxSpread=0`); se la misura manca, **1,50 pip EURUSD / 2,00 pip GBPUSD** [ASSUNTO PRUDENZIALE] (§5.5) |
| **F10** | **la FASE 2 slippage (R55-bis)** obbligatoria | 0 / 2 / 5 punti sulle celle che passano, **verdetto letto a 5 punti** (§5.6) |
| **F11** | **niente selezione** | nessun picco, nessuna "cella migliore", **promuovibile solo il motore 2** (§5.2) |
| **F12** | **il tetto del round** | **da qui NON esce una sedia**: al massimo il **diritto di chiedere la prova di rischio sul vecchio** (§6, raccomandata **R-C come round separato**) e poi il forward demo |

> ⚠️ **Finché queste dodici righe non sono firmate, questo file resta una BOZZA,
> l'EA non si scrive e la riga di lancio non si costruisce.**

---

## 11. 📨 LE DODICI FIRME IN FORMATO CHAT — una riga l'una

_Da incollare a Claudio così com'è. Può rispondere **`firmo tutte`**, oppure
**`firmo tutte tranne la 5, sulla 5 voglio l'opzione B`**, oppure cambiare un
numero. Le caselle le riempio io dopo la sua risposta, con la data._

| # | firmato? | la domanda, in una riga |
|---|:--:|---|
| **F1** | ⬜ | **Finestra `2024.07.05 → 2026.06.30`, TICK REALI (Modello 4), M15, EURUSD + GBPUSD.** Si parte dal pavimento tick MISURATO, non dal 2024.09.26 del PASSO 0: **+83 giorni di campione**, ma i conteggi **non** sono confrontabili riga per riga col referto del 03/09. **Un solo regime, dichiarato.** |
| **F2** | ⬜ | **Ora CONGELATA a 8 (08:00-16:00 server = Londra esatta).** Era la previsione dichiarata **prima** dei numeri nel PASSO 0, e la catena dei fusi ha una risposta fisica. Le ore 4 e 6 tornano **solo dopo**, e **solo se 8 passa**, come prova di fragilità: **se 8 muore, non si guardano nemmeno.** |
| **F3** | ⬜ | **Nuovo EA `ABTG_LondonFx.mq5`: UN contenitore, TRE motori a interruttore** (canale nudo / canale+RSI / allineamento 5 medie). Il terzo si **porta dentro** invece di far girare `ABTG_AllineaLondra` a parte, perché le uscite non si possono allineare per input (TP in R contro TP fisso) e l'ablazione si romperebbe. `ABTG_AllineaLondra` **resta intatto**. |
| **F4** | ⬜ | **"I tre vanno uguale" = scarto di aspettativa ≤ 0,05R fra i tre, stesso segno, n≥150 ciascuno.** Lo 0,05R sono **due terzi del cancello H8 firmato il 31/08**: sotto quella distanza i motori non si distinguono in modo che cambi un'ammissione. Se è vero → **il contenitore è l'edge e NON esce nessuna sedia sul segnale.** |
| **F5** | ⬜ | 🔴 **LA SOGLIA RSI DELLO SHORT.** Propongo **A = simmetrica (short a 20)**: è la configurazione che ha **passato il PASSO 0** e usa **lo stesso metro sui due lati**. L'alternativa **B = 10 dell'autore** è più fedele alla fonte ma **rompe la continuità col PASSO 0** e rischia di portare lo short **sotto 150 operazioni** (merito sospeso su un lato intero). **Decidi tu.** |
| **F6** | ⬜ | **Rischio delle passate 0,65% (la taglia di campo), non 1,00%.** Così il DD si confronta col muro prop **senza la scalatura inferita** che R95 ha dovuto marcare, e il cap di perdita giornaliera del 2% morde **come morderebbe sul campo**. Prezzo: i profitti in euro non si confrontano con R82/R95. |
| **F7** | ⬜ | **I sei cancelli:** `E` OOS ≥ **0,075R NETTA** (la tua FIRMA 2 del 31/08) · PF OOS ≥ **1,15** · segno IS/OOS coerente · DD OOS ≤ **8,0%** · **Peggior Giornata ≥ −4,0%** (oltre, il **Guardian avrebbe messo in pausa la giornata**: quel backtest non è nemmeno riproducibile) · **n ≥ 150** per gamba e per finestra. |
| **F8** | ⬜ | **Bocciatura secca sul RISCHIO a qualunque `n`** (DD > 10% o giornata < −5%), e **tre fasce disgiunte** su ogni grandezza (passa / zona morta / bocciata): nessun valore cade in due clausole, e ogni ambiguità si scioglie verso **la più severa**, dichiarandolo. |
| **F9** | ⬜ | **Lo spread si MISURA, non si assume** (lezione R55): l'EA lo registra all'ingresso, mediana e P95 → **questo round chiude il buco H12 anche se boccia tutto**. Se la misura mancasse, si rilegge con **1,50 pip EURUSD / 2,00 pip GBPUSD** [prudenziale]. **Chi passa solo a 1,0 pip e muore a 1,5 NON passa.** |
| **F10** | ⬜ | **R55-bis obbligatorio, dentro questo round.** Lo stop è **8 pip**: è la classe dell'ORB, che con **1,5 punti** di slippage sfondava il 10% di DD. Slippage 0 / 2 / 5 punti sulle celle che passano, e **il verdetto si legge a 5 punti (0,5 pip = 6,3% di un R)**. |
| **F11** | ⬜ | **Niente selezione: questo round non ha una griglia, quindi non ha un picco.** Vietato nominare "la cella migliore", vietato promuovere i rami di controllo (motore nudo o 5 medie), vietato tenere la gamba che va meglio. **Promuovibile solo il motore 2, gamba per gamba.** |
| **F12** | ⬜ | **Da questo round NON esce una sedia.** Il massimo che può ottenere è **il diritto di chiedere la prova di rischio sul vecchio** (§6 — raccomando **R-C, prova di regime, come round SEPARATO**, perché mescolare tick veri e dati vecchi rende illeggibili entrambi) e poi il **forward demo**. |

> 🔕 **E una cosa che NON ti sto chiedendo di firmare:** che il round dia un
> risultato. **L'esito più probabile, scritto qui prima dei numeri, è NO** — la
> MAE mediana misurata al PASSO 0 (**11,8 pip**) sta **sopra** lo stop della
> fonte (**8,0 pip**), e il costo è **da 1,7 a 3,3 volte l'edge richiesto**.
> Sarebbe un **verdetto valido e utile**, non un fallimento: chiuderebbe con una
> misura il primo superstite della missione frequenza, **e ci lascerebbe in mano
> lo spread BCM di Londra**, che oggi non abbiamo.

---

_Fine bozza. **Nessun numero di questo round è stato prodotto, letto o guardato.
Nessun EA è stato compilato. Nessuna riga di lancio è stata costruita.**_

---

## ✍️ FIRMA — 03/09/2026, ~09:45 (Claudio, in chat: "FIRMO TUTTO, ANCHE LA A SU F5")

**TUTTI i criteri di questa bozza sono CONGELATI come proposti**, incluse le
scelte raccomandate nei punti aperti:
- **F5 = OPZIONE A** (soglia RSI short SIMMETRICA a 20 — esplicitamente
  firmata: "anche la A su F5");
- ora di sessione CONGELATA a 8 (le altre tornano solo dopo, se la 8 passa);
- rischio 0,65% per trade;
- terzo motore (allineamento 5 medie) DENTRO il contenitore, come da
  raccomandazione F3;
- prova di rischio sul vecchio = ROUND SEPARATO (R-C), con la regola
  vincolante "nessuna sedia in forward prima che quella prova esista";
- cap 2%/giorno acceso, con la rinuncia dichiarata su A5.

Da qui in avanti i criteri NON si toccano: prima i numeri, poi (semmai) le
revisioni, mai il contrario. Prossimo passo: costruzione dell'EA contenitore
`ABTG_LondonFx` (repo-only) + riga di lancio dal verificatore.

---

### 🏗️ EA costruito (repo-only, MAI COMPILATO): `mql5/Experts/ABTG_LondonFx.mq5`, **v1.00**

_03/09/2026, subito dopo la firma. **Non compilato, non girato, nessuna riga di
lancio**: qui non esistono MetaEditor né Strategy Tester. La compilazione e la
riga di lancio sono del verificatore._

**2.012 righe, ASCII puro.** Cosa c'è dentro, mappato sulle firme:

| firma | dove vive nel codice |
|---|---|
| **F3** — un contenitore, tre motori | `InpMotore` (1/2/3) → **`MotoreSegnale_Calc()`, unica funzione in cui i tre si distinguono**. Tutto il resto è attraversato da tutti e tre |
| **F3** — motore 3 portato dentro | `AllineaLong_Calc` / `AllineaShort_Calc` copiate **alla lettera** da `ABTG_AllineaLondra.mq5` righe 356-373. Di quell'EA **non** si prende altro (né sessione, né TP in R, né parziale/pari/trailing). **`ABTG_AllineaLondra.mq5` non è stato toccato** |
| **F5 = A** | un solo `InpRsiSoglia = 80`; lo short usa `100 - 80 = 20`, **confronto stretto su entrambi i lati**, autotest sul **bordo esatto** (80,0 e 20,0 non armano). Entrambe le soglie escono in colonna |
| **F2** — ora 8 | `InpOraInizioServer = 8`, `InpOreSessione = 8`, fine **esclusa**; autotest sui bordi 08:00 (dentro) / 16:00 (fuori) |
| **F6** — 0,65% | `InpRiskPercent = 0.65`, lotto dalla distanza **davvero piazzata** |
| **F9** — spread misurato | `InpMaxSpread = 0` (spento); `(ask-bid)/pip` registrato **all'ingresso** → colonne **Spread Mediano** e **Spread P95** (`PercentileOrdinato_Calc`, nearest-rank, ricontabile a mano) |
| **F10** — R55-bis | `InpSlippagePts` (0/2/5): **costo simulato sulla geometria**, SL 8,0 + S e TP 15,0 − S. **Non** è la deviation di CTrade (che resta fissa a 30 pt = contenitore) |
| **canarino (§4.3)** | le **8 colonne obbligatorie stanno PRIME nel CSV**, prima del conto economico, e escono da `FrameAdd`/OPTFRAME, non da `Print` |
| geometria (§3.4) | `LONDONFX_TP_PIP 15.0` / `LONDONFX_SL_PIP 8.0` sono **`#define`, non input**: non si adattano per simbolo dalla riga di lancio |
| contenitore (§3.3) | flat **non disattivabile** (nessun bool lo spegne), 1 posizione, tetto 6/giorno, cap 2%/giorno che **chiude e blocca**, Guardian acceso |
| gestione (§3.3) | **non esiste nel file**: niente parziale, niente breakeven, niente trailing. Non è un input a `false` — è codice che non c'è |

**Tre cose in più rispetto alla bozza, dichiarate qui perché sono scelte nostre:**

1. **N6 — l'ingresso deve cadere dentro la sessione.** Il segnale nasce su barra
   chiusa e l'ordine parte all'apertura della successiva: quello delle 15:45
   entrerebbe alle 16:00, cioè dove il flat chiude al tick dopo. Non si apre.
   **Non è un taglio anticipato**: è lo stesso cancello di sessione applicato al
   momento in cui l'ordine parte. Costo misurato dalla colonna **`Segnali
   Soppressi Fine Sessione`**. Conseguenza: su M15 l'ultima barra di segnale
   utile è quella delle **15:30**.
2. **`E In R` in colonna**, col suo denominatore accanto (`Rischio Medio
   Valuta` = media dei rischi in euro **dichiarati all'apertura**). Il cancello
   A1 si legge senza scalature a mano. Limite dichiarato: esatto al primo
   ordine, non al centesimo (il rischio in euro cresce col saldo).
3. **`Canarino Torna` (1/0)**: l'EA verifica da sé l'identità
   `Segnali Generati = Ingressi + le 5 soppressioni + Ingressi Falliti`. Se è
   **0**, le colonne del canarino **non si leggono**.

**Sicurezza — hedge-safe dalla nascita (audit del 03/09):** zero occorrenze di
`PositionSelect(_Symbol)` fuori dai commenti, zero `PositionClose/Modify/
ClosePartial(_Symbol)`. Lettura per `PositionsTotal()` + `PositionGetTicket(i)`
filtrata **simbolo + magic**, scrittura **solo per ticket**.

**Autotest:** `InpAutoTest` esegue **17 blocchi / 112 casi**, con **due**
contatori attesi (`#define` su blocchi *e* casi: un blocco svuotato delle sue
asserzioni non passa per verde). Bordi esatti esercitati: cap −2,00%, tetto 6,
sessione 8/16, RSI 80/20, uguaglianza stretta sul canale, geometria con
slippage, P95. Esito in colonna (`Autotest Falliti` / `Blocchi` / `Casi`).

**Magic:** `InpMagic = 774001` — blocco **7740xx verificato vergine oggi** nei
sorgenti (`7741xx` è di `ABTG_GapContinuation`). ⚠️ **Da ri-verificare il giorno
del lancio.**

🚫 **Cosa NON è stato verificato in questo giro, e va detto:** **la
compilazione** (nessun MetaEditor qui: errori di sintassi/tipo sono possibili e
li scoprirà l'F7), il comportamento a runtime, la frequenza reale del motore 3
(mai contata da nessuno), e ovviamente **nessun numero di backtest**. I
controlli fatti sono statici: bilanciamento dei blocchi, ASCII puro, nessuna
funzione duplicata, allineamento **56 nomi = 56 specificatori = 56 argomenti**
del CSV OPTFRAME, indici `stats[0..52]` tutti assegnati.

### ✅ 03/09 ~12:10 — verifiche d'integrita' pre-lancio (fatte in sessione, non da agente)
- **Magic 774001 VERGINE**: unica occorrenza nel repo = il default input di
  ABTG_LondonFx.mq5. 774101 e' GapContinuation (7741xx, altro blocco). Da
  ri-confermare col grep il giorno del lancio (la sedia potrebbe nascere prima).
- **ABTG_LondonFx hedge-safe confermato**: zero `PositionSelect(_Symbol)` /
  `PositionClose(_Symbol)` / `PositionModify(_Symbol)` fuori dai commenti (le
  2 occorrenze sono commenti che spiegano cosa NON fa). Il difetto C9 non nasce.
- **Graffe bilanciate** (diff 0) su ABTG_LondonFx, ABTG_ORB v1.01, ABTG_MaxMinNotte
  v1.11 — integrita' strutturale ok (NON e' una prova di compilazione: quella
  resta il primo passo del giro a vuoto).
