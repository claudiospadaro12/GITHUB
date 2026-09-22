# 🎯 DOSSIER — ALZARE IL PROFIT FACTOR DEI SEI MOTORI IN CAMPO
**22/09/2026 · caccia ESTERNA · sola lettura: nessun EA toccato, nessun preset toccato, nessun forward toccato**

> **Richiesta di Claudio (22/09), testuale:** _"Dobbiamo alzare i profit factor dei nostri EA attuali. Trovate il modo x farlo."_
>
> **Quindi qui dentro NON ci sono strategie nuove.** Ci sono **meccanismi documentati
> fuori** che si innestano su **uno dei sei motori che abbiamo già**, con scritto
> accanto **quale manopola toccano** e **quanto costano in operazioni**.

---

## 🥇 LA RIGA CHE CONTA

**Su 19 meccanismi guardati su 7 fonti, 21 pagine aperte davvero, 8 letti nel
testo primario (paper intero, spec, o articolo col sorgente), 3 li proverei — e il
primo non è un meccanismo nuovo: è una CORREZIONE che ci impedisce di spendere
tempo macchina su un numero che l'autore ha ritirato.**

🔴 **La scoperta più cara della giornata non è un candidato: è che il nostro
dossier del 23/08 cita un T-statistic che NON ESISTE PIÙ.** Dettaglio in §2.
Costo di quella correzione: zero minuti. Valore: non costruire una sedia su
`T = 3,23` quando la versione corrente del paper dice `T = 1,46`.

---

## 🧪 § 1 — CONTROLLO POSITIVO, FONTE PER FONTE (fatto PRIMA di cercare)

| fonte | bersaglio del controllo | esito | uso |
|---|---|---|---|
| **arXiv q-fin.TR** | `arxiv.org/list/q-fin.TR/recent` deve mostrare titoli+autori+ID | ✅ **PASS** — 9 voci reali (es. `2609.23703` Kirtac, `2609.17788` Chionas et al.) | 🟢 usata a fondo (API + PDF) |
| **MQL5 Code Base** | `mql5.com/en/code/mt5/experts` deve elencare EA | ✅ **PASS** — 10 titoli (PropFirm Risk Guardian MT5, RegimeRouter, ...). ⚠️ **autori e date NON compaiono nell'elenco**: si prendono sulla pagina del singolo pezzo | 🟡 usata sugli **articoli** (che hanno autore+data+sorgente), non sull'elenco |
| **MQL5 Articles** | pagine `/en/articles/<id>` | ✅ **PASS** — 5 articoli aperti con autore e data | 🟢 usata a fondo |
| **QuantConnect** | `quantconnect.com/research/18444` | ✅ **PASS** — regole e numeri leggibili | 🟢 usata |
| **GitHub** | repo + `raw.githubusercontent.com` | ✅ **PASS** — letta la spec grezza | 🟢 usata |
| **TradingView** | pagina script `8vjWAdLN` | 🟡 **PASS PARZIALE** — descrizione e numeri sì, **il Pine NON l'ho letto** | 🟡 usata, dichiarata |
| **Quantpedia** | `quantpedia.com/strategies/` | ✅ **PASS** (10 titoli) · ma `?s=opening+range+breakout` → **nessun titolo mostrato** (solo la paginazione) | 🔴 **nulla sul nostro tema** |
| 🔴 **SSRN** | `papers.ssrn.com/.../4729284` e `/5095349.pdf` | ❌ **403 su pagina E su PDF** | 🛑 **FONTE NULLA** (come il 12/09) |
| 🔴 **11 domini** | vedi §7 | ❌ **bloccati dal proxy di rete** (`EGRESS_BLOCKED`) | 🛑 **FONTI NULLE, elencate per nome** |

⚠️ **404 ≠ 503 ≠ 403-di-proxy.** Le fonti qui sotto marcate `EGRESS_BLOCKED` **esistono**:
non le ho potute aprire io. Non sono state cancellate dal catalogo, sono in §7.

---

## 🔴 § 2 — LA CORREZIONE D'ARCHIVIO (leggila prima dei candidati)

**Il fatto.** Il nostro `report/SWEEP_MECCANISMI_2026-08-23.md` §4 (righe 280-310)
promuove *"Gap Continuation Short (Kalman v>2.5)"* citando **la v2** del paper di
Mesfin e scrivendo:

> _"**su quattordici famiglie è l'UNICA barra che supera T=2,0**, e cade solo sulla numerosità"_ — tabella nostra: **N=22 · netto +14,52 · T = +3,23 · win rate 68,2%**

