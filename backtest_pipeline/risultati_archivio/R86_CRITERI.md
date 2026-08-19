# ⚖️ R86 — CRITERI CONGELATI **PRIMA** DEI NUMERI — 📝 **BOZZA DA FIRMARE**

> ## ✍️ FIRMA DI CLAUDIO: ______________________  data: ____/____/2026, ore ____
>
> **Finché questa riga è vuota, i CSV di R86 NON SI APRONO.** Sono nella
> cartella sigillata sul Desktop con il suo `LEGGIMI_PRIMA`. La regola di casa
> è una sola e non è negoziabile: *i criteri si cambiano PRIMA dei numeri, non
> dopo*. Se un numero uscito suggerisse un criterio migliore, quel criterio
> vale **dal round dopo**.

> ### 🔒 DICHIARAZIONE DI CIECO — obbligatoria, e vera
> Questo file è stato scritto il **19/08/2026, in tarda serata (ore ~23:20
> italiane = ~22:20 ora server BCM)**, mentre le passate di R86 giravano o
> erano in coda. **Chi scrive NON ha visto un solo numero di R86**: nessun CSV
> aperto, nessun aggregato, nessuna riga di log della corsa. Le uniche cifre
> qui dentro vengono da **round già refertati e già agli atti** (R84, R26,
> R29, R20, R55, METRO_PROP), tutte citate per nome.
>
> Verificabile da chiunque, anche fra un anno: `git log` di questo file contro
> la data di raccolta dei CSV di R86.

_Nota di collocazione: i TODO in testa ai file prova rimandano a
`prove\R86_ABLAZIONE_CRITERI.md`. **Il file è QUESTO**, messo in
`risultati_archivio/` accanto a `R88_CRITERI.md` per tenere insieme i criteri
firmati. Non cercarlo in `prove/`._

---

## 0. 🤝 LA PROMESSA DI ONESTÀ — l'attesa è dichiarata PRIMA

Tre cose sono già scritte, e vanno lette prima dei numeri perché sono
**pretese in anticipo**: se poi i numeri le smentiscono, il round ha imparato
qualcosa; se le confermano, nessuno può dire "l'avevo detto dopo".

1. **La cella A (motore nudo) sarà probabilmente brutta.** Lo dichiara lo
   sviluppatore nel file prova stesso: *"un motore a incroci nudo sovra-trada
   per costruzione"*. **Se A esce a PF sotto 1 con centinaia di operazioni,
   NON è una sorpresa: è il METRO.** Non è un fallimento del round, è la
   baseline che serve per leggere le gambe.
2. **La gamba VOLUMI parte già battuta due volte, da due misure indipendenti:**
   - `REFERTO_ROUND84_ABLAZIONE.md` (Nasdaq, tick reali, 18/08): cella volumi
     **PF totale 0,917**, campione tagliato da 447 a 154 op → verdetto
     **TOGLIE**.
   - `REFERTO_ROUND26_VOLUMI_DAX.md` (DAX, 11/08): **0 soglie su 3** battono
     la baseline in OOS → **non si adotta**.
   👉 Quindi: **se qui i volumi aiutano, quella è una NOTIZIA**, non una
   contraddizione — è la lezione PTE (stessa gamba, segno opposto su mercati
   diversi, e si scrive per quello che è). Se non aiutano, è la terza conferma.
3. **La gamba EMA200 è quella su cui l'attesa è più alta**, e proprio per
   questo va misurata da sola. Precedente a favore: `REFERTO_ROUND29_EMA200_WF.md`
   (il primo 30/30 della storia di casa, su U30USD H1). Precedente contro:
   `REFERTO_ROUND84_ABLAZIONE.md` cella E (EMA 14/200 H1 su Nasdaq) è **il
   filtro PEGGIORE dei nove**, OOS PF 0,681. **Due misure nostre, segno
   opposto: il parametro è APERTO, e R86 serve a chiuderlo su DAX e ORO.**

---

## 1. 🎯 LA DOMANDA DEL ROUND, CELLA PER CELLA

