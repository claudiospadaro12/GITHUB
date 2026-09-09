# 🗂️ CENSIMENTO DEGLI SCARTATI — ESTRAZIONE DALLA PROSA (09/09/2026)

> # 📌 **COSA C'È QUI DENTRO**
> Tutti i candidati **scartati, bocciati, archiviati, spenti o dichiarati senza
> edge** che si riescono a leggere nella **PROSA** del repo:
> `backtest_pipeline/REGISTRO_TEST.md`, i **176 file** di `report/*.md`,
> `HANDOFF.md`, `report/ROBUSTEZZA.md` e i referti `risultati_archivio/R*` citati
> da quei documenti.
>
> 🔢 **207 righe censite** — **119 NOSTRE** (hanno un `.mq5` in `mql5/Experts/`)
> e **88 ESTERNE** (mai arrivate a un `.mq5`).
>
> 🛑 **Questo file non promuove, non riapre, non accende e non tocca niente.**
> Nessun EA, preset, magic, parametro di forward o sedia viva è stato sfiorato.
> Nessun backtest lanciato. È **sola lettura d'archivio**. **Decide Claudio.**

_Compilato il **09/09/2026**. Se un referto e questo documento divergono,
**comanda il referto** — e la divergenza va nella §CONTRADDIZIONI, non nascosta._

> ## ✅ AGGIORNAMENTO DEL 09/09/2026 (sera) — **LE 10 CONTRADDIZIONI SONO STATE LAVORATE**
> Ognuna e' stata portata davanti all'**indizio materiale** (file che esistono
> davvero: CSV, commit, orari). Verbale completo e verdetti:
> **`report/CONTRADDIZIONI_CHIUSE_2026-09-09.md`**.
> 🔴 **Due esiti toccano questo file:** **C1** — il `DD 42,9%` di `ABTG_FvgRetest`
> e' **RITIRATO** (nessuna traccia materiale in tutta la storia del repo): la
> riga **A119** va letta come **`NON ANCORA MISURATO`**, non come contraddizione
> aperta. **C8** — l'accusa *"criterio aggiunto dopo i numeri"* su `M0PB` **e'
> risultata FALSA** ai commit (i criteri erano congelati ~4 ore prima della
> corsa); il verdetto scende comunque a **`NON ANCORA MISURATO`**, ma per due
> motivi diversi e migliori.

---

## 🧊 LE REGOLE DI SCRITTURA, CONGELATE PRIMA DELLA TABELLA

1. 🚫 **Nessun numero è stato inventato, stimato o interpolato.** Dove il numero
   non è scritto da nessuna parte la cella dice **`[NON MISURATO]`**.
2. 📎 **Un numero letto in UN SOLO file e non confermato altrove porta
   `[1 fonte]`.** Un numero senza fonte è peggio di un buco dichiarato.
3. 📄 **Ogni riga cita il file, e la riga dove esiste** (`r.NNN`).
4. 🪟 **Convenzione delle due colonne PF:** molti scarti sono **screening a
   finestra unica** (sweep di combo, non walk-forward). In quel caso il numero
   sta in **PF IS** e **PF OOS** dice **`[FINESTRA UNICA]`**. Dove il round era
   walk-forward, le due colonne sono quelle vere.
5. 🚪 **Il CANCELLO** è scelto fra: `EDGE/PF` · `RISCHIO/DD` · `FREQUENZA` ·
   `COSTO C3` · `MURO GIORNALIERO` · `NON MISURABILE (n troppo basso)` ·
   `BACO/NON GIRATA` · `ALTRO (…)`. Se i cancelli sono più d'uno sono elencati
   **in ordine di gravità**.
6. 🧭 **Il confine NOSTRO / ESTERNO è verificabile, non a sentimento:** è
   **l'esistenza di un `.mq5` in `mql5/Experts/`** (EA o sonda). Un candidato
   nato sul web ma arrivato a un nostro `.mq5` (CRT, ChaosLyapunov, LondonFx,
   IBRetest, LVNArbitro, M0PB-sonda, RSI+EMA V8-sonda) sta in **§A**, con
   l'origine dichiarata nella riga.

---

# 🏠 SEZIONE A — CANDIDATI **NOSTRI** (hanno un `.mq5` in `mql5/Experts/`)

