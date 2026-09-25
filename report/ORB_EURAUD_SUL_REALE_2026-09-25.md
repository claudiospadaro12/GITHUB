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
   sopra il mercato, irraggiungibile.** [MISURATO: sorgente r.456-457 e r.614 + preset]
2. 🟢 **Riempimenti sul reale: ZERO.** Soldi guadagnati o persi da questa sedia: **0 EUR**. [MISURATO]
3. 🟠 **Sono DUE istanze diverse, non una sola spostata**: dal 12/09 al 24/09 sul reale
   giravano **insieme** l'ORB U30USD M5 e l'ORB EURAUD H1, **con lo stesso magic 770611**. [MISURATO]
4. 🟢 **Il rischio dichiarato torna coi lotti, 4 su 4**: il `.chr` dice `1.0`, e l'EA
   dimensiona su `ACCOUNT_BALANCE` (r.1070). Il reale ha **bilancio ~5.000 + credito 2.500**:
   l'1,0% del **bilancio** (~50 EUR) ripredice esattamente 1,69 · 3,00 · 1,88 · 0,65 lotti.
   Rispetto all'**equita'** (~7.550) sono ~0,67%. [INFERITO, conto rifatto con la formula del sorgente]
5. 🔴 **Il pericolo non e' oggi: e' la "correzione"**. Con `InpK` da forex (0,0001) gli ordini
   diventerebbero raggiungibili, con stop di **2,7-12,5 pip** e lotti fino a **3,00** (gia'
   stampati: ~50 EUR = 1,0% del bilancio a operazione). Su
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
| **L'istanza U30USD M5 (chart02, `0.65`) ha continuato a girare in parallelo**: `BUY STOP @ 52340.50 ... lot 0.20` il **22/09**; rimossa dal grafico il **24/09 alle 22:49:21 locali** (`ABTG_ORB_Ottimizzato (U30USD,M5) removed`). NB: la riga `01:00:00.162 nuovo giorno` della foto `CODA_02` del 25/09 e' del **23/09**, non del 24/09 (la sonda mostra la riga del file piu' vecchio: il Guardian `23:55:03.331` accanto e' la riga del 23/09) | `CODA_09_giornale_operativo_20260923_033004.log` (giorno 20260922); `report/SOSPENSIONE_SEDIE_HEDGING_2026-09-24.md` r.70 | [MISURATO] |
| Foto del 24/09 03:30: reale con **DAX 770101 + ORB U30USD 770611 + SlippageLogger + Guardian**. Foto del 25/09 03:30: **SlippageLogger + Guardian + ORB EURAUD** (chart01 e chart02 spariti) | `CODA_01_..._20260924_033003.log` r.110-114; `CODA_01_..._20260925_033004.log` r.105-110 | [MISURATO] |

👉 **Risposta: e' una istanza NUOVA, non quella del Dow spostata di simbolo.** E' attaccata
dal **12/09 00:21 locali** (= 11/09 23:21 server), e per **12 giorni ha convissuto** con
l'ORB del Dow sullo **stesso conto e con lo stesso magic 770611**. Il 24/09 sono stati tolti
DAX (**22:49:09** locali) e ORB Dow (**22:49:21**) — la sospensione per l'hedging con FTMO,
`report/SOSPENSIONE_SEDIE_HEDGING_2026-09-24.md` §ESEGUITO r.69-73 — e poi e' stato salvato il
profilo (punto 5 della stessa procedura, r.58): e' per questo che `chart05.chr` nasce alle
**22:53**. E' rimasta **solo l'istanza EURAUD**. [MISURATO]

