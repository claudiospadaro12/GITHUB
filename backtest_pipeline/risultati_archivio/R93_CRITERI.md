# ⚖️ R93 — FIBO H4 ALL'IMBUTO — CRITERI, **BOZZA DA FIRMARE**

> ## ✋ NON FIRMATO. Questa e' una BOZZA.
> **Finche' Claudio non scrive "FIRMO R93", i numeri di R93 non si guardano.**
> Regola di casa, non trattabile: *i criteri si cambiano prima dei numeri, non
> dopo.* Se un numero uscito suggerisse un criterio migliore, quel criterio vale
> **dal round dopo**.
>
> _Scritto il 21/08/2026, a numeri di R93 **mai visti**: nessuna passata girata,
> `ABTG_FiboH4_Corso.mq5` **non e' mai stato compilato da nessuno**, e
> `ABTG_FiboH4_Multi.mq5` v1.10 nemmeno._

**Origine:** riga **D5** di `report/PIANO_PROP.md` + decisione di Claudio del
21/08/2026 in chat, testuale: **"1,2,3 si guardano"** — dove il punto 1 era
*"FiboH4: vale scrivere l'EA con la geometria vera del corso, dato un 0/8 in
archivio?"*. **Risposta: SI.**

---

## 🔴 0. LE QUATTRO RICHIESTE A CLAUDIO — in cima, non in mezzo al testo

Sono la differenza fra **implementazione fedele** e **nostra invenzione**.
Finche' non arrivano, i numeri accanto **restano assunzioni nostre**, e questo
va scritto in ogni referto che uscira' da R93.

| # | cosa serve | quale numero resta un'ASSUNZIONE finche' manca |
|---|---|---|
| **R1** | **Le slide** dei moduli FiboH4 e Media200. Citate 10 volte nelle lezioni, **mai lette**. Sul Breakout le slide alzarono la meccanizzabilita' dal 71% all'87%. | quasi tutto: la meccanizzabilita' dichiarata e' **50% secco / 79% con 8 assunzioni** |
| **R2** | **Screenshot del Fibonacci tracciato con la linea "100" VISIBILE** | il **target**. Oggi deduciamo che il 100 e' la **base del pattern**; se fosse l'estremo opposto la gamba B diventa il nostro EA di prima. **Fattore x2,1.** `InpTargetLevel` |
| **R3** | **Screenshot del pannello Fibo con le 4 descrizioni** (1,88 / 1,78 / 2,88 / 2,78) | la **banda**. Oggi deduciamo che "entry zone" e' una banda larga `0,10 x range`; se fossero due livelli lontani `1,0 x range` la gamba B non esiste. **Fattore x10.** `InpEZ1near/far`, `InpEZ2near/far` |
| **R4** | **Il fuso della piattaforma del corso.** Il modulo base dice *"GMT, due ore indietro dall'Italia d'estate"*; il repo usa *"server = Italia meno UNA ora"*. **Stesso broker** (bcmmarkets.com), **un'ora di differenza**, conflitto gia' agli atti (`PIANO_PROP` B3 / M15a) | gli **orari**: cancellazione pendenti 18:30-19:00 e chiusura del venerdi'. `InpCutoffHour`. **E il filtro news**: un'ora di errore su una finestra di -60/+30 minuti non e' un dettaglio |

> **R2 e R3 sono le due che decidono se la GAMBA B e' la strategia del corso o
> una nostra ricostruzione plausibile.** R93 si puo' lanciare senza, ma il
> referto dovra' dire *"misurata la NOSTRA ricostruzione"*, non *"misurata la
> strategia del corso"*.

---

## 1. 🎯 LE DUE DOMANDE — separate, giudicabili separatamente

R93 ha **due gambe**. Una puo' passare e l'altra no. **Non si sommano mai.**

### 🅰️ GAMBA A — *"il filtro news cambia l'edge del NOSTRO EA, e in che verso?"*
Banco: **`ABTG_FiboH4_Multi` v1.10**, geometria **intoccata**.
La domanda che **non** si fa: *"quanto rende il FiboH4"*. Nessuna.

### 🅱️ GAMBA B — *"la geometria del CORSO opera, e con che profilo?"*
Banco: **`ABTG_FiboH4_Corso` v1.00**, EA **nuovo**, mai compilato.
La domanda che **non** si fa: *"la geometria del corso e' migliore della
nostra"*. **Sono due ipotesi diverse, non una la correzione dell'altra.** Puo'
benissimo perdere anche lei.