| # | Motore / EA | Famiglia | Simbolo/i | TF | n operazioni | PF IS | PF OOS | DD max % | 🚪 CANCELLO CHE HA UCCISO | Data verdetto | File di riferimento |
|---:|---|---|---|---|---|---|---|---|---|---|---|
| A1 | `ABTG_DAX_Apertura_EU` cella **A1** (entrambe + Supertrend ON) | Aperture | D30EUR | M5 | `[NON MISURATO]` | **1,03** best · 3% combo positive `[1 fonte]` | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 26/07/2026 | `backtest_pipeline/REGISTRO_TEST.md` r.18 |
| A2 | `ABTG_Nasdaq_Apertura_US` cella **A4** (solo long, screening) | Aperture | NASUSD | M5 | `[NON MISURATO]` | **0,91** best · **0% combo positive** `[1 fonte]` | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.21 |
| A3 | `ABTG_Nasdaq_Apertura_US` breakout — **sedia 770201, SPENTA** | Aperture | NASUSD | M5 | `[NON MISURATO]` | `[NON MISURATO]` | **0,82** · walk-forward **19/20 celle OOS negative** | **17%** | `RISCHIO/DD` → `EDGE/PF` | 18/08/2026 | `report/CONTRATTI_SEDIE.md` r.45 · `report/CORSIA_DEMO_CANDIDATI.md` r.225 · `report/PERCHE_MUOIONO_2026-09-08.md` r.105 |
| A4 | `ABTG_DAX_Live5m` | Live5m | D30EUR | M5 | `[NON MISURATO]` | **27/27 combo NEGATIVE** | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.34 |
| A5 | `ABTG_Nasdaq_Live5m` | Live5m | NASUSD | M5 | `[NON MISURATO]` | **27/27 combo NEGATIVE** | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.35 |
| A6 | `ABTG_DAX_Live5m_v2` (32 combo) | Live5m | D30EUR | M5 | `[NON MISURATO]` | **1,04** best (resto negativo) | `[FINESTRA UNICA]` | **~10%** (best) · **15-26%** (resto) | `EDGE/PF` → `RISCHIO/DD` | 26/07/2026 | `REGISTRO_TEST.md` r.36 |
| A7 | `ABTG_ORB_Fibo` | ORB | NASUSD | M5 | `[NON MISURATO]` | **29% combo positive** (OHLC) | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.133 |
| A8 | `ABTG_DAX_M3` | Breakout | D30EUR | M3 | `[NON MISURATO]` | **33% combo positive**, **short 0%** (OHLC) | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.134 |
| A9 | `ABTG_Londra_ORB` | ORB Londra | GBPUSD | M5 | `[NON MISURATO]` | **11% combo positive** (OHLC) · **R45 a tick: 0/48** | **0/48** | **23%** | `EDGE/PF` → `RISCHIO/DD` | 26/07/2026 (OHLC) · R45 19/08/2026 | `REGISTRO_TEST.md` r.135 · `CORSIA_DEMO_CANDIDATI.md` r.239 |
| A10 | Motore aperture su **FTSE** | Aperture | 100GBP | M5 | `[NON MISURATO]` | **0,90** (profit −302) | `[FINESTRA UNICA]` | **9,6%** | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.375 |
| A11 | Motore aperture su **Dow** | Aperture | U30USD | M5 | `[NON MISURATO]` | **0,997** (profit −9) | `[FINESTRA UNICA]` | **8,6%** | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.376 |
| A12 | Motore aperture su **Russell 2000** | Aperture | US2000 | M5 | **0 (mai girato)** | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `ALTRO (strumento NON quotato su BCM)` | 26/07/2026 | `REGISTRO_TEST.md` r.373 |
| A13 | `ABTG_SupertrendReversal` cella **S2** | SupRev | D30EUR | M5 | `[NON MISURATO]` | **0% combo positive** | `[FINESTRA UNICA]` | **30-37%** | `RISCHIO/DD` → `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.151 |
| A14 | `ABTG_SupertrendReversal` cella **S3** | SupRev | NASUSD | H4 | **15-19** (best) | 43% combo positive | `[FINESTRA UNICA]` | `[NON MISURATO]` | `NON MISURABILE (n troppo basso)` | 26/07/2026 | `REGISTRO_TEST.md` r.152 |
| A15 | `ABTG_SupertrendReversal` cella **S6** | SupRev | NASUSD | M5 | `[NON MISURATO]` | **1,10** best · 5% combo positive | `[FINESTRA UNICA]` | **11,5%** | `EDGE/PF` → `RISCHIO/DD` | 26/07/2026 | `REGISTRO_TEST.md` r.155 |
| A16 | `ABTG_SupertrendReversal` FTSE H4 | SupRev | 100GBP | H4 | **48** | **1,29** | `[FINESTRA UNICA]` | **2%** | `EDGE/PF` → `NON MISURABILE (n troppo basso)` | 26/07/2026 | `REGISTRO_TEST.md` r.393 |
| A17 | `ABTG_SupertrendReversal` FTSE H1 | SupRev | 100GBP | H1 | `[NON MISURATO]` | **tutte negative** | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.394 |
| A18 | `ABTG_SupertrendReversal` Nikkei | SupRev | 225JPY | H1/H4 | **24-75** | **~2** | `[FINESTRA UNICA]` | **0,2%** | `ALTRO (profitto irrisorio ~50 €, lotto JPY minuscolo)` → `NON MISURABILE` | 26/07/2026 | `REGISTRO_TEST.md` r.395 |
| A19 | `ABTG_SupRev_DOW_H4_Ottimizzato` **970914** | SupRev | U30USD | H4 | **79** (cella promossa) | OHLC **2,58** · cella tick **2,77** | **PFmed a tick 0,79** — promozione **REVOCATA** | 4,0% (cella) | `EDGE/PF (illusione OHLC)` | ~24-25/08/2026 | `FLOTTA_ATTIVA.md` r.87 · `CORSIA_DEMO_CANDIDATI.md` r.242 · `risultati_archivio/CLASSIFICHE.md` r.14 e §2 |
| A20 | `ABTG_SupRev_CAC_H4_Ottimizzato` **970915** | SupRev | F40EUR | H4 | **65** (cella promossa) | OHLC **7,37** · cella tick **1,79** | **PFmed a tick 0,96** — promozione **REVOCATA** | 3,5% (cella) | `EDGE/PF (overfit / illusione OHLC)` | ~24-25/08/2026 | `FLOTTA_ATTIVA.md` r.86 · `CORSIA_DEMO_CANDIDATI.md` r.242 |
| A21 | `ABTG_SupRev_DOW_H1_Ottimizzato` **970916** | SupRev | U30USD | H1 | **273** | **1,20** | `[FINESTRA UNICA]` | **9,8-10,0%** (a rischio 1%) | `RISCHIO/DD` | ~26/07-24/08/2026 | `FLOTTA_ATTIVA.md` r.88 · `risultati_archivio/CLASSIFICHE.md` r.14 · `RIPESCAGGIO_FREQUENZA_2026-09-08.md` §4.1 |
| A22 | `ABTG_SupRev_DAX_H1_Ottimizzato` **970911** — **SPENTA con delibera** | SupRev | D30EUR | H1 | **223** | **IS −240 (rosso)** | OOS **+1.312** | 5,6% (cella 26/07) | `EDGE/PF (IS rosso a campione pieno)` | **11/08/2026** | `risultati_archivio/REFERTO_FUORILISTA.md` · `FLOTTA_ATTIVA.md` r.44 · `CORSIA_DEMO_CANDIDATI.md` r.226 |
| A23 | SupRev su **IBEX H1** (R18) | SupRev | IBEX | H1 | `[NON MISURATO]` | **0/12 celle** | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | R18 (data non riportata nei file letti) | `CORSIA_DEMO_CANDIDATI.md` r.241 `[1 fonte]` |
| A24 | `ABTG_GoldenCross` su **forex** (R20) | GoldenCross | forex vari | H1/H4 | `[NON MISURATO]` | **0/6 celle** | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | R20 | `CORSIA_DEMO_CANDIDATI.md` r.241 `[1 fonte]` |
| A25 | SupRev H4 su **simboli non-indice** (R21) | SupRev | vari | H4 | `[NON MISURATO]` | **0 promossi** | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | R21 | `CORSIA_DEMO_CANDIDATI.md` r.241 `[1 fonte]` |
| A26 | SupRev **GBPJPY oltre il bordo** (R22) | SupRev | GBPJPY | H1/H4 | `[NON MISURATO]` | **3/9 celle** | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | R22 | `CORSIA_DEMO_CANDIDATI.md` r.241 `[1 fonte]` |
| A27 | `ABTG_SuperWave` DAX H1 | SuperWave | D30EUR | H1 | `[NON MISURATO]` | **0,84** max | `[FINESTRA UNICA]` | **17%** | `RISCHIO/DD` → `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.467 |
| A28 | `ABTG_SuperWave` Nasdaq H4 | SuperWave | NASUSD | H4 | **16-18** | **negative** | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` → `NON MISURABILE (n troppo basso)` | 26/07/2026 | `REGISTRO_TEST.md` r.468 |
| A29 | `ABTG_SuperWave` Oro | SuperWave | XAUUSD | H1/H4 | `[NON MISURATO]` | **~1,0 / negative** | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.469 |
| A30 | `ABTG_SuperWave` GBPUSD **770532** — **SPENTA** | SuperWave | GBPUSD | H2 | `[NON MISURATO]` | **0,79** (R103, 6,5 anni; profit −7.501; **5/7 anni negativi**) | `[FINESTRA UNICA]` | **13,4%** (12,9× il promesso) | `RISCHIO/DD` → `EDGE/PF` | **24/08/2026** | `risultati_archivio/R103_REFERTO_FINALE.md` pos.23 · `CORSIA_DEMO_CANDIDATI.md` r.222 |
| A31 | `ABTG_SuperWave_DAX_H4_Ottimizzato` **770512** — 🎣 **RIPESCATO 08/09** | SuperWave | D30EUR | H4 | **56** | **1,28** (tick, profit +278, 7/9 celle positive) | `[FINESTRA UNICA]` | **3,3%** (a rischio 1%) | `FREQUENZA` (0,12 op/g) → `NON MISURABILE (n 56 < 150)` | mai in campo; rilettura **08/09/2026** | `REGISTRO_TEST.md` **r.477** · `CORSIA_DEMO_CANDIDATI.md` §2 G4 · `RIPESCAGGIO_FREQUENZA_2026-09-08.md` §2 R1 |
| A32 | `ABTG_MaxMinNotte` FTSE | Night-box | 100GBP | M15 | `[NON MISURATO]` | **0,67** max | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.419 |
| A33 | `ABTG_MaxMinNotte` CAC | Night-box | F40EUR | M15 | `[NON MISURATO]` | **~1,0** max | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.420 |
| A34 | `ABTG_MaxMinNotte` Stoxx50 | Night-box | E50EUR | M15 | `[NON MISURATO]` | **0,59** max | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 26/07/2026 | `REGISTRO_TEST.md` r.421 |
| A35 | `ABTG_FiboH4_Multi` | FiboH4 | 8 coppie forex + oro (di fatto **GBPUSD;USDJPY;EURUSD**) | H4 | `[NON MISURATO]` | IS da **−384,56 a −394,13** (profit) | OOS da **+116,17 a +118,68** | `[NON MISURATO]` | **`BACO/NON GIRATA`** (pin `InpSymbols` vuoto → default compilato; **7 file su 8 identici al centesimo**) — il "0/8" è **una config contata otto volte** | verdetto 10-11/08/2026, **smontato il 21/08/2026** | `REGISTRO_TEST.md` r.50 e r.52-57 |
| A36 | `ABTG_PostNews` — **primo verdetto, RITIRATO** | PostNews | EURUSD / EURJPY | M5 | **0 (Trades = 0 su 4 CSV)** | **0,00** | **0,00** | 0,00 | **`BACO/NON GIRATA`** (calendario 2026-2027 + `FileOpen` senza `FILE_COMMON` → filtro spento in silenzio) | letto 07/08/2026, **RITIRATO 03/09/2026** | `REGISTRO_TEST.md` r.76 e r.70-79 |
| A37 | `ABTG_PostNews` candidato **A** — ISM/PMI/CB 15:15 srv (magic 774701/774706) | PostNews | EURUSD | M5 | **IS 234 / OOS 312** | **0,76** (profit −4.651,72) | **0,79** (profit −5.633,01) | **6,92 / 6,94** | `EDGE/PF` (PF < 1 su **entrambe** le finestre, campione pieno) | **05/09/2026** | `REGISTRO_TEST.md` r.1178+ |
| A38 | `ABTG_PostNews` candidato **B** — blocco 13:45 srv (magic 774801/774806) | PostNews | USDJPY | M5 | **IS 151 / OOS 253** | **0,66** (profit −4.084,87) | **0,90** (profit −1.979,08) | **4,75 / 4,56** | `EDGE/PF` | **05/09/2026** | `REGISTRO_TEST.md` r.1178+ |
| A39 | `ABTG_Nightly` **fade** su indici/oro | Nightly | U30USD · D30EUR · XAUUSD | M15 | **0 trade** | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`BACO/NON GIRATA`** (`InpMaxNightVolPips=45` contro `ATR(H1)/PipSize()`, su indici/oro `PipSize()=_Point` → sempre ≥45) — *"non è stato bocciato: non è stato misurato"* | rettifica **23/08/2026** | `REGISTRO_TEST.md` §"analisi del PDF Strategia NIGHTLY" · `CORSIA_DEMO_CANDIDATI.md` r.295 |
| A40 | `ABTG_Nightly` fade forex | Nightly | EURUSD · GBPUSD · USDCHF | M15 | **~160 per coppia** | **negativo** (coda fascia B: **0/8**) | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 10-11/08/2026 | `REGISTRO_TEST.md` §NIGHTLY · `HANDOFF.md` r.1810 |
| A41 | `ABTG_Nightly` **EURCHF** | Nightly | EURCHF | M15 | **IS 63 / OOS 85** | **0,89113** (profit −408,07) | **0,81429** (profit −956,49) | 🔴 **11,0988 / 15,3861** | `RISCHIO/DD` → `EDGE/PF` → `NON MISURABILE (n<150)` | **09/09/2026** | `report/P0_NIGHTLY_EURCHF_2026-09-09.md` |
| A42 | `ABTG_CRT_TurtleSoup` (origine: Neo Malesa, MIT) | CRT / Turtle Soup | **NASUSD** | **M15** (tick, modello 4) | 30 celle, `n` non riportato | **0/30 celle con PF ≥ 1** | **0/30** · PF **0,43-0,73** ovunque | `[NON MISURATO]` per cella · **17/19 mesi rossi** | `EDGE/PF` | **30-31/08/2026** | `risultati_archivio/REFERTO_CRT_2026-08-30.md` r.1-10 · `REGISTRO_TEST.md` r.594 |
| A43 | `ABTG_CRT_TurtleSoup` **+ gate ADX(D1)≤30** | CRT | NASUSD | M15 tick | idem | — | **PF 0,459** gated contro **0,462** ungated → *il gate non salva* | idem | `EDGE/PF` | 31/08/2026 | `REGISTRO_TEST.md` r.598-601 |
| A44 | `ABTG_ChaosLyapunov` (gate LLE, origine Code Base **76446**) | Chaos / EMA-cross | **NASUSD_EXT** | M15 (OHLC 2020-2024) | **55-92 trade / 4 anni** | 105 celle: gate stretto **0,39-0,42** · gate largo **1,25-1,33** | `[FINESTRA UNICA]` | fascia PF≥1,3 & DD<8% = **1 cella su 105** | `EDGE/PF (tesi falsificata: il gate morde AL CONTRARIO)` → `NON MISURABILE` | **31/08/2026** | `risultati_archivio/REFERTO_CHAOS_2026-08-31.md` · `REGISTRO_TEST.md` r.614 |
| A45 | `ABTG_ChaosLyapunov` — **ablazione dell'ingrediente LLE** | Chaos | NASUSD_EXT | M15 | `[NON MISURATO]` | gate max **1,789** contro nudo **1,150** | `[FINESTRA UNICA]` | **8,78%** contro 21,01% | `ALTRO (fallita la condizione profit_totale della lettera congelata)` — condizione riconosciuta **anti-filtro per costruzione** | 31/08/2026 | `risultati_archivio/REFERTO_CHAOSABL_2026-08-31.md` · `REGISTRO_TEST.md` r.622-630 |
| A46 | `ABTG_NySessionRetest` — cella **slope 75** | NY Retest / VWAP | U30USD | M15 | **114-115** | `[FINESTRA UNICA]` | **1,374 (sl5) / 1,427 (sl7)** | **3,7-4,7%** (motore nudo 12,87%) · pegg. giornata **−0,69%** | `NON MISURABILE (n troppo basso)` — muro R59 | **31/08/2026** | `risultati_archivio/REFERTO_NYRETEST_2026-08-31.md` · `REGISTRO_TEST.md` r.645 · `CORSIA_DEMO_CANDIDATI.md` §2 G2 |
| A47 | `ABTG_NySessionRetest` — cella **slope 60** | NY Retest | U30USD | M15 | **160** | `[FINESTRA UNICA]` | **1,14-1,20** (sotto barra 1,30) | `[NON MISURATO]` | `EDGE/PF` | 31/08/2026 | idem |
| A48 | `ABTG_DaxReEntry` lato **LONG** | DaxReEntry | D30EUR | M5 | **57** (break 40) · **92** (break 20) | `[FINESTRA UNICA]` | **1,69-1,80** (break 40) · **1,159** (break 20) · 6/6 celle long verdi | **2,5-2,9% / 4,6%** · pegg. giornata **−0,67/−0,68%** | `NON MISURABILE (n ≤ 92 < 150)` — merito sospeso R59 | **31/08/2026** | `risultati_archivio/REFERTO_DAXREENTRY_2026-08-31.md` · `REGISTRO_TEST.md` r.721 · `CORSIA_DEMO_CANDIDATI.md` §2 G3 |
| A49 | `ABTG_DaxReEntry` lato **SHORT** | DaxReEntry | D30EUR | M5 | `[NON MISURATO]` | `[FINESTRA UNICA]` | **0,38-0,54** | **8,8-23%** | `EDGE/PF` → `RISCHIO/DD` | 31/08/2026 | `CORSIA_DEMO_CANDIDATI.md` r.162 |
| A50 | `ABTG_BreakinBox` (falsa rottura box notturno) — **tesi** | BreakinBox | D30EUR | M15 tick 2024-2026 | ~**20/mese** due lati | `[FINESTRA UNICA]` | **1,007** | **24,1%** | `EDGE/PF (tesi falsificata dal controllo)` → `RISCHIO/DD (cancello ≤15%)` | **31/08/2026** | `risultati_archivio/REFERTO_BREAKIN_2026-08-31.md` · `REGISTRO_TEST.md` r.712 |
| A51 | `ABTG_BreakinBox` — **controllo RR fisso 2,0** | BreakinBox | D30EUR | M15 tick | idem | `[FINESTRA UNICA]` | **1,106** | **19,7%** | `RISCHIO/DD` (buca comunque il cancello DD ≤ 15%) | 31/08/2026 | idem |
| A52 | `ABTG_VwapRevert` | VWAP reversion | D30EUR | M15 | **n OOS 107** (cella `00_nudo`) | `[FINESTRA UNICA]` | **S0 NON PASSA su 4 celle su 4**: rapporto punti/spread **−0,11 / −0,21 / −0,14 / −0,21** | `[NON MISURATO]` | **`COSTO C3`** (S0) → `EDGE/PF` (*"perde in media PIÙ dello spread"*) → `NON MISURABILE (n 107)` | **03/09/2026** | `REGISTRO_TEST.md` r.944 · `risultati_archivio/vwaprevert/CORSA_2026-09-03_1711_FALSIFICATO.txt` |
| A53 | `ABTG_LondonFx` **motore 2** (canale + RSI) — l'unico promuovibile | LondonFx | EURUSD | M15 tick | **1.132** | **0,795** (profit −36.353,98) | **0,843** · E OOS **−0,1078R** | 🔴 **37,14%** | `RISCHIO/DD` → `EDGE/PF` | **03/09/2026** (R116) | `REGISTRO_TEST.md` r.956 · `PERCHE_MUOIONO_2026-09-08.md` r.93 |
| A54 | `ABTG_LondonFx` **motore 1** (canale nudo, controllo) | LondonFx | EURUSD | M15 tick | **2.253** | `[NON MISURATO]` | **0,898** | 🔴 **45,29%** | `RISCHIO/DD` → `EDGE/PF` (+ **strozzato dal tetto giornaliero**, 38%/22% dei giorni oltre soglia) | 03/09/2026 | `REGISTRO_TEST.md` r.956+ · `PERCHE_MUOIONO` r.92 |
| A55 | `ABTG_LondonFx` **motore 3** (5 medie, P2 28/08) | LondonFx | EURUSD | M15 tick | **1.343** | `[NON MISURATO]` | **0,923** | 🔴 **31,26%** | `RISCHIO/DD` → `EDGE/PF` | 03/09/2026 | idem |
| A56 | `ABTG_LondonFx` **GBPUSD** (tutti e 3 i motori) | LondonFx | GBPUSD | M15 tick | **1.132** (motore 2) | **0,688** | **0,763** · E OOS **−0,1726R** | 🔴 **55,03%** (motori 1 e 3: **55-61%**) | `RISCHIO/DD` → `EDGE/PF` ⚠️ **banco sporco classe 129** (gemelli divergenti: numeri non leggibili, ma la bocciatura è per rischio) | **03/09/2026** | `REGISTRO_TEST.md` r.971 · `PERCHE_MUOIONO` r.95 |
| A57 | `ABTG_Relativo` gamba **D30EUR** (R117, cella N=40 / σ=1,35) | RELATIVO | D30EUR | M5 tick | `[NON MISURATO]` | `[NON MISURATO]` | **0,452** · E OOS **−0,267R** | 🔴 **25,01%** | `RISCHIO/DD` → **`MURO GIORNALIERO` (−5,20%)** → `EDGE/PF` — **due muri prop insieme** | **~04/09/2026** | `REGISTRO_TEST.md` r.1540 · `HANDOFF.md` r.256 · `PERCHE_MUOIONO` r.96 |
| A58 | `ABTG_Relativo` gamba **NASUSD** (R117, stessa cella) | RELATIVO | NASUSD | M5 tick | **IS 87 / OOS 154** | **0,754** | **1,189** · E OOS **+0,063R** | **8,40%** · pegg. giornata −2,12% | `NON MISURABILE (n troppo basso, A6 non soddisfatto)` — **il rischio non è mai stato rosso**; A6 raggiungibile **~27/11/2026** | **~04/09/2026** | `REGISTRO_TEST.md` r.1554 · `CORSIA_DEMO_CANDIDATI.md` §2 G1 |
| A59 | `ABTG_AtrExhaustVol` — **D30EUR LONG** | AtrExhaust (R109) | D30EUR | M15 | **818** | `[FINESTRA UNICA]` | **0,911** | 🔴 **56,2%** · pegg. giornata −4,82% | `RISCHIO/DD` → `EDGE/PF` | **26/08/2026** | `risultati_archivio/R109_REFERTO.md` · `PERCHE_MUOIONO` r.86 |
| A60 | `ABTG_AtrExhaustVol` — **D30EUR SHORT** | AtrExhaust | D30EUR | M15 | **927** | `[FINESTRA UNICA]` | **0,831** | 🔴 **67,8%** · pegg. giornata −5,01% | `RISCHIO/DD` → **`MURO GIORNALIERO`** → `EDGE/PF` | 26/08/2026 | `R109_REFERTO.md` · `PERCHE_MUOIONO` r.87 |
| A61 | `ABTG_AtrExhaustVol` — **U30USD LONG** | AtrExhaust | U30USD | M15 | **886** | `[FINESTRA UNICA]` | **0,978** | 🔴 **44,3%** · pegg. giornata −4,38% | `RISCHIO/DD` → `EDGE/PF` | 26/08/2026 | `PERCHE_MUOIONO` r.88 |
| A62 | `ABTG_AtrExhaustVol` — **U30USD SHORT** | AtrExhaust | U30USD | M15 | **923** | `[FINESTRA UNICA]` | **0,917** | 🔴 **57,2%** · pegg. giornata 🔴 **−9,72%** | `RISCHIO/DD` → **`MURO GIORNALIERO`** (2 muri insieme) → `EDGE/PF` | 26/08/2026 | `PERCHE_MUOIONO` r.89 |
| A63 | `ABTG_AtrExhaustVol` — **NASUSD LONG** | AtrExhaust | NASUSD | M15 | **655** | `[FINESTRA UNICA]` | **0,885** | 🔴 **59,2%** · pegg. giornata −4,57% | `RISCHIO/DD` → `EDGE/PF` | 26/08/2026 | `PERCHE_MUOIONO` r.90 |
| A64 | `ABTG_AtrExhaustVol` — **NASUSD SHORT** | AtrExhaust | NASUSD | M15 | **743** | `[FINESTRA UNICA]` | **0,990** | 🔴 **44,1%** · pegg. giornata −4,30% | `RISCHIO/DD` → `EDGE/PF` | 26/08/2026 | `PERCHE_MUOIONO` r.91 |
| A65 | `ABTG_AllineaLondra` (8 letture) | Allinea Londra | EURUSD | M15 | `[NON MISURATO]` | `[FINESTRA UNICA]` | **0,60-1,12** · profitto negativo su **7/8** | 🔴 **10,44-46,62%** | `RISCHIO/DD` → `EDGE/PF` | **03/09/2026** | `risultati_archivio/allinealondra/REFERTO_PASSO0_2026-09-03_1651.txt` · `CORSIA_DEMO_CANDIDATI.md` r.205 |
| A66 | `ABTG_AltaVelocita` v1 / v1.1 (8 celle) | Alta Velocità (Manuela Negro) | GBPUSD | `[NON DICHIARATO nei file letti]` | `[NON MISURATO]` | `[FINESTRA UNICA]` | **0,54-0,82** · **8/8 celle negative**, **4/4 OOS negative anche in v1.1** | 🔴 fino a **37%** | `EDGE/PF` → `RISCHIO/DD` | **11/08/2026**, riletto 06/09/2026 | `risultati_archivio/REFERTO_ALTA_VELOCITA_V1.md` · `report/ANALISI_MANUALE_ALTAVELOCITA_2026-09-06.md` §0 |
| A67 | **FASE 2 CASSAFORTE** — Nasdaq drive-following LONG | Fase 2 | NASUSD | M15 | **OOS 297** | `[NON MISURATO]` | **1,083** | 🔴 **11,73%** già a rischio **0,65%** | `RISCHIO/DD` → `EDGE/PF` (campione pieno, sotto barra) — costo escluso come causa (spread misurato 1,7 pti) | **30/08/2026** | `risultati_archivio/REFERTO_FASE2_CASSA_2026-08-30.md` · `CORSIA_DEMO_CANDIDATI.md` r.209 |
| A68 | **FASE 2 CASSAFORTE** — cella simmetrica (long+short) | Fase 2 | NASUSD | M15 | `[NON MISURATO]` | `[NON MISURATO]` | **0,796** (asp./trade −47,6) | **19,09%** | `RISCHIO/DD` + `EDGE/PF` | 30/08/2026 | idem r.210 |
| A69 | `ABTG_SondaGapCash` — gap di sessione cash | Gap cash | NASUSD (tick BCM) | M5/M15 `[NON DICHIARATO]` | `[NON MISURATO]` | dato esterno **+0,0988%** evento vs **+0,0112%** controllo | tick BCM **−0,0487%** vs **−0,0134%** — **segno rovesciato**, monotonia rotta **4/7** | `[NON MISURATO]` (la sonda **non apre ordini**) | `EDGE/PF (segno rovesciato)` + `FREQUENZA` (0,14 op/g per simbolo) — 🎣 **riaperto 08/09 solo per la firma sulla frequenza** | **07/09/2026** | `risultati_archivio/REFERTO_GAPCASH_PASSO0_2026-09-07.md` · `CORSIA_DEMO_CANDIDATI.md` r.212 · `RIPESCAGGIO_FREQUENZA` §2 R2 |
| A70 | `ABTG_SondaOrologio` — **ramo DAX (indici)** | Sonda Orologio | D30EUR | fasce orarie | 72 fasce × 2 lati | **1 fascia asimmetrica su 72** (IS) | **0 fasce asimmetriche su 72** (OOS) | `[NON MISURATO]` | `EDGE/PF` (*LONG = −SHORT esatto → ogni ora "verde" era deriva del toro*) | **07/09/2026** | `risultati_archivio/REFERTO_OROLOGIO_INDICI_DAX_2026-09-07.md` · `CORSIA_DEMO_CANDIDATI.md` r.213 |
| A71 | `ABTG_InvEsaurimento` cella **E3** | InvEsaurimento | `[NON DICHIARATO]` | `[NON DICHIARATO]` | **215** | `[FINESTRA UNICA]` | **1,16** nel totale — ma **−5.604 (−95/trade) nel TORO PULITO 2017** | **8,16%** | `ALTRO (lettura per regime: perde proprio nel regime del forward)` | **30/08/2026** | `risultati_archivio/REFERTO_INVES_2026-08-30.md` · `CORSIA_DEMO_CANDIDATI.md` r.214 |
| A72 | `ABTG_InvEsaurimento` cella **E1** (esaurimento ≥1,0× ADR14) | InvEsaurimento | `[NON DICHIARATO]` | `[NON DICHIARATO]` | **68** | `[FINESTRA UNICA]` | **0,95** (profit −944) | `[NON MISURATO]` | `EDGE/PF` → `NON MISURABILE (n 68)` | 30/08/2026 | idem r.215 |
| A73 | `ABTG_CrossEmaApertura` cella **A (ancora)** — Dow | CrossEma apertura (R96) | U30USD | M5 | **IS 440 / OOS 661** | **0,96** (profit −9.302) | **0,92** (profit −28.908) | 🔴 **35,5%** | `RISCHIO/DD` → `EDGE/PF` | **23/08/2026** | `risultati_archivio/R96_REFERTO.md` r.21-24 |
| A74 | `ABTG_CrossEmaApertura` cella **A (ancora)** — Nasdaq | CrossEma apertura (R96) | NASUSD | M5 | **IS 437 / OOS 643** | **0,99** (profit −1.772) | **0,99** (profit −5.232) | 🔴 **35,4%** | `RISCHIO/DD` → `EDGE/PF` | 23/08/2026 | `R96_REFERTO.md` r.27-30 |
| A75 | `ABTG_CrossEmaApertura` cella **B (controllo)** — Dow / Nasdaq | CrossEma apertura (R96) | U30USD / NASUSD | M5 | **273/423** e **256/410** | **0,83** / **1,06** | **0,95** / **1,00** | **24,7%** / **19,1%** | `ALTRO (filtro orario appiccicato: per firma NON promuovibile, mai)` + `RISCHIO/DD` | 23/08/2026 | `R96_REFERTO.md` r.22, r.28, r.36-39 |
| A76 | `ABTG_ORB` — **stop all'estremo opposto** (R97, 4 celle) | ORB | NASUSD | M5 tick | **IS 74 / OOS 135** per cella | **1,13-1,32** (IS **verde 4/4**) | 🔴 **0,84-0,91** — **tutte sotto 1,00** | **8,2-12,4%** (S1 ≤7%: **0/4**) | `EDGE/PF` (**0/4**) → `RISCHIO/DD` | **22/08/2026** | `risultati_archivio/R97_REFERTO.md` r.21-26 |
| A77 | `ABTG_IntradayMomentum` (Gao, porting) | Intraday momentum (R98) | NASUSD | M15 tick | **IS 149 / OOS 261** (cella nuda) | `[NON MISURATO]` per cella | **0/6 celle** | `[NON MISURATO]` | **`COSTO C3`** (cancello zero S0: **−0,31 punti indice per operazione**) → `EDGE/PF` | **23/08/2026** | `risultati_archivio/R98_REFERTO.md` r.1, r.14-18 |
| A78 | `ABTG_MeanRevert` (R60) | Mean revert | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | **12/12 celle bocciate** | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | R60 | `CORSIA_DEMO_CANDIDATI.md` r.244 `[1 fonte]` |
| A79 | `ABTG_CrossEma` (R86) | CrossEma | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `EDGE/PF` (citato in blocco con R60/R96/R97/R98) | R86 | `CORSIA_DEMO_CANDIDATI.md` r.244 `[1 fonte]` |
| A80 | **FADE degli estremi del range di apertura** (R42) | Fade apertura | indici | M5 | **195-333 per cella** | **0/48 celle positive** | **0/48** | `[NON MISURATO]` | `EDGE/PF` | R42 (fascia C, ~08/2026) | `CORSIA_DEMO_CANDIDATI.md` r.237 · `HANDOFF.md` r.1554 |
| A81 | **Rimbalzo ORL/ORH** (R43) | ORB | NASUSD · D30EUR | M5 | `[NON MISURATO]` | **0/8** | **0/8** | `[NON MISURATO]` | `EDGE/PF` | R43 | `CORSIA_DEMO_CANDIDATI.md` r.238 · `HANDOFF.md` r.1554-1555 |
| A82 | **Londra ORB** (R45) | ORB Londra | GBPUSD | `[NON DICHIARATO]` | `[NON MISURATO]` | **0/48** | **0/48** | `[NON MISURATO]` | `EDGE/PF` ⚠️ **e il fuso era sbagliato**: misurava la **pre-apertura** (Londra apre 08:00 srv, misurato 03/09) | **19/08/2026** | `CORSIA_DEMO_CANDIDATI.md` r.239 · `REGISTRO_TEST.md` §CACCIA LONDRA ALTERNATIVA |
| A83 | `ABTG_LiquiditySweep` — **sweep + reclaim JPY** (R95) | Sweep/reclaim | EURJPY | OHLC M1, densità M30→H4 | **21.354 livelli creati, 0 buttati** | **0/30 passate** · PF **0,65-0,80** | **0/30** | `[NON MISURATO]` | `EDGE/PF` (*non è fame di segnali*) | **23/08/2026** | `risultati_archivio/R95_REFERTO.md` r.1 · `REGISTRO_TEST.md` §CACCIA FREQUENZA5 |
| A84 | `ABTG_ORB_Ottimizzato` lato **SHORT** sul Dow (R54) | ORB | U30USD | M5 | `[NON MISURATO]` | `[NON MISURATO]` | **0,520** | 🔴 **26,37%** | `RISCHIO/DD` + `EDGE/PF` (asimmetria strutturale, rosso in **entrambe** le finestre) | **R54** | `CORSIA_DEMO_CANDIDATI.md` r.236 · `PERCHE_MUOIONO` r.104 |
| A85 | `ABTG_Dow_Apertura_US` lato **SHORT** (R54 → riprodotto R107) | Aperture | U30USD | M5 tick | **IS 73 / OOS 73** | **1,511** (profit +6.463) | 🔴 **0,840** (profit −2.592) | **8,62%** | `EDGE/PF` (28° ribaltamento: lo short è la cella **migliore** in campione) | **25/08/2026** (R107) | `risultati_archivio/R107_REFERTO.md` r.17, r.29 |
| A86 | `ABTG_DAX_Apertura_EU` lato **SHORT** (R107) | Aperture | D30EUR | M5 tick | **IS 138 / OOS 257** | **0,965** (profit −996) | **0,957** (profit −1.865) | **12,31%** | `EDGE/PF` (**campione pieno**, discesa feb-apr 2025 inclusa) → `RISCHIO/DD` | **25/08/2026** | `R107_REFERTO.md` r.31 |
| A87 | `ABTG_Nasdaq_Apertura_US` lato **SHORT** (R107) | Aperture | NASUSD | M5 tick | **IS 58 / OOS 59** | **3,220** (profit +8.399) | 🔴 **0,460** (profit −10.569) | **11,34%** | `EDGE/PF` (ribaltamento IS→OOS) → `RISCHIO/DD` → `NON MISURABILE (n 58/59)` | 25/08/2026 | `R107_REFERTO.md` r.33 |
| A88 | `ABTG_BreakingBand` su **M15** (R108) | Breaking Band / Bulge | GBPUSD · EURUSD · AUDUSD | M15 tick | **227 · 87 · 118** | GBP **0,935** · EUR **0,712** · AUD **0,781** | GBP **0,743** · EUR **0,533** · AUD **0,965** | `[NON MISURATO]` | `EDGE/PF` (**cancello di merito 0/3**) | **25/08/2026** | `risultati_archivio/R108_REFERTO.md` r.28-30 |
| A89 | `ABTG_BreakingBand` su **M30** (R111) | Breaking Band | GBPUSD · EURUSD · AUDUSD | M30 tick | **358 · 195 · 145** | GBP **0,997** (IS 181, **negativo**) · EUR **0,656** · AUD **0,701** | GBP **1,087** (n 174) · EUR **0,882** · AUD **1,030** | `[NON MISURATO]` | `EDGE/PF` (**0/3**; su GBPUSD campione pieno e **IS negativo**) — gradiente misurato **H1 > M30 > M15** | **26/08/2026** | `risultati_archivio/R111_REFERTO.md` r.24-26 |
| A90 | `ABTG_SuperWave_DOW_H1_Ottimizzato` lato **SHORT** (R110) | SuperWave | U30USD | H1 tick | **OOS 84** | `[NON MISURATO]` | 🔴 **0,429** (profit −6.090) | **7,53%** | `EDGE/PF` → `NON MISURABILE (n 84)` | **26/08/2026** | `risultati_archivio/R110_REFERTO.md` r.31 |
| A91 | `ABTG_SupRev_DAX_H4_Ottimizzato` lato **SHORT** (R110) | SupRev | D30EUR | H4 tick | **OOS 29** | `[NON MISURATO]` | **1,290** | 3,60% | `NON MISURABILE (n 29)` — *"non misurabile per criterio"* | 26/08/2026 | `R110_REFERTO.md` r.28 · `CORSIA_DEMO_CANDIDATI.md` r.320 |
| A92 | `ABTG_PTE` **USDJPY 771323** — **SPENTA** | PTE | USDJPY | H1 | `[NON MISURATO]` | **1,08** (R103, 6,5 anni; **3/7 anni negativi**) | `[FINESTRA UNICA]` | 🔴 **11,5%** (fuori muro) | `RISCHIO/DD` → `EDGE/PF` (R77/R78 su 13 anni: **1 cella positiva su 14**) | **24/08/2026** | `risultati_archivio/R103_REFERTO_FINALE.md` pos.17 · `CORSIA_DEMO_CANDIDATI.md` r.221 |
| A93 | `ABTG_CostToCost` **XAGUSD 772363** — **SPENTA** | CostToCost | XAGUSD | `[NON DICHIARATO]` | `[NON MISURATO]` | **0,70** (profit −11.701; **6/7 anni negativi**) | `[FINESTRA UNICA]` | 🔴 **16,4%** | `RISCHIO/DD` → `EDGE/PF` | **24/08/2026** | `R103_REFERTO_FINALE.md` pos.24 · `CORSIA_DEMO_CANDIDATI.md` r.223 |
| A94 | `ABTG_EasyTrend` **AUDJPY 772423** — **SPENTA** | EasyTrend | AUDJPY | `[NON DICHIARATO]` | `[NON MISURATO]` | **1,01** | `[FINESTRA UNICA]` | 🔴 **15,9%** | `RISCHIO/DD` (+ famiglia bocciata in portafoglio, R49: *"alza TUTTE le code"*) | **24/08/2026** | `R103_REFERTO_FINALE.md` pos.19 · `CORSIA_DEMO_CANDIDATI.md` r.224 · `ROBUSTEZZA.md` r.26 |
| A95 | `ABTG_Apertura_Marco` **770301** — **SPENTA** | Aperture (Marco) | D30EUR | M5 | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (DOPPIONE ESATTO)`**: stesso trade allo stesso secondo di `DAX_Apertura_EU`, 2%+2% = **4% su un segnale**; il 06/08 −205,92 insieme al gemello | **~06-07/08/2026** | `report/A1_A4_rischio_immediato.md` · `CORSIA_DEMO_CANDIDATI.md` r.227 |
| A96 | `ABTG_SondaRsiEmaV8` — **RSI+EMA V8** (origine: Pine anonimo) | Incroci EMA | NASUSD · U30USD · D30EUR (+ ORO) | M5 · M15 | 7 corse, 21 mesi | il filtro RSI toglie **solo il 9-13%** degli incroci EMA(5/20) | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` (è un incrocio di medie travestito) → **`RISCHIO/DD`** (a taglia di flotta **19,5% M5 / 8,45% M15** di rischio aperto contro cap **3,25%**) | **03/09/2026** | `REGISTRO_TEST.md` r.809 · `risultati_archivio/REFERTO_SONDARSIEMAV8_2026-09-03.md` |
| A97 | `ABTG_SondaM0PB` — **M0PB** (origine: Marcns, TradingView, MPL 2.0) | Momentum pull-back | U30USD · NASUSD · D30EUR | M5 · M15 | 12 celle, **zero ordini** (contatore puro) | `[NON MISURATO]` — la sonda non apre ordini | `[NON MISURATO]` | `[NON MISURATO]` | **`FREQUENZA`** (F1 **0/12**, miglior lato **0,52 segn./gg** contro 1,00) + `ALTRO (RR: 7/12 sotto 0,70)` — 🎣 **riaperto 08/09** (F1 decaduta con la firma del 07/09; 5 celle passano H8 = **1,516 op/g di famiglia**) | **31/08/2026**, rilettura **08/09/2026** | `REGISTRO_TEST.md` r.789 · `risultati_archivio/REFERTO_SONDAM0PB_2026-08-31.md` · `RIPESCAGGIO_FREQUENZA` §2 R5 |
| A98 | `ABTG_OpeningReversalB` | Fade del drive d'apertura | U30USD | M5 | 🔴 **IS 2 · OOS 0** | **1,82619** (su 2 trade = rumore) | **0** | **0,9588%** | **`FREQUENZA`** (0,0078 op/g = **128× sotto** il pavimento) → `NON MISURABILE (n=2)` | **08/09/2026** | `report/P0_OPENINGREVERSALB_2026-09-08.md` |
| A99 | `ABTG_LVNArbitro` (origine: TradingView `j35ygZIm`, MPL 2.0) | LVN rejection/acceptance | U30USD | M30 tick | **IS 392 / OOS 618** (1.010 tot., **1,57 op/g**) | **0,97856** @10k · **0,97485** @100k | **1,05108** @10k · **1,05227** @100k | 🔴 **18,01 / 11,33** @10k · **19,35 / 11,76** @100k | **`RISCHIO/DD`** (sfonda il muro 10% a **entrambe** le taglie) → `EDGE/PF` (due finestre di segno opposto, PF a ridosso di 1) | **08/09/2026** | `report/P0_LVNARBITRO_2026-09-08.md` |
| A100 | `ABTG_IBRetest` **magic 772900** (origine: *IB Completed*, TradingView `Z1CwMI6V`) | IB retest | U30USD · NASUSD · D30EUR | M30 tick | **95 · 84 · 165** (famiglia **344**) | **0,38242 · 0,56297 · 1,21062** — famiglia **0,7356** (n 135) | **0,69663 · 0,59292 · 0,96493** — famiglia **0,8124** (n 209) | **7,61 · 5,31 · 5,25** (max) | **`EDGE/PF`** (cancello **C0**: n≥150 + PF<1,10 nella finestra peggiore) → **`FREQUENZA`** (0,78 op/g di famiglia contro 1,00) | **09/09/2026** | `REGISTRO_TEST.md` r.1831+ · `report/P0_IBRETEST_2026-09-09.md` · `report/P0_IBRETEST_NASUSD_2026-09-09.md` |
| A101 | `ABTG_GapFill` **772234** U30USD | GapFill | U30USD | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`RISCHIO/DD` di portafoglio** (esclusa da R37 per il **cumulo del lunedì**) ⚠️ fa **0,069 op/g**: *sembra* frequenza **e non lo è** | R37 | `report/CENSIMENTO_CONTRATTI.md` r.150 · `RIPESCAGGIO_FREQUENZA` §4.1 |
| A102 | `ABTG_BreakoutCorso` | Breakout del corso | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | **R12: 48/48 OOS negative** | **0/48** (R45) | `[NON MISURATO]` | `EDGE/PF` (duplica famiglie già sepolte) | 03/09/2026 (censimento) | `report/GIACIMENTO_DI_CASA_2026-09-03.md` §6-7 · `CORSIA_DEMO_CANDIDATI.md` r.274 |
| A103 | `ABTG_PointBreak` | Point Break | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | **R60 (12/12 bocciate)** | `[FINESTRA UNICA]` | `[NON MISURATO]` | `EDGE/PF` | 03/09/2026 | `GIACIMENTO_DI_CASA_2026-09-03.md` · `CORSIA_DEMO_CANDIDATI.md` r.274 |
| A104 | `ABTG_SuperFilter` | Filtro appiccicato | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `ALTRO (filtro appiccicato: 0 successi su 5 in casa)` | 03/09/2026 | `GIACIMENTO_DI_CASA_2026-09-03.md` · `CORSIA_DEMO_CANDIDATI.md` r.275 |
| A105 | `ABTG_DaxValueArea` | Value Area | D30EUR | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `ALTRO (morto su due gambe: tick-volume su CFD + fade dei bordi R42/R60)` | 03/09/2026 | `GIACIMENTO_DI_CASA_2026-09-03.md` §6-7 · `CORSIA_DEMO_CANDIDATI.md` r.276 |
| A106 | `BULGE_MASTER` + **14 file di classe 5** del giacimento | magazzino | vari | vari | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `ALTRO (duplicano famiglie già sepolte: 5 sono ORB/breakout, BULGE_MASTER è fade Bollinger R108/R111)` — *"Nessuno merita spesa"* | **03/09/2026** | `GIACIMENTO_DI_CASA_2026-09-03.md` §6-7 · `CORSIA_DEMO_CANDIDATI.md` r.277-279 |
| A107 | `ABTG_SupertrendInvert` | SupertrendInvert | oro / vari | H1 | 🔴 **0-2 trade** | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`BACO/NON GIRATA`** (*"non opera"*) → `NON MISURABILE` | **10-11/08/2026** | `HANDOFF.md` r.1810 · `report/PULIZIA_VPS_10-08.md` |
| A108 | `ABTG_WOL` | WOL | vari | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (profitti da spread — artefatto, non edge)`** | **10-11/08/2026** | `HANDOFF.md` r.1810 · `PULIZIA_VPS_10-08.md` |
| A109 | `ABTG_OutOfNoise` (porting Zarattini-Aziz-Barbon) | Momentum intraday | NASUSD | M15 | 🔴 **n = 0 su 3 celle** | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`BACO/NON GIRATA`** (`CopyRates(...,0,need,r)` conta barre di **calendario** invece che di **seduta** → `nDays` 4-5 contro `InpConeMinDays=14`) — **corretto in v1.01/v1.02 e MAI RIGIRATO** | **29/08/2026** | `risultati_archivio/REFERTO_PASSO0_OUTOFNOISE_2026-08-29.md` · `CORSIA_DEMO_CANDIDATI.md` r.289 |
| A110 | `ABTG_TurnaroundTuesday` / famiglia **stagionali** (R63) | Stagionali | vari | D1 | **11.928 operazioni** | `[NON MISURATO]` | **0/24 celle OOS** | `[NON MISURATO]` | `EDGE/PF` | **R63** | `report/CACCIA_M30_INDICI_2026-09-08.md` §5.3 · `REGISTRO_TEST.md` §CACCIA ORO |
| A111 | `ABTG_DAX_Apertura_EU` — **motore RETEST** (`InpEntryMode=RETEST`) | Aperture | D30EUR · NASUSD · U30USD | M5 tick | `[NON MISURATO]` | `[NON MISURATO]` | Dow **1,30→0,94** · Nasdaq **0,73** · DAX **0,79** | Nasdaq **27%** | `EDGE/PF` → `RISCHIO/DD` — *famiglia breakout (stop+limit) ELIMINATA per DAX/Nasdaq* | ~07-08/2026 | `HANDOFF.md` r.1680 |
| A112 | `ABTG_DAX_Apertura_EU` — **motore RANGE-FADE** | Aperture | D30EUR | M5 tick | 136 combo | `[NON MISURATO]` | **PFmed 0,73** · **0 combo su 136 sopra PF 1** (max 0,94) | **23,5% mediano** | `EDGE/PF` → `RISCHIO/DD` | ~07-08/2026 | `HANDOFF.md` r.1681 · `risultati_archivio/DAX_Apertura/ANALISI_MOTORI_DAX_M5.md` |
| A113 | **R46** — struttura "TP 3R secco" sul DAX | Aperture | D30EUR | M5 | `[NON MISURATO]` | **1,54** (+48.904, **la migliore**) | 🔴 **0,88** (−14.343, **la peggiore**) | **22,5%** | `EDGE/PF` (ribaltamento da **63.000 €**) → `RISCHIO/DD` | **R46** | `report/ROBUSTEZZA.md` r.21 |
| A114 | **R44** — target 2×/3× sul Dow | Aperture | U30USD | M5 | `[NON MISURATO]` | **1,955** (da 1,66) | `[NON MISURATO]` | **10,8-11%** (da 9,92%) | `RISCHIO/DD` (cancello bocciato) | **R44** | `ROBUSTEZZA.md` r.22 |
| A115 | **R51** — la "cella di riserva" | Aperture | `[NON DICHIARATO]` | M5 | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | pegg. giornata **da −1,07% a −2,06%** | **`MURO GIORNALIERO`** | **R51** | `ROBUSTEZZA.md` r.25 |
| A116 | **R30** — Supporti/Resistenze (20° ribaltamento) | S/R | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `EDGE/PF` (ribaltamento IS→OOS) | **R30** | `HANDOFF.md` r.1642 `[1 fonte]` |
| A117 | **R49** — `EasyTrend` in portafoglio | EasyTrend | AUDJPY + flotta | `[NON DICHIARATO]` | `[NON MISURATO]` | promossa **da sola** | `[NON MISURATO]` | *"alza **TUTTE** le code"* | `RISCHIO/DD` di portafoglio | **R49** | `ROBUSTEZZA.md` r.26 |
| A118 | `ABTG_HARSI` | HARSI | EURUSD | M5 | 🔴 **nessuna misura in archivio** | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`BACO/NON GIRATA`** (*"scan da fare"* dal 02/08, staccato nella pulizia VPS del 10/08) | 10/08/2026 | `FLOTTA_ATTIVA.md` r.53 · `CORSIA_DEMO_CANDIDATI.md` r.299 · `PULIZIA_VPS_10-08.md` |
| A119 | `ABTG_FvgRetest` **magic 775501** | FVG / SMC | D30EUR | M15 (H4 in un'altra fonte) | `[NON MISURATO]` ⚠️ | `[NON MISURATO]` ⚠️ | `[NON MISURATO]` ⚠️ | ⚠️ **42,9%** in `HANDOFF.md` r.611-612 — **contraddetto da 3 file** | 🔴 **CONTRADDIZIONE APERTA** — vedi §CONTRADDIZIONI C1. Cancello dichiarato in HANDOFF: `RISCHIO/DD`; negli altri tre: **nessun verdetto, mai misurato** | HANDOFF: **29/08/2026** · gli altri: 03/09 · 07/09 · 08/09 | `HANDOFF.md` r.610-612 **contro** `GIACIMENTO_DI_CASA_2026-09-03.md` r.71, `CORSIA_DEMO_CANDIDATI.md` r.290, `CORSIA_DEMO_CANDIDATI_v2.md` r.240 |

> ### 🧾 NOTA SULLE 3 RIGHE CHE **NON** SONO SCARTI E QUI NON SONO CONTATE
> `ABTG_GapContinuation` **774101** (in campo dal 16/08), le **5 sedie
> `ABTG_GapFill` 772231-235** (SOSPESE per campione, non scartate) e i **lati di
> sedie vive** (EMADOW short PF OOS **1,891** n 302 DD 2,66%, SupRev NAS H1
> short, SupRev DAX H4 short) stanno in `CORSIA_DEMO_CANDIDATI.md` §5 come
> **fuori perimetro**. Le nomino perché altrimenti qualcuno le rimette in lista
> domani. Fonte: `CORSIA_DEMO_CANDIDATI.md` r.315-323 · `R110_REFERTO.md` r.34.

---

# 🌐 SEZIONE B — CANDIDATI **ESTERNI** (trovati sul web, **mai** portati a un `.mq5`)

| # | Motore / EA | Famiglia | Simbolo/i | TF | n operazioni | PF IS | PF OOS | DD max % | 🚪 CANCELLO CHE HA UCCISO | Data verdetto | File di riferimento |
|---:|---|---|---|---|---|---|---|---|---|---|---|
| B1 | **Artemis NAS100 ORB Edge EA** (Nathan James Gilks, MQL5 Market 179855, 59 USD) | ORB | NAS100 | M5 | `[NON MISURATO]` — 0 signals, 0 subscribers | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (CANCELLO ACQUISTI gradino 2: Recovery Ladder 3 layer, lotto ×1,2 — dichiarata dall'autore)`** + fuso a 2 ore da BCM + venditore con 19 prodotti in 77 giorni | **22/08/2026** | `report/DOSSIER_EA_NASDAQ_ESTERNI_2026-08-21.md` r.460-495 · `report/ARTEMIS_NAS100_ORB_2026-08-21.md` |
| B2 | **Master Nasdaq FTMO MT5** v4.6 (Yudi Sri Warsito, MQL5 Market 111837, 60 USD) | paniere 10 strategie | NAS100 | H1-D1 misti | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (architettura: fino a 20 posizioni simultanee, il nostro cap C1 3,25% e il Guardian NON possono intervenire)`** + **firma dell'ottimizzatore** (5 blocchi = stesso template con TF/ATR adiacenti) + 4 indicatori aggiunti e rimossi = *filtro appiccicato, 0 successi su 5* | **22/08/2026** | `DOSSIER_EA_NASDAQ_ESTERNI_2026-08-21.md` r.497-522 · `report/MASTER_NASDAQ_FTMO_2026-08-21.md` |
| B3 | **DIEGO_Nasdaq_Bands_Indicator** (autore ignoto) | ORB | NAS100 | M5 | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (provenienza informale: nessuna traccia web, autore ignoto, licenza ignota; ed è INDICATORE, non EA)`** — *"l'idea era già nostra"* | **22/08/2026** | `DOSSIER_EA_NASDAQ_ESTERNI_2026-08-21.md` r.524-529 · `report/INDICATORE_DIEGO_NASDAQ_2026-08-21.md` r.238 |
| B4 | **Range Breakout EA with Range Filters** (Jimmy Peter Eriksson, MQL5 Market 122237) | Breakout range asiatico | XAUUSD·USDJPY·BTCUSD·US30·DE40 | `[NON DICHIARATO]` | **1.876 operazioni** su 13 signals / 92 settimane `[DICHIARATO DALL'AUTORE]` | `[NON MISURATO]` | `[NON MISURATO]` | 🔴 **25,53% sul saldo** (dal **suo stesso signal**) — **2,5× il muro del 10%** | **`RISCHIO/DD`** → `ALTRO (fuso GMT+2/3 obbligatorio contro BCM GMT+1; parametri chiusi dalla v2.10 → nessuna superficie IS/OOS leggibile)` | **22/08/2026** | `report/RANGE_BREAKOUT_ERIKSSON_2026-08-21.md` r.565-600 |
| B5 | **Prop Firm Gold EA** (Jimmy Peter Eriksson, MQL5 Market 153540, 399 USD) | Oro | XAUUSD | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **18,43%** (suo signal, Sharpe 0,09) | **`ALTRO (il changelog v1.87/v1.94 dichiara di modificare lotti/orari/stop/suffissi per "evitare la rilevazione dei sistemi delle prop firm")`** → `RISCHIO/DD` (18,43% > 10%; rischio dichiarato 1,5/3/4,5% per operazione contro il nostro 0,65%) → `ALTRO (nessun filtro news; fuso GMT+2/3)` | **22/08/2026** | `report/PROPFIRM_GOLD_ERIKSSON_2026-08-21.md` r.555-600 |
| B6 | **GoldEdge Spark** v3.4 (Chi Sang Lai, MQL5 Market) | griglia / averaging | USDCHF·USDJPY·CADJPY·NZDJPY | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | 🔴 **47,88% bilancio / 79,98% equity** (signal linkato dal venditore) · previsione annua **−100%** · MQL5 marchia *"absence of risk limitation"* | **`ALTRO (CANCELLO ACQUISTI gradino 2: "grid-style entries", hedging/averaging, Basket+AutoLot dichiarati)`** → `RISCHIO/DD` → `ALTRO (nessuno SL vero, nessun filtro news, nessun cap giornaliero)` | **22/08/2026** | `report/GOLDEDGE_SPARK5_2026-08-22.md` r.744-775 |
| B7 | **PS5 ORB BOT** v2.60 (Marco Garbuglia, documento master) | ORB | indici | `[NON DICHIARATO]` | `[DICHIARATO, senza allegati]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `ALTRO (rango 4 — dichiarazione singola: nessun .htm, nessun CSV, nessun .set, nessuno screenshot; forward reale finito **in perdita**)` — **niente qui chiude una nostra riga, una la APRE** | **06/09/2026** | `report/ANALISI_STUDIO_PS5_ORB_2026-09-06.md` §0-1 |
| B8 | **Manuale «ALTA VELOCITÀ»** (Manuela Negro, 38 pp.) | Ciclico + Williams%R + RSI | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `ALTRO (non è materiale nuovo: è la fonte del capitolo già chiuso l'11/08 — il porting di casa `ABTG_AltaVelocita` è **rosso 8/8 a tick**, riga A66)` + **zero parametri nuovi**, 7 incoerenze interne | **06/09/2026** | `report/ANALISI_MANUALE_ALTAVELOCITA_2026-09-06.md` §0 |
| B9 | **`RSI Ea MT5`** (Code Base **59303**) | RSI di coda | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`FREQUENZA`** — testuale: *"SCARTO PER FREQUENZA, e NON per difetto: è il codice meglio scritto dei sette"* (`MaxOpenPositions=1` + grilletto di coda RSI(14)) — 🎣 **riaperto 08/09** | **02/09/2026** | `caccia_strategie/CACCIA_FREQUENZA4_CB_PAPER_2026-09-02.md` §4.1 S4 · `RIPESCAGGIO_FREQUENZA` §2 R6 |
| B10 | **`Power Hour Money Strategy`** | 1 trade/giorno | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`FREQUENZA`** (C2 fallita *per definizione*) — 🔴 **sorgente MAI aperto** — 🎣 riaperto 08/09 | **02/09/2026** | `CACCIA_FREQUENZA4_GH_TV_FF_2026-09-02.md` §4.4 · `RIPESCAGGIO_FREQUENZA` §2 R7 |
| B11 | **`ICT Opening Gap Strategy [Momentum1]`** | gap d'apertura | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`FREQUENZA`** (1 occasione/giorno) — 🔴 *"scaricato ma NON letto riga per riga, e lo dichiaro"* — 🎣 riaperto 08/09 | **03/09/2026** | `CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md` §5.6 · `RIPESCAGGIO_FREQUENZA` §2 R7 |
| B12 | **`IU Gap Fill Strategy`** | gap fill | indici | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`FREQUENZA`** (1 gap/giorno, filtrato a `pec_gap=0,2%`) — 🎣 **riaperto 08/09**, il pezzo che vale è **l'ingresso alla riconquista confermata** | **03/09/2026** | `CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md` S18 · `report/CACCIA_APERTURE_ORO_2026-09-08.md` §3 |
| B13 | **`Gap Filling Strategy`** (S17) | gap fill | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (NESSUNO STOP)`** — muore al §4, non per la frequenza | **03/09/2026** | `CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md` S17 · `RIPESCAGGIO_FREQUENZA` §2 R7 |
| B14 | **`ORB Heikin Ashi SPY 5min Correlation`** (2.305 like) | ORB | SPY | M5 | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | motivo **SCRITTO**: `FREQUENZA` · motivo **VERO**: `EDGE/PF` — famiglia ORB/breakout chiusa da **~210 celle a tick** (R45 0/48, R12 48/48 OOS negative). 🟡 **l'etichetta va riscritta** | 02/09/2026, rilettura 08/09/2026 | `CACCIA_FREQUENZA4_GH_TV_FF_2026-09-02.md` §4.4 · `RIPESCAGGIO_FREQUENZA` §3.2 |
| B15 | **`Mou Value Areas`** | value area | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | motivo **SCRITTO**: `FREQUENZA` · **VERO**: `EDGE/PF` (value area morta su due gambe in casa: tick-volume su CFD + fade dei bordi R42/R60) | 02/09, rilettura 08/09/2026 | idem |
| B16 | **`Previous Day High Low only for Long`** | livello di giornata | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | motivo **SCRITTO**: `FREQUENZA` · **VERO**: `EDGE/PF` (rottura di livello di giornata) + `ALTRO (un lato solo senza ragione strutturale, C7)` | 02/09, rilettura 08/09/2026 | idem |
| B17 | **`VWAP Touch (Rolling Prev-VWAP)`** `4JD54K2I` (TV, kalvey16, 234 righe) | VWAP | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **M9 in casa: PF 1,002** (pareggio) | `[NON MISURATO]` | 🟡 **IN CODA, non scarto secco** · `EDGE/PF` (M9 già a pareggio) + `ALTRO (filtro aggiunto a motore già tarato: 0 successi su 5; calc_on_every_tick + limite = riempimento ottimista)` | **08/09/2026** | `report/CACCIA_M30_INDICI_2026-09-08.md` §5.1 r.1 |
| B18 | **`NY Session Trend Retest`** `zV6RrYm5` (TV, MPL 2.0, 705 righe) | retest VWAP | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (DOPPIONE — identico byte per byte a un file già archiviato il 30/08 e già misurato, ~0,25 op/g)`** | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.1 r.2 |
| B19 | **`Execution-Aware Trend [BSL]`** `Z9O5w3SG` (TV, 304 righe) | Donchian(20) | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (STOP VIRTUALE — cancello C3: uscita a chiusura di barra, su un broker è un SL che non esiste)`** + `EDGE/PF` (rottura di canale = famiglia sepolta) | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.1 r.3 |
| B20 | **`TriAnchor Elastic Reversion`** `vbiLfaCo` (TV, exlux, 137 righe) | reversione a VWAP ancorate | SPY/QQQ/IWM richiesti | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (il lato LONG non ha stop — bracket commentati)`** + `ALTRO (richiede SPY/QQQ/IWM che BCM non quota)` + `ALTRO (ingresso 10 barre dopo il segnale, senza ragione)` | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.1 r.4 |
| B21 | **`FlowStateTrader`** `omL7kjy0` (TV, 518 righe, 26 input) | minimo a 20 barre | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (condizione d'ingresso quasi VACUA: `ta.lowest(low,20)` include la barra corrente)`** + lotto fisso in contratti | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.1 r.5 |
| B22 | **`Channel Reversion System (CRS)`** `XRZCjbFr` (TV, 90 righe) | Donchian(50)+SMA200 | `[NON DICHIARATO]` | **D1** | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`FREQUENZA`** (l'autore: *"flat roughly 80% of the time"*) + `ALTRO (TF giornaliero, LONG-ONLY = C5)` + `ALTRO (doppione di ABTG_EMA200)` | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.1 r.6 |
| B23 | **`3 Red / 3 Green + Volatility Check`** `1v0u3Weg` (TV, 54 righe) | pattern candele | `[NON DICHIARATO]` | D1 | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (NESSUNO STOP — C3)`** + giornaliero + long-only | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.1 r.7 |
| B24 | **`Range Filter Strategy with ATR TP/SL`** `jtm3aJ4O` (TV, 56 righe) | bande | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`BACO/NON GIRATA`** (`position_avg_price` letto **prima** dell'ingresso) + `EDGE/PF` (rottura di banda = Donchian travestito) | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.1 r.8 |
| B25 | **`Sniper V4: Liquidity & Fast Exhaustion`** `72gQqAzW` (TV, 78 righe) | sweep + RSI esaurimento | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (NESSUNO STOP — C3, perdita illimitata)`** + `EDGE/PF` (**due cadaveri sommati**: M24 sweep ⬛ 3 volte + M17 RSI esaurimento ⬛) | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.1 r.9 |
| B26 | **`Volume Breakout Strategy [Tables Fixed]`** `36zwwSMa` (TV, 205 righe) | Keltner + 5 filtri | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (cinque filtri appiccicati = la forma che in casa fa 0 successi su 5)`** + `RISCHIO/DD` (**50% dell'equity per operazione con leva 2**) | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.1 r.10 |
| B27 | **`VR Breakdown level`** (Code Base **69545**, VOLDEMAR, 202 righe) | breakout nudo | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (STOP NON PRESENTE ALL'INGRESSO — C3, provato nel codice: `trade.Buy(lt)` r.79 senza sl/tp, e il ciclo che lo mette legge `PositionsTotal()` PRIMA dell'apertura)`** + lotto fisso + breakout nudo | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.2 |
| B28 | **Code Base 55630** (Mullerp04) | — | — | — | — | — | — | — | 🚨 **`ALTRO (DA NON FAR GIRARE MAI ACCANTO ALLA FLOTTA: `DeletePending()` cancella TUTTI i pendenti del terminale senza controllare il magic)`** | **04/09/2026** | `REGISTRO_TEST.md` §CACCIA NOTIZIE |
| B29 | **`003 - Weekly Day Reversal`** (dj_ermoloff, Code Base) | reversal settimanale | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **R63: 0/24 celle OOS** | `[NON MISURATO]` | `EDGE/PF` — *"ERA GIÀ MORTO, E DUE VOLTE"* (16/08 e 22/08) | **16/08 e 22/08/2026** | `report/SWEEP_MECCANISMI_LIBERI_2026-08-22.md` · `report/CACCIA_APERTURE_ORO_2026-09-08.md` r.77 |
| B30 | **`002 - Inside Bar`** (Code Base **73884**, 318 righe lette) | compressione→espansione | `[NON DICHIARATO]` | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `EDGE/PF` (famiglia L3, **0/8 sopra il pavimento**) + **`ALTRO (`balance` letto una volta in `OnInit()` = rischio % che è lotto fisso travestito; manca `OnTester`)`** — 🟠 *"codice buono"* ma già scartato due volte | **16/08 · 22/08 · 08/09/2026** | `CACCIA_APERTURE_ORO_2026-09-08.md` r.368 |
| B31 | **`10pipsOnceADayOppositeLastNHourTrend`** (Code Base **17474**) | — | forex | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `ALTRO (stesso impianto e stessa famiglia dell'autore già scartato — "senza appello")` | **08/09/2026** | `CACCIA_APERTURE_ORO_2026-09-08.md` r.354 |
| B32 | **`Sniper Gold Hybrid Recovery EA`** (Code Base **76605**, 65 input) | recovery oro | XAUUSD | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | cap interno **12%** contro muro prop **10%** | **`ALTRO (`RecoveryLotMultiplier=1.20` — gradino 2 del cancello acquisti)`** + `RISCHIO/DD` | **06/09/2026** | `REGISTRO_TEST.md` §CACCIA ORO/ARGENTO · `caccia_strategie/CACCIA_ORO_ARGENTO_MECCANISMI_2026-09-06.md` |
| B33 | **`XANDER Grid XAUUSD`** (Code Base **71776**) | griglia | XAUUSD | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (griglia bidirezionale `GridStep=390` + `AVERAGE_TP` — gradino 2)`** | **06/09/2026** | idem |
| B34 | **`Quantum XAUUSD Silver Trader`** (Code Base **73622**, 79 input) | oro/argento | XAUUSD·XAGUSD | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (79 input, sopra il tetto ~15; fratello del 63193 già scartato il 16/08)`** | **06/09/2026** | idem |
| B35 | **`GoldWarrior02b`** (Code Base **20577**) | hedge oro | XAUUSD | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (`InpMultiplier=3 // Multiplier of hedge positions` + `iCustom` non allegati + lotto fisso)`** | **06/09/2026** | idem |
| B36 | **`Session Range Desk MT5`** (Code Base **76927**, E. M. Kaynak) | range di sessione | — | — | — | — | — | — | **`ALTRO (DOPPIONE del nostro `ABTG_ORB`; l'autore stesso lo definisce "a programming example")`** | **06/09/2026** | `REGISTRO_TEST.md` §CACCIA MECCANISMI DAX/DOW |
| B37 | **`SuperTrend TV EA`** (Code Base **77009**, M. Samoiliuk) | flip SuperTrend | — | — | — | — | — | — | **`ALTRO (DOPPIONE della famiglia SupRev già viva)`** + l'autore stesso: *"backtests showed modest results due to spread costs from frequent reversals"* | **06/09/2026** | idem |
| B38 | **`XAG strategy 1h`** (@SoftKill21, TV, MPL-2.0) | argento | XAGUSD | H1 | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`BACO/NON GIRATA`** (`strategy.entry("long",1,when=short1)` — in Pine v4 il 2° argomento è il bool `long`: **i nomi sono invertiti**; **stesso difetto già verbalizzato il 28/08**) | **06/09/2026** | `CACCIA_ORO_ARGENTO_MECCANISMI_2026-09-06.md` · `REGISTRO_TEST.md` §CACCIA ORO |
| B39 | **`Gold/Silver 30m Only`** (@MtxTrader, TV) | oro/argento | XAUUSD·XAGUSD | M30 | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`BACO/NON GIRATA`** (uscita short identica alla long; ingresso short su `vrsi > 35`) | **06/09/2026** | idem |
| B40 | **`Silver Long/Short`** (@tyler747, TV) — gold/silver ratio | rapporto metalli | XAUUSD/XAGUSD | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`RISCHIO/DD` (dimensiona al 100% dell'equity, nessuno stop)** + `ALTRO (soglie GSR 60/45 cablate sull'epoca 2000-2020; il GSR ha toccato 125 nel marzo 2020)` | **06/09/2026** | idem |
| B41 | **`Aurum DCX`** (@exlux, TV) — *il meglio scritto degli 8* | oro | XAUUSD | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (28 input e CINQUE filtri impilati = l'architettura che in casa fa 0 successi su 5)`** | **06/09/2026** | idem |
| B42 | **`Gold/Silver Spread`** (@MarcoValente, TV) | "spread" metalli | XAUUSD·XAGUSD | `[NON DICHIARATO]` | — | — | — | — | **`BACO/NON GIRATA`** (`spr = (au - ag)` con oro ~2.000 e argento ~25 è **oro al 98,7%**: quel grafico chiama "spread" **il prezzo dell'oro**) | **06/09/2026** | idem |
| B43 | **`SMC Liquidity Grab Pro`** (TV, MPL 2.0) | sweep di liquidità | `[NON DICHIARATO]` | `[NON DICHIARATO]` | — | — | — | — | **`BACO/NON GIRATA`** (`barmerge.lookahead_on` = **guarda nel futuro**) | **03/09/2026** | `REGISTRO_TEST.md` §SECONDA CACCIA DOPO R116 |
| B44 | **`Falcon Liquidity Grab`** (TV, MPL 2.0) | sweep di liquidità | `[NON DICHIARATO]` | `[NON DICHIARATO]` | — | — | — | — | **`BACO/NON GIRATA`** (`low < ta.lowest(low,5)`: condizione **matematicamente impossibile**) | **03/09/2026** | idem |
| B45 | **`4H Range Scalp V3 - Smart Fakeout`** · **`Strategy_500 Turtle Soup NY V5`** · **`Gold H1 Breakout Failure`** · **`Parent Session Sweeps`** (TV, 4 candidati) | falsa rottura di box | vari | H1/H4 | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `EDGE/PF` — **sono riga per riga `ABTG_BreakinBox`** (righe A50-A51: **PF 1,007 DD 24,1%** e controllo **1,106 / 19,7%**), e su forex sarebbe **R95 0/30** | **03/09/2026** | `REGISTRO_TEST.md` §SECONDA CACCIA DOPO R116 · `caccia_strategie/CACCIA_LONDRA_ALTERNATIVA_2026-09-03.md` |
| B46 | **`DAX Breadth`** · **`DAX Universe Relative Strength`** · **`McClellan for GER30`** (TV) | ampiezza di mercato | D30EUR | `[NON DICHIARATO]` | — | — | — | — | **`ALTRO (richiedono i COSTITUENTI dell'indice, che su MT5/BCM non esistono — morti per DATI, non per idea)`** | **06/09/2026** | `REGISTRO_TEST.md` §CACCIA MECCANISMI DAX/DOW |
| B47 | **`Xetra Auctions Breakout [Box Strategy]`** (@ovvo_113, TV, 1.742 like) | asta intraday XETRA | D30EUR | M1/M5 | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `EDGE/PF` (box su finestra oraria + rottura = **ORB, ~210 celle**; box + fade = **R42, 0/24 IS e 0/24 OOS**) ⚠️ orario **[INCERTO]**, fonte primaria EGRESS_BLOCKED. 🟢 **il FATTO (asta DAX 12:00-12:02 srv) resta agli atti** | **06/09/2026** | idem |
| B48 | **`RTH Confluence`** e **`London Signal B`** (arXiv **2605.04004** §5) | confluenza / segnale Londra | MNQ | 5 min | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`BACO/NON GIRATA` (IRRIPRODUCIBILI: il cuore è un classificatore GMM che l'autore dichiara "a separate research program", mai pubblicato)** + `FREQUENZA` (**0,72 e 0,31 trade/giorno** contro il minimo di 1) | **31/08/2026** | `REGISTRO_TEST.md` §CACCIA FREQUENZA (31/08) |
| B49 | **Regime post-news 15-30 min** (lapide **L1**, arXiv 2605.04004 §4.7) | post-news | MNQ / Nasdaq | 5 min | **993 eventi** | — | T-statistiche **0,14-0,69 da barra +6** · RTH **T=0,38** · *"D127 permanently rejected — LOCKED"* | — | `EDGE/PF` ⚠️ **rettificato il 04/09: chiude dal minuto 30, NON i minuti 0-25** | **03/09**, rettifica **04/09/2026** | `REGISTRO_TEST.md` §CACCIA FREQUENZA5 e §CACCIA NOTIZIE |
| B50 | **Sweep di micro-pivot sugli indici** (lapide **L2**) | sweep | DAX e indici | M5 · M15 | **22.616 segnali** | densità OK (**4,22-4,57 segn./gg/lato**) | TP-prima-di-SL **43,5-48,2%** contro **49,6% richiesto** (**8/8 sotto**) · delta contro ingresso **CASUALE** **−0,2 punti** | — | `EDGE/PF` | **03/09/2026** | `REGISTRO_TEST.md` §CACCIA FREQUENZA5 |
| B51 | **Compressione ATR → espansione** (lapide **L3**) | volatilità | indici | M5 · M15 | **9.723 segnali** | frequenza **0,55-1,87/gg** (**0/8** sopra il pavimento) | TP-prima-di-SL **31,6-36,0%** contro 35,8% (**7/8 sotto**) · delta contro il caso **−1,2 punti** | — | `EDGE/PF` + `FREQUENZA` *(la metà "frequenza" è decaduta il 07/09 — l'altra metà no, e basta lei)* | **03/09/2026** | idem · `CORSIA_DEMO_CANDIDATI.md` r.261 |
| B52 | **Gap intraday / gap-fill** (lapide **L4**) | gap | indici | intraday | — | — | — | — | **`FREQUENZA`** (*un gap di apertura è **UNO al giorno**: nessuna implementazione può superare il pavimento di 2 segnali/giorno per lato*) — 🎣 riaperto in parte come **R2/R3** | **03/09/2026** | `REGISTRO_TEST.md` §CACCIA FREQUENZA5 |
| B53 | **Contrarian post-sovrareazione su forex/commodity** (lapide **L6**, Caporale-Plastun) | contrarian | forex/commodity | `[NON DICHIARATO]` | — | — | chiuso **dagli autori** | — | `EDGE/PF` (coerente con **R42 0/24** in casa) | **03/09/2026** | idem |
| B54 | **M31 · Salto statistico** (Lee-Mykland, *RFS* 21(6) 2008) — gamba **M5** | salto statistico | EURUSD · D30EUR | M5 | 16 celle | lordo da **−0,011R a +0,0922R** | **16 celle su 16 sotto il cancello**; netto a 1 pip **sempre negativo** (miglior −0,033R) | — | **`COSTO C3`** (il pedaggio M5 vale **1,1-1,7 volte** l'intero cancello H8) → `EDGE/PF` | **05/09/2026** | `REGISTRO_TEST.md` §CACCIA TF M5 · `caccia_strategie/CACCIA_TF_M5_2026-09-05.md` |
| B55 | **M31 · Salto statistico** — gamba **M15** | salto statistico | D30EUR · SPXUSD · EURUSD | M15 | 2,0σ: **1,34 segn./gg/lato** · 4,5σ: **~88 op su tutto il banco** | 2,0σ: E netta **−0,036R** | 4,5σ: E netta **+0,104R** ma **0,10 segn./gg/lato** | — | **`NON MISURABILE (n troppo basso)`** (*la cella con l'edge non ha campione, quella col campione non ha edge*) + **`COSTO C3`** (S0 **1,93-2,28** contro 2,5) | **05/09/2026** | `caccia_strategie/CACCIA_TF_M15_2026-09-05.md` · `REGISTRO_TEST.md` §CACCIA M15 |
| B56 | **Il FADE del salto** (contro-tesi di M31) | salto statistico | indici + forex | M15 | 9 celle | — | perde contro il controllo casuale in **9 celle su 9** (da −2,6 a −8,6 punti); RR mediane 0,76-0,92 contro 1,09-1,32 della continuazione | — | `EDGE/PF` ⚠️ **contraddice l'ipotesi scritta il 03/09** (*"il salto senza notizia è quello dove il rientro è più probabile"*): sui nostri strumenti il salto **CONTINUA** | **05/09/2026** | `CACCIA_TF_M15_2026-09-05.md` |
| B57 | **M25 · Lead-lag direzionale S&P → DAX** | lead-lag | SPXUSD → D30EUR | M5 | 8 celle | — | **8 celle su 8 negative al netto**; depurata la monetina, l'informazione direzionale è **−0,003R / +0,013R = zero** | — | `EDGE/PF` — 🎯 **la frequenza PASSAVA** (2-7 segnali/giorno): conferma diretta di H8, *"la frequenza da sola non è un merito"* | **05/09/2026** | `CACCIA_TF_M5_2026-09-05.md` |
| B58 | **M11 · Fix valutari** (Krohn-Mueller-Whelan, *JF* 79(1) 2024) | fix WMR/ECB/Tokyo | EURUSD | M5 | quintili su 3 fix | il **meccanismo è VERO** (WMR 15:59 Londra = **1,34-1,45× il fondo**; segno pre-registrato azzeccato, **monotono su 5 quintili**) | quota di rientro **0,038-0,082** → **il FADE non esiste**; cella buona **1,90 pip** contro cancello 3,0 | — | `EDGE/PF` (F3) + **`FREQUENZA`** (**0,2 eventi/giorno** contro pavimento 2,00) | **05/09/2026** | `CACCIA_TF_M5_2026-09-05.md` · `REGISTRO_TEST.md` §CACCIA TF M5 |
| B59 | **M23 · Numeri tondi** (Osler, *JF* 2003 / *JIMF* 2005) | livelli psicologici | forex | M5 | **93.000+ segnali** | R1/R3/R5 passano (3,04 / 6,07 / 31,05 tocchi al giorno) | delta contro controllo **APPAIATO** da **−1,50 a +0,90 punti**, **5 letture su 6 negative** | — | `EDGE/PF` (il 55-57% di "rimbalzi" è un artefatto della definizione) | **05/09/2026** | `CACCIA_TF_M5_2026-09-05.md` |
| B60 | **Asta LBMA sull'oro** (fixing 10:30 e 15:00 Londra) | asta oro | XAU_USD | M5 | 72 celle, 9 anni | — | 🔴 **72 celle su 72 NEGATIVE**, fade **E** continuazione; in **68 su 72** gli anni positivi sono 0 o 1 su 9 | — | `EDGE/PF` ⚠️ e qui è stato preso **un look-ahead da 0,60 R** (la cella passa da +0,3930R a −0,2043R correggendo `j`→`j+1`) | **06/09/2026** | `REGISTRO_TEST.md` §CACCIA ORO/ARGENTO · `CACCIA_ORO_ARGENTO_MECCANISMI_2026-09-06.md` |
| B61 | **Oro ← dollaro** (disegno C con driver EUR_USD) | lead-lag | XAU_USD | M5 | 9 anni | verso della tesi **−0,3447 $/evento, t −6,31, PF 0,718, 0 anni positivi su 9** | verso contrario **−0,1553 $, t −2,85** | — | `EDGE/PF` — *"vero come correlazione, falso come segnale operabile"* | **06/09/2026** | idem |
| B62 | **Lead-lag bond → oro** (USB10Y → XAU) | lead-lag | XAU_USD | M5 / D1 | **n 2.210** | **+0,3219 $/evento · t +4,12 · PF 1,303 · 8 anni su 9** — e **passa la sua falsificazione** | con SL/TP veri e costo 0,25 $: **54 celle, 0 promosse**; migliore **+0,0201R** contro cancello **+0,075R** (positiva 3 anni su 9). Scala D1: **90 celle, 0 a t≥2,0** | — | **`COSTO C3`** — *"un edge che non copre il costo non è un edge più piccolo: è zero"* ⚠️ **il verdetto si ribalta sullo spread oro BCM, che NON è mai stato misurato** | **06/09/2026** | idem |
| B63 | **Fade post-notizia** | post-news | EURUSD · XAU_USD | M5 | 686 / 683 giornate-evento | ISM: **PF 0,85 (t −1,26)** EURUSD e **0,73 (t −2,41)** oro | 13:30: PF **1,10** contro controllo casuale **1,06** (EURUSD) e **1,08** contro **1,11** (oro, cioè **peggio del caso**) | — | `EDGE/PF` — *"invertire una strategia perdente non è un meccanismo nuovo"* | **05/09/2026** | `REGISTRO_TEST.md` §SECONDA CACCIA POST-NEWS · `caccia_strategie/CACCIA_POSTNEWS_MECCANISMI_2026-09-05.md` |
| B64 | **Liquidity sweep sul range della notizia** | post-news | EURUSD · XAU_USD | M5 | idem | ISM **PF 0,86** (4/11 anni) | 13:30 **PF 1,18** contro casuale 1,06, **tutto fatto nel 2010-2012** | — | `EDGE/PF` — **terzo giro sulla stessa geometria** (BreakinBox + R95 0/30) | **05/09/2026** | idem |
| B65 | **Uscita a tempo 30' post-news** | post-news | EURUSD | M5 | **n 371** (73 + 298) | 2010-2011 (n 73): **+7,87 pip, PF 3,14** | 2012-2020 (n 298): **+0,36 pip, t 0,61, PF 1,12** → **0,014R contro il cancello 0,075R NETTI** | — | `EDGE/PF` (**l'84% del profitto dal 20% del campione, e sono i due anni più vecchi**) — *prova dell'epoca* | **05/09/2026** | idem |
| B66 | **M27 · Deriva overnight contro deriva intraday** (Knuteson arXiv 2010.01727; Lou-Polk-Skouras *JFE* 134(1) 2019) | overnight | indici | D1 | **mai girato** | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`FREQUENZA`** (C2 fallita *per definizione*: 1/giorno contro ≥2/giorno/lato delle cacce) — 🎣 **riaperto 08/09**, è **l'unico dei sette che supera il pavimento anche a unità vecchia** | **03/09/2026**, rilettura 08/09 | `caccia_strategie/CACCIA_FREQUENZA5_TASSONOMIA_2026-09-03.md` §M27 · `RIPESCAGGIO_FREQUENZA` §2 R4 |
| B67 | **M10 · Deriva oraria del forex** (EURUSD SHORT 08:00-16:00 srv, Breedon-Ranaldo) | deriva oraria | EURUSD | oraria | **IS 1.607 / OOS 2.411** | **C1 4,59** (IS +32,13 punti) | **C1 5,31** — **passa il cancello su ENTRAMBE le finestre, campione pienissimo** | `[NON MISURATO]` (non esiste un EA, non esiste uno SL) | 🟡 **NON DECIDIBILE**: il motivo scritto (`FREQUENZA`/C2) è **decaduto il 07/09**; quello che regge è **`COSTO C3`** — ma **lo spread forex BCM non è mai stato misurato** (riga H12) | **03/09/2026**, rilettura 08/09 | `risultati_archivio/OROLOGIO_VS_BREEDON_2026-09-03.md` · `RIPESCAGGIO_FREQUENZA` §3.1 |
| B68 | **M30 · pre-FOMC su M30** | macro | indici | M30 | ~8 eventi/anno | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`FREQUENZA`** *(C2 fallita di due ordini di grandezza)* — **resta fuori anche da FAMIGLIA**: 8/anno × 3 simboli ≈ **0,10 op/g** | **03/09/2026** | `CACCIA_FREQUENZA5_TASSONOMIA_2026-09-03.md` §M30 · `RIPESCAGGIO_FREQUENZA` §3.3 |
| B69 | **BoE Official Bank Rate** | macro news | GBP | `[NON DICHIARATO]` | **n 130 in 14 anni** (8/anno) | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`NON MISURABILE (n troppo basso)`** — 🔴 scritto come *"frequenza fatale"*, ma **è la regola del campione (IS ≥150), non il pavimento**: etichetta da riscrivere | **04/09/2026** | `caccia_strategie/CACCIA_POSTNEWS_ALTRE_FAMIGLIE_2026-09-04.md` §5 · `RIPESCAGGIO_FREQUENZA` §3.3 |
| B70 | **BoC Interest Rate** | macro news | CAD | `[NON DICHIARATO]` | 8/anno | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `NON MISURABILE (n troppo basso)` — *"orario buono, frequenza no"*, etichetta da riscrivere | **04/09/2026** | idem |
| B71 | **RBNZ** | macro news | NZD | `[NON DICHIARATO]` | 7/anno | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `NON MISURABILE (n troppo basso)` | **04/09/2026** | idem |
| B72 | **SNB** | macro news | CHF | `[NON DICHIARATO]` | **3,8/anno** (*"con ≥150 op per finestra servirebbero ~40 anni"*) | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `NON MISURABILE (n troppo basso)` — **il testo lo dice già bene** | **04/09/2026** | idem |
| B73 | **RBA** | macro news | AUD | `[NON DICHIARATO]` | 8/anno | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `NON MISURABILE (n troppo basso)` + **`ALTRO (ora server NON fissa — difetto d'orario misurato)`** | **04/09/2026** | idem |
| B74 | **Spike & Fade** (Ederington & Lee, *JFQA* 30(1) 1995) | post-news | futures FX/tassi | **sotto M5** (40 secondi) | 1988-1992 | — | — | — | **`ALTRO (orizzonte 40 secondi: sotto il nostro TF e DENTRO la finestra vietata FTMO ±2 min)`** ⚠️ paper **NON aperto**, citazione da snippet **[INCERTO]** | **03/09/2026** | `caccia_strategie/CACCIA_CANDELA_NEWS_2026-09-03.md` |
| B75 | **"Momentum candle continuation"** (il colore della 1ª candela predice le successive) | pattern candele | — | — | — | — | — | — | **`ALTRO (NON è un meccanismo bocciato: è un meccanismo che NON ESISTE da leggere)`** — arXiv 3 query, Quantpedia, ricerca generale: **solo folklore retail** | **03/09/2026** | idem |
| B76 | **QuantConnect** — `Combining Mean Reversion and Momentum in Forex` · `Dual Thrust` | portafoglio | forex | mensile / D1 | ~1-2 trade/mese | — | — | — | **`FREQUENZA`** + **`ALTRO (NESSUNO STOP in entrambe; ribilancio di PORTAFOGLIO, non traducibile)`** | **31/08/2026** | `caccia_strategie/CACCIA_FREQUENZA2_2026-08-31.md` |
| B77 | **Quantpedia** — `turn-of-the-month` · `pre-holiday-effect` · `overnight anomaly` · `mean-reversion in country equity indexes` (**82 slug spazzolati**) | stagionali / cross-sezionali | azioni/indici | mensile | 1 operazione al mese = **1/20 del pavimento** | — | — | — | **`FREQUENZA`** + `ALTRO (panieri su centinaia di titoli: noi abbiamo 4 indici, non 3.000 azioni)` | **08/09/2026** | `report/CACCIA_APERTURE_ORO_2026-09-08.md` r.399 |
| B78 | **Famiglia "JOAT"** (`Precision Edge`, `Quant Synthesis`, `Vantage Protocol`, `Concordance ×4`, `Helios`, `Aureate`, `Charter`, `Bastion`, `Tectonic`, `Fracture`, `Sovereign`, `Caldera`, `APEX V2`, `CryptoFlux`, `Liquidity Maxing`) — **17 titoli, 1 famiglia** | mashup | — | — | — | — | — | — | **`ALTRO (stesso autore, nomi diversi, nessuna tesi in una riga ricavabile dalla scheda)`** — sorgente **non aperto, dichiarato** | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.3 |
| B79 | **SHORT-ONLY di Botnet101** (`10-Bar Low Pullback`, `Consecutive Close High`, `Consecutive Bars Above MA`, `ATR Sell the Rip`) — **4** | short-only | SPY/QQQ | D1 | — | — | — | — | **`ALTRO (giornalieri su SPY/QQQ = strumenti fuori perimetro, C1)`** + **`ALTRO (senza stop, C3)`** | **08/09/2026** | idem |
| B80 | **Griglie / DCA dichiarate nel titolo** (`AliceTears Grid`, `Continuous Market Grid bot`, `3Commas ×2`, `Adaptive S-R Reversal DCA`, `TRADLEWARE DCA`, `OrangePulse DCA`, `dca-martingale strategy`, `AUTOMATIC GRID BOT`) — **9** | griglia/martingala | — | — | — | — | — | — | **`ALTRO (§4 del cancello acquisti, senza appello)`** | **08/09/2026** | idem |
| B81 | **Cripto / azionario indiano / ETF-only** (BANKNIFTY, LINKUSDT, ETHUSD, ONEUSDT, BTC, INTC, SPY-solo…) — **~22** | — | strumenti non quotati | — | — | — | — | — | **`ALTRO (strumenti che BCM non quota / fuori dai simboli attivi)`** | **08/09/2026** | idem |
| B82 | **Stagionali / calendario** (`Turnaround Tuesday`, `Turn of the Month`, `Buy Tuesday`, `Seasonal Strategies V1`, `FTSE Fridays`, `TDOW`) — **6** | stagionali | — | D1 | **11.928 operazioni** (R63) | — | **R63: 0/24 OOS** | — | `EDGE/PF` | **08/09/2026** | idem |
| B83 | **Pair trading / z-score su spread** (`Pair Trade`, `Pair Trade crypto`, `Pairs Trading OLS`, `Return Dispersion Matrix`) — **4** | relativo | — | — | — | — | — | — | 🟡 **`ALTRO (adiacenti a `RELATIVO`, che è a tick adesso — non si duplica un motore in corsa)`** | **08/09/2026** | idem |
| B84 | **Mashup multi-indicatore senza tesi** (`Ultimate TEMA LSMA Institutional`, `Squared9 Pro`, `Tristan's Multi-Indicator ×2`, `Quadruple EMA + S/R`, `Ichimoku+MACD+CMF+TSI`, `SSL Wave Trend`, `Multi-Indicator Swing`, `KALKI TFXBOT`…) — **~15** | mashup | — | — | — | — | — | — | **`ALTRO (nessuna tesi scrivibile in una riga → non è un esperimento, è una spazzolata)`** | **08/09/2026** | idem |
| B85 | **32 Pine esterni valutati il 29/08** | vari | — | — | — | — | — | — | **`EDGE/PF` (tutti dominati: EMA-cross→HAM, BB-MR→Bulge, struttura→HH&LL) o `ALTRO` (ORB/breakout chiusi; 3 recovery/griglia; 2 licenza CC-NC)** — **0 candidati nuovi**; 2 mattoncini archiviati | **29/08/2026** | `HANDOFF.md` r.613-617 |
| B86 | **`SP500 Session Gap Fade`** (exlux, MPL 2.0) | gap fade | SPXUSD | `[NON DICHIARATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | **`ALTRO (PROMOSSO COME SPECIFICA, SCARTO COME EA)`** | **28/08/2026** | `caccia_strategie/CACCIA_INTRADAY_FOREX_ORO` r.818 · `CACCIA_APERTURE_ORO_2026-09-08.md` r.76 |
| B87 | **`KSQ Fair Value Gap EA`** (Code Base **71467**) | FVG | — | — | — | — | — | — | **`ALTRO (doppione di `ABTG_FvgRetest`; il "regime filter" è OPZIONALE = filtro appiccicato, §5B)`** | **08/09/2026** | `CACCIA_APERTURE_ORO_2026-09-08.md` r.384 |
| B88 | **Utility / template / non-strategie** (`How To Set Backtest Date Range` ×3, `TradingView Alerts to MT4/MT5` ×2, `Automate on Hyperliquid`, `Close Trade at end of day`, `Alert alertcondition`) — **~9** | — | — | — | — | — | — | — | **`ALTRO (non sono strategie)`** | **08/09/2026** | `CACCIA_M30_INDICI_2026-09-08.md` §5.3 |

---

# 🔢 CONTEGGIO

## 1. Il totale

| | |
|---|---:|
| 🏠 **SEZIONE A — candidati NOSTRI** | **119 righe** |
| 🌐 **SEZIONE B — candidati ESTERNI** | **88 righe** |
| **TOTALE CENSITO** | **207 righe** |

> ⚠️ **Attenzione a come si legge questo numero.** Non sono 207 *motori*: sono
> **207 righe di verdetto**. Un motore può comparire più volte perché è stato
> misurato su **simboli diversi**, su **lati diversi** o in **round diversi**
> (§DOPPIONI). E **13 righe della sezione B sono GRUPPI** (JOAT 17 titoli,
> griglie 9, cripto ~22, mashup ~15, utility ~9, stagionali 6, botnet 4, pair
> trading 4, 32 Pine, 4 candidati BreakinBox, 3 DAX breadth, 4 Eriksson/Gilks…):
> contate a titolo, i **titoli esterni** censiti superano i **170**.

## 2. Per cancello — cancello **PRIMARIO** (il primo elencato nella riga)

| 🚪 cancello | righe | quota |
|---|---:|---:|
| **`EDGE/PF`** | **80** | 38,6% |
| **`ALTRO`** (griglia/martingala, nessuno stop, doppione, strumento non quotato, filtro appiccicato, licenza, fuso, architettura…) | **47** | 22,7% |
| **`RISCHIO/DD`** | **33** | 15,9% |
| **`FREQUENZA`** | **17** | 8,2% |
| **`BACO/NON GIRATA`** | **13** | 6,3% |
| **`NON MISURABILE (n troppo basso)`** | **11** | 5,3% |
| **`COSTO C3`** | **4** | 1,9% |
| **`MURO GIORNALIERO`** (come primario) | **1** | 0,5% |
| **`[CONTRADDIZIONE APERTA]`** (A119 FvgRetest) | **1** | 0,5% |
| **totale** | **207** | 100% |

## 3. Per cancello — **TUTTE le occorrenze** (un candidato può averne più d'uno)

| 🚪 cancello | occorrenze |
|---|---:|
| `EDGE/PF` | **114** |
| `ALTRO` (tutte le specifiche) | **58** |
| `RISCHIO/DD` | **52** |
| `NON MISURABILE (n troppo basso)` | **23** |
| `FREQUENZA` | **22** |
| `BACO/NON GIRATA` | **13** |
| `COSTO C3` | **6** |
| `MURO GIORNALIERO` | **4** |
| `[CONTRADDIZIONE APERTA]` | **1** |

> ## 🎯 **LA RIGA CHE VIENE FUORI DAL CONTEGGIO, E COINCIDE CON QUELLA DI CASA**
> **L'imbuto muore di EDGE, non di frequenza.** `EDGE/PF` è il cancello
> primario di **80 righe su 207 (38,6%)** e compare in **114 righe su 207
> (55%)**; la `FREQUENZA` è primaria in **17** e compare in **22**. È
> **esattamente** la
> conclusione già misurata in `report/PERCHE_MUOIONO_2026-09-08.md` §2
> (*"il collo di bottiglia non è la frequenza. È l'edge, di cinque volte"*) —
> raggiunta qui per una strada diversa (prosa integrale, non le 71 righe di
> quel referto), e **arriva allo stesso posto**. 🟢 È una conferma
> indipendente, e va detta.
>
> 🔴 **E la sorpresa vera è la colonna `ALTRO`, che è la SECONDA più grande.**
> Griglie e martingale dichiarate, EA senza stop, doppioni di motori nostri,
> strumenti che BCM non quota, filtri appiccicati, look-ahead. **Sono 47
> candidati che non sono mai arrivati a un backtest** — e non perché il
> mercato li abbia bocciati, ma perché **erano rotti o vietati in partenza**.
> 💰 È il cancello più economico che abbiamo: costa **una lettura**, non un round.

## 4. Nota metodologica sul conteggio (dichiarata)

- I conteggi §2 e §3 **non sono stimati a occhio: sono contati sulla colonna
  «CANCELLO» delle 207 righe di questa tabella**, prendendo come *primario* il
  primo cancello nominato nella cella (l'ordine di gravità è quello scritto
  nella riga). Sono quindi **riproducibili e verificabili riga per riga**.
  ⚠️ Il limite dichiarato: la classificazione della singola riga è **mia**, e
  su alcune righe `EDGE/PF` e `ALTRO` si toccano (es. *"doppione di una
  famiglia già sepolta"* — è ALTRO o è EDGE?). Spostare una decina di righe fra
  quelle due colonne **non cambia la conclusione** (edge ≫ frequenza), ma
  cambierebbe le percentuali di qualche punto.
- Il conto di questo file **non coincide** con quello di
  `PERCHE_MUOIONO_2026-09-08.md` (~71 righe) né con quello di
  `CORSIA_DEMO_CANDIDATI.md` (35 morti + 11 non decidibili + 4 candidati),
  **e non deve**: quelli censivano *i candidati di casa e i dossier*, questo
  censisce **la prosa intera, inclusi i titoli esterni scartati al primo
  taglio**. 👉 Sono tre metri diversi sullo stesso archivio, e vanno citati
  ognuno col suo perimetro.

---

# 👥 I DOPPIONI — lo stesso motore, più volte, con verdetti diversi

> Questi **non sono errori**: quasi tutti sono lo stesso motore misurato su un
> **simbolo diverso**, su un **lato diverso** o in un **round diverso**. Ma se
> qualcuno conta le righe come se fossero motori, sbaglia il numero — quindi
> vanno nominati.

| motore | quante righe | i verdetti, e sono **diversi** |
|---|---:|---|
| **`ABTG_SupertrendReversal` / famiglia SupRev** | **A13-A26** (14) | 🟢 **vivi**: oro H4, Nasdaq H1, DAX H4, argento, Nikkei H4 · 🔴 **morti**: DAX M5, NAS M5, NAS H4, FTSE H1/H4, IBEX, GBPJPY · ⚫ **promozioni REVOCATE**: Dow H4 e CAC H4 (illusione OHLC) · 🔴 **spente**: DAX H1 (IS rosso), Dow H1 (DD 10%). **È il motore con più verdetti opposti del repo, e il criterio che li separa è il TIMEFRAME + il simbolo, non il motore.** |
| **`ABTG_SuperWave`** | **A27-A31, A90** (6) | 🟢 Dow H1 **1,52** in campo · 🟡 DAX H4 **1,28** mai in campo (freq) · 🔴 DAX H1 **0,84 / DD 17%** · 🔴 NAS H4 negativo · 🔴 oro negativo · 🔴 GBPUSD **0,79 / DD 13,4%** spenta · 🔴 lato short Dow **0,429** |
| **`ABTG_LondonFx`** | **A53-A56** (4) | 3 motori × 2 simboli = **6 letture, tutte bocciate per rischio** (DD 31-55%). Una gamba (GBPUSD) esce da **banco sporco classe 129**: i numeri non si leggono, ma la bocciatura per rischio regge. |
| **`ABTG_AtrExhaustVol`** | **A59-A64** (6) | 6 celle (3 simboli × 2 lati), **tutte bocciate per rischio**, DD **44,3-67,8%**. Verdetto omogeneo: **non è un doppione contraddittorio, è una famiglia intera**. |
| **`ABTG_Relativo`** | **A57-A58** (2) | 🔴 D30EUR **BOCCIATA PER RISCHIO** (DD 25,01%, giornata −5,20%) · 🟠 NASUSD **MERITO SOSPESO**, rischio mai rosso (DD 8,40%). **Due verdetti opposti sullo STESSO motore e stessa cella**: cambia solo il simbolo. |
| **`ABTG_Nasdaq_Apertura_US`** | **A2, A3, A87** (3) | screening 26/07 (**0% combo**) · sedia 770201 spenta 18/08 (**PF 0,82 · DD 17%**) · lato short R107 (**PF OOS 0,460**). ⚪ E il **GATED SHORT 770250** dello stesso EA è **IN CAMPO dal 30/08** — non è uno scarto. |
| **`ABTG_DAX_Apertura_EU`** | **A1, A86, A111-A115** (7) | 🟢 la cella viva è **sul conto reale** · 🔴 morte: config A1, lato short (R107 **0,957** con n 257), motore RETEST, motore RANGE-FADE, R46, R44, R51 |
| **`ABTG_Nightly`** | **A39-A41** (3) | 🔴 forex 0/8 · ⚪ **indici/oro NON MISURATI** (baco `PipSize`) · 🔴 EURCHF bocciato per rischio 09/09. **Il "Nightly 0/8" citato in giro NON copre indici e oro.** |
| **`ABTG_PostNews`** | **A36-A38** (3) | ⚪ primo verdetto **RITIRATO** (Trades 0 = baco) · 🔴 ISM EURUSD **0,76/0,79** · 🔴 blocco 13:30 USDJPY **0,66/0,90**. ⚪ E la sedia **NFP è viva**. |
| **`ABTG_BreakinBox`** | **A50-A51, B45** (3) | tesi **1,007 / DD 24,1%** · controllo **1,106 / DD 19,7%** · e **4 candidati esterni TradingView** che sono lo stesso motore riga per riga |
| **`ABTG_BreakingBand` / Bulge** | **A88-A89** (2) | M15 **0/3** · M30 **0/3** ma **migliore di M15 su tutti e 3 i simboli** (+11.506 su GBPUSD). Il gradiente **H1 > M30 > M15** è il vero contenuto dei due round. |
| **`ABTG_CrossEmaApertura`** | **A73-A75** (3) | cella A Dow · cella A Nasdaq · cella B (controllo). ⚠️ **La cella B su NASUSD è l'unico segno verde del round (PF 1,06 IS / 1,00 OOS) ed è per FIRMA non promuovibile, mai** — schema "filtro orario appiccicato". |
| **`ABTG_ORB` / famiglia ORB** | **A7, A9, A76, A81, A82, A84, B14, B36, B47** (9) | 🟢 la sedia **770611 è viva** · 🔴 ORB_Fibo, Londra_ORB, R45 0/48, R43 0/8+0/8, R97 0/4, ORB Dow short DD 26,37%, + 3 esterni. **~210 celle a tick, e il registro lo dice.** |
| **`ABTG_AltaVelocita`** | **A66, B8** (2) | il porting di casa (**8/8 rosse**) e il manuale che l'ha generato (**riletto il 06/09, zero parametri nuovi**). Una riga sola di verdetto, due file. |
| **M0PB · RSI+EMA V8 · GapCash** | **A69, A96, A97** | 🔴 morti alla sonda **nel 2026-08/09** · 🎣 **riaperti l'08/09** dal ripescaggio per frequenza. **Sono contemporaneamente "morti" e "in coda all'imbuto", ed è corretto così**: la firma del 07/09 li rimette in coda, **mai in campo in automatico**. |

---

# ⚔️ CONTRADDIZIONI — due file, due numeri, sullo stesso oggetto

> **Sono importanti quanto i numeri.** Nessuna è stata risolta d'ufficio in
> questo file: sono **dichiarate**, con i due lati e chi decide.

### 🔴 C1 — `ABTG_FvgRetest`: **misurato o mai misurato?** (la più pesante)

| fonte | data | cosa dice |
|---|---|---|
| `HANDOFF.md` r.610-612 | **29/08/2026** | *"Corse (G1PAOLO, VWAPREV, FVGRET): nessuna dà una proposta… **FVGRET DD 42,9% (bocciato rischio)**"* — e r.633 lo mette nella lane fade M15 *"tutto bocciato/debole"* |
| `report/GIACIMENTO_DI_CASA_2026-09-03.md` r.71 | 03/09/2026 | `ABTG_FvgRetest` — colonna "cosa manca": **"la corsa"** |
| `report/CORSIA_DEMO_CANDIDATI.md` r.290 | 07/09/2026 | *"EA scritto, prova e riga pronte, **zero CSV, zero referto**… **mai misurato in casa**"* |
| `report/CORSIA_DEMO_CANDIDATI_v2.md` r.240 | 08/09/2026 | DD: **🔴 NON MISURATO** · frequenza: **🔴 NON MISURATA** |

🔎 **Controllo fatto oggi:** in `backtest_pipeline/risultati_archivio/` **non
esiste nessuna cartella o referto FVG** (esiste `vwaprevert/`, non l'equivalente
FVG). 👉 **L'indizio materiale sta dalla parte dei tre documenti recenti.**
🔴 **Ma il "42,9%" è scritto in HANDOFF e nessuno l'ha mai ritirato**, e HANDOFF
è il file che si legge per ripartire in una chat nuova.
➡️ **Serve una riga di chi ha lanciato quella corsa del 29/08, oppure la
cancellazione esplicita del numero da HANDOFF.** Finché non si chiude, il DD di
`FvgRetest` **non si può citare in nessuna direzione**. Decide Claudio.

### 🟠 C2 — `SupRev DOW H4` e `SupRev CAC H4`: **PF 2,77/1,79 oppure 0,79/0,96?**

| fonte | numero |
|---|---|
| `REGISTRO_TEST.md` §"VALIDAZIONE REAL-TICK SupRev nuovi indici" (26/07) | Dow H4 **PF 2,77 · DD 4,0% · n 79** · CAC H4 **PF 1,79 · DD 3,5% · n 65** — *"CONFERMATA"* |
| `risultati_archivio/CLASSIFICHE.md` §2 · `FLOTTA_ATTIVA.md` r.86-87 · `CORSIA_DEMO_CANDIDATI.md` r.242 | **PFmed a tick 0,79** (Dow H4) e **0,96** (CAC H4) — *"illusione OHLC"*, **promozioni REVOCATE** |

✅ **Questa si spiega, e la spiegazione va scritta accanto ai numeri:** il
**2,77** è la **cella migliore** di uno sweep, lo **0,79** è il **PF MEDIANO di
tutte le celle**. Non sono lo stesso oggetto. 🔴 **Ma il registro dice
"CONFERMATA" e non porta la revoca**: chi legge solo `REGISTRO_TEST.md`
r.406-412 crede che Dow H4 sia un keeper. **La revoca va scritta ANCHE lì.**

### 🟠 C3 — `ABTG_ORB_Ottimizzato` **770611**: il DD è 9,92% o 10,00%?

| fonte | numero |
|---|---|
| `report/CENSIMENTO_CONTRATTI.md` §2 (contratto storico R15) | **DD 9,92% @1%** su n 119 — ⚠️ *"doppio asterisco"* |
| `risultati_archivio/R103_REFERTO_BLOCCO1_INDICI.md` r.12 (21 mesi) | **DD 10,00% @1%** su n 190 |

➡️ Non è una sedia scartata (è **viva sul conto reale**), ma il numero **decide
se è dentro o fuori il muro del 10%**, e i due file dicono **dentro** e
**esattamente al muro**. Fonte: `PERCHE_MUOIONO_2026-09-08.md` r.66-67 e r.77-80.

### 🟠 C4 — Quante esclusioni erano **solo per frequenza**? UNA o SETTE?

| fonte | numero |
|---|---|
| `report/CORSIA_DEMO_CANDIDATI_v2.md` §1.2 (08/09) | *"Nel repo esiste **UNA SOLA** esclusione motivata SOLO dalla frequenza"* (G4 SuperWave DAX H4) |
| `report/RIPESCAGGIO_FREQUENZA_2026-09-08.md` §1 (08/09, stesso giorno) | 🔴 **"Non è esatto: sono SETTE"** |

✅ **Risolta dentro il repo stesso**, e la spiegazione è di metodo: il v2
cercava **la frase** *"scartato per frequenza"*, il ripescaggio ha cercato **il
cancello** (`C2` nelle cacce, `F1` nelle sonde, *"pavimento"* nella tassonomia).
📌 **Vale come regola per il prossimo censimento: si cerca il cancello, non la
frase.**

### 🟠 C5 — `ABTG_Nightly`: il "0/8" copre gli indici oppure no?

`HANDOFF.md` r.1810 e la coda fascia B chiudono **"Nightly 0/8"** come capitolo.
🔴 La **rettifica del 23/08** in `REGISTRO_TEST.md` dice che su **U30USD,
D30EUR, XAUUSD** l'EA fa **ZERO trade** per un baco (`InpMaxNightVolPips` contro
`ATR(H1)/PipSize()`): *"su quei mercati il fade non è stato bocciato: **non è
stato misurato**"*. ➡️ **Il "0/8" vale su EURUSD/GBPUSD/USDCHF e basta.** Chi lo
cita per gli indici cita un numero che non esiste.

### 🟠 C6 — La finestra del range **ORB**: 14:25-14:30 o 14:30-14:45?

`REGISTRO_TEST.md` §"ORB — LA FINESTRA DEL RANGE È CONTESA" (04/09): la **voce
dei docenti** (Paolo 03/09 + Emiliano, RICORRENTE su 18 live) dice **14:30-14:45
server**; **lo strumento** (`ORB_Indicator_V17`) e **le nostre due sedie vive**
usano **14:25-14:30**. 🔴 **Le due finestre non si sovrappongono nemmeno per un
secondo** e hanno durata diversa (5 minuti contro 15). 🟢 Regge quella misurata
(770611: DD 9,92%, 119 trade). **Non misurato**, prerequisito Q1 aperto.

### 🟠 C7 — Ampiezza del range ORB: filtro sì o no?

`REGISTRO_TEST.md` r.230 (**Emiliano, RICORRENTE su 18 live**): *"niente trade
se il range è troppo ampio"*. **Paolo il 03/09 lo NEGA esplicitamente**
(*"mi condiziona la size e basta"*). ➡️ La riga 230 **resta com'è**: si annota la
contraddizione, non si riscrive una regola misurata su una live sola. ⚠️ E
**noi quel filtro oggi non ce l'abbiamo**: siamo per caso allineati a Paolo.

### 🟡 C8 — Il "certificato di morte" di **M0PB** poggia su un criterio **aggiunto dopo i numeri**

`REFERTO_SONDAM0PB_2026-08-31.md` uccide M0PB anche con *"win rate necessario
62-70%… la zona che in casa non ha mai pagato"*. 🛑 **Ma il cancello firmato è
`H8: RR ≥ 0,70`** (`FIRME_2026-08-31.md` FIRMA 2), e **cinque celle su dodici lo
passano**. Il win-rate richiesto è la stessa cosa detta in un altro modo, scritta
**dopo** aver visto i numeri — e la regola di casa è *"i criteri si cambiano
prima dei numeri, non dopo"*. ➡️ Fonte: `RIPESCAGGIO_FREQUENZA_2026-09-08.md`
§2 R5. **Non significa che M0PB funzioni: significa che non è stato misurato.**

### 🟡 C9 — Il "0/8" del **FiboH4** è un numero solo, contato otto volte

`REGISTRO_TEST.md` r.40-47: `InpSymbols` era pinnato **vuoto**, MT5 ha usato il
default compilato, e **7 file su 8 danno lo stesso numero al centesimo**
(IS da −384,56 a −394,13 · OOS da +116,17 a +118,68). ➡️ Il "0/8" è **una
configurazione bocciata, contata otto volte** — e **non ha mai giudicato la
strategia del corso** (tre divergenze di geometria: distanza ordini **~×10**,
target **×2,1**, stop **~×4**). **R93 non è mai girato.**

### 🟡 C10 — Il "nessun edge" di **PostNews** del 07/08 era un verdetto **inesistente**

`REGISTRO_TEST.md` r.66-79: quattro CSV con **`Trades = 0`** non misurano una
strategia debole, **non misurano niente**. Due cause sommate (calendario datato
2026-2027 + `FileOpen` senza `FILE_COMMON`). ➡️ **Verdetto RITIRATO il
03/09/2026.** Chi cita "PostNews senza edge" col numero del 07/08 cita il vuoto.

---

# 🚧 COSA QUESTO CENSIMENTO **NON** COPRE — dichiarato

- 🔴 **Non ho aperto i file di `caccia_strategie/`**, `prove/` e la maggior parte
  dei referti `risultati_archivio/R*` uno per uno. Il mandato era **la prosa**
  (`REGISTRO_TEST.md`, `report/*.md`, `HANDOFF.md`, `ROBUSTEZZA.md`); dove ho
  citato un referto è perché **un file di prosa lo cita**, e in **9 casi** l'ho
  aperto per prendere i numeri veri (R96, R97, R98, R107, R108, R110, R111,
  R95, CRT). 👉 **Nei dossier di caccia ci sono altri titoli scartati che qui
  compaiono solo aggregati.**
- 🔴 **Non ho riaperto nessun CSV, nessuno zip, nessun `.htm` del tester.** Ogni
  numero qui è **copiato dalla prosa che lo riporta**, non ricalcolato.
- 🔴 **Le colonne `n`, `PF IS`, `PF OOS` e `DD` sono vuote molto più spesso di
  quanto vorrebbe il mandato — e non è pigrizia: quei numeri non esistono.**
  Su **119 righe della sezione A** solo **49** hanno un PF *numerico* e solo
  **54** un DD *numerico* (contato: le altre portano verdetti di forma
  «0/48 celle positive», che sono misure ma non sono un PF).
  Nella sezione B la maggior parte dei candidati **non è mai
  arrivata a un backtest** (`ALTRO`, `BACO/NON GIRATA`): non hanno numeri
  **per costruzione**, e inventarli sarebbe il peggior servizio possibile.
- 🔴 **Non copre il REGIME.** Ogni numero a tick sugli indici viene da **21 mesi
  di UN SOLO REGIME (toro)**, pavimento tick BCM **2024.09.26**.
- 🔴 **Non copre lo spread forex e oro** (riga **H12** di `report/PIANO_PROP.md`,
  **NON MISURATO**, aperta da sette dossier). Tocca direttamente B62 (oro),
  B67 (M10) e ogni cancello `COSTO C3` fuori dai tre indici.
- 🔴 **Non è una riapertura.** Le sette righe 🎣 riaperte dal ripescaggio dell'
  08/09 sono segnate come tali **perché lo dice quel referto**, non perché
  questo file le promuova. **Nessuna va in campo per effetto di questo
  documento.**

---

_Compilato il 09/09/2026 in **sola lettura d'archivio**. **Nessun EA, preset,
sedia, magic o parametro di forward è stato toccato. Nessun backtest lanciato.
Nessuna promozione, nessuna riapertura.** Se un referto e questo documento
divergono, **comanda il referto** — e la divergenza va nella §CONTRADDIZIONI._
