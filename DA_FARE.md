# ✅ DA FARE — lista maniacale

_05/08/2026. Ogni voce ha: **cosa**, **perché lo so**, **come si chiude**._
_Aggiornare questo file a ogni chiusura. Quello che non è qui, non esiste._

---

# 🔴 A — RISCHIO IMMEDIATO (sono soldi, adesso)

### A1. ✅ **CHIUSO 06/08 — Claudio ha deciso: `Apertura Marco` si spegne**
**Prova:** `audit_flotta.py` → **100% su 64 parametri condivisi**. E il 05/08 hanno fatto
lo stesso trade allo stesso secondo allo stesso prezzo (26.339,50 → 26.332,30, +7,20 × 2).
**Effetto:** il segnale d'apertura del DAX rischia **2% + 2% = 4%**. Con una regola prop da
−5% giornaliero, **un trade solo arriva a un passo dal limite**.
**🆕 06/08 — la cosa che il 05/08 non sapevo:** girano tutti e due `BREAKOUT` con range 15 e
buffer 200, cioè **la zona misurata negativa**: 0 celle positive su 4 fuori campione col
breakout, 0 su 4 col retest, e sul periodo intero a buffer 200 media −214,31. Il candidato
validato fa +1198,79 con PF 1,237. **Non è più "quale spengo": tutti e due girano una geometria
che non guadagna.**
**Fatto nel codice (06/08):** nuovo `InpMaxPosSimbolo` (default **0 = spento**) che conta
posizioni+pendenti sul simbolo **ignorando il magic** e blocca il piazzamento oltre il tetto.
⚠️ È una **mitigazione, non una soluzione**: due EA possono piazzare nello stesso tick.
**Raccomandazione:** spegnere `Apertura Marco`. Non solo per il rischio doppio — nel suo codice
esistono **solo BREAKOUT e GAPFILL**, non può nemmeno eseguire il retest che abbiamo validato.
**Decisione presa il 06/08**, dopo la seconda occorrenza documentata in diretta (−205,92 su un
segnale). Fatto nel repo: banner di ritiro in testa al sorgente, `InpMaxPosSimbolo` portato a 1
come rete di sicurezza, EA tolto dalla lista di `scarica_ottimizzati.ps1`, riga barrata in
`FLOTTA_ATTIVA.md`.
**⚠️ Resta da fare sul VPS, e l'ordine conta:** staccare l'EA **non** chiude la sua posizione né
cancella i suoi pendenti, e da quel momento nessuno gestisce più trailing, breakeven e chiusura
delle 17:30. Prima si chiude la posizione #3088161, poi si stacca. → [report](report/A1_A4_rischio_immediato.md)

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