### 🛑 REGOLA ZERO — **R93 NON PROMUOVE NIENTE**
Da R93 non esce: nessun `.set`, nessun EA su un grafico, nessuna sedia, nessun
cambio a niente di vivo. **Non e' prudenza formale: e' aritmetica**, vedi il
par. 4 (i tick a BCM non arrivano al 2021, quindi R93 e' **screening OHLC**, e
in questa casa *"l'OHLC e' solo screening, i verdetti solo a tick"* — R57, dove
cambiando solo il modello del tester **il segno si e' ribaltato**).

---

## 2. 📜 IL PRECEDENTE, DETTO PRIMA: C'E' UN **0/8** IN ARCHIVIO

`risultati_archivio/REFERTO_CODA_FASCIA_B.md` riga 30, coda fascia B del
10-11/08/2026:

> **"ABTG_FiboH4_Multi — 0/8 promossi. Zero promozioni su 8 coppie forex+oro H4.
> Mai piu' senza una tesi nuova."**

**R93 nasce sopra una bocciatura, e questo va scritto in ogni suo referto.**
Ma quel numero va letto per quello che e', e il 21/08 ne abbiamo trovato il
difetto di banco.

### 2.1 🔴 IL DIFETTO CHE RENDE IL "0/8" UN NUMERO SOLO, CONTATO OTTO VOLTE

`ABTG_FiboH4_Multi` e' **multi-simbolo**: opera su `InpSymbols`, **non** sul
simbolo del grafico. Il file prova di allora
(`prove/ABTG_FiboH4_Multi.txt`) lo sapeva e scriveva, testuale:

> _"NOTA CRITICA: InpSymbols VUOTO = opera sul solo simbolo del grafico. Senza
> questo pin l'EA scannerizza la lista di default (3 cross) e i risultati
> mischierebbero simboli: **il pin sotto e' OBBLIGATORIO**."_
> e sotto: `InpSymbols=`

**Quel pin non ha funzionato.** [MISURATO, non dedotto] — nei 16 CSV di
`risultati_prove/ABTG_FiboH4_Multi/` la colonna `InpSymbols` vale
**`GBPUSD;USDJPY;EURUSD`** (il default compilato) in **tutte** le passate,
comprese quelle intitolate AUDUSD, CADJPY, GBPJPY, USDCHF. E i numeri lo
confermano:

| simbolo del titolo | IS profit | OOS profit | n IS | n OOS |
|---|---:|---:|---:|---:|
| AUDUSD | −385,83 | +116,17 | 72 | 82 |
| CADJPY | −385,83 | +116,17 | 72 | 82 |
| EURUSD | −384,56 | +118,46 | 72 | 82 |
| GBPUSD | −384,78 | +118,68 | 72 | 82 |
| GBPJPY | −394,13 | +118,46 | 72 | 82 |
| USDCHF | −384,78 | +118,68 | 72 | 82 |
| USDJPY | −384,99 | +116,81 | 72 | 82 |
| XAUUSD | −536,71 | +299,89 | 67 | 70 |

**Sette righe su otto sono la stessa passata.** Le differenze da centesimi
vengono solo dal flusso di tick del simbolo del grafico, che scandisce
`OnTick()`. XAUUSD si stacca per lo stesso motivo, non perche' sia un mercato
diverso: **anche li' l'EA stava operando su GBPUSD/USDJPY/EURUSD**.

> ### 📌 LA LEZIONE, che vale oltre il FiboH4
> **Un pin di una stringa a valore VUOTO non arriva all'EA: vince il default
> compilato.** `walkforward_generico.ps1` scrive comunque la riga `InpSymbols=`
> in `[TesterInputs]`, e MT5 la ignora. E' il fratello del difetto n.5 della
> checklist (*il pin che imposta il valore ma non spegne il flag*): **la riga
> c'e', sembra applicata, e non lo e'.**
> ➡️ In R93 `InpSymbols` e' pinnato a un valore **NON VUOTO**, sempre.
> ➡️ Corretto anche `scan_market.ps1` (blocco FiboH4): ora usa `__SYM__` come il
> blocco del BULGE.

### 2.2 ⚖️ Cosa cambia e cosa NON cambia di quel verdetto

- ❌ **NON cambia** che quella configurazione, su quel basket, in quella
  finestra, abbia perso in IS e guadagnato pochissimo in OOS. **Il numero resta.**
- ✅ **Cambia** che sia un verdetto su **otto mercati**: e' un verdetto su **uno**.
- ✅ **E cambia** che sia un verdetto sulla **strategia del corso**: non lo e'
  mai stato (par. 3).

---

## 3. 📐 PERCHE' LA GAMBA B ESISTE — le tre divergenze, coi fattori

`ANALISI_CORSO_FIBOH4_MEDIA200_2026-08-18.md` par. 1.2, misurate:

| | `ABTG_FiboH4_Multi` (il nostro) | il CORSO | fattore |
|---|---|---|---|
| dove vanno i 2 ordini | su 1,88 e su 2,88, distanti **1,0 x range** | sui due bordi di **UNA banda**, distanti **0,10 x range** (~5-10 pip) | 🔴 **~x10** |
| dove va il target | l'**estremo opposto** (livello 0,0) | il **livello 100** = base del pattern | 🔴 **x2,1** |
| quale stop | **4,236 fisso**, il piu' largo dei 7, **mai messo a sweep** | uno dei **7 metodi**, senza criterio di scelta | 🔴 **~x4** |

🧮 **E l'aritmetica di quanto costa:** con lo stop 4,236 e il target all'estremo
opposto, la gamba EZ1 del nostro EA ha **R:R strutturale 0,80** → le serve
**win rate > 56% solo per pareggiare**, prima di spread e commissioni.

> ### ⚠️ LA COSA ONESTA DA DIRE SUBITO, PRIMA DI SPENDERE UNA NOTTE DI MACCHINA
> **La gamba A da sola non salva niente.** Un filtro news toglie l'8-12% delle
> occasioni (numero misurato, par. 6.1): su un motore con R:R strutturale 0,80
> **non puo' ribaltare il segno**, al massimo lo sposta di poco. Se la domanda
> fosse *"come rendiamo profittevole il FiboH4"*, la risposta **non e' il
> filtro news**: e' la GEOMETRIA, cioe' la gamba B.
> **La gamba A resta valida per un'altra ragione, ed e' quella di D5:**
> sapere **quanto costa la CONFORMITA' PROP** (un filtro news e' obbligatorio
> per FTMO/The5ers/E8/FundingPips). Cioe' non *"quanto rende"* ma *"quanto mi
> costa essere in regola"*. **E' una domanda diversa e va scritta cosi'.**

---

## 4. 📅 PASSO 0 — LA FINESTRA. Aritmetica, prima dei numeri

### 4.1 La frequenza VERA del motore (misurata, non stimata)

Dai CSV della fascia B, finestra `2024.09.26 → 2026.06.30` (642 giorni, IS 40% /
OOS 60%), basket di 3 cross con `InpMaxTotalPositions=1`:

| finestra | durata | n (basket di 3) | op/anno basket | op/anno **per simbolo** |
|---|---:|---:|---:|---:|
| IS | 0,70 anni | 72 | 102 | **34** |
| OOS | 1,06 anni | 82 | 78 | **26** |

**Frequenza di casa da usare: ~30 operazioni/anno/simbolo, ~100/anno sul basket
di 3.** (E' un **limite inferiore** per il simbolo singolo: col tetto a 1
posizione i tre cross si tolgono il posto a vicenda.)

### 4.2 Quanti anni servono per l'Emendamento della finestra (regola A: n >= 150)

| banco | op/anno | anni per 150 IS | anni per 150 IS **+** 150 OOS |
|---|---:|---:|---:|
| **Gamba A** — basket di 3 | ~100 | **1,5** | **~3,0** |
| **Gamba B** — un simbolo | ~30 | **5,0** | **~10,0** |

### 4.3 Quanta finestra ESISTE davvero — e qui il round si stringe

| vincolo | da quando | a quando | anni | misurato? |
|---|---|---|---|---|
| **Calendario news convertito** | **2021.01.04** | **2025.12.19** | **4,96** | ✅ [MISURATO] `converti_calendario_news.py` |
| Barre M1 a BCM sui cross | ❓ | — | ❓ | 🔴 **DA MISURARE — PASSO 0** |
| **Tick reali a BCM (GBPUSD)** | **2024.07.05** | — | **~2,0** | ✅ [MISURATO] referto 15/08 |

### 4.4 🔴 LE TRE CONSEGUENZE, ACCETTATE IN ANTICIPO

1. **R93 E' UN ROUND OHLC. NON PUO' ESSERE ALTRO.** A tick reali la finestra
   2021-2025 **non esiste a BCM** (i tick di GBPUSD partono dal 2024.07.05).
   Quindi: **nessuna promozione**, e ogni numero porta l'etichetta *screening*.
   ⚠️ E vale l'avvertimento di R57: **passando ai tick fino al 49% delle
   operazioni sparisce, e il segno puo' ribaltarsi.**
