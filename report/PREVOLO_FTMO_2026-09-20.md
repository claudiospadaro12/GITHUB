# 🛫 PREVOLO FTMO — la sonda che apre le sei caselle **prima** che si tocchi un grafico

> data: 2026-09-20 (notte) · script `backtest_pipeline/righe/PREVOLO_FTMO.ps1`
> pin `e09296b9` · marcatore `MARCATORE_PREVOLO_FTMO_v1` · riga:
> `backtest_pipeline/righe/RIGA_PREVOLO_FTMO_DA_MANDARE.md`
> Perimetro: **sola lettura**. Non scrive dentro nessun terminale, non tocca processi,
> non nomina il conto reale **10105439** se non per **escluderlo**.

---

## ① 🎯 IN UNA RIGA, e senza abbellire il numero

**La sonda non chiude sei caselle su sei, e chi lo promettesse mentirebbe.**
Quello che fa è un'altra cosa, e vale di più di una promessa: **trasforma sei letture
cieche in quattro numeri da copiare e due fatti certificati**, e per ognuno dei quattro
stampa **prima** la tabella che dice **che cosa cambia** se quel numero è diverso da quello
che abbiamo ipotizzato.

| | conto |
|---|---|
| ✅ **chiuse dalla sonda, da sole** | **1** — la **n.2 (nomi dei simboli)**, *e solo se* il terminale ha già scaricato la lista: la sonda dichiara quanti mercati su cinque ha chiuso (0/5 … 5/5) |
| 🟠 **mezze** | **1** — la **n.6**: numero di conto e **nome del server** sono certificati dal disco; **leva, valuta, saldo** no |
| ✍️ **a mano, ma guidate** | **4** — n.1 (orologio), n.3 (margine), n.4 (`Digits`), n.5 (spread) |
| 🔓 **diventano 4 chiuse su 6** | se si fa il passo del §⑨ (uno **script MQL5 di sola lettura**, 2 minuti): la sonda **legge già** il CSV che produce |

---

## ② 📋 LA TABELLA DELLE SEI CASELLE