### A4. ✅ **CORRETTO 06/08** — la guardia "un trade al giorno" non esisteva proprio
**Cosa ho trovato:** `InpOneTradePerDay` era dichiarato alla riga 185 e **non era usato in nessun
punto del codice**. L'unica cosa che limitava a un ciclo al giorno era la macchina a stati, e
`gPhase` al riavvio riparte da `PH_WAIT_OPEN`. La guardia esistente vedeva solo se in quel momento
c'era un ordine o una posizione: **a trade già chiuso non vedeva niente.** Da lì i pendenti
riarmati il 05/08 alle 09:46 (ticket #3078825 e #3078827) su una giornata già operata alle 08:34.
**Correzione:** `HaGiaOperatoOggi()` legge lo **storico dei deal del giorno** per simbolo+magic e
cerca un `DEAL_ENTRY_IN`. Chiamata una volta al giorno **e a ogni riavvio** (le globali ripartono
da −1), non a ogni tick. Applicata ai quattro EA d'apertura.
**⚠️ Cambia il comportamento in forward, ed è voluto:** riattaccare un EA su una giornata già
operata non riarma più niente. Nel log compare *"oggi ho GIA' operato (storico deal del giorno):
non riarmo"*. **Va ricompilato e riattaccato sul VPS**, fuori dalla finestra operativa.
**✅ Verificato in diretta il 06/08 alle 19:25**: `DAX Apertura EU` e `Nasdaq Apertura US`
riattaccati su una giornata già operata → *"oggi ho GIA' operato: non riarmo"*. Funziona.
**🔴 MA la prima applicazione era incompleta, e si è visto subito.** Avevo messo la guardia solo
sui quattro EA che si *chiamano* "Apertura", mentre la macchina a stati difettosa è identica in
**nove** EA. Alle 19:17 dello stesso giorno `Nasdaq Apertura US OTT` (che non l'aveva) ha
**ripiazzato un BUY STOP a mercato aperto** su una giornata già operata — esattamente il difetto
che la guardia doveva impedire. Estesa il 06/08 sera a `DAX_Apertura_EU_Ottimizzato`,
`Nasdaq_Apertura_US_Ottimizzato`, `DAX_Live5m`, `DAX_Live5m_v2`, `Nasdaq_Live5m`.
**Ora 9 su 9.** *(Terza volta che correggo il caso invece della classe: vedi E10 e G5.)*
→ [report](report/A1_A4_rischio_immediato.md)

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

### B1. ✅ **CHIUSO 06/08** — la gestione accesa non peggiora il candidato, lo migliora
**Misurato:** FASE F (32 pass) + FASE G (4 pass) sul candidato retest · range 35 · buffer 500 ·
offset 200. Il controllo dichiarato prima del test è passato: **8 coppie su 8 identiche come
previsto** (parziale 0 → il flag breakeven non può fare niente), e nessun'altra coppia identica.
**Risultato, DAX fuori campione:**
| gestione | OOS | PF | DD |
|---|---:|---:|---:|
| TP 1,5R secco *(quella dei test A–E)* | +834,12 | 1,164 | 11,65% |
| **TP 3R + parziale + BE — quella ACCESA** | **+1198,79** | **1,237** | **10,49%** |
Più profitto, PF più alto, drawdown più basso. **Tutte e sei le gestioni sono positive in OOS**:
la geometria regge da sola e la gestione la migliora.
**Il 2% misurato (FASE G):** profitto **×2,03**, DD **×1,95** → DD reale **20,40%**, non il 24%
che avevo stimato (la mia stima partiva dalla base sbagliata). Resa/DD **0,65 all'1% e 0,68 al 2%**:
raddoppiare la size non migliora il sistema, ne raddoppia la scala.
**Nasdaq:** la gestione accesa lo migliora (da −768,68 a −154,68) ma resta negativo, e al 2% ha
**24,50% di DD**. Da spegnere.
→ [REFERTO_FASE_F_G_B1.md](backtest_pipeline/risultati_archivio/Walkforward_Aperture/REFERTO_FASE_F_G_B1.md)

### B1-bis. Il testo originale — rifare `aperture_trailing` sulla configurazione ACCESA
**Prova:** `AUDIT_live_vs_backtest.md`. **6 divergenze sul DAX, 9 sul Nasdaq.** Il test usava
TP 1,5R senza parziale né BE, risk 1%; gli EA veri: **TP 3R + parziale 50% + stop in pari**,
risk 2%, Nasdaq in PREVBAR H1, chiusura 21:45.
**Effetto:** *"nessuna combinazione è in profitto"* vale per la configurazione **testata**.
**Non è dimostrato** che descriva quello che gira. **Verdetto sospeso.**

### B2. Il Nasdaq in `RangeMode=2` non è mai stato testato
Gira in PREVBAR H1 dal primo giorno; **tutti** i test l'hanno misurato in OPENING.
→ coperto da `aperture_retest_fade.ps1` (job `NASDAQ_prevH1`).

### B3. ⬆️ **CONFERMATO IN DIRETTA 06/08** — il buy stop rifiutato lascia UN SOLO LATO
**Prova nuova, dal log Esperti delle 19:17:56:**
```
ABTG_ORB  CTrade::OrderSend: buy stop 0.90 NASUSD at 29260.20 sl: 29202.50 tp: 29375.60 [invalid price]
ABTG_ORB  [ORB] SELL STOP @ 29192.50000 SL 29250.20000 TP 29077.10000 lot 0.90
```
Il **BUY STOP viene rifiutato** dal broker (`invalid price`: il prezzo era già sopra il livello,
quindi lo stop non è piazzabile) e **il SELL STOP passa**. L'EA resta armato **su un lato solo**,
e per costruzione dal lato sbagliato: se il prezzo è già salito, l'unico ordine vivo è quello che
scommette sulla discesa.
Nel codice non c'è nessun controllo: solo un log. **Non è più un'ipotesi, è documentato.**
**Chiude quando:** misurata la frequenza, e deciso cosa fare quando un lato non è piazzabile
(saltare la giornata? entrare a mercato? aspettare?).

### B3-bis. Il testo originale
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
| ~~C12~~ | **FASE H — il drawdown** (`InpAtrSlMult` × offset, con SL ad ATR) | 64 | assorbe C12 e lo risolve alla radice: con `InpSLMode=ATR` la distanza dello stop **non dipende più da dove entro**, quindi l'offset torna a essere solo un filtro sui riempimenti. Se il DD migliora anche così erano i riempimenti, se il miglioramento sparisce era la geometria dello stop |
| C9 | **GAPFILL × soglie** (`InpGapMinPoints` × `InpGapMinRR`) | 64 | PF 2,08 → 1,94 sul Nasdaq ma su 23 e 19 trade: le occasioni salgono restando redditizie? |
| C10 | rifare la sola colonna **GAPFILL volumi ON** | 8 | col binario corretto (E10) |
| C6 | Nasdaq **RETEST** OOS + `RangeMode=2` | 32 | prima di spegnere la linea Nasdaq: è l'unico motore positivo in OOS |
| C7 | DAX **range 40 / buffer 400** con storico completo | — | conferma del centro dell'altopiano dopo aver chiuso B7 |

**Ordine consigliato:** ~~B7~~ ~~C5~~ ~~C8~~ ~~C11~~ ~~B1~~ ~~A4~~ → **FASE H** (il drawdown: è
lì che si gioca la prop) → decisione su A1 e sui 4 parametri del DAX → C6 → C9 → C1 → C10 → C3 →
C2 → C4. Mai due test insieme: si rubano la CPU.

> 🏦 **La domanda prop, con i numeri del 06/08.** Su 100k: all'1% di rischio +6 800 €/anno con
> **10 490 € di DD**; al 2% +13 900 € con **20 400 €**. Un limite tipico è il 10% totale e il 5%
> giornaliero → **al 2% si esce subito, all'1% si fallisce di un pelo.** Serve resa/DD sopra 1,5;
> oggi è **0,65–0,68**. Il collo di bottiglia non è il profitto, è il drawdown — da qui la FASE H.
> ⚠️ E il **limite giornaliero non era mai stato misurato**: da oggi i CSV hanno la colonna
> `Peggior Giornata %`.

> ✅ **APPLICATO il 06/08 nel sorgente di `ABTG_DAX_Apertura_EU`** (non ancora sul VPS).
> ⚠️ Non basta ricompilare: MT5 salva i parametri **sul grafico**. Serve staccare, riattaccare e
> premere **RIPRISTINA**. Verifica dalla scheda Esperti: all'avvio l'EA scrive ora la riga
> `CONFIG IN USO -> motore=... | range=... | buffer=... | offset retest=...`. Se non corrisponde,
> il Ripristina non è stato preso.
>
> 🎯 **Candidato DAX al 06/08 — quattro cancelli su cinque:**
> `InpEntryMode=2` (retest) · `InpRangeMinutes=35` · `InpBufferPoints=500` · `InpRetestOffsetPts=200`
> · volumi OFF, gestione invariata (TP 3R + parziale 50% + BE).
> ✅ fuori campione · ✅ vicinato (due motori) · ✅ realismo dei riempimenti · ✅ gestione vera.
> ❌ **manca solo il forward.**
> Fuori campione: **+1198,79 · PF 1,237 · DD 10,49%** all'1% · **DD 20,40%** al 2%.
> ⚠️ **L'EA acceso oggi NON è questo**: gira in breakout con range 15 e buffer 200, cioè la zona
> che fuori campione perde. Sono **quattro parametri** da cambiare, ed è una decisione di Claudio.

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

### B10. La `Peggior Giornata %` misura UN SOLO EA, non il conto
La nuova colonna viene dal tester, dove gira un EA alla volta. In forward il limite giornaliero
di una prop si applica alla **somma di tutti gli EA**: se tre perdono lo stesso giorno, il conto
vede la somma. Quindi il numero misurato è un **limite inferiore**, non la realtà.
**Si lega ad A1 e ad A6:** proprio le giornate storte sono quelle in cui gli EA correlati perdono
insieme. **Chiude quando:** esiste una misura della peggior giornata *di portafoglio*, presa dallo
storico reale del conto invece che dal tester.

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

### G4. `verifica_fasi.py` — creato il 06/08, dopo la FASE F non partita
**Perché:** sei CSV vuoti. Sei parametri finivano **due volte** in `[TesterInputs]` — una nel
blocco job e una nello sweep — e MT5 non produceva nessun pass.
**Ma il problema vero è un altro:** l'audit che avevo scritto a mano **non l'ha visto**, perché
deduplicava sia il blocco job sia la blindatura mentre lo script deduplicava **solo** la
blindatura. Stavo controllando un codice diverso da quello che girava.
**Quindi questo script non "controlla i parametri": ricostruisce la composizione esatta leggendola
dal `.ps1`**, e se il `.ps1` cambia in modo da rendere la ricostruzione infedele, se ne accorge e
si rifiuta di dare un verdetto.
**Va lanciato PRIMA di mandare un test.**

```
python3 backtest_pipeline/verifica_fasi.py
```

Controlla: duplicati in `[TesterInputs]` · input dell'EA non pinnati (escluse le stringhe, che MT5
non può ottimizzare) · celle della griglia contro i pass dichiarati (sapendo che `InpEntryMode` è
un enum e MT5 li spazzola tutti e sei).

**Lezione generale:** un controllo che simula il codice a memoria non è un controllo. O legge il
codice vero, o si accorge di non poterlo più leggere.

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

---

## 🔴 Aperto il 06/08 sera, dalla verifica del deploy sul VPS

Referto: [`report/VERIFICA_DEPLOY_06-08.md`](report/VERIFICA_DEPLOY_06-08.md)

### A7. `ABTG_DAX_Apertura_EU_Ottimizzato` non risulta in forward
Su 10 righe `CONFIG IN USO` del 06/08 non compare mai. O non è attaccato a nessun grafico,
o è attaccato senza AutoTrading, o non è stato riavviato — e in questi ultimi due casi
**non ha la guardia A4** e riarma i pendenti su una giornata già operata.
**Da distinguere sul VPS guardando la faccina in alto a destra sul grafico.**

### A8. `DAX Live 5m` e `DAX Live5m v2` sono lo stesso EA
59 parametri in comune, **59 identici**. I 7 in più del v2 sono neutri per default:
filtro volumi OFF, `InpSkipIfTight` false, `InpBEatR` 0. L'unica differenza vera è
`InpMinStopPts = 200`, un **pavimento** sullo stop: lo allarga, **non salta il trade**.
Quindi entrano sullo stesso segnale, stesso momento, stessa direzione — al 2% e all'1%,
cioè **3% su un segnale solo**. È A1, identico a `Apertura Marco`.
**Prima di decidere: confrontare i parametri sul GRAFICO**, non i default nel codice
(il rischio 2% vs 1% è già una prova che sul grafico sono diversi dai default).

### A9. Esposizione per simbolo — il tetto teorico è 11%
D30EUR 5% (2+2+1) · NASUSD 5% (2+1+2) · U30USD 1%. Non è una previsione, è il tetto.
Con una regola prop del 5% giornaliero, **un solo simbolo esaurisce la giornata**.
Da riportare sotto controllo prima di parlare di prop.

### A10. `DAX Apertura EU Ottimizzato` girava ancora il trailing a punti fissi
Nel log del 06/08: `trail=ABTG_TRAIL_FIXED PERIOD_M1`. È il trailing a **410 punti fissi**
trovato il 05/08 dopo tre aperture DAX chiuse sotto il minuto al 3% del target, e **mai
entrato in nessun backtest**. Il 05/08 è stato corretto su `ABTG_DAX_Apertura_EU`
(`ABTG_DEF_TRAIL_MODE` 2 → 1, `InpTrailTF` M1 → M5: su 440 trade M1 −801 · M5 −79).
**Sull'`_Ottimizzato` era rimasto `2`.** Nella stessa schermata gli altri sette EA dicono
tutti `TRAIL_PREVBAR`: era l'unico.
**Fatto nel codice il 06/08** (`ABTG_DEF_TRAIL_MODE` 1, `InpTrailTF` M5).
⚠️ **Non basta:** MT5 tiene i parametri sul GRAFICO, quindi l'EA acceso continua col
trailing fisso finché non si cambia `InpTrailMode` a mano nelle sue proprietà.
**Da fare sul VPS, decisione di Claudio.**

### G5. Ora dei LOG ≠ ora del GRAFICO — e il 06/08 ci sono cascato
Scheda Esperti e Giornale sono in **ora LOCALE del PC**; grafico, candele e `TimeCurrent()`
sono in **ora SERVER**. Sul VPS Windows è in ora italiana, il server BCM un'ora indietro.
Ho letto `BUY STOP alle 09:15` in un log e ho annunciato un **ritardo di un'ora** che non
esisteva: erano le **08:15 server**, cioè la fine esatta del range 08:00–08:15.
La colpa era di un mio file: `log_ea.ps1` diceva *"finestra oraria (ora SERVER, come nei
log)"*. Corretto in tre punti + avviso in cima al `param()`, e la regola è finita in
`CLAUDE.md`.
**Controllo lampo:** l'ultima riga del log deve coincidere con l'orologio di Windows;
l'ultima candela del grafico sta un'ora indietro.

