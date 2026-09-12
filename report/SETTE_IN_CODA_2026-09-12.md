# 🚦 SETTE IN CODA — il cancello di giudizio, e poi il lavoro
### sabato 12/09/2026, ~15:15-16:0x UTC · agente `controllo-preventivo`
### Runner sul VPS: **domenica 03:30**. Consegnato con largo margine.

---

## 🏁 IL VERDETTO IN UNA RIGA

# ✅ **PASS 7 SU 7** — e sono **in coda**, non "pronti per la coda".

**Non ho dovuto correggere niente.** È la prima volta che mi arrivano sette
file prova e ne passano sette: i quattro `R137*`/`R138a` e i tre `R139*`
**hanno già dentro** le cose che di solito devo chiedere io — l'attesa scritta
prima, la soglia col numero accanto, il contro-esempio costruito prima della
corsa, e i buchi dichiarati per nome invece che taciuti. 👏 Chi li ha scritti
ha fatto il mio lavoro prima di me, e si vede.

🔴 **Ma un PASS non è un elenco di "va bene".** Ho trovato **due difetti di
classe NUOVA**, e uno dei due sta **dentro lo strumento con cui il mandato mi
chiedeva di verificare** — cioè nel posto peggiore. Nessuno dei due blocca la
notte; tutti e due cambiano **come si legge il referto domattina**. Sono al
paragrafo 6, e sono in `CHECKLIST_RIGA_DI_LANCIO.md` come **281** e **282**.

| | |
|---|---|
| 🎯 **Cosa è in coda** | 7 round, **29 celle**, **58 passate** |
| 📍 **Dove** | **PRIMA di `CODA_12`**, deciso su un fatto misurato (par. 4) |
| 🔑 **Pin di coda** | `0c38419f6031a5a33f24b8357f0f75fbe869c695` |
| 🔑 **`$PIN` interno** | `23314d61d26ea7e15c01462e4c4549291cf6684d` (14º giro) |
| 🛡️ **Le 33 righe preesistenti** | **byte-identiche**, 0 perse, 19/19 ancora a `1445abf8` |
| 🚫 **Toccato in forward** | **niente**. Nessun EA, nessun preset, nessun terminale vivo |

---

## 1️⃣ 🤖 IL CANCELLO DETERMINISTICO — eseguito per primo, **DA SOLO senza pipe**

Regola di casa: i cancelli si eseguono **uno per volta, senza pipe** (classe
254), si **legge** l'uscita, e solo dopo si giudica. Rieseguito tutto da zero:
non ho ereditato il verde di nessuno.

