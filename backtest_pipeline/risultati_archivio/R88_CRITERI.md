# ⚖️ R88 — CRITERI CONGELATI **PRIMA** DEI NUMERI — ✍️ FIRMATI

> ## ✅ FIRMATO DA CLAUDIO IN CHAT: **"FIRMO R88"** — 19/08/2026, ore ~18:05.
> Firma raccolta A NUMERI MAI VISTI (nessuna passata girata), dopo la
> presentazione in chat dei 4 cancelli numerici e del canarino sul muro dei
> tick (26/09/2024, n max 119 OOS -> selezione per MERITO sospesa, si legge
> per il RISCHIO). Regola confermata: *i criteri si cambiano prima dei
> numeri, non dopo* — se un numero uscito suggerisse un criterio migliore,
> quel criterio vale dal round dopo.

_Scritto il 19/08/2026, a numeri di R88 **mai visti** (nessuna passata girata)._

---

## 0. 🤝 LA PROMESSA DI ONESTA' — le celle sono state scelte PRIMA

Le tre celle di R88 non escono dai risultati di R88. Escono da un dossier
**gia' agli atti**, scritto e committato prima di questo file:

- `backtest_pipeline/caccia_strategie/biblioteca/schede/SPEC_ORB_CORSO_VS_R15_2026-08-19.md`
- commit **`ac37053`** — *"SPEC ORB: corso (2 PDF originali + indicatore V15) vs
  cella R15, con le 6 dimensioni inesplorate per R88"*

Chiunque, anche fra un anno, puo' verificare con `git show ac37053` che la
sezione C di quel dossier elencava **sei** dimensioni inesplorate e ne ordinava
tre come prioritarie — **prima** che una sola passata di R88 girasse.

E c'e' un secondo pezzo di onesta', scritto nel dossier stesso (sezione E) e che
qui si ripete perche' e' il vero test del round:

> **Se l'ORB avesse VINTO tre volte su tre invece di perderle, la cella 1
> sarebbe esattamente la stessa.** Nasce da R55 (difetto strutturale misurato),
> non dai tre stop del forward. Tre trade non sono un segnale.

---

## 1. 🎯 LA DOMANDA DEL ROUND, CELLA PER CELLA

Ogni cella ha **una** domanda. Se un risultato risponde a un'altra domanda, e'
materiale per un round futuro, non per questo.

| cella | file prova | LA DOMANDA | falsificazione |
|---|---|---|---|
| **R88a** 🥇 | `R88a_stoplargo_U30USD.txt` | **Allargare lo stop abbassa il drawdown senza uccidere il profit factor?** R55 ha nominato lo stop stretto come causa della fragilita'; questo e' l'unico asse che parla direttamente al muro prop. | Se ogni cella con stop piu' largo perde piu' PF di quanto guadagna in DD (cancello A qui sotto), la tesi di R55 **non si traduce in un parametro** e la sedia resta com'e'. |
| **R88b** 🥈 | `R88b_ricettacorso_U30USD.txt` | **La ricetta del corso (chiusura confermata + volume + EMA 9/21), mai provata sul Dow, aggiunge qualcosa al motore gia' tarato?** | Se nessuna delle 8 celle batte la base su entrambe le finestre, si conferma il precedente di casa: **filtro aggiunto DOPO a un motore tarato = 0 successi su 5** (R20, R12, R26, R45, R54). |
| **R88c** 🥉 | `R88c_geometria_U30USD.txt` (+ le due sorelle) | **La geometria dell'OR e l'orario di chiusura contano, a parita' di gestione?** | Nessuna: e' **diagnostica pura**. Vedi §6: da questa cella **non puo' uscire nessuna promozione**, qualunque numero faccia. |

### 1-bis. 🔢 Il conto delle passate, e le tre cose che vanno sapute PRIMA

