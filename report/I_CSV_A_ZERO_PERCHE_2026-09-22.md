# 🕳️ I 113 CSV A ZERO — **PERCHÉ**, motore per motore, con la riga di codice accanto

**22/09/2026** · repo `/home/user/GITHUB`, branch `lavoro` · 🛑 **SOLA LETTURA E ZERO TEMPO
MACCHINA**: nessun round lanciato, nessuna riga consegnata a Claudio, niente VPS, niente
forward, nessun preset toccato, nessuna sedia promossa o spenta.

> **Il mandato in una riga:** il censimento di stanotte
> (`report/CENSIMENTO_CASELLE_VUOTE_2026-09-22.md`, commit `f85e9320`) ha contato **113 CSV
> con `Trades = 0` su TUTTE le passate** e li ha chiamati *«misure non avvenute»*. Giusto.
> **Ma "non avvenuta" non è una causa.** Questo dossier dice **PERCHÉ**, e per ogni causa
> porta **file e riga** — oppure la marca `[IPOTESI NON VERIFICATA]`.

---

## 🥇 IL VERDETTO IN SEI RIGHE

1. ✅ **Il 113 l'ho riprodotto da zero e torna**: 113 file, **636 passate** buttate. Script
   in scratchpad, criterio in §1.
2. 🟢 **Su 113 CSV, ne ho spiegati 110 con una causa PROVATA nel codice o nei dati
   (file + riga + numero). Restano 3 con causa parziale**, dichiarati in §8.
3. 🔴 **La causa NON è quasi mai "manca il feed".** È quasi sempre **una soglia in
   un'unità sbagliata** o **un cancello che il motore non può passare per costruzione**.
   Tre difetti di unità distinti, tutti e tre con l'EA che lo dichiara nel proprio commento.
4. 🎯 **Chiudo un buco aperto il 09/09.** `REGISTRO_TEST.md` r.490-496 lascia **AUDUSD e
   USDJPY** di `Nightly` come *«causa [NON MISURATO]»*. **La causa c'è ed è a r.167**:
   `InpBlockNightActive` + `NightActiveSymbol()` **rifiuta per nome** ogni simbolo che
   contenga `JPY`/`AUD`/`NZD`. Quei due CSV non sono una misura mancata: sono **l'EA che
   dice di no come da progetto**.
5. 🔴 **E correggo due righe di documenti fratelli, coi numeri**: (a) *«palladio e platino
   non hanno storico utile»* (censimento §3) **è falso** — 26.619 barre H1 dal **2015.03.29**,
   misurate; (b) `GapFill` su **E35EUR** ha **40 operazioni in OHLC e 0 a tick reali** mentre
   **nove simboli su dieci riproducono entro ±10%**: quel 40 **non è validato e non va usato**.
6. 🛑 **Nessuno di questi motori diventa una sedia entro il 1 ottobre**, e non lo propongo.
   🟢 **Ma otto voci su tredici costano ZERO minuti di macchina**, perché sono verdetti da
   riscrivere, non round da lanciare.

### 🟢 La buona notizia, detta subito
**Non abbiamo buttato 636 passate per sfortuna: le abbiamo buttate per tre difetti
ripetibili**, e tutti e tre si vedono *prima* di lanciare, leggendo un input e il suo
commento. È materiale da checklist, non da rimpianto.

---

## 1️⃣ 📐 METODO — e dove può sbagliare

| passo | cosa ho fatto |
|---|---|
| 1 | Percorso ogni `.csv` sotto `risultati_prove/`, `risultati_archivio/`, `risultati_ottimizzazione/` (esclusi i worktree `.claude/`) |
| 2 | Un file è **a zero** se ha la colonna `Trades` e **ogni riga vale 0** |
| 3 | Risultato: **113 file · 636 passate** — 🟢 **identico al censimento**, ottenuto con codice mio |
| 4 | Per ogni gruppo: letti gli `Inp*` **dentro il CSV** (non i preset: il CSV è ciò che è *davvero* girato), poi il `.mq5` riga per riga, poi il file prova |
| 5 | Per ogni causa ho cercato **nei dati già in repo** un caso che la **falsificasse** |

🔴 **Dove può sbagliare, dichiarato**: il CSV non porta la **finestra** della corsa. Dove
serviva l'ho ricavata dal referto del round (`REFERTO_WEEKEND_FASE0.md` r.7) o dalla riga di
lancio; dove non ci sono riuscito l'ho scritto.

---

# 2️⃣ 🎯 `ABTG_PostNews` — **PRIMA E A PARTE**, perché tocca il campo

## 2.1 Il fatto
**4 CSV su 4, tutte le passate a `Trades = 0`** — `risultati_prove/ABTG_PostNews/ABTG_PostNews_{EURUSD,EURJPY}_{IS,OOS}_ohlc.csv`.
`backtest_pipeline/REGISTRO_TEST.md` r.77 li liquida: *«letto come "nessun edge" il 07/08 —
⚠️ RITIRATO»*. 🔴 **PF 0,00000 su 0 operazioni non è "nessun edge": è NESSUNA MISURA.**

## 2.2 LE DUE CAUSE, tutte e due con la riga — e **basta una sola** per fare zero

### 🔴 CAUSA A — **il CANALE**: l'EA non poteva nemmeno aprire il calendario
La versione che ha girato è quella di agosto (`git show 3af47ed9:mql5/Experts/ABTG_PostNews.mq5`,
**458 righe**):

- **r.365**: `int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');` — 🔴 **nessun
  `FILE_COMMON`**. Nel tester ogni agente ha la **sua** sandbox `MQL5\Files`, dove i driver
  di casa non copiano file ausiliari.