2. **Ogni cella col filtro news acceso vive dentro 2021.01.04 → 2025.12.19.**
   Fuori da li' il filtro e' **CIECO** e la cella tornerebbe identica alla
   baseline. E' lo stesso errore di M17 sul PostNews (*calendario 2026-2027 →
   Trades=0, misurato il nulla*), al contrario. **La finestra di R93 finisce il
   2025.12.19, non il 2026.06.30.**
3. **GAMBA A: il campione c'e'** (atteso ~200 IS / ~290 OOS sul basket) → il
   merito **si puo' leggere**, dentro i limiti dell'OHLC.
   **GAMBA B: il campione NON c'e'** (~150 operazioni **in tutto** su un simbolo
   in 5 anni, contro i 150+150 richiesti). → **In gamba B il MERITO e' SOSPESO**,
   vale la valvola R59: *il campione sottile sospende il giudizio sul MERITO,
   mai sul RISCHIO*. ✅ Il **drawdown si legge lo stesso**: un drawdown accaduto
   e' un fatto, non una stima.

### 4.5 Il comando del PASSO 0 (da eseguire PRIMA, MT5 chiuso)

```
.\scarica_storico.ps1 -Auto -SenzaTick -Da 2021.01.01 -Simboli "GBPUSD,USDJPY,EURUSD" -TimeoutMin 240
```
**Si legge la riga `M1`, colonna `PrimaDataServer`** (difetto n.18 della
checklist: il tester a modello 1 costruisce le barre dall'**M1**, non dall'H4).
- Se M1 parte **dopo il 2021.01.04** → la finestra del round si accorcia a
  quella data **e l'aritmetica del par. 4.2 va rifatta**, non interpretata.
- Se M1 parte dopo il **2024** → **la gamba B non e' misurabile nemmeno per la
  direzione** e R93 si riduce alla sola gamba A.

---

## 5. 🐤 I CANARINI — si leggono **PRIMA** dei numeri veri

### 5.1 🗞️ IL CANARINO DEL FILTRO NEWS (il piu' importante della gamba A)

Il difetto che ucciderebbe il round in silenzio e' il **31-bis** della
checklist: *un filtro a cui manca il dato non fallisce, diventa NEUTRO*, la
cella esce identica alla baseline e si scriverebbe **"il filtro e' neutro"**
misurando **un filtro che non e' mai girato**.

Qui il pericolo era **doppio e reale**, e adesso e' chiuso da tre parti:

**(a) IL FORMATO.** I due calendari in biblioteca hanno **le colonne 2 e 3
SCAMBIATE** rispetto a quello che l'EA legge:

```
biblioteca : data ; PAESE            ; impatto 0-3 ; evento
l'EA       : data ; impatto (High..) ; VALUTA      ; titolo
```
Dandoli all'EA come sono, `ImpactToInt()` legge `"United States"`, torna **0**,
e con soglia 3 **nessuna riga blocca mai niente**.
✅ Chiuso da `backtest_pipeline/converti_calendario_news.py` (autotest 5/5 casi
passati). Prodotto: `mql5/Files/abtg_news_2021_2025_UTC.csv` — **2.971 eventi ad
alto impatto, 0 righe scartate, 2021.01.04 → 2025.12.19**, in **UTC**.

**(b) IL FUSO — e qui l'etichetta "UTC+2" di `PIANO_PROP` D1 era mezza
sbagliata.** Misurato sul Nonfarm Payrolls (esce alle 08:30 di New York):
`2022.01.07 15:30` nel file → 13:30 UTC (**+2**); `2022.07.08 15:30` → 12:30 UTC
(**+3**). Cioe' i file sono in **ora server MetaQuotes (EET/EEST, con l'ora
legale europea)**, non in un UTC+2 fisso. **Chi sottrae "un'ora fissa" sbaglia
di un'ora per meta' anno.** Il convertitore scrive in **UTC puro** e l'offset
del server resta un numero dichiarato nel file prova (`InpNewsShiftMinutes`),
**misurabile**, non sepolto nel CSV.

**(c) LA CONSEGNA AL TESTER — il punto che poteva far fallire tutto.**
`FileOpen(..., FILE_READ|FILE_CSV|FILE_ANSI)` legge dalla **sandbox
`MQL5\Files` dell'AGENTE**, non da quella del terminale. In ottimizzazione
(`Optimization=1`, agenti locali multipli) **il file non ci arriva**:
`FileOpen` falliva, l'EA stampava una riga informativa e **il filtro si
spegneva da solo**. `walkforward_generico.ps1` **non copia nessun file
ausiliario**: lo abbiamo verificato riga per riga.
✅ Chiuso in tre modi, tutti e tre insieme:
1. l'EA legge da **`Common\Files`** (`InpNewsCommon`, default true) — la stessa
   strada che in casa funziona gia' per `ExportTrades` **dal tester**;
2. se non lo trova in Common **ripiega sulla sandbox e LO DICE**;
3. se non lo trova da nessuna parte, o lo legge e produce **zero eventi utili**,
   stampa **`[FIBOH4][NEWS] FILTRO ACCESO MA CIECO`** e a fine passata
   **`[FIBOH4][NEWS-CONTA] ... CANARINO ROSSO`**.

> 🔴 **REGOLA DEL ROUND, non trattabile:** una cella "news ON" con
> **`bloccate = 0`** o **`eventi utili = 0`** **si BUTTA**. Non e' un risultato
> *"il filtro e' neutro"*: e' una passata in cui il filtro **non e' stato
> eseguito**. Si cerca il file e si rilancia.

### 5.2 📏 L'ATTESO DEL FILTRO, CALCOLATO PRIMA (e' la soglia S2-A)

Calcolato **sul calendario vero**, contando quante aperture di barra H4
(lun-ven, 2021.01.04 → 2025.12.19, **7.764 barre**) cadono in blackout:

| finestra | server UTC+0 | **server UTC+1** | server UTC+2 |
|---|---:|---:|---:|
| **−60/+30 (default)** | 9,81% | **11,37%** | 11,66% |
| −30/+15 | 3,55% | 5,76% | 8,27% |
| −10/+10 | 1,21% | 3,19% | 5,49% |

E **per valuta** (regola del corso), server UTC+1, finestra −60/+30:
GBPUSD **9,70%** · USDJPY **8,45%** · EURUSD **8,54%**.