> **UNA sola domanda:** *"l'incrocio EMA 9/21 su barra chiusa ha un edge
> misurabile DA SOLO, e le tre gambe opzionali (volumi / EMA200 di trend /
> uscita sull'incrocio opposto) aggiungono o tolgono, misurate UNA ALLA VOLTA
> a parità di tutto il resto?"*

Otto file prova: quattro celle × due simboli (**D30EUR H1** e **XAUUSD H1**).

| cella | file prova | LA DOMANDA | riga cambiata vs A | falsificazione |
|---|---|---|---|---|
| **A** 🧭 | `R86a_nudo_{D30EUR,XAUUSD}.txt` | **Il motore da solo.** È la BASELINE: ogni altra cella si legge SOLO come differenza da questa. | — (magic 776220 / 776200) | Nessuna: A non promuove e non boccia niente da sola. È il metro. |
| **B** 🔊 | `R86b_volumi_*.txt` | **Il tick-volume ≥ 1,5× la media a 20 barre sulla candela dell'incrocio aggiunge?** Soglia **da documento** (ricetta TradingView), NON spazzolata. | `InpUseVolumeFilter 0→1` | Se toglie, è la **terza** misura contro la gamba volumi (R84 Nasdaq, R26 DAX). |
| **C** 📈 | `R86c_ema200_*.txt` | **Il filtro di direzione (long solo sopra EMA200, short solo sotto) aggiunge?** | `InpUseEma200Filter 0→1` | Se le operazioni **NON calano molto**, il filtro non sta filtrando e il numero è rumore — vedi §4.5. |
| **D** 🔁 | `R86d_opposta_*.txt` | **Uscire (e girarsi) sull'incrocio opposto invece di aspettare SL/TP aggiunge?** Non è un filtro d'ingresso: è una regola di USCITA. | `InpUseOppositeExit 0→1` (con `InpReverseOnOppositeExit=1`) | Se toglie, la gestione a SL/TP fissi resta il riferimento. |

### 1-bis. 🔢 Il conto delle passate

| | passate/finestra/simbolo | finestre | simboli | **totale a tick reali** |
|---|---:|---:|---:|---:|
| 4 celle × 2 magic gemelli | 8 | 2 | 2 | **32** |

**Le tre cose che vanno sapute PRIMA, tutte lette nei file prova:**

1. **L'unico asse spazzolato è la coppia di magic gemelli.** Le due passate
   **devono uscire IDENTICHE al centesimo**. Se non lo sono, c'è di mezzo la
   cache del tester o una griglia che MT5 si ricorda: **il round si ferma**
   (checklist punto 5). È il controllo gratis, e in R84 ha funzionato 18/18.
2. **Parziale e trailing sono SPENTI di proposito in tutte e quattro le
   celle.** La cella nuda dev'essere SL e TP e basta. **La gestione è la
   domanda di un ALTRO round**, e non si legge qui nemmeno di striscio.
3. **Non esiste una cella "tutte e tre le gambe insieme".** A differenza di
   R84 (che aveva la cella I, *metodo completo*), R86 **non misura le
   combinazioni**. È un buco dichiarato: vedi §7.

---

## 2. 🪟 LE FINESTRE — dimensionate sulle OPERAZIONI (Emendamento, regola A)

### 2.0 🚧 PASSO 0 — la condizione che viene prima di tutto

I file prova lo scrivono a chiare lettere: **`@DAQUANDO 2024.09.26` è un
SEGNAPOSTO prudente, non una misura dei TICK.**

- **BARRE degli indici: MISURATE** — `REFERTO_SONDA_STORICO_17-08.md`: gli
  indici partono dal **2024.09.26**, verdetto `COMPLETO`.
- **TICK di D30EUR e XAUUSD: NON misurati.** L'unica riga `TICK` mai prodotta
  nel repo è quella di GBPUSD (probe del 15/08, `2024.07.05`).

> 🔴 **REGOLA CONGELATA:** se il PASSO 0 dice che i tick partono **dopo** il
> 2024.09.26, **i numeri di R86 non si leggono**: la finestra si riscrive con
> la data misurata e il round si rilancia. È il **difetto n.18** della
> checklist (profondità misurata su un TF, corsa girata su un altro), e in
> questa casa si è già ripetuto.
> Se i tick **non ci sono affatto**, R86 vale a **modello 1 (OHLC M1)** e
> **ogni numero porta scritto accanto "OHLC, non tick"** — l'illusione OHLC ha
> già revocato una promozione qui dentro (SupRev DOW H4, FIRMA 5).

### 2.1 La finestra dichiarata (provvisoria fino al PASSO 0)

| voce | valore | fonte |
|---|---|---|
| simboli / TF | **D30EUR H1** e **XAUUSD H1** | file prova |
| storico | **`@DAQUANDO 2024.09.26`** | sonda 17/08 (BARRE) — **da confermare sui TICK** |
| fine | `2026.06.30` | default `-Fino` di `walkforward_generico.ps1` |
| split | **40/60** (`-FrazioneIS 0.40`) | come R83/R84-bis |
| **IS** | **2024.09.26 → 2025.06.09** | identico a `REFERTO_ROUND84_ABLAZIONE.md` (stessa data d'inizio, stesso split) — **da riverificare sulle anteprime `.ini` del PASSO 2** |
| **OOS** | **2025.06.10 → 2026.06.30** | idem |
| modello | **4 = tick reali** (se il PASSO 0 lo consente) | file prova |
| rischio | **1,00% pinnato** — non è una taglia di campo (0,65%), è un valore comune che rende confrontabili le celle | file prova |

### 2.2 🐤 IL CANARINO, DETTO PRIMA DEI NUMERI

L'Emendamento (regola A) chiede **≥150 operazioni IS** e altrettante OOS.

**Qui la frequenza gioca a favore** — un motore a incroci su H1 spara molto più
di un motore da apertura — ma **è una STIMA, non una misura**: il file prova
dichiara *"~10-20 incroci grezzi al mese"*, mai contati.

> ### 🔴 CONSEGUENZE, ACCETTATE IN ANTICIPO — tutte e tre
>
> 1. **Se l'IS della CELLA A esce ≥150 operazioni** → il MERITO si legge.
>    Resta comunque vero che **R86 non promuove niente** (§6).
> 2. **Se l'IS della CELLA A esce sotto 150** → **la selezione per il MERITO è
>    SOSPESA in tutto R86** (valvola R59: *il campione sottile sospende il
>    giudizio sul MERITO, mai sul RISCHIO*). Si legge il **RISCHIO** e si
>    scrive che la finestra va allargata indietro.
> 3. **Per CIASCUNA cella filtrata (B, C, D)**: sotto **30 operazioni totali
>    (IS+OOS)** il giudizio di merito su QUELLA cella è sospeso e si scrive
>    **"non misurabile"**, mai *"peggiora"*. Soglia identica a quella congelata
>    in `R84_ABLAZIONE_CRITERI.md` §3.3 — non è inventata stanotte.
>
> Chi legge R86 fra sei mesi deve trovare questa riga **prima** dei numeri.

### 2.3 Il REGIME contenuto — va scritto accanto a OGNI numero

Con `2024.09.26 → 2026.06.30` il regime è **UNO E MEZZO**:
- **D30EUR**: toro europeo 2024-25 + correzione 2025.
- **XAUUSD**: toro dell'oro 2024-25.

Niente 2020, niente 2022, niente 2013. **R86 confronta GAMBE dentro un regime;
NON dichiara robustezza.** La robustezza è la regola C dell'Emendamento
(quattro finestre toro/orso/laterale/crollo) ed è un altro round.

---

## 3. 🎚️ LA REGOLA DI SELEZIONE — centro dell'altopiano, MAI il picco

Vale anche qui, **anche se R86 non spazzola una griglia**, perché il round
confronta quattro celle e la tentazione di prendere "la più bella" è la stessa:

1. Si guarda **l'insieme delle celle**, non la riga migliore.
2. Una cella che sporge da sola, con le sorelle che non la accompagnano, è
   **rumore**: si scrive a referto *"picco isolato, non proposto"*.
3. **Coerenza fra i due simboli**: se una gamba aggiunge su un simbolo e toglie
   sull'altro, **NON si sceglie il simbolo che piace**. Si scrive che la gamba
   ha **segno opposto sui due mercati** — è la lezione PTE (GBPUSD sì, USDJPY
   no), ed è un risultato, non un imbarazzo. **Nessun pooling dei due simboli
   in un verdetto unico**; se si somma, la riga porta scritto **[INFERITO]**.
4. **Il conteggio operazioni IS e OOS va scritto accanto a OGNI numero.** Un
   numero senza `n` **non entra nel referto**.
5. Ogni riga porta l'etichetta **[MISURATO] / [INFERITO] / [DICHIARATO]**.

---

## 4. 🚪 I CANCELLI DI LETTURA — le soglie NUMERICHE, congelate

### 4.0 🧪 Il controllo di sanità, prima di qualunque altra riga

**R86 non ha una riga di riferimento storica**: `ABTG_CrossEma` è un EA NUOVO,
mai girato. Quindi la sanità si fa in tre pezzi, tutti obbligatori:

1. **Gemelli identici** (§1-bis punto 1): 4 coppie per simbolo, 8 in tutto.
   Una sola coppia che diverge → **il round si ferma**.
2. **AUTOTEST letto UNA VOLTA, in un test singolo, PRIMA del round**
   (`InpAutoTest=1` fuori dalla griglia; nei file prova è pinnato a 0 apposta).
   La riga `[CROSSEMA][AUTOTEST] esito motore:` deve dire che **0 controlli
   sono falliti**. Se ne fallisce uno, il motore non si misura: si corregge.
3. **Le celle B/C/D devono differire da A per UNA riga sola.** Si verifica con
   un `diff` prima di lanciare (già fatto in preparazione: **verificato, una
   riga di logica + il magic**).

### 4.1 🟢 CANCELLO A — "la gamba AGGIUNGE" (i quattro criteri, tutti e quattro)

Copiati dalla lettera di `R84_ABLAZIONE_CRITERI.md` §5, perché R86 è **lo
stesso tipo di round** (ablazione, un filtro alla volta, nessuna griglia) e i
criteri di casa non si riscrivono a ogni giro:

| # | soglia | da dove esce il numero |
|---|---|---|
| **A1** | **n ≥ 30 operazioni totali** (IS+OOS) per la cella | Sotto: merito **SOSPESO**, si scrive "non misurabile". Valvola R59, già congelata in R84 §3.3. |
| **A2** | **coerenza fra le due metà**: il segno del Profit non si ribalta fra IS e OOS, **oppure** la cella migliora in **entrambe** rispetto ad A | È il criterio che in R84 ha smascherato le celle C, E, H, I (segno ribaltato = non concludente). E in R20 è la lezione USDJPY: *"IS rosso ovunque + OOS verde ovunque è la configurazione PIÙ pericolosa"*. |
| **A3** | **PF sul campione intero ≥ PF(A) + 0,10** | **+0,10 è il margine di rumore congelato in R84** (§5 punto 3): sotto quella differenza, con questi `n`, si scrive **"non distinguibile"**, non "meglio". In R84 la cella C si è fermata a +0,069 ed è finita lì. |
| **A4** | **DD non peggiore di A di più di 1,0 punto percentuale** (in entrambe le finestre) | Idem R84 §5 punto 4. |

### 4.2 ⚫ CANCELLO B — "la gamba TOGLIE"

Basta **una**: peggiora il PF **e** taglia il campione; **oppure** peggiora il
DD di più di 1,0 pp. È il verdetto che in R84 ha preso 7 celle su 9.

⚠️ **La trappola già misurata, scritta prima**: `REFERTO_ROUND84_ABLAZIONE.md`
punto 3 — *"i filtri comprimono il DD decimando i trade, non proteggendo
quelli che restano"* (cella B: DD da 17,1% a 4,6% tagliando 291→92 op).
**Un DD più basso ottenuto tagliando il campione a un terzo NON è gestione del
rischio: è selezione di giornate, e va scritto con quelle parole.**

### 4.3 🔴 CANCELLO C — IL MURO DEL RISCHIO (assoluto, a qualunque `n`)

Questo cancello **non si sospende mai** (Emendamento, regola B: *un drawdown è
un fatto accaduto, non una stima*). Vale per **ogni** cella, A compresa:

| # | soglia | da dove esce il numero |
|---|---|---|
| **C1** | **DD (IS o OOS) > 15,0%** → cella **BOCCIATA PER RISCHIO**, qualunque sia il PF | Il muro prop è **10% di DD totale** (`report/METRO_PROP.md` §1-bis). Le passate girano a **1,00%** di rischio, la taglia di campo è **0,65%**: 10% ÷ (1,00/0,65) = **15,4%**. Si arrotonda **in basso a 15,0%**. ⚠️ **[INFERITO per scalatura lineare del rischio, NON misurato]**: il DD non scala esattamente col lotto. Serve un R55-bis su qualunque cella eventualmente proposta. |
| **C2** | **Peggior Giornata % peggiore di −7,5%** → **BOCCIATA PER RISCHIO** | Muro prop giornaliero **5%** (METRO_PROP §1-bis), scalato allo stesso modo: 5% ÷ 1,538 = 7,7% → **7,5%**. La colonna *Peggior Giornata %* c'è nel CSV apposta. Stesso [INFERITO] di C1. |

### 4.4 ⚪ CANCELLO D — il pareggio, che si dichiara e non si tira

Se una gamba sta **dentro il 5% di PF e dentro 0,5 punti di DD** dalla cella A,
è un **PAREGGIO**: si scrive *"nessuna differenza misurabile"* e **la gamba
resta spenta**. Il default spento vince i pareggi: accendere un filtro ha un
costo (un pezzo di strategia in più da capire, da misurare e da mantenere) che
un pareggio non paga.

### 4.5 🔍 IL CONTROLLO DEL FILTRO CHE NON FILTRA (specifico della cella C)

Il file prova lo dichiara: *"Se le operazioni non calano molto, il filtro non
sta filtrando e il numero è rumore"*. Lo si rende numerico adesso:

> **Se la cella C ha `n` entro il ±10% della cella A, il filtro EMA200 su
> quel simbolo è INERTE**: qualunque differenza di PF è rumore di
> arrotondamento e si scrive **"filtro inerte, non misurato"**.
> Precedente identico agli atti: `REFERTO_ROUND20_GOLDENCROSS_FOREX.md` —
> *"righe IS identiche fra ADX 15 e 20 su entrambi i simboli: soglia bassa
> inerte sul campione"*.

Lo stesso controllo vale per la cella B (volumi): in R84 il filtro volumi
tagliava il campione da 447 a 154 op — **quello sì che filtrava**.

---

## 5. ⚖️ REGOLA B DELL'EMENDAMENTO, APPLICATA A QUESTO ROUND

> **Il VECCHIO giudica il RISCHIO. Il RECENTE giudica il MERITO.**

Qui il "vecchio" **non esiste**: il muro dei dati è il 2024, e c'è un regime e
mezzo. Quindi:

- ✅ **Il RISCHIO si giudica lo stesso** e con la finestra che c'è: il cancello
  C (§4.3) è pienamente applicabile a qualunque `n`.
- ⛔ **Il MERITO** è leggibile solo se il canarino (§2.2) lo consente, e in ogni
  caso **non produce una promozione** (§6).
- 📌 **Corollario da scrivere nel referto**: se una gamba passa il cancello A
  ma su un regime e mezzo, la frase corretta è *"su questa finestra la gamba
  aggiunge"*, **non** *"la gamba funziona"*. La differenza non è semantica:
  cambia cosa si promette a Claudio.

---

## 6. 🛑 IL VINCOLO — R86 PROPONE, CLAUDIO DECIDE

1. **`ABTG_CrossEma` NON È UNA SEDIA.** È un candidato mai girato. Dal round
   non esce nessun `.set`, nessun EA attaccato a un grafico, nessun magic in
   campo. **Nessun deploy automatico, in nessun caso.**
2. **Il massimo che R86 può produrre è "il permesso di fare un walk-forward
   vero"** — così sta scritto nei file prova, e resta.
3. **Nessuna sedia viva si tocca mentre R86 gira.** Nessuna cella di R86 parla
   di una sedia esistente.
4. **Un solo cambio alla volta.** Se due gambe passassero il cancello A, si
   propone **prima** quella che risponde alla domanda del round, e la seconda
   diventa un round successivo. Due cambi insieme = non si sa più chi ha
   spostato cosa.
5. Se una proposta esce e Claudio la firma, **prima del campo** servono:
   (a) **prova di regime** (regola C dell'Emendamento); (b) **R55-bis** su
   slippage/spread della cella proposta; (c) **contratto della sedia** in
   `report/CONTRATTI_SEDIE.md` con DD e frequenza **promessi** (è su quelli che
   il criterio di uscita del 18/08 misurerà il forward); (d) **forward demo**,
   mai live da un backtest.

### 6-bis. 🔁 LA CLAUSOLA DELLA SECONDA CACCIA — dichiarata PRIMA

Se **la cella A esce senza edge E nessuna delle tre gambe la porta sopra PF 1
sul campione intero**, scatta la **REGOLA DELLA SECONDA CACCIA** (richiesta di
Claudio, 19/08), e scatta **da sola**, senza aspettare che venga chiesta:

> Si cercano **MECCANISMI alternativi sulla stessa inefficienza** (fade,
> liquidity sweep, regime diverso, gestione diversa), **MAI "parametri diversi
> dello stesso motore morto"**. Motivo misurato: su un motore 0/48 un'altra
> griglia trova solo picchi di rumore, e la cella *verde per caso* è quella che
> brucia la challenge. Ogni candidato passa la lista dei caduti
> (`REGISTRO_TEST.md`) prima di entrare nell'imbuto.

**Quindi: un R86 tutto rosso NON autorizza un "R86-bis con altre EMA".**
Autorizza un meccanismo diverso, o la chiusura del capitolo.

---

## 7. 🕳️ COSA R86 **NON** PUÒ MISURARE — dichiarato prima, non dopo

Un piano che sembra completo ma ha buchi nascosti è peggio di un piano corto.
Ecco i buchi, tutti:

| ❌ non misurabile in R86 | perché | dove va |
|---|---|---|
| **Le COMBINAZIONI di gambe** (volumi+EMA200, ecc.) | non esiste una cella multi-gamba, a differenza di R84 (cella I) | round successivo, solo se una gamba singola regge |
| **La GESTIONE** (parziale, trailing, TP in R, breakeven) | pinnata e spenta apposta in tutte e quattro le celle | altro round, dichiarato nel file prova |
| **Le SOGLIE dei filtri** (volumi 1,5× / 20 barre; EMA200 periodo) | da documento, **non spazzolate**. Un filtro che funzionerebbe con un'altra soglia è un ALTRO round | coda |
| **Le varianti della cella D**: "uscita opposta con TP tolto" (`InpTP_RR=0`) e "chiude senza girarsi" (`InpReverseOnOppositeExit=0`) | cambierebbero due righe insieme; la seconda dimezza i segnali = misura un motore diverso | dichiarate e rimandate nel file prova |
| **La ROBUSTEZZA DI REGIME** | un regime e mezzo nella finestra | regola C dell'Emendamento, round a parte |
| **L'ORARIO / la sessione** | `InpUseHourFilter=0` in tutte le celle: i tetti e gli orari sono **filtri travestiti** e qui devono stare spenti | coda |
| **Lo SLIPPAGE e lo SPREAD** | `InpMaxSpread=0`, nessuna simulazione di slittamento | R55-bis, se e solo se esce una proposta |
| **Il GUARDIAN** | acceso come in campo ma **INERTE nel tester** (le sue GlobalVariable non esistono): fail-open totale | il collaudo Guardian, non questo round |
| **Il confronto con le sedie vive** | nessuna sedia gira su questo motore | — |

⚠️ **E un buco di processo, il più importante:** i file prova avvertono che
`walkforward_generico.ps1` scarica l'EA da `$EABranch="lavoro"` **scritto fisso
nel sorgente**, non dal `-Rif`. **Gira sempre l'EA che sta sulla punta di
`lavoro` ADESSO.** Se la migrazione Guardian non era chiusa quando R86 è
partito, un numero strano non si sa se è del motore o della migrazione:
**va verificato quale commit era sulla punta all'ora della corsa**, e la
risposta va scritta nel referto. (Nota: il BLOCCO 4 del collaudo Guardian
risulta chiuso VERDE alle ore serali del 19/08, commit `8907a8f` — **da
confermare contro l'orario di raccolta dei CSV**.)

---

## 8. 📋 CHECKLIST DEL REFERTO DI R86

- [ ] Il **PASSO 0** (tick D30EUR e XAUUSD) dichiarato: misurato / non misurato / OHLC.
- [ ] Il commit sulla punta di `lavoro` **all'ora della corsa**, dichiarato.
- [ ] **Gemelli identici**, 8 coppie su 8, dichiarato.
- [ ] **AUTOTEST** letto e dichiarato (0 controlli falliti).
- [ ] **n IS e n OOS accanto a OGNI numero**, senza eccezioni.
- [ ] Il **regime** dichiarato accanto a ogni tabella (§2.3).
- [ ] Il **canarino** (§2.2) ripetuto: merito leggibile o sospeso, con il numero.
- [ ] Il controllo **"filtro che non filtra"** (§4.5) applicato a B e C.
- [ ] Le celle bocciate scritte per nome, **col cancello che le ha bocciate**.
- [ ] Il verdetto **per simbolo**, mai un pooling silenzioso (§3 punto 3).
- [ ] Etichette **[MISURATO] / [INFERITO] / [DICHIARATO]** su ogni riga.
- [ ] Le **ipotesi falsificate** dette per prime, non nascoste in fondo.

---

## 9. 📎 TRACCIABILITÀ

- **File prova**: `backtest_pipeline/prove/R86{a,b,c,d}_*_{D30EUR,XAUUSD}.txt`
- **Sorgente**: `mql5/Experts/ABTG_CrossEma.mq5` v1.00 (840 righe, filtri tutti
  opt-in con default SPENTO — dichiarato nell'header: *"un default acceso
  sarebbe un pezzo di strategia nascosto dentro il codice"*)
- **Precedenti citati**: `REFERTO_ROUND84_ABLAZIONE.md` (volumi 0,917; EMA
  0,681; DD compresso decimando) · `REFERTO_ROUND26_VOLUMI_DAX.md` (0/3) ·
  `REFERTO_ROUND29_EMA200_WF.md` (30/30 su U30USD) ·
  `REFERTO_ROUND20_GOLDENCROSS_FOREX.md` (soglia inerte; lezione USDJPY) ·
  `REFERTO_SONDA_STORICO_17-08.md` (barre 2024.09.26) · `report/METRO_PROP.md`
  (muri prop 10% / 5%)
- **Criteri di riferimento**: `prove/R84_ABLAZIONE_CRITERI.md` (i quattro
  cancelli, ripresi alla lettera) · `risultati_archivio/R88_CRITERI.md` (forma)
- **Regole di casa applicate**: EMENDAMENTO DELLA FINESTRA (A/B/C/D) · valvola
  R59 · REGOLA DELLA SECONDA CACCIA (19/08) · CHECKLIST_RIGA_DI_LANCIO punti 5,
  13, 14, 18, 19