**Oggi ho aperto la v3** (`arXiv:2605.04004v3`, **15/09/2026**, 17 pagine, PDF
estratto e letto, non l'abstract). Il campo *comments* della v3 dice, testuale:

> _"Revised: **corrected T-statistics to net-return basis**; updated London Signal B to walk-forward OOS figures (N=247, T=4.30); ... **year-stability tables updated to OOS years only**"_

E la Tabella 13 della v3 dice, testuale:

| famiglia | lordo (pt) | netto (pt) | **T-net** | N (OOS) | modo di fallimento |
|---|--:|--:|--:|--:|---|
| ORB Long (H=15) | +4,82 | +2,82 | **+0,88** | 447 | T < 2,0; instabile per anno |
| VVG Classifier Reversal | — | +13,49 | **+1,26** | 35 | T < 2,0; instabile per anno |
| **Gap Continuation Short** | **+16,53** | **+14,52** | 🔴 **+1,46** | **35 (~12/fold)** | **instabile 2024 (−11,87 netto)** + meno di 30 trade per fold |

E il §4.4 della v3, testuale: _"It fails on two criteria simultaneously: **2024
produces -11.87 net (year instability)**, and 35 total OOS trades spread across
three folds averages roughly 12 per fold."_

🔴 **Quindi: `T = 3,23` → `T = 1,46`, e il motivo del fallimento non è più solo
"campione sottile": è un ANNO INTERO IN PERDITA (2024).** Il nostro archivio lo
descriveva come *"il caduto ingiusto"*. Con la v3 in mano non lo è più: è un
candidato **a due criteri dal passare**, non a uno.

✅ **Cosa NON cambia:** la citazione che usiamo in `REGISTRO_TEST.md` r.1517
(_"a two-point round-trip transaction cost..."_) regge: la v3 conferma il
**pavimento di attrito a 2,0 punti su MNQ** e che **11 famiglie su 14** muoiono lì
sotto (lordo 0,07-1,50 punti).

📌 **Azione, e costa zero:** aggiornare la riga del 23/08 con i numeri v3 prima
che qualcuno costruisca una sedia sul `3,23`. Non l'ho fatto io: **non tocco
referti di altri round senza firma.**

---

## 📋 § 3 — TABELLA DEI CANDIDATI

**Legenda verdetti:** 🟢 `PROVA SUBITO` · 🟡 `IN CODA` · ⚪ `[SENZA NUMERI] — in fondo` · 🔴 `SCARTO`

| # | meccanismo | su quale sedia si innesta | manopola / codice | numero pubblicato | fonte (URL · autore · data) | bandiere rosse | verdetto |
|---|---|---|---|---|---|---|---|
| **1** | **LA PRESA LUNGA** — sull'ORB il netto arriva solo con **60-75 minuti** di tenuta; a una barra è negativo | `770101` DAX · `770202` Dow · `770260` Nasdaq (tutte M5) | `InpTP1_ClosePct` · `InpBreakevenAtTP1` · `InpBEatR` · `InpTrailStartR` (**tutte manopole esistenti, 0 righe di codice**) | **ORB Long bar+1 netto −0,82 pt** → **bar+15 netto +2,82 pt** (N=447 OOS). E §6.2: _"the longer hold period accumulates enough net return to clear friction before the edge reverts"_ | [arXiv 2605.04004v3](https://arxiv.org/abs/2605.04004) · Mathias Mesfin · v3 **15/09/2026** · **PDF letto** | nessuna | 🟢 **PROVA SUBITO** |
| **2** | **LA PARZIALE DIPENDE DALLA LARGHEZZA DEL BERSAGLIO** — aiuta sui target larghi, **fa male sui target stretti** (commissioni + taglio della coda) | tutte e sei, ma decide su `770101` (stretto) contro `771531`/`770511` (largo) | `InpTP1_ClosePct` / `InpTP1Pct` | **target larghi: 33.000 $ con parziali contro 22.234 $ senza** (+11.000 $). **Target stretti: ~4.000 $ PEGGIO con le parziali** · XAUUSD M5, 01.01.2024-22.09.2025 | [MQL5 art. 19682](https://www.mql5.com/en/articles/19682) · Niquel Mendoza · **12/06/2026** · sorgente incluso | nessuna | 🟢 **PROVA SUBITO** (conferma esterna di una cella già nostra) |
| **3** | **BANCO DI PROVA DELLE USCITE SULLE OPERAZIONI VERE** — si rigiocano **gli stessi ingressi** cambiando solo il trailing | tutte e sei · **zero operazioni tagliate** | nessuna manopola: è un **attrezzo di misura** (EA di replay) | **stesse operazioni, 9 coppie, 222-526 deal**: originale **−658 $** · trailing semplice **−746,1 $** · Parabolic SAR **+541,8 $** · **DEMA +1.397,1 $** | [MQL5 art. 16991](https://www.mql5.com/en/articles/16991) · Artyom Trishkin · **06/10/2025** · 5 file di sorgente inclusi | nessuna (⚠️ è ottimizzazione IN campione sulle uscite: vedi §4.3) | 🟢 **PROVA SUBITO** |
| 4 | **BREAKEVEN IN R, MAI IN PUNTI FISSI** — e più tardi è meglio | `770101` (R201a) · `770202` (R172d) · `770260` (fatto, R199A) | `InpBEatR` contro un BE a punti | **senza BE 15.800 $ · BE a punti fissi (200 pt) 12.000 $ (−24%)** · RRR 1:3 meglio di 1:2 · XAUUSD M5 tick reali | [MQL5 art. 18111](https://www.mql5.com/en/articles/18111) · Niquel Mendoza · **08/06/2026** · sorgente incluso | nessuna | 🟡 **IN CODA — e sposta in cima due round GIÀ SCRITTI** (`R201a`, `R172d`) |
| 5 | **RVOL A PARI ORA DEL GIORNO** — il volume della rottura si confronta col volume **alla stessa ora nelle N sedute precedenti**, non con le 20 barre prima | `770101`/`770202`/`770260` | 🔴 **riscrittura di `VolumeOKtf()`** (`ABTG_DAX_Apertura_EU.mq5` r.2703-2716) | Sharpe **2,396** contro **0,836** del buy&hold SPY (backtest 2016) | [QuantConnect 18444](https://www.quantconnect.com/research/18444/opening-range-breakout-for-stocks-in-play/) · Derek Melchin · su paper Zarattini-Barbon-Aziz **16/02/2024** | nessuna | 🟡 **IN CODA** — costo: ~3 h di codice + ricompilazione |
| 6 | **GEOMETRIA NORMALIZZATA SULLA LARGHEZZA DEL RANGE** — buffer, profondità di retest, invalidazione e filtro d'ampiezza espressi in **frazioni di W** e di ATR giornaliero, non in punti | `770101`/`770202`/`770260` | `InpBufferPoints` · `InpRetestOffsetPts` · `InpMinRangePts`/`InpMaxRangePts` (oggi **tutti in PUNTI**) | ⚪ **[SENZA NUMERI]** — soglie precise (`0,08 ≤ W/ATR ≤ 0,35`; `b = max(2 tick; 0,05·W)`; retest `0,12·W`; invalidazione `0,15·W`; stop tra 8 e 48 tick; target `1,75×`) ma il repo dichiara _"research prototype, not a profitability claim"_ | [github crispysizzlin/strategy-test](https://github.com/crispysizzlin/strategy-test) · spec grezza letta · licenza **[INCERTO]**, non dichiarata | nessuna | 🟡 **IN CODA** — la **motivazione** è forte (§4 nota), il numero manca |
| 7 | **STOP COME % DELLA LARGHEZZA DEL RANGE** (default 50% di W) + **ampiezza minima in % del PREZZO** (0,35%) + **reverse on stop** | `770101`/`770202`/`770260` (`InpAllowReverse` esiste già, default `false`) | `InpSLMode` · `InpMinRangePts` · `InpAllowReverse` | **PF 1,178 · 50,91% vincenti · P&L 154.141,18 $ · DD max 18.624,36 $** (simbolo/periodo **non dichiarati**) | [TradingView `8vjWAdLN`](https://www.tradingview.com/script/8vjWAdLN-Opening-Range-Breakout/) · fabledforman · **30/07/2025** · open source (**Pine NON letto**) | ⚠️ numeri su **una sola sequenza**, senza costi dichiarati, simbolo ignoto | 🟡 **IN CODA, in fondo** |
| 8 | **CANCELLO DI TREND SULLA MEDIA LUNGA DEL TF OPERATIVO** (MA 350 su M5) | `770101`/`770202`/`770260` | `InpUseEmaFilter` + `InpEmaSlow=350` + `InpFilterTF=PERIOD_CURRENT` (**manopole esistenti**) | **PF 1,23 · Sharpe 2,81 · DD 18%** (rischio 2%/trade) | [MQL5 art. 17745](https://www.mql5.com/en/articles/17745) · Zhuo Kai Chen · **16/04/2025** · sorgente `ORB1.mq5` incluso | ⚠️ **DD 18% e rischio 2%**: fuori dai muri prop. ⚠️ è **un filtro appiccicato a un motore già tarato** → 0 successi su 5 in casa | 🟡 **IN CODA, con riserva scritta** |
| 9 | **TRAILING SU VWAP DI SESSIONE** invece che su barra/ATR | `770101`/`770202`/`770260` | 🔴 nuovo modo in `ENUM_ABTG_TRAIL` | **PF 1,3 · Sharpe 5,9** (rischio **4%**/trade) | MQL5 art. 17745 (stessa fonte, "Concretum Bands") · Zhuo Kai Chen · 16/04/2025 | 🔴 **rischio 4%**: Sharpe 5,9 su M1 con quel rischio **non è confrontabile** con niente di nostro | 🟡 **IN CODA, ultimo** |
| 10 | **STOP TEMPORALE** (chiudi dopo N minuti se non è successo niente) | `770101`/`770202`/`770260` | 🔴 **non esiste**: abbiamo `InpPendingExpiryMin` (pendenti) e `InpCloseHour` (flat), **non un time-stop sulla POSIZIONE** | ⚪ **[SENZA NUMERI]** — la spec dice "45-minute time stop", senza misurarne l'effetto | github crispysizzlin/strategy-test · spec letta | nessuna | ⚪ **[SENZA NUMERI]** |
| 11 | **FINESTRA ORARIA DEL SEGNALE** (solo 09:45-11:30 ET) | `770101`/`770202`/`770260` · `770511` (`InpUseTimeWindow` esiste, default `false`) | `InpStartHour`/`InpEndHour` | ⚪ **[SENZA NUMERI]** nella spec letta | github crispysizzlin/strategy-test | nessuna | ⚪ **[SENZA NUMERI]** |
| 12 | **STOP = 0,1 × ATR(14) GIORNALIERO, niente target, flat alla campanella** | `770101`/`770202`/`770260` | `InpSLMode=ABTG_SL_ATR` + `InpAtrSlMult` (ma il nostro ATR è sul TF di gestione, non giornaliero) | win rate **<30%**, R/R **~1:4**, **99 operazioni in 17 mesi** (PLTR, prova singola) | [MQL5 art. 23226](https://www.mql5.com/en/articles/23226) · Jocimar Lopes · **06/07/2026** · `ORB_Expert.mq5` incluso | ⚠️ prova su **UN titolo**; il "Sharpe 2,81 / 1.637%" citato è **della ricerca SFI, non del suo backtest** | 🟡 **IN CODA** |
| 13 | **NON ENTRARE ALLA CHIUSURA DELLA BARRA DI ROTTURA** — il movimento è già consumato dentro la barra | `770411` MaxMin notte · e contro `OPENCONFIRM`/filtro volume delle aperture | scelta fra pendente piazzato **prima** (quello che già facciamo) e conferma a barra chiusa | **apertura→apertura successiva: +32,24 punti** nel verso dell'espansione · **chiusura→apertura successiva: −0,17 punti**. E continuazione a bar+1: **T = −11,52** | arXiv 2605.04004v3 §4.2, Mesfin · PDF letto | ⚠️ misurato su **sessione Asia di MNQ**, non su DAX notte M15 | 🟡 **IN CODA** — è una **conferma** del nostro disegno, non un cambio |
| 14 | ORB **SHORT** su Nasdaq | `770260` | — | **negativo a TUTTE E DUE le tenute** (N=428 OOS per tenuta). I due netti sono **−3,45** e **−2,16**; 🔴 **quale dei due sia bar+1 e quale bar+15 è [INCERTO]**: l'estrazione del PDF non separa le colonne in modo sicuro e la prosa non lo ripete | arXiv 2605.04004v3 Tab. 4 | — | 🔴 **niente da innestare: è un avvertimento**, e spiega il DD OOS del lato short |
| 15 | Ingresso **su pullback** dell'ORB con **stop fisso** | `770101`/`770202`/`770260` | — | **N=83** e **80,7% di stop-out con stop FISSO a 20 punti** (prosa §4.1, verbatim). Netto e T: **[INCERTO]** — la tabella li dà, ma l'estrazione del PDF non separa le colonne in modo sicuro | arXiv 2605.04004v3 §4.1 | — | 🔴 **SCARTO come proposta, 🟢 come lezione**: vedi §5bis |
| 16 | **GMM su regimi** (RTH Confluence / London Signal B) | — | — | T=**3,11** (N=196) e T=**4,30** (N=247, p=0,000025) | arXiv 2605.04004v3 §5, App. A | 🔴 **un ritardo di UNA barra ribalta T da +4,30 a −2,78** | 🔴 **SCARTO**: non portabile in MQL5 senza librerie, e fragilità d'esecuzione dichiarata |
| 17 | **Livelli ottimi di TP/SL in forma chiusa** (processi di Ornstein-Uhlenbeck, metodo dei potenziali termici) | `771531` EMA200 (rimbalzo = ritorno a un livello) | `InpTP_RR` / `InpSLatr` | ⚪ **[SENZA NUMERI]** nell'abstract: nessuna tabella numerica | [arXiv 2003.10502](https://arxiv.org/abs/2003.10502) · Lipton & Lopez de Prado · **23/03/2020** · abstract letto | — | ⚪ **[SENZA NUMERI]** — cultura, costo di porting alto |
| 18 | **Regole di stop-loss di portafoglio** | — | — | _"50 to 100 basis points per month"_ su dati **mensili** 1950-2004 | Kaminski & Lo (trovato in ricerca, **PDF non aperto**: SSRN 403) | — | 🔴 **FUORI MANDATO**: orizzonte mensile di portafoglio, non uno stop intraday |
| 19 | **Exit strategies per l'intraday momentum** (il titolo più on-target trovato) | `770260` | — | 🔴 **NON LETTO** | [SSRN 5095349](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=5095349) · Ákos Maróy · 12/01/2025 | — | 🛑 **NON VALUTABILE — SSRN 403 su pagina e su PDF** |

---

## 🥇 § 4 — I TRE MIGLIORI, SVILUPPATI

### 4.1 🥇 CANDIDATO 1 — **LA PRESA LUNGA**: l'edge dell'ORB matura in 60-75 minuti

```
NOME            Hold-horizon dell'Opening Range Breakout (§4.1 + §6.2)
FONTE / URL     https://arxiv.org/abs/2605.04004   (v3, 15/09/2026, 17 pagine)
AUTORE / DATA   Mathias Mesfin, Independent Researcher · v1 05/05/2026 · v3 15/09/2026
LETTO           🟢 PDF INTERO, testo estratto (non solo l'abstract)
CAMPIONE        MNQ continuo, 72.604 barre M5, RTH 09:30-16:00 ET, dic-2021 → ago-2025,
                947 sedute complete, walk-forward a finestra espansa, attrito 2,0 punti
```

**TESI IN UNA RIGA**
> _"L'ORB guadagna perché l'ordine sbilanciato dell'apertura si smaltisce in un'ora
> abbondante: chi esce prima paga l'attrito e non incassa il movimento."_

**I NUMERI, testuali dalla Tabella 4 della v3** _[dichiarati dall'autore, NON verificati da noi]_:

| variante | N (OOS) | netto (pt) | T-net | 2023 | 2024 | 2025 (parziale) |
|---|--:|--:|--:|--:|--:|--:|
| ORB Long — **bar+1** (5 min) | 447 | **−0,82** | −0,82 | −2,11 | −1,54 | +6,11 |
| ORB Long — **bar+15** (75 min) | 447 | **+2,82** | +0,88 | +2,43 | +7,04 | +15,05 |

E il §6.2, testuale: _"the two positive controls exist outside this ceiling because
they use GMM regime classification **and hold positions for 60 to 75 minutes** ...
**the longer hold period accumulates enough net return to clear friction before the
edge reverts**."_

**PERCHÉ DOVREBBE ALZARE IL NOSTRO PF, e su quale manopola**
Le nostre tre aperture M5 hanno tutta la macchina che **accorcia** la presa:
`InpTP1_ClosePct=50` a 1R, `InpBreakevenAtTP1=true`, `InpUseTrailing=true` con
`InpTrailStartR=0` (arma **subito**). Se l'edge matura a 75 minuti, ognuno di quei
tre interruttori è una tassa.

🟢 **E in casa il primo pezzo è GIÀ MISURATO, e concorda**: `770101`
`InpTP1_ClosePct` **50 → 0** dà **PF OOS 1,39709 → 1,49140** e **DD OOS 7,2328% →
6,2719%**, con il DD **anche in valuta** in discesa (8.886 → 7.974) —
`report/CELLE_MIGLIORI_GIA_MISURATE_2026-09-21.md` §2A.
👉 **Questo candidato non chiede di scoprire qualcosa: chiede di FIRMARE una cosa
misurata, e aggiunge la ragione di mercato che finora mancava.**

**COSA MISUREREMMO PER FALSIFICARLO** (e deve poter dire di no)
1. 📏 **La durata media di una nostra operazione vincente contro una perdente**, in
   minuti, sulle tre aperture. Se le vincenti durano già 60-75', la tesi **non ha
   niente da correggere qui** e il candidato muore.
2. 🔬 **Asse `InpTrailStartR` 0 / 0,5 / 1,0 / 1,5** a parziale SPENTA, in IS+OOS.
   Se il PF **non** sale monotòno con la soglia, la tesi della presa lunga è falsa
   su di noi. ⚠️ **Contro-esempio già in archivio**: su `770260` il round `R200b` è
   stato RITIRATO perché l'archivio mostrava il **DD che sale in 5 righe su 5**
   alzando `InpTrailStartR`. 🔴 **Quindi la tesi ha già un dato contro sul Nasdaq**,
   e va detto prima, non dopo.
3. ⏱️ **Ora di chiusura**: nel sorgente il default è `ABTG_DEF_CLOSE_HOUR 17` (server)
   → la presa lunga **è già possibile per costruzione**. ⚠️ **[DA VERIFICARE sul preset
   FTMO che vola**, non sul sorgente: quel preset porta `InpSessionHour=10` (orologio
   FTMO) e quindi anche l'ora di chiusura può non essere 17.** Se la durata media delle
   vincenti è corta, la colpa è della gestione; se è corta perché si chiude presto, è
   dell'orario, ed è un'altra manopola.

**COSTO IN OPERAZIONI:** 🟢 **ZERO**. Non taglia nessun ingresso: cambia solo dove
si esce. Il pavimento di frequenza per famiglia (firma 07/09) **non è toccato**.

**🏛️ IN OTTICA PROP:** ⚠️ **è la riga scomoda.** Tenere aperto più a lungo **alza
l'escursione avversa per operazione** e quindi mette più pressione sul muro
**giornaliero del 5%** (−5.000 € su 100k), non solo su quello totale. La nostra
peggior giornata misurata è **−2,06%** (R51). E il 22/09 abbiamo misurato che sul
primo stop vero della challenge la perdita reale ha superato il modello del
**+10,5%** (`report/PRIMO_STOP_FTMO_2026-09-22.md`). 👉 **Il guadagno in PF qui è +6,7%** (1,39709 → 1,49140).
🔴 **E le due percentuali NON sono la stessa unità** — una è un rapporto di PF, l'altra
è l'eccesso di perdita su un singolo stop: metterle a confronto è un'analogia, non
un conto. Ma il criterio 4 della commessa chiede di dichiararlo, e lo dichiaro: **un
miglioramento del 6,7% su una grandezza stimata vive nello stesso ordine di grandezza
dell'errore d'esecuzione che abbiamo appena misurato.** Va detto chiaro: **il PF da
solo non basta a firmarlo; la ragione per firmarlo è che il DD scende INSIEME al PF —
in percentuale E in valuta — e il DD è un fatto accaduto, non una stima.**

---

### 4.2 🥈 CANDIDATO 2 — **LA PARZIALE NON È UNA VIRTÙ: DIPENDE DA QUANTO È LARGO IL BERSAGLIO**

```
NOME            "Implementing Partial Position Closing in MQL5"
FONTE / URL     https://www.mql5.com/en/articles/19682
AUTORE / DATA   Niquel Mendoza · 12/06/2026
LETTO           🟢 articolo aperto · sorgente pubblicato (MQL Algo Forge)
MECCANICA       chiusure scaglionate al 25/45/65% della distanza ingresso→TP, 30% del volume ognuna
```

**TESI IN UNA RIGA**
> _"La parziale compra tranquillità pagandola in commissioni e in coda troncata:
> conviene quando il bersaglio è largo abbastanza da ripagare il pedaggio."_

**I NUMERI** _[dichiarati dall'autore, NON verificati]_ — Gold M5, 01.01.2024 → 22.09.2025:

| impianto | con parziali | senza parziali | differenza |
|---|--:|--:|--:|
| **bersaglio LARGO (swing)** | **~33.000 $** | ~22.234 $ | 🟢 **+11.000 $ a favore delle parziali** |
| **bersaglio STRETTO (scalping)** | più basso | **~4.000 $ in più** | 🔴 **a favore del NIENTE parziali** |

**PERCHÉ ALZA IL PF E SU QUALE MANOPOLA**
È **la regola che spiega una nostra anomalia già misurata e mai motivata**:

| sedia | bersaglio | cosa dice l'archivio nostro |
|---|---|---|
| `770101` DAX M5 (stop = range, TP1 a 1R) | **stretto** | 🟢 togliere la parziale **ALZA** il PF (1,397 → 1,491) |
| `770202` Dow M5 | **stretto** | 🔴 `REGISTRO_TEST.md` r.2441: _"sul Dow il parziale SERVE, al contrario del DAX"_ |
| `771531` EMA200 H1 (TP 2R) · `770511` SuperWave H1 (TP 2R) | **largo** | parziale accesa, e le due sedie con PF più alto del gruppo |

🔴 **E qui c'è il contro-esempio che mi sono costruito, ed è quello che conta:
il Dow SMENTISCE la regola** (bersaglio stretto, ma la parziale serve). Quindi
la regola dell'autore **non è una legge**: è **un'ipotesi con un discriminante
misurabile**, e il discriminante non è "stretto/largo" a occhio ma
**`larghezza del bersaglio ÷ costo di andata e ritorno`**.

**COSA MISUREREMMO PER FALSIFICARLO**
1. 📐 Calcolare, per ognuna delle sei sedie, **`TP1 in valuta ÷ (spread+commissioni+slippaggio) di un giro`**.
   Se le sedie in cui la parziale aiuta hanno rapporto alto e quelle in cui fa male
   rapporto basso, la regola regge **e diventa un cancello**, non un'opinione.
2. 🧪 Se il Dow resta l'eccezione anche col rapporto calcolato, **la regola è falsa
   per noi** e il candidato va archiviato con il suo numero.

**COSTO IN OPERAZIONI:** 🟢 **ZERO** (è gestione d'uscita).
**🏛️ IN OTTICA PROP:** 🟢 **favorevole**: sulla `770101` togliendo la parziale il DD
OOS scende **in percentuale E in valuta**. È l'unico dei tre candidati che migliora
il muro e il PF nello stesso movimento.

---

### 4.3 🥉 CANDIDATO 3 — **IL BANCO DI PROVA DELLE USCITE SULLE NOSTRE OPERAZIONI VERE**

```
NOME            "Post-Factum trading analysis: Selecting trailing stops and new stop
                levels in the strategy tester"
FONTE / URL     https://www.mql5.com/en/articles/16991
AUTORE / DATA   Artyom Trishkin · 06/10/2025
LETTO           🟢 articolo aperto · 5 file di sorgente inclusi (`TradingByHistoryDeals_Ext.mq5`)
MECCANICA       prende lo STORICO DEAL di un conto vero, lo rigioca nel tester e applica
                trailing DIVERSI alle STESSE operazioni
```

**TESI IN UNA RIGA**
> _"Gli ingressi sono una cosa e le uscite un'altra: si possono misurare le seconde
> senza rimettere in discussione i primi."_

**I NUMERI** _[dichiarati dall'autore, NON verificati]_ — 9 coppie, 222-526 deal ciascuna:

| gestione applicata alle **stesse** operazioni | risultato |
|---|--:|
| trading originale | **−658 $** |
| trailing semplice | −746,1 $ |
| trailing su Parabolic SAR | **+541,8 $** |
| **trailing su DEMA** | 🟢 **+1.397,1 $** |

**PERCHÉ È IL CANDIDATO CHE COSTA MENO DI TUTTI**
Il nostro `REGISTRO_TEST.md` (21/09) dice già, misurato in casa:
> 🔴 _"**`InpTrailMode` è la leva più grande mai misurata sul DD di questo EA**:
> stesse operazioni, stesso PF, DD da **17,65%** a **7,17%**"_

👉 **Due misure indipendenti — una nostra, una di fuori — dicono che la manopola
dell'uscita muove più di qualunque filtro d'ingresso, a ingressi invariati.**
E questo attrezzo la misura **senza tagliare una sola operazione**: nel mese in cui
la frequenza è un vincolo di challenge, è l'unica famiglia di miglioria che non
costa niente al pavimento del 07/09.

**COSA MISUREREMMO PER FALSIFICARLO**
1. 🧪 **Il contro-esempio obbligatorio: è ottimizzazione IN CAMPIONE.** Scegliere il
   trailing migliore su operazioni già avvenute è esattamente il modo in cui si
   compra rumore. 👉 **La prova valida è: scegliere il trailing sulla finestra IS e
   verificarlo sulla OOS**, con la nostra regola di sempre — **centro dell'altopiano,
   mai la cella migliore** (12 Spearman IS→OOS negative su 13).
2. 📏 Se il trailing scelto in IS **non** regge in OOS su almeno 2 sedie su 3,
   l'attrezzo va usato solo come **diagnostica**, mai come selettore.

**COSTO IN OPERAZIONI:** 🟢 **ZERO**.
**🏛️ IN OTTICA PROP:** 🟢 **il più favorevole dei tre.** Agisce sul DD — che è il
muro — a frequenza invariata. ⚠️ **Ma attenzione al DD TRAILING**: un trailing che
allunga le vincenti crea curve a scalini con lunghi ritorni dal picco, ed è proprio
la forma che le prop col DD che insegue l'equity puniscono (le nostre Monte Carlo
sono tutte su DD **statico**).

---

## 🪦 § 5 — GLI SCARTI, una riga di motivo a testa

| meccanismo | perché fuori |
|---|---|
| GMM su regimi (RTH Confluence, London Signal B) | non portabile in MQL5 senza librerie esterne, e **un ritardo di 15 minuti ribalta T da +4,30 a −2,78**: fragilità d'esecuzione dichiarata dall'autore stesso |
| ORB **short** Nasdaq | negativo a tutte e due le tenute (netti −3,45 e −2,16, N=428): non è un innesto, è un avvertimento |
| Ingresso su pullback con **stop fisso** | **80,7% di stop-out** con stop FISSO a 20 punti, N=83. 🟢 **Ma la lezione è a NOSTRO favore**: il nostro retest NON ha lo stop fisso, ce l'ha **strutturale** (`InpSLMode=ABTG_SL_RANGE`, estremo opposto del range). La bocciatura dell'autore colpisce la SUA geometria, non la nostra — e R197A sul Dow ha misurato il contrario (retest > breakout) |
| Kaminski & Lo, regole di stop-loss | orizzonte **mensile di portafoglio**: non si innesta su uno stop intraday. E il PDF non l'ho aperto (SSRN 403) |
| Lipton & Lopez de Prado, TP/SL in forma chiusa | nessun numero nell'abstract, processo OU (market making), costo di porting fuori scala per il 1° ottobre |
| Quantpedia | il motore di ricerca del sito **non restituisce nulla** su "opening range breakout": niente da setacciare |
| Tutto ciò che è `/market/` e `/signals/` di MQL5 | perimetro chiuso in modo permanente: **senza sorgente il setaccio non è applicabile** |

🔴 **Nessun candidato è stato scartato per martingala, griglia, mediazione, assenza
di stop, repaint o DLL.** Non perché non ce ne siano in giro: perché ho cercato
**meccanismi di gestione e di filtro**, non EA completi, e quel tipo di marciume sta
negli EA completi.

---

## 🟢 § 5bis — LA LEZIONE CHE VALE PIÙ DI UN CANDIDATO: perché il nostro retest NON è quello bocciato

Il §4.1 di Mesfin boccia l'**ingresso su pullback** dell'ORB con una frase secca:

> _"The pullback entry is more straightforwardly bad: **an 80.7% stop-out rate at a
> 20-point stop** means the signal is predominantly identifying **reversals of
> breakout attempts**, not continuations."_ (N = 83)

🔴 **A prima vista questa riga boccia TRE nostre sedie su sei**, perché `770101`,
`770202` e `770260` girano tutte in `InpEntryMode = ABTG_RETEST`.

🟢 **Ma non le boccia, e il motivo sta in una sola differenza di geometria:**

| | Mesfin §4.1 | le nostre tre aperture |
|---|---|---|
| dove si entra | pullback dopo la rottura | **limite sul livello**, `InpRetestOffsetPts` **dentro** il livello |
| **dove sta lo stop** | 🔴 **fisso, 20 punti** | 🟢 **strutturale**: `InpSLMode = ABTG_SL_RANGE`, cioè **l'estremo OPPOSTO del range** (`ABTG_DAX_Apertura_EU.mq5` r.1931) |
| conseguenza | **80,7% di stop-out**: lo stop sta dentro il rumore del rientro | lo stop sta **oltre** la struttura che ha generato il segnale |

👉 **E in casa la prova contraria è già misurata**: round **R197A** (21/09, Dow
`770202`) — _"retest confermato: costa il 15-20% degli ingressi e li ripaga. **Col
breakout l'IS va in perdita**"_.

🎯 **Quindi la lettura giusta non è "il retest non funziona": è "il retest con lo
stop FISSO non funziona".** È la stessa lezione della regola di casa **R55**
(_lo spread si misura in percentuale dello stop, non in punti_) e del pavimento di
stop del collega (`PS5_ORB_MASTER_LETTURA_2026-09-10.md`: portare il pavimento a 20
punti fa crollare il DAX da PF 2,40 a 1,26). **Tre fonti indipendenti, stessa
conclusione: sugli ingressi di rientro, lo stop in PUNTI FISSI è il difetto.**

⚠️ **E il rovescio, che va scritto perché è scomodo:** il nostro `InpMinStopPts`
(pavimento di stop in punti) e il nostro `InpBufferPoints` **sono in punti fissi**.
Su di loro questa lezione morde **contro di noi**, ed è la radice del candidato 6.

---

## 🕳️ § 6 — LA LISTA DEI CADUTI, passata prima di entrare

| candidato | c'è già in `REGISTRO_TEST.md` / referti? |
|---|---|
| Mesfin 2605.04004 | 🟡 **SÌ, ma la v2** — `REGISTRO_TEST.md` r.1517 e `SWEEP_MECCANISMI_2026-08-23.md` r.289. **La v3 cambia i numeri**: §2 |
| Zhuo Kai Chen (MQL5) | 🟡 **autore già noto** (art. **16752**, citato in `report/coach_paolo/NEWS_BREAKOUT_OCO_NFP_2026-09-03.md` r.518). **L'articolo 17745 è nuovo** |
| `InpUseVolumeFilter` | 🟢 **già misurato**: su `770101` 0→1 porta PF OOS 1,4152 → 1,5384 **ma taglia il 61% delle operazioni** (`CELLE_MIGLIORI_GIA_MISURATE_2026-09-21.md` r.280). 👉 il candidato 5 attacca **il perché** taglia tanto |
| `InpBEatR` | 🟢 **già misurato su Nasdaq** (R199A: 0,5 domina) e **già in coda** su DAX (`R201a`) e Dow (`R172d`) |
| `InpTrailStartR` | 🔴 **round R200b RITIRATO il 21/09**: archivio già mostrava DD in salita 5 righe su 5 |
| `InpRetestOffsetPts` | 🟢 già girato (R197B Dow: 400 confermato · R198 Nasdaq: IS e OOS **opposti**) |
| Trishkin, Mendoza, Mesfin-v3, fabledforman, crispysizzlin | ⚪ **nessuna occorrenza nel repo**: sono nuovi |

---

## 🚧 § 7 — COSA NON HO POTUTO VEDERE, per nome

**🛑 FONTE NULLA — 403 su pagina e su PDF:**
- `papers.ssrn.com` — `abstract_id=4729284` (Zarattini-Barbon-Aziz, il paper madre dell'ORB) · `abstract_id=5095349` (**Maróy, "Improvements to Intraday Momentum Strategies Using Parameter Optimization and Different Exit Strategies"** — 🔴 **il titolo più on-mandate di tutta la caccia**) · `abstract_id=4416622` · `abstract_id=968338`.
  👉 **Stessa diagnosi del 12/09** (`CACCIA_TF_BASSO_2026-09-12.md` r.334). SSRN è nulla da qui, e va messo in conto.

**🛑 BLOCCATI DAL PROXY DI RETE (`EGRESS_BLOCKED`) — esistono, non li ho aperti io:**
| dominio | cosa c'era | perché fa male |
|---|---|---|
| `alexandria.unisg.ch` | i PDF **liberi** dei paper Zarattini (SFI 24-97) | è il modo gratuito di leggere il paper che SSRN nega |
| `trading-edge.app` | *"I backtested the DAX overnight-range break over 4 years"* | 🔴 **era la sola misura trovata sull'inefficienza della `770411`** |
| `fxvps.biz` | *"The DAX Opening-Range Breakout: What 14 Years of Data Actually Show"* — la ricerca riportava **PF 1,20-1,27** e un confronto fra uscita alle 11:00 e alla chiusura | 🔴 era il confronto d'uscita **sul nostro simbolo** |
| `tosindicators.com` | banco di prova "moving average pullback": conferma contro ingresso cieco al variare della lunghezza della media | 🔴 era il pezzo per la **`771531` EMA200** |
| `www.quantitativo.com` · `newsletter.huntgathertrade.com` | repliche con tabelle dell'intraday momentum | confronti fra varianti |
| `www.quantifiedstrategies.com` · `ideas.repec.org` · `www.researchgate.net` · `www.wealth-lab.com` · `api.semanticscholar.org` (CONNECT 403) | backtest ORB e paper accademico Umeå | — |

**🟡 APERTO MA NON LETTO NEL SORGENTE:**
- Il **Pine** dello script TradingView `8vjWAdLN`: ho letto descrizione e numeri, **non il codice**. Quindi su quel candidato **non posso escludere repaint/`calc_on_every_tick`**, e infatti sta in fondo.
- Il **`.cs`/`.py`** del repo `crispysizzlin/strategy-test`: ho letto **la spec** (`docs/strategy-spec.md`, grezza), non l'implementazione. **Licenza non dichiarata → [INCERTO]**.

**🟠 BUCHI DEL NOSTRO PORTAFOGLIO CHE NON HO POTUTO RIEMPIRE:**
- 🔴 **`770411` MaxMin notte DAX Short (PF 2,160, il più alto che abbiamo): ZERO
  candidati.** L'unico materiale numerico trovato era su `trading-edge.app`, bloccato.
  La cosa più vicina è il §4.2 di Mesfin, ma è **sessione Asia su MNQ**, non notte DAX.
- 🟠 **`771531` EMA200 e `770511` SuperWave: nessun candidato con NUMERI.** Il pezzo
  buono (tosindicators) era bloccato. I candidati 2 e 3 li toccano perché sono
  meccanismi generali di gestione, ma **non ho trovato una sola misura pubblicata sul
  rimbalzo su media lunga o su Supertrend che isoli l'incremento**.

---

## ❓ § 8 — LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> 🎯 **"Le nostre operazioni vincenti sulle tre aperture M5 durano già 60-75 minuti,
> oppure la nostra macchina d'uscita le taglia prima che l'edge sia maturato?"**

**È una domanda a cui si risponde LEGGENDO L'ARCHIVIO, non girando un round**: basta
la durata media di vincenti e perdenti sui CSV già in casa. Se durano già abbastanza,
il candidato 1 muore in dieci minuti e abbiamo risparmiato un round. Se durano venti
minuti, allora `InpTP1_ClosePct` 50→0 non è una cella fortunata: **è il sintomo**.

### 📐 La griglia che proporrei DOPO quella risposta (⚠️ **NON è un file prova: non è passata dal cancello**)

```
# IPOTESI: sulla 770101 l'edge dell'ORB matura oltre i 60 minuti; la macchina
#          d'uscita (parziale a 1R + BE + trailing armato a 0R) lo tronca.
# CRITERI DI ACCETTAZIONE (congelati PRIMA dei numeri):
#   - PF OOS della cella-centro >= 1,45 CON n OOS >= 150
#   - DD OOS <= quello della cella viva, in % E in valuta
#   - se il PF sale ma n scende sotto 150 -> NON si promuove (e' selezione, non gestione)
@SIMBOLO  D30EUR
@PERIODO  M5
@DAQUANDO 2024.09.26          <- MISURATA, gia' in repo (prove/ABTG_DAX_Apertura_EU.txt)
InpTP1_ClosePct=0||0||0||0||N          <- PINNATO (cella gia' misurata)
InpBreakevenAtTP1=false||0||0||0||N    <- PINNATO (no-op a ClosePct=0, dichiarato)
InpTrailStartR=0||0||0.5||1.5||Y       <- L'ASSE
InpUseTrailing=true||0||0||0||N
```
🔴 **Prima di scriverlo come `.txt` servono: (a) la risposta alla domanda qui sopra,
(b) `controlla_prova.py`, (c) l'agente `controllo-preventivo`.** Non l'ho scritto
apposta: un file prova che sembra pronto e non lo è, è peggio di nessun file.

---

## ✍️ FONTI APERTE DAVVERO (21 pagine) — contro quelle solo TROVATE

**Aperte e lette:** `arxiv.org/list/q-fin.TR/recent` · `export.arxiv.org/api` (3 interrogazioni) ·
`arxiv.org/abs/2605.04004` · **`arxiv.org/pdf/2605.04004v3` (PDF intero, testo estratto)** ·
`arxiv.org/abs/2003.10502` · `quantconnect.com/research/18444` ·
`mql5.com/en/articles/17745` · `/23226` · `/19682` · `/18111` · `/16991` ·
`mql5.com/en/code/mt5/experts` (+ `page2`) · `quantpedia.com/strategies/` (+ ricerca) ·
`github.com/crispysizzlin/strategy-test` · **`raw.githubusercontent.com/.../docs/strategy-spec.md`** ·
`github.com/HrudithL/ReTrade/pull/1` · `tradingview.com/script/8vjWAdLN`.

**Solo trovate (titolo visto, pagina NON aperta):** tutte quelle in §7. **Un titolo
letto non è una fonte letta**, e in questo dossier non pesa su nessun verdetto.

---

**Licenze e attribuzione:** gli articoli MQL5 sono di MetaQuotes/autore (Niquel
Mendoza, Artyom Trishkin, Zhuo Kai Chen, Jocimar Lopes) e il sorgente è allegato
all'articolo; `crispysizzlin/strategy-test` **non dichiara licenza [INCERTO]**;
il Pine `8vjWAdLN` di fabledforman è open source su TradingView; il paper Mesfin è
su arXiv. 🔴 **Qualunque `.mq5` derivato da questi porta l'autore e la fonte in testa
al file.**
