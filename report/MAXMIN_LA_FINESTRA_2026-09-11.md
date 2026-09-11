# 🌙 MAXMIN — LA FINESTRA DEL BOX NOTTURNO: cosa dice davvero l'archivio

**11/09/2026 · scavo d'archivio, ZERO backtest nuovi · branch `lavoro`**
Domanda di partenza: *`InpBoxEndHour=6` (la notte di Claudio, 00:00–08:00
italiane) è già stato girato contro `=4` (i preset vivi)? Chi vince?*

---

# 🛑 LA RISPOSTA IN UNA RIGA, e non è quella che speravamo

> ## ❌ **IL CONFRONTO NON ESISTE IN ARCHIVIO. Non una riga.**
> Su **526 righe di CSV** con la colonna `InpBoxEndHour`, le coppie di celle
> che differiscono **SOLO** per quel valore sono **ZERO**.
> `end=4` ed `end=6` non si sono **mai incontrati** sullo stesso simbolo,
> nello stesso round, con lo stesso resto.
> 👉 **Mi fermo qui sul confronto**, come da mandato. Un confronto con due
> cose che cambiano non è un confronto.

🟢 **Ma lo scavo non è stato a vuoto: ha trovato altre tre cose, una delle
quali è più grossa della domanda di partenza.** Sono ai §4, §5 e §6.

---

# 📊 1. LA MAPPA DELLE 526 RIGHE — chi ha girato cosa

**[MISURATO]** `61 file CSV`, `526 righe`, trovati con
`grep -rl InpBoxEndHour --include=*.csv` su tutto il repo.
Script di scansione riproducibile:
`/tmp/.../scratchpad/pair.py` (conteggio) e `pair2.py` (accoppiamento).

## 1a. La distribuzione, cruda (simbolo × start × end)

