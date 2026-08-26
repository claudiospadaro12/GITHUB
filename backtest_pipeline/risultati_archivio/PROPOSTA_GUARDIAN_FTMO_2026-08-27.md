# 🛡️ PROPOSTA — PRESET GUARDIAN PER I MURI FTMO (27/08/2026)

> **Cos'è questo documento**: il **CANCELLO 4** del `report/PIANO_PROP.md`
> (§ CANCELLO CHALLENGE) chiede _"un preset Guardian sui muri della prop
> scelta + firma"_. Qui c'è la **proposta di preset**, valore per valore, con
> la derivazione di ogni numero e i buchi dichiarati.
>
> ## 🛑 QUESTO DOCUMENTO NON CAMBIA NIENTE
> - ❌ **nessun file `.mq5` / `.mqh` toccato** — il codice del Guardian è
>   rimasto quello di ieri, riga per riga;
> - ❌ **nessun preset vivo modificato** — `mql5/Presets/ABTG_Guardian_FTMO_2Step.set`
>   (quello che gira sul dry-run 100k) è **intatto**;
> - ❌ **niente commit, niente push** — è un foglio da leggere e firmare;
> - ❌ **niente compilazione, niente test**: in questo ambiente non esistono
>   MetaEditor né MT5. Tutto ciò che segue è **codice letto**, non codice
>   provato. La prova la fa Claudio sul terminale.
>
> **Il preset entra in vigore SOLO con la firma**, e **SOLO sul futuro conto
> FTMO**: il demo/100k in campo oggi non si tocca (vedi § FIRMA, decisione 9).

---

## 0. 🏷️ ETICHETTE — cosa è misurato e cosa è ragionato

| etichetta | significato |
|---|---|
| 🥇 **[VERIFICATO]** | letto da me nel sorgente/nel dato di casa, in questo giro |
| 🟡 **[LETTO-VIA-SEARCH]** | regola della prop letta via ricerca/dossier, **mai una pagina aperta con i miei occhi** |
| 🔵 **[INFERITO]** | ragionamento mio ancorato a numeri di casa — **non è una misura** |
| 🔴 **[INCERTO]** | manca il dato, e lo dico invece di riempirlo |