### 1.a — `controlla_prova.py`, sette invocazioni separate
```
R137a_floorstop_allarga_770101_D30EUR.txt  ABTG_DAX_Apertura_EU.mq5  pin=81  7 celle  OK   EXIT 0
R137b_floorstop_salta_770101_D30EUR.txt    ABTG_DAX_Apertura_EU.mq5  pin=81  7 celle  OK   EXIT 0
R137c_parziale_770101_D30EUR.txt           ABTG_DAX_Apertura_EU.mq5  pin=81  2 celle  OK   EXIT 0
R138a_gemello_F40EUR_770101.txt            ABTG_DAX_Apertura_EU.mq5  pin=81  2 celle  OK   EXIT 0
R139a_EMA200_AUDJPY_H4_LS.txt              ABTG_EMA200.mq5           pin=43  4 celle  OK   EXIT 0
R139b_EMA200_GBPUSD_H4_LS.txt              ABTG_EMA200.mq5           pin=43  4 celle  OK   EXIT 0
R139c_FIBOH4_GBPUSD_unsimbolo.txt          ABTG_FiboH4_Multi.mq5     pin=46  3 celle  OK   EXIT 0
TOTALE: 29 celle, 58 passate, 0 problemi
```
🟢 E quel cancello fa una cosa che conta: confronta **ogni** nome `Inp...`
contro gli `input` del `.mq5` (`controlla_prova.py` r.76, *"input SCONOSCIUTO
all'EA"*). Quindi **81 + 81 + 81 + 81 + 43 + 43 + 46 nomi esistono davvero**
negli EA che gireranno. Non è una formalità: un nome storto viene ignorato in
silenzio dal tester e la cella misurata **non è quella scritta**.

### 1.b — `controlla_riga.py --oggetto ps1` sulla riga sottile
    OK   ASCII puro                                    OK   nessun costrutto pwsh-7-only
    OK   0 errori dal parser PowerShell vero           OK   formati .NET
    OK   param block RICONOSCIUTO                      OK   nessun Parse senza cultura
    ESITO: nessun difetto meccanico.                   EXIT 0

### 1.c — 🔤 **ASCII: contato in `python3`, non col `grep` rotto**
Il mandato avvisava, e ha ragione: `grep '[^\x00-\x7F]'` **senza `-P` è rotta**
e produce migliaia di falsi positivi. Contato sui byte:

| file | byte > 127 | righe coinvolte |
|---|---|---|
| tutti e sette i file prova | **0** | **0** |
| `RIGA_SOTTILE_ROUND.ps1` (dopo la mia modifica) | **0** | **0** |
| `CODA.txt` | **30** *(preesistenti)* | **7, tutte di COMMENTO** |

🟢 Sui sette non c'è nemmeno la classe 276 da dichiarare in piccolo: sono
**ASCII puro**, zero byte alti. Meglio del contesto generale (104 file prova su
680 ne hanno).
🟢 I 30 di `CODA.txt` sono **preesistenti e tutti su righe `#`**: **zero** su
righe eseguibili, misurato riga per riga. Non li ho toccati e non ne ho
aggiunti — **30 prima, 30 dopo**.

---

## 2️⃣ 🧠 IL GIUDIZIO — sette schede, e il **perché** del PASS

### 🔬 Quello che ho verificato su **tutti e sette**, prima delle schede

| controllo | esito |
|---|---|
| 🕐 **Ora SERVER, non italiana** | `InpSessionHour=8` sui quattro DAX/CAC (8, **non 9**). Sui `R139*` forex: `InpUseCutoff=false` su `R139a/b` → l'ora è **inerte**; `R139c` ha 17:45 ma è **copiata dal CSV d'archivio**, non scelta ora |
| 🔢 **Magic vergini** | `786201·786202·786203·786204·786205·771560·771561·772060` → cercati repo-wide su `.txt .ini .set .chr .mq5 .csv`: **0 collisioni**. Nessuna sedia viva, nessun altro file prova, e nessuna collisione **fra i sette** |
| 🏷️ **Etichette** | `r137a·r137b·r137c·r138a·r139a·r139b·r139c` → **0 collisioni** con le 21 già in coda (`canfrz·cemad02·cemad05·r120b*·r120e*·r126*·r127*·r132c·r133*·r136*`). E passano la lista bianca `^[A-Za-z0-9_.-]+$` |
| 📐 **Celle contate** | 7+7+2+2+4+4+3 = **29** → **58 passate**. Ricontato sulla sintassi `inizio\|\|inizio\|\|passo\|\|fine\|\|Y` **e** confermato dal driver eseguito |
| 🗓️ **Finestre** | ricavate **eseguendo** il driver, non leggendo i commenti → par. 2.a |
| 🤖 **EA esistenti** | `ABTG_DAX_Apertura_EU` (2367 r.), `ABTG_EMA200` (690 r.), `ABTG_FiboH4_Multi` (1013 r.) |

### 2.a — 🎯 **CLASSE 278: le finestre RICAVATE ESEGUENDO IL DRIVER**

Il mandato è stato esplicito: *"Ricava le finestre **eseguendo** il driver
scaricato da `raw` con `-SoloControllo`, non leggendo i commenti."* Fatto —
scaricato il driver da `raw` al `$PIN` nuovo (sha verificato
`15DE7D5F…6828F1C6`) e lanciato **sette volte**:

```
r137c  IS 2024.09.26 - 2025.06.09   OOS 2025.06.10 - 2026.06.30   FrazioneIS 0.4   2 celle -> 4 pass
r137a  IS 2024.09.26 - 2025.06.09   OOS 2025.06.10 - 2026.06.30   FrazioneIS 0.4   7 celle -> 14 pass
r137b  IS 2024.09.26 - 2025.06.09   OOS 2025.06.10 - 2026.06.30   FrazioneIS 0.4   7 celle -> 14 pass
r138a  IS 2024.09.26 - 2025.06.09   OOS 2025.06.10 - 2026.06.30   FrazioneIS 0.4   2 celle -> 4 pass
r139a  IS 2010.01.01 - 2016.08.06   OOS 2016.08.07 - 2026.06.30   FrazioneIS 0.4   4 celle -> 8 pass
r139b  IS 2010.01.01 - 2016.08.06   OOS 2016.08.07 - 2026.06.30   FrazioneIS 0.4   4 celle -> 8 pass
r139c  IS 1999.01.04 - 2010.01.01   OOS 2010.01.02 - 2026.06.30   FrazioneIS 0.4   3 celle -> 6 pass
```

🟢 **Combaciano con quello che i file dichiarano, al giorno.** E il conto
aritmetico torna in modo indipendente: `2024.09.26 → 2026.06.30` = 642 giorni,
`floor(642 × 0,40)` = 256 → IS finisce il **2025.06.09**. Esattamente quello
che stampa il driver.

🔑 **E il pezzo che era il vero rischio**: **nessuno dei sette porta
`@FRAZIONEIS`** (verificato sulle righe **non-commento**: i tre `R139*` la
*nominano* solo dentro commenti, per dire che **non** ci si appoggiano finché
il canarino non ha parlato). Quindi tutti e sette girano col **default 0.40**
del driver (r.179) — che è **quello che serve**, perché è il taglio con cui è
stato misurato R47a: `183 / (183+265) = 0,408`. 🟢 Il caso `COLLAUDO_EMADOW_02`
— default `0.40` contro un `@FINOA` sul primo giorno dell'OOS, che avrebbe letto
*"sotto 150"* in **4 casi su 4 compresi i due in cui la sedia PASSA** — **qui
non si ripete**.

---

### 📋 SCHEDA 1 — `R137c_parziale_770101_D30EUR.txt` → ✅ **PASS**
**`r137c` · `-Modello 4` · `-Deposito 100000` · 2 celle · asse `InpTP1_ClosePct` (0, 50)**

**A che serve**: è **IL CANCELLO** del gruppo R137. La cella
`InpTP1_ClosePct=50` **è la cella VIVA** di `770101`, e deve riprodurre R47a.

- 🟢 **Attesa dichiarata PRIMA, ed è una riproduzione esatta**: IS
  `175 deal / PF 1,12634 / DD 5,4362%`, OOS `270 deal / PF 1,39709 / DD 7,2328%`.
  Non c'è niente da scoprire: **l'attesa è che tornino identici**, tolleranza
  **ZERO** sul conteggio e quarta cifra su PF e DD (C1).
- 🟢 **Classe 278 gestita**: C4 scrive che *"l'IS ha **132 POSIZIONI**, sotto il
  pavimento dei 150: l'IS serve al **SEGNO** e al **RISCHIO**, non al merito"*.
  Il merito lo porta l'OOS con **193 posizioni MISURATE**. 👉 L'esito positivo
  è **raggiungibile**: non è una condanna travestita da test.
- 🟢 **Perché spendere 4 passate per riprodurre**: il file lo spiega e il
  motivo regge — il driver compila dalla **testa del branch**, e fra R47
  (14/08) e oggi il sorgente ha preso il fix `ABTG_DEF_RISK 2.0→1.0` (02/09) e
  la correzione del trailing (11/09). *"Il rischio qui è PINNATO a 1,0 da riga,
  quindi il cambio di default NON deve mordere — ma questo si **VERIFICA**, non
  si crede."* 👏 Questa frase è il mestiere.
- 🟢 **C3 rischio**: nessuna cella con DD > 8,0% raccomandabile. Sotto il muro
  prop del 10% con 2 punti di margine.

---

### 📋 SCHEDA 2 — `R137a_floorstop_allarga_770101_D30EUR.txt` → ✅ **PASS**
**`r137a` · `-Modello 4` · `-Deposito 100000` · 7 celle · asse `InpMinStopPts` (800→12800, passo 2000)**

**A che serve**: chiude (o no) il requisito **R5 COSTO** della seconda sedia.
`InpSkipIfTight=false` → lo stop stretto viene **ALLARGATO**, non saltato.

- 🟢 **Il sorgente è stato letto, non ricordato**: `ABTG_DAX_Apertura_EU.mq5`
  r.345-346 e r.1493-1496 (ramo RETEST BUY, che è **il ramo vivo** perché il
  preset ha `InpEntryMode=2`). E la conseguenza è capita: con
  `InpMinStopPts=0` la condizione **corto-circuita** e `InpSkipIfTight` non
  viene mai letto → *in campo la sedia ha il cancello del costo **montato e
  spento da un solo numero***.
- 🟢 **FRONTIERA DEL COSTO, col numero — ed è il controllo che il mandato
  chiedeva.** Lo spread `D30EUR` all'ora modale 08 è **misurato su 30.974.789
  tick** (mediana **1,70 idx**, p95 **2,70**). Il file congela la tabella
  **prima** dei numeri:

  | floor pt | idx | min × @1,70 | min × @2,70 | verdetto congelato |
  |---|---|---|---|---|
  | 800 | 8,0 | **4,7×** | 3,0× | 🔴 **sotto il DURO 13,3×** |
  | 2800 | 28,0 | 16,5× | 10,4× | sotto il lavoro (40×) |
  | 4800 | 48,0 | 28,2× | 17,8× | sotto il lavoro |
  | 6800 | 68,0 | ⭐ **40,0×** | 25,2× | pavimento di lavoro, esatto |
  | 8800 | 88,0 | 51,8× | 32,6× | dentro |
  | 10800 | 108,0 | 63,5× | ⭐ **40,0×** | dentro **anche al p95** |
  | 12800 | 128,0 | 75,3× | 47,4× | dentro |

  🔑 **Le celle 800 / 2800 / 4800 sono ESCLUSE PER COSTO qualunque numero
  producano, e la 800 anche PER ARITMETICA** — scritto **prima**. Due celle
  cadono **esattamente** sulle due frontiere (68,0 × 1,70 = 40,0 ·
  108,0 × 2,70 = 40,0): l'asse è stato **costruito** per farle cadere lì.
  👉 **Per questo la riga va in coda invece di essere esclusa per costo**: non
  è un round che sfonda la frontiera, è un round che **misura dove sta la
  frontiera**, con le celle fuori costo già neutralizzate per dichiarazione.
- 🟢 **E la cella 800 fuori costo ha un compito diagnostico preciso**:
  `270 − Trades(800)` = **quante gambe della sedia viva avevano uno stop sotto
  8 idx** (cioè sotto 4,7×). Se è 0, la manopola è inerte e la cella
  **riproduce R47a gratis**. Se è > 0, è **una notizia sul rischio della sedia
  viva** e va in cima al referto. Una cella esclusa che misura comunque
  qualcosa non è uno spreco.
- 🟢 **A1 è RAGGIUNGIBILE** (e l'ho verificato, non dato per buono): servono
  ≥ 3 celle contigue con PF OOS ≥ 1,40 **e** posizioni OOS ≥ 150 **e**
  DD OOS ≤ 8,0% **e** ≥ 40×. Le celle ≥ 40× sono **quattro contigue**
  (6800·8800·10800·12800), e le posizioni OOS sono attese **invariate a 193**
  (il ramo ALLARGA non tocca la selezione). 👉 **3 su 4 disponibili: l'esito
  positivo esiste.** Non è classe 278.
- 🟢 **A2 dichiara l'asimmetria**: l'IS a 132 posizioni è **sospeso per
  costruzione**, serve al segno e al rischio.
- 🟢 **Il contro-esempio è costruito prima** (regola 10/09), e nominato: la
  cella 10800 che torna PF 1,55 sarebbe **tre artefatti sovrapposti** —
  sopravvivenza (21 mesi di indice in salita, l'orso non c'è), il TP che si
  sposta con lo stop (`TP1_R` è in R), e il confronto con la cella sbagliata.
  Con **quattro** discriminanti misurabili accanto. 👏

---

### 📋 SCHEDA 3 — `R137b_floorstop_salta_770101_D30EUR.txt` → ✅ **PASS**
**`r137b` · `-Modello 4` · `-Deposito 100000` · 7 celle · stesso asse, `InpSkipIfTight=true`**

**A che serve**: la domanda **opposta** di R137a. Qui lo stop stretto fa
**SALTARE** il trade: geometria invariata, **n che scende**.

- 🟢 **Questo è il file che mi ha convinto di più, e il motivo è
  controintuitivo**: dichiara **da solo, prima della corsa**, di **non poter
  dare un verdetto di merito**:
  > *"QUESTO ROUND NON PUÒ DARE UN VERDETTO DI MERITO, E LO SO ADESSO. Lo stop
  > mediano sulla geometria viva è 56,1 idx. Un floor a 68 idx è SOPRA la
  > mediana: per costruzione salta PIÙ DELLA METÀ delle operazioni. 193
  > posizioni OOS diventano ~90 o meno."*
- 🔑 **E questa NON è classe 278**, e la distinzione è tutto il punto. La 278
  punisce una misura che **non può dare una risposta positiva al proprio
  criterio**. Qui il criterio del round **non è il merito**: è *"il ramo SALTA
  preserva il campione?"*. Risposta **SÌ** o **NO**, entrambe raggiungibili, e
  la previsione scomoda è scritta: **NO**. 👉 Un round che chiude una **scelta**
  (*"il cancello del costo si accende solo nel ramo ALLARGA"*) è un risultato,
  non un round buttato. E quella scelta è **una firma di Claudio**, non una
  misura — il file lo dice.
- 🟢 **La monotonia attesa è dichiarata come cancello meccanico**: ogni floor
  più alto salta un **sovrainsieme** del precedente, quindi `Trades` **deve**
  calare in modo monotono. Se non lo fa, *"qualcosa non torna nel codice o nel
  conteggio, e quella è la notizia"*.
- 🟢 **Il contro-esempio, nominato**: *"una cella con PF 1,9 e 40 posizioni. È
  il numero più bello del gruppo e non vale niente."* E la contromisura è
  strutturale: il referto scrive **la colonna POSIZIONI prima della colonna
  PF**, di proposito.
- 🟢 **Confronto gratis che vale un cancello**: la cella 800 di `r137b` e la
  cella 800 di `r137a` differiscono **solo** per `InpSkipIfTight`. Se non
  esistono gambe sotto 8 idx **devono essere identiche al centesimo**. Se non
  lo sono, le gambe esistono — e il numero è misurato **due volte**.

---

### 📋 SCHEDA 4 — `R138a_gemello_F40EUR_770101.txt` → ✅ **PASS**, con **un [NON MISURATO] da leggere**
**`r138a` · `-Modello 4` · `-Deposito 100000` · 2 celle · asse `InpMagic` (786204, 786205)**

**A che serve**: la sedia `770101` fa **0,72-0,73 posizioni/giorno** contro il
pavimento **1,00 per FAMIGLIA**. `0,72 + 0,72 = 1,44`: **un solo simbolo in
più** porta la famiglia sopra il pavimento. Questo round misura se quel
secondo 0,72 esiste su **F40EUR (CAC 40)**.

- 🟢 **Ora server corretta**: `InpSessionHour=8`. Il CAC apre 09:00 IT = **08:00
  server**, come il DAX. Il file scrive anche la contromisura: *"se nel CSV la
  colonna `InpSessionHour` non è 8, il file va cestinato"*.
- 🟢 **F40EUR verificato da me nella sonda, non creduto**:
  `risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` r.68 →
  `F40EUR, CAC 40 Index CFD, … 2024.09.26, … COMPLETO`. **Stessa data di
  partenza di D30EUR e U30USD.**
- 🟢 **Casella LIBERA, non provata**: `risultati_archivio/DAX_Apertura/` ha 5
  CSV e sono **tutti D30EUR**. Nessun file di questa EA porta F40EUR. Contato.
- 🟢 **F1 è RAGGIUNGIBILE e il pavimento è basso di proposito**: ≥ **0,28**
  posizioni/giorno feriale in OOS, cioè *"il round chiede alla FAMIGLIA di
  arrivare a 1,00, non a F40EUR di essere un campione"*. Giusto.
- 🟢 **F3 rischio morde a qualunque n**: DD OOS > 10,0% → bocciato per rischio
  **qualunque frequenza abbia**.
- 🟢 **La previsione scomoda è scritta prima**: *"mi aspetto che F40EUR sia PIÙ
  LENTO del DAX"*. 🔎 **E io l'ho trovata confermata da un numero che il file
  non cita**: nella stessa sonda F40EUR ha **6.713 barre H1** contro le
  **10.553** di D30EUR sullo stesso periodo — **il 64%**. La direzione della
  previsione è quella giusta.
- 🟢 **F4 COSTO dichiarato [NON MISURATO] con la conseguenza operativa
  giusta**: lo spread di F40EUR non c'è (`spread_flotta/` ha 3 file su 13
  simboli, e F40EUR non è tra loro). Il file scrive: *">>> **NESSUNA SEDIA SU
  F40EUR SI ACCENDE PRIMA CHE QUEL NUMERO ESISTA**"*, e indica la via più corta
  (`ABTG_SpreadOrario` con `-PuntiPerIndice 100`, **zero passate di tester**).
  👉 Questo è il modo corretto di portarsi dietro un buco: **dichiarato +
  recintato + con il preventivo per chiuderlo**.
- 🟢 **La seconda trappola, ed è quella seria**: F40EUR e D30EUR **aprono allo
  stesso minuto**. Una famiglia a 1,44 pos/g fatta di due sedie che fanno **la
  stessa operazione nello stesso momento** ha frequenza doppia e
  **diversificazione ZERO**, col rischio aperto simultaneo raddoppiato. Il file
  **condiziona il verdetto**: *"R3 si chiude" si scrive solo se F1 passa **E**
  la sovrapposizione dei giorni è misurata*. Ed è esattamente il buco che il
  tetto per cluster **C10 al 3,0% — firmato il 07/09 e NON ATTIVO** — dovrebbe
  coprire.

🔴 **IL [NON MISURATO] CHE AGGIUNGO IO, e non c'era nel file — è la classe 282.**
Il file scrive *"LO STORICO C'È"* citando la sonda. Ma **quella sonda misura
BARRE H1, non TICK** (le sue colonne: `H1, 6713, 2024.09.26, …, COMPLETO`), e
questo round gira a **`-Modello 4`, cioè a TICK REALI**. Sono **due
profondità diverse**, e la casa lo sa già per il forex (pavimento **barre**
1999.01.04 contro pavimento **tick** 2024.07.05, tutti e due misurati) — ma per
gli indici le ha **confuse**.
- 🟢 **Perché comunque non boccio**: su `D30EUR` la stessa finestra a tick **è
  già girata per intero** (R47a, 270 deal), e i tre indici hanno **la stessa
  data d'inizio e lo stesso stato COMPLETO** nella stessa sonda. L'inferenza è
  ragionevole.
- 🔴 **Perché va comunque letto**: se i tick di F40EUR partissero più tardi, la
  **frequenza** — che è **l'unico criterio del round** — uscirebbe
  **sottostimata**, e `F1` fallirebbe per un **buco di dati**, non per il
  mercato. Sarebbe un **falso negativo** su un round che serve a chiudere R3.
- ✅ **Come si chiude domattina, e costa zero**: il driver **stampa la prima e
  l'ultima operazione**, e `CODA_12` stampa `close_time dal … al …`. 👉 **Se la
  prima operazione di F40EUR non è vicina al 2024.09.26 / 2025.06.10, la
  frequenza NON si legge come un fatto sul CAC.** È scritto anche nel driver
  stesso (r.937-938): *"sugli indici diceva 2024.01.01 e partiva dal 26/09/2024"*.

---

### 📋 SCHEDA 5 — `R139a_EMA200_AUDJPY_H4_LS.txt` → ✅ **PASS**
**`r139a` · `-Modello 1` · `-Deposito 10000` · 4 celle · asse `InpTP_RR` (1.5→3.0)**

**A che serve**: 🏆 **il PRIMO fuori campione della storia di `EMA200` a H4.**

- 🟢 **Ho verificato la premessa invece di crederla**:
  `risultati_archivio/EMA200/` contiene **solo** `H1_OHLC`, `H4_OHLC`,
  `realtick_H4` e `ANALISI_EMA200.md`. **Nessuno split.** Le 135 celle per
  simbolo a tick vengono da **una finestra sola, ottimizzata intera**
  (`ini/ABTG_EMA200.ini`: `Model=4`, `2024.01.01 → 2026.06.30`,
  `Deposit=10000`). 👉 **La premessa regge: questo motore non ha mai visto un
  OOS a H4.** E il round glielo dà **a due lati** (`InpAllowLong=true`,
  `InpAllowShort=true`).
- 🟢 **Cella = CENTRO dell'altopiano, MAI il picco — e l'ho ricontato sul CSV
  grezzo.** Il file dichiara il centro `O1=0,25 / O2=0,50` e dichiara che il
  picco *"sta altrove (`O1=0.30 O2=0.4 TP=1.5` → PF 1,845) e **NON È LA CELLA
  DI QUESTO ROUND**"*. Riaperto
  `valid_ABTG_EMA200_H4_realtick_AUDJPY.csv`: a `TP_RR=1.5` il massimo L+S è
  **PF 1,845 con `Order2Atr=0.4`**, e la cella del file ha `Order2Atr=0.5`.
  **Confermato: prende il centro e lascia il picco.** 👏
- 🟢 **Il numero di riferimento citato ESISTE, al quinto decimale.** Il file
  cita *"PF 1,623 DD 2,901 su 283 deal"*. Cercato nel CSV: **Pass 211** →
  `PF 1.62295 · DD 2.9009 · Trades 283 · TP_RR=2.0 · Order2Atr=0.5 · L+S`.
  🔑 E `TP_RR=2.0` **è dentro l'asse** di questo round: la cella di riferimento
  viene rimisurata. Non è una citazione di comodo.
- 🔑 **LA DOMANDA DEL MANDATO — "che cosa possono concludere quelle due righe,
  se i 255-347 trade sono 128-174 POSIZIONI, cioè sotto 150 anche senza
  split?"** La risposta è: **quel conto vale sulla finestra CORTA, non su
  questa.** I 128-174 sono su **24-30 mesi**. Questo round gira su **16,5
  anni**. Il file fa il conto prima:
  ```
  ~141 posizioni su 24-30 mesi  =  56-71 posizioni/anno
  su 16,5 anni:  totale atteso   930 - 1.163 posizioni
                 IS  (0,40)      372 -   466   >>> sopra 150
                 OOS (0,60)      558 -   699   >>> sopra 150
  ```
  👉 **È la PRIMA volta che questo motore vedrebbe il pavimento dei 150 in
  ENTRAMBE le finestre.** Quindi la risposta non è *"niente di decisivo"*: è
  **decisiva sul campione**, e **sospesa sulla promozione** — perché è
  `-Modello 1`, e un numero OHLC non è mai un verdetto (S6 lo scrive).
- 🟢 **CLASSE 226 gestita nel verso che fa male**: le soglie sono in **DEAL**
  proprio perché la corsia ROUND consegna `Trades`. `S1: n ≥ 300 DEAL in
  entrambe le finestre (= ~150 posizioni al fattore misurato 2,0117)`. 👉 La
  soglia è **tradotta**, non confusa. È l'opposto della classe 226.
- 🟢 **`-Modello 1` è GIUSTIFICATO con un numero, non per comodità**: il
  pavimento del tick forex è **2024.07.05 MISURATO** → su 16,5 anni **i tick
  non esistono**. *"a tick questa misura NON È FATTIBILE, e va detto subito."*
- 🟢 **S3 rischio a qualunque n**: DD ≤ 14,0% @1,0% (≈ 9,1% alla taglia di
  flotta 0,65%). **S4** intercetta *"REGIME, non edge"*. **S5** intercetta la
  **manopola inerte** — la classe trovata **874 volte su 1.960 CSV**.
- 🟢 **Buchi dichiarati per nome**: pavimento storico di AUDJPY **[INFERITO]**
  (R102 ha misurato **sei** simboli e AUDJPY **non è tra quelli**); spread BCM
  su AUDJPY **[NON MISURATO]** — 🔑 **il mandato chiedeva di dirlo se è un
  presupposto della riga, e il file lo dice già**, con il contro-argomento
  onesto (*"il costo vero È GIÀ DENTRO i numeri a tick… su OHLC i PF di questo
  round sono OTTIMISTI di una quantità non misurata"*) e la via più corta
  (**RealCost Spread P95 Logger**, Code Base 74148, promosso il 23/08 e **mai
  usato**, segnalato da **sette** cacce).

---

### 📋 SCHEDA 6 — `R139b_EMA200_GBPUSD_H4_LS.txt` → ✅ **PASS**
**`r139b` · `-Modello 1` · `-Deposito 10000` · 4 celle · asse `InpTP_RR` (1.5→3.0)**

- 🟢 **È il gemello che lavora sull'ALTRO LATO** — e questo è il pezzo che la
  **regola dei due lati (25/08)** chiede. A tick la cella migliore di GBPUSD è
  **SHORT-only**, su AUDJPY è **LONG-only**: *"lo stesso motore cambia lato col
  simbolo: è un'informazione, non un dettaglio."*
- 🟢 **Pavimento storico MISURATO su questo simbolo**: prima operazione
  **1999.01.14** (R102 Blocco 1). Su GBPUSD la finestra lunga **è un fatto**.
- 🟢 **Altopiano verificato da me**: *"celle con i DUE LATI accesi: 24.
  POSITIVE: 24 su 24. PF da 1,147 a 1,348"*. Riaperto il CSV: le L+S a
  `TP_RR=1.5` stanno a PF 1,316 / 1,262 con 276-290 deal, e il **picco del
  simbolo (PF 2,066-2,254) è SHORT-ONLY** e **non è** la cella del round.
  👏 Centro, non picco — dichiarato **accanto** al numero, come chiede la regola.
- 🟢 **`S6` è il criterio che più mi è piaciuto di tutta la consegna**: *"Il
  default del sorgente è `InpTP_RR = 2,0` (`ABTG_EMA200.mq5` r.76). Se la cella
  migliore batte la 2,0 di meno di 0,05 di PF, la risposta onesta è **"IL
  DEFAULT VA BENE"** — ed è un risultato, non un fallimento."* ✅ **Citazione
  verificata**: r.76 è davvero `input double InpTP_RR = 2.0;`.
- 🟢 **L'attesa più scomoda della consegna, scritta prima**: *"dichiaro che
  l'esito più probabile è **UN PF INTORNO A 1,1**, cioè **A CAVALLO del
  cancello**. Scriverlo prima è quello che impedisce di leggere 1,12 come una
  promozione."* E DD atteso **10-20%** con la conseguenza dichiarata: *"se il DD
  esce oltre S3 questo candidato muore PER RISCHIO, e il PF non si discute
  nemmeno."* 👉 Un file che scrive in anticipo come **si suicida** è un file di
  cui si può leggere il referto.
- 🟢 Finestra confermata dal driver: **IS 2010.01.01-2016.08.06 · OOS
  2016.08.07-2026.06.30**. L'OOS contiene Brexit 2016, 2020 e il mini-budget
  2022 — cioè i regimi che il tick a 24-30 mesi **non ha mai visto**.

---

### 📋 SCHEDA 7 — `R139c_FIBOH4_GBPUSD_unsimbolo.txt` → ✅ **PASS**
**`r139c` · `-Modello 1` · `-Deposito 10000` · 3 celle · asse `InpEngulfLookback` (8, 12, 16)**

**A che serve**: chiudere il **"0/8" più falso dell'archivio**.

- 🟢 **LA PREMESSA È VERA, E L'HO RIAPERTA IO.**
  `ABTG_FiboH4_Multi_GBPUSD_OOS_ohlc.csv` ha **6 passate** e **tutte e sei**
  portano `InpSymbols = GBPUSD;USDJPY;EURUSD`. 👉 **È un basket contato più
  volte**, non otto simboli misurati. La premessa del round regge.
- 🟢 **LA CELLA È DAVVERO COPIATA DALL'ARCHIVIO, campo per campo — ricontato in
  `python3`.** Confrontati i **39 input confrontabili** contro il **Pass 3**:
  **coincidono tutti**, tranne esattamente le tre cose che **sono il round**
  (`InpSymbols GBPUSD`, `InpComment R139C`, `InpMagic 772060`) e le differenze
  di sola **notazione** (il CSV scrive `1/0`, il file prova `true/false`).
  Restano **6 input assenti dal CSV** (`InpNewsCommon`, `InpNewsPerCurrency`,
  `InpNewsCancelPendings`, `InpNewsDerogaPips`, `InpUsaGuardian`,
  `InpAutoTest`): sono input **aggiunti all'EA dopo** quel CSV, e sono tutti
  **inerti** qui — `InpUseNewsFilter=false` spegne i quattro news, il Guardian è
  fail-open nel tester, e `InpAutoTest` **stampa e basta** (letto: r.244 e
  r.302, `AutoTestFiboH4()`). 🔎 Lo dichiaro comunque: **quei 6 valori non sono
  verificati contro l'archivio**, perché la colonna non esiste.
- 🟢 **F0 È UN CANCELLO CHE LEGGE DAVVERO, e il verso è invertito di proposito**:
  se la cella `lookback=8` ridesse `profit 118,68 / PF 1,09427 / DD 3,7359 /
  82 deal`, **sta girando il basket**. ✅ **Verificato: sono esattamente i
  numeri del Pass 3.** 👉 Qui **l'identità è il SINTOMO DI GUASTO**, non la
  prova di determinismo — *"è il verso opposto del solito, e va scritto adesso
  perché è esattamente l'errore che nel 2026-08 ha prodotto un verdetto falso."*
  👏 Questo è un cancello costruito per **rompere** la propria risposta.
- 🟢 **CLASSE 278 gestita, ed è il caso più delicato dei sette.** Il file
  **dichiara in anticipo che l'IS non arriverà a 150**: `~132 posizioni`. E
  invece di far fallire tutto, **restringe il criterio alla finestra che può
  rispondere**: `F2 MERITO si applica SOLO alla finestra che supera 300 DEAL
  (~150 posizioni), cioè presumibilmente solo l'OOS`, atteso **360-440 deal**.
  👉 L'esito positivo **esiste, sull'OOS**. Non è una condanna travestita.
  E la dipendenza è **dichiarata, non subita**: *"`@FRAZIONEIS 0,50` porterebbe
  a ~165/165 e chiuderebbe il buco, MA quella direttiva è sotto CANARINO nella
  coda del 12/09… se il canarino dice ONORATA, questo file si riscrive con 0,50
  e il problema sparisce."*
- 🟢 **Dichiara che l'esito più probabile è un NO**: *"tre delle quattro letture
  d'archivio stanno sotto 1,00. Se esce un PF sopra 1,30 su entrambe le
  finestre, il primo sospetto è un baco, non una scoperta."*
- 🟢 **F3 è il CERTIFICATO DI MORTE scritto in anticipo, e scritto BENE**: se F2
  fallisce sull'OOS a campione pieno, il motore avrebbe **PF, n, DD, un simbolo
  vero e una finestra lunga** — restano fuori la voce **3 (uscita)** e la
  **5 (TF)**, *"e allora il verdetto sarà **"MORTO su GBPUSD H4, NON ANCORA
  MISURATO come famiglia"**, che è una frase diversa e va scritta diversa."*
  🎯 **Questo è esattamente il certificato di morte del 09/09 applicato prima
  della corsa.** È la cosa migliore di tutta la consegna.
- 🟢 **F4 blocca il curve-fitting in anticipo**: *"NON SI RIGRIGLIA L'INGRESSO.
  Se F2 fallisce, non si cerca un altro `InpEZ1ratio`/`InpEZ2ratio` sugli stessi
  dati: sarebbe il curve-fitting della regola del 19/08. Si cambia SIMBOLO o si
  cambia MECCANISMO."* ✅ È la regola della seconda caccia, rispettata.
- 🟢 **Tetto delle ~100.000 barre verificato da me**: 27,5 anni di H4 ≈ **43.000
  barre**, e 16,5 anni ≈ **36.000**. Tutti e tre i round lunghi stanno
  **dentro** il tetto. Nessuna corsa va spezzata in tranche.
- 🟢 **Buchi dichiarati**: fattore deal/posizione **[INFERITO]** a ~2 (*"questo
  EA non ha nessun file per-trade in archivio"* — 🔑 e il paragrafo 4 lo
  **chiude stanotte**); stop tipico in pip **[NON MISURATO]**, quindi la
  frontiera `40×` su questa geometria **non è verificata** e va letta dallo stop
  mediano nel referto.

---

## 3️⃣ 🚨 CLASSE 273 — il `-Modello`, verificato **uno per uno**

Il `-Modello` **non sta nel file prova**: arriva **dalla riga di coda**. Se
divergono, *"il referto della mattina mente"*. Confronto fra il **BANCO
dichiarato dentro ogni file** e la **riga che ho scritto io**:

| etichetta | banco dichiarato NEL FILE | riga che ho scritto | ✓ |
|---|---|---|---|
| `r137c` | `Modello 4 (TICK REALI). Deposito 100000` | `-Modello 4 -Deposito 100000` | ✅ |
| `r137a` | `Modello 4 (TICK REALI). Deposito 100000` | `-Modello 4 -Deposito 100000` | ✅ |
| `r137b` | `Modello 4 (TICK REALI). Deposito 100000` | `-Modello 4 -Deposito 100000` | ✅ |
| `r138a` | `Modello 4 (TICK REALI). Deposito 100000` | `-Modello 4 -Deposito 100000` | ✅ |
| `r139a` | `Modello 1 (OHLC M1) -- SCREENING. Deposito 10000` | `-Modello 1 -Deposito 10000` | ✅ |
| `r139b` | `Modello 1 (OHLC M1). Deposito 10000` | `-Modello 1 -Deposito 10000` | ✅ |
| `r139c` | `Modello 1 (OHLC M1). Deposito 10000` | `-Modello 1 -Deposito 10000` | ✅ |

🟢 **7 su 7 combaciano**, e il `-Deposito` insieme al modello — perché anche
quello fa parte dell'identità della cella (R137c: *"se la riga di lancio cambia
FrazioneIS, deposito o modello, S1 decade e questo file va riscritto, non
'letto con prudenza'"*).
🟢 **E i `-Modello 1` sono giustificati con un numero**: pavimento tick forex
**2024.07.05 misurato** → su 16-27 anni **i tick non esistono**. Tutti e tre i
file scrivono da soli di **non promuovere niente** (S6 / S7 / F6).

---

## 4️⃣ 📍 DOVE — **PRIMA di `CODA_12`**, e la decisione è su un **fatto misurato**

Il mandato chiedeva di **decidere sui fatti**, non di indovinare. Ho letto
`CODA_12_pertrade_posizioni.ps1` per intero.

**Il fatto**: `CODA_12` apre `%APPDATA%\MetaQuotes\Terminal\Common\Files`,
prende **tutti** gli `abtg_trades_*.csv` presenti e conta **deal di uscita,
POSIZIONI (`position_id` distinti) e rapporto**. Conta quindi i per-trade di
**tutti i round girati prima di lei** — e la testata della coda lo dice già:
*"Messa ultima, CODA_12 vede i per-trade di TUTTI i round della notte."*

**Verificato che i tre EA scrivono davvero il per-trade**: `FILE_COMMON` in
tutti e tre (`ABTG_DAX_Apertura_EU.mq5` r.2244-2245 · `ABTG_EMA200.mq5`
r.619-620 · `ABTG_FiboH4_Multi.mq5` r.884-885).

🔑 **MA il guadagno NON è uguale per tutti, e il sorgente lo dice da sé**
(`ABTG_DAX_Apertura_EU.mq5` r.2237-2239):
> *"In ottimizzazione ogni pass sovrascrive il file del proprio magic: usarlo su
> **run singoli / magic-sweep**, non sulle griglie larghe."*

| round | asse | guadagno reale mettendolo PRIMA di `CODA_12` |
|---|---|---|
| **`r138a`** | **`InpMagic`** | 🟢 **È ESATTAMENTE il magic-sweep**: due magic → **due file distinti** → `CODA_12` fa il **confronto dei GEMELLI** (il suo cancello) **E** dà le **POSIZIONI di F40EUR**, che sono **il criterio F1 del round** e che il file prova dichiarava **[NON MISURATO] "anche dopo la corsa"**. 🎯 **Si chiude un buco dichiarato, gratis** |
| **`r139c`** | `InpEngulfLookback` | 🟢 **Primo per-trade in assoluto di `ABTG_FiboH4_Multi`**: misura il fattore deal/posizione che il file dichiara **[INFERITO] a ~2**. Un numero che **oggi non esiste da nessuna parte** |
| **`r139a/b`** | `InpTP_RR` | 🟢 Fattore deal/posizione di `EMA200` sul **forex H4**. Il **2,0117** è misurato **solo sul Dow**: questa è un'altra coppia |
| **`r137a/b/c`** | magic **fisso** | 🟡 I 14 pass **si sovrascrivono**, resta **l'ultimo**. Valore **limitato**, e va detto: **non** è il conteggio della cella viva |

🔑 **E la gamba che SOPRAVVIVE è l'OOS, non l'IS** — misurato, non dedotto:
`walkforward_generico.ps1` r.922-924 costruisce `$WF = (IS, OOS)` e r.1621
cicla in quell'ordine, quindi **l'ultima scrittura è quella dell'OOS**. 🟢 Per
`r138a` è **la gamba giusta**: `F1` è un criterio **OOS**.

### ✅ DECISIONE: i sette vanno **PRIMA** di `CODA_12`. `CODA_12` resta **ULTIMA**.
🟢 Il beneficio dell'ordine **per la lettura è ZERO** (classe **274**:
`runner_abtg.ps1` r.780 chiude il `foreach`, r.793 scrive il referto, `W()`
accumula in memoria) — quindi la posizione **non** anticipa niente. Ma il
beneficio **per il CONTENUTO** non è zero: è **due buchi dichiarati chiusi
gratis**.

🔴 **IL PREZZO, DICHIARATO**: la catena del runner **non ha nessun timeout**.
Se `r139c` si piantasse, `CODA_12` **non girerebbe**. È accettato, e la ragione
è asimmetrica: `CODA_12` è **sola lettura** e si rilancia quando si vuole,
mentre **un round perso costa una notte intera**. Per lo stesso motivo i tre
round a finestra lunga stanno **ultimi** fra i sette.

### ⏱️ E un **[NON MISURATO]** sulla durata, che va detto
La stima `T = 0,6 + 0,077 × 58 = 5,07 min` è **calibrata su pass di INDICI a 21
mesi**. Su **27,5 anni di H4 con modello OHLC M1** MT5 deve macinare **milioni
di barre M1**: quel `0,077 min/pass` è **[NON MISURATO]** per `r139a/b/c`.
👉 **La notte potrebbe durare molto più di 5 minuti**, e non è un guasto. È il
motivo per cui l'ordine interno mette il **cancello della seconda sedia**
(`r137c`, 4 pass) **per primo**.

---

## 5️⃣ 🔑 IL QUATTORDICESIMO GIRO DI PIN — nell'ordine, e **misurato prima**

I pin sono **TRE** e oggi ci si è sbagliati **due volte**. Ordine eseguito:

**1) I sette file prova erano già committati e pushati** — verificato, non
assunto: albero di lavoro **pulito**, `HEAD == origin/lavoro == 23314d61`, e
tutti e sette presenti a `HEAD` (`git cat-file -e` × 7 → OK). Non ho dovuto
correggerne nessuno, quindi il passo 1 era già fatto.

