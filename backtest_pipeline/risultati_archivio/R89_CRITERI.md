# ⚖️ R89 — CRITERI CONGELATI **PRIMA** DEI NUMERI — 📝 **FIRMATI**

> ## ✍️ FIRMA DI CLAUDIO: ______________________  data: ____/____/2026, ore ____
>
> **Finché questa riga è vuota, i CSV di R89 NON SI APRONO.** Sono nella
> cartella sigillata sul Desktop col suo `LEGGIMI_PRIMA`. *I criteri si
> cambiano PRIMA dei numeri, non dopo*: se un numero uscito suggerisse un
> criterio migliore, quel criterio vale **dal round dopo**.

> ### 🔒 DICHIARAZIONE DI CIECO — obbligatoria, e vera
> Scritto il **19/08/2026, in tarda serata (ore ~23:20 italiane = ~22:20 ora
> server BCM)**, mentre le passate di R89 giravano o erano in coda. **Chi
> scrive NON ha visto un solo numero di R89**: nessun CSV, nessun aggregato,
> nessuna riga `[LIQSWEEP][CONTEGGIO]`. Le cifre qui dentro vengono da round
> già refertati (R42, R45, R84, R15, METRO_PROP) e dal **dossier di caccia
> committato prima della corsa**, tutti citati per nome.

_Nota di collocazione: il TODO nei file prova rimanda a `prove\R89_CRITERI.md`.
**Il file è QUESTO**, in `risultati_archivio/` accanto a `R88_CRITERI.md`._

---

## 0. 🤝 LA PROMESSA DI ONESTÀ — il candidato è stato scelto PRIMA

Il motore di R89 **non esce dai risultati di R89**. Esce da un dossier già agli
atti, scritto e committato prima di questo file:

- `backtest_pipeline/caccia_strategie/CACCIA_LONDRA_MECCANISMI_2026-08-19.md`

E in quel dossier è già scritta, **prima di qualunque numero**, la frase che è
il vero test di questo round (§9, testuale):

> *"Se il verdetto del gradino A fosse negativo, la conclusione corretta NON
> sarà 'cerchiamo un altro EA di Londra': sarà che l'apertura di Londra, per
> come il mercato la tratta oggi, non è un evento su cui abbiamo un edge — e
> che il tempo va speso sui buchi veri del portafoglio (short, laterale,
> crollo) invece che su una sessione che ci ha già detto di no in cinque modi
> diversi."*

**Attribuzione, come da regola di casa:** il motore è ripreso da *"Liquidity
Sweep H4 - M15 (Swing Highs and Lows)"* di **OsmarSandovalEspinosa**, MQL5 Code
Base 68951 (2026.03.23). La citazione va ripetuta in testa a qualunque `.mq5`
derivato — ed è già nell'header di `ABTG_LiquiditySweep.mq5`.

### 0-bis. 📕 La lista dei caduti — è il metro, e va letta prima

| caduto | verdetto misurato |
|---|---|
| **Londra_ORB** (O4) | OHLC **11% celle positive**, DD **23%** → 🔴 morto |
| **R45 — ORB di sessione Londra** | **0 celle positive su 48** (GBPUSD/EURUSD/XAUUSD, 149-408 trade/cella) |
| **R42 — FADE degli estremi del range** | **0/24 IS e 0/24 OOS**, PF sempre fra **0,50 e 0,93**, campioni 195-333/cella. Diagnosi: *"è morto il MOTORE, non la gestione"* |
| **capitolo BREAKOUT M5 in apertura** | **CHIUSO il 26.07.26** su tick reali: *"non costruire altri v2 M5"* |

👉 **R89 non è "lo stesso motore con altri pip".** Le due frasi che l'hanno
generato sono citate nei referti: R42 — *"l'unica cosa che ha sempre pagato è
il RETEST"*; R45 — *"il box paga sul RANGE DELLA NOTTE (ore di accumulo), non
sul quarto d'ora dell'apertura"*. Qui il livello è costruito in **~3,5 giorni**
(swing H4 a 21 barre per lato) e l'ingresso è sul **RIENTRO**, non sul tocco.

---

## 1. 🎯 LA DOMANDA DEL ROUND, CELLA PER CELLA