| file | assi | passate/finestra | totale tick reali |
|---|---|---:|---:|
| `R88a_stoplargo_U30USD.txt` | SLMode(4) × Buffer(3) × TPMode(2) × TP_R(2) | **48** | 96 |
| `R88b_ricettacorso_U30USD.txt` | CloseConfirm(2) × Volume(2) × Ema9/21(2) | **8** | 16 |
| `R88c_geometria_U30USD.txt` + `R88c2_pre` + `R88c3_or30` | fine giornata(4) × 3 geometrie | **4 per file, 12 in tutto** | 24 |
| | | | **136** |

**Le tre cose, tutte lette nel sorgente o nello script, tutte dette prima:**

1. **`InpSLMode` è un ENUM: MT5 IGNORA lo step** e spazzola *tutti* i membri fra
   start e stop (sta scritto in `walkforward_generico.ps1`). Chiedendo 0 e 3
   escono **0, 1, 2, 3**: OPPRANGE, ATR, FIXED, HALFRANGE. Si tengono, perché
   rispondono alla stessa domanda (stop più largo = meno DD?) e R15 punto 3
   aveva già visto ATR+trailing+EMA200 a **OOS +3.221, PF 1,49, DD 8,4%**.
   Il `-SoloControllo` **deve** stampare 48 celle: se ne stampa 24, ci si ferma.
2. **In R88b, con `InpUseCloseConfirm=0` i filtri volume ed EMA 9/21 NON FANNO
   NIENTE.** `EmaSideOK` e `VolumeOK` sono chiamate **solo** da
   `TryCloseConfirmEntry` (v1.02, righe 457 e 459); `TryPlace` — il ramo dei
   pendenti STOP — chiama solo `Ema200SideOK`. Quindi 4 delle 8 passate sono
   **la stessa cella** e devono uscire identiche al centesimo (canarino gratis),
   e **la ricetta del corso non è separabile dalla chiusura confermata** senza
   toccare il codice. Se servisse, è un altro round.
3. **La geometria dell'OR non è spazzolabile in un file solo**: muove tre input
   insieme e la griglia è aritmetica per singolo input; il prodotto cartesiano
   genererebbe combinazioni invalide (fine 14:00 con inizio 14:30 → nel sorgente
   `tStart-=86400`, cioè un range lungo un giorno). Da qui le **tre file
   sorelle**, che differiscono **solo** per le 4 righe della geometria: si
   verifica con un `diff` prima di lanciare.

---

## 2. 🪟 LE FINESTRE — dimensionate sulle OPERAZIONI (Emendamento, regola A)

### 2.1 La finestra, e perche' e' quella

**Pin identico a R15/R16/R54b/R55**, citati per nome cosi' il confronto e' alla
pari e non c'e' niente da interpretare:

| voce | valore | fonte |
|---|---|---|
| simbolo / TF | **U30USD · M5** | `REFERTO_ROUND15_ORB_GESTIONE.md` |
| storico | **`@DAQUANDO 2024.09.26`** | `REFERTO_SONDA_STORICO_17-08.md`: U30USD **misurato** `2024.09.26`, stato `COMPLETO`. **Non e' una data prudente: e' il muro dei tick del broker.** |
| fine | `2026.06.30` (default `-Fino`) | `walkforward_generico.ps1` |
| split | **40/60** (`-FrazioneIS 0.40`, default) | idem |
| **IS** | **2024.09.26 → 2025.06.09** | stesso calcolo di `REFERTO_ROUND69_PTE_BUFFER_FAMIGLIA.md` (U30USD H1: *"IS 2024.09.26 → 2025.06.09 · OOS → 2026.06.30, ventuno mesi in tutto"*) |
| **OOS** | **2025.06.10 → 2026.06.30** | idem |
| deposito | **100.000** (`-Deposito 100000`) | come R54b e R55: e' l'unico modo di riprodurre la riga di sanita' al centesimo |

### 2.2 🐤 IL CANARINO, DETTO PRIMA DEI NUMERI

L'Emendamento della Finestra (regola A) chiede **>=150 operazioni** in campione
e altrettante fuori. **Qui non ci sono, e non ci possono essere:**