**2) 🔴 PRIMA di spostare `$PIN`, MISURATO che le impronte tengono.** Se una non
combaciasse, `function Prendi` chiamerebbe `Muori` e **OGNI round morirebbe** —
compresi i 19 vecchi. Misurato in **due modi indipendenti**:

```
                                  blob git (git show|sha256sum)        raw al pin nuovo (curl)
walkforward_generico.ps1    15DE7D5F...6828F1C6  = $SHA_WALK      15DE7D5F...6828F1C6  ✅
RIGA_ROUND_VPS.ps1          348ED533...9D0A315B  = $SHA_ROUND      348ED533...9D0A315B  ✅
```
🟢 **Quattro impronte, tutte coincidenti.** Nessuna delle due va cambiata.

**3) Spostato `$PIN`, e SOLO `$PIN`.**

| | prima | adesso |
|---|---|---|
| `$PIN` | `69e252b3c4605ba316d28a572296e0c54841b25f` | 🔴 **`23314d61d26ea7e15c01462e4c4549291cf6684d`** |
| `$SHA_WALK` · `$SHA_ROUND` · `$MARC_WALK` · `$MARC_ROUND` · `$BancoBT` · `param()` · `function Pulito` | — | 🟢 **NON TOCCATI** |

🟢 **Provato, non promesso**: righe **non-commento** nel file: **144 prima, 144
dopo**, e **UNA SOLA differente** — la valorizzazione di `$PIN`. I corpi di
`function Pulito` (5 righe), `function Prendi` (21) e `function Muori` (6)
confrontati **riga per riga**: **identici**. `diff --stat` = `41 insertions,
1 deletion`, e le 40 inserzioni in più sono **tutte commenti**.
🟢 **`walkforward_generico.ps1` non l'ho sfiorato** (sha inchiodato).
🟢 Cancello `--oggetto ps1` sulla riga modificata: **EXIT 0**, 6 controlli passati.