| simbolo | `BoxStartHour` | `BoxEndHour` | righe | motore |
|---|---:|---:|---:|---|
| D30EUR | 23 | **4** | 154 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` |
| 100GBP | 23 | **4** | 72 | `ABTG_MaxMinNotte` |
| E50EUR | 23 | **4** | 72 | `ABTG_MaxMinNotte` |
| F40EUR | 23 | **4** | 72 | `ABTG_MaxMinNotte` |
| EURUSD | 23 | **4** | 4 | `ABTG_MaxMinNotte` |
| **XAUUSD** | **22** | **6** | **112** | `ABTG_MaxMinNotte` |
| AUDUSD · D30EUR · EURCHF · EURUSD · GBPUSD · U30USD · USDCHF · USDJPY · XAGUSD · XAUUSD | 22 | **4** | 4 ciascuno (40) | `ABTG_Nightly` ⚠️ *altro EA* |

> ## 🔴 **`end=6` esiste SOLO sull'ORO. `end=4` esiste su tutto il resto.**
> Il valore della finestra è **perfettamente confuso col SIMBOLO** — e anche
> con l'ora di inizio (22 contro 23) e con l'orario di taglio ingressi
> (`InpEntryCutoffHour` 9 contro 8).

## 1b. I round, uno per uno

| round / file | simbolo | TF | modello | finestra | `start→end` | righe |
|---|---|---|---|---|---|---:|
| **FASE 0** `..._D30EUR_IS/OOS_ohlc.csv` | D30EUR | M15 | **OHLC M1** (screening) | IS 26/09/24→09/06/25 · OOS 10/06/25→30/06/26 | 23→4 | 4 |
| **FASE 0 tick** `..._D30EUR_IS/OOS.csv` | D30EUR | M15 | **tick reali** | idem | 23→4 | 4 |
| **R2** `..._r2.csv` | D30EUR | M15 | **tick reali** | idem | 23→4 | 10 |
| **R16b** `..._ptb.csv` | D30EUR | M15 | tick reali, dep. 100k | idem | 23→4 | 4 |
| **R81 a–f** `r81_csv/*.csv` | D30EUR | M15 | **tick reali**, dep. 100k | idem | 23→4 | 24 |
| **26/07/26** `valid_MaxMin_*.csv` | D30EUR·E50EUR·F40EUR·100GBP | *[NON MISURATO]* | real-tick (`REGISTRO_TEST.md` r.452) | *[NON MISURATO]* | 23→4 | 288+36 |
| **FASE 0** `ABTG_MaxMinNotte_EURUSD_*_ohlc.csv` | EURUSD | *[NON MISURATO]* | OHLC M1 | idem FASE 0 | 23→4 | 4 |
| **fase 1 oro** `oro_maxmin_fase1_*.csv` | XAUUSD | M5·M15·M30·H1 | **OHLC** (`NOTTE_ORO.md` r.35) | 2024.01→2026.06, **finestra unica** | **22→6** | 48 |
| **fase 2 oro** `oro_maxmin_fase2_*.csv` | XAUUSD | M5·M15·M30·H1 | **tick reali** (vecchio script) | **finestra unica, nessun IS/OOS** | **22→6** | 16 |
| **R17** `..._XAUUSD_*_r17.csv` | XAUUSD | M5 | **tick reali** | IS 2025.03→2025.09 · OOS 2025.09→2026.06 | **22→6** | 40 |
| **R19 / R19b** | XAUUSD | M5 | tick reali, dep. 100k | idem R17 | **22→6** | 8 |
| **FASE 0 Nightly** `ABTG_Nightly/*.csv` | 10 simboli | M5 | OHLC M1 | idem FASE 0 | 22→4 | 40 |

*(R100 e R103 hanno girato il MaxMinNotte ma producono referti-driver, non CSV
con le colonne dei parametri: non entrano nelle 526 righe. Ne parlo al §5.)*

---

# 🔬 2. PERCHÉ IL CONFRONTO NON SI PUÒ FARE — la prova, non l'opinione

Ho accoppiato le 526 righe su **tutti i parametri tranne `InpBoxEndHour`**,
con tre livelli di severità crescente di tolleranza:

| criterio di accoppiamento | coppie `4` vs `6` trovate |
|---|---:|
| tutti i parametri identici, stesso simbolo | **0** |
| tutti i parametri identici, **simbolo ignorato** | **0** |
| **solo le 16 colonne comuni a tutti i file**, magic/commento/spread ignorati | **0** |

**[MISURATO]** `pair2.py`, output: `relaxed pairs: 0`.

## L'unico incrocio possibile, e perché è vuoto
XAUUSD è l'unico simbolo che ha **sia** `end=4` **sia** `end=6` (start=22 in
entrambi). Ma:
- le 4 righe `end=4` vengono da **`ABTG_Nightly`**, che è un **motore diverso**
  (input diversi: `InpEdgeOffsetPips`, `InpSLpips`, `InpTPfrac`…);
- 🔴 e soprattutto **hanno fatto ZERO OPERAZIONI**:
  `ABTG_Nightly_XAUUSD_IS_ohlc.csv` → `Trades=0`, `Profit=0.00`;
  `ABTG_Nightly_XAUUSD_OOS_ohlc.csv` → `Trades=0`, `Profit=0.00`.
  (È il bug `PipSize()=_Point` già a registro, `REGISTRO_TEST.md` r.~478.)

> ### 🚫 **Non c'è niente da confrontare: da una parte 112 righe di oro, dall'altra quattro righe vuote di un altro motore.**

## 🧨 E c'è di peggio — `InpBoxEndHour` non è mai stato un ASSE
**[MISURATO]** In **tutti** i file prova del repo la manopola è **inchiodata**,
mai spazzolata: `grep "^InpBoxEndHour" backtest_pipeline/prove/*.txt | grep "||"`
restituisce solo forme `=N||N||0||N||**N**` (il flag finale `N` = *non
ottimizzare*):

```
R100_ABTG_MaxMinNotte_770402.txt:95       InpBoxEndHour=6||6||0||6||N
R103_..._D30EUR_770411.txt:119            InpBoxEndHour=4||4||0||4||N
R103_..._XAUUSD_770402.txt:115            InpBoxEndHour=4||4||0||4||N
R104_MaxMinDAX_MFE.txt:74                 InpBoxEndHour=4||4||0||4||N
R114_C2_MAXMIN.txt:45                     InpBoxEndHour=4||4||0||4||N
ABTG_Nightly_EURCHF_00_conta.txt:92       InpBoxEndHour=4||4||0||4||N
```
Zero occorrenze con flag `Y`.

> ## 🔓 **Questa è una CASELLA LIBERA, non una casella provata.**
> Esattamente il caso descritto nel mandato del 09/09: *"l'abbiamo già provato"
> a volte voleva dire "l'abbiamo girato senza che cambiasse niente".* Qui è
> anche peggio: non l'abbiamo girato **affatto**.

---

# 🧪 3. IL CONTRO-ESEMPIO OBBLIGATORIO — e mi smonta l'entusiasmo

La domanda del mandato: *se `end=6` andasse meglio, sarebbe perché il LIVELLO
è migliore o perché il BOX è più largo (rotture più rare e più "vere")?*

## 3a. Prima: la manopola MORDE? Sì, e si misura
`backtest_pipeline/risultati_archivio/MaxMin_Oro/ABTG_Notte_Study_XAUUSD.csv`
— **371 notti d'oro, 28/02/2025→04/08/2026**, con le colonne `ora_massimo` e
`ora_minimo` (ora SERVER dell'estremo della notte).

Le due ore che `end=6` aggiunge e `end=4` esclude sono **05 e 06 server**.
Se nessuno dei due estremi cade lì, i due box danno lo **stesso identico
livello** e la notte è indistinguibile.

| | notti | quota |
|---|---:|---:|
| estremo in 05 o 06 → **i due box danno livelli DIVERSI** | **212** | **57,1%** |
| entrambi gli estremi in 22–04 → **box IDENTICI, stesso trade** | 159 | 42,9% |
| *di cui: solo il MAX cambia* | 106 | |
| *di cui: solo il MIN cambia* | 103 | |
| *di cui: cambiano entrambi* | 3 | |

> ## ✅ **Su quasi 6 notti su 10 `end=4` ed `end=6` sono DUE STRATEGIE DIVERSE.** La manopola non è inerte: nessuno l'ha mai girata.

**Bonus utile:** la stessa misura sull'ora **22** (cioè il confronto
`start=22` contro `start=23`, l'altro confondente) dà **27 notti su 371 =
7,3%**. 👉 **Il confondente dell'ora di INIZIO vale ~1/8 di quello dell'ora di
FINE.** Non lo annulla, ma lo ridimensiona.

## 3b. Poi: il CONTRO-ESEMPIO. Quelle due ore contengono informazione?
🔴 **NO — e il numero bello di sopra NON dice quello che sembra.**

L'ipotesi alternativa è la **legge dell'arcoseno**: gli estremi di un cammino
casuale si addensano **ai bordi** della finestra. Quindi un 57% è atteso
**anche se in quelle due ore non succede niente di speciale**.
*(Lo dice già lo studio di casa: `NOTTE_ORO.md` r.21 — "le 06:00 non contano:
sono l'ultima ora della finestra".)*

Ho costruito il numero che produce l'ALTRA spiegazione, invece di limitarmi a
verificare che il mio tornasse:

| | valore |
|---|---:|
| **MISURATO** (239 notti con entrambi gli estremi in 00–06): estremo in 05/06 | **62,8%** |
| **CONTRO-ESEMPIO**: cammino casuale senza deriva, 7 ore × 60 minuti, 200.000 simulazioni | **70,5%** |

> ## 🔴 **Il dato reale sta SOTTO la previsione del "non c'è niente lì". Le due ore aggiunte NON mostrano nessuna informazione in più del puro effetto di bordo.**

✅ Cosa sopravvive: il **fatto meccanico** che i livelli cambiano su ~57% delle
notti. ❌ Cosa NON sopravvive: qualunque idea che 05:00–06:59 siano ore
"speciali" perché ci arriva l'Europa. **L'archivio non la sostiene.**

## 3c. E la seconda metà del contro-esempio: "più largo = meglio" è GIÀ misurato
Allargare il box allontana il livello di innesco. Ma nell'archivio esiste già
una manopola che allontana l'innesco **senza toccare la finestra oraria**:
`InpBufferPoints`. Se "più lontano = meglio" fosse la vera causa, si vedrebbe lì.

**[MISURATO]** oro, R17 tick reali, PF **mediano** su 5 valori di TF gestione:

| buffer | = dollari | PF mediano IS | PF mediano OOS |
|---:|---:|---:|---:|
| 50 | 0,50 $ | 0,951 | 1,466 |
| 150 | 1,50 $ | 1,173 | 1,687 |
| 250 | 2,50 $ | 1,120 | **1,988** |
| 350 | 3,50 $ | **2,327** | 1,866 |

e fase 1/2 (OHLC + tick, finestra unica) sul tratto largo, H1:
200→1,52 · 800→1,58 · 1400→1,24 · **2000→1,04**.

> ## ⚖️ **L'archivio dice: allontanare l'innesco AIUTA fino a ~2,5–3,5 $, e da lì in poi DANNEGGIA.** L'ampiezza mediana della notte d'oro è 41,6 $ (`NOTTE_ORO.md` r.24): due ore in più di box possono spostare il livello proprio dentro quella fascia buona.

### 🛑 IL LIMITE, DICHIARATO
**Con i dati d'archivio NON posso separare le due cause.** Il file delle 371
notti dà l'**ORA** dell'estremo, non il **PREZZO**: non so di quanti dollari si
sposta il livello quando l'estremo cade in 05/06. → **[NON MISURATO]**.
👉 Conseguenza operativa, e vale come vincolo di progettazione per chi il round
lo lancerà: **un asse su `InpBoxEndHour` da solo NON risponde alla domanda.**
Serve accanto un **controllo sul buffer**, altrimenti un eventuale "`end=6`
vince" è indistinguibile da "l'innesco era più lontano" — cosa che sappiamo già.

---

# 🏆 4. COSA SI PUÒ DIRE SUI DUE GRUPPI (e non è un confronto)

Le due famiglie girano su simboli, motori e finestre diversi. **Queste tabelle
NON si confrontano fra loro.** Le metto perché il mandato chiede i numeri, e
perché servono come base di partenza per il round che manca.

## 4a. `end=4` — DAX short (`D30EUR` M15, tick reali, IS 8,5 mesi / OOS 12,7 mesi)

| cella (buffer) | IS profit | IS PF | IS DD% | IS n | OOS profit | OOS PF | OOS DD% | OOS n | freq OOS |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 500 | 376,67 | 1,930 | 3,01 | 16 | **−26,03** | 0,957 | 3,61 | 16 | 0,041/g |
| 750 | 488,79 | 1,964 | 3,18 | 19 | 515,72 | 2,007 | 2,23 | 20 | 0,052/g |
| **1000 (VIVA)** | 477,51 | 1,921 | 3,07 | 20 | **618,31** | **2,192** | **1,88** | 21 | **0,054/g** |
| 1250 | 444,58 | 1,882 | 3,22 | 19 | **699,30** | 2,680 | 2,38 | 19 | 0,049/g |
| 1500 | 466,80 | 1,921 | 2,94 | 21 | 432,88 | 1,722 | 2,77 | 19 | 0,049/g |

Fonte: `risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato/..._IS_r2.csv` e
`..._OOS_r2.csv`. Frequenza calcolata su OOS = 386 giorni di calendario
(10/06/2025→30/06/2026).

🔴 **n = 16–21 per cella: MOLTO sotto i 150 dell'Emendamento A.** Per la regola
di casa il **MERITO qui è sospeso**; si legge solo il RISCHIO (DD 1,9–3,6%).
🔴 **E la frequenza è 0,05 op/giorno**: un ventesimo del pavimento di 1,00 —
che dal 07/09 si misura per FAMIGLIA, non per sedia, ma resta lontanissimo.

## 4b. `end=6` — ORO (`XAUUSD` M5, tick reali, R17: IS ~6 mesi / OOS ~9 mesi)

Cella promossa (buffer 250 · TF gestione H2), `MaxMin_Oro_r17/*_r17.csv` Pass 10:

| | profit | PF | DD% | "Trades" | posizioni vere (÷~2,5) | freq |
|---|---:|---:|---:|---:|---:|---:|
| **IS** | 258,40 | 1,334 | 3,07 | 55 | ~22 | 0,120/g |
| **OOS** | **1.023,31** | **1,908** | **5,32** | 82 | ~33 | **0,121/g** |

E l'intera matrice OOS (20 celle) è **positiva 20/20**, PF 1,46–2,27, DD max
6,95% — `REFERTO_ROUND17_ORO_NOTTE.md` r.5.

🟡 Anche qui: **~33 posizioni OOS**, sotto i 150. Merito sospeso, rischio
leggibile.

## 4c. `end=4` — gli altri tre indici europei (26/07/26, real-tick)
`REGISTRO_TEST.md` r.456-459 + `risultati_archivio/MaxMinNotte/*.csv`:
FTSE `100GBP` PF max **0,672** · CAC `F40EUR` PF max **0,999** · Stoxx
`E50EUR` PF max **0,840** su 72 celle ciascuno. **Morti.**
⚠️ **Ma morti a `end=4` soltanto** — e quindi, per il certificato di morte del
09/09 (punto 3: *la gestione dell'uscita messa ad asse*; qui aggiungo: *la
finestra del box*), sono **"non ancora misurati"** sulla finestra di Claudio.

---

# 🚨 5. IL RITROVAMENTO PIÙ GROSSO DELLA GIORNATA — e non c'entra con `end=6`

Scavando ho incrociato il preset della sedia viva dell'ORO con il round che
l'ha prodotta. **Non coincidono.**

| | `InpBoxStartHour` | `InpBoxEndHour` | `InpEntryCutoffHour` |
|---|---:|---:|---:|
| **R17**, la cella MISURATA e promossa (`prove/R17_oro_notte.txt` r.~41) | **22** | **6** | **9**:30 |
| **R19** per-trade, stessa cella | 22 | 6 | 9:30 |
| tutte le 112 righe CSV dell'oro | 22 | 6 | 9 |
| 🔴 **`mql5/Presets/sedie_piccolo/sedia_MAXMIN_ORO_770402.set`** (r.2 · r.4 · r.10) | **23** | **4** | **8**:30 |
| 🔴 `prove/R103_ABTG_MaxMinNotte_XAUUSD_770402.txt` (r.113-115) | **23** | **4** | **8** |

> ## 🔴 **LA SEDIA ORO VIVA (magic 770402) GIRA SU UNA FINESTRA CHE NON È MAI STATA MISURATA.**
> Il numero che le abbiamo dato in dote — IS +258 / **OOS +1.023, PF 1,91, DD
> 5,3%** — viene da un box **22:00–06:59** con taglio alle **9:30**.
> In campo gira un box **23:00–04:59** con taglio alle **8:30**.
> E per il §3a, **su ~57% delle notti quei due box danno livelli diversi.**

⚠️ E c'è un secondo strato: **R100** ha misurato il DD a 22 anni (**19,72% al
1%**, `R100_REFERTO.md` r.15 → **REVISIONE** scattata) sulla finestra **22→6**,
mentre **R103** ha misurato PF 1,31 / DD 10,64% / n=693 dal 2020
(`R103_REFERTO_FINALE.md` r.16) sulla finestra **23→4**.
👉 **Due referti che pesano sulla stessa sedia, su due finestre diverse, senza
che nessuno dei due lo dichiari.** Nemmeno questi due sono confrontabili fra
loro (cambiano start, end, cutoff **e** il periodo: 2004 contro 2020).

**Questa non è una proposta di cambio parametro** — è una **discrepanza fra il
contratto e il campo**, e per il criterio di uscita del 18/08 (corsia RISCHIO,
vale a qualunque n) merita gli occhi di Claudio prima di qualunque round nuovo.

---

# 🧾 6. IL TERZO RITROVAMENTO: il DAX vivo, invece, è ALLINEATO ✅
`sedie_piccolo/recupero2/sedia_..._DAX_Short_Ottimizzato_770411.set` r.2-4:
`23 / 4:59`, cutoff `8:30`, buffer 1000, corr S&P ON — **identico** alla cella
misurata in FASE 0 / R2 / R81. 🟢 **Una buona notizia, e va detta: qui contratto
e campo coincidono al parametro.**

---

# 🎯 7. VERDETTO, spietato come richiesto

| domanda | risposta |
|---|---|
| `end=6` è meglio di `end=4`? | ⛔ **NON MISURATO. Nessuna coppia comparabile in 526 righe.** |
| è dentro il rumore? | ⛔ Non lo so, e **chi dicesse di saperlo starebbe inventando**. |
| è un asse vergine? | 🟢 **SÌ, mai messo ad asse in nessun file prova del repo.** |
| la manopola morde? | 🟢 **SÌ: cambia il livello su 212 notti su 371 = 57,1%.** |
| le due ore aggiunte contengono informazione? | 🔴 **NO secondo l'archivio**: 62,8% misurato contro 70,5% previsti dal caso puro. |
| il default (`4`) va bene? | 🟡 **Sul DAX è coerente col misurato. Sull'ORO il default vivo NON è il misurato** (§5). |

## ⚠️ E IL LIMITE DI METODO, dichiarato prima di qualunque round
> **Con due soli valori (4 e 6) non esiste un ALTOPIANO.** Anche se domani una
> corsa desse `6` vincente, il massimo che si potrebbe scrivere è
> ***"questo è meglio di quello"***, **mai** *"questa è la cella giusta"*.
> La regola di casa — centro dell'altopiano, mai il picco — con n=2 valori
> **non è applicabile**. Serve un asse da 4-5 valori o non si seleziona niente.

🔴 **E il limite del 19/08 vale anche qui**: allargare è legittimo su
`MaxMinNotte DAX` (PF OOS 2,19 > 1,10 — **non** è un motore senza edge) e su
`MaxMinNotte ORO` (PF OOS 1,91). ❌ **NON** è legittimo su FTSE/CAC/Stoxx
partendo dai loro parametri d'ingresso: lì si cambia **la finestra** (che è un
meccanismo), non si infittisce la griglia dei buffer.

---

# 💰 8. COSA SERVIREBBE PER PROMUOVERE `end=6`, e quanto costa

🚫 **Non propongo di toccare nessun preset vivo.** Le decisioni sui parametri in
campo sono di Claudio. Qui c'è solo il preventivo.

## 8a. L'asse minimo che risponde davvero

| voce | valore |
|---|---|
| **asse** | `InpBoxEndHour = 2 / 3 / 4 / 5 / 6` (**5 valori**, il vivo `4` al centro) |
| **`InpBoxEndMin`** | fisso a `59` — così la fine è sempre "l'ora piena successiva" |
| ⚠️ **tetto tecnico** | `end` deve restare **prima** di `InpPlaceHour`. DAX piazza a **07:59** → 7 è il massimo assoluto; oro piazza a **07:00** → **6 è già il tetto**. `end=7` sull'oro **non è lanciabile**: il box finirebbe dopo il piazzamento. **Dichiarato, non scoperto dopo.** |
| **una variabile per file prova** | ✅ un solo asse, `controlla_prova.py` passa |
| **simboli** | `D30EUR` M15 (sedia viva, PF OOS 2,19) e `XAUUSD` M5 (sedia viva, PF OOS 1,91) |
| **finestre** | le stesse già usate (IS/OOS di FASE 0 per il DAX, di R17 per l'oro): **NON si cambia la finestra nello stesso round in cui si cambia la manopola** |

## 8b. Il costo, contato

| round | celle | passate (× 2 finestre × 2 magic gemelli) | stima tempo |
|---|---:|---:|---:|
| **A · DAX** `end` 2-6 | 5 | **20** | **~50 min – 2h 30** |
| **B · ORO** `end` 2-6 | 5 | **20** | *[NON MISURATO]* (l'M5 oro è più lento del M15 DAX) |
| **C · controllo buffer** (§3c — obbligatorio per non confondere le cause) | 5 | 20 | come A |

**Base della stima**: `lancia_r81.ps1` r.28-29 dichiara *"24 passate a tick
reali su D30EUR 2024.09.26→2026.06.30, STIMA (non misura): 1-3 ore"* →
**2,5–7,5 min/passata**. ⚠️ È una **stima dichiarata dall'autore dello script**,
non una misura cronometrata: la riporto come tale.

💡 **Due round da 20 passate fatti bene, non uno da 60.** A e C prima (stesso
simbolo, stesso banco); B dopo, solo se A dice qualcosa.

## 8c. I cancelli, congelati PRIMA dei numeri
1. **G1 determinismo**: i due magic gemelli devono dare esiti **identici al
   centesimo**. Se no, il round non si legge.
2. **Riproduzione**: la cella `end=4` deve rifare **+618,31 OOS** sul DAX (il
   valore già in archivio). Se non lo fa, il banco è cambiato → **stop**.
3. **Selezione**: si guarda il **centro dell'altopiano**. Se `6` sporge e `5`
   **no**, il verdetto è **"non c'è una configurazione robusta"**, e si scrive
   così. Nessuna eccezione.
4. **Merito sospeso**: con ~20 op/cella sul DAX, **qualunque** PF che esca è
   sotto i 150 dell'Emendamento A. Il round può dire *"la manopola muove/non
   muove"* e *"il rischio è X"*. **Non può promuovere niente da solo.**
5. **Contro-esempio del §3c**: senza il round C (buffer), un "`6` vince" resta
   **non attribuibile**. Va scritto nel file prova prima di partire.

---

# 📌 9. I BUCHI, elencati per nome (mai "tutto il resto")

| buco | stato |
|---|---|
| spostamento in **dollari/punti** del livello quando l'estremo cade in 05/06 | **[NON MISURATO]** — il file delle 371 notti ha l'ora, non il prezzo |
| finestra temporale e TF dei 4 grid `valid_MaxMin_*` del 26/07 | **[NON MISURATO]** — nessun `.ini` né referto con le date in archivio |
| TF della corsa FASE 0 su `EURUSD` | **[NON MISURATO]** |
| studio delle 371 notti su **D30EUR** (esiste solo per XAUUSD) | **[NON MISURATO]** — sarebbe l'analogo del §3a per la sedia DAX, e costa **zero tick**: è uno script sulle barre |
| `end=6` su **qualunque** simbolo che non sia l'oro | **[NON MISURATO]** |
| `end` diverso da 4 e 6 (2, 3, 5, 7) su **qualsiasi** simbolo | **[NON MISURATO]** |
| perché la sedia oro viva usa 23→4 quando il misurato è 22→6 | **[NON MISURATO]** — nessun verbale trovato che spieghi il cambio |

---

# 🔥 10. LA RIGA DA PORTARSI VIA

> ## Non abbiamo perso un confronto: **abbiamo scoperto che il confronto non era mai stato fatto.**
> `InpBoxEndHour` è una manopola **mai messa ad asse in tutto il repo**, che
> **cambia il livello su 6 notti su 10** — su due sedie che un edge misurato ce
> l'hanno (DAX PF OOS 2,19 · ORO PF OOS 1,91). 🟢 **Questo è giacimento, non
> rumore.**
> 🔴 E nello scavo è saltato fuori che **la sedia oro in campo gira su una
> finestra che nessun backtest ha mai visto.** Quella è roba da leggere oggi,
> non fra un mese.
> 🧊 Ma il contro-esempio resta lì a raffreddare l'entusiasmo: **l'archivio non
> dice che le due ore dell'Europa contengano informazione.** Se `6` vincerà,
> dovrà vincere in un round costruito per non farsi confondere col buffer.

---

*Dossier prodotto senza eseguire alcun backtest, senza toccare preset, EA o
forward, senza commit. Script di verifica riproducibili nella scratchpad di
sessione (`pair.py`, `pair2.py`, simulazione arcoseno).*