> **La domanda, testuale dal dossier §8:**
> *"Il RIENTRO dopo lo sweep — cioè la famiglia RETEST che R42 indica come
> l'unica che ha sempre pagato — ha un edge su un livello costruito in GIORNI,
> dopo che lo stesso rientro sull'estremo del box di 15 minuti è stato bocciato
> 48 celle su 48?"*

| cella | file prova | LA DOMANDA | falsificazione |
|---|---|---|---|
| **R89a** 🧭 | `R89a_liqsweep_GBPUSD.txt` | **Il motore NUDO, senza nessun orario.** Sweep + reclaim su chiusura M15 di un livello swing H4 (21 barre/lato), livello consumato dopo l'uso. È la **BASELINE**. | Se il motore nudo non passa i cancelli §5, **anche la scala H4 è chiusa** e il verbale dirà che il retest paga sui **nostri** livelli (apertura DAX/Dow) e **non in generale** — informazione che oggi non abbiamo. |
| **R89b** 🕰️ | `R89b_liqsweep_londra_GBPUSD.txt` | **La finestra di Londra aggiunge?** Griglia 3 (ora d'inizio) × 3 (durata) = **9 passate**. | Se solo una cella oraria sporge e le altre no, la lettura corretta è **"l'orario non è il motore"**, non *"ho trovato l'ora giusta"* — frase già scritta nel file prova. |

### 1-bis. 🔢 Il conto delle passate

| | passate/finestra | finestre | **totale a tick reali** |
|---|---:|---:|---:|
| **R89a** (2 magic gemelli, 772603/772604) | 2 | 2 | **4** |
| **R89b** (3 × 3 = 9, magic pinnato 772605) | 9 | 2 | **18** |
| | | | **22** |

**Tre cose da sapere PRIMA:**

1. 🔴 **L'ORDINE È VINCOLANTE: A prima di B, e B NON SI LEGGE senza A.** Non è
   burocrazia: è la condizione perché il numero significhi qualcosa. Se si
   misurasse già filtrato per Londra e andasse male, non si saprebbe se è morto
   il **MOTORE** o l'**ORARIO** — ed è l'errore che il §5B del dossier ha
   misurato **0 successi su 5** (R20 ADX, R12, R26, R45, R54: filtro appiccicato
   a un motore già tarato).
2. **R89a ha i gemelli** (magic 772603/772604): devono uscire **identici al
   centesimo**. **R89b NON li ha** (magic pinnato: raddoppierebbe a 18 passate
   per finestra) — e va **dichiarato** nel referto.
3. **La riga `[LIQSWEEP][CONTEGGIO]` esce SEMPRE**, anche con `InpVerbose=0`
   (verificato nel sorgente, riga 465). **Si legge PRIMA del conto economico.**
   È il canarino, §3.

---

## 2. 🪟 LE FINESTRE — Emendamento, regola A

### 2.0 🚧 PASSO 0 — prima di tutto

`@DAQUANDO 2024.07.05` è **la data che il referto del 15/08 attribuisce ai TICK
di GBPUSD** — l'unico simbolo del repo per cui una riga `TICK` sia mai stata
prodotta. Va comunque **riverificata** con `scarica_storico.ps1 -Simboli
"GBPUSD" -SoloReferto` prima di leggere i numeri.

> 🔴 Se i tick partono **dopo** il 2024.07.05 → i numeri non si leggono, la
> finestra si riscrive, il round si rilancia (difetto n.18 della checklist:
> *"sugli indici il driver diceva 2024.01.01 e i dati partivano dal
> 26/09/2024"* — si è già ripetuto). Se i tick non ci sono, si gira a **modello
> 1 (OHLC M1)** e ogni numero porta scritto **"OHLC, non tick"**.

### 2.1 La finestra dichiarata (provvisoria fino al PASSO 0)

| voce | valore |
|---|---|
| simbolo / TF | **GBPUSD · M15** (struttura su **H4**, `InpTF_Struttura=16388`) |
| storico | **`@DAQUANDO 2024.07.05`** — identico nelle due celle, o non si confrontano |
| fine | `2026.06.30` |
| split | **40/60** |
| **IS** | **2024.07.05 → 2025.04.21** — **[CALCOLO]**: 40% di 725 giorni = 290 |
| **OOS** | **2025.04.22 → 2026.06.30** — **[CALCOLO]** |
| rischio | **1,00% pinnato** (la taglia di campo è 0,65%) |
| modello | **4 = tick reali**, se il PASSO 0 lo consente |

⚠️ Le date IS/OOS sono **calcolate, non lette**: vanno **verificate sulle
anteprime `.ini` del PASSO 2** e sulla prima/ultima riga del per-trade, come in
R84. Se il driver spezza diversamente, **vale il driver**.

### 2.2 Il REGIME contenuto — accanto a OGNI numero

**UNO E MEZZO** (GBPUSD 2024-2026). Niente 2020, niente 2022, niente 2013.
**R89 confronta il motore con e senza sessione: NON dichiara robustezza.**
La prova di regime (toro/orso/laterale/crollo) è la regola C dell'Emendamento
ed è un round a parte.

### 2.3 ⚠️ Il limite del motore, detto anche se non piace

**È un motore CONTROTENDENZA su livello**: è il tipo che **incassa una serie di
stop in un trend forte**. La colonna *Peggior Giornata %* del CSV c'è apposta:
**si misura, non si stima**. Il criterio di uscita delle sedie (18/08) giudica
il **RISCHIO sempre, a qualunque `n`** — e qui è il rischio la cosa che va
guardata per prima dopo la frequenza.

---

## 3. 🐤 IL CANARINO DI FREQUENZA — **si legge PRIMA del conto economico**

Il dossier avvisa, testualmente: *"con `Range=21` su H4 i livelli sono pochi,
quindi il campione potrebbe non arrivare ai 150 trade IS richiesti"*. E nella
cella B **morde il doppio**: la finestra oraria taglia i segnali, e ristretto a
4 ore al giorno il campione può scendere a un terzo.

**Si legge la riga `[LIQSWEEP][CONTEGGIO]`** (livelli creati / consumati da uno
sweep / invalidati da una rottura / segnali scartati dai filtri) e si scrive
**nel referto, prima di qualunque PF**:

| esito del canarino (in **IS**, cella A) | conseguenza congelata |
|---|---|
| **n trade IS ≥ 150** | 🟢 il **MERITO** si legge (resta comunque §6: R89 non promuove) |
| **30 ≤ n trade IS < 150** | 🟠 **MERITO SOSPESO** (valvola R59). Si legge il **RISCHIO** e si scrive che la finestra va allargata indietro. **Atteso: è questo lo scenario probabile.** |
| **n trade IS < 30** *oppure* **livelli creati IS < 30** | 🔴 **ROUND NON MISURABILE.** E la conclusione **non è sull'edge**: è che **`InpSwingBars=21` su H4 è troppo raro su questa finestra**. Abbassare `InpSwingBars` è un **ALTRO round** (lo dice il file prova), **non** una taratura di questo. |

> 📌 **Perché 30 e non un altro numero:** è la stessa soglia di leggibilità
> congelata in `R84_ABLAZIONE_CRITERI.md` §3.3 (valvola R59). Non è tarata
> stanotte su R89.

**Il conteggio dei livelli va scritto accanto ai trade**: se i livelli creati
sono tanti e i consumati pochissimi, il problema è il **grilletto**; se sono
pochi i livelli, il problema è la **definizione dello swing**. Sono due
diagnosi diverse e il CSV le distingue gratis.

---

## 4. 🎚️ LA REGOLA DI SELEZIONE — centro dell'altopiano, MAI il picco

Non trattabile. Il file prova la cita col suo motivo misurato: **12 correlazioni
di Spearman IS→OOS negative su 13** — *il picco IS non regge*.

1. Si guarda la **superficie** delle 9 passate di R89b, non la riga migliore.
2. **Vicino** = una cella ottenuta muovendo **un solo asse di un solo passo**
   (ora ±1, oppure durata ±2 ore).
3. Una cella si può nominare **centro di altopiano** solo se **TUTTE** le sue
   vicine dirette restano dentro **20% di PF** e **1,5 punti percentuali di DD**
   da lei (soglia identica a `R88_CRITERI.md` §3).
4. Una cella che sporge da sola è **rumore**: si scrive *"picco isolato, non
   proposto"*.
5. **`n` IS e `n` OOS accanto a OGNI numero.** Etichette
   **[MISURATO] / [INFERITO] / [DICHIARATO]** su ogni riga.

---

## 5. 🚪 I CANCELLI DI LETTURA — le soglie NUMERICHE, congelate

### 5.0 🧪 Sanità, prima di tutto

1. **Gemelli identici** in R89a (772603 vs 772604): se divergono, **il round si
   ferma** (checklist punto 5). **R89b è senza gemelli**, dichiarato.
2. **AUTOTEST letto UNA VOLTA in un test singolo, prima del round**
   (`InpAutoTest` è pinnato a 0 nella griglia apposta).
3. **`InpTF_Struttura=16388` = PERIOD_H4**: il file prova chiede di
   **verificare** che lo script passi il numero e non il nome dell'enum. Se
   passasse il nome, la passata girerebbe su un altro timeframe di struttura e
   **tutto il round misurerebbe un'altra cosa**. Da confermare nel referto.
4. **Il commit sulla punta di `lavoro` all'ora della corsa va dichiarato**: il
   driver ignora il `-Rif` (`$EABranch="lavoro"` scritto fisso) e gira l'EA che
   sta sulla punta ADESSO.
5. **`diff` fra i due file prova**: devono differire **solo** per le righe della
   finestra di sessione e il magic. *(Verificato in preparazione: differiscono
   per `InpUseSessionWindow`, i due assi orari e il magic — più i commenti.)*

### 5.1 🟢 CANCELLO A — la cella NUDA "PASSA" (= permesso di proseguire)

Una cella A che passa **non è una promozione**: è il permesso di leggere B e di
proporre un walk-forward vero. Servono **tutte e cinque**:

| # | soglia | da dove esce il numero |
|---|---|---|
| **A1** | **PF OOS ≥ 1,20** | Il cancello storico di casa è **PF 1,10** (R15, citato in `R88_CRITERI.md` §4.1). Qui si alza di **+0,10** — che è **il margine di rumore già congelato in R84** §5 punto 3 — perché R89 è un **candidato NUOVO** che chiede di **riaprire un capitolo chiuso** da 48 celle su 48 (R45) e 0/24+0/24 (R42). **Riaprire costa più che confermare.** |
| **A2** | **PF IS > 1,00** e **segno del profitto coerente fra le due metà** | È la lezione USDJPY di R20: *"IS rosso ovunque + OOS verde ovunque è la configurazione PIÙ pericolosa: senza criteri congelati la si promuove ('guarda l'out-of-sample!') e si deploya un pattern che nella finestra di scelta non esisteva"*. |
| **A3** | **DD OOS ≤ 15,0%** | Muro prop **10% di DD totale** (`report/METRO_PROP.md` §1-bis); passate a **1,00%** di rischio contro taglia di campo **0,65%**: 10% ÷ 1,538 = **15,4%**, arrotondato in basso. ⚠️ **[INFERITO per scalatura lineare del rischio, NON misurato]**: il DD non scala esattamente col lotto → R55-bis obbligatorio su qualunque cella proposta. |
| **A4** | **Peggior Giornata % non peggiore di −7,5%** | Muro prop giornaliero **5%**, stessa scalatura: 5% ÷ 1,538 = 7,7% → **7,5%**. Stesso [INFERITO]. **Qui è il cancello che conta di più**: è un motore controtendenza, e la serie di stop in un trend forte è il suo modo di morire. |
| **A5** | **n totale (IS+OOS) ≥ 60** | Metà del minimo dell'Emendamento su una finestra sola. Sotto, il DD non è un DD: è un aneddoto. E sotto 30 in IS vale il canarino §3 (round non misurabile). |

### 5.2 ⚫ CANCELLO B — quando la cella A è BOCCIATA

Basta **una**:
- **PF OOS < 1,10** — sotto il cancello storico di casa;
- **IS negativo** (A2 fallito);
- **DD OOS > 15,0%** oppure **Peggior Giornata peggiore di −7,5%** → bocciata
  **per RISCHIO**, qualunque sia il PF, e **il giudizio di rischio non si
  sospende mai** (regola B dell'Emendamento);
- **n IS < 30** → non è una bocciatura, è **"non misurabile"** (§3).

### 5.3 🕰️ CANCELLO C — LA FINESTRA DI LONDRA (cella B)

> ### 🔴 LA REGOLA CHE IL DOSSIER CHIEDE, RESA NUMERICA
> **"La finestra si tiene SOLO se migliora l'INSIEME delle 9 passate rispetto
> alla cella A, NON la passata migliore."**
> Una finestra che aggiusta un'ora e ne rovina tre è **curve fitting
> sull'orologio**, ed è il modo più facile di pescare.

Servono **tutte e tre**:

| # | soglia |
|---|---|
| **C1** | la **MEDIANA** del PF OOS delle **9** passate ≥ **PF OOS della cella A + 0,10** |
| **C2** | **almeno 6 passate su 9** hanno PF OOS **superiore** a quello della cella A (maggioranza netta: 5/9 è un pareggio travestito) |
| **C3** | esiste un **centro di altopiano** secondo §4 punto 3 (tutte le vicine dirette dentro 20% di PF e 1,5 pp di DD) |

**Esiti congelati:**

| esito | condizione | cosa si scrive |
|---|---|---|
| 🟢 **la finestra aggiunge** | C1 + C2 + C3 | *"la sessione migliora l'insieme"*. **Non è una promozione** (§6): è un elemento per un walk-forward vero. |
| 🟠 **una o due passate sporgono, le altre no** | C2 fallito | **"L'ORARIO NON È IL MOTORE."** Frase già scritta nel file prova, e si scrive quella. |
| ⚪ **pareggio** | dentro il 5% di PF e 0,5 pp di DD dalla cella A | *"nessuna differenza misurabile"*: **la finestra resta spenta.** Il default spento vince i pareggi. |
| 🔴 **la finestra peggiora** | mediana sotto A | si scrive, ed è **la sesta conferma** del §5B del dossier (filtro appiccicato a un motore = 0 successi su 5, che diventano 0 su 6). |

### 5.4 🔗 IL VINCOLO DI LETTURA A→B

| stato della cella A | la cella B si legge? |
|---|---|
| **A passa** (§5.1) | ✅ sì, con tutti e tre i criteri C1-C3 |
| **A bocciata sul MERITO** ma canarino OK | 🟠 **solo come DIAGNOSI** (*l'orario cambia qualcosa?*), e **non può produrre nessuna proposta**. Il precedente 0/5 vale: non si cerca un orario che salvi un motore morto. |
| **A bocciata sul RISCHIO** (A3 o A4) | ⛔ **B non si legge affatto.** |
| **canarino sotto 30 trade IS** | ⛔ **B non si legge affatto** (con la finestra oraria il campione è ancora più piccolo). |

### 5.5 🕐 L'ORA — l'ambiguità documentata, e come si scrive

**I nostri stessi file danno TRE valori diversi per Londra. Non ne inventiamo
uno**: si spazzola l'asse, e si dichiara che è la risposta onesta a
un'ambiguità documentata.

| `InpSessStartHour` | ora **server BCM** | ora **italiana** (= server + 1) | da dove viene |
|---:|---|---|---|
| **6** | 06:00 | 07:00 | `REGISTRO_TEST.md` (Londra_ORB): *"range 06-07 server"* |
| **7** | 07:00 | 08:00 | `REFERTO_ROUND45_LONDRA.md`: *"range 07:00 → 07:15/07:30 server"* |
| **8** | 08:00 | 09:00 | **regola di casa** (server BCM = ora italiana − 1): Londra apre 08:00 UK = 09:00 IT = **08:00 server** |

| `InpSessEndHour` | ora server | ora italiana | durata dalle 6 / 7 / 8 |
|---:|---|---|---|
| **10** | 10:00 | 11:00 | 4 / 3 / 2 ore |
| **12** | 12:00 | 13:00 | 6 / 5 / 4 ore |
| **14** | 14:00 | 15:00 | 8 / 7 / 6 ore |

**Due regole di scrittura, congelate:**
1. **Ogni ora citata nel referto va scritta in DUE fusi**: ora server BCM **e**
   ora italiana, sempre, con il fuso d'origine dichiarato.
2. La finestra è **[inizio, fine)**: la barra M15 che apre all'ora di fine è
   **già fuori**. Con 8:00-12:00 l'ultima barra utile è quella che apre alle
   **11:45**.

> ⚠️ **TODO PRIMA DI CHIUDERE IL REFERTO (30 secondi):** guardare
> **l'orologio del server** e fissare il numero vero. Promemoria dell'errore del
> 06/08: le schede **Esperti e Giornale** di MT5 stampano in **ora locale del
> PC**, il **grafico e `TimeCurrent()`** in **ora server**. Chi confronta le due
> cose annuncia ritardi che non esistono — è successo, ed è costato una
> diagnosi sbagliata.
> **Se l'ora vera risulta essere una sola, le altre due colonne dell'asse
> restano nel referto come misura di sensibilità, non si cancellano.**

---

## 6. 🛑 IL VINCOLO — R89 PROPONE, CLAUDIO DECIDE

1. **`ABTG_LiquiditySweep` NON È UNA SEDIA.** È un **candidato**, mai girato.
   **Nessun forward, nessun VPS, nessun `.set`, nessun magic in campo** finché
   non passa un round a tick reali **e poi** il demo.
2. **Il massimo che R89 può produrre è "il permesso di fare un walk-forward
   vero"** — così sta scritto nei file prova, e resta.
3. **Nessuna sedia viva si tocca mentre R89 gira.**
4. **Un solo cambio alla volta**: se A passasse e B pure, si propone **prima**
   la cosa che risponde alla domanda del round.
5. Se una proposta esce e Claudio la firma, **prima del campo** servono:
   (a) **prova di regime** (regola C); (b) **R55-bis** su slippage/spread —
   qui pesa doppio, perché lo SL è **strutturale** e la sua ampiezza cambia da
   trade a trade; (c) **contratto della sedia** in `report/CONTRATTI_SEDIE.md`
   con DD e frequenza **promessi**; (d) **forward demo**, mai live.
6. **Il magic 772600** resta riservato all'eventuale sedia; 772601/772602 sono
   già bruciati in R54. Le passate usano **772603/772604** (cella A) e
   **772605** (cella B).

### 6-bis. 🔁 LA CLAUSOLA DELLA SECONDA CACCIA — e il suo LIMITE, dichiarato

Se il motore nudo esce **senza edge**, la **REGOLA DELLA SECONDA CACCIA**
(19/08) dice che gli agenti ripartono da soli a cercare **meccanismi
alternativi sulla stessa inefficienza**, mai *"parametri diversi dello stesso
motore morto"*.

> 🔴 **Ma qui il dossier ha già scritto il limite, e vale più della regola
> generica:** la seconda caccia **NON sarà "un altro EA di Londra"**. Sarebbe il
> settimo giro sulla stessa sessione. Se R89a boccia, **il tempo va sui buchi
> veri del portafoglio: short, laterale, crollo.** Questa riga è congelata
> adesso proprio perché domani sarà quella che si vorrà riscrivere.

---

## 7. 🕳️ COSA R89 **NON** PUÒ MISURARE — dichiarato prima

| ❌ non misurabile in R89 | perché | dove va |
|---|---|---|
| **Il "gradino B pieno" del dossier** (tempo **costitutivo**: livello = estremo del range notturno asiatico, grilletto = rientro dentro Londra) | è un **MOTORE DIVERSO** e un EA diverso. La cella B qui è ancora un **FILTRO** applicato al motore | EA a parte, **solo se** questa cella dice qualcosa |
| **Lo SL in modo 1 (ATR puro)** | l'ATR è quello di M15: 1,5×ATR(M15) è uno stop **piccolo** rispetto allo sweep di un livello H4 → i due modi **non sono gemelli** e non si confrontano a cuor leggero | altro round |
| **L'ablazione del BREAKEVEN** (`InpBreakeven=0`) | nella cella "nuda" il breakeven è **acceso**: è una scelta di gestione dichiarata (lezione PTE 04/08), non un default dimenticato | cella C di un round successivo, da dichiarare **prima** |
| **`InpSwingBars` diverso da 21** | è il parametro che decide la frequenza. Cambiarlo qui confonderebbe "quanti livelli" con "quanto valgono" | round successivo, **e solo se** il canarino dice che 21 è troppo raro |
| **Altri simboli** | R89 gira **solo GBPUSD**. La famiglia caduta era stata misurata anche su EURUSD e XAUUSD (R45): qui no | coda |
| **Il TP e il parziale** | `InpTP_RR=2.0` fisso, parziale spento (`InpTP1Pct=0`): la gestione è la domanda di un altro round | coda |
| **La robustezza di regime** | un regime e mezzo | regola C dell'Emendamento |
| **Lo SLIPPAGE e lo SPREAD** | `InpMaxSpread=0`; e con SL strutturale la sensibilità è **diversa** da quella misurata in R55 su SL fisso | R55-bis, obbligatorio se esce una proposta |
| **Il GUARDIAN** | acceso come in campo ma **INERTE nel tester** (le GlobalVariable non esistono): fail-open totale | collaudo Guardian |
| **Il filtro NEWS** | spento: è un filtro, e i filtri sono la domanda del round | coda |
| **Il tetto giornaliero** | `InpMaxTradesPerDay=0`: i tetti sono **filtri travestiti** | coda |

---

## 8. 📋 CHECKLIST DEL REFERTO DI R89

- [ ] **PASSO 0** dichiarato (tick GBPUSD: misurato / non misurato / OHLC).
- [ ] Il **commit sulla punta di `lavoro` all'ora della corsa**, dichiarato.
- [ ] **`InpTF_Struttura` = H4 verificato** (numero vs nome dell'enum), §5.0.3.
- [ ] La riga **`[LIQSWEEP][CONTEGGIO]`** riportata **PRIMA** del conto
      economico, per ogni passata: livelli creati / consumati / invalidati /
      segnali scartati.
- [ ] Il **canarino** (§3) con il suo verdetto scritto per esteso.
- [ ] Date **IS/OOS verificate** sulle anteprime `.ini`, non calcolate.
- [ ] **Gemelli identici** in R89a; **R89b senza gemelli**, dichiarato.
- [ ] **n IS e n OOS accanto a OGNI numero**, senza eccezioni.
- [ ] **Peggior Giornata %** riportata per **ogni** cella (§5.1 A4).
- [ ] Ogni ora scritta in **DUE fusi** (server BCM + italiana), §5.5.
- [ ] Il **vincolo A→B** (§5.4) dichiarato prima di qualunque numero di B.
- [ ] Il **regime** dichiarato accanto a ogni tabella.
- [ ] La **regola di selezione** dichiarata insieme a ogni cella nominata.
- [ ] Etichette **[MISURATO] / [INFERITO] / [DICHIARATO]** su ogni riga.
- [ ] Le **ipotesi falsificate** dette per prime, non nascoste in fondo.
- [ ] **Attribuzione** a OsmarSandovalEspinosa (MQL5 Code Base 68951) ripetuta.

---

## 9. 📎 TRACCIABILITÀ

- **File prova**: `prove/R89a_liqsweep_GBPUSD.txt` ·
  `prove/R89b_liqsweep_londra_GBPUSD.txt`
- **Sorgente**: `mql5/Experts/ABTG_LiquiditySweep.mq5` (1.137 righe; il bug di
  overflow dell'originale — `SwingHighs[100]` senza controllo di limite — è
  **corretto nel nostro porting**: tetto `InpMaxLivelli=200` e ogni accesso via
  `ArraySize()`, verificato alle righe 61-63, 143, 364-376)
- **Dossier che lo ha promosso**:
  `caccia_strategie/CACCIA_LONDRA_MECCANISMI_2026-08-19.md` (§0 caduti, §2
  meccanismo e differenze, §5F cosa tenere/cosa rifare, §8 la domanda, §9
  l'onestà finale)
- **Precedenti citati**: `REFERTO_ROUND42_FADE.md` (0/24+0/24; *"è morto il
  MOTORE"*; *"l'unica cosa che ha sempre pagato è il RETEST"*) ·
  `REFERTO_ROUND45_LONDRA.md` (0/48; *"il box paga sul RANGE DELLA NOTTE"*) ·
  `REGISTRO_TEST.md` (Londra_ORB 11%, DD 23%; capitolo M5 chiuso) ·
  `REFERTO_ROUND20_GOLDENCROSS_FOREX.md` (lezione IS rosso / OOS verde) ·
  `REFERTO_ROUND15_ORB_GESTIONE.md` (cancello PF 1,10) ·
  `R84_ABLAZIONE_CRITERI.md` (valvola 30 op; margine di rumore ±0,10) ·
  `report/METRO_PROP.md` (muri prop 10% / 5%)
- **Regole di casa**: EMENDAMENTO DELLA FINESTRA (A/B/C/D) · valvola R59 ·
  REGOLA DELLA SECONDA CACCIA (19/08) · FUSO BCM (ora IT − 1) · ora dei LOG ≠
  ora del GRAFICO (06/08) · CHECKLIST_RIGA_DI_LANCIO punti 5, 13, 14, 18, 19