### C14. ✅ CHIUSO il 07/08 — e la mia ipotesi era SBAGLIATA
**Non sparisce nessun trade.** Il lotto d'ingresso non va mai a zero: la funzione di
dimensionamento fa `lot = MathMax(minLot, ...)`, quindi **arrotonda in SU al lotto minimo**.
Un trade sottodimensionato viene preso lo stesso.

**Quello che sparisce è la CHIUSURA PARZIALE**, e MT5 la conta come un trade a sé.
Verifica aritmetica: la finestra OOS è di 12 mesi, ~250 giorni di borsa, e con
`OneTradePerDay` non si possono superare ~250 posizioni. Il CSV ne dichiara **324**:
i 74 in più sono parziali. Stessa cosa in campione (241 su ~195 giorni).
Con lo stop largo il lotto scende al minimo, il 50% del minimo sta **sotto** il minimo,
`NormalizeVolume` restituisce 0 e la parziale non viene fatta → meno "trade" contati.

**Il conteggio non invalida la FASE H.** Ma la conclusione «stop largo = meglio» va letta
sapendo che nelle celle a stop largo **la gestione non è tutta accesa**. Vedi E2.

### E2. 🔴 Il breakeven è ANNIDATO dentro la chiusura parziale — 9 EA
Trovato il 07/08 mentre chiudevo C14. Il codice è questo:

