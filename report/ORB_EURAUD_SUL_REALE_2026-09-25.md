# 🔎 L'ORB SU EURAUD SUL REALE `10105439` — i fatti per decidere (25/09/2026)

**Perimetro: SOLA LETTURA.** Nessun file, terminale o EA toccato. Il conto reale
`10105439` (`C:\BCM_Reale`) e' di Claudio: qui ci sono solo i fatti, con la fonte
accanto a ogni numero. In fondo le tre opzioni, **senza raccomandazione** e **senza
istruzioni operative** (se servono, le scrive il coordinatore passando dai cancelli e
con la regola dei terminali multipli).

Etichette: **[MISURATO]** = letto in un file del repo · **[INFERITO]** = dedotto da
numeri misurati, con il conto scritto · **[NON MISURATO]** = il dato non c'e'.

---

## 🧭 IN CINQUE RIGHE
1. 🔴 **Il livello "11,6" NON e' un difetto di stampa: e' il prezzo vero dell'ordine.**
   Il preset e' quello del **Dow** (`InpEntryPoints=10`, `InpK=1.0` → +10,0 **in prezzo**
   oltre il massimo del range). Su EURAUD (~1,62) il BUY STOP finisce a ~11,62: **~10 unita'
   sopra il mercato, irraggiungibile.** [MISURATO: sorgente + preset + aritmetica che torna al 5° decimale]
2. 🟢 **Riempimenti sul reale: ZERO.** Soldi guadagnati o persi da questa sedia: **0 EUR**. [MISURATO]
3. 🟠 **Sono DUE istanze diverse, non una sola spostata**: dal 12/09 al 24/09 sul reale
   giravano **insieme** l'ORB U30USD M5 e l'ORB EURAUD H1, **con lo stesso magic 770611**. [MISURATO]
4. 🟠 **Il rischio dichiarato non torna coi lotti**: il `.chr` dice `1.0`, i lotti stampati
   dal 14/09 al 23/09 implicano **~0,66%**. [INFERITO]
5. 🔴 **Il pericolo non e' oggi: e' la "correzione"**. Con `InpK` da forex (0,0001) gli ordini
   diventerebbero raggiungibili, con stop di **2,7-12,5 pip** e lotti fino a **~4,5**. Su
   EURAUD l'ORB **non e' mai stato testato in casa**. [MISURATO / INFERITO, vedi §3-§5]

---

## 1️⃣ DA QUANDO E' LI', E CHE ISTANZA E'

| fatto | fonte | etichetta |
|---|---|---|
| **Prima riga in assoluto** dell'ORB EURAUD sul reale: `avviato su EURAUD. Range server 14:30-14:45` alle **00:21:12 locali del 12/09** (log `20260912.log`) | `CODA_02_chi_ha_operato_20260912_033002.log` r.88 | [MISURATO] |
| Nei log del **10/09 e 11/09** l'ORB EURAUD **non c'e'** (la sonda mostra come "ultima riga" quella del file piu' vecchio letto: il Guardian del 12/09 mostra `23:55 eq=7507.65`, che solo il log del 10/09 puo' contenere → la regola e' verificata) | stesso file, sezione `E23E1504...` | [MISURATO] |
| **Tutti i `.chr` del reale** risultano riscritti alle **00:21 del 12/09**, lo stesso minuto dell'avvio | `CODA_08_preset_dai_chr_20260924_033003.log` r.4231, 4320, 4381, 4400 | [MISURATO] |
| Il grafico EURAUD **non ha avuto un `.chr` su disco fino al 24/09 22:53** (compare come `chart05.chr` solo nella foto del 25/09) | `CODA_01_sedie_attaccate_20260925_033004.log` r.105-110; CODA_01 dal 12/09 al 24/09: 4 sedie, nessun EURAUD | [MISURATO] |
| Spiegazione: MT5 scrive il `.chr` di un grafico nuovo solo quando salva il profilo, quindi un grafico aperto dopo il salvataggio **resta invisibile alle sonde dei `.chr`** finche' il profilo non viene salvato di nuovo | — | [INFERITO] |
| **L'istanza U30USD M5 (chart02, `0.65`) ha continuato a girare in parallelo**: `BUY STOP @ 52340.50 ... lot 0.20` il **22/09**, "nuovo giorno" ancora alle **01:00 del 24/09** | `CODA_09_giornale_operativo_20260923_033004.log` (giorno 20260922); `CODA_02_..._20260925_033004.log` sezione reale | [MISURATO] |
| Foto del 24/09 03:30: reale con **DAX 770101 + ORB U30USD 770611 + SlippageLogger + Guardian**. Foto del 25/09 03:30: **SlippageLogger + Guardian + ORB EURAUD** (chart01 e chart02 spariti) | `CODA_01_..._20260924_033003.log` r.108-112; `CODA_01_..._20260925_033004.log` r.105-110 | [MISURATO] |

