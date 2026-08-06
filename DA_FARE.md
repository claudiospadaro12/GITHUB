# ✅ DA FARE — lista maniacale

_05/08/2026. Ogni voce ha: **cosa**, **perché lo so**, **come si chiude**._
_Aggiornare questo file a ogni chiusura. Quello che non è qui, non esiste._

---

# 🔴 A — RISCHIO IMMEDIATO (sono soldi, adesso)

### A1. `Apertura Marco` e `DAX Apertura EU` sono lo stesso EA
**Prova:** `audit_flotta.py` → **100% su 64 parametri condivisi**. E il 05/08 hanno fatto
lo stesso trade allo stesso secondo allo stesso prezzo (26.339,50 → 26.332,30, +7,20 × 2).
**Effetto:** il segnale d'apertura del DAX rischia **2% + 2% = 4%**. Con una regola prop da
−5% giornaliero, **un trade solo arriva a un passo dal limite**.
**Chiude quando:** Claudio decide se spegnere Marco, o differenziarlo davvero (buffer/ora/lato).

### A2. Tre EA sull'oro condividono il magic **250604**
**Prova:** `audit_flotta.py` → `Gold_Ichimoku_TK_ATR_EA`, `IchiCross_Gold_722`,
`IchiTrend_Gold_Base`.
**Effetto:** se **due di loro girano insieme sullo stesso simbolo**, ognuno vede le posizioni
dell'altro come proprie: le chiude, ci mette il breakeven, ci fa il trailing. Comportamento
imprevedibile.
**Chiude quando:** verificato quali sono attaccati sul VPS. Se più di uno → magic diversi.
**Priorità:** verificarlo **subito**, è una riga da guardare nel Navigatore.

### A3. In forward si rischia il 2%, i backtest sono all'1%
**Prova:** `audit_flotta.py` → 11 EA sopra l'1%. `PostNews` al **3%**, `ORB_GOLD_FIBONACCI_EA`
al **5%**.
**Effetto:** ogni drawdown che ho riportato va **moltiplicato** (×2, ×3, ×5). Il DD del DAX
al 38,96% misurato all'1% diventa un altro film al 2%.
**Chiude quando:** o si porta il forward all'1%, o si rifanno i backtest al 2%. Non a metà.