> ✅ **ATTESO DICHIARATO: il filtro deve bloccare fra l'8% e il 12% delle
> interrogazioni**, e togliere un numero di operazioni **dello stesso ordine**.
> - **0%** → non ha girato (si butta la cella, par. 5.1).
> - **> 50%** → file letto male o shift assurdo (si butta la cella).
> - **fra 8% e 12%** → il filtro **ha filtrato**: adesso si puo' leggere il
>   resto della riga.
>
> 📌 E si vede anche una cosa utile: **l'ipotesi di fuso sposta il risultato di
> ~1,6 punti** (9,81 contro 11,37). E' poco: **la richiesta R4 non blocca la
> gamba A**, ma va dichiarata. La cella `R93c` la misura.

### 5.3 👯 IL DETERMINISMO DEL BANCO (magic gemello)

`R93a` spazzola **solo** `InpMagic` (771650 / 771651): due passate identiche in
tutto tranne il magic. **Devono uscire uguali al centesimo** (precedente: R51,
*"tutte e quattro le coppie identiche"*).
**Se differiscono, il banco non e' deterministico e NESSUN altro numero di R93
vale.** Si cerca il perche' prima di leggere qualunque altra riga.

### 5.4 🧊 IL CANARINO DELLA GAMBA B: "ha operato?"

`ABTG_FiboH4_Corso` stampa a fine passata:
```
[FIBOCORSO-CONTA] <SYM> | pattern visti=N -> scartati: ampiezza=A laterale=L distanza=D | SETUP PIAZZATI=P
```
- **P = 0** → la passata **non dice niente sulla strategia**: dice che **non ha
  mai operato**. Si guarda **quale cancello ha mangiato tutto**:
  - `laterale` alto → la precondizione "fine di un trend" e' troppo stretta
    (l'asse `R93h` la misura accesa/spenta);
  - `distanza` alto → i 50 pip minimi non si raggiungono mai su quel cross;
  - `pattern visti = 0` → l'engulfing **totale, ombre comprese** e' raro su H4.
    **E' un fatto, non un difetto.**
- E' il gemello del canarino BLU di R92: **prima si stabilisce che il banco ha
  misurato qualcosa, poi si guarda quanto ha reso.**

### 5.5 🧪 L'AUTOTEST — si legge ESEGUENDO, non compilando

Entrambi gli EA stampano in `OnInit`. **F7 compila e basta: da MetaEditor quelle
righe non escono** (difetto n.20 della checklist). Si leggono facendo **un test
SINGOLO nello Strategy Tester**, mai attaccando l'EA a un grafico: sul PC di
backtest il terminale e' collegato al **conto vivo** (il 14/08 e' partito un
ordine vero da un backtest).

Da `[FIBOCORSO][AUTOTEST]` devono uscire **0 casi falliti** e questa riga, che
e' la prova che la geometria del corso e' quella dichiarata:
```
geometria su pattern 100-110 (range 10): target100=100.00 | EZ1 [98.20 - 99.20] | EZ2 [88.20 - 89.20] | banda=1.00
```
(banda = `0,10 x range` = 1,00 su range 10 ✅ · target 100 = **la base** ✅)

---

## 6. 🚪 LE SOGLIE — CONGELATE, e sono DIVERSE per le due gambe

### 6.1 🅰️ GAMBA A — e la soglia NON e' un profit factor

La domanda e' *"il filtro cambia l'edge, e in che verso"*. La risposta si legge
con **la misura del round**, non col PF:

> ### 🧮 **aspettativa dei trade TAGLIATI = (Profit_base − Profit_cella) / (n_base − n_cella)**
>
> - viene **< 0** → il filtro ha tagliato **perdenti**: la conformita' prop
>   **e' gratis, o ci guadagna**;
> - viene **>= 0** → il filtro ha tagliato **vincenti**: la conformita' prop
>   **ha un prezzo**, e adesso sappiamo quanto.
>
> ⚠️ E il segno **non e' l'ipotesi**: e' la cosa che si misura. Non e' vero che
> "togliere le news fa bene" — su un motore che entra con ordini LIMITE, le
> barre di news sono anche quelle che **riempiono** i pendenti lontani.

| # | soglia | il numero, e da dove esce |
|---|---|---|
| **S1-A — CAMPIONE** | **n >= 150** in IS **e** in OOS, sul basket | Emendamento della finestra, regola A. Atteso ~200 / ~290 (par. 4.1-4.2). **Sotto 150: merito SOSPESO, si legge solo il rischio** (valvola R59) |
| **S2-A — IL FILTRO HA FILTRATO** | **taglio delle operazioni fra 5% e 20%** rispetto alla baseline | l'atteso misurato e' **8-12%** (par. 5.2); la banda 5-20% e' larga apposta, perche' le operazioni non coincidono con le barre. **Fuori da questa banda la cella si BUTTA**, non si interpreta |
| **S3-A — IL VERDETTO SU D5** | il filtro si dichiara **UTILE** solo se l'aspettativa dei trade tagliati e' **< 0 in ENTRAMBE le finestre** | una finestra sola non basta: *"si tiene una modifica solo se migliora l'INSIEME"*. Se IS dice si' e OOS dice no → **NON DIMOSTRATO**, e si scrive cosi' |

### 6.2 🅱️ GAMBA B — dove il merito e' sospeso per aritmetica

| # | soglia | il numero, e da dove esce |
|---|---|---|
| **S1-B — LEGGIBILITA'** | **P (setup piazzati) > 0** e **n >= 30** per simbolo e per finestra | sotto 30 non si legge nemmeno la **direzione**. Sopra, si legge la direzione ma **NON il merito**: per il merito servirebbero ~10 anni (par. 4.2) e non ci sono |
| **S2-B — PROFILO** | **PF >= 1,30** in **entrambe** le finestre, **su entrambi i simboli** | 1,30 e' la soglia di casa per uno screening OHLC (stessa di R92): un PF appena sopra 1 in OHLC, al tick, e' quasi sempre sotto 1. **"La famiglia, mai il simbolo solo"**: un solo cross che passa e' un **picco isolato = rumore** |
| **S3-B — SEGNO** | **profitto netto > 0** in entrambe le finestre | l'OHLC e' il modello **piu' generoso** dei tre (R57): quello che perde qui, al tick perde di piu' |

### 6.3 ⚫ BOCCIATURA SECCA — basta **una**

**Gamba A:**
- la cella `R93a` (baseline) **non riproduce** il metro → si ferma tutto,
  non e' un problema di filtro (canarino 5.3);
- **tutte** le celle "news ON" hanno `bloccate = 0` → **il meccanismo CSV non
  regge nel tester**: si passa al **PIANO B** (par. 8) e i numeri non si leggono.