⚠️ **Controllo positivo del mio lavoro**: i valori del Guardian qui sotto li ho
letti **nel sorgente** (`ABTG_Guardian.mq5`, `ABTG_PausaGuardian.mqh`), non nei
referti che li raccontano. Dove sorgente e documentazione **divergono**, lo
scrivo (§ 4.3: c'è una divergenza, e non è piccola).

---

## 1. 🔍 CENSIMENTO DEL GUARDIAN — tutti gli input, semantica ESATTA

🥇 Fonte: `mql5/Experts/ABTG_Guardian.mq5` v1.11 (righe 49-70 per gli input) e
`mql5/Include/ABTG_PausaGuardian.mqh` v1.40.

### 1.1 Gli input, uno per uno

| input | default nel sorgente | preset FTMO vivo oggi | cosa fa ESATTAMENTE |
|---|---:|---:|---|
| `InpStartBalance` | `0` | `100000` | capitale di riferimento di **tutti** i limiti. **0 = cattura automatica** del balance al primo avvio e lo persiste in GV |
| `InpDailyLossPct` | `5.0` | **`4.9`** | **EMERGENZA giornaliera.** Scatta quando `dayStart − equity >= %·StartBalance` |
| `InpTotalDDPct` | `10.0` | **`9.9`** | **EMERGENZA totale.** Scatta quando il DD totale `>= %·StartBalance` |
| `InpDDMode` | `0` | `0` | **0 = STATICO** (`totalDD = StartBalance − equity`) · **1 = TRAILING** (`totalDD = piccoEquity − equity`, picco **live sull'equity**, non EOD) |
| `InpDailyResetHour` | `0` | **`23`** | **ORA SERVER** (del broker su cui gira il Guardian, non ora locale del PC, non ora della prop) in cui gira il "giorno prop" |
| `InpDailyPausePct` | `4.0` | `4.0` | **PAUSA MORBIDA (B1).** 0 = spenta |
| `InpMaxOpenRiskPct` | `3.25` | `3.25` | **CAP C1** sul rischio aperto simultaneo, **% dell'EQUITY**. 0 = spento |
| `InpRiskMode` | `0` | `0` | **0** = rischio misurato dall'**INGRESSO**→SL (convenzione M2) · **1** = dal **PREZZO CORRENTE**→SL (perdita residua) |
| `InpWarnNoSL` | `true` | `true` | logga le posizioni **senza SL** (rischio ignoto, **escluse dal cap**) — non blocca |
| `InpAction` | `0` | `0` | **0 = CHIUDI+BLOCCA** (enforce) · **1 = SOLO ALLARME** (non chiude nulla) |
| `InpCloseAllMagics` | `true` | `true` | true = chiude/cancella **qualsiasi magic** (la regola prop è sul CONTO) |
| `InpShowPanel` | `true` | `true` | pannello a schermo |
| `InpMagic` | `779001` | `779001` | solo per i propri log |
| `InpComment` | `"GUARDIAN"` | `GUARDIAN FTMO 2STEP` | commento |
| `InpVerbose` | `true` | `true` | log ogni 300 s |
| `InpAutotest` | `false` | *(assente)* | all'avvio esegue i casi del nucleo di decisione e scrive l'esito nel giornale. **Non tocca il conto** |

### 1.2 🚨 COSA FA ESATTAMENTE QUANDO SCATTA — chiude? blocca? entrambe?

**È la domanda giusta, e la risposta è DIVERSA per ognuna delle quattro soglie.**
🥇 letto in `OnTimer()`, righe 372-428.

| soglia | chiude? | blocca nuovi ingressi? | quanto dura | come si sblocca |
|---|---|---|---|---|
| 🟨 **`InpDailyPausePct`** (pausa B1) | ❌ **NO, niente** | ✅ **SÌ**, ma **solo per gli EA che chiamano la guardia** (vedi § 4.3) | **latch** fino al reset del giorno prop, anche se l'equity risale | da sola, al reset. E ha una **scadenza** scritta (`ABTG_PAUSA_FINO`): se il Guardian muore, non resta bloccata in eterno |
| 🟥 **`InpDailyLossPct`** (emergenza giorno) | ✅ **SÌ — `FlattenAll()`**: chiude **tutte** le posizioni e cancella **tutti** i pendenti | ✅ SÌ (accende anche la pausa) | **tutto il giorno prop**, e **ogni secondo ri-chiude** qualsiasi cosa riappaia | da sola, al reset del giorno prop |
| ⬛ **`InpTotalDDPct`** (emergenza totale) | ✅ **SÌ — `FlattenAll()`** | ✅ SÌ (pausa per **30 giorni**) | **PER SEMPRE** (`GV_FAILED = 1`, latch permanente) | ❗ **SOLO A MANO**: cancellando la GlobalVariable `ABTG_GUARD_<login>_FAILED` dal terminale (F3) |
| 🟦 **`InpMaxOpenRiskPct`** (cap C1) | ❌ **NO** | ✅ SÌ, finché il rischio aperto è sopra il cap | finché rientra (ri-timbrato ogni secondo) | da solo. E **scade da solo entro 120 s** se il Guardian muore (fail-open) |

📌 **Tre precisazioni che cambiano il senso della tabella:**
1. **La pausa e il cap NON hanno potere sugli EA**: scrivono una GlobalVariable.
   Chi non la legge, apre lo stesso. **Le emergenze invece sono autonome**: il
   Guardian chiude da sé, senza chiedere permesso a nessuno.
2. **Nemmeno le emergenze chiudono "in sicurezza"**: `FlattenAll()` manda
   `PositionClose` una volta per posizione e **conta i successi, non i
   fallimenti** — niente controllo del retcode, niente retry esplicito. Il
   recupero c'è ma è indiretto: il blocco alle righe 392-395 richiama
   `FlattenAll()` **a ogni giro di timer** finché il conto non è piatto.
3. **Il Guardian sorveglia con `OnTimer(1 s)`**, non sui tick: funziona anche a
   mercato fermo e su qualunque grafico. Ma **fra due giri passa un secondo**, e
   in quel secondo l'equity può fare quello che vuole (§ 4.4).

### 1.3 ✅ COME I NUMERI DEL GUARDIAN MAPPANO SUI MURI FTMO — riga per riga

Questa è la verifica che rende il preset legittimo: **le formule combaciano**.

| regola FTMO 2-Step 🟡 | formula FTMO | formula del Guardian 🥇 | esito |
|---|---|---|---|
| **muro giornaliero** | `balance delle 00:00 CE(S)T − 5% del capitale INIZIALE`, misurato sull'**equity** (floating+swap+commissioni inclusi) | `dailyLoss = dayStart − equity` con `dayStart = BALANCE` catturato al reset; limite `= % · StartBalance` | ✅ **COMBACIA ESATTAMENTE**, anche nel dettaglio sottile: il riferimento è il **BALANCE**, non `max(balance,equity)` |
| **muro totale (2-Step)** | _"equity must not drop below **90% of the initial** account balance at any given time"_ — **STATICO** | `InpDDMode=0` → `totalDD = StartBalance − equity` | ✅ **COMBACIA** |
| **muro totale (1-Step)** | **TRAILING End-of-Day** (si aggiorna alle 23:59:59, **sale e non scende**) | `InpDDMode=1` → `piccoEquity(live) − equity` | ❌ **NON è la stessa cosa**: il nostro trailing insegue il **picco di equity intraday**, quello FTMO il **balance di fine giornata**. Il nostro è **più severo del vero** → prudente, ma costa operatività. ⛔ **Questo preset vale SOLO per il 2-Step** |
| **base di misura** | equity | `AccountInfoDouble(ACCOUNT_EQUITY)` | ✅ |
| **target di profitto** | +10% fase 1 · +5% fase 2 | 🔴 **il Guardian non ha nessun input di target** | ❌ **BUCO** (§ 4.1) |

> 🎯 **La conclusione che vale il cancello 4**: sui **muri** il Guardian è
> **già aritmeticamente giusto** per FTMO 2-Step. Non serve scrivere codice
> nuovo per proteggersi: serve **scegliere le soglie e l'ora**. Tutto ciò che
> manca (§ 4) sta **fuori** dai due muri.

---

## 2. 📜 LE REGOLE FTMO — cosa dobbiamo rispettare

🟡 Fonte: `backtest_pipeline/risultati_archivio/DOSSIER_PROP_CANDIDATE_2026-08-26.md`
§2 e §7, e la rilettura `docs/REGOLAMENTO_FTMO_2026-08.md` (13/08).
⚠️ **Etichetta onesta**: il dossier del 26/08 dichiara al §8 buco n.1 che
**nessuna pagina è stata aperta direttamente** (WebFetch `EGRESS_BLOCKED` su
tutti i domini). Sono regole **lette via ricerca e riconfermate contro un
dossier interno**, non citazioni verificate a schermo. **Prima di pagare
servono le risposte scritte del supporto** (regola D3).

| regola | valore | nota che ci riguarda |
|---|---|---|
| 🧱 **Muro giornaliero** | **5% del capitale INIZIALE**, sottratto al **balance delle 00:00 CE(S)T** | esempio ufficiale: 204.000 − 10.000 = 194.000 su un 200k |
| 🧱 **Muro totale** | **10% STATICO** sul capitale iniziale (equity mai sotto il 90%) | ✅ è l'unica prop del dossier che non ci obbliga a rifare un numero del metro |
| 🕐 **Reset giornaliero** | **00:00 CE(S)T** | = **23:00 ora server BCM** · = **01:00 ora server FTMO** (§ 3.3) |
| 🖥️ **Fuso server FTMO** | **GMT+2 inverno / GMT+3 estate** = **ora italiana + 1** tutto l'anno | 🟡 repo 13/08: _"All times are expressed in MetaTrader platform time — GMT+3, con cambi al DST"_ |
| 🎯 **Target** | +10% (Challenge) · +5% (Verification) | 🔴 il Guardian non lo conosce (§ 4.1) |
| 📅 **Tempo** | illimitato · **min. 4 giorni di trading per fase** | 🔴 il Guardian non li conta (§ 4.6) |
| 🤖 **EA** | ✅ ammessi. **Max 2.000 richieste server/giorno** | 🔴 mai contate (§ 4.7) |
| 🌙 **Overnight / weekend (SWING)** | ✅ nessuna restrizione | è il motivo per cui la candidata è lo **Swing** |
| 📰 **News (SWING / in Challenge)** | ✅ nessuna restrizione | ⚠️ diventa vincolante **solo** su un funded **Standard** (±2 min) |
| ⚖️ **Consistency** | nessuna sul 2-Step | |

### 🔴 LA QUESTIONE APERTA CHE IL MANDATO CHIEDE DI DICHIARARE

> **"= 23:00 ora server BCM… ma sul server della prop l'ora server sarà quella
> di FTMO, non BCM."** ✅ **Osservazione corretta, ed è più di un dettaglio:
> il preset di oggi è tarato sul server SBAGLIATO per il conto vero.**

`InpDailyResetHour` è **l'ora del server su cui gira il Guardian**. Oggi vale
`23` perché il Guardian gira su **BCM**. Sul terminale **FTMO** quel 23 sarebbe
**due ore fuori bersaglio** → il contatore giornaliero cambierebbe giorno alle
**21:00 CE(S)T**, cioè **tre ore prima** del reset vero: tre ore di perdite
finirebbero nel **giorno-prop sbagliato**, e il Guardian misurerebbe un budget
che FTMO non riconosce. La soluzione è al § 3.3, e **non è una modifica di
codice**: è un numero diverso.

---

## 3. 🎛️ IL PRESET PROPOSTO — un valore per riga, con la derivazione

> **Nome del file proposto (da creare SOLO dopo la firma):**
> `mql5/Presets/ABTG_Guardian_FTMO_CHALLENGE.set`
> **File NUOVO.** `ABTG_Guardian_FTMO_2Step.set` (il dry-run 100k) **non si
> tocca**: due file, due conti, nessuna sovrascrittura silenziosa.

### 3.1 📋 LA TABELLA DEL PRESET

| # | input | **valore proposto** | oggi (preset 18/08) | derivazione in una riga |
|---|---|---:|---:|---|
| 1 | `InpStartBalance` | **`= capitale nominale acquistato`** (es. `100000`) | `100000` | **mai 0**: i muri FTMO sono sul capitale **iniziale**, non sul balance del giorno in cui installi il Guardian |
| 2 | `InpDailyPausePct` | **`3.5`** | `4.0` | **70% del muro 5%**. Costo misurato: **2 giorni su 481** (§ 3.2) |
| 3 | `InpDailyLossPct` | **`4.4`** | `4.9` | **muro 5% − 0,6 pt di cuscinetto** dichiarato (§ 3.2) |
| 4 | `InpTotalDDPct` | **`9.0`** | `9.9` | **muro 10% − 1,0 pt**. Costa **0** in operatività misurata (§ 3.2) |
| 5 | `InpDDMode` | **`0`** (STATICO) | `0` | il 2-Step è statico. ⛔ **su 1-Step questo preset è NULLO** |
| 6 | `InpDailyResetHour` | **`1`** su server FTMO · `23` sul dry-run BCM | `23` | 00:00 CE(S)T = **01:00** server GMT+2/+3 (§ 3.3) |
| 7 | `InpAction` | **`0`** (CHIUDI+BLOCCA) | `0` | su un conto pagato l'allarme senza enforcement non serve a niente |
| 8 | `InpCloseAllMagics` | **`true`** | `true` | la regola prop è sul **conto**, non sulla sedia |
| 9 | `InpMaxOpenRiskPct` | **`3.25`** | `3.25` | **invariato** — FIRMA 3 del 18/08, nessuna misura nuova la contraddice |
| 10 | `InpRiskMode` | **`0`** (dall'ingresso) | `0` | **invariato**: è la convenzione M2 su cui il 3,25 è tarato |
| 11 | `InpWarnNoSL` | **`true`** | `true` | una posizione senza SL è **esclusa dal cap**: va vista nel giornale |
| 12 | `InpShowPanel` | **`true`** | `true` | il pannello è il controllo del mattino (§ 4.5) |
| 13 | `InpVerbose` | **`true`** | `true` | il log ogni 5 min è l'unico storico che avremo del conto FTMO |
| 14 | `InpMagic` | **`779001`** | `779001` | invariato (serve solo ai suoi log) |
| 15 | `InpComment` | **`GUARDIAN FTMO CHALLENGE`** | `GUARDIAN FTMO 2STEP` | distingue i giornali dei due conti |
| 16 | `InpAutotest` | **`true` al PRIMO avvio, poi `false`** | *(assente)* | costa zero, non tocca il conto, e prova **il filo** (che il Guardian scriva dove gli EA leggono) su un terminale mai usato prima |

🔵 **Le tre righe che cambiano un valore già firmato sono la 2, la 3 e la 4.**
Le altre tredici sono conferme o rimappature. È giusto che sia così: la firma
del 18/08 non era sbagliata, è **invecchiata di una misura** (§ 3.2).

### 3.2 🧮 DA DOVE VENGONO I TRE NUMERI NUOVI

#### 🟥 EMERGENZA GIORNALIERA: **4,4%** (era 4,9%)

**Il muro è 5,0%. Il cuscinetto proposto è 0,6 punti = 600 € su un 100k.**

Perché **allargare** un numero già firmato? Perché il 4,9 (_"un decimo di punto
PRIMA del muro"_, `FIRME_2026-08-18.md` FIRMA 1) è stato scelto il **18/08**,
e l'**R109 del 26/08** ha misurato una cosa che allora non sapevamo. La
"regola di ripensamento" dello stesso verbale dice testualmente: _"ogni firma
si riapre SOLO con una misura nuova che la contraddica, per iscritto"_. **È
esattamente questo il caso**, ed è per questo che sta qui e non in un commit.

Cosa deve coprire il cuscinetto — 🔵 **[INFERITO]**, con le fonti accanto:

| voce | ordine di grandezza | fonte |
|---|---|---|
| **slippage in chiusura d'emergenza** | 🥇 **21,5 punti misurati** su uno stop Nasdaq reale = **perdita doppia dell'attesa** su quel trade | `R109_REFERTO.md` |
| — proiettato sull'esposizione | con il cap C1 a 3,25% di rischio aperto, un extra del 10-20% sulla chiusura = **0,3-0,65 pt** 🔵 | inferenza mia, **non misurata** |
| **latenza** | 1 s di timer + una `PositionClose` per posizione in sequenza (~0,1-0,3 s l'una): con 10 posizioni **1-3 s** di esposizione in più 🔵 | `OnTimer`/`FlattenAll` |
| **costi di chiusura** | commissioni + swap sulle posizioni chiuse in blocco | — |

> ⚖️ **Onestà obbligatoria**: il 21,5 è **UNA misura, su UNO strumento**. Il
> 0,6 non è "il numero giusto": è **un ordine di grandezza difendibile**, e
> lo dichiaro come tale. Chi vuole 4,5 o 4,3 non sta sbagliando: sta pesando
> lo stesso rischio con un'altra mano.
>
> 🚨 **E il cuscinetto è una PERCENTUALE**: su 500k valgono 3.000 €, ma
> **anche lo slippage cresce con la taglia** (R109). Alla taglia grande il
> 0,6 pt **va rimisurato**, non ereditato → è dentro il **cancello 6**.

#### 🟨 PAUSA MORBIDA: **3,5%** (era 4,0%)

**Questo è l'unico numero del preset di cui conosciamo il COSTO MISURATO.**
🥇 `ANALISI_DIAL_TAGLIE_2026-08-26.md` T1, 481 giorni × 40 sedie, dial 1,00:

| soglia | quanti giorni su 481 l'avrebbero fatta scattare | in % dei giorni |
|---|---:|---:|
| **−3,5% (proposta)** | **2** | 0,42% |
| −4,0% (oggi) | **1** | 0,21% |
| −5,0% (il muro) | **0** | 0% |

👉 Passare da 4,0 a 3,5 **raddoppia le accensioni: da 1 a 2 in 21 mesi.** È un
prezzo che si legge, non che si teme.

**E c'è un motivo strutturale più forte del costo**: con emergenza a 4,4, una
pausa a 4,0 lascia un **corridoio di soli 0,4 punti**. Il senso della pausa è
smettere di **aggiungere** rischio mentre c'è ancora spazio per gestire quello
in campo; in 0,4 punti non c'è spazio per niente. **A 3,5 il corridoio è 0,9
punti** — più del doppio.

> 🔴 **IL LIMITE CHE VA DETTO AD ALTA VOCE, ed è il più serio di tutto il
> documento**: quei "2 giorni su 481" sono calcolati sulle **CHIUSURE
> giornaliere**. Il Guardian **guarda il FLOTTANTE**, che è più mosso. **Il
> numero vero di accensioni della pausa è più alto — e non l'abbiamo mai
> misurato.** L'unico modo di saperlo è il **dry-run sul 100k** (decisione 9).
> Chi firma il 3,5 sta firmando un costo di operatività **stimato, non noto**.

#### ⬛ EMERGENZA TOTALE: **9,0%** (era 9,9%)

🥇 `ANALISI_DD_TOTALE_2026-08-26.md`, stesso banco, dial 1,00:

| misura | valore | contro il muro 10% |
|---|---:|---|
| **DD totale worst** | **−6,37%** | 3,6 pt di margine |
| p99 | −5,83% | |
| **worst day** | **−4,74%** | **0,26 pt dal muro del 5%** |

👉 **Il vincolo che morde è il GIORNALIERO, non il totale** (margine 5% contro
36%). Conseguenza diretta: **allargare il cuscinetto sul totale da 0,1 a 1,0
punti costa ZERO operatività misurata** — in 481 giorni non si sarebbe mai
attivato né a 9,9 né a 9,0. È **margine comprato gratis**, e serve proprio nel
caso in cui l'emergenza giornaliera **fallisca** (gap, VPS spento, latenza).

> ⚠️ **Il prezzo vero, e non è in punti percentuali**: a −9% il Guardian
> **latcha `GV_FAILED` per sempre** e ci ferma la challenge **da soli**, con
> 1 punto ancora disponibile. È una **rinuncia volontaria**, non un breach.
> Va firmata sapendolo — e sapendo che è **reversibile a mano** (cancellare
> `ABTG_GUARD_<login>_FAILED` dal terminale), mentre il muro FTMO **non lo è**.
> A −9% di DD totale con un banco che ha come peggior caso −6,37%, comunque,
> **non è "sfortuna": è la macchina che si sta comportando diversamente da
> come è stata misurata**. Fermarsi è la risposta giusta.

### 3.3 🕐 IL RESET GIORNALIERO E IL CONFLITTO B3 — **buona notizia, con una postilla**

**Il conflitto B3 del PIANO_PROP suona così:** _"`InpDailyResetHour` è un intero
fisso, ma il reset FTMO è alle 00:00 CE(S)T e si muove col DST"_.

#### ✅ La misura scioglie metà del conflitto

🟡 `docs/REGOLAMENTO_FTMO_2026-08.md` §10: **il server FTMO è GMT+2 d'inverno e
GMT+3 d'estate, "con cambi al DST"** = **ora italiana + 1, tutto l'anno**.
(Controprova nello stesso documento: il DAX apre alle **10:00 ora server FTMO**,
cioè 09:00 italiane + 1 — e vale sia d'estate sia d'inverno.)

Se il server **si sposta insieme** al CE(S)T, allora:

```
     inverno:  00:00 CET  (UTC+1)  →  server GMT+2  →  01:00
     estate:   00:00 CEST (UTC+2)  →  server GMT+3  →  01:00
     ------------------------------------------------------
     👉 InpDailyResetHour = 1, FISSO, TUTTO L'ANNO
```

> 🎯 **Il DST non muove il numero, perché muove ENTRAMBI gli orologi insieme.**
> Il conflitto B3, sul server FTMO, **non esiste**: il valore è `1` e resta `1`.
> (Lo stesso vale, per la stessa ragione, per il `23` su BCM: BCM = italiana − 1
> tutto l'anno → 00:00 CE(S)T = 23:00 BCM sempre.)

#### 🔴 La postilla che resta, ed è precisa

Il ragionamento regge **solo se FTMO cambia l'ora negli stessi GIORNI
dell'Europa**. Moltissimi broker MT5 "GMT+2/GMT+3" cambiano invece sulle **date
americane**, e in quel caso per **due-tre settimane l'anno** l'offset diventa
**+2** invece di +1 — e il reset andrebbe messo a **2**, non a 1.

**Le due finestre a rischio, con le date:**

| finestra | cosa succede | reset corretto se FTMO segue le date USA |
|---|---|---|
| **25/10/2026 → 01/11/2026** | l'Europa torna all'ora solare il **25/10**, gli USA l'**01/11** | ⚠️ **`2`** per quella settimana |
| **14/03/2027 → 28/03/2027** | gli USA passano all'ora legale il **14/03**, l'Europa il **28/03** | ⚠️ **`2`** per quelle due settimane |

**🔬 Come si verifica in 10 secondi, senza credere a nessuno** (da fare il
primo giorno sul terminale FTMO e **di nuovo dentro le due finestre**):

> apri un grafico qualsiasi e confronta **l'ora dell'ultima candela M1**
> (= ora server) con **l'orologio di Windows** (= ora italiana sul VPS).
> **Differenza attesa: +1.** Se leggi **+2**, `InpDailyResetHour` va messo a
> **`2`** finché non torna +1.
> ⚠️ E ricorda la regola di casa imparata sbagliando il 06/08: **le schede
> Esperti e Giornale sono in ORA LOCALE del PC, il grafico è in ORA SERVER.**
> Il confronto si fa **col grafico**, mai col log.

#### 🅰️ SOLUZIONE PROPOSTA (in vigore da subito, **zero codice**)

1. `InpDailyResetHour = 1` sul terminale FTMO — 🔴 **[INCERTO]** finché il
   supporto non conferma **per iscritto** il fuso (domanda già in coda, regola D3);
2. **verifica del grafico** il primo giorno (procedura sopra);
3. **promemoria di cambio d'ora agli atti**, due date l'anno: **25/10/2026** e
   **14/03/2027** → si rifà la verifica, e **se serve si cambia il numero a mano**
   (30 secondi: si ricarica il preset).

#### 🅱️ SECONDA OPZIONE — **modifica futura del Guardian** (tocca codice → round suo)

Il difetto della 🅰️ è che dipende da un promemoria, e i promemoria si saltano.
La versione robusta **non aggiunge un flag DST** (un flag va comunque girato a
mano: sposta il problema, non lo risolve) ma fa **derivare l'ora da sola**:

> **Nuovo input `InpResetTZ`** = il fuso in cui la prop dichiara il reset
> (`CE(S)T`, `UTC`, `EST`…). Il Guardian calcola l'offset del **suo** server
> confrontando `TimeCurrent()` con `TimeGMT()`, applica la regola DST del fuso
> dichiarato, e ricava **da solo** l'ora di reset a ogni giro di timer.
> `InpDailyResetHour` resta come **scavalco manuale** (default = automatico).
>
> ✅ Immune al disallineamento delle date DST · ✅ funziona su **qualunque**
> prop (è la stessa cosa che serve alla riga B10, "un preset per famiglia di
> muri") · ⚠️ dipende dall'orologio e dal fuso del **VPS**, che vanno giusti ·
> ⚠️ **è codice nuovo su un componente che oggi funziona**: vuole un round suo,
> con autotest, **e non si accende su un conto pagato senza averlo visto girare**.

**Perché la 🅰️ è la proposta e la 🅱️ è la seconda opzione**: la 🅰️ costa un
numero e un promemoria; la 🅱️ costa un round e introduce rischio nuovo dentro
il componente che ci deve salvare. **Sul conto della prima challenge si va con
il numero fisso.**

---

## 4. 🕳️ COSA IL GUARDIAN **NON** SA FARE — buchi dichiarati, uno per uno

> Ognuno ha la sua **proposta**: 🟢 *accetto il rischio residuo* (procedura, non
> codice) oppure 🔧 *modifica codice futura, round suo*.

### 4.1 🎯 NON CONOSCE IL TRAGUARDO — **il buco più grave**

Il Guardian **non ha nessun input di target**. Difende dal muro in basso, non
sa nulla del **+10%**. Il giorno in cui la challenge è **già vinta**, la flotta
continua ad aprire e **un brutto pomeriggio può restituire tutto**.

🥇 Il meccanismo **esiste già a metà**: `ABTG_PausaGuardian.mqh` v1.40 ha lo
**stop S1** completo (soglia, latch persistente, autotest). Ma:
- 🥇 **nessun EA lo usa**: `InpTargetPct` / `InpSaldoRiferimento` compaiono in
  **0 file** su 60 (verificato in questo giro);
- **S1 non chiude**: blocca solo le aperture. Le posizioni vive restano.

> 🔧 **PROPOSTA — modifica codice futura, round suo.** Portare il target
> **dentro il Guardian** (non dentro 60 EA): `InpTargetPct` + `InpTargetAction`
> (0 = solo pausa · 1 = chiudi tutto e fermati). Il Guardian **sa già chiudere**
> — è la stessa `FlattenAll()`. Due input e tre righe, ma è **codice nuovo sul
> pezzo che ci protegge**: vuole autotest e dry-run.
> ⚠️ E vuole **due preset**, perché il target cambia fra le fasi: **+10%** in
> Challenge, **+5%** in Verification.
> 🟢 **Nel frattempo**: **presidio manuale**. A +8% si guarda il pannello ogni
> giorno; a +10% **si spengono gli EA a mano**. Funziona, ma dipende da una
> persona sveglia — ed è esattamente ciò che una challenge vinta non merita.

### 4.2 🌅 LA BASELINE DEL GIORNO SI PERDE SE IL GUARDIAN NON GIRA AL RESET

🥇 In `OnInit`, se il giorno prop è cambiato, il Guardian scrive
`GV_DAYSTART = balance ATTUALE`. Se il VPS è spento all'01:00 e riparte alle
08:00, la baseline è **quella delle 08:00**.

**Perché è un problema vero e non teorico**: gli **SL e i TP stanno sul
server** ed eseguono anche a terminale spento. Una posizione che va in stop
alle 03:00 mentre il VPS è giù abbassa il balance; alle 08:00 il Guardian
cattura **il balance già abbassato** e **quella perdita sparisce dal contatore
giornaliero**. Il Guardian misurerebbe un budget **più largo del vero**, e
FTMO no. **È l'unico buco che può far sfondare il muro senza che il Guardian
se ne accorga.**

> 🔧 **PROPOSTA — modifica codice futura, round suo** (piccola e chiusa):
> ricostruire la baseline dalla cronologia invece di catturarla —
> `HistorySelect(reset, adesso)`, somma dei netti, `dayStart = balance − somma`.
> Il mattone c'è già: `ABTG_InizioGiornoServer_Calc()` nell'include.
> 🟢 **Nel frattempo**: **VPS sempre acceso** (già la prassi) **+ controllo del
> mattino**: la riga _"Inizio giorno"_ del pannello contro il balance dello
> statement. **Se il VPS è stato giù durante la notte, la baseline va rifatta
> a mano** cancellando `ABTG_GUARD_<login>_DAYKEY`. ⚠️ Questa procedura oggi
> **non è scritta da nessuna parte**: se si firma il preset, va scritta.

### 4.3 🔌 LA PAUSA VALE SOLO PER CHI LA LEGGE — e c'è una **divergenza fra le carte e il codice**

Pausa (B1) e cap (C1) **non hanno potere**: scrivono una GlobalVariable.

**Cosa dicono le due fonti — e non dicono la stessa cosa:**
- 📄 `report/PIANO_PROP.md`, cancello 4: _"**manca l'enforcement**: gli EA non
  leggono ancora le bandiere del Guardian"_;
- 🥇 **il sorgente, contato in questo giro**: **60 file** in `mql5/Experts/`
  contengono `ABTG_GuardiaIngresso(...)`, con `InpUsaGuardian = true` di
  **default**. La migrazione **è stata fatta** (commit `1f4c92b`, 19/08).

> 🔎 **La spiegazione più probabile 🔵**: la riga del PIANO_PROP è **vecchia**
> rispetto al codice. **Ma esiste una seconda spiegazione, e sarebbe peggio:**
> che i **`.ex5` compilati sul VPS siano più vecchi dei `.mq5`**. In quel caso
> il Guardian scriverebbe la pausa e **nessuno la leggerebbe**, in silenzio,
> senza un solo errore nel giornale.
>
> 🟢 **PROPOSTA — controprova d'adozione, PRIMA di firmare** (costa 5 minuti,
> non è codice): sul terminale, **ricompilare tutta la flotta** e verificare
> che ogni sedia viva abbia l'input `InpUsaGuardian` visibile nella finestra
> delle proprietà. Una sedia senza quell'input **è cieca alla pausa**.
> ➕ Verificare anche l'altra metà del filo: all'avvio il Guardian scrive
> _"filo verificato: 5 GlobalVariable su 5"_ (v1.11). **Se quella riga non
> c'è nel giornale, il canale è rotto.**

### 4.4 ⚡ NON PUÒ NIENTE CONTRO UN GAP

Il Guardian guarda l'equity **una volta al secondo**. Un gap di apertura
(lunedì, o dopo una headline) può portare l'equity **oltre il muro fra due
giri**, e non c'è soglia che lo impedisca: **quando lo vede, è già successo.**

⚠️ E il conto **Swing** è proprio quello che ci **permette** di tenere posizioni
nel weekend — cosa che tre nostre sedie fanno. 🥇 E il peggior giorno di tutto
il banco è **il "lunedì dei gap" del 25/05/26** (cluster GapFill).

> 🟢 **PROPOSTA — accetto il rischio residuo**, ed è **una delle due ragioni**
> del cuscinetto più largo (4,4 invece di 4,9). Alternative reali, tutte fuori
> dal Guardian e tutte da firmare a parte: chiusura del venerdì
> (`InpFridayClose`, già ipotizzata nel PIANO_PROP §1), filtro news (D1/D5,
> **spenti**), o non tenere il weekend. **Nessuna è in questo preset.**

### 4.5 🟨 IL GUARDIAN NON HA UN ALLARME SUL MURO TOTALE — e il mandato ne chiede uno

Il mandato propone _"muro totale: **allarme a −8%**, emergenza a −9%"_.
🥇 **L'allarme a −8% oggi NON è configurabile**: `InpTotalDDPct` è **una sola
soglia**, e fa scattare direttamente l'emergenza. **La pausa morbida esiste
solo sul giornaliero.** Non c'è nessun valore da mettere nel preset che
produca il comportamento richiesto.

> 🔧 **PROPOSTA — modifica codice futura, round suo**: nuovo input
> `InpTotalPausePct` (default `0` = spento, quindi **no-op assoluto** per chi
> non lo usa) che, superata la soglia, chiama la **stessa `SetPausa()`** già
> esistente. È **la modifica più piccola di tutto l'elenco**: una riga di
> input e un `if` accanto a quello della pausa giornaliera.
> 🟢 **Quanto costa non averlo, misurato**: al dial firmato il DD totale worst
> è **−6,37%** → in 481 giorni un allarme a −8% **non sarebbe MAI scattato**.
> **Il buco è reale ma il suo costo, alla taglia misurata, è zero.**
> ➕ **Surrogato a costo zero, da subito**: il pannello mostra già DD totale e
> percentuale. **L'allarme a −8% lo fa Claudio guardando il pannello.**

### 4.6 📅 NON CONTA I 4 GIORNI MINIMI DI TRADING

FTMO chiede **almeno 4 giorni di trading per fase**. Il Guardian non li conta.
🟢 **PROPOSTA — accetto il rischio residuo**: non è un muro, è una condizione
di consegna, e 🥇 la mediana della challenge nel nostro banco è **12 giorni** —
il vincolo è lontanissimo. Si guarda a mano quando si arriva al target.

### 4.7 📡 NON CONTA LE 2.000 RICHIESTE SERVER/GIORNO

🔴 Buco **nostro**, non delle fonti: non abbiamo **mai** contato le richieste
che la flotta genera. Gli EA con trailing che modificano l'SL a ogni barra
fanno `OrderModify` in quantità, e con **35+ sedie** il tetto non è ovviamente
lontano.
> 🟢 **PROPOSTA — misura di casa PRIMA della challenge** (non è codice del
> Guardian): si contano le righe di ordine/modifica nel giornale di una
> giornata piena del dry-run 100k e si moltiplica. Se il numero è vicino a
> 2.000, **è un problema di configurazione della flotta**, non del Guardian.
> 🔧 *(Solo se serve)* contatore giornaliero nel Guardian con allarme: round suo.

### 4.8 ⚖️ NON CONOSCE LE REGOLE DI CONDOTTA

**Gap trading**, **one-sided bets**, **regola dei ±2 minuti** (sui funded
Standard): 🟡 sono le tre clausole che il dossier segna in rosso, e **due
colpiscono direttamente noi** (la famiglia GapFill; le sedie mono-direzione
tipo `MaxMinNotte_DAX_Short`). Il Guardian non ne sa niente e **non è il posto
per metterle**.
> 🟢 **PROPOSTA — fuori da questo preset**: si risolvono con le **risposte
> scritte del supporto** (D3, già in coda) e con la **composizione della
> flotta**, non con una soglia. Vanno però **dette qui**, perché il Guardian
> potrebbe non fermare mai il conto e la challenge fallire lo stesso.

### 4.9 🛡️ SE IL GUARDIAN MUORE, LA FLOTTA CONTINUA (fail-open)

🥇 `ABTG_GuardiaIngresso(...)` ha `pretendi_guardian = false` di default, e
**nessun EA passa `true`** (verificato: 0 occorrenze). Guardian morto →
gli EA aprono lo stesso. È una scelta dichiarata (_"un cane da guardia morto
non deve fermare la flotta per sempre"_) — **giusta sul demo, discutibile su
un conto pagato**.
> 🔧 **PROPOSTA — modifica codice futura, round suo** (piccola): un input
> `InpPretendiGuardian` (default `false`) da mettere a `true` **solo nei preset
> prop** → sul conto FTMO nessuno apre se il cane non batte.
> 🟢 **Nel frattempo**: il battito è visibile nel pannello e nel giornale; il
> controllo del mattino (§ 4.2) lo copre.
> ⚠️ **Attenzione al rovescio**: un Guardian che va in errore **blocca l'intera
> challenge**. Il fail-closed va acceso **solo dopo** che il dry-run ha
> dimostrato che il Guardian non muore da solo.

### 4.10 🧾 `FlattenAll()` NON CONTROLLA I RETCODE

🥇 Chiude e conta i successi; **non legge il codice di errore**, non fa retry
esplicito, non gestisce le modalità di riempimento. Il recupero è indiretto
(ri-chiama ogni secondo finché il conto è piatto) — funziona, **ma nel
giornale non resterà scritto PERCHÉ una chiusura è fallita**.
> 🔧 **PROPOSTA — modifica codice futura, round suo** (cosmetica ma preziosa
> il giorno dopo): loggare `retcode` e descrizione a ogni chiusura fallita.
> 🟢 **Nel frattempo**: rischio residuo **basso** (il retry a 1 s c'è).

### 4.11 📏 IL CAP C1 È IN % DELL'EQUITY, I MURI SONO SUL CAPITALE INIZIALE

🥇 `OpenRiskPct()` divide per l'**equity corrente**. Se l'equity scende, il cap
**si stringe da solo** (a −5% di equity, 3,25% di equity = 3,09% del capitale
iniziale). ✅ **Va nella direzione giusta** (più prudente proprio quando serve),
ma è **un'unità di misura diversa da quella dei muri**.
> 🟢 **PROPOSTA — accetto il rischio residuo, e lo dichiaro**: l'effetto è
> conservativo e piccolo. Cambiarlo vorrebbe dire **ritarare il 3,25**, cioè
> riaprire la FIRMA 3 senza una misura nuova che lo chieda. **Non si tocca.**

### 4.12 🔢 NON SA NIENTE DELLA TAGLIA

Tutte le soglie sono **percentuali** → trasferibili a qualunque taglia **solo
se la scala dei lotti è lineare**. 🥇 R109 ha misurato che **non lo è**
(`SYMBOL_VOLUME_MAX` = 100 → **66 trade su 743 = 8,9%** tagliati; slippage
**21,5 pt** che cresce con la taglia).
> 🟢 **PROPOSTA — è il CANCELLO 6, non questo documento**: la firma di questo
> preset **non autorizza nessuna taglia**. Se si compra oltre 100k, il
> cuscinetto del § 3.2 **va rimisurato alla taglia target**.

---

## 5. 📊 RIEPILOGO — cosa cambia e cosa no

| | oggi (100k dry-run) | **proposta (solo FTMO)** | Δ |
|---|---:|---:|---|
| pausa morbida | 4,0% | **3,5%** | −0,5 pt |
| emergenza giorno | 4,9% | **4,4%** | −0,5 pt |
| emergenza totale | 9,9% | **9,0%** | −0,9 pt |
| DD mode | statico | **statico** | = |
| reset | 23 (BCM) | **1 (server FTMO)** | rimappato |
| cap C1 | 3,25% | **3,25%** | = |
| azione | chiudi+blocca | **chiudi+blocca** | = |

**Cuscinetti dichiarati:** giornaliero **0,6 pt** (600 € su 100k) ·
totale **1,0 pt** (1.000 € su 100k) · corridoio pausa→emergenza **0,9 pt**.

**Cosa NON è coperto da questo preset, e va saputo prima di firmare:**
🎯 il traguardo (§4.1) · 🌅 la baseline se il VPS è giù (§4.2) · ⚡ i gap (§4.4) ·
🟨 l'allarme a −8% (§4.5) · 📡 le 2.000 richieste (§4.7) · ⚖️ le clausole di
condotta (§4.8).

---

## ✍️ BLOCCO FIRMA — 🖊️ **FIRMATO**

> **FIRMA: "FIRMO GUARDIAN" — Claudio, 27/08/2026 notte (00:10 circa,
> testuale: "FIRMO GUARDIAN R113 ED ANDIAMO AVANTI ANCORA UN PO").**
> La firma copre le **10 decisioni con le proposte e le raccomandazioni
> come scritte**, compresa la **decisione 9 nella versione raccomandata**:
> le soglie nuove **si provano prima sul dry-run 100k** (unico modo di
> misurare la pausa a 3,5% sul flottante) — quindi il 100k cambierà
> preset con questa autorizzazione. La decisione 10 (i 5 prerequisiti
> a-e) resta un ELENCO DA ESEGUIRE prima del conto pagato: firmarla non
> la esegue. Le righe 1-3 riaprono consapevolmente le soglie della
> FIRMA 1 del 18/08 con la misura nuova di R109 (regola di ripensamento
> rispettata, come argomentato nel § 3).

> Si firma scrivendo **`FIRMO PRESET GUARDIAN FTMO`**, indicando **quali
> decisioni** si accettano (per numero) e quali si rimandano.
> **Firma parziale ammessa e anzi consigliata**: ogni riga è indipendente.

| # | decisione da firmare | cosa comporta |
|---|---|---|
| **1** | 🟥 **Emergenza giornaliera a `4,4%`** (era 4,9 — modifica di un valore FIRMATO il 18/08) | riapre la FIRMA 1 punto 2, ed è legittimo per la "regola di ripensamento": la misura nuova è lo **slippage 21,5 pt** di R109 (26/08). ⚠️ Il cuscinetto 0,6 pt è 🔵 **[INFERITO]**, non misurato |
| **2** | 🟨 **Pausa morbida a `3,5%`** (era 4,0) | costo misurato **2 giorni su 481** (chiusure); 🔴 **sul flottante è più alto e non lo sappiamo**. Serve a dare 0,9 pt di corridoio prima dell'emergenza |
| **3** | ⬛ **Emergenza totale a `9,0%`** (era 9,9) | margine gratis (0 accensioni in 481 giorni), **ma è una rinuncia volontaria a 1 pt dal muro**, reversibile solo a mano |
| **4** | 🧱 **`InpDDMode = 0` STATICO + vincolo "SOLO 2-Step"** | ⛔ se il conto acquistato è **1-Step**, questo preset **è nullo** e va rifatto (là il muro è trailing EOD) |
| **5** | 🕐 **`InpDailyResetHour = 1`** sul terminale FTMO (00:00 CE(S)T = 01:00 server GMT+2/+3) | 🔴 **[INCERTO]** finché il supporto non conferma per iscritto. Sostituisce il `23`, che vale **solo** su BCM |
| **6** | 📅 **Soluzione DST = opzione 🅰️** (valore fisso + verifica del grafico + promemoria **25/10/2026** e **14/03/2027**) | l'opzione 🅱️ (Guardian che ricava l'ora da solo) **NON si firma oggi**: è codice nuovo sul componente che ci protegge → **round suo, dopo la prima challenge** |
| **7** | 🔵 **Conferma senza modifiche di `InpMaxOpenRiskPct = 3,25` e `InpRiskMode = 0`** | la FIRMA 3 del 18/08 resta in piedi: nessuna misura nuova la contraddice |
| **8** | 🕳️ **Presa d'atto dei rischi residui accettati** (§4.4 gap · §4.6 4 giorni · §4.8 condotta · §4.11 unità del cap · §4.12 taglia) e dei **4 lavori di codice rimandati** (§4.1 target · §4.2 baseline · §4.5 allarme −8% · §4.9 fail-closed), **ognuno con un round proprio** | firmare l'8 significa dire: **"so che il Guardian non copre queste cose, e vado avanti lo stesso"** |
| **9** | 🧪 **Il percorso del preset**: file **NUOVO** `ABTG_Guardian_FTMO_CHALLENGE.set`, `ABTG_Guardian_FTMO_2Step.set` **intatto**. ❓ **Domanda aperta a Claudio**: le soglie nuove si **provano prima sul dry-run 100k** (e allora il 100k cambia, contro la nota qui sotto) **oppure** vanno in campo **mai viste girare**? | La FIRMA 1 del 18/08 dice: _"il conto vero non si tocca finché Claudio non ha visto girare il tutto sul 100k"_. **Per rispettarla il 100k va toccato.** 🔵 **La mia raccomandazione: provarle sul 100k**, perché è l'unico modo di misurare quante volte scatta davvero la pausa a 3,5% **sul flottante** (il buco dichiarato al §3.2) |
| **10** | ✅ **Prerequisiti da eseguire PRIMA che il preset vada su un conto pagato** (nessuno è codice): **(a)** controprova d'adozione della flotta §4.3 · **(b)** riga _"filo verificato: 5 su 5"_ nel giornale · **(c)** `InpAutotest=true` al primo avvio · **(d)** verifica del fuso col grafico §3.3 · **(e)** procedura scritta per la baseline dopo un VPS spento §4.2 | sono **cinque controlli**, non cinque sviluppi |

### 📌 NOTA FINALE — perimetro della firma

> ⚠️ **Questo preset si applica SOLO al futuro conto FTMO.**
> **NON tocca il demo BCM 50503392 né il dry-run 100k**, che continuano con le
> soglie firmate il 18/08 (**4,0 / 4,9 / 9,9 / reset 23 / DD statico**) — a
> meno che non si firmi **anche** la decisione 9 nella versione "provale sul
> 100k", che è una **decisione separata e va detta esplicitamente**.
>
> 🛑 **E questo documento non autorizza l'acquisto di nessuna challenge.**
> Il cancello 4 è **uno dei sei**, e gli altri cinque sono nello stato di ieri:
> 🔴 cancello 1 (forward), 🟡 cancello 2 (contratti), 🔴 cancello 3 (scelta della
> prop), 🔴 cancello 5 (due-dial), 🔴 cancello 6 (prova della taglia).
> Vale ancora il vincolo di calendario: 📅 **Jackson Hole 27-28/08** — non si
> inizia niente prima che sia passato.
>
> 🧊 **E vale la regola di ripensamento**: ogni numero qui sopra si riapre
> **solo** con una misura nuova che lo contraddica, per iscritto. Mai a caldo,
> mai in silenzio, **mai dopo aver visto chi colpisce**.