```
double closeVol = NormalizeVolume(vol * InpTP1_ClosePct/100.0);
if(closeVol > 0 && closeVol < vol)
   if(gTrade.PositionClosePartial(ticket, closeVol))
     {
      ...
      if(InpBreakevenAtTP1) { ... }      // <-- sta QUI DENTRO
     }
```

**Se la parziale non si può fare, non si fa nemmeno il breakeven.** E la parziale non si può
fare ogni volta che la posizione è al **lotto minimo**: il 50% di 0,10 è 0,05, sotto il
minimo, `NormalizeVolume` torna 0 e l'intero blocco viene saltato.

**Conseguenza in forward: una posizione al lotto minimo gira senza protezione a pari.**
Lo stop resta quello iniziale, a rischio pieno, anche dopo aver raggiunto il primo obiettivo.
E `InpBEatR` (il breakeven indipendente del punto 2b) è a **0**, quindi non c'è rete.

**Estensione verificata: 9 EA su 9** fra quelli con la macchina a stati delle aperture
(`Marco`, `DAX_Apertura_EU`, `DAX_Apertura_EU_Ottimizzato`, `DAX_Live5m`, `DAX_Live5m_v2`,
`Dow_Apertura_US`, `Nasdaq_Apertura_US`, `Nasdaq_Apertura_US_Ottimizzato`, `Nasdaq_Live5m`).
⚠️ Gli **altri 31 EA** che usano `PositionClosePartial` **non sono stati controllati**: la
scansione guardava solo i 700 caratteri dopo la chiamata. Da fare.

**✅ FATTA il 07/08 su tutti e 9 gli EA.** Il breakeven è ora **fuori** dal ramo della
parziale: se la parziale non si può fare, il pari si fa lo stesso.

Due generazioni di codice, due varianti della stessa correzione:
- **4 EA a stato per-ticket** (`Marco`, `DAX_Apertura_EU`, `Dow`, `Nasdaq_Apertura_US`):
  guardia `!TkDone(ticket, gBETk)`, che è lo stesso token del breakeven indipendente — così
  i due non si pestano i piedi.
- **5 EA a stato globale** (`DAX_Live5m`, `Live5m_v2`, `Nasdaq_Live5m`, i due `_Ottimizzato`):
  aggiunta la globale `gBEDone`, azzerata dove si azzera `gPartialDone`.

Aggiunte due cose che prima non c'erano:
1. **la guardia «mai arretrare lo stop»** (`be > sl` per i long, `be < sl` per gli short).
   Prima non serviva perché il ramo girava una volta sola; adesso che può essere
   raggiunto anche senza parziale, serve.
2. **una riga di log quando la parziale è impossibile**, così in forward si vede:
   *«parziale impossibile al lotto X (minimo del broker), stop a pari lo stesso»*.

`riskDist` non cambia: con lo stop a pari `InitialSL` restituisce 0 e scatta lo stesso
ripiego sull'ATR che c'era già dopo la parziale. Verificato: 9 su 9, graffe bilanciate.

### ✅ 07/08 — controllati TUTTI e 40 gli EA con la chiusura parziale. E ce n'erano altri 11.

Non erano 31: gli EA che usano `PositionClosePartial` sono **40**. Classificati tutti.

| gruppo | quanti | stato |
|---|---:|---|
| corretti stanotte (aperture + Live5m) | 9 | ✅ |
| famiglia `bool parz = (...)` — `EMA200`, `PTE`, `SupRev*`, `SuperWave*`, `SupertrendReversal*`, `WOL` | 17 | ✅ **già corretti il 04/08** |
| `IchiCross_Gold_722` · `DAX_MASTER_PROP` · `Gold_Scalper_TK_BB_BE_EA` | 3 | ✅ breakeven già indipendente |
| **trovati difettosi il 07/08 e corretti** | **11** | ✅ |

Gli **11 nuovi**: `ABTG_DAX_M3` · `ABTG_FiboH4_Multi` · `ABTG_GoldenCross` ·
`ABTG_GoldenCross_Ottimizzato` · `ABTG_Londra_ORB` · `ABTG_MaxMinNotte` ·
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato` · `ABTG_ORB` · `ABTG_ORB_Fibo` ·
`ABTG_SupertrendInvert` · `BULGE_MASTER`.

Dieci avevano la forma compatta `if(cv>0 && cv<vol && PositionClosePartial(...)) { ...; if(InpBreakeven) ... }`
— stesso difetto della forma lunga. `BULGE_MASTER` aveva una variante peggiore:
`if(closeVol < lotMin) continue;` **saltava l'intera posizione**, breakeven compreso.

**Come sono stati corretti** (idioma unico su tutta la flotta, quello degli `EMA200`):
```
bool parzOK = (cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv));
if(parzOK) gPart1=true;
bool beFatto = (InpBreakeven && ((dirLong && bePari>slPrec) ||
                                 (!dirLong && (slPrec==0 || bePari<slPrec))));