👉 **Risposta: e' una istanza NUOVA, non quella del Dow spostata di simbolo.** E' attaccata
dal **12/09 00:21 locali** (= 11/09 23:21 server), e per **12 giorni ha convissuto** con
l'ORB del Dow sullo **stesso conto e con lo stesso magic 770611**. Il 24/09 (fra le 15:17
locali, ultima riga del DAX, e le 22:53, salvataggio dei `.chr`) sono stati tolti DAX e ORB
Dow — la sospensione per l'hedging con FTMO — ed e' rimasta **solo l'istanza EURAUD**.

✏️ **Una precisazione al resoconto del 16/09** (`RESOCONTO_2026-09-16.md` r.93-97): *"il
censimento dei `.chr` del 15/09 aveva gia' trovato `ABTG_ORB_Ottimizzato` attaccato al
reale"*. **Vero, ma quella era l'altra istanza**: la foto del 15/09 mostra
`ABTG_ORB_Ottimizzato U30USD M5 magic 770611 rischio 0.65 [Default\chart02.chr]`
(`CODA_01_..._20260915_033005.log` r.99). **L'istanza EURAUD in quella foto non poteva
esserci** (nessun `.chr` fino al 24/09). [MISURATO]

🟢 **Lo stesso magic su due simboli non ha fatto danni per costruzione**: nel sorgente a HEAD
(v1.04) `CancelPendings()` filtra per simbolo **e** magic (r.1037-1038) e `SelPos()` sceglie
il ticket per simbolo+magic (r.1119-1123). [MISURATO sul sorgente; che il binario in campo
sia la v1.04 e' **[NON MISURATO]**]

🟠 **Chi l'ha attaccato e perche'**: **[NON MISURATO]**. Nessun referto del repo lo registra.

---

## 2️⃣ QUANTI ORDINI, QUANTI RIEMPIMENTI, QUANTI SOLDI

### Ordini piazzati (tutti BUY STOP, tutti alle 15:45 locali = 14:45 server)
| giorno | prezzo | SL | TP | lotti | fonte |
|---|---:|---:|---:|---:|---|
| 14/09 | 11.62233 | 11.62185 | 11.62377 | **1,69** | `CODA_09_..._20260915_033005.log` r.111 |
| 15/09 | 11.61982 | 11.61955 | 11.62063 | **3,00** | `CODA_09_..._20260916_033005.log` r.113 |
| 16/09 | 11.61883 | 11.61840 | 11.62010 | **1,88** | `CODA_09_..._20260917_033003.log` r.110 |
| 23/09 | 11.61729 | 11.61604 | 11.62103 | **0,65** | `CODA_09_..._20260924_033003.log` r.163 |

- **4 ordini** [MISURATO] nei giorni coperti da `CODA_09` (14-18/09, 22-24/09). Nessuno il
  17, 18, 22 e 24/09 [MISURATO]. Il **21/09 non e' coperto** da nessuna foto del giornale:
  **[NON MISURATO]**.
- Il **pendente del 16/09 e' quello cancellato a mano prima della FOMC**
  (`RESOCONTO_2026-09-16.md` r.91-95): la prova che il server **accetta** questi ordini a
  11,6. [MISURATO da Claudio]

### Riempimenti ed esiti
- 🟢 **ZERO.** Lo `SlippageLogger` del reale (avviato **04/09 21:54 server**, ultima scrittura
  **25/09 02:30 server**) registra **17 deal, tutti `D30EUR` magic 770101**, **zero** con
  magic 770611 (`CODA_10_slippage_20260925_033004.log` r.13-60). [MISURATO]
- 🟢 **Esito in denaro: 0 EUR.** Nessun `TradeExporter` del reale in `data/statements/`
  (ci sono solo `ReportHistory50503392.xlsx`, `trades_100k.csv`, `trades_auto.csv`): la
  fonte del P/L e' solo il logger dei deal, e dice zero. [MISURATO]
- 🟢 **E non poteva riempirsi**: EURAUD avrebbe dovuto salire da ~1,62 a ~11,62 (§3). [INFERITO, per costruzione]

---

## 3️⃣ I PREZZI "11,6": DIFETTO DI STAMPA O LIVELLI SBAGLIATI?

### 🔴 LIVELLI SBAGLIATI. La stampa e' fedele.
Il sorgente `mql5/Experts/ABTG_ORB_Ottimizzato.mq5` (v1.04):
- r.457: `Log(StringFormat("BUY STOP @ %.5f SL %.5f TP %.5f lot %.2f",buyPx,sl,tp,lot))` —
  **stampa la stessa variabile `buyPx` passata a `gTrade.BuyStop(...)`** alla r.456. `%.5f`
  non puo' aggiungere una cifra davanti.
- r.614: `double d=InpEntryPoints*InpK;  // distanza in PREZZO` → **10,0 × 1,0 = 10,0**.
- r.140: il commento dell'input dice gia' la regola: *"indici/oro=1.0; ... **forex=0.0001**"*.
- Preset del reale: `InpEntryPoints=10.0`, `InpK=1.0`, `InpSLMode=3` (HALFRANGE), `InpTPMode=1`
  (RANGE), `InpTPRangeMult=1.5` (`CODA_08_..._20260925_033004.log` r.3877-3887).

### 🧪 Il contro-esempio: se fosse un difetto di stampa, l'aritmetica NON tornerebbe
Con HALFRANGE lo stop sta a **mezzo range** sotto l'ingresso (r.629) e con TP_RANGE il
target sta a **1,5 range** sopra (r.451). Quindi dal log si ricava il range e si **predice**
il TP:

| giorno | entry−SL = ½ range | range | TP predetto = entry + 1,5×range | TP stampato |
|---|---:|---:|---:|---:|
| 14/09 | 0,00048 | 0,00096 | 11.62377 | **11.62377** ✅ |
| 15/09 | 0,00027 | 0,00054 | 11.62063 | **11.62063** ✅ |
| 16/09 | 0,00043 | 0,00086 | 11.62012 | 11.62010 (arrotondamento del ½ range) ✅ |
| 23/09 | 0,00125 | 0,00250 | 11.62104 | 11.62103 ✅ |

E togliendo il 10,0 il massimo del range cade dove stava davvero il cambio: **1,62233 /
1,61982 / 1,61883 / 1,61729**, contro i livelli EURAUD dello stesso periodo stampati da
`ABTG_PunteLarry` sul piccolo (`1.61692` il 15/09, `1.60800-1.61540` il 23/09:
`CODA_09_..._20260916_033005.log` r.35, `..._20260924_033003.log` r.52). [MISURATO]

👉 **I livelli sono calcolati "giusti" per un indice e sbagliati di 10,0 per un cambio.** Lo
**stop** invece e' il ½ range vero (2,7-12,5 pip) e **non dipende da `InpK`**: se qualcuno
mettesse `InpK=0.0001`, l'ingresso scenderebbe a 10 pip oltre il range e **lo stop
resterebbe esattamente quello della tabella**. [MISURATO sul sorgente, r.627-629]

### 💶 Rischio in euro per operazione
Valore del pip: 1 lotto EURAUD = 10 AUD/pip; AUD/EUR = **0,61372** (tabella cambi di
`report/MISURA_SPREAD_FOREX_2026-09-12.md` r.210) → **6,137 EUR/pip/lotto**. [MISURATO il
cambio, INFERITO il pip value al giorno dell'ordine]

| giorno | stop (pip) | lotti | rischio calcolato | % dell'equity (Guardian) |
|---|---:|---:|---:|---:|
| 14/09 | 4,8 | 1,69 | **49,8 EUR** | 0,66% di 7.511,13 |
| 15/09 | 2,7 | 3,00 | **49,7 EUR** | 0,66% di 7.511,13 |
| 16/09 | 4,3 | 1,88 | **49,6 EUR** | 0,66% di 7.515,82 |
| 23/09 | 12,5 | 0,65 | **49,9 EUR** | 0,66% di 7.550,74 |

Equity dal Guardian del reale: `CODA_02_..._20260916/17_*.log` e `CODA_09_..._20260924_033003.log`.
- 🟠 **I lotti implicano ~0,66%, non l'1,0% del `.chr`.** Con `1.0` e ~7.550 EUR il rischio
  sarebbe **75,5 EUR** e i lotti ~1,5 volte piu' grandi (il 23/09: **0,98** invece di 0,65).
  Il `.chr` e' datato **24/09 22:53**, dopo l'ultimo ordine. Quindi il rischio e' stato
  **portato a 1,0 dopo il 23/09** oppure il `.chr` non descrive l'istanza che ha piazzato quegli
  ordini. [INFERITO — quale delle due: NON MISURATO]
- 🟢 **Rischio REALIZZATO oggi: 0 EUR**, perche' l'ingresso e' irraggiungibile. [INFERITO]
- 🔴 **Rischio nello scenario "corretto" (`InpK=0.0001`), all'1,0% di 7.551 EUR = 75,5 EUR a
  operazione**: sugli stop osservati i lotti sarebbero **4,55 (2,7 pip) · 2,86 (4,3) · 2,56
  (4,8) · 0,98 (12,5)**. Con 4,55 lotti **ogni pip di slippage costa 27,9 EUR = 37% dell'R**.
  Il nozionale sarebbe **98.000-455.000 EUR** su un conto da 7.551. [INFERITO]
  - La **leva del reale** non e' in repo: **[NON MISURATO]**. Se fosse la leva al dettaglio UE
    sulle coppie non major (1:20), il margine di **1,69 lotti** sarebbe ~8.450 EUR, **piu'
    dell'equity**, e l'ordine verrebbe respinto all'attivazione. Ipotesi, non misura.
- 🟠 **Il Guardian del reale non conta i pendenti** nel rischio aperto (buco **B6**,
  dichiarato in `mql5/Experts/ABTG_Guardian.mq5` r.91 e r.430): alle 23:55 stampa sempre
  `rischioAperto=0.00%`. [MISURATO sul sorgente a HEAD]

---

## 4️⃣ E' MAI STATO TESTATO SU EURAUD? L'ORARIO HA SENSO?

- 🔴 **Mai testato in casa su EURAUD.** I file prova che citano `ABTG_ORB_Ottimizzato` usano
  solo **U30USD (29) · NASUSD (11) · D30EUR (8) · GBPUSD (6) · XAUUSD (3) · EURUSD (1) ·
  CHFJPY (1)** (`grep @SIMBOLO` su `backtest_pipeline/prove/*.txt`). Zero CSV EURAUD in
  `backtest_pipeline/risultati_prove/ABTG_ORB_Ottimizzato/` e in
  `backtest_pipeline/risultati_archivio/ORB/`. Zero righe ORB+EURAUD in `REGISTRO_TEST.md`.
  Le sole righe EURAUD delle prove sono di `ABTG_PunteLarry` (`R52_CENSIMENTO_LATI.md` r.47,
  `R103_GENERA_PROVE.py` r.348). [MISURATO]
- 🟠 **Il preset e' quello del Dow, parola per parola**: rispetto all'ORB U30USD del reale
  (`CODA_08_..._20260924_033003.log` r.4316-4376) cambia **solo** `InpRiskPercent`
  (0.65 → 1.0). Stessi `InpEntryPoints/InpK`, stesso range, stesso filtro EMA200, stesso
  `InpMaxRangePct=0.8`. [MISURATO, diff riga per riga]
- 🟠 **L'orario 14:30-14:45 server**: con BCM oggi a UTC+1 (`report/OROLOGIO_BCM_2026-09-24.md`)
  sono le **13:30-13:45 UTC = 15:30-15:45 italiane = 09:30-09:45 di New York**, cioe'
  **i primi 15 minuti del cash azionario USA**. E' il cuore del motore sugli indici; per
  EURAUD **non e' l'apertura di nessuna delle due valute**. Che quella finestra abbia un edge
  su EURAUD: **[NON MISURATO]** — nessuna prova, ne' a favore ne' contro.

🪦 **Certificato**: questa NON e' una bocciatura dell'ORB su EURAUD. Mancano PF, n, DD,
gestione, gemelli e TF: il verdetto e' **"NON ANCORA MISURATO"**.

---

## 5️⃣ LA FRONTIERA DEL COSTO `stop >= 40 x spread`

- **Spread EURAUD: [NON MISURATO].** E' una delle **quattro coppie cieche** del 12/09: la
  sola lettura esistente e' `0` alla sonda del 17/08, che vuol dire **nessun tick**, non
  spread nullo (`report/MISURA_SPREAD_FOREX_2026-09-12.md` r.107-110). Nessun file in
  `data/spread_vivo/` o `risultati_archivio/spread_flotta/` contiene EURAUD.
- **Quanto dovrebbe valere lo spread per passare**, sugli stop osservati:
  2,7 pip → **<= 0,07 pip** · 4,3 → **<= 0,11** · 4,8 → **<= 0,12** · 12,5 → **<= 0,31**. [INFERITO, aritmetica]
- **La commissione da sola li sfonda tutti**, *se* il reale paga come il demo: 4 EUR per
  lotto giro completo = **0,6518 pip** su EURAUD (`MISURA_SPREAD_FOREX_2026-09-12.md` r.276,
  legge a r.157). A 40x fanno **26,1 pip**, piu' del doppio dello stop piu' largo osservato
  (12,5). 🟠 Ma la commissione sul **forex del reale** e' **[NON MISURATA]**: i 17 deal del reale
  sono tutti DAX, con commissione `0.00` (`CODA_10` sezione reale).
- 👉 Verdetto onesto: **non calcolabile per lo spread**; **sfondata** se il reale ha la
  commissione del demo. Sugli indici la frontiera l'ORB la rispetta; questi stop da 2,7-12,5
  pip nascono dal range di 15 minuti di un cambio, e sono **stretti per costruzione**. [INFERITO]

---

## 6️⃣ RISCHIO HEDGING CON FTMO

- 🟢 **EURAUD NON e' fra i simboli FTMO attivi.** Terminale `541452707` (`C:\FTMO`), profilo
  `Default`, 9 sedie: **GER40.cash, US30.cash, US100.cash** (le sedie che operano), piu'
  Guardian su **NZDJPY**, TradeExporter su **NZDUSD**, SpreadLogger su **US500.cash**
  (`CODA_01_sedie_attaccate_20260925_033004.log` r.57-68). [MISURATO]
- 🟢 Quindi l'ORB EURAUD **non puo' fare hedging incrociato** con nessuna sedia FTMO di oggi.
  Le due istanze che lo potevano fare (**DAX 770101** su D30EUR e **ORB 770611** su U30USD,
  gemelle di GER40/US30 di FTMO) **non sono piu' nella foto del 25/09**. [MISURATO]
- 🟠 **Vale finche' FTMO non mette una sedia su EURAUD**: oggi nessuna lo fa. [MISURATO oggi]

---

## ⚖️ LE TRE OPZIONI DI CLAUDIO (cosa comporta ciascuna — nessuna raccomandazione)

### A. Lasciarlo com'e'
- Continua a piazzare **BUY STOP a ~11,6** nei giorni in cui passano i filtri (4 su 8 giorni
  misurati): **non si riempiono**, rischio realizzato **0 EUR**, P/L **0 EUR**.
- Resta un EA **che occupa il reale senza misurare niente**: non produce ne' dati di merito
  ne' di slippage (non entra mai).
- Nei giorni in cui entra lascia un **pendente vivo** sul reale dalle 15:45 alle 22:00 locali
  (`InpEndHour=21` server; il 16/09 uno e' stato cancellato a mano prima della FOMC): innocuo
  finche' il preset resta questo.
- 🔴 Resta **la trappola della "correzione"**: chiunque in futuro "sistemi" `InpK` lo rende
  operativo **su un motore mai testato su EURAUD**, all'**1,0%**, con lotti fino a ~4,5.
- Resta aperta la domanda **0,66% contro 1,0%** (§3).

### B. Spostarlo (altro simbolo o altro conto)
- 🟠 **Tornare sul Dow sul reale** riapre il **rischio hedging** con `US30.cash` di FTMO,
  che e' il motivo per cui il 24/09 l'ORB Dow e' stato tolto dal reale (§6).
- 🟠 **Tenerlo su un cambio con `InpK` da forex** vuol dire far girare con soldi veri un motore
  **mai misurato in casa su quel simbolo**, con stop di 2,7-12,5 pip e una frontiera del costo
  **non calcolabile** (spread [NON MISURATO]). Il certificato di morte del 09/09 vale anche al
  contrario: **"non misurato" non e' "buono"**.
- 🟢 Un **conto demo** non ha nessuno di questi due problemi: misura senza rischio e senza hedging.
- Qualunque spostamento e' un'**azione a mano dentro MT5**: la scrive il coordinatore con la
  regola dei terminali multipli (numero di conto + cartella + stringa PID/titolo/cartella).

### C. Staccarlo
- Il reale resta con **SlippageLogger + Guardian**, cioe' **zero EA che fanno trading**
  (oggi l'ORB EURAUD e' **l'unico**: `report/NOTTE_2026-09-25.md` r.12).
- Si perde **niente in merito** (non ha mai eseguito) e si toglie il pendente quotidiano.
- Il reale smette di produrre deal: lo `SlippageLogger` resta acceso ma **non avra' niente da
  misurare** finche' non si attacca una sedia nuova.
- 🟠 Resta da capire **chi e quando** l'ha attaccato il 12/09 e **quando** e' diventato 1,0:
  staccarlo chiude il rischio, non la domanda.

---

## 🧾 COSA NON SI SA (e dove si troverebbe)
| buco | dove sta la risposta |
|---|---|
| chi ha attaccato l'istanza il 12/09 e perche' | Claudio |
| rischio 0,65 → 1,0: quando | scheda Esperti del 24/09 sul reale (una riga `avviato su EURAUD` dopo le 15:45 del 23/09 lo direbbe) |
| ordini del 21/09 | giornale `20260921.log` del reale (nessuna foto `CODA_09` lo copre) |
| spread EURAUD | `ABTG_SpreadLogger` su EURAUD (strada B del 12/09) |
| commissione forex e leva del reale | specifiche del simbolo sul terminale `10105439` |
| versione del binario ORB in campo | intestazione `avviato` nel log / confronto `.ex5` |

*Verifiche fatte prima di consegnare: diff dei due preset riga per riga; TP predetto dal log
contro TP stampato (4 su 4); regola "ultima riga = file piu' vecchio" della sonda CODA_02
provata sul Guardian; rischio implicito ricalcolato su 4 ordini indipendenti (49,6-49,9 EUR).*