🟠 **La verifica scritta in quel referto** (r.74: *"deve NON trovare ... 770611 ... su
REALE"*) **alla lettera non e' soddisfatta** dalla foto del 25/09: il 770611 c'e' ancora, su
EURAUD. Non e' un buco di hedging (§6): e' una verifica **per magic**, che non distingue le
due istanze. [MISURATO]

✏️ **Una precisazione al resoconto del 16/09** (`RESOCONTO_2026-09-16.md` r.93-97): *"il
censimento dei `.chr` del 15/09 aveva gia' trovato `ABTG_ORB_Ottimizzato` attaccato al
reale"*. **Vero, ma quella era l'altra istanza**: la foto del 15/09 mostra
`ABTG_ORB_Ottimizzato U30USD M5 magic 770611 rischio 0.65 [Default\chart02.chr]`
(`CODA_01_..._20260915_033005.log` r.99). **L'istanza EURAUD in quella foto non poteva
esserci** (nessun `.chr` fino al 24/09). [MISURATO]

🟢 **Lo stesso magic su due simboli non ha fatto danni per costruzione**: nel sorgente a HEAD
(v1.04) `CancelPendings()` filtra per simbolo **e** magic (r.1037-1038) e `SelPos()` sceglie
il ticket per simbolo+magic (r.1119-1123). [MISURATO sul sorgente] Il binario in campo e'
**probabilmente la v1.04**: la sonda del reale legge sorgente `1.04` con `.ex5` compilato il
**06/09 09:58** (`CODA_06_quale_codice_gira_20260925_033004.log` r.438). Che quell'`.ex5` sia
compilato proprio da quel sorgente: [INFERITO, non verificato per hash]

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

- **4 ordini** [MISURATO] nei **7 giorni coperti per intero** da `CODA_09` (14, 15, 16, 18,
  22, 23, 24/09). Nessuno il 18, 22 e 24/09 [MISURATO].
- **17/09: [NON MISURATO].** La foto di quel giorno stampa **40 righe su 199** (*"... altre
  159 righe non stampate (tetto)"*, `CODA_09_..._20260918_033004.log` sezione reale), tutte
  del DAX fino alle 14:43:58 locali; l'ORB piazza alle 15:45, fuori dalla parte stampata.
- **21/09: [NON MISURATO]**: nessuna foto del giornale lo copre.
- Il **pendente del 16/09 e' con ogni probabilita' quello cancellato a mano prima della FOMC**
  (`RESOCONTO_2026-09-16.md` r.91-95), e quindi la prova che il server **accetta** questi
  ordini a 11,6. [INFERITO: il resoconto registra la cancellazione, non il prezzo; l'unico
  pendente ORB EURAUD di quel giorno nel log e' quello a 11.61883]

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

👉 **A decidere e' il sorgente**: r.614 calcola la distanza, r.456 manda `buyPx` a
`BuyStop`, r.457 stampa **la stessa** `buyPx`. Stampa e ordine non possono divergere.

### 🧪 Coerenza interna (NON e' una prova contro il difetto di stampa)
Con HALFRANGE lo stop sta a **mezzo range** sotto l'ingresso (r.629) e con TP_RANGE il
target sta a **1,5 range** sopra (r.451). Dal log si ricava il range e si predice il TP.
🟠 **Questo controllo non discrimina**: un difetto di stampa che spostasse i tre prezzi della
**stessa costante** lascerebbe le differenze identiche. Conferma solo che il preset letto e'
quello che ha generato gli ordini (HALFRANGE, TP_RANGE 1,5).

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
La formula del sorgente (`LotByRisk`, r.1067-1097): `rischio = ACCOUNT_BALANCE x InpRiskPercent/100`,
`perdita per lotto = OrderCalcProfit(stop)`, `lotti = floor(rischio/perdita, 0,01)`.
- **Bilancio contro equita'**: sul reale il broker tiene **2.500 EUR di credito** non
  prelevabile, bilancio ~5.000 (`report/CENSIMENTO_RISCHIO_VERO_2026-09-10.md` r.312-313;
  `report/GUARDIAN_BASELINE_GIORNALIERA_2026-09-08.md` r.37-39). Il Guardian stampa l'**equita'**;
  il bilancio qui sotto e' **equita' − 2.500** (nessuna posizione aperta alle 23:55). [INFERITO]
- **Pip del giorno**: 10 AUD / EURAUD del giorno (massimo del range, §3) = **6,164 · 6,174 ·
  6,177 · 6,183 EUR/pip/lotto**. [INFERITO]

| giorno | stop (pip) | lotti stampati | lotti predetti all'1,0% del bilancio | rischio | bilancio | % bilancio | % equita' |
|---|---:|---:|---:|---:|---:|---:|---:|
| 14/09 | 4,8 | 1,69 | **1,69** ✅ | 50,00 EUR | 5.011,13 | 1,00% | 0,67% |
| 15/09 | 2,7 | 3,00 | **3,00** ✅ | 50,01 EUR | 5.015,82 | 1,00% | 0,67% |
| 16/09 | 4,3 | 1,88 | **1,88** ✅ | 49,94 EUR | 5.015,82 | 1,00% | 0,66% |
| 23/09 | 12,5 | 0,65 | **0,65** ✅ | 50,24 EUR | 5.050,74 | 0,99% | 0,67% |

Bilancio al momento dell'ordine (14:45 server) = equita' del Guardian alle 23:55 della sera
prima − 2.500, **piu' i deal DAX chiusi prima delle 14:45 server dello stesso giorno**: solo il
15/09 ne ha, +2,90 e +1,79 EUR alle 12:00 e 12:05 server (`CODA_10_slippage_20260925_033004.log`,
sezione reale) → 7.511,13 + 4,69 = 7.515,82, che e' proprio l'equita' della sera del 15/09.
Equita' serali: `CODA_09_..._20260915_033005.log`, `..._20260916_033005.log`,
`..._20260923_033004.log` (sezioni reale, righe `GUARDIAN`).

🧪 **Il contro-esempio, fatto**: le ipotesi alternative **sbagliano**. 1,0% dell'**equita'**
→ 2,53 · 4,50 · 2,82 · 0,97 lotti; 0,65% del **bilancio** → 1,10 · 1,95 · 1,22 · 0,42; 0,65%
dell'equita' → 1,65 · 2,93 · 1,83 · 0,63; pip fisso 6,137 (cambio del 17/08) → 1,70 · 3,02 ·
1,90. **Solo "1,0% del bilancio, pip del giorno" fa 4 su 4.** 👉 Il `1.0` del `.chr` descrive
l'istanza **da sempre**. [INFERITO, calcolo rifatto ordine per ordine]

- 🟢 **Rischio REALIZZATO oggi: 0 EUR**, perche' l'ingresso e' irraggiungibile. [INFERITO]
- 🔴 **Scenario "corretto" (`InpK=0.0001`)**: lo stop **non cambia** (r.627-629), quindi i lotti
  restano quelli stampati, **0,65-3,00 a ~50 EUR** (1,0% del bilancio, ~0,67% dell'equita').
  Con 3,00 lotti **ogni pip di slippage costa ~18,5 EUR = 37% dell'R**. Il nozionale sarebbe
  **65.000-300.000 EUR** su un'equita' di 7.551. [INFERITO]
  - La **leva del reale** non e' in repo: **[NON MISURATO]**. Se fosse 1:20 (leva al dettaglio
    UE sulle coppie non major), il margine di **1,69 lotti** sarebbe ~8.450 EUR, **piu'
    dell'equita'**, e l'ordine verrebbe respinto all'attivazione. Ipotesi, non misura.
- 🟠 **Il Guardian del reale non conta i pendenti** nel rischio aperto (buco **B6**,
  dichiarato in `mql5/Experts/ABTG_Guardian.mq5` r.91 e r.430). Sul reale gira la **v1.12**
  (`CODA_06_quale_codice_gira_20260925_033004.log` r.437), e anche li' `OpenRiskPct()` scorre
  solo `PositionsTotal()` (commit `1b6a095d`, r.171-177): **B6 vale anche nella versione in
  campo**. Quindi il cap C1 (3,25%) **non vede** il pendente ORB. [MISURATO sul sorgente]
  (La riga delle 23:55 con `rischioAperto=0.00%` non prova niente in un senso o nell'altro: a
  quell'ora il pendente e' gia' stato cancellato dall'`EndOfDay` delle 21:00 server.)

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
  commissione del demo. Questi stop da 2,7-12,5 pip nascono dal range di 15 minuti di un
  cambio, e sono **stretti per costruzione**. [INFERITO]
- 🔴 **E nemmeno sul Dow l'ORB passa la frontiera**: la cella viva (HALFRANGE su U30USD) fa
  **29,5x**, sotto il 40x (`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.434;
  `report/A4_LA_GEOMETRIA_DELLO_STOP_2026-09-12.md` r.141). [MISURATO]

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
- Continua a piazzare **BUY STOP a ~11,6** nei giorni in cui passano i filtri (4 su 7 giorni
  misurati): **non si riempiono**, rischio realizzato **0 EUR**, P/L **0 EUR**.
- Resta un EA **che occupa il reale senza misurare niente**: non produce ne' dati di merito
  ne' di slippage (non entra mai).
- Nei giorni in cui entra lascia un **pendente vivo** sul reale dalle 15:45 alle 22:00 locali
  (`InpEndHour=21` server; il 16/09 uno e' stato cancellato a mano prima della FOMC): innocuo
  finche' il preset resta questo.
- 🔴 Resta **la trappola della "correzione"**: basta cambiare `InpK`, `InpEntryPoints` o
  `InpSLMode` perche' l'ordine diventi raggiungibile, **su un motore mai testato su EURAUD**,
  all'1,0% del bilancio (~50 EUR), con lotti gia' stampati fino a **3,00**.
- 🟠 Il pendente, vivo **~6 ore al giorno**, **non e' visto dal cap C1** del Guardian (buco B6, §3).
- 🟠 Il magic **770611 e' condiviso** con l'istanza U30USD sospesa: se quella tornasse sul
  reale, ogni lettura per magic (sonde, verifiche, criterio di uscita) **non distinguerebbe le
  due**.

### B. Spostarlo (altro simbolo o altro conto)
- 🟠 **Tornare sul Dow sul reale** riapre il **rischio hedging** con `US30.cash` di FTMO,
  che e' il motivo per cui il 24/09 l'ORB Dow e' stato tolto dal reale (§6).
- 🟠 **Tenerlo su un cambio con `InpK` da forex** vuol dire far girare con soldi veri un motore
  **mai misurato in casa su quel simbolo**, con stop di 2,7-12,5 pip e una frontiera del costo
  **non calcolabile** (spread [NON MISURATO]). Il certificato di morte del 09/09 vale anche al
  contrario: **"non misurato" non e' "buono"**.
- 🟠 E la cella viva del Dow **e' sotto la frontiera del costo** (29,5x contro 40x, §5).
- 🟠 Un **conto demo** toglie il rischio e l'hedging, ma: con `InpK=1.0` **non misurerebbe
  niente** (stesso ordine irraggiungibile); con `InpK` da forex sarebbe il **forward di un motore
  mai testato su EURAUD**. La strada di casa per un simbolo nuovo parte dal **file prova**.
- Qualunque spostamento e' un'**azione a mano dentro MT5**: la scrive il coordinatore con la
  regola dei terminali multipli (numero di conto + cartella + stringa PID/titolo/cartella).

### C. Staccarlo
- Il reale resta con **SlippageLogger + Guardian**, cioe' **zero EA che fanno trading**
  (oggi l'ORB EURAUD e' **l'unico**: `report/NOTTE_2026-09-25.md` r.12).
- Si perde **niente in merito** (non ha mai eseguito) e si toglie il pendente quotidiano.
- Il reale smette di produrre deal: lo `SlippageLogger` resta acceso ma **non avra' niente da
  misurare** finche' non si attacca una sedia nuova.
- 🟠 Resta da capire **chi l'ha attaccato il 12/09 e perche'**: staccarlo chiude il rischio,
  non la domanda.

---

## 🧾 COSA NON SI SA (e dove si troverebbe)
| buco | dove sta la risposta |
|---|---|
| chi ha attaccato l'istanza il 12/09 e perche' | Claudio |
| ordini del 17/09 | giornale `20260917.log` del reale (la foto `CODA_09` si ferma al tetto di 40 righe) |
| ordini del 21/09 | giornale `20260921.log` del reale (nessuna foto `CODA_09` lo copre) |
| spread EURAUD | `ABTG_SpreadLogger` su EURAUD (strada B del 12/09) |
| commissione forex e leva del reale | specifiche del simbolo sul terminale `10105439` |
| che l'`.ex5` dell'ORB sul reale sia compilato dal sorgente v1.04 | hash del file / riga `avviato` nel log |

*Verifiche fatte prima di consegnare: diff dei due preset riga per riga; lotti predetti
dall'1,0% del bilancio contro lotti stampati, 4 su 4 (1,0% dell'equita' e 0,65% del bilancio
falliscono); regola "ultima riga = file piu' vecchio" della sonda CODA_02 provata sul Guardian.
Rivisto dopo il FAIL del cancello (strato 2), correzioni D1-D9.*