if(beFatto) gTrade.PositionModify(...);
```
La condizione «solo se **migliora** lo stop» fa due cose insieme: impedisce di arretrare lo
stop, e **si autospegne** — appena lo stop è a pari la condizione è falsa e non si ripete a
ogni tick. Su `BULGE_MASTER` la `GlobalVariable` di "già fatto" ora si scrive solo se il
parziale **o** il breakeven sono riusciti, così un BE respinto dallo `STOPS_LEVEL` viene
ritentato invece di essere perso.

**Verifica finale: 40 EA su 40, zero breakeven annidati, graffe bilanciate ovunque.**

📌 **Nota storica che vale più della correzione:** l'idioma giusto esisteva già dal **04/08**,
con tanto di commento che documentava il danno misurato (*«due short oro a 0,01 lotti hanno
toccato 1,28R di profitto con lo stop ancora all'originale, −112,78 EUR di oscillazione»*).
Era stato applicato a 17 EA e **fermato lì**. Quarta volta che correggo il caso invece della
classe. Da qui in poi: quando si corregge un difetto, **si conta quanti file lo hanno**,
prima di dire che è chiuso.

⚠️ **Resta da fare:** ricompilare e riattaccare sul VPS.

### C14-bis. I trade che sembravano sparire (nota storica)
DAX OOS, offset 300: **324 trade a ×1,0 → 270 a ×2,5, il 17% in meno.** Con
`InpOneTradePerDay=1`, `InpMinRangePts=0`, `InpMaxRangePts=0` e `InpSkipIfTight=0` quei
trade non dovrebbero mancare.
**Ipotesi:** stop più largo → lotto più piccolo → sotto il lotto minimo del broker → trade
saltato in silenzio. Se è così, parte del "miglioramento" della FASE H è un **filtro
involontario** sulle giornate a range ampio, non merito dello stop.
**Va verificato PRIMA di agire sulla conclusione «stop largo = meglio».** Stessa famiglia
del bug del breakeven al lotto minimo (E1).

### C15. Estendere il moltiplicatore ATR e misurare quanto vale lo stop dal range
Al ×2,5 la curva **sta ancora migliorando**: non sappiamo dov'è il massimo. Due cose insieme:
provare **3,0 / 3,5 / 4,0**, e **misurare in quanti ATR si traduce lo stop preso dal range**,
così si capisce se il riferimento è già il massimo o se sta solo più a destra.

### B11. La coda del Nasdaq: −5,2% in una giornata sola, al rischio dell'1%
FASE H, Nasdaq IS, le quattro celle ad ATR ×1,0: **−5,19 / −5,20 / −5,23 / −5,24%** di
peggior giornata. Quattro celle diverse, **la stessa giornata**, su un sistema da un trade
al giorno. Con una regola prop da −5% giornaliero **quella giornata chiudeva il conto**.
Da identificare la data e capire se è un gap, uno spike o un difetto di dimensionamento.
Sul DAX la stessa colonna non supera mai ~1,1× il rischio nominale.

## 🐛 07/08 mattina — FASE I a vuoto e FASE L a metà: sweep degeneri

**Cos'è successo.** Ho scritto due righe di sweep con il flag `Y` ma **start == stop e
step == 0**:

```
InpTrailTF=5||5||0||5||Y      -> FASE I: ZERO pass, tutti e 4 i CSV VUOTI
InpRangeMode=0||0||0||0||Y    -> FASE L: l'enum e' rimasto pinnato a 0, la fase ha
                                 girato ma ha risposto a un'altra domanda