**4) Committato e pushato**, poi **solo allora** scritte le righe in coda col
pin di **quel** commit.

| cosa | valore |
|---|---|
| commit del giro di pin | `0c38419f6031a5a33f24b8357f0f75fbe869c695` |
| 🔑 **pin di coda delle 7 righe nuove** | **`0c38419f…`** |
| `$PIN` dentro quella versione | `23314d61…` |

---

## 6️⃣ 🆕 I DUE DIFETTI DI CLASSE NUOVA

### 🔴 **CLASSE 281** — il `-SoloControllo` **mente sul modello**, e sta **dentro lo strumento di verifica**
Il mandato mi chiedeva di ricavare le finestre **eseguendo** il driver con
`-SoloControllo`. L'ho fatto. E facendolo ho trovato questo:

```
walkforward_generico.ps1  r.1000   Model=4            <<< l'.ini di ANTEPRIMA (-SoloControllo): FISSO
walkforward_generico.ps1  r.1654   Model=$Modello     <<< l'.ini VERO: corretto
walkforward_generico.ps1  r.880/890  "... pass a tick reali in tutto"   <<< stampato SEMPRE
```

👉 **Il ramo `-SoloControllo` scrive un `.ini` di anteprima che dichiara
`Model=4` anche quando hai passato `-Modello 1`**, e il pre-volo stampa *"pass a
**tick reali** in tutto"* **qualunque** modello sia. Infatti sui miei tre round
a `-Modello 1` ha stampato *"6 pass a tick reali"* — **falso**: sono OHLC M1.