**Gamba B:**
- **P = 0 su entrambi i simboli e in tutte le celle** → la ricostruzione del
  corso, come l'abbiamo scritta, **non opera**. Non e' "perde": e' **non
  eseguita**, e va distinta (difetto 31-bis);
- **n < 20** in una finestra → *un numero senza n non entra nel referto*;
- **PF < 1,00 in OOS su entrambi i simboli, in tutte e quattro le celle dello
  stop** → la geometria del corso **non ha edge misurabile** in questa finestra
  e con queste assunzioni. **Ed e' un esito legittimo del round**: scatta la
  **REGOLA DELLA SECONDA CACCIA** (CLAUDE.md), meccanismi alternativi, mai
  "un'altra griglia dello stesso motore morto".

### 6.4 ⚪ LA ZONA GRIGIA, dichiarata e non tirata

Cella che passa **due soglie su tre**: si scrive a referto come **"zona
grigia"** col nome della soglia mancata. **Non passa allo stadio dopo** in
questo giro.

---

## 7. 🎚️ LA REGOLA DI SELEZIONE — e perche' qui e' DIVERSA

La regola di casa e' *"centro dell'altopiano, MAI il picco"* (R70: il confronto
si ribalto' quando fu rifatto con la regola giusta).

- ✅ **Dove c'e' una griglia ordinata** (`InpNewsShiftMinutes`, `InpZona`) la
  regola vale come sempre.
- 🛑 **Sull'asse dello STOP no, e va detto.** I 4 metodi (`R:R 1:1` / `ATR` /
  `4,236` / `candela`) **non sono una griglia**: sono **quattro ricette
  qualitative**, non ordinabili. Non esiste un "centro dell'altopiano" fra loro.
  > ### 📌 Quindi: **R93 NON SCEGLIE UN METODO DI STOP.**
  > R93 dice soltanto **se almeno uno regge**. La scelta e' un round dopo, a
  > **tick reali**, sui soli metodi sopravvissuti. Scegliere qui il metodo col
  > numero piu' bello sarebbe **pescare**, ed e' esattamente quello che il
  > 4,236 di `ABTG_FiboH4_Multi` gia' e': un metodo **scelto e mai misurato**.
- 📌 **Il conteggio operazioni va scritto accanto a OGNI numero**, e accanto va
  scritto **il regime contenuto**: 2021 reflazione post-covid · 2022 dollaro
  forte e inflazione · 2023-24 disinflazione · 2025. **Quattro regimi in una
  finestra sola: e' una fortuna, e va sfruttata leggendo gli ANNI, non solo il
  totale.**

---

## 8. 🅿️ IL PIANO B, deciso PRIMA (se il CSV non arriva agli agenti)

Se il canarino 5.1 dice **CIECO su tutte le celle**, l'ordine delle cose e'
questo, e **non si improvvisa a corsa avviata**:

1. **Copiare il CSV anche in `MQL5\Files` del terminale** (lo fa gia' la riga di
   lancio) e rilanciare **una sola cella** in test SINGOLO: se li' funziona ma
   in ottimizzazione no, il problema **e' la sandbox degli agenti** ed e'
   confermato.
2. **`#property tester_file "abtg_news.csv"`** — la strada documentata da
   MetaQuotes per far arrivare un file agli agenti. **Non e' stata messa
   adesso di proposito**: pretende un nome **costante a compilazione** (quindi
   `InpNewsFile` smetterebbe di contare) e, se il file manca, il comportamento
   del tester **non e' verificato in questa casa**. Metterla alla cieca
   rischiava di rompere **tutti** i round futuri di questo EA.
3. **Ultima spiaggia: un solo agente** (`Optimization` disattivata, celle in
   sequenza). Costa tempo di macchina, ma toglie di mezzo la sandbox.

---

## 9. 🛡️ IL RISCHIO, DETTO PRIMA CHE ARRIVINO I NUMERI

1. **Gamba A: `InpRiskPercent = 1,0%`** (il valore gia' nel file prova della
   fascia B). **Non si tocca**: e' il valore comune di casa che rende le celle
   confrontabili fra loro.
   ⚠️ **Ma il TETTO cambia, e va detto: `InpMaxTotalPositions` passa da 1 a 3.**
   Nella fascia B era 1, e con 1 i tre cross **si tolgono il posto a vicenda**:
   l'ordine della lista deciderebbe chi opera, e il canarino del pin
   (par. 11) sarebbe inutile perche' cambierebbe anche i risultati. Con 3 i
   cross sono **indipendenti**, che e' la condizione giusta per misurare un
   filtro.
   👉 **Conseguenza sul rischio, dichiarata: 3 x 1,00% = 3,00% di rischio
   aperto massimo. Sotto il cap C1 di 3,25% firmato il 18/08.**
   👉 **Conseguenza sui numeri, dichiarata: la baseline `R93a` NON e'
   confrontabile in denaro con le righe della fascia B.** Non e' un problema:
   quelle righe erano gia' otto copie della stessa passata (par. 2.1), e R93
   porta il suo metro.
2. **Gamba B: `InpRiskPercent = 0,65%`** — lo **0,65% DI CASA** (firma del
   18/08), **NON l'1% preso in prestito dal modulo Breakout**: il corso la
   percentuale **non la pronuncia mai in 3 lezioni**. Con 2 ordini la frazione
   si **spartisce** (1/3 + 2/3), **non si somma**: rischio aperto massimo
   **0,65%**.
   ⚠️ **I profitti in denaro delle due gambe NON sono confrontabili fra loro**
   (rischi diversi). **PF, win rate e n si'.**
3. **Guardian acceso in entrambi** (`InpUsaGuardian = true`), come in campo. Nel
   tester le sue GlobalVariable non esistono → **fail-open totale, inerte**: i
   numeri restano confrontabili con quelli degli altri EA. Sta scritto qui
   apposta, cosi' nessuno lo cerca nei log.
4. **Nessuna sedia viva viene toccata.** Il FiboH4 **non e' in campo**:
   verificato in `FLOTTA_ATTIVA.md`, `report/CONTRATTI_SEDIE.md` e nel
   censimento — e sta perfino in `$KillSempre` della pulizia VPS. Magic
   **771602** (gamba A) e **771640** (gamba B, blocco libero verificato nel
   repo il 21/08): nessuna collisione.

---

## 10. 🚫 COSA NON SI POTRA' DIRE COI DATI CHE ABBIAMO

Da scrivere **nel referto finale**, per esteso, non in nota:

1. ❌ **Niente sul merito a TICK REALI.** A BCM i tick su GBPUSD partono dal
   **2024.07.05**: la finestra 2021-2025 a tick **non esiste**. R93 e'
   **screening OHLC** e basta. *(R57: cambiando solo il modello, il segno si e'
   ribaltato e fino al 49% delle operazioni e' sparito.)*
2. ❌ **Niente sul 2026.** Il calendario news finisce il **2025.12.19**.
3. ❌ **Niente su "la geometria del corso e' migliore della nostra".** Sono due
   ipotesi diverse, misurate su **un broker, un feed, un modello approssimato**.
   E la gamba B ha **il merito sospeso per aritmetica** (par. 4.4).
4. ❌ **Niente sul fuso.** La cella `R93c` misura **quanto il risultato e'
   SENSIBILE** a un'ora di errore. **Non stabilisce quale sia l'ora giusta**:
   quella e' la richiesta **R4**, e si chiude con uno screenshot, non con un
   backtest.
5. ❌ **Niente su "il filtro news e' inutile"** se il canarino 5.1 e' rosso: in
   quel caso non e' stato misurato niente.
6. ❌ **Niente sulla fedelta' al corso** finche' **R2 e R3** non arrivano. Si
   scrive *"misurata la NOSTRA ricostruzione della geometria del corso, con 8
   assunzioni dichiarate"*.
7. ⚠️ **E niente promozioni, in nessun caso.** R93 misura. Il forward demo, se
   mai, e' due stadi piu' in la'.

---

## 11. 📦 IL DISEGNO DEL ROUND — 68 passate, una variabile alla volta

Ogni file prova ha **UN SOLO asse** con flag `Y` (regola di casa: se non c'e' un
asse, il driver **rifiuta** di lanciare — difetto n.5 della checklist).
Tutto il resto e' pinnato in forma completa `v||v||0||v||N`.

**Finestra comune: `2021.01.04 → 2025.12.19`** (il calendario news), IS/OOS
40/60, **Modello 1 (OHLC M1)**, deposito 10.000, `InpSymbols` pinnato **NON
vuoto**.

### ✅ I 14 file prova sono gia' stati VERIFICATI A MACCHINA (non a memoria)

```
python3 backtest_pipeline/controlla_prova.py "backtest_pipeline/prove/R93*.txt"
```
Esito del 21/08/2026: **14 file, 34 celle, 68 passate, 0 problemi.**
Lo strumento controlla quello che controlla il driver (nome sconosciuto,
parametro doppio, sweep degenere) **piu' una cosa che il driver NON controlla**:
il **pin di stringa vuoto**, cioe' esattamente il difetto che ha prodotto il
"0/8" (par. 2.1). Passato sul file prova della fascia B, lo trova ancora oggi:

```
ABTG_FiboH4_Multi.txt   !! 3 PROBLEMI
   - PIN VUOTO (MT5 lo IGNORA e usa il default compilato): InpSymbols=
   - 2 assi Y: un file prova misura UNA variabile alla volta
   - manca @DAQUANDO: la finestra va dichiarata nel file, non ricordata
```

### 🐤 IL CANARINO DEL PIN, dentro i dati e non nei log

`InpSymbols` e' pinnato a **`USDJPY;EURUSD;GBPUSD`**: **stesso basket, ordine
DIVERSO dal default compilato** (`GBPUSD;USDJPY;EURUSD`). Serve a distinguere
"pin arrivato" da "pin ignorato", che col default identico **non si
distinguerebbero**.
- colonna `InpSymbols` del CSV = `USDJPY;EURUSD;GBPUSD` → ✅ il pin e' arrivato;
- colonna `InpSymbols` del CSV = `GBPUSD;USDJPY;EURUSD` → 🔴 **il pin NON e'
  arrivato** (il `;` non sopravvive all'`.ini`): **i numeri della gamba A non si
  leggono**, e si ripiega su un simbolo per passata rifacendo l'aritmetica del
  campione (par. 4.2).
Con `InpMaxTotalPositions = 3` l'ordine della lista **non cambia i risultati**,
quindi il canarino e' gratis.

### 🅰️ GAMBA A — `ABTG_FiboH4_Multi` v1.10 · basket `GBPUSD;USDJPY;EURUSD`

| file prova | l'asse (Y) | celle | cosa risponde |
|---|---|---:|---|
| `R93a_baseline.txt` | `InpMagic` 771650/771651 | 2 | **il metro** + il determinismo del banco (5.3) |
| `R93b_news.txt` | `InpNewsPerCurrency` 0/1 | 2 | blackout **globale** vs **per valuta** (la regola del corso) |
| `R93c_fuso.txt` | `InpNewsShiftMinutes` 0/+60 | 2 | **quanto pesa un'ora** (richiesta R4) |
| `R93d_toglio_ordini.txt` | `InpNewsCancelPendings` 0/1 | 2 | *"prima del dato gli ordini vanno tolti"* + deroga 100 pip |
| `R93e_overnight.txt` | `InpUseCutoff` 0/1 | 2 | il cancello **overnight**, misurato e non acceso per fede |
| `R93f_weekend.txt` | `InpFridayClose` 0/1 | 2 | il cancello **weekend** (*"mai e qua dico mai"*) |

**12 celle x 2 finestre = 24 passate.**

### 🅱️ GAMBA B — `ABTG_FiboH4_Corso` v1.00 · **GBPUSD** e **USDJPY** (i due cross che il corso nomina)

| file prova | l'asse (Y) | celle | cosa risponde |
|---|---|---:|---|
| `R93g_stop_<SYM>.txt` | `InpSLMode` (4 metodi) | 4 | **il buco che decide il P&L**: il corso ne da' 7 senza sceglierne uno |
| `R93h_trend_<SYM>.txt` | `InpUseTrendFilter` 0/1 | 2 | quanto pesa la **precondizione "fine di un trend"** |
| `R93i_ancoraggio_<SYM>.txt` | `InpAncoraggio` 0/1 | 2 | l'ambiguita' del par. 4.4 (*"il minimo successivo"*) |
| `R93j_zona_<SYM>.txt` | `InpZona` (3) | 3 | solo EZ2 (il corso) vs solo EZ1 vs fallback |

(un file per simbolo: `_GBPUSD` e `_USDJPY`. Il simbolo sta nel `@SIMBOLO` del
file, non in un parametro della riga: cosi' non si puo' sbagliare accoppiamento.)

**11 celle x 2 simboli x 2 finestre = 44 passate.**

### ⏱️ Traffico
**UNA MACCHINA, UN LAVORO.** Il PC di backtest ha **un solo MT5**.
**R92 deve essere finito prima.** R93 non ha prerequisiti di dati oltre al
PASSO 0, ma ha tre prerequisiti duri:
1. la **FIRMA** di questi criteri;
2. la **COMPILAZIONE** dei due EA in MetaEditor, **0 errori 0 warning**
   (`ABTG_FiboH4_Corso.mq5` non e' **mai** stato compilato, e chi lo ha scritto
   **non ha MetaEditor**);
3. il **PASSO 0** (par. 4.5) e l'**autotest letto in test singolo** (par. 5.5).

---

## 12. 📋 COSA DEVE CONTENERE IL REFERTO DI R93 (checklist)

- [ ] **Le 4 richieste R1-R4 in cima**, con accanto quale numero resta assunzione.
- [ ] I **canarini** del par. 5 letti **per primi**, prima di ogni tabella.
- [ ] Il **conteggio operazioni accanto a OGNI numero**, e per la gamba B anche
      `pattern visti / scartati / setup piazzati`.
- [ ] Il **regime** dichiarato accanto a ogni tabella (2021 / 2022 / 2023-24 / 2025).
- [ ] **La percentuale di barre bloccate** di ogni cella news, confrontata con
      l'atteso **8-12%** del par. 5.2.
- [ ] **L'aspettativa dei trade TAGLIATI** (par. 6.1) per ogni cella news, col
      segno in chiaro.
- [ ] Le due gambe **giudicate separatamente**, con scritto in chiaro che
      **una puo' passare e l'altra no**.
- [ ] Il **0/8 della fascia B citato**, e citato col suo difetto di banco (par. 2).
- [ ] Distinzione esplicita **[MISURATO] / [INFERITO] / [DICHIARATO]**.
- [ ] La frase finale, in chiaro: **"R93 non ha promosso niente; ha misurato X e
      Y, in OHLC, su un broker solo"**.

---

## 13. ✍️ FIRMA

Tre cose da firmare insieme, o R93 non parte:

```
FIRMO R93 -- gamba A (filtro news)          Claudio, data ____________

FIRMO R93 -- gamba B (geometria del corso)  Claudio, data ____________

Rischi: gamba A 1,00%  ·  gamba B 0,65%     Claudio, data ____________
```

E le tre domande su cui serve una riga di risposta, anche solo un "ok":

1. **Le soglie S1/S2/S3 delle due gambe** (par. 6) vanno bene come sono?
2. **La finestra si ferma al 2025.12.19** (limite del calendario news) invece
   del solito 2026.06.30: **d'accordo?** Costa 6 mesi di OOS e in cambio rende
   il filtro **misurabile**.
3. **R2 e R3** (i due screenshot): arrivano prima del lancio, o si lancia
   dichiarando che si misura **la nostra ricostruzione**?

Finche' queste righe sono vuote, R93 **non si lancia** e i suoi numeri **non si
leggono**.

---

## 14. 🚀 LA RIGA DI LANCIO — cinque blocchi, in quest'ordine

**Pinnata a `d78af56`.** Ogni blocco e' **UN SOLO comando**: si incolla
**intero, graffe comprese**. Tre righe una sotto l'altra dentro un blocco non
sono un programma — sono tre comandi indipendenti, e un `throw` alla riga 1
**non ferma la riga 2** (difetto n.21 della checklist).

> ⚠️ **PC DI BACKTEST, MT5 CHIUSO. Mai sul VPS.**
> ⚠️ **UNA MACCHINA, UN LAVORO: R92 dev'essere FINITO.**
> ⚠️ **CONGELAMENTO DEL BRANCH:** `walkforward_generico.ps1` riscarica l'EA da
> `lavoro` **HEAD** ignorando il pin (difetto n.24). Lo script se ne accorge e
> **si ferma** se HEAD e il pin divergono. Quindi: **nessun push su `lavoro`
> mentre R93 gira.** Se qualcuno pusha, o si riallinea il pin, o si rilancia
> con `-Rif lavoro` **dichiarandolo**.

### 🅾️ BLOCCO 1 — PASSO 0: le barre M1 (MT5 chiuso, 10-40 minuti)

```powershell
& { $ErrorActionPreference='Stop'; $p="$env:USERPROFILE\scarica_storico.ps1"; Remove-Item $p -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/d78af56/backtest_pipeline/scarica_storico.ps1" -OutFile $p -EA Stop; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'scarica_storico.ps1' -Quiet)){ throw 'SCRIPT VECCHIO O SBAGLIATO' }; Remove-Item "$([Environment]::GetFolderPath('Desktop'))\storico_bcm\ABTG_StoricoScaricato.csv" -Force -EA SilentlyContinue; $global:LASTEXITCODE=0; & powershell -ExecutionPolicy Bypass -File $p -Auto -SenzaTick -Da 2021.01.01 -Simboli "GBPUSD,USDJPY,EURUSD" -TimeoutMin 240; if($LASTEXITCODE -ne 0){ throw "PASSO 0 FALLITO ($LASTEXITCODE)" }; $c="$([Environment]::GetFolderPath('Desktop'))\storico_bcm\ABTG_StoricoScaricato.csv"; if(-not (Test-Path $c)){ throw 'IL REFERTO NON E STATO PRODOTTO' }; Write-Host "`n=== RIGHE M1 (e' quello che il modello 1 usa davvero) ==="; Import-Csv $c | Where-Object { $_.Timeframe -eq 'M1' } | Format-Table Simbolo,Timeframe,Barre,PrimaDataLocale,PrimaDataServer,Verdetto -AutoSize }
```

**Cosa deve uscire:** tre righe `M1`, una per cross.
- `PrimaDataServer` **<= 2021.01.04** su tutte e tre → si prosegue.
- Se una parte dopo → **la finestra si sposta**, e si rifa' l'aritmetica del
  campione (par. 4.2). **Non si interpreta.**
- `Verdetto` diverso da `COMPLETO` → il broker ce l'ha ma il **disco** no:
  si rilancia il blocco finche' dice COMPLETO, altrimenti la prima passata
  esce con pochissime operazioni e nessuno sa perche'.
- **Niente `-SenzaTick`? Non serve:** R93 e' a modello 1. Ed e' anche cio' che
  evita il difetto n.30 (il guardiano di progresso che ammazza MT5 durante lo
  scaricamento dei tick, quando il CSV per costruzione non cresce).

### 1️⃣ BLOCCO 2 — installare i due EA e il Guardian, POI COMPILARE A MANO

```powershell
& { $ErrorActionPreference='Stop'; $p="$env:USERPROFILE\lancia_r93.ps1"; Remove-Item $p -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/d78af56/backtest_pipeline/lancia_r93.ps1" -OutFile $p -EA Stop; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R93-LANCIO-v1' -Quiet)){ throw 'SCRIPT VECCHIO: la cache di raw tiene ~5 minuti, riprova fra poco' }; $global:LASTEXITCODE=0; & powershell -ExecutionPolicy Bypass -File $p -Rif d78af56 -SoloControllo; if($LASTEXITCODE -ne 0){ throw "GIRO A VUOTO FALLITO ($LASTEXITCODE): NON si lancia il round" }; Write-Host "`n=== GIRO A VUOTO OK. Adesso i tre gesti a mano del blocco 3. ===" -ForegroundColor Green }
```

Il giro a vuoto **non apre MT5**: scarica tutto, installa
`ABTG_PausaGuardian.mqh`, mette il calendario in `Common\Files`, fa il PASSO 0
e stampa le 14 anteprime `.ini`. **Si legge quello che stampa**, in particolare:
- `InpSymbols` = **`USDJPY;EURUSD;GBPUSD`** (ordine diverso dal default: e' il
  canarino del pin, par. 11). Se dice `GBPUSD;USDJPY;EURUSD` **ci si ferma li'**.
- `FromDate` / `ToDate` dentro `2021.01.04 → 2025.12.19`.
- le celle news con `InpNewsFile=abtg_news_2021_2025_UTC.csv` e `InpNewsCommon=1`.

### 2️⃣ BLOCCO 3 — I TRE GESTI A MANO (non sono automatizzabili, e vanno fatti)

1. **MetaEditor → F7 su `ABTG_FiboH4_Corso.mq5`** e su `ABTG_FiboH4_Multi.mq5`.
   **0 errori, 0 warning.** `ABTG_FiboH4_Corso.mq5` **non e' MAI stato
   compilato** e chi lo ha scritto **non ha MetaEditor**: qualche errore di
   battitura e' plausibile, e va corretto prima, non a corsa avviata.
   ⚠️ Se MetaEditor era gia' aperto, **chiudilo e riaprilo**: il suo Navigatore
   mostra l'albero fotografato all'apertura e i file nuovi non ci sono
   (difetto n.27-bis).
2. **Strategy Tester → UN TEST SINGOLO** di `ABTG_FiboH4_Corso` su GBPUSD H4,
   un mese qualsiasi, `InpAutoTest = true`. **F7 compila e basta: l'autotest si
   legge ESEGUENDO** (difetto n.20). Nella scheda *Esperti* devono uscire
   `0 casi falliti` e questa riga:
   ```
   [FIBOCORSO][AUTOTEST] geometria su pattern 100-110 (range 10): target100=100.00 | EZ1 [98.20 - 99.20] | EZ2 [88.20 - 89.20] | banda=1.00
   ```
   🚫 **MAI attaccare l'EA a un grafico** per leggere quelle righe: sul PC di
   backtest il terminale e' collegato al **conto vivo**, e il 14/08 e' partito
   un ordine vero proprio cosi'.
3. **Un test singolo di `ABTG_FiboH4_Multi` con `InpUseNewsFilter=true`** e
   `InpNewsFile=abtg_news_2021_2025_UTC.csv`, su un mese del 2022. Nella scheda
   *Esperti* deve uscire:
   ```
   [FIBOH4][NEWS] letto da Common\Files | eventi utili 2971 (impatto >= 3) | ...
   [FIBOH4][NEWS] primo evento 2021.01.04 ... | ultimo evento 2025.12.19 ...
   ```
   🔴 Se dice **`FILTRO ACCESO MA CIECO`**, oppure `eventi utili 0`, **si passa
   al PIANO B (par. 8) e non si lancia il round**: sarebbe una notte di
   macchina per misurare un filtro spento.
   ⚠️ **In OTTIMIZZAZIONE MT5 non stampa le `Print` degli agenti**: questa prova
   si fa in **test singolo**, non nella griglia.

### 3️⃣ BLOCCO 4 — IL ROUND (68 passate)

```powershell
& { $ErrorActionPreference='Stop'; $p="$env:USERPROFILE\lancia_r93.ps1"; if(-not (Test-Path $p)){ throw 'lancia il BLOCCO 2 per primo' }; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R93-LANCIO-v1' -Quiet)){ throw 'SCRIPT VECCHIO' }; $global:LASTEXITCODE=0; & powershell -ExecutionPolicy Bypass -File $p -Rif d78af56; $rc=$LASTEXITCODE; $z="$([Environment]::GetFolderPath('Desktop'))\R93_FIBOH4.zip"; if(-not (Test-Path $z)){ throw 'LO ZIP NON C E: la corsa non e arrivata alla raccolta' }; $eta=(New-TimeSpan -Start (Get-Item $z).LastWriteTime -End (Get-Date)).TotalMinutes; if($eta -gt 15){ throw ("ZIP STANTIO: ha " + [int]$eta + " minuti, non e di adesso") }; if($rc -ne 0){ Write-Host "ESITO PARZIALE: mandalo lo stesso, ma di' QUALE pezzo manca (lo scrive REFERTO_R93.txt)" -ForegroundColor Yellow }; Write-Host ("`nMANDA IN CHAT: " + $z) -ForegroundColor Cyan }
```

**Durata stimata:** 68 passate OHLC M1 su ~5 anni di H4. **[STIMA, non
misurata]** 1-3 minuti a passata → **1-3 ore**. Si puo' spezzare:
`-Gamba A` (24 passate) e `-Gamba B` (44 passate) in due sere.
Il `throw` sullo zip guarda **l'artefatto e la sua eta'**, non solo il codice
d'uscita (difetto n.26-bis): un esito parziale **e' gia' una risposta**, e lo
zip va mandato lo stesso.

### 4️⃣ BLOCCO 5 — cosa deve esserci nello zip, per nome

`Desktop\R93_FIBOH4.zip` deve contenere:
- **28 CSV** `ABTG_FiboH4_<Multi|Corso>_<SYM>_<IS|OOS>_ohlc_<tag>.csv`
  — **12 della gamba A** (6 file prova x IS/OOS, tag `r93a`..`r93f`) e
  **16 della gamba B** (8 file prova x IS/OOS, tag `r93g`..`r93j`).
  ⚠️ **28 CSV, 68 passate:** ogni CSV contiene **le celle del suo asse**, una
  riga per cella. Chi conta i FILE aspettandosi 68 crede che manchi meta'
  round. `REFERTO_R93.txt` elenca i 28 nomi attesi, uno per uno;
- le serie **per-trade** `pertrade_*.csv` da `Common\Files`;
- **`REFERTO_R93.txt`** — e la sua riga `data:` **deve essere di ADESSO**;
- **`R93_CRITERI.md`**, cosi' i numeri viaggiano coi criteri che li giudicano.

Se manca qualcosa, `REFERTO_R93.txt` lo elenca sotto **`MANCANTI`**: si legge
quello **prima** di aprire i CSV.