| # | casella | esito | **chi la chiude, e come ESATTAMENTE** | 🔴 che cosa cambia se il numero è diverso |
|---:|---|---|---|---|
| **1** | **orologio del server** | ✍️ **a mano, guidata** | La sonda stampa: ora di Windows, **fuso di Windows** (e verifica che sia compatibile con l'ora italiana, altrimenti **dichiara aperta** la casella), ora UTC, e **una riga per ogni fuso possibile** con l'ora che ci si aspetta di leggere e il **verdetto**. Tu leggi **un** numero: Market Watch (Ctrl+M) → tasto destro → Colonne → **Ora**. Controprova: ora dell'**ultima candela** su un grafico M1 | `+2` → **i dieci preset FTMO vanno bene**. `+3` → **vanno rigenerati** (`rimappa_preset_ftmo.py`, −1 ora). `0`/`+1` → si butta tutta la colonna FTMO. 🔴 **Sbagliare qui è certo, non sfortunato**: il DAX formerebbe il range a mercato chiuso |
| **2** | **nomi dei simboli** | ✅ **chiusa dalla sonda** (condizionata) | Legge **tre fonti di disco**: i nomi di **cartella** sotto `bases\<server>\history` e `\ticks` (nomi veri, scritti da MT5), le **parole** dentro i file di servizio di `bases\` (ASCII **e** UTF-16), e le righe `symbol=` dei `.chr` dei grafici aperti. Poi confronta con un **dizionario** dei cinque mercati. **Zero candidati → lo dice. Più d'uno → li elenca e NON sceglie** | Senza il nome vero **nessun grafico si apre**, e un nome sbagliato (`US30` vs `US30.cash`) apre la sedia su uno **strumento diverso**. La fonte che vince su tutto resta **Ctrl+U** (Visualizza → Simboli) |
| **3** | **margine per lotto** | ✍️ **a mano** | **Non è in nessun file di testo**, e lo dichiaro invece di inventarlo. Market Watch → tasto destro sul simbolo → **Specifica** → riga **Initial margin**. La sonda stampa il **modulo da riempire** (7 campi) | È il numero che decide **quante sedie entrano**. La flotta mista risulta al **140,6 %** del conto a 1:15: se è quello, **la rosa si riduce PRIMA di accendere**, non dopo il primo `not enough money` |
| **4** | **`Digits` / `_Point`** | ✍️ **a mano** | Specifica → riga **Digits**. 🟢 **Ma la sonda fa il pezzo difficile**: legge i preset **già sul disco** e stampa ogni valore *in punti* con le tre letture possibili — `Digits=1`, `2`, `3` | `InpBufferPoints=1000` su `U30USD` (`Digits=2`) vale **10,00** punti indice; con `Digits=1` vale **100,0**: il livello di rottura si sposta di **dieci volte** e la sedia entra al prezzo sbagliato (o non entra mai) |
| **5** | **spread** | ✍️ **a mano** | Market Watch, colonna **Spread**, letta **nell'istante in cui la sedia entra** (apertura di mercato), non a mercato fermo. La sonda elenca **quali preset hanno `InpMaxSpread=0`**, cioè **filtro spento** | Frontiera di casa: **stop ≥ 40 × spread**. Con il filtro spento la sedia entra anche col libro largo: il costo si mangia il vantaggio senza che nessun log lo dica |
| **6** | **tipo di conto e leva** | 🟠 **mezza** | ✅ **Dal disco**: numero di conto (certificato **dal giornale**), **nome del server** (cartella sotto `bases\`), righe `Server=`/`Login=` dei `config\*.ini` (**lista bianca**: nessuna riga di password viene letta né stampata). ✍️ **A mano**: leva, valuta, saldo (Ctrl+T → Trading; leva nell'area clienti FTMO) | 🟢 **Controprova che non costa niente e vale più di uno screenshot**: *Initial margin* del Dow per 1 lotto. Con Dow a 46 000 → **1:100 ≈ 460 $**, **1:15 ≈ 3 067 $**. Due numeri che non si somigliano: la Specifica risponde da sola |

---

## ③ 🔐 COME SCEGLIE IL TERMINALE — **riuso**, non riscrittura

La scoperta è quella di `SCHIERA_FTMO.ps1` (pin `489f98c0`, `MARCATORE_SCHIERA_FTMO_v2`),
**ripresa così com'è** perché ha già retto 13 contro-esempi: sette **hash noti** esclusi,
`origin.txt` che non deve nominare BCM/Pepperstone/Tickmill/MT5_Backtest/MT5_MANUALE,
il **giornale** (`<dati>\logs`, non `MQL5\Logs`) che deve contenere **`-ContoAtteso` E la
parola FTMO**, e il rifiuto su **zero** o **più di una** candidata.

### 🧪 I contro-esempi, **eseguiti** (pwsh 7.4.6, alberi finti, non ragionati a mente)

| # | caso costruito | esito osservato | uscita |
|---:|---|---|---|
| 1 | **zero candidate** (solo le cartelle di casa) | «ESCLUSA … = 50503392 / 10105439» + le **4 cause possibili** in chiaro | **1** |
| 2 | **due candidate** confermate con lo stesso conto | le elenca e **rifiuta**: *«non so quale terminale stai guardando»* | **1** |
| 3 | 🔴 **la candidata è il REALE** (hash `E23E…`, e nel giornale **c'erano** il numero e la parola FTMO, messi apposta come esca) | **esclusa per HASH prima di leggere il giornale**: l'esca non è servita a niente | **1** |
| 4 | **`-ContoAtteso` assente dal giornale** | scartata, con la spiegazione *(login appena fatto / numero sbagliato)* | **1** |
| 5 | **terminale senza giornale** (`logs` inesistente) | «giornali 0 … non trovato → scartata» | **1** |
| 6 | 🔴 **la riga intera col segnaposto non sostituito** (`IL_TUO_CONTO_FTMO`) — eseguita **davvero**, scaricando dal pin | *«è ancora il SEGNAPOSTO della riga di lancio»* | **1** |
| 7 | `-ContoAtteso` = **10105439** (il reale) | *«è UN CONTO DI CASA, non FTMO»* | **1** |
| 8 | `-ContoAtteso` non numerico (`15109-99`) | *«non è un numero di conto»* | **1** |
| 9 | ✅ **caso buono**: una candidata FTMO, `bases\FTMO-Demo2` con 6 simboli, un `.chr`, un preset, `config\common.ini` **con dentro una password finta** | referto completo; **la password NON compare da nessuna parte**; DAX/Oro/USDJPY **candidato unico**, Dow e Nasdaq **2 candidati → non sceglie** | **2** |
| 10 | come sopra **+** `MQL5\Files\PREVOLO_FTMO_specifiche.csv` | caselle **3-4-5 chiuse dalla sonda**, aperte 3 su 6 | **2** |

🟢 E la riga è stata provata **per intero** (`irm` dal pin + controllo del marcatore + esecuzione
+ messaggio finale) in tutti e due i rami, **1** e **2**.

---

## ④ 🔍 I RILIEVI `[457]` DEL CANCELLO, letti uno per uno

Il cancello deterministico dà **`ESITO: nessun difetto meccanico`** e **5 rilievi**, tutti
della stessa famiglia: *«nomina un conto di casa dentro una stringa: bersaglio o guardia?»*.
Li ho riletti a mano, riga per riga:

| rilievo | riga | che cos'è davvero |
|---|---|---|
| `50504263` in stringa | **r.93** | valore della tabella **`$HASH_NOTI`**: è l'**etichetta** della cartella dati del 100k, e sta lì per essere **stampata come ESCLUSA**. 🟢 **Guardia** |
| `BCM_Reale` + `10105439` in stringa | **r.94** | idem, ed è la riga del **REALE**: marcata `*** REALE ***` proprio perché salti all'occhio nell'elenco delle escluse. 🟢 **Guardia** |
| `50504263` e `10105439` in stringa | **r.101** | array **`$CONTI_DI_CASA`**: serve a **rifiutare `-ContoAtteso`** se per sbaglio contiene uno di quei numeri (contro-esempio 7). 🟢 **Guardia** |

🔴 **E la prova che sono guardie, non bersagli, non è la mia parola**: in tutto il file non
esiste **nessuna** scrittura verso una cartella dati — `New-Item`, `Copy-Item`,
`WriteAllText` e `Compress-Archive` puntano **solo** a `$CARTREF`, che nasce da
`$env:USERPROFILE\Desktop`. E il contro-esempio **3** mostra il reale **escluso** con l'esca
nel giornale.

---

## ⑤ 🪞 I DIFETTI CHE HO TROVATO A **ME STESSO**, e corretto **prima** di consegnare

Non sono aneddoti: sono usciti **eseguendo** la sonda, non rileggendola.

1. 🔴 **`UTC+-2`.** Sulla macchina di prova (fuso UTC+0) la tabella dei fusi stampava
   `UTC+-2` e `UTC+-1`: concatenavo `'UTC+'` con un numero **già negativo**. Su un VPS in
   ora italiana il caso non capita quasi mai — e infatti è esattamente il tipo di difetto
   che si scopre solo provando in un fuso diverso. Corretto con **una funzione sola**
   (`Fuso($h)`) usata da tutti i punti di stampa.
2. 🔴 **`InpMaxSpread` dentro la tabella dei `Digits`** (è la **classe 478** applicata a me):
   lo pescavo per **nome** insieme agli altri `Inp*Pts`, ma `InpMaxSpread` **non è un livello
   da riscalare**, è un **tetto**. Ora sta nel paragrafo dello spread, dove la sonda dice
   **quali preset hanno il filtro spento** (`=0`).
3. 🟠 L'etichetta della tabella veniva **troncata in testa** (`_Apertura_US_770202_FTMO`),
   nascondendo di quale EA fosse il preset. Ora si accorcia **in mezzo**
   (`ABTG_Dow_Ape~S_770202_FTMO`).
4. 🟠 Il conteggio finale diceva *«6 caselle su 6 restano a mano»* anche quando due erano
   **mezze**: un numero che descrive male la realtà è un errore di misura come gli altri.
   Ora stampa `CONTO: X chiuse, Y mezze, Z a mano`.

---

## ⑥ 🔴 LA TRAPPOLA DI **STASERA**, ed è una classe nuova

**Oggi è domenica.** Il passo 4 del pacchetto di schieramento dice — giustamente — *«leggi
l'ora del server in Market Watch e confrontala con Windows»*. 🔴 **Ma a mercato chiuso la
colonna Ora di Market Watch non dice che ore sono: dice quando è arrivato l'ULTIMO TICK**,
che di domenica pomeriggio è **di venerdì sera**.

E il modo in cui fa male è subdolo: l'ora di chiusura del venerdì (23:00 server per gli
indici) **sembra un'ora plausibile**. Chi legge solo `HH:MM` può concludere un fuso —
**sbagliato** — e poi rigenerare dieci preset sopra quella conclusione.

✅ **La difesa, ed è dentro la sonda in rosso**: *guarda la **DATA** accanto all'ora. Se non
è quella di oggi, la lettura non vale e la casella resta **aperta**.* Gli indici riaprono
la **domenica sera**: la lettura richiede 10 secondi e si fa **prima** di accendere
AutoTrading, non prima di installare.

📌 Parentela: è cugina della **267** (*«l'ora letta senza il giorno»*) e della nota di casa
sul `TimeCurrent()` che **si congela** a mercato fermo. La differenza — e il motivo per cui
merita un numero suo — è che qui a congelarsi è **l'orologio che legge l'essere umano** per
prendere una decisione che vale **dieci file di configurazione**.

---

## ⑦ 🧭 IL PROBLEMA **H4** DI `770202` — e la via più corta, che è più corta della tua

### Il fatto, verificato nel sorgente (non nel preset soltanto)

`ABTG_Dow_Apertura_US.mq5` r.403-406 e r.1495-1502: con `InpUseEmaFilter=true` il bias è

```
bias = segno( EMA(InpEmaFast=1)  -  EMA(InpEmaSlow=50) )   sulle chiusure di InpFilterTF
CopyBuffer(..., shift 1, ...)  ->  l'ULTIMA BARRA CHIUSA
```
cioè: **la chiusura dell'ultima barra H4 chiusa contro la EMA50 delle chiusure H4**.

### Perché le due griglie non sono la stessa cosa — con l'orologio alla mano

Le barre H4 sono ancorate alla **mezzanotte del server**:

| | griglia H4 (in UTC) | all'istante d'ingresso (**13:30 UTC** = 14:30 BCM = 16:30 FTMO) |
|---|---|---|
| **BCM** (UTC+1) | 23, 03, 07, 11, 15, 19 | barra aperta 11→15; **ultima CHIUSA: 07:00→11:00 UTC** |
| **FTMO** (UTC+3) | 21, 01, 05, 09, 13, 17 | barra aperta 13→17; **ultima CHIUSA: 09:00→13:00 UTC** |

👉 Il filtro guarda una chiusura di **11:00 UTC** su BCM e di **13:00 UTC** su FTMO: **due
ore di prezzo in più**, su **tutta** la serie della EMA50. Quando il prezzo sta vicino alla
media, **il segno può essere opposto** — e su una sedia **solo-long** un bias opposto non
peggiora l'ingresso: **lo cancella**.

### 🔴 Dal repo non è misurabile, e l'ho verificato io

Cercato: nessuna serie OHLC di `U30USD` in repo. I file `*_H4_OHLC*.csv` e
`*_H1_OHLC*.csv` dell'archivio **non sono prezzi**: sono **griglie di ottimizzazione**
(`Pass, Profit, Profit Factor, …` — verificato aprendone l'intestazione). `OHLC` lì dentro
è il **modello di test**, non il contenuto.

### 🥇 LA VIA PIÙ CORTA — e **non ha bisogno di FTMO**, quindi è rispondibile **subito**

**L'intuizione chiave: una barra H4 è l'unione di 4 barre H1.** Due griglie sfalsate di
**2 ore intere** sono **due raggruppamenti diversi delle STESSE barre H1**. Quindi:

1. ✍️ **3 minuti di Claudio**, sul **banco `50504400` (`C:\MT5_Backtest`)** — 🚫 non sul
   reale, 🚫 non sul conto FTMO: aprire un grafico **`U30USD` H1**, premere **Home** per
   caricare lo storico, poi **tasto destro → Salva con nome…** (CSV).
2. 🤖 **~20 minuti miei**: uno script offline che dalla **stessa** serie H1 costruisce
   **tutte e due** le griglie H4 (ancoraggio UTC+1 e UTC+3), calcola la **EMA50** su
   ciascuna e confronta il **segno del bias** alle **13:30 UTC** di ogni seduta.
3. 📤 Esce **un numero solo**: *«su N sedute il bias è OPPOSTO nel X % dei casi»*, più
   l'elenco delle date. Quello è il costo vero del cambio di griglia, isolato dal feed.

🟢 **Perché questa strada batte quella del backtest su FTMO**: isola **la griglia**. Un
backtest sul terminale FTMO cambia **insieme** griglia, feed, spread e commissioni: se i
numeri differiscono non sai **quale** dei quattro ha parlato (è la classe di casa del
«verificare contro il nulla invece che contro l'ipotesi alternativa»).

### 🥈 E la tua idea **regge lo stesso, come CONTROPROVA** — ecco costo e limiti

Sì: una volta installato e compilato (F7 già previsto), il terminale FTMO **può** girare
lo Strategy Tester sulla **sua** griglia e sul **suo** feed. Costo: lo scarico dello storico
M1 del Dow FTMO (quanti anni ce ne siano **si misura**, non si assume: FTMO è un feed
simulato e la profondità **non è nota**) + una corsa su `1 minute OHLC` (minuti, non ore).
Vale come **conferma end-to-end** («la sedia, lì, si comporta ancora così?»), **non** come
misura isolata del problema H4. 🔴 E **non** è la prima cosa da fare stasera: la prima è
l'orologio.

### ❌ Quello che **non** si fa

Spegnere `InpUseEmaFilter` per togliere l'ambiguità: quel filtro è **il** motivo per cui la
sedia ha PF 1,24 invece di 1,03 e DD 6,9 % invece di 14,9 % (r.259 del sorgente).
Spegnerlo **cambia il contratto misurato** → è una **firma di Claudio**, non un aggiustamento.

---

## ⑧ 🚧 QUELLO CHE **NON** HO POTUTO VERIFICARE, e lo dichiaro

1. **Non ho un terminale FTMO** su cui provare: i dieci casi sono stati eseguiti su **alberi
   finti** costruiti da me. La struttura riprodotta (`origin.txt`, `logs\*.log`,
   `bases\<server>\history\<SYM>`, `MQL5\Profiles\Charts\*.chr`, `config\common.ini`) è
   quella già letta in casa da `SCHIERA_FTMO`, `CODA_01`, `CODA_08` e
   `RIGA_CENSIMENTO_MT5_MACCHINA` — 🔴 ma **il layout interno di `bases\` di FTMO non l'ho
   visto**: se le sue cartelle simbolo non esistono ancora, la casella 2 esce **vuota**, non
   sbagliata (ed è il comportamento voluto).
2. **Parse reale: fatto** (`Parser::ParseFile`, 0 errori) ed esecuzione fatta, **ma su pwsh
   7.4.6**, non su **Windows PowerShell 5.1**. Mitigazione: il cancello certifica *«nessun
   costrutto pwsh-7-only»*, il file è **ASCII puro**, non usa operatori ternari, `&&`/`||`,
   `??`, `-AsHashtable`, né `-LeafBase`.
3. **La cadenza esatta dei menu di MT5 in italiano** (Specifica/Specification, Colonne/Ora):
   le istruzioni riportano **tutte e due** le diciture; se il terminale FTMO fosse in
   inglese, la voce è quella tra parentesi.
4. **Gli indizi di fuso pescati dal giornale non sono un verdetto** e la sonda lo scrive:
   le righe `previous successful authorization` portano la data di un **accesso precedente**
   — lo scarto che stampano è la distanza fra due login, **non** il fuso. Sono marcate una
   per una.

---

## ⑨ 🔓 IL PASSO CHE CHIUDE **3-4-5 CON NUMERI**, e costa due minuti

Le specifiche di contratto **non stanno in nessun file di testo** (MT5 le tiene nei binari di
`bases\` e in memoria): per leggerle da PowerShell bisognerebbe **indovinare un formato**, e
indovinare qui è esattamente ciò che questa sonda esiste per non fare.

🟢 **Ma c'è una strada pulita, e la sonda è già pronta a riceverla.** Uno **script MQL5 di
sola lettura** (~40 righe: `SymbolInfoInteger/Double` su cinque simboli → `FileWrite`)
scrive `MQL5\Files\PREVOLO_FTMO_specifiche.csv`. **Costo**: 1 file + 1 F7 + trascinarlo su
un grafico = **2 minuti**. **Resa**: `Digits`, `Point`, contract size, tick value, **margine
iniziale vero**, stops level e **spread misurato** — numeri, non screenshot.
👉 `PREVOLO_FTMO.ps1` **legge già quel CSV** se lo trova, e le caselle 3-4-5 passano a
**CHIUSA DALLA SONDA** (contro-esempio 10: verificato). Lo script MQL5 **non è stato scritto
stanotte** perché esce dal perimetro di sola lettura che mi è stato dato: **è la prima cosa
da firmare** se stasera i numeri si vogliono misurati invece che fotografati.

---

## ⑩ ✅ COSA È ANDATO BENE, che un elenco di buchi descrive male la realtà

- La scoperta del terminale **non è stata riscritta**: 13 contro-esempi già pagati da
  `SCHIERA_FTMO` valgono ancora, e i miei 10 li confermano su un altro script.
- Il **REALE** è stato attaccato apposta con un'esca (contro-esempio 3) e ha retto **prima**
  di leggere il giornale.
- La **password finta** messa in `config\common.ini` **non è uscita** da nessuna parte: la
  lista bianca funziona.
- E la casella che più conta — l'**orologio** — oggi non era solo *non misurata*: era
  **impossibile da misurare bene** senza accorgersi della trappola della domenica. Adesso è
  scritta in rosso dentro la riga che Claudio lancerà.