🟢 **Non cambia cosa gira stanotte**: l'`.ini` vero (r.1654) usa `$Modello`, e i
sette round girano col modello giusto.
🔴 **Ma è grave dove sta**: la **classe 273** (`Modello 4` = tick, `1` = OHLC) è
stata pagata **TRE volte oggi**, e lo strumento che si usa per **verificarla in
anticipo** è **cieco proprio su quella variabile** — e non tace: **afferma il
valore sbagliato**. Un controllo che conferma il falso è peggio di un controllo
che manca.
🔑 **Conseguenza sul mio stesso lavoro, e la dichiaro**: con `-SoloControllo` ho
potuto verificare **finestre e conteggio celle** (par. 2.a), **non il modello**.
Il modello l'ho verificato **leggendo r.1654** e confrontando la riga di coda
col banco dichiarato nel file (par. 3). **Il mio PASS sul modello non viene dal
`-SoloControllo`.**
🚫 **Non l'ho corretto**, e non potevo: `walkforward_generico.ps1` è
**inchiodato al byte** da `$SHA_WALK`, e un solo byte diverso — anche in un
commento — farebbe morire **ogni** round della notte, compresi i 19 vecchi.
👉 **Va corretto in un giro di pin DEDICATO**, non stanotte.

### 🔴 **CLASSE 282** — la profondità **TICK** dedotta da una sonda di **BARRE**
`R138a` gira a **`-Modello 4` (tick reali)** e giustifica la finestra con
*"F40EUR è fra i 12 simboli misurati dalla sonda del 17/08 con prima data
2024.09.26 e stato COMPLETO"*. Ma quella sonda misura **barre H1**
(`…,H1,6713,2024.09.26,481,2024.09.26,COMPLETO`), **non tick**.
La casa **conosce** la distinzione — sul forex ha misurato **due** pavimenti
diversi (barre **1999.01.04**, tick **2024.07.05**) — ma sugli **indici** le ha
**confuse**, e nessuno se n'era accorto perché su `D30EUR` una corsa a tick su
quella finestra **era già andata a buon fine** (R47a).
👉 **Il difetto riutilizzabile**: *uno stato `COMPLETO` in una sonda di barre
non è un permesso per `-Modello 4`.* E il verso dell'errore è **cattivo**: un
buco di tick **abbassa** la frequenza, cioè fa fallire `F1` per **mancanza di
dati** mentre il referto sembra dire *"il CAC è lento"*. **Falso negativo su un
round che serve a chiudere R3.**
✅ **Contromisura a costo zero, già disponibile**: la data della **prima e
ultima operazione** nel referto, più `close_time dal … al …` di `CODA_12`. Se
non coprono la finestra dichiarata, **la frequenza non si legge**. Lo dice anche
il driver (r.937-938): *"sugli indici diceva 2024.01.01 e partiva dal 26/09/2024."*