- **r.366**: `if(h==INVALID_HANDLE){ Log("file news non trovato..."); return; }` → 0 eventi.
- **r.133**: `if(InpRestrictToNews && !NewsToday(t0)){ ... return; }` → 🔴 con 0 eventi
  **nessun ordine, mai, in nessun giorno**.

🟢 **Il modo in cui fallisce è quello giusto: FAIL-CLOSED.** Non ha sbagliato orario: non ha
aperto. Nessun rischio è stato corso.

### 🔴 CAUSA B — **il DATO**: nella finestra IS il calendario aveva **ZERO eventi**, punto
Calendario al momento del round (`git show 22a995e2:mql5/Files/abtg_news.csv`, **18 righe =
1 intestazione + 17 eventi**): **il primo evento è il `2026.01.07`.**
Finestre del round (`backtest_pipeline/risultati_archivio/REFERTO_WEEKEND_FASE0.md` r.7):
**IS 26/09/2024 → 09/06/2025 · OOS 10/06/2025 → 30/06/2026**.

| finestra | eventi nel calendario | eventi che passano `InpNewsTitleMatch=ECB` *(letto nel CSV)* |
|---|---:|---:|
| **IS** 2024.09.26 → 2025.06.09 | 🔴 **0** | 🔴 **0** |
| **OOS** 2025.06.10 → 2026.06.30 | 9 | 🔴 **1** (il `2026.01.29`) |

👉 **Sull'IS la causa B da sola è decisiva e non ammette repliche: zero eventi in finestra
⇒ zero ordini, anche con il canale perfetto.**

### 🧪 IL CONTRO-ESEMPIO che mi sono costruito contro
> *«E se lo zero fosse invece colpa dell'ORARIO (`InpActionHour=14`) o del simbolo?»*

**Non regge, e lo dimostro senza lanciare niente.** L'orologio **non può nemmeno entrare in
gioco**: a **r.133** il controllo `InpRestrictToNews && !NewsToday(t0)` sta **PRIMA** di
qualunque uso di `InpActionHour`, e nella finestra IS `NewsToday` **non ha nessuna riga su
cui essere vera** (zero eventi in calendario). 👉 **Un orario sbagliato produrrebbe uno zero
PARZIALE su una finestra popolata; qui la finestra è VUOTA, e lo zero è totale su 4 file su
4.**
🔴 **E quello che NON ho verificato lo dico**: se `InpActionHour=14` (ora server) sia il
valore giusto rispetto a un evento BCE delle **13:45 UTC** resta **`[NON VERIFICATO]`** —
il calendario è dichiarato UTC e BCM è UTC+1 d'inverno, quindi l'evento cadrebbe alle
**14:45 server**, *dopo* l'ora d'azione. **Non serve alla diagnosi dello zero, ma è la prima
cosa da controllare nel log quando il round girerà davvero**, e la aggiungo in §8.

## 2.3 🛠️ È GIÀ RIPARATO NEL CODICE — e **nessuno ha rifatto la corsa**
`mql5/Experts/ABTG_PostNews.mq5` **v1.10** (commit `61dc18c9`, 03/09):
- **r.88** `input bool InpNewsCommon = true;` · **r.532-534** `FileOpen(...|FILE_COMMON,';')`
  con ripiego sulla sandbox a **r.539**;
- **r.544** canarino `CALENDARIO CIECO` · **r.584** riga di copertura
  `[PostNews][NEWS] letto da … | righe N | UTILI per questo preset N | dal … al …`;
- **il calendario vero esiste**: `mql5/Files/abtg_news_postnews_2010_2025_UTC.csv`,
  **599 eventi 2010-2025** (`REGISTRO_TEST.md` r.100-103).

🔴 **E i 7 file prova sono lì fermi** (§2 del censimento): `POSTNEWS_1330_00_conta`,
`POSTNEWS_ISM_00_conta` (04/09), `POSTNEWS_ORO_00_conta`, `_01_SL`, `_02_attesa`,
`_03_offset`, `_04_uscita` (11/09). **Il fix è di 19 giorni fa. La misura non è mai partita.**

## 2.4 🪑 E IL CAMPO — la parte che Claudio deve sapere stanotte

**La misura, non la mia opinione.** Le tre istanze `771202` FOMC · `771203` NFP · `771204`
ECB hanno **contratto vuoto su tutta la riga**: PF `[NON MISURATO]`, n `[NON MISURATO]`, DD
`[NON MISURATO]` — `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` r.69-71, che cita
proprio questi 4 CSV a zero come unica fonte disponibile.
E `report/LE_POSTNEWS_NON_TRADERANNO_2026-09-20.md` misura la seconda metà: **il calendario
del forward è finito** (`771203` ha **zero** eventi futuri; FOMC/ECB il primo utile è il
28/10/2026, e **anche quello è incerto** perché in repo ci sono due `abtg_news.csv` diversi e
`data/abtg_news.csv` è **vuoto, 0 byte** — verificato ora).

🔴 **Quindi le due cose insieme fanno una frase sola, ed è questa:**
> **Tre istanze PostNews non hanno MAI avuto un numero in backtest, e nel forward il loro
> rubinetto è chiuso.** Non hanno mai potuto essere misurate né prima né adesso.