```

La forma che funziona era già nel file, in FASE B: `InpEntryMode=0||0||5||5||Y` — **due
estremi diversi e step ≠ 0**. Sugli enum MT5 ignora i numeri e spazzola tutti i valori,
**ma solo se la riga non è degenere**.

**Corretto:**
- `InpTrailTF=5||1||4||5||Y` → vale `{M1, M5}` anche a numeri. Se MT5 spazzola tutto l'enum
  esce la curva dei 22 timeframe; se rispettasse i numeri escono **esattamente i due valori
  che ci interessano**. Nessun esito è uno spreco.
- `InpRangeMode=0||0||1||2||Y` → copre i tre valori sia a numeri sia come enum.

**🔴 E `verifica_fasi.py` diceva «ok» a tutte e due.** Il controllo sapeva che gli enum
vengono spazzolati per intero, ma non che la riga deve essere non degenere: ha promosso una
configurazione che ha buttato una notte di macchina. **Seconda volta che un mio controllo
convalida una cosa rotta.**
Aggiunto il controllo `SWEEP DEGENERE`, e **verificato all'incontrario**: rimettendo la riga
vecchia, adesso la boccia.

**Regola:** un controllo nuovo va provato **anche sul caso che deve bocciare**, non solo su
quello che deve passare. Se passa tutto, non hai un controllo — hai un timbro.

## 07/08 — FASE I e FASE L. Un controllo fallito che vale più di dieci riusciti.

Referto: [`REFERTO_FASE_I_L.md`](backtest_pipeline/risultati_archivio/Walkforward_Aperture/REFERTO_FASE_I_L.md)

### D1. 🔴 Il trailing M5 sul DAX è stato scelto in campione — da rifare
Il 05/08 il `DAX Apertura EU` è passato da `PREVBAR M1` a `PREVBAR M5` in forward sulla base
di *«440 trade: M1 −801 · M5 −79»*. La FASE I mostra che quel numero **è la riga IS**:
fuori campione l'ordine si inverte (IS M5 +347,62 e M1 −493,33 · OOS M1 −855,73 e M5
−1298,56, **Spearman −0,60**).
**Non toccare niente adesso**: la fase gira sulla geometria bocciata (BREAKOUT 15) e tutte le
celle OOS sono negative. **Va rifatta sul candidato `RETEST` 35/500/offset 200**, e solo
allora si decide.

### D2. ❌ ANNULLATO l'esperimento «trailing Nasdaq da M1 a M5»
Lo avevo proposto dopo la pagella del 06/08 (17% di movimento catturato). **I numeri dicono
il contrario**: Nasdaq OOS M1 −550,34 contro M5 −1513,57. Sarebbe costato quasi tre volte
tanto. Il problema del 17% resta aperto, ma **la causa non è il timeframe del trailing.**

### D3. 🔴 C6 CHIUSA — e il Nasdaq d'apertura gira la peggiore delle tre configurazioni
`InpRangeMode`, Nasdaq fuori campione:

| | Profit | PF | DD |
|---|---:|---:|---:|
| 0 OPENING 35 | +107,19 | 1,022 | 7,88% |
| 0 OPENING 15 | −681,90 | 0,886 | 11,70% |
| 1 PREV | −1600,74 | 0,798 | 17,35% |
| **2 PREVBAR ← quello ACCESO** | **−2444,14** | **0,665** | **26,29%** |

`ABTG_Nasdaq_Apertura_US` e `_Ottimizzato` hanno `ABTG_DEF_RANGE_MODE 2`, verificato nel
codice. **Sesto test indipendente fallito**, e stavolta non è teoria: è la configurazione in
forward. Al 2% di rischio quel drawdown supera il 50%.
**Decisione di Claudio: spegnere o portare a rischio simbolico.**

### D4. ✅ Arrivati gli ultimi due CSV — e ribaltano tutto
`RangeMode` fuori campione **rovescia la classifica in campione su tutti e due i simboli**,
con lo **stesso identico Spearman −0,80**.

| DAX | IS | OOS |
|---|---:|---:|
| **OPENING 35** ← acceso | −9,02 | **+1198,79** (PF 1,237) |
| OPENING 15 | −1241,91 | −318,43 |
| PREVBAR | +380,16 | −748,39 |
| PREV | **+509,69** | **−886,05** |

| Nasdaq | IS | OOS |
|---|---:|---:|
| OPENING 35 | −261,87 | **+107,19** (PF 1,022) |
| OPENING 15 | −702,75 | −681,90 |
| PREV | +106,12 | −1600,74 |
| **PREVBAR** ← acceso | **+434,08** | **−2444,14** (PF 0,664 · DD 26,29%) |

**Sul DAX**: scegliere sull'IS avrebbe portato a `PREV`, che fuori campione fa −886,05 contro
i +1198,79 della cella già in uso. **2085 € di differenza.**
**✅ Il candidato ne esce rafforzato: `RangeMode` non è una leva, il DAX sta già sulla cella
migliore delle quattro** — e per la terza volta riproduce +1198,79 al centesimo.

**🔑 Il pezzo che unisce le due fasi:**

| decisione presa in forward | in campione | fuori campione |
|---|---|---|
| DAX trailing `PREVBAR M5` (dal 05/08) | migliore dei 5 | **peggiore dei 5** (ρ −0,60) |
| Nasdaq `RangeMode PREVBAR` | migliore dei 4 | **peggiore dei 4** (ρ −0,80) |

Due parametri che non c'entrano niente l'uno con l'altro, **due volte lo stesso ribaltamento**.
Non è sfortuna: è la firma del sovradattamento, misurata due volte in una notte.

### G8. Mai aprire un file in scrittura mentre lo si sta ancora leggendo
Il 07/08 ho scritto `open(p,'w').write(open(p).read().replace(...))`: Python apre in
scrittura **e tronca subito**, poi legge un file ormai vuoto e ci scrive dentro il nulla.
**`report/DIARIO.md` è andato a 0 byte.** Recuperato con `git checkout --` perché era
committato — cioè la REGOLA #1 ha appena pagato per la prima volta in modo visibile.
**Regola: si legge tutto, si trasforma in memoria, si apre in scrittura UNA volta sola alla
fine.** E dopo ogni modifica a un file di testo si controlla che non sia diventato vuoto.

### D5. Errore mio nella progettazione della FASE I
Ho pinnato `InpBufferPoints = 300` su **entrambi** i simboli: è il buffer del Nasdaq live, il
DAX live usa **200**. Le righe DAX non corrispondono a nessuna configurazione reale. Non
cambia le conclusioni (il confronto fra timeframe è interno alla stessa configurazione) ma
va corretto prima di rifarla. **Le fasi che pinnano valori "come il live" devono pinnarli
PER SIMBOLO**, non una volta sola.

### G6. Come MT5 spazzola davvero gli enum
Non spazzola tutti i valori: spazzola **i membri compresi fra `start` e `stop`, ignorando lo
`step`**. `InpTrailTF=5||1||4||5||Y` ha prodotto **M1 M2 M3 M4 M5**, cinque celle, non 22.
**Gli estremi contano, lo step no.** Da tenere presente progettando ogni sweep su enum —
e `verifica_fasi.py` ancora non lo sa: continua a stimare "tutti i valori dell'enum".

### G7. Lo script adesso dice in fondo QUALI CSV mancano
Il 07/08 due passate su otto non hanno prodotto il CSV (`DAX_L_rangemode_OOS` e
`NASDAQ_L_rangemode_IS`). Il messaggio *"(nessun CSV per ...)"* c'era, ma scorreva via in
mezzo a cento righe, e in fondo lo script scriveva solo *"FINITO — devono esserci 12 CSV"*,
un numero fisso che non c'entrava più niente con la fase lanciata.
**Risultato: venti messaggi passati a cercare file che non esistevano**, con Claudio che
pescava senza saperlo dalla cartella `vecchi\`.
Adesso in fondo esce il conto vero — attesi / presenti / **mancanti**, con l'elenco dei nomi
in rosso — e il suggerimento giusto: **rilanciare lo stesso comando SENZA `-Rifai` rifà solo
quelli mancanti**, perché il salto "già fatto" si basa sull'esistenza del CSV.
**Regola:** un riepilogo finale che stampa un numero fisso non è un riepilogo. Deve contare
quello che è successo davvero in quella corsa.


## 07/08 — FASE M: l'ultimo tentativo sul Nasdaq, con le regole scritte prima

### La decisione presa oggi: rischio a 0,25%, non spegnimento
Claudio non vuole arrendersi sul Nasdaq d'apertura. **Deciso: i due EA restano accesi ma a
`InpRiskPercent = 0.25`.** Si continua a raccogliere forward vero — l'unico dato non
contaminato che abbiamo — e il drawdown misurato del 26,29% all'1% scende sotto il 7%
invece di superare il 50% come al 2%.

### ⚠️ Il rischio di questa ricerca, scritto per non dimenticarlo
Sul Nasdaq abbiamo fatto **sei test e falliti tutti e sei**. Continuare finché una
configurazione non "passa" **trova sempre un vincitore, anche quando non c'è niente** — ed
è esattamente il meccanismo che stanotte abbiamo misurato due volte (Spearman −0,60 e
−0,80). **Contatore delle ipotesi provate sul Nasdaq d'apertura: 7 con la FASE M.**

### La ragione strutturale che nessun parametro può cambiare
Il DAX alle 08:00 server ha un'**apertura vera**: cash chiuso tutta la notte, gap,
esplosione di liquidità in un istante. Il **NASUSD quota quasi 24 ore**: alle 14:30 arriva
più volume, ma il prezzo è in movimento da ore. **Il concetto stesso di "range d'apertura"
è più debole**, e questo è coerente con sei bocciature. Non chiude la porta, ma dice dove
NON cercare: non in un'altra sfumatura del range d'apertura.

### FASE M — cosa chiede, e i criteri dichiarati PRIMA
`RETEST` · `OPENING` · buffer 500 · offset 200 · gestione accesa · 1%.
Sweep: `InpAllowLong` × `InpAllowShort` × `InpRangeMinutes` {25, 35, 45} = **12 celle**,
48 pass su due simboli e due finestre.

**a) Il lato.** Gli indici hanno una deriva strutturale al rialzo: uno short sull'apertura la
combatte, un long ci va insieme. **È una domanda sulla natura dello strumento, non un
parametro da tarare** — e non è mai stata fatta su nessuno dei due simboli.

**b) Il 35 è un altopiano o un picco?** L'unica cella positiva del Nasdaq è `OPENING 35`
(+107,19 · PF 1,022). Se i vicini 25 e 45 sono negativi, è rumore.

**CRITERIO DI ACCETTAZIONE, scritto prima di guardare i numeri:**
1. la cella deve essere **positiva in TUTTE E DUE le finestre**, non solo fuori campione;
2. **PF ≥ 1,10** fuori campione;
3. **le celle vicine per range devono essere positive anche loro.**

**Se una sola delle tre non è soddisfatta, il Nasdaq d'apertura è chiuso.**

**Due controlli dentro la fase:**
- `AllowLong=0 + AllowShort=0` deve dare **ZERO trade**. Se ne desse, l'EA entra ignorando i
  filtri e tutta la tabella non vale niente.
- gira **anche sul DAX**, dove serve da controllo: il candidato validato è a due lati. Se il
  filtro migliorasse anche lui, abbiamo trovato qualcosa di vero sugli indici; se lo
  peggiora, il candidato regge ed è una conferma in più.

### Parcheggiato: l'ora della sessione
Testare se le 14:30 sono l'evento giusto (contro 15:30 / 16:30) richiede uno sweep **per
simbolo**: `InpSessionHour` sta nel blocco job (DAX 8, Nasdaq 14) e una fase condivisa lo
sovrascriverebbe su entrambi. **Serve un meccanismo che sappia il simbolo** prima di poterlo
fare.


## 07/08 07:06 — il rischio 0,25% è confermato, ma un parametro è tornato al default

### ✅ Confermato dal log
```
07:03:18  [Nasdaq Apertura US OTT]  rischio=0.25%
07:03:59  [Nasdaq Apertura US]      rischio=0.25%
```
E il DAX regge la configurazione validata: `RETEST | range 35 | buffer 500 | offset 200`.

### 🔴 A11. Il buffer di `Nasdaq Apertura US` è tornato da 300 a 200
```
06/08 19:17:56   buffer=300 pt
07/08 00:32:19   buffer=200 pt      <- 200 e' il DEFAULT nel codice
```
Il cambio è avvenuto nel giro di riavvii delle 00:30–00:34, non stamattina con il rischio.
**La spiegazione più probabile è un click su *Ripristina*** durante quel giro.

Sull'effetto pratico è irrilevante — quell'EA gira una configurazione già bocciata sei
volte, e adesso allo 0,25%. **Sul processo no**: un parametro sul grafico è cambiato senza
che nessuno lo volesse, e ce ne siamo accorti per caso confrontando due log a distanza di
un giorno.

### ✅ A12. `CONFIG IN USO` adesso stampa anche RANGE MODE e i LATI — 9 EA su 9
Il punto peggiore di A11 non è il buffer: è che **`InpRangeMode` non veniva stampato
affatto**. È il parametro che fuori campione vale **−2444 €** sul Nasdaq (FASE L), e non
avevamo modo di vedere dal log se fosse cambiato.

Aggiunti alla riga:
- `rangemode=` — il valore vero, come `EnumToString`;
- `lati=` — `long+short` / `SOLO LONG` / `SOLO SHORT` / `NESSUNO!`, che serve anche a
  leggere la FASE M in forward.

Verificato su tutti e 9: **segnaposto e argomenti allineati** (11 o 12 secondo la
generazione), graffe bilanciate. È lo stesso controllo che il 06/08 aveva pescato la patch
delle metriche prop applicata a metà su Nasdaq e Dow.

⚠️ Da ricompilare sul VPS insieme alle altre correzioni (breakeven su 20 EA).


## 07/08 — FASE M: il DAX va SOLO LONG, il Nasdaq è chiuso

Referto: [`REFERTO_FASE_M.md`](backtest_pipeline/risultati_archivio/Walkforward_Aperture/REFERTO_FASE_M.md)

### 🟢 D6. `SOLO LONG` sul DAX passa i tre criteri dichiarati prima
6 celle positive su 6. A range 35, fuori campione: **+1800,19 · PF 1,423 · DD 6,72%** contro
+1198,79 · 1,237 · 10,49% della configurazione accesa. **Resa/DD da 114 a 268.**
Meccanismo verificabile nei conteggi: SOLO LONG 256 trade, SOLO SHORT 243, insieme **316 e
non 499** — con `OneTradePerDay` lo short **si prende il posto** del long su ~183 giornate.

**DA FARE SUL VPS:** portare `ABTG_DAX_Apertura_EU_Ottimizzato` (magic diverso, stesso
grafico) alla configurazione `SOLO LONG`, lasciando `ABTG_DAX_Apertura_EU` a due lati come
**braccio di controllo**. Si ottiene un A/B in forward vero e si chiude anche A10
(`TRAIL_FIXED`). Esposizione su D30EUR invariata: resta 1%.

Parametri da mettere sull'`_Ottimizzato`:
`InpEntryMode=2 (RETEST)` · `InpRangeMode=0 (OPENING)` · `InpRangeMinutes=35` ·
`InpBufferPoints=500` · `InpRetestOffsetPts=200` · **`InpAllowShort=false`** ·
`InpTrailMode=1 (PREVBAR)` · `InpTrailTF=M5` · `InpRiskPercent=1.0`

### 🔴 D7. Nasdaq d'apertura: CHIUSO come ricerca — settima bocciatura
`SOLO LONG 35` è positiva solo fuori campione (+342,32 · PF 1,129): in campione fa −105,58
(criterio 1 ❌) e i vicini in OOS fanno −399,00 e −314,31 (criterio 3 ❌). Picco isolato.
Sul DAX la stessa riga è positiva **6 su 6**, sul Nasdaq **1 su 6**: la differenza fra
altopiano e rumore, vista nella stessa corsa.
**Resta allo 0,25% per raccogliere forward. Nessun altro test finché non c'è un'ipotesi
NUOVA e strutturale — non un'altra sfumatura del range d'apertura.**

### ⚠️ D8. La finestra OOS si sta consumando
Ci abbiamo guardato in **otto fasi**. Sta diventando una seconda finestra in campione, ed è
lo stesso meccanismo documentato oggi due volte. **Da qui in avanti le conferme si prendono
in forward**, non con altri backtest sulla stessa finestra. Se servirà un altro giudizio
pulito, va tagliata una terza finestra mai guardata.


### 🔴 A13. `InpAllowShort` con l'etichetta che dice il contrario — 07/08
Nei due `_Ottimizzato` d'apertura l'input era:
```
input bool InpAllowShort = false;   // OTT: SOLO LONG (validato real tick)
```
L'etichetta descriveva **cosa succede col default**, non cosa significa il valore. Nella
finestra dei parametri di MT5 si legge *«OTT: SOLO LONG»* con accanto `true`/`false`, e
sembra un interruttore da **accendere** per avere il solo long. **È l'opposto:**
`true` = short attivi, `false` = solo long.

Claudio ci è cascato mentre applicava la modifica di FASE M: sul grafico quel valore era
`true`, cioè short **accesi** su un EA che nel nome del parametro si dichiarava "solo long".

**Corretto in tutti e due i file:** ora l'etichetta è
`Consenti operazioni short (false = SOLO LONG)`.

**Regola:** l'etichetta di un input deve dire **cosa fa il valore**, mai cosa fa il default.
Chi legge la finestra dei parametri non vede il default: vede il valore corrente.

### ⚠️ A14. `ABTG_DAX_Apertura_EU_Ottimizzato` non può eseguire il candidato
Il suo enum dei motori ha **solo `BREAKOUT` e `GAPFILL`**: `RETEST` non esiste. È una copia
di generazione più vecchia, come `Apertura Marco`.
**Conseguenza: l'A/B in forward su due EA in parallelo non è possibile**, e la modifica
`SOLO LONG` va applicata direttamente su `ABTG_DAX_Apertura_EU` (dove l'input si chiama
`Consenti operazioni short`). Il confronto sarà **contro la misura**, non contro un secondo EA.
**Se si vuole l'A/B**, va portato il motore RETEST dentro l'`_Ottimizzato` — lavoro di codice,
da fare con calma e da testare prima.


## 07/08 sera — PTE: preparato tutto, da lanciare

Claudio chiede se la **PTE** può andare bene per una prop. **Risposta onesta: non lo
sappiamo.** Nell'export ci sono 1132 trade chiusi e **nessuno è della PTE**; in
`backtest_pipeline` non esiste una riga di risultati; un driver non c'era. Quello che si è
visto finora è il **profitto flottante** di una posizione aperta.

### Cosa ho verificato leggendo il codice
- ✅ **Il timeframe del GRAFICO non conta.** PTE usa `InpTF` in tutti e 16 i punti in cui
  tocca i dati, compreso il rilevamento della nuova barra (`iTime(_Symbol, InpTF, 0)`).
  Nessun `PERIOD_CURRENT`. Conta solo il **parametro** `TF operativo` (default H4).
- ✅ **BE e trailing sono cablati bene** (famiglia già corretta il 04/08): il breakeven si fa
  anche se la parziale non parte, e il trailing sull'EMA14 è condizionato a `beDone`.
- 🔴 **A 0,01 lotti la parziale non può partire** (50% del minimo sta sotto il minimo). E il
  dimensionamento produce proprio 0,01: rischio 1% ≈ 52 €, stop 41,17 $ ≈ 35 € per 0,01
  lotto → lotto ideale 0,0147 → arrotondato a 0,01. **Della gestione a tre pezzi ne funziona
  uno e mezzo.**
- 🔴 **Il breakeven ha un solo grilletto: il primo target = EMA14 sul TF operativo.** Su H4
  può stare lontanissima. Visto dal vivo il 06/08: short oro aperto alle 16:00, arrivato a
  **+22,29**, tornato a **+1,41 con lo stop ancora all'originale (4314.19)**. Non esiste un
  breakeven indipendente a N×R come sulle aperture (`InpBEatR`).

### ✅ Fatto: metriche prop aggiunte alla PTE
Il suo export aveva l'intestazione vecchia, **senza `Peggior Giornata %`** — cioè senza la
colonna che risponde alla domanda che ha fatto Claudio. Portate da `ABTG_DAX_Apertura_EU`:
`Peggior Giornata %`, `Perdite Consecutive Max`, `Serie Perdente Peggiore`.
L'aggiornamento dell'equity sta **prima** del filtro sulla nuova barra: su H4 una candela
dura quattro ore e la caduta peggiore di giornata succede in mezzo.
Verificato: **11 segnaposto = 11 argomenti = 11 colonne**, graffe bilanciate.

### ✅ Fatto: `backtest_pipeline/walkforward_pte.ps1`
**Ipotesi dichiarata nel file, prima dei numeri:** *il breakeven arriva troppo tardi perché
il primo target è la EMA14; avvicinarlo lo fa scattare prima e migliora la resa/DD senza
distruggere il profitto.* La leva è `InpTP1_ATRmult`, che esiste già.

Sweep: `InpTP1_ATRmult` {0 · 0,5 · 1,0 · 1,5} × `InpTF` {H1 · H2 · H3 · H4} = **16 celle**,
32 pass su due finestre. Verificato: 39 parametri pinnati, **nessun input libero**, nessun
duplicato, **nessuno sweep degenere**.

**CRITERIO DI ACCETTAZIONE, scritto in cima al file:**
1. positiva in **tutte e due** le finestre;
2. **PF ≥ 1,10** fuori campione;
3. **vicini positivi** — non un picco isolato;
4. **`Peggior Giornata %` sopra −2,5%** all'1% di rischio (una prop chiude a −5%: al 2% si
   sfonda).

### ⚠️ PREREQUISITO — da fare PRIMA di lanciare
**Non sappiamo da quando parte lo storico dell'oro su BCM.** Sugli indici i driver dicevano
`2024.01.01` e i dati partivano dal **26/09/2024**: metà finestra IS non esisteva. Misurarlo:
```
powershell -ExecutionPolicy Bypass -File .\scarica_storico.ps1 -Simboli "XAUUSD" -SoloReferto
```
e poi passare la data vera con `-DaQuando`. Il default nello script è una **ipotesi prudente
copiata dagli indici, non una misura**, e lo script lo dice a schermo prima di partire.
Questo chiude anche **B9**, aperto dal 05/08.