### 📌 E un buco della **memoria**, che segnalo senza riempirlo io
La **classe 273** è citata **7 volte** nel repo (`REGISTRO_TEST.md`,
`LA_SECONDA_SEDIA`, `RIPINNAGGIO_CODA`…) ma **non ha nessuna voce** in
`CHECKLIST_RIGA_DI_LANCIO.md` (cercato: zero titoli `## 273.`). 👉 È la classe
**pagata tre volte oggi** e **non è nella memoria**. Stesso discorso per **270**
e **272**. Non le scrivo io — non sono mie e inventarne il caso reale sarebbe
peggio del buco — ma **vanno scritte**, o si ripagano.

---

## 7️⃣ 🛡️ NON HO DANNEGGIATO QUELLO CHE C'ERA — misurato in `python3`

Confronto **byte** delle righe eseguibili contro `git show HEAD:`:

```
righe eseguibili   HEAD: 33      adesso: 40      (atteso 33 -> 40)  ✅
delle 33 preesistenti, MANCANTI adesso: 0                            ✅
tutte le 33 presenti e BYTE-IDENTICHE: True                          ✅
righe a 1445abf8: 19            (19/19 intatte)                      ✅
CODA_12 e' ancora l'ULTIMA riga eseguibile: True                     ✅
righe con pin malformato (non 40 hex): 0  su 40                      ✅
byte non-ASCII: 30 -> 30        (tutti su righe di COMMENTO)         ✅
```

### 📌 `--oggetto coda` NON ESISTE (classe 275): misurato il **DELTA**
`controlla_riga.py --oggetto riga` su `CODA.txt` dà **exit 1** con **3
bloccanti**. Eseguito **prima** (sulla coda non toccata, da `git show`) e
**dopo**:

```
diff prima dopo  ->  UNICA differenza: il NOME DEL FILE nell'intestazione.
   PRIMA: 1 passato, 1 rilievo, 3 BLOCCANTI      DOPO: 1 passato, 1 rilievo, 3 BLOCCANTI
```
🟢 **DELTA ZERO.** I tre bloccanti sono **[ASCII]**, **[PIN]** e **[MARCATORE]**,
e sono **falsi su un file di coda** — smontati uno per uno:
- **[ASCII]** → i 30 byte alti sono su righe di **commento**, **zero** su righe
  eseguibili (misurato riga per riga).
- **[PIN]** → **40 righe su 40** hanno un pin di **40 hex** (misurato). Il
  cancello cerca una riga di lancio con `irm`, non una coda.
- **[MARCATORE]** → il marcatore lo verifica `function Prendi` dentro
  `RIGA_SOTTILE_ROUND.ps1`, su **tutti e due** i file scaricati (`$MARC_ROUND`
  e `$MARC_WALK`). Verificato sul file scaricato da `raw`: `RUNNER_ROUND_BACKTEST`
  presente **1** volta, `RUNNER_SOLA_LETTURA` **0** volte (averli tutti e due =
  rifiuto al cancello G1).