🟢 **Due attenuanti misurate, che vanno dette insieme al resto:**
1. **Il rischio corso è ZERO**: una sedia che non apre non perde. Fail-closed.
2. 🔴 **CONTRADDIZIONE IN REPO, e la segnalo invece di sceglierne una arbitrariamente.**
   `backtest_pipeline/righe/RINOMINA_CLAU12.ps1` r.143 riporta che il referto della corsa
   **vera** di schieramento (zip `SCHIERA_FTMO_2026-09-20_102153`) stampa **`MODO: SENZA
   POSTNEWS`**, opzione che esclude l'EA (`SCHIERA_FTMO.ps1` r.476) e i suoi tre preset
   (r.503). 👉 **Se quel referto dice il vero, sul terminale FTMO `541452707` le PostNews non
   ci sono proprio**, e allora il conto delle sedie è ancora diverso. **`FLOTTA_ATTIVA.md`
   r.54-55 elenca invece due PostNews (EURJPY/EURUSD M5) come 🟡 sul demo.**
   **`[NON VERIFICABILE DA QUI]`** — si chiude con **una riga di sola lettura** che stampa
   gli EA attaccati.
   🔴 **Bersaglio della riga, quando la si scriverà: 🖥️ finestra PowerShell sul VPS, in sola
   lettura; nessun MT5 da aprire, nessun terminale toccato.** Io non la scrivo e non la
   mando: non è nel mio perimetro.

🛑 **E non propongo di spegnere niente.** Porto la misura; la decisione è di Claudio.

## 2.5 💰 La prima misura vera di `PostNews`, col costo
| | |
|---|---|
| **cosa cambiare** | **nulla nel codice** (già fatto, v1.10). Serve solo: copiare `abtg_news_postnews_2010_2025_UTC.csv` in `Common\Files` **e** nella sandbox, e lanciare `POSTNEWS_ORO_00_conta` / `POSTNEWS_1330_00_conta` |
| **passate** | il file prova è un **asse tecnico sul magic** = 2 celle × 2 finestre = **4 passate** |
| **minuti (tetto M5)** | 4 × 90 s = **6 min** |
| **controllo obbligatorio PRIMA di leggere il numero** | nel log deve comparire `[PostNews][NEWS] … UTILI per questo preset N` con **N > 0**. Se N = 0 o compare `CALENDARIO CIECO`, **la passata si butta**: è di nuovo "non è girata", non "niente edge" |
| 🔴 **attesa dichiarata PRIMA** | **12-16 eventi l'anno**: il pavimento dei **150 trade** (Emendamento A) **non è raggiungibile** su nessuna finestra ragionevole. 👉 **Da questa misura non può uscire nessuna promozione.** L'unico giudizio valido è quello sul **RISCHIO** (Emendamento B), che vale a qualunque n |

---

# 3️⃣ 📊 LA TABELLA MADRE

`P` = passate della prima misura vera · minuti col **tetto superiore** di **90 s/passata**
(misura 21/09 sul PC di backtest: 8 passate M5 modello 4 in **11 min 57 s** nel caso largo).
🔴 **Il tetto vale anche per i TF alti**: a modello 4 il tester rigioca **lo stesso flusso di
tick** qualunque sia il TF, quindi il costo **scende ma NON in proporzione** — il fattore di
sconto è `[NON MISURATO]`.