### A4. La guardia "un trade al giorno" non sopravvive al riavvio
**Prova:** codice, riga 476. Guarda solo se **adesso** c'è un ordine o una posizione. Il
05/08 alle 09:46 il riattacco degli EA ha **ripiazzato i pendenti** su una giornata già
operata (buy stop 26.440,50, ticket #3078825 e #3078827).
**Effetto:** riavviare a mercato aperto = secondo trade non previsto, e dal lato sbagliato.
**Chiude quando:** la guardia legge lo storico deal del giorno per magic, non solo lo stato.
**Nel frattempo:** riattaccare gli EA d'apertura solo **fuori** dalla loro finestra.

### A5. Il `DAX Live5m` gira a **2 lotti**, il doppio degli altri
**Prova:** trade del 05/08, −103,80 contro −52,90 del v2 sullo stesso identico segnale.
**Effetto:** l'EA col difetto strutturale più documentato (3 sweep su 3) è quello che pesa di più.

### A6. Concentrazione sull'oro: 6 short contemporanei
**Prova:** 05/08, −173,02 €. Alle 03:35:54 gli STREV vengono stoppati, **9 secondi dopo**
l'EMA200 rientra short 2 punti più in alto, poi altre 3 volte scalando contro il movimento.
**Effetto:** non sono 6 operazioni indipendenti, è **una con 6× la size**.
**Chiude quando:** esiste un tetto di esposizione per simbolo (il `Guardian` potrebbe farlo).

---

# 🟠 B — MISURE DA RIFARE (i verdetti attuali non valgono)

### B1. ⏳ **IN CORSO 06/08** — misurare il candidato con la gestione ACCESA
**Test pronto:** `walkforward_aperture.ps1 -SoloGestione` → FASE F (32 pass) + FASE G (4 pass).
FASE F: sul candidato (retest · range 35 · buffer 500 · offset 200) spazzola
`InpTP1_R` 0,5/1,0 × `InpTP1_ClosePct` 0/50 × `InpBreakevenAtTP1` off/on, su IS e OOS.
Portati ai valori accesi anche `InpMinStopPts` (0, non 500) e `InpSkipIfTight` (true, non false).
FASE G: rischio **1% contro 2%** sulla gestione accesa, periodo intero — il DD al 2% non è
esattamente il doppio perché il lotto si calcola su un saldo che cambia.
⚠️ **Previsione dichiarata prima**: alla riga 1518 il blocco della parziale gira solo se
`InpTP1_ClosePct > 0` e il breakeven sta dentro quel blocco → **due coppie devono venire
identiche** (parziale 0 con BE off e BE on). Altre coppie identiche = ramo di codice che non gira.
⚠️ **Sul Nasdaq la FASE F non è un test di fedeltà**: gira in `RangeMode=0` e chiusura 17:30,
mentre l'EA acceso usa la candela H1 precedente e chiude alle 21:45 (quello è C6). Vale come
controllo sull'asse gestione, non come "ecco cosa fa il Nasdaq che gira".

### B1-bis. Il testo originale — rifare `aperture_trailing` sulla configurazione ACCESA
**Prova:** `AUDIT_live_vs_backtest.md`. **6 divergenze sul DAX, 9 sul Nasdaq.** Il test usava
TP 1,5R senza parziale né BE, risk 1%; gli EA veri: **TP 3R + parziale 50% + stop in pari**,
risk 2%, Nasdaq in PREVBAR H1, chiusura 21:45.
**Effetto:** *"nessuna combinazione è in profitto"* vale per la configurazione **testata**.
**Non è dimostrato** che descriva quello che gira. **Verdetto sospeso.**

### B2. Il Nasdaq in `RangeMode=2` non è mai stato testato
Gira in PREVBAR H1 dal primo giorno; **tutti** i test l'hanno misurato in OPENING.
→ coperto da `aperture_retest_fade.ps1` (job `NASDAQ_prevH1`).

### B3. Quante volte il buy stop **non è piazzabile** in PREVBAR?
**Prova:** 05/08 ore 14:30, prezzo già a 29.866 sopra il livello (29.830,50): il `BUY STOP`
è stato rifiutato dal broker e all'EA è rimasto **solo l'ordine dalla parte sbagliata**.
Nel codice non c'è nessun controllo, solo un `ABTGLog("BUY STOP fallito")`.
**Chiude quando:** misurata la frequenza. Se è alta, PREVBAR ha un difetto strutturale.

### B4. Discrepanza aperta sul filtro volumi del Nasdaq
Ablazione di inizio agosto: **PF 1,15 su 152 trade**. Test del 05/08 con volumi accesi:
**PF 0,955 su 260 trade**. Cambiano gestione e numero di trade. Da capire prima di
continuare a dare per buono quel filtro.

### B5. Il conteggio dei "trade" è gonfiato fino a 3×
`TP1Pct=50` + `TP2Pct=50` + residuo = fino a 3 chiusure per posizione, e MT5 le conta tutte.
I "393 trade" del MaxMinNotte sono forse 130-180 posizioni. **La soglia di significatività
va applicata alle posizioni.**

### B7. ✅ **CHIUSO 06/08** — lo storico BCM parte dal **26/09/2024**, e va bene così
**Come è stato trovato:** walk-forward 05/08. L'EA fa max 1 trade/giorno su ~21 giorni di borsa
al mese, quindi deve stare intorno a 20/mese. La finestra IS ne dava **10,0**, la OOS **20,4**:
rapporto **2,03 identico su D30EUR e NASUSD** (e lo stesso segno sul Dow). Due simboli diversi,
stesso identico numero → non è mercato, è storico.
**Misurato:** `scarica_storico.ps1` con `SERIES_SERVER_FIRSTDATE`. **PrimaDataLocale =
PrimaDataServer = 2024.09.26** su tutti e 3 i simboli e tutti e 7 i timeframe. Non manca niente
in locale: **BCM prima di quella data non ha nulla.** Tick reali completi da lì (D30EUR 33,6 M ·
NASUSD 162,7 M · U30USD 67,0 M).
**Il conto torna:** la finestra IS non era di 18 mesi ma di **9,1**. Ricalcolato: DAX
**19,80** trade/mese contro i 20,39 dell'OOS · Nasdaq **20,15** contro 20,75. L'anomalia sparisce.
**Conseguenza — ed è l'opposto di quanto scritto il 05/08:**
- il walk-forward **è valido**. IS 26/09/2024→30/06/2025 e OOS 01/07/2025→30/06/2026 sono due
  finestre vere, contigue, non sovrapposte (43% / 57%). **Non c'è niente da riscaricare né da
  rifare** per questo motivo.
- l'IS pesa meno di quanto credessi: **181 trade, non 360**. Campione più piccolo = più rumore.
  Motivo in più per fidarsi dell'altopiano e non della singola cella migliore.
- i crolli IS→OOS **sono crolli veri**: OPENCONFIRM Nasdaq +2086 (PF 1,816) → −145 resta un caso
  da manuale di sovra-ottimizzazione. E lo **Spearman −0,357 del Dow resta in piedi.**
**Resta da fare (documentazione, non misura):** ogni CSV e ogni referto in archivio dice
*"2024.01.01"* nel periodo. **È un'etichetta falsa**: il test parte dal 26/09/2024. Da correggere
ovunque, e da mettere `2024.09.26` come data d'inizio in tutti i driver `.ps1`.
**Tetto invalicabile:** nessun backtest su questi indici può risalire oltre il **26/09/2024**.
Chi promette risultati su periodi più lunghi sta leggendo dati che non esistono.

### B8. ✅ **CHIUSA 06/08** — FASE B rifatta, i tre controlli passati
GAPFILL non è più identico a BREAKOUT (8 righe su 8), DELAYED entra (51-247 trade per riga
invece di 0), RANGE_FADE distingue volumi ON da OFF (4 su 4). RETEST e OPENCONFIRM invariati
al centesimo su 14 righe su 16 — le altre 2 sono in E11.
**Esito:** vince il **RETEST a volumi spenti**. **DELAYED bocciato** (era la mia ipotesi sullo
sweep, ed era sbagliata: IS +1528 sul DAX → OOS −379). **RANGE_FADE bocciato su misura
finalmente valida.**
⚠️ **Corretto il 06/08 da C8:** avevo scritto che il RETEST passava su **due** mercati. Il
+218,98 del Nasdaq era misurato a buffer 200, che nella griglia C8 sta **fra +275 (buf 100) e
−194 (buf 300)**: una cella positiva circondata da celle negative. **Il RETEST passa sul DAX,
non sul Nasdaq.**
→ [REFERTO_FASE_B_C5.md](backtest_pipeline/risultati_archivio/Walkforward_Aperture/REFERTO_FASE_B_C5.md)

### B9. Misurare la prima data vera anche di **XAUUSD, SPXUSD e i cambi**
**Perché:** su D30EUR/NASUSD/U30USD è saltato fuori che i backtest partivano 9 mesi dopo
l'etichetta. Gli altri simboli non sono stati misurati, e in `maxmin_oro.ps1`,
`goldencross_lavorenti.ps1`, `studio_apertura.ps1`, `test_orb_toolkit.ps1`, `valida_realtick*.ps1`,
`scan_market.ps1`, `walkforward.ps1` c'è ancora scritto `FromDate=2024.01.01`. **Non sono stati
corretti apposta**: correggerli senza aver misurato sarebbe rimpiazzare un'etichetta falsa con
un'altra. Sull'oro c'è già un indizio: lo studio della notte trovava M5 solo **dal 28/02/2025**.
**Chiude quando:** lanciato una volta con l'elenco completo — bastano le barre, niente tick:
```
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\scarica_storico.ps1" `
  -Auto -ChiudiMT5 -SenzaTick -Simboli "XAUUSD,XAGUSD,SPXUSD,EURUSD,GBPUSD,USDJPY,AUDUSD,USDCAD,USDCHF,NZDUSD"
```
e poi corrette le date in quei driver.

### B6. Lo storico dell'oro parte davvero dal 2024?
Lo studio della notte ha trovato dati M5 **solo dal 28/02/2025**, ma i backtest chiedono dal
2024.01.01. Se anche l'M1 parte nel 2025, il test copre 16 mesi e non 30 — e sono i mesi in
cui la volatilità dell'oro è **raddoppiata** (29,8 $ → 59,5 $ di ampiezza notturna mediana).

---

# 🟡 C — TEST PRONTI (script scritti, da lanciare)

| # | script | pass | domanda |
|---|---|---:|---|
| C1 | `notte_05-08.ps1` | 56 | OPENCONFIRM (grafico + M15) e geometria dell'ingresso — **in corso** |
| C2 | `goldencross_lavorenti.ps1` | 24 | su H1 bastano **due** candele HA? E le Bollinger in espansione servono? |
| C3 | `aperture_retest_fade.ps1` | 48 | RETEST e RANGE_FADE con la gestione buona (la bocciatura di luglio non vale) |
| C4 | `maxmin_oro.ps1 -Fase 2 -SLMode 0` | 12 | il MaxMinNotte sull'oro a tick reali, griglia spostata dove puntavano i gradienti |

| ~~C5~~ | ~~FASE B rifatta~~ | 48 | ✅ **FATTA 06/08**. I 3 controlli passati. Vince il **RETEST a volumi spenti**: unico in utile OOS su due mercati con campione vero (+392,96 DAX · +218,98 Nasdaq). DELAYED e RANGE_FADE bocciati su misura valida. GAPFILL interessante ma 19 trade. [referto](backtest_pipeline/risultati_archivio/Walkforward_Aperture/REFERTO_FASE_B_C5.md) |
| ~~C8~~ | ~~RETEST × geometria~~ | 80 | ✅ **FATTA 06/08**. **Due motori diversi disegnano la stessa mappa sul DAX**: stesso segno in 18 celle su 20, zona 35–45 positiva **8/8** con tutti e due, zona 5–15 negativa **0/8** con tutti e due. Centro: **range 40, buffer 500**. **Il Nasdaq no**: 2 celle positive su 20, una è +0,01 €. [referto](backtest_pipeline/risultati_archivio/Walkforward_Aperture/REFERTO_FASE_D_C8.md) |
| ~~C11~~ | ~~FASE E — riempimento realistico~~ | 40 | ✅ **FATTA 06/08**. **Cancello passato sul DAX**: pretendendo un ritorno 300 punti più profondo si perde solo il **3,9% dei riempimenti** (409→393) e il range 35 resta positivo a **tutti e quattro** i livelli, in crescita monotona. **Nasdaq: 1 cella positiva su 20 e vale +9,93 €** — quarto fallimento indipendente. [referto](backtest_pipeline/risultati_archivio/Walkforward_Aperture/REFERTO_FASE_E_C11.md) |
| C12 | **geometria dello stop del retest** (`InpSLMode` × `InpAtrSlMult` × `InpTP1_R`) | 48 | l'offset ha migliorato il sistema **accorciando lo stop**, non grazie al realismo: i due effetti sono confusi in C11 e vanno separati |
| C9 | **GAPFILL × soglie** (`InpGapMinPoints` × `InpGapMinRR`) | 64 | PF 2,08 → 1,94 sul Nasdaq ma su 23 e 19 trade: le occasioni salgono restando redditizie? |
| C10 | rifare la sola colonna **GAPFILL volumi ON** | 8 | col binario corretto (E10) |
| C6 | Nasdaq **RETEST** OOS + `RangeMode=2` | 32 | prima di spegnere la linea Nasdaq: è l'unico motore positivo in OOS |
| C7 | DAX **range 40 / buffer 400** con storico completo | — | conferma del centro dell'altopiano dopo aver chiuso B7 |

**Ordine consigliato:** ~~B7~~ ~~C5~~ ~~C8~~ ~~C11~~ → **B1** (rifare il candidato con la
gestione ACCESA: senza quello nessun numero descrive l'EA che gira) → C6 (ultima chance del
Nasdaq) → C12 → C9 → C1 → C10 → C3 → C2 → C4. Mai due insieme: si rubano la CPU.

> 🎯 **Candidato DAX al 06/08:** RETEST · range 35 · buffer 500 · offset 200 · volumi OFF.
> Tre cancelli su quattro passati (fuori campione · vicinato · realismo). **Manca il forward.**
> ⚠️ E manca soprattutto **B1**: questi numeri sono a rischio 1% con TP 1,5R senza parziale né
> breakeven; l'EA acceso gira al 2% con TP 3R + parziale + BE. **DD 11,8% all'1% → ~24% al 2%.**

---

# 🔵 D — DA MISURARE, script ancora da scrivere

- **D1.** Apertura delle **02:00 sull'oro**. Lo studio dice che quell'ora fa il **47,9%**
  dell'escursione della notte, contro il 35,7% della seconda. Nessun EA ci opera.
- **D2.** ORB con la **vera finestra di 15 minuti** dopo l'apertura (contraddizione risolta
  dalle live, mai testata).
- **D3.** Aperture con `RangeMode=PREV` sull'oro.
- **D4.** Breakeven a 0,5R **con** parziale sul DAX (divergenza con le live).
- **D5.** `InpAtrSlMult` per il fade, se il fade mostra qualcosa in C3.

---

# ⚫ E — BUG NOTI, NON RISOLTI

- **E1.** Il bug del **breakeven al lotto minimo** è ancora in **10 EA** in forma diversa:
  `DAX_M3`, `FiboH4_Multi`, `GoldenCross`(+Ott), `Londra_ORB`, `MaxMinNotte`(+Ott), `ORB`,
  `ORB_Fibo`, `SupertrendInvert`. Costa soldi veri.
- **E2.** `InpConfirmMode = CONF_OR` è ancora il default sulle aperture. È l'errore che
  introdussi il 02/08: neutralizza il filtro volumi (PF 1,38 → 0,99). Innocuo finché volumi
  e ATR non sono accesi insieme — ma è una mina.
- **E3.** `InpTrailFixedPts = 410` sopravvive come default anche dove ora `TrailMode = 1`.
  Inerte, ma se qualcuno rimette il modo 2 da preset torna in gioco senza avvisare.
- **E4.** `ABTG_SupertrendReversal_Multi` **non ha** `InpFridayClose`, che il fratello ha.
- **E6.** ✅ *corretto 05/08* — **GAPFILL non veniva mai eseguito.** `if(InpEntryMode == ABTG_GAPFILL
  && InpUseGapFill)`: col flag legacy a `false` l'EA cadeva nel ramo `else // BREAKOUT` **in
  silenzio**. Nel walk-forward il motore 1 dava numeri identici al centesimo al motore 0 su
  2 mercati × 2 finestre × 2 filtri. Ora comanda la modalità; il flag è solo storico.
- **E7.** ✅ *corretto 05/08* — **il filtro volumi non toccava il RANGE_FADE.**
  `TryPlaceRangeFade()` non chiamava né `VolumeOK()` né `ConfirmOK()`, a differenza di breakout,
  retest e delayed. Filtro ON e OFF davano la stessa riga. Ora passa da `ConfirmOK()`.
- **E8.** ✅ *corretto 05/08* — **DELAYED non poteva entrare, mai.** 0 trade su 30 mesi. Non era
  il conflitto `DelayMinutes 30` vs `range 35` (il codice già allineava). La decisione cadeva
  **nell'istante in cui il range si chiude**, e `DIR_BREAK` chiede il prezzo **fuori** dal range:
  ma il range è l'high/low di quella stessa finestra, quindi il prezzo è dentro **per definizione**.
  E il ramo faceva `return(true)`, bruciando la giornata. Ora aspetta la rottura vera entro
  `InpPendingExpiryMin`. **Con filtri spenti e modalità BREAKOUT il comportamento è identico a
  prima: nessun EA in forward cambia.**
- **E10.** ✅ *corretto 06/08* — **anche GAPFILL ignorava il filtro volumi.** `TryPlaceGapFill()`
  non chiamava né `VolumeOK()` né `ConfirmOK()`: nella FASE B rifatta le righe volumi ON e OFF
  erano di nuovo identiche al centesimo. **È lo stesso difetto del RANGE_FADE corretto il 05/08**:
  avevo corretto il caso singolo invece della classe, senza controllare gli altri rami con lo
  stesso schema. Ora c'è l'audit di tutti e sei i motori nel referto C5, e tutti applicano il
  filtro al momento dell'ingresso.
  **Lezione di processo: quando si trova un difetto, si cerca subito lo stesso schema altrove.**
- **E11.** ⚠️ **`NASDAQ RETEST volumi ON` è cambiato fra le due FASE B senza motivo noto**
  (IS +357,30 → +332,40; OOS +279,11 → +274,35; **stesso numero di trade**). L'unico input
  diverso è `InpUseGapFill`, che nel codice compare solo dentro il ramo GAPFILL e non può toccare
  il retest. Ipotesi: fra i due giri è stato riscaricato lo storico a tick reali, e il retest è
  l'unico motore che legge i **volumi tick** nel momento della rottura. **Non dimostrato.**
  Test decisivo, 2 pass: stesso binario, `InpEntryMode=2`, `InpUseVolumeFilter=1`, con
  `InpUseGapFill` a 0 e a 1. Entità trascurabile (0,27 €/trade), nessun verdetto cambia.
- **E9.** ⚠️ **Il motore delle aperture è copiato a mano in ~10 file.** `ABTG_ApertureCore.mqh`
  esiste ma **nessuno lo include** (compare solo nei commenti): è codice morto. Le tre correzioni
  di oggi sono state applicate 3 volte a mano. È esattamente il motivo per cui difetti come E6/E7/E8
  sopravvivono per mesi. **Da unificare.**
- **E5.** I **661 trade non etichettati** (−18.707 €, 485 su XAUUSD, lotti 0,5-1,0, fino al
  27/07): non sappiamo ancora di chi siano.

---

# 🟣 F — DA ATTIVARE

- **F1.** `ABTG_Dow_Apertura_US` in forward su U30USD. È **l'unico** EA validato in
  walk-forward (PF 1,371 · DD 5,32% · 329 trade · 40/40 combinazioni OOS in utile) e
  **l'unico** i cui default combaciano con ciò che è stato misurato. È pronto dal 05/08.
- **F2.** Ricompilare sul VPS per attivare il trailing a base candela M5 su DAX e Marco.

---

# 🧭 G — PROCESSO (perché non ricascarci)

### G1. `audit_flotta.py` — creato il 05/08
Trova da solo: magic duplicati, gemelli comportamentali, chi rischia sopra l'1%, chi dipende
dal timeframe del grafico. **Va lanciato prima di ogni verdetto e dopo ogni modifica agli EA.**

```
python3 backtest_pipeline/audit_flotta.py
```

### G3. `lint_ps1.py` — creato il 06/08, dopo l'ennesimo script rotto
**Perché:** ho mandato a Claudio uno script con dentro `"$tag:"`, che PowerShell legge come nome
di disco e rifiuta di eseguire. Qui non c'è PowerShell per provare gli script prima di mandarli,
quindi il controllo va fatto a mano — cioè con questo.
**Va lanciato PRIMA di ogni push che tocca un `.ps1`. Senza eccezioni.**

```
python3 backtest_pipeline/lint_ps1.py
```

Controlla: `$var:` letto come disco · `"$oggetto.Proprieta"` che non espande ·
here-string aperte e mai chiuse · chiusure `"@` indentate (PowerShell le ignora).

### G2. La regola sui verdetti
Prima di dire *"questo EA fa X"*: **estrarre i suoi default effettivi e metterli accanto a
quelli del test.** Se non combaciano, il verdetto non vale — e va detto **prima**, non dopo.

### G3. Il limite dell'audit automatico, da ricordare
`audit_flotta.py` confronta i **parametri**, non i **motori**. `ABTG_SuperWave` e
`ABTG_SupertrendReversal` hanno 36 parametri su 36 uguali tranne uno, ma il primo entra su un
**incrocio EMA 14/200** e il secondo su un **rimbalzo del Supertrend**. Il codice va letto.

### G4. Dove il timeframe del grafico conta davvero
`AtrValue()` legge `iATR(_Symbol, PERIOD_CURRENT, ...)` e il filtro volumi legge il TF del
grafico. Sulla configurazione attuale (BREAKOUT + SL_RANGE + trailing a base candela) **non
vengono chiamati**, quindi il grafico non conta. Diventano rilevanti appena si accende:
**RANGE_FADE**, stop ad ATR, trailing ad ATR, filtro volumi. Da ricordare quando C3 darà i
risultati.