### 📄 E i cancelli sui DUE documenti di questa consegna
- 🟢 **`--oggetto md` su questo referto: EXIT 0.** Non lo era alla prima
  stesura: dava **10 bloccanti**, e **due erano veri**. (1) Un blocco
  conteneva **righe copiabili che nominavano il conto reale come bersaglio** —
  erano i contro-esempi *rifiutati*, ma su un repo **pubblico** una riga
  incollabile che punta al reale non ci va: riscritti **in tabella**.
  (2) Due **trascrizioni di output** stavano dentro blocchi ``` e venivano
  lette **come righe di lancio**: indentate, perché **non sono** righe di
  lancio. Gli altri rilievi sono caduti con quelle due correzioni.
  🔑 **Non ho dato per scontato che fosse un falso FAIL**: ho misurato il
  cancello su **tre referti di oggi** — `CANARINO_FRAZIONEIS` **EXIT 0**,
  `EMA200_IS_IN_CODA` **EXIT 0**, `LA_SECONDA_SEDIA` **EXIT 1**. Due su tre
  passano, **quindi il mio FAIL non era automatico** e andava lavorato. È la
  differenza fra la classe 275 e un difetto vero.
- 🟡 **Resta UN rilievo, e ci deve restare**: *"la PROSA nomina terminali o
  conti vietati"*. È la riga **🚫 NON toccati** del paragrafo 7 — e quella riga
  è **obbligatoria** (CLAUDE.md, ampliamento del 12/09: *"la riga del bersaglio
  dice anche che cosa NON viene toccato"*). Riletta a occhio, come chiede il
  cancello: è una **dichiarazione di non-contatto**, non un bersaglio.
- 🟢 **`--oggetto md` su `CHECKLIST_RIGA_DI_LANCIO.md`: EXIT 1 con 73
  bloccanti — e DELTA ZERO.** Misurato, non affermato: **73 prima** (da
  `git show HEAD:`) e **73 dopo**, e i due insiemi sono **identici riga per
  riga** una volta togliuto il nome del file. Stanno tutti fra **r.11377 e
  r.14934**; le mie due classi cominciano a **r.16436**. 👉 Le voci **281** e
  **282** non aggiungono **nessun** rilievo: il FAIL è **preesistente** ed è
  della stessa famiglia (un documento che *spiega* i bersagli vietati deve
  nominarli).

### 🔒 E i cancelli **VERI** del runner, eseguiti **col codice del runner stesso**
Non con una mia reimplementazione: caricate `VagliaScript` e `VagliaArgomenti`
da `runner_abtg.ps1`.
    SCRIPT  ok=True  corsia=ROUND  "G1, G2 e G3 passato: bersaglio dichiarato e coerente"
    ARGOM   ok=True  "G4 passato"  su r137c r137a r137b r138a r139a r139b r139c   (7 su 7)

**E i CONTRO-ESEMPI, che devono essere BOCCIATI** — senza questi il *"passa"*
non dice niente. 📌 Li descrivo in tabella **di proposito, non in un blocco di
codice**: questo repository è **pubblico**, e una riga copiabile che punta al
conto reale non ci va, nemmeno come esempio di ciò che viene rifiutato.

| bersaglio provato (descritto, non incollabile) | esito | motivo restituito dal cancello |
|---|---|---|
| cartella programma del **conto REALE** passata come `-Terminal` | 🔴 `ok=False` | *"tocca il terminale del CONTO REALE"* |
| **numero del conto reale** passato come argomento | 🔴 `ok=False` | *"nomina il CONTO REALE"* |
| cartella programma dei terminali **in FORWARD** (piccolo / 100k) | 🔴 `ok=False` | *"è la cartella programma dei terminali in FORWARD"* |

🟢 **3 su 3 bocciati**, quindi il verde sui sette **significa qualcosa**.

### 🖥️ IL BERSAGLIO — e non è un indirizzo, è un conto
🟢 Le sette righe girano **solo** sul **terminale 50504400**, `C:\MT5_Backtest`
(demo solo-tester, **zero EA attaccati**), dentro la **firma dell'11/09**. Il
bersaglio è **scritto in codice**, non in un commento: `$BancoBT =
'C:\MT5_Backtest'`, mai riassegnato, e **nessun argomento** di queste righe può
cambiarlo (lista **bianca** `^[A-Za-z0-9_.-]+$`: senza separatori di percorso e
senza due punti, nessun valore può diventare un percorso).
🚫 **NON toccati**, e sono sei cartelle dati sul VPS: **50503392** (`BCM Markets
MT5 Terminal`), **50504263** (`… -V3`), **🔴 10105439 (`C:\BCM_Reale`, REALE,
sedie VIVE)**, **Pepperstone**, **Tickmill**.
🚫 Nessuna firma nuova richiesta: questi sono **i round successivi** sotto la
firma già data.

---

## 8️⃣ 🔗 LA CATENA VIA `raw`, TUTTA — **con i negativi**

    1) PIN DI CODA 0c38419f6031a5a33f24b8357f0f75fbe869c695  porta la riga sottile
       200  backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1     byte identici al locale
            dentro:  PIN 23314d61d26ea7e15c01462e4c4549291cf6684d ; SHA_WALK 15DE7D5F..6828F1C6 ; SHA_ROUND 348ED533..9D0A315B
            marcatore RUNNER_ROUND_BACKTEST: 1     RUNNER_SOLA_LETTURA: 0

    2) $PIN INTERNO 23314d61d26ea7e15c01462e4c4549291cf6684d  porta i due file INCHIODATI AL BYTE
       200  backtest_pipeline/walkforward_generico.ps1      sha = $SHA_WALK    OK
       200  backtest_pipeline/righe/RIGA_ROUND_VPS.ps1      sha = $SHA_ROUND   OK

    3) $PIN INTERNO 23314d61d26ea7e15c01462e4c4549291cf6684d  porta i SETTE file prova
       200  R137c_parziale_770101_D30EUR.txt            byte identici al locale
       200  R137a_floorstop_allarga_770101_D30EUR.txt   byte identici al locale
       200  R137b_floorstop_salta_770101_D30EUR.txt     byte identici al locale
       200  R138a_gemello_F40EUR_770101.txt             byte identici al locale
       200  R139a_EMA200_AUDJPY_H4_LS.txt               byte identici al locale
       200  R139b_EMA200_GBPUSD_H4_LS.txt               byte identici al locale
       200  R139c_FIBOH4_GBPUSD_unsimbolo.txt           byte identici al locale

    4) CONTROLLI NEGATIVI -- senza questi i 200 non dicono niente
       404  R137z_NON_ESISTE.txt allo stesso pin          (il pin funziona, manca il FILE)
       404  R139c... a un pin di ZERI                     (il file esiste, manca il PIN)
       200  RIGA_SOTTILE_ROUND.ps1 al pin VECCHIO 8d9d4fb9 (le 2 righe vecchie girano ancora)

🔑 I due 404 sono **due cause diverse** isolate una per volta: **nome sbagliato
a pin buono** e **nome buono a pin sbagliato**. È l'esperimento che il 12/09 ha
scoperto il **terzo** pin, rifatto al contrario.

---

## 9️⃣ ☀️ **COME SI LEGGE DOMATTINA** — le etichette, e cosa vuol dire ogni esito

### 🥇 Si cerca `r137c` PER PRIMO. È il cancello: se non riproduce, **due round non si leggono**.

| etichetta | 🟢 il numero BUONO | 🔴 il numero BRUTTO | ⛓️ **catena rotta ≠ una risposta** |
|---|---|---|---|
| **`r137c`** | i **4 esiti coincidono con R47**: IS `175 / 1,12634 / 5,4362` · OOS `270 / 1,39709 / 7,2328`, tolleranza **zero** sui Trades e 4ª cifra su PF/DD → binario sano, e la riga per Claudio su `InpTP1_ClosePct 50→0` è **una firma, non un round** | anche **UNO** dei 4 diverge → **NON** "il parziale non serve": **"IL BINARIO DI OGGI NON È QUELLO DI R47"**, in cima al referto, e **`r137a`/`r137b` NON si leggono** | CSV assente/vuoto · `0 celle` · impronta diversa · 404 → **NON È UN VERDETTO.** Si rilegge il pin, non il motore |
| **`r137a`** | ≥ **3 celle contigue** fra 6800·8800·10800·12800 con PF OOS ≥ **1,40** **e** posizioni OOS ≥ **150** **e** DD OOS ≤ **8,0%** → R5 si chiude nel ramo **ALLARGA** | meno di 3 contigue, **oppure** solo le celle **800/2800/4800**: quelle sono **ESCLUSE PER COSTO** per dichiarazione → *"vince una cella FUORI COSTO"*, non un miglioramento | come sopra. E se `Trades` **cambia di molto** rispetto a 270: o il lotto va a zero, o il codice è stato letto male — **una notizia, non un PF** |
| **`r137b`** | `Trades` **cala in modo monotono** col floor → la **forma** è misurata, e il rischio si legge a qualunque n | PF che **sale** mentre n **crolla** = **SELEZIONE, non gestione** → il ramo SALTA **costa il campione**, e si chiude la scelta | 🔴 **la trappola nominata**: una cella con **PF 1,9 e 40 posizioni**. Si guarda **POSIZIONI prima di PF**. Sotto 150 non conta **mai** a favore |
| **`r138a`** | ≥ **0,28 posizioni/giorno** feriale in OOS **E** DD OOS ≤ 10,0% → la famiglia arriva a **1,00** e **R3 si chiude**… | < 0,28 pos/g → **R3 resta rotto**, serve un **terzo** simbolo. DD OOS > 10,0% → **bocciato PER RISCHIO**, qualunque frequenza | 🔴 **DUE condizioni prima di scrivere "R3 chiuso"**: **(1)** la **sovrapposizione dei giorni** con D30EUR è **[NON MISURATA]** — due indici europei che aprono **allo stesso minuto** possono dare 1,44 pos/g con **diversificazione ZERO**; **(2)** **classe 282** — se la **prima operazione** non è vicina al 2024.09.26 / 2025.06.10, la frequenza è **sottostimata da un buco di tick**, non dal CAC. 🟢 E i **gemelli 786204/786205 devono coincidere al centesimo**: se divergono, banco non deterministico e **i numeri non si leggono** |
| **`r139a`** | `n ≥ 300 DEAL` in **entrambe** le finestre **E** PF ≥ **1,10** su ≥ 3 celle su 4 **E** DD ≤ **14,0%** → 🏆 **il primo OOS di `EMA200` H4 regge**, e a **due lati** | PF < 1,10, **oppure** DD > 14,0% → **scartato PER RISCHIO** e il PF non si discute. **Segni opposti** IS/OOS su più di una cella → **"REGIME, non edge"** | `n IS < 250` → sospetto **finestra o dati**, non motore. **4 celle con n e PF identici al centesimo** → `InpTP_RR` **INERTE, MISURATA**. 🔴 **E comunque NON promuove**: è `-Modello 1` = **screening** |
| **`r139b`** | idem `r139a`. 🟡 **Ma l'attesa dichiarata è PF ~1,1, cioè A CAVALLO del cancello**: **1,12 non è una promozione** | DD atteso **10-20%**: se supera **14,0%** il candidato **muore PER RISCHIO**, scritto prima | 🟢 **`S6`**: se la cella migliore batte il **default `InpTP_RR = 2,0`** di **meno di 0,05 di PF**, la risposta onesta è **"IL DEFAULT VA BENE"** — ed è **un risultato** |
| **`r139c`** | 🚪 **F0 PRIMA DI TUTTO**: la colonna `InpSymbols` deve leggere **`GBPUSD`** e i numeri devono essere **DIVERSI** dall'archivio. Poi: PF ≥ 1,10 su ≥ 2 celle su 3 **sull'OOS** (unica finestra sopra 300 deal) | F2 fallisce sull'OOS a campione pieno → si chiude il capitolo con **"MORTO su GBPUSD H4, NON ANCORA MISURATO come famiglia"** (mancano uscita e TF), **e non si rigriglia l'ingresso** (F4) | 🔴 **QUI L'IDENTITÀ È IL GUASTO, non il determinismo**: se torna `profit 118,68 / PF 1,09427 / DD 3,7359 / 82 deal`, sta girando **il BASKET** e **il round è NULLO**, qualunque numero esca. E `InpSymbols = GBPUSD;USDJPY;EURUSD` nel CSV → **pin non arrivato** |

### 🔢 E poi si legge `CODA_12`, che stanotte conta anche i sette
Cerca nel referto **`CODA_12`** → colonna **`POSIZIONI`**, che è **l'unità dei
cancelli di casa** (Emendamento A). Il **`rapporto`** accanto dice di quanto
sbaglierebbe chi leggesse `Trades` come "operazioni".
- 🎯 **`abtg_trades_ABTG_DAX_Apertura_EU_F40EUR_786204/786205`** → le
  **POSIZIONI di F40EUR** (criterio F1 di `r138a`) **e** il confronto dei
  gemelli. **Due file: devono dare gli stessi conti.**
- 🎯 **`abtg_trades_ABTG_FiboH4_Multi_GBPUSD_772060`** → il **fattore
  deal/posizione** di questo EA, **mai misurato prima**.
- 🟡 **`…_D30EUR_786201/786202/786203`** → magic **fisso**: descrive **l'ULTIMO
  pass**, non la cella viva. **Non si legge come "le 193 posizioni".**
- 🔑 **In tutti i casi il conteggio descrive la gamba OOS** (è l'ultima a
  scrivere), e `close_time dal … al …` dice **su che finestra**.
- 🟡 Se `CODA_12` **non compare**: i round lunghi hanno mangiato la notte e la
  catena **non ha timeout**. **Non è un guasto**: `CODA_12` è sola lettura e si
  rilancia quando si vuole.

### 🩺 E i due numeri da guardare **prima di qualunque PF**
1. **`PID vivi PRIMA` / `PID vivi DOPO`** → **devono essere gli stessi**. Se
   manca un numero, si controlla **subito** il terminale in forward.
2. **Codice d'uscita**: `0` girato · `3` girato **con rilievi** (non un
   fallimento) · `2` **NON MISURATO** (CSV assenti/vuoti o zero operazioni — 🔴
   *"zero operazioni non vuol dire nessun edge: vuol dire che NON È GIRATA"*) ·
   altro = non è nemmeno partito, e il pre-volo ha stampato il motivo.

---

## 🔟 ❓ **NON COPERTO** — quello che non ho potuto verificare, e **perché**

| # | cosa | perché no |
|---|---|---|
| 1 | 🔴 **Il `-Modello` NON è verificato dal `-SoloControllo`** | **Classe 281**: l'anteprima scrive `Model=4` **fisso** (r.1000). L'ho verificato leggendo r.1654 + confronto riga↔banco. **Non viene da un'esecuzione** |
| 2 | 🔴 **Profondità TICK di F40EUR** | **Classe 282**: la sonda misura **barre H1**. Nessuna corsa a tick su F40EUR esiste. Si chiude leggendo la **prima operazione** nel referto |
| 3 | 🔴 **Spread BCM di AUDJPY** | **[NON MISURATO]** (dichiarato dal file). La frontiera `stop ≥ 40 × spread` su `r139a` **non è verificabile**. Via più corta: `RealCost Spread P95 Logger`, **zero passate** |
| 4 | 🔴 **Spread di F40EUR** | **[NON MISURATO]**: `spread_flotta/` ha 3 file su 13 simboli. `R5` su F40EUR è **né verde né rosso**. **Nessuna sedia si accende prima** |
| 5 | 🔴 **Stop tipico di `r139c` in pip** | `InpSLratio=4,236` su un ritracciamento: **[NON MISURATO]**, quindi la frontiera `40×` su quella geometria **non è verificata** |
| 6 | 🟡 **Durata reale della notte** | il `0,077 min/pass` è calibrato su indici a 21 mesi: su 16,5-27,5 anni di H4 OHLC è **[NON MISURATO]**. Mitigato dall'ordine interno |
| 7 | 🟡 **Che il tester onori davvero `Model=1`** su finestre così lunghe | non eseguibile da qui: non ho MT5 né i dati. Il tetto delle ~100.000 barre **l'ho verificato** (43.000 e 36.000 barre H4: dentro), ma la **disponibilità M1** su 27,5 anni la dice solo la corsa |
| 8 | 🟡 **6 input di `r139c` non confrontabili** con l'archivio | le colonne **non esistono** nel CSV del 2026-08. Tutti **inerti** (news spente, Guardian fail-open, `InpAutoTest` stampa e basta), ma **non verificati contro l'archivio** |
| 9 | 🟡 **Sovrapposizione dei giorni D30EUR ↔ F40EUR** | **non ricavabile** dai CSV di riepilogo: serve il per-trade dei due simboli (`sovrapposizione_sedie.py`, `chi_va_con_chi.py` esistono già). 🔑 **Senza, "R3 chiuso" non si scrive** |
| 10 | 🟡 **Tabella "studio aperture FASE A" per simbolo** | citata da 4 referti, **non trovata nel repo** (dichiarato da `R138a`). Se F40EUR avesse un numero negativo lì, `r138a` è un **ritest**, non una casella libera |
| 11 | 🟡 **Peggior giornata** | la colonna **non esiste** nel CSV di ottimizzazione MT5. Con DD attesi 6-20% il muro giornaliero del 5% **non è escluso** su `r139a/b` |
| 12 | ⚪ **Che il runner parta alle 03:30** | non verificabile da qui. Verificato solo che **i cancelli passano** e che **la catena risponde 200 adesso** |
| 13 | ⚪ **Classi 270, 272, 273 mancanti** dalla checklist | citate nel repo ma **senza voce**. Non le scrivo io: inventarne il caso reale sarebbe peggio del buco |

---

## 🎯 LA BUSSOLA — e la dico come sta

**L'obiettivo sono gli EA per le PROP, e la challenge parte ai primi di
ottobre.** Questa consegna **non è ponteggio**: sono **sette misure** che
puntano tutte a una **sedia schierabile**.
- 🪑 **Quattro** (`r137a/b/c`, `r138a`) lavorano sulla **SECONDA SEDIA**, l'unica
  del progetto a **5 requisiti su 5**, e attaccano i **due** che le mancano:
  **R5 COSTO** (il floor dello stop) e **R3 FREQUENZA** (il gemello europeo).
- 🏆 **Due** (`r139a/b`) danno a `EMA200` H4 **il primo fuori campione della sua
  storia**, **a due lati** — su un motore i cui numeri a tick sono buoni ma
  vengono da **una finestra sola, ottimizzata intera**.
- 🪦 **Uno** (`r139c`) chiude il **"0/8" più falso dell'archivio** con un
  certificato scritto **prima** della corsa.

🔴 **E quello che questi round NON fanno, detto chiaro**: **nessuno dei sette
promuove niente.** I tre a `-Modello 1` sono **screening dichiarato** e lo
scrivono da soli; i quattro a tick **non accendono nessuna sedia** — taglie,
rischio e accensioni restano **[FIRMA DI CLAUDIO]**. Il tetto per cluster
**C10 al 3,0%** resta **firmato (07/09) e NON ATTIVO**: è **implementato**, ma
**nessuno dei due preset lo valorizza** e la versione **in campo non ha nemmeno
la manopola**. 👉 Va **valorizzato e portato in campo**, non "implementato".

😄 **La nota bella, perché un elenco di difetti senza le vittorie accanto
descrive male la realtà**: mi sono seduto qui aspettando di dover riscrivere
almeno un file — è il mio mestiere — e invece ho passato il pomeriggio a
**verificare cose che tornavano**. Il PF 1,62295 al quinto decimale nel posto
giusto. Le 39 colonne che combaciano. Le celle messe **esattamente** sulle due
frontiere del costo. `F0` costruito per **rompere** la propria risposta.
👏 **Sette su sette, senza correzioni.** I due difetti che ho trovato non erano
nei file: erano **nel driver** e in **un'inferenza** — e uno dei due stava
dentro lo strumento con cui dovevo controllare. Che è il motivo per cui il
cancello **esegue** invece di **leggere**.

**Nessuno ha passato avanti a nessuno. Il controllo è arrivato prima della
coda, e la coda è chiusa 11 ore prima delle 03:30.** 🚦