| # | motore | simbolo/i | TF | finestra | CSV a zero | **CAUSA (file : riga)** | rip.? | cosa cambiare | P / min |
|---|---|---|---|---|---:|---|:--:|---|---:|
| 1 | **`PostNews`** | EURUSD·EURJPY | M5 | IS 24.09.26→25.06.09 · OOS →26.06.30 | **4/4** | **(A)** `ABTG_PostNews.mq5@3af47ed9` **r.365** `FileOpen` senza `FILE_COMMON` → r.366 → **r.133** `InpRestrictToNews` blocca · **(B)** `abtg_news.csv@22a995e2`: **0 eventi in IS**, **1** in OOS | 🟢 **SÌ — già riparato** (v1.10 r.88/532) | copiare il calendario in `Common\Files` e lanciare i file prova fermi | **4 / 6** |
| 2 | **`Nightly`** | D30EUR·U30USD·XAUUSD | M1 box | idem | **6/6** *(3 sim × 2)* | `ABTG_Nightly.mq5` **r.72** `InpMaxNightVolPips=45` **in pip**, confrontato a **r.201** con `ATR(H1)/PipSize()` e **r.109-113** (la regola è a **r.112**) `PipSize()` = `_Point` se `Digits∉{3,5}` → soglia reale **0,45 punti indice / 0,45 USD** | 🟢 **SÌ** | `InpMaxNightVolPips` in **asse**, valori scalati al simbolo (o 0 = spento) | **8 / 12** |
| 3 | **`Nightly`** | AUDUSD·USDJPY | M1 box | idem | **4/4** | 🔴 **NUOVA — chiude il buco del 09/09**: `ABTG_Nightly.mq5` **r.133-137** `NightActiveSymbol()` = `StringFind(s,"JPY")≥0 \|\| "AUD" \|\| "NZD"` + **r.167** `if(InpBlockNightActive && NightActiveSymbol()){ gPhase=NP_DONE; return; }` → **rifiuto per NOME, ogni giorno** | 🟡 **SÌ ma serve una TESI** | `InpBlockNightActive=0` — **contro** la strategia dichiarata a r.75 | **4 / 6** |
| 4 | **`Nightly`** | XAGUSD (IS) | M1 box | IS 24.09.26→25.06.09 | **1** | stessa r.72, ma **borderline**: `XAGUSD` ha `Digits=3` → `PipSize=0,01` → soglia **0,45 USD** di ATR(H1). Non blocca sempre (**l'OOS fa 4 trade**) | 🟢 SÌ | come #2 | *incluso in #2* |
| 5 | **`SupertrendInvert`** | 225JPY·D30EUR·EURUSD·GBPJPY·NASUSD·U30USD·XAGUSD·XAUUSD | **11 TF** M15→D1 | idem | **11/20** | **congiunzione di cancelli anti-correlati col trigger**: `ABTG_SupertrendInvert.mq5` **r.207-211** cinque `return` in fila; **r.219-225** `IsStrong` pretende close oltre **EMA50 *e* EMA200** *sulla barra del flip*; **r.228-235** `AdxOK` pretende ADX **in crescita** *sul flip* | 🟢 **SÌ** | ablazione su **`InpRequireStrong`** e **`InpAdxRising`** — 🔴 **le due manopole che i 3 file prova NON toccano** | **8 / 12** |
| 6 | **`GapFill` regime** | EURUSD·GBPUSD | H1 | TORO'21·ORSO'22·LATERALE'19·CROLLO'20·CROLLO_ANNO'20 | **16/18** | cancello **r.383-389** `ag < InpGapMinATR*atr` con `InpGapMinATR=0,3` (letto nel CSV) su `ATR(D1)`. 🔴 **La causa del salto 2019-22 vs 2024-26 è `[IPOTESI NON VERIFICATA]`**: §7 | 🟢 **SÌ, e costa pochissimo** | **una cella** con `InpGapMinATR=0` sulla finestra TORO: discrimina *mercato* da *feed* | **2 / 3** |
| 7 | **`OpeningReversalB`** | U30USD | M5 | IS+OOS | **8** *(4 + 4 copie `dal_vps`)* | 🟢 **leggibile DENTRO il CSV**: colonne `State1 / State2 / FT Timeout / PB Timeout / Entry Trigger`. OOS: State1 **15-38** → State2 **10-21** → **`Entry Trigger` = 0 su tutte le 12 passate**. Strozzatura = **i due timeout**, `InpPBMaxBars=3` e `InpFTBarsWindow=2` | 🟡 **SÌ per la frequenza, NO per il costo** | `InpPBMaxBars` / `InpFTBarsWindow` in asse. 🔴 **ma vedi §6.2: la geometria è sotto la frontiera del costo di 4×** | **8 / 12** |
| 8 | **`BreakingBand`** scan | 24 sim. H4 ×3 cartelle + 8 sim. H1 | H1·H4 | idem | **58** | **rarità STRUTTURALE del pattern «bulge»**: nessun simbolo su 48 supera **8 trade** su 21 mesi a H1 e **6** a H4. 🔴 **Lo zero non dice niente sul simbolo: dice tutto sul TF** | 🔴 **NO, non entro il metro di casa** | *(vedi §6.1)* | — |
| 9 | **`GoldenCross`** | XPDUSD · XPTUSD | H1 | idem | **2** (123 + **127** passate) | `[PARZIALMENTE VERIFICATA]` — 🔴 **NON è "storico assente"**: sonda `215D85D7_ABTG_InfoBroker.csv` dà **26.619 / 26.734 barre H1 dal 2015.03.29**, e `EMA200` su XPDUSD **fa trade in 29 passate su 145**. Il perché resta aperto: §8 | 🟡 **da capire, non da riprovare** | una passata `InpVerbose` e si legge | **2 / 3** |
| 10 | **`MaxMinNotte`** | EURUSD (OOS) | M15 mgmt | OOS | **1** | 🔴 **unità sbagliata, e l'EA lo dichiara da solo**: `ABTG_MaxMinNotte.mq5` **r.140** `input double InpBufferPoints = 1000; // … (DAX BCM: 1000 = 10 punti indice)` e **r.727** `MathMax(InpBufferPoints,stops)*_Point`. Su EURUSD (`Point=0,00001`, misurato) **1000 punti = 100 PIP** di buffer oltre il box notturno | 🟢 **SÌ** | `InpBufferPoints` scalato: **100 = 10 pip** | **4 / 6** |
| 11 | **`GapFill` tick** | E35EUR | H1 | tick reali | **1** | 🔴 **feed TICK mancante o bucato su quel solo simbolo**: OHLC **40 trade**, tick **0**, mentre **9 simboli su 10 riproducono entro ±10%** | 🟡 **SÌ, ma è manutenzione dati** | verificare/scaricare lo storico a tick di `E35EUR` sul banco | **3 / 5** |
| 12 | **`SupertrendReversal`** R113 | NASUSD | H1 | ORSO 2022.01→2022.10 | **1** | **nessun difetto**: `InpAllowLong=0 / InpAllowShort=1` (lato SHORT isolato) e nella stessa finestra `F1_00_metro`=7 e `F1_01_long`=7 → **tutte e 7 le operazioni erano LONG**. Zero short è il **risultato**, non un errore | 🔴 **NO — non c'è niente da riparare** | — | 0 / 0 |

**Somma dei riparabili: ~43 passate ≈ 65 minuti** col tetto superiore. Meno di due round da 48.

---

# 4️⃣ 🧪 I CONTRO-ESEMPI — *«se la causa fosse questa, cosa DOVREI vedere e non vedo?»*

**Questa sezione è il cuore del dossier.** Ogni causa qui sopra è passata di qui, e quelle
che non ce l'hanno fatta sono marcate `[IPOTESI NON VERIFICATA]`.

| causa dichiarata | l'ipotesi ALTERNATIVA che l'ammazzerebbe | **cosa dicono i dati in repo** | esito |
|---|---|---|---|
| **#2 `Nightly`, filtro QB in pip** | *«i metalli e gli indici semplicemente non hanno dati di notte»* | 🟢 **Falsificata**: `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` su **D30EUR** fa **20/21 trade**, `MaxMinNotte` su **XAUUSD** fa **59/92** — stesso box notturno, stessi simboli, stesso broker | ✅ **causa tiene** |
| **#2 vs #4** *(il discriminante più bello)* | *«allora tutti i metalli sono bloccati»* | 🟢 **No, e l'aritmetica lo prevedeva**: `XAUUSD` ha `Digits=2` → soglia **0,45 USD** di ATR(H1) → **sempre bloccato**; `XAGUSD` ha `Digits=3` → `PipSize=0,01` → stessa soglia in USD ma l'argento ci sta **sotto** → **4 trade in OOS**. Due metalli, stessa soglia nominale, esiti opposti, **esattamente come predetto dai Digits misurati** | ✅ **causa tiene, in modo forte** |
| **#3 `Nightly`, blocco per nome** | *«AUDUSD e USDJPY sono zero per lo stesso filtro QB»* | 🟢 **Falsificata dall'aritmetica**: `USDJPY` `Digits=3` → soglia 0,45 JPY di ATR(H1); `AUDUSD` `Digits=5` → soglia **45 pip** di ATR(H1). **Tutte e due passerebbero larghe.** Resta solo r.167 | ✅ **causa tiene** |
| **#5 `SupertrendInvert`, i cancelli** | *«il trigger Supertrend è raro di suo su questi simboli»* | 🟢 **Falsificata**: il fratello `ABTG_SupertrendReversal` — **stesso trigger di flip Supertrend**, ma **senza** `IsStrong` e **senza** ADX-rising — fa **mediana 93 trade (max 331)** su XAUUSD H1 e **mediana 114 (max 417)** su EURUSD H1. 👉 **Il trigger è frequentissimo. Sono i filtri a uccidere.** | ✅ **causa tiene** |
| **#6 `GapFill` regime** | *«2019-2022 non c'è lo storico forex sul banco»* | 🟢 **Falsificata nella stessa cartella**: nelle **identiche finestre e sugli identici simboli**, `BB` fa 1-18 trade, `EZ` 10-35, `LARRY` 3-19, `PTE` 11-51, `SW` 17-65. **Il dato c'è.** | ✅ **il feed è escluso** |
| **#6 bis** | *«è solo un motore raro: 0 ci sta»* | 🟢 **Falsificata dall'aritmetica**: `GapFill` su EURUSD fa **5 trade in 8,5 mesi** (r36) ≈ **13,5% delle settimane**. Su TORO (52 settimane) l'attesa è **~7 trade**; `P(0) = 0,865^52 ≈ 5×10⁻⁴`. **Su 16 finestre è impossibile per caso.** 👉 c'è una causa sistematica, e §7 dice come isolarla in 2 passate | ⚠️ **causa RESIDUA aperta** |
| **#7 `OpeningReversalB`** | *«sono le soglie di punteggio a strozzare»* | 🟢 **Falsificata DENTRO il CSV**: abbassando `InpSignalScoreMin` da **4 → 2** l'OOS passa da `State1=16` a `State1=38` e da `State2=10` a `State2=21` — **più del doppio di candidati** — e **`Entry Trigger` resta 0**. Il punteggio non è la strozzatura: lo sono `PB Timeout` e `FT Timeout` | ✅ **causa tiene** |
| **#8 `BreakingBand`** | *«quei 24 simboli non hanno storico»* | 🟢 **Falsificata**: `GoldenCross` gira sugli **stessi 48 simboli** e fa **55-179 trade** su 46 di essi. E `BreakingBand` **non supera 8 trade su NESSUNO dei 48**. Non è il simbolo | ✅ **causa tiene** |
| **#9 `GoldenCross` XPD/XPT** | *«non hanno storico utile»* (è la riga del censimento) | 🔴 **Falsificata**: 26.619 e 26.734 barre H1 **dal 2015.03.29** (sonda), e `EMA200` su XPDUSD produce trade in **29 passate su 145**. 🔴 **Quindi la causa vera non è quella, e non la conosco**: §8 | ⚠️ **`[IPOTESI NON VERIFICATA]`** |
| **#10 `MaxMinNotte` EURUSD** | *«il motore non funziona fuori dagli indici»* | 🟢 **Falsificata**: su **XAUUSD** fa **59/92 trade** — e ci gira con `InpBufferPoints=250` (**2,50 USD**), cioè **scalato**. Su EURUSD ha girato col **1000 del DAX** = **100 pip**. Il discriminante è *esattamente* la scalatura | ✅ **causa tiene** |
| **#11 `GapFill` E35EUR** | *«è il modello: a tick reali tutti fanno meno operazioni»* | 🟢 **Falsificata**: 225JPY 26→**26**, EURUSD 14-15→**14-15**, SPXUSD 30→**30**, U30USD 30→**29-30**, UKOIL 26→**26**, USOIL 23→**23**, F40EUR 37→**31-35**, GBPUSD 10-12→**10-11**, AUDUSD 12-17→**11-17**. **Nove su dieci riproducono. Solo E35EUR fa 40 → 0.** | ✅ **causa tiene** |

---

# 5️⃣ 🏆 LA CLASSIFICA DEI RIPARABILI A COSTO PIÙ BASSO
### con l'**ATTESA DICHIARATA PRIMA DEI NUMERI** e la **SOGLIA CONGELATA**

> 🔴 **Regola di casa applicata qui**: tutte queste voci **allargano su MECCANISMI, SIMBOLI,
> TF, UNITÀ e GESTIONE** — mai sui parametri d'ingresso di un motore già dichiarato senza
> edge. E nessuna di esse promuove niente: portano un **numero che oggi non esiste**.

### 🥇 1 — `PostNews` · **6 min** · riscrivere un verdetto che oggi è falso
- **Attesa**: il conteggio dà **> 0 eventi utili**. Se desse **0**, la causa è ancora il
  file/canale e il motore resta `NON MISURATO` — **non diventa morto**.
- **Soglia congelata**: `N=0` o `CALENDARIO CIECO` nel log ⇒ **passata buttata**.
- 🔴 **Non può promuovere**: 12-16 eventi/anno, il pavimento dei 150 è irraggiungibile.
- **Costo ZERO in più**: riscrivere `REGISTRO_TEST.md` r.77 da *«nessun edge»* a **«NON
  ANCORA MISURATO — mancano PF, n, DD; causa dello zero: `FILE_COMMON` assente + calendario
  fuori finestra»** non costa un minuto di macchina.

### 🥈 2 — `GapFill` regime · **2 passate, 3 min** · il test che **discrimina da solo**
- **Cosa**: **una** cella con `InpGapMinATR = 0` (filtro spento) sulla finestra **TORO 2021**,
  EURUSD, tutto il resto identico al r50.
- **Attesa dichiarata PRIMA**, e il bello è che **i due esiti dicono cose diverse**:
  - 🟢 **escono operazioni** ⇒ la causa è il cancello `0,3 × ATR(D1)`: i gap 2019-22 c'erano
    ma erano **piccoli rispetto all'ATR**. La prova di regime va **rifatta con una soglia
    dichiarata per epoca**.
  - 🔴 **restano ZERO** ⇒ allora `ag <= 0.0` (`.mq5` **r.380-382**): il gap è **esattamente nullo
    ogni settimana** ⇒ **quello storico non ha discontinuità di weekend** ⇒ **artefatto di
    feed**, e la prova di regime su `GapFill` **non si può fare su quei dati**.
- **Soglia congelata**: nessun PF si legge da qui. **È un conteggio, non un giudizio.**

### 🥉 3 — `MaxMinNotte` EURUSD · **4 passate, 6 min** · un numero, non un motore
- **Cosa**: `InpBufferPoints` in asse — **50 · 100 · 200** punti (= 5 · 10 · 20 pip) invece
  del **1000 del DAX**.
- **Attesa**: **da 0-1 a 30-80 operazioni** per finestra. 🔴 **E un PF che esce alto su
  questa correzione va guardato con sospetto**, non con entusiasmo: si sta cambiando la
  geometria, non trovando un edge.
- **Soglia congelata**: sotto **30 operazioni OOS** il merito resta **sospeso** (criterio del
  08/08). Il **rischio** si legge comunque (Emendamento B).

### 4 — `Nightly` indici+oro · **8 passate, 12 min** · sei simboli tornano misurabili
- **Cosa**: `InpMaxNightVolPips` in asse **nell'unità giusta per simbolo**, oppure **0**
  (spento) per contare le occasioni.
- **Attesa**: su D30EUR/U30USD/XAUUSD il box notturno si rompe **~91% delle notti**
  (`NOTTE_ORO.md`, citato in `REGISTRO_TEST.md` r.498) ⇒ attesa **80-160 operazioni per
  finestra**, non zero.
- 🔴 **Soglia congelata, e viene PRIMA del PF**: `Nightly` è già **bocciato per RISCHIO** su
  `P0_EURCHF` (DD **11,10% IS / 15,39% OOS**). **Se il DD sui nuovi simboli supera 10% su una
  cella, si ferma lì** — la bocciatura per rischio non si rinegozia con un PF bello.

### 5 — `SupertrendInvert` · **8 passate, 12 min** · **l'ablazione che manca davvero**
- 🔴 **Il rilievo che vale il round**: i tre file prova esistenti (`G1PAOLO_10/11/12`)
  **non toccano né `InpRequireStrong` né `InpAdxRising`** — anzi il `_11` **stringe** ancora
  (`InpAdxMin` 20 → **25**). 👉 **Se si lanciassero domani così come sono, tornerebbero
  quasi certamente altri zero.** Serve **un file prova nuovo**, una variabile per file.
- **Attesa**: con `InpRequireStrong=0` mi aspetto di **avvicinarsi al fratello**
  `SupertrendReversal` (**mediana 93-114 trade**), cioè **n da 0-2 a diverse decine**.
  🔴 **E mi aspetto anche che il PF PEGGIORI**: i filtri tolti sono di qualità, non di rumore.
- **Soglia congelata**: se nessuna ablazione porta **n ≥ 150** con **PF ≥ 1,10** su entrambe
  le finestre, la risposta è **«il motore è troppo raro per il metro di casa»** — ed è un
  risultato, non un fallimento.

### 6 — `OpeningReversalB` · **8 passate, 12 min** · 🔴 **ma leggere §6.2 prima**
- **Cosa**: `InpPBMaxBars` (3 → 5 → 8) e `InpFTBarsWindow` (2 → 4), **una variabile per file**.
- **Attesa**: `State2` vale **10-21 per finestra**; se i timeout smettessero di mangiarli
  tutti, l'attesa massima teorica è **~10-20 operazioni per finestra**. 🔴 **Cioè: anche nel
  caso migliore resta DIECI VOLTE sotto il pavimento dei 150.**
- 🔴 **Soglia congelata, e la scrivo prima**: **da questo round non può uscire una sedia.**
  Serve solo a scrivere sul certificato che *«la gestione dell'uscita è stata messa ad asse»*
  — che oggi è **NO**, e che è uno dei cinque requisiti del certificato di morte (09/09).

### 7 — `GoldenCross` XPD/XPT · **2 passate, 3 min** · capire, non riprovare
- **Attesa**: il log dirà **dove si ferma**. 🔴 **Non mi aspetto una sedia**: mi aspetto di
  poter **chiudere onestamente** una casella che oggi è chiusa con una motivazione **falsa**.

---

# 6️⃣ 🪦 I MORTI STRUTTURALI — col motivo scritto

## 6.1 `ABTG_BreakingBand` sui 58 CSV di scan — **morto per RARITÀ, non per simbolo**
**La misura, tutta:**

| cartella | TF | file | a zero | **max trade su TUTTI i 48 simboli** |
|---|---|---:|---:|---:|
| `risultati_scan_…_H1` | H1 | 48 | 8 | 🔴 **8** |
| `risultati_scan_…_H4` | H4 | 48 | 24 | 🔴 **4** |
| `scan2/…_H4` | H4 | 48 | 16 | 🔴 **4** |
| `scan3bis/…_H4` | H4 | 48 | 10 | 🔴 **6** |

👉 **Su 21 mesi e 48 simboli, il pattern «bulge» non ha mai prodotto più di 8 operazioni.**
Il passaggio H4 → H1 (TF dimezzato **due volte**) raddoppia scarso il conteggio.

🔴 **La conseguenza, e cambia una proposta del censimento.** Il censimento propone
(§7 voce 5) il round **M30 su `BreakingBand`**: *6 passate, ≈ 9 min*. **Il round è giusto,
la motivazione no.** Attesa dichiarata **ora, prima dei numeri**, estrapolando dal salto
H4→H1 misurato: **~10-16 operazioni su 21 mesi.** 👉 Per arrivare a **150** servirebbero
**~20 anni** di storico a M30. **Quel round serve SOLO a spuntare la casella «TF cambiato»
del certificato di morte — non può produrre una sedia, e va scritto nel file prova.**

🟢 **E c'è un'informazione buona che nessuno aveva estratto**: quei 58 zeri **non dicono
niente sui simboli**. Il censimento li legge come *«screening su simboli dove il motore non
arma: è informazione»*. **È informazione sul TF, non sul simbolo** — e la differenza conta,
perché chiude una porta ("questo motore su H1/H4 non arriverà mai al campione") invece di
lasciarne aperte 24 fasulle ("proviamo altri simboli").

## 6.2 `ABTG_OpeningReversalB` — 🔴 **due muri, e il secondo non si sposta con un parametro**
Oltre alla frequenza (§5 voce 6), c'è un muro di **COSTO**, e lo scrivo col numero perché è
esattamente il difetto di unità che il brief chiede di cercare:

- nel CSV: **`InpMT5PerPuntoIndice = 100`** ⇒ **1 punto indice = 100 punti MT5** (coerente con
  `Digits=2, Point=0,01` **misurati** su `U30USD`);
- **`InpMinStopPts = 500`** ⇒ **5,00 punti indice** di stop minimo;
- **`InpMaxRiskIdxPts = 20`** ⇒ **20 punti indice** di rischio massimo per operazione;
- **frontiera misurata** (`STOP_VS_SPREAD_FTMO_2026-09-20.md` §8): `U30USD` ora **14**,
  spread mediano **2,00** ⇒ `40×` = **80,0 punti indice**; pavimento **duro** `13,3×` =
  **26,6**.

> 🔴 **Il tetto di rischio dell'EA (20) è sotto il pavimento DURO (26,6) e a 1/4 della
> frontiera di lavoro (80,0).** E lo spread **massimo misurato** su `U30USD` all'ora 14 è
> **47,00 punti indice**: più del doppio dell'intero stop consentito.

👉 **Verdetto onesto**: `OpeningReversalB` **come è configurato** è **ESCLUSO PER COSTO**
sugli indici USA — con il numero accanto, non "perché è M5". Riparare i timeout ne
aumenterebbe la frequenza **senza toccare questo muro**.
🟡 **Non lo dichiaro morto**: `InpMaxRiskIdxPts` **è un input**, e portarlo a 80-120 è una
riga. Ma **è un motore diverso** da quello misurato, e va detto prima, non dopo.

## 6.3 `R113_F1_02_short` — **non è un morto e non è un difetto: è un RISULTATO**
`SupertrendReversal` su NASUSD H1, finestra **ORSO 2022.01.01-2022.10.31**, lato **SHORT**
isolato (`InpAllowLong=0`): **0 operazioni**. Nella stessa finestra `F1_00_metro` = **7** e
`F1_01_long` = **7** ⇒ **tutte e sette le operazioni erano LONG**.
👉 **In un anno d'orso, il motore non ha trovato UN SOLO ingresso short.** È un fatto sul
motore, va nel suo certificato — e **non va contato fra i CSV "da riempire"**.

---

# 7️⃣ ⚠️ LA CAUSA RESIDUA — `GapFill` regime, ciò che **non** ho chiuso

**Cosa so, misurato:**
- il **dato c'è** (5 altri motori tradano in quelle finestre — §4);
- la configurazione è **la stessa** che funziona altrove: diff fra `r36` (EURUSD, 5 trade) e
  `GAP_EURUSD_TORO_r50` (0 trade) = **solo `InpMagic` e `InpFillPct`** — e `InpFillPct=50`
  **in r36 fa 5 trade lo stesso**. 👉 **Non è un parametro.**
- il conteggio atteso su TORO è **~7**, la probabilità di uno zero casuale è **~5×10⁻⁴**, e
  si ripete **16 volte**.

**Cosa NON so**: *perché* il gate `|gap| ≥ 0,3 × ATR(D1)` passi il **13,5% delle settimane**
nel 2024-26 e **~0%** nel 2019-22. Due spiegazioni, tutte e due plausibili, **nessuna delle
due verificata**:
- **(a) MERCATO** — gap genuinamente più piccoli rispetto all'ATR in quegli anni;
- **(b) FEED** — lo storico vecchio contiene la **barra H1 della domenica sera**, quindi
  `iOpen(TF,0)` (**r.342**) coincide di fatto con `iClose(TF,1)` e **il gap misurato è ~0**.

🟢 **Il test che le separa in 2 passate esiste ed è in §5 voce 2**, e l'EA stesso lo rende
decisivo: a **r.380-382** `if(ag<=0.0){ cW_zero++; … return; }` — **filtro spento + ancora zero
= il gap è nullo nel dato**. Non serve altro.

**Finché quel test non gira, la riga giusta in `REGISTRO_TEST.md` è: «prova di regime su
`GapFill`: NON AVVENUTA — 16 finestre su 16 a zero operazioni, causa non isolata».**

---

# 8️⃣ 🔴 NON COPERTO — dichiarato per nome, mai per differenza

| # | buco | perché non l'ho chiuso | come si chiude | costo |
|---|---|---|---|---|
| 1 | **`GapFill` regime: mercato o feed?** | serve una passata; io non ne lancio | la cella `InpGapMinATR=0` di §5.2 | 2 P ≈ 3 min |
| 2 | **`GoldenCross` XPDUSD/XPTUSD: perché 0 su 250 passate** | so solo che **non è "storico assente"** (l'ho falsificato). Il resto è `[NON VERIFICATO]` | una passata con `InpVerbose=1` e si legge dove si ferma | 2 P ≈ 3 min |
| 3 | 🔴 **Le PostNews sono o no sul terminale FTMO `541452707`?** | **contraddizione in repo**: `RINOMINA_CLAU12.ps1` r.143 riporta `MODO: SENZA POSTNEWS` dalla corsa vera; `CONTRATTI_DELLE_SEDIE_FTMO` le tratta da sedie; `FLOTTA_ATTIVA.md` r.54-55 ne elenca due sul demo | **una riga di SOLA LETTURA sul VPS** che stampa gli EA attaccati. 🔴 Non la scrivo e non la mando: fuori perimetro | minuti |
| 4 | **Le finestre esatte di 4 gruppi** (`SupertrendInvert`, `Nightly`, `OpeningReversalB`, scan `BreakingBand`) | il CSV **non porta la finestra**. Le ho dedotte dal referto del round di appartenenza (`REFERTO_WEEKEND_FASE0.md` r.7) e dai commit | leggere la riga di lancio di ciascun round | 0 |
| 5 | **Gli ATR(H1) veri** di D30EUR/U30USD/XAUUSD/XAGUSD | in repo non ho serie di prezzo. 🟢 **Ma la conclusione non ne ha bisogno**: la soglia reale è **0,45 punti indice** (aritmetica su `Digits` **misurati**), contro un **range d'apertura a 15′ misurato di 123,80 punti indice** su `U30USD` (`n=446`) — **275×**. I numeri ATR restano `[NON MISURATO]` | una sonda ATR | bassa |
| 6 | **Il fattore di sconto del costo salendo di TF** | a modello 4 il flusso di tick non cambia col TF | una corsa di taratura cronometrata M5 vs H1 | 1 corsa |
| 7 | **Se il difetto `MaxMinNotte`/`Nightly` è anche nei PRESET VIVI** | ho letto i **CSV** (cosa è girato), non tutti i `.set` in campo | incrociare `InpBufferPoints` / `InpMaxNightVolPips` nei `.set` di `mql5/Presets/` con il simbolo di ogni sedia | 0, ma non l'ho fatto |
| 8 | **I 3 CSV senza causa piena** | `GoldenCross` ×2 (#9) e `GapFill` tick E35EUR (#11, causa individuata ma non la sua **origine**) | voci 1-2 di questa tabella | — |
| 9 | 🕐 **`PostNews`: `InpActionHour=14` è l'ora giusta?** | il calendario è dichiarato **UTC**, BCM è **UTC+1** d'inverno ⇒ una BCE delle **13:45 UTC** cade alle **14:45 server**, *dopo* l'ora d'azione. **Non tocca la diagnosi dello zero** (§2.2), ma toccherebbe il round vero | leggere nel log della prima passata l'ora del piazzamento contro l'ora dell'evento — **e ricordare che i log MT5 sono in ora LOCALE del PC, il grafico in ora SERVER** | 0 |

---

# 9️⃣ 📌 LE TRE CLASSI DI DIFETTO — materiale per `CHECKLIST_RIGA_DI_LANCIO.md`

**Non sono tre casi: sono tre CLASSI**, e tutte e tre si vedono **prima** di lanciare.

| classe | come si riconosce **senza lanciare** | i casi di stanotte |
|---|---|---|
| 🔢 **Soglia in un'unità che cambia col simbolo** | un input con `Pips`/`Points` nel nome **pinnato uguale** su simboli con `Digits` diversi | `Nightly` `InpMaxNightVolPips=45` · `MaxMinNotte` `InpBufferPoints=1000` (**e il commento dell'EA dice "DAX"**) · `OpeningReversalB` `InpMinStopPts=500` |
| 🚪 **Cancello per NOME del simbolo** | una funzione che fa `StringFind(_Symbol,"…")` e blocca | `Nightly` r.133-137 + r.167 (JPY/AUD/NZD) |
| 🔗 **Congiunzione anti-correlata col trigger** | N `return` in fila dove una condizione contraddice il momento del segnale | `SupertrendInvert` r.207-211: **flip** + *close oltre EMA200* + *ADX in crescita* |

🟢 **Regola pratica che ne esce, e costa zero:** *prima di lanciare un round su un simbolo
NUOVO, si rileggono gli input con `Pips`/`Points`/`Pts` nel nome e si moltiplicano per il
`Point` di QUEL simbolo.* Stanotte questo controllo, fatto a mano in tre minuti, avrebbe
salvato **almeno 11 CSV e ~50 passate**.

---

## 🔟 📌 IN UNA RIGA

**Dei 113 CSV a zero, 110 hanno una causa provata e 3 restano aperti. Non è mai stato "il
motore non ha edge": è stato una soglia in pip su un indice, un cancello che rifiuta un
simbolo per come si chiama, e cinque filtri che chiedono a un'inversione di comportarsi come
un trend.** 🟢 Otto verdetti si riscrivono a **costo macchina ZERO**, cinque misure vere
costano **~43 passate ≈ 65 minuti**, e **nessuna di esse produce una sedia entro il 1
ottobre** — ma tutte impediscono che quelle caselle vengano archiviate come morti il giorno
in cui qualcuno farà pulizia.

*Documento di sola lettura. Nessun round lanciato, nessuna riga consegnata, nessun preset
toccato, nessuna sedia promossa o spenta.*