- R15 ha misurato la cella promossa: **IS n=71 · OOS n=119**. Totale 190.
- Non si allarga la finestra indietro: **2024.09.26 e' il muro dei tick di BCM
  su U30USD**, misurato dalla sonda del 17/08. Anche l'OHLC di R74 parte da li'.
- Non si sposta lo split: portare l'IS a 150 lascerebbe un OOS di ~40.

> ### 🔴 CONSEGUENZA, ACCETTATA IN ANTICIPO
> **La selezione di cella per il MERITO e' SOSPESA in tutto R88.**
> R88 si legge per il **RISCHIO** (regola B: *il drawdown e' un fatto accaduto,
> non una stima*) e come **diagnosi di direzione**. Da qui puo' uscire una
> **proposta motivata**, mai una promozione automatica.
>
> Chi legge R88 fra sei mesi deve trovare questa riga **prima** dei numeri, non
> dopo. E' scritta qui apposta.

### 2.3 Il REGIME contenuto — va scritto accanto a OGNI numero

Con `2024.09.26 → 2026.06.30` il regime e' **UNO SOLO**: Dow 2024-2026, fase
prevalentemente rialzista. Niente 2020, niente 2022, niente 2013.
R14 aveva gia' refertato **vento di regime long** su questa pista.

**Quindi**: R88 misura *l'effetto di un cambio di geometria del rischio dentro
un regime*, **non** la robustezza di regime. Quella e' la regola C
dell'Emendamento (quattro finestre toro/orso/laterale/crollo) ed e' un altro
round, che sul Dow **non e' nemmeno eseguibile a tick reali** con questo broker.

### 2.4 📏 La conversione delle unita' (misurata, non assunta)

> **Su U30USD a BCM: 100 punti MT5 = 1 punto indice.**

Fonte: `REFERTO_ROUND55_SLIPPAGE.md` — *"200 punti (2 punti indice sul Dow)"*,
*"150 punti, cioe' 1,5 punti indice"*, *"~445 punti (4,5 punti indice)"*; e
`prove/R55b_slippage_ORB.txt` riga 25: *"Su U30USD 100 punti = 1 punto indice"*.

⚠️ **Correzione di una premessa della missione R88**, che diceva *"1 punto
indice = 10 point MT5"*. **E' 100, non 10** — e la differenza e' un fattore
dieci sul valore dell'asse. Per questo l'asse `InpSLBufferPts` di R88a usa
**0 / 500 / 1000 punti MT5 = 0 / 5 / 10 punti indice**, che sono *esattamente*
i "5-10 punti" del ToolKit ABTG (§5.1). Con 50/100 punti MT5 si sarebbero
misurati mezzo punto e un punto indice: sotto lo spread, cioe' niente.

---

## 3. 🎚️ LA REGOLA DI SELEZIONE — centro dell'altopiano, MAI il picco

Non trattabile, e va **dichiarata insieme al numero** (in R70 il confronto si e'
ribaltato quando e' stato rifatto con la regola giusta):

1. Si guarda la **superficie**, non la riga migliore.
2. Una cella si puo' proporre **solo se le sue vicine dirette la accompagnano**:
   per **ogni** asse mosso di un passo, la vicina deve restare dentro
   **20% di PF** e **1,5 punti percentuali di DD** dalla cella centrale.
3. Una cella che sporge da sola e' **rumore**, anche se e' la piu' bella della
   tabella. Si scrive a referto come "picco isolato, non proposto".
4. Il **conteggio operazioni IS e OOS va scritto accanto a OGNI numero**.
   Un numero senza n non entra nel referto.

---

## 4. 🚪 I CANCELLI DI LETTURA — le soglie NUMERICHE, congelate

### 4.0 La riga di riferimento (la cella viva, gia' misurata)

| | Profit | PF | DD | n | fonte |
|---|---:|---:|---:|---:|---|
| **OOS** | **+41.057,00** | **1,6742** | **9,7623%** | **119** | R54b (14/08) e R55 slip 0 (15/08), identici al centesimo |
| **IS** | +867,42 | 1,223 | 8,63% | 71 | R15 (a deposito 10k: il PF e il DD si confrontano, il profitto no) |

> ⚠️ **Controllo di sanita' obbligatorio, prima di leggere qualunque altra
> riga**: la cella base di R88a (`InpSLMode=3, InpSLBufferPts=0, InpTPMode=1,
> InpTPRangeMult=1.5`) **deve** riprodurre l'OOS qui sopra al centesimo. Se non
> lo fa, l'input nuovo NON e' un no-op e **il round si ferma**: si cerca prima
> il perche'. E' lo stesso controllo che ha validato v1.01 in R55.

### 4.1 🟢 CANCELLO A — "vince sul RISCHIO" (l'obiettivo dichiarato di R88a)

Una cella vince sul rischio se, **in OOS**, verifica **tutte e quattro**:

| # | soglia | da dove esce il numero |
|---|---|---|
| **A1** | **DD <= 7,00%** | Non e' "meno del 10%": e' il livello a cui la sedia torna a **respirare**. R55 misura +0,45 punti di DD ogni 150 punti di slippage (9,7623 → 10,2086). Da 7,00% servirebbero **~1000 punti = 10 punti indice** per sfondare il muro, contro gli **1,5 di oggi**: tolleranza **~7 volte** maggiore. [INFERITO per estrapolazione lineare da R55, **non misurato**: il buffer cambia anche il lotto, quindi la pendenza vera va **riletta** con un R55-bis sulla cella eventualmente proposta.] |
| **A2** | **PF >= 1,40** | Il prezzo massimo accettabile per quel DD: **-16%** dal PF 1,6742 della cella viva. Regge anche il caso peggiore di R55 (200 punti di slippage costano -6,2% di PF: 1,40 → ~1,31) e resta **sopra il PF 1,10** che era il cancello di R15. |
| **A3** | **IS positivo: profit > 0 E PF IS >= 1,10** | E' **la trappola gia' vista**, non un'ipotesi: R15 punto 3 aveva OPPRANGE+trailing+EMA200 a **OOS +1.807, PF 1,68, DD 4,1%** e lo scarto' perche' *"li' l'IS e' rosso o piatto"*. Se R88a ritrova quella cella con l'IS ancora rosso, **A3 la boccia di nuovo** — e stavolta il no e' scritto prima. |
| **A4** | **n OOS >= 95** (= -20% dai 119) **e n IS >= 57** (= -20% dai 71) | Sotto, il DD di quella cella non e' un DD: e' un aneddoto. Vale soprattutto per R88b, dove la chiusura confermata **taglia i trade per costruzione**. |

### 4.2 🔵 CANCELLO B — "vince sul MERITO" (PF a DD pari)

**PF OOS >= 1,84** (= **+10%** su 1,6742) **con DD OOS <= 9,7623%** (non
peggiore della viva) **e** A3 **e** A4.

⚠️ Ma con **n < 150 in entrambe le finestre** (§2.2), il cancello B **non
promuove**: al massimo scrive a referto *"candidato per il merito, campione
insufficiente, verdetto rinviato al forward"*. **Regola B dell'Emendamento: il
recente giudica il merito, ma il campione sottile sospende il giudizio sul
merito, mai sul rischio** (valvola R59).

### 4.3 ⚫ CANCELLO C — quando una cella e' BOCCIATA e basta

Basta **una** di queste:
- **DD OOS > 9,7623%** — peggiora il rischio: fuori, comunque vada il PF.
  (E' il cancello che ha bocciato R44: TP 2x/3x, PF 1,955 ma DD 10,8-11,0%.)
- **PF OOS < 1,10** — sotto il cancello storico di R15.
- **IS negativo** (A3 fallito).
- **n OOS < 60** — meta' del campione attuale: non leggibile nemmeno per il
  rischio.

### 4.4 ⚪ CANCELLO D — il pareggio, che va dichiarato e non tirato

Se una cella sta **dentro il 5% di PF e dentro 0,5 punti di DD** dalla cella
viva, e' un **PAREGGIO**: si scrive "nessuna differenza misurabile" e **non si
cambia niente**. La cella in campo vince i pareggi per default: cambiare un
parametro vivo ha un costo (nuovo `.ex5`, nuovo forward, storia azzerata) che
un pareggio non paga.

---

## 5. ⚖️ REGOLA B DELL'EMENDAMENTO, APPLICATA A QUESTO ROUND

> **Il VECCHIO giudica il RISCHIO. Il RECENTE giudica il MERITO.**

Qui il "vecchio" **non esiste**: il muro dei tick e' il 2024.09.26 e c'e' un
regime solo. Quindi:

- ✅ **Il RISCHIO si giudica lo stesso**, e con la finestra che c'e': un
  drawdown del 2025 e' **un fatto accaduto**, non una stima. Il cancello A e'
  pienamente applicabile.
- ⛔ **Il MERITO resta sospeso**: campione sotto 150 in entrambe le finestre,
  **e** un regime solo. Nessuna cella di R88 puo' essere dichiarata "migliore"
  in senso pieno. Puo' essere dichiarata **"meno rischiosa a parita' di PF"**,
  che e' un'altra frase e vale meno.
- 📌 Corollario che va scritto nel referto: **se R88a trova una cella che passa
  A ma non B, la proposta e' "stessa strategia, rischio piu' basso", non
  "strategia migliore".** La differenza non e' semantica: cambia cosa si
  promette a Claudio.

---

## 6. 🛑 IL VINCOLO — R88 PROPONE, CLAUDIO DECIDE

1. **NESSUN DEPLOY AUTOMATICO.** Da R88 non esce nessun `.set`, nessun cambio a
   una sedia viva, nessun EA attaccato a un grafico. Esce **un referto con una
   proposta**, o nessuna proposta.
2. **La sedia ORB in campo NON si tocca** mentre R88 gira. Vale
   `report/ORB_100K_CRITERI.md` §3: nessuna decisione sul rendimento prima di
   **15 trade** (siamo a 3), e le uniche tre porte d'uscita anticipate sono di
   **rischio** (-2.000 € cumulati · una giornata peggio di -1,5% · DD della
   serie oltre il 12%). **Nessuna e' vicina.**
3. **R88c non promuove mai.** E' diagnostica: risponde a *"perche' funziona"*,
   non a *"cosa mettiamo in campo"*.
4. Se una proposta esce e Claudio la firma, **prima del campo** servono:
   (a) un **R55-bis** sulla cella nuova (la pendenza dello slippage cambia col
   lotto, §4.1); (b) il **contratto della sedia** aggiornato in
   `report/CONTRATTI_SEDIE.md` con DD e frequenza **promessi**, perche' e' su
   quelli che il criterio di uscita del 18/08 misurera' il forward;
   (c) **forward demo**, mai live da un backtest (ROTTA_PROP).
5. **Un solo cambio alla volta.** Se passano sia il buffer sia il TP in R, si
   propone **prima** quello che risponde alla domanda del round (il rischio), e
   l'altro diventa R89. Due cambi insieme = non si sa piu' chi ha spostato cosa.

---

## 7. 📋 COSA DEVE CONTENERE IL REFERTO DI R88 (checklist)

- [ ] La riga di **sanita'** (§4.0) riprodotta al centesimo, dichiarata.
- [ ] **n IS e n OOS accanto a OGNI numero**, senza eccezioni.
- [ ] Il **regime** dichiarato accanto a ogni tabella (§2.3).
- [ ] La **regola di selezione** dichiarata insieme alla cella scelta (§3).
- [ ] Le celle bocciate scritte per nome, col cancello che le ha bocciate.
- [ ] Le **ipotesi falsificate** dette per prime, non nascoste in fondo.
- [ ] Il **canarino** (§2.2) ripetuto nel referto: merito sospeso, n < 150.
- [ ] Distinzione esplicita **[MISURATO] / [INFERITO] / [DICHIARATO]**.
