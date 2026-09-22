# 🎯 DOSSIER CONFIG — COME ALZARE IL PROFIT FACTOR DEI NOSTRI EA
### Caccia esterna ai VALORI D'USCITA copiabili · 22/09/2026

> **La richiesta, testuale di Claudio:** _"Dobbiamo alzare i profit factor dei nostri EA
> attuali. Trovate il modo x farlo."_
>
> Qui non ci sono strategie nuove. Ci sono **numeri d'uscita** presi da preset pubblici e
> da articoli aperti oggi, messi accanto ai numeri che i nostri sei EA hanno **adesso**
> nei preset FTMO, con la proposta di misura per ciascuno.

---

## 🔥 LA RIGA CHE CONTA

> ## Ho aperto 11 fonti e decodificato **28 preset ufficiali di vendor su INDICI** (DAX, US30, NAS100, US500). **ZERO usano un parziale.** I nostri **sei EA su sei** ne prendono uno del 50%. Questo e' il buco, ed e' lo stesso che la nostra R46/R47 aveva gia' misurato in casa senza che nessuno lo traducesse in una proposta.

**Il conto dei preset, per nome** (tutti decodificati riga per riga, §2):

| famiglia di preset | file | simboli | parziale attivo? |
|---|---:|---|---|
| Opening Range Breakout EA V2 (Lee Samson) | 11 | DAX · NAS · DOW, M5 | ❌ il parametro **non esiste** |
| The ORB Master (Profalgo) | 7 | US500 · US30 · NAS100 | ❌ nessun input di parziale |
| Range Breakout Daytrader (v3 US30) | 8 | US30 | ❌ `ClosePartOfProfitTP1..TP4 = false` (4 scalini, tutti **spenti**) |
| The US30 Market Maker v2.3 (NJtrading) | 2 | US30 | ❌ il parametro **non esiste** |
| **TOTALE** | **28** | | 🔴 **0 su 28** |
| **i NOSTRI preset FTMO in campo** | **6** | DAX · Dow · Nasdaq · US30 | 🔴 **6 su 6 con parziale 50%** |

---

## ⚠️ 0. IL CONTROLLO POSITIVO — e la meta' del web che oggi e' NULLA

Prima di cercare ho verificato ogni canale su un bersaglio noto. **Il risultato e' pesante e
va dichiarato prima dei contenuti**, perche' cambia il peso di tutto il dossier.

| fonte | esito | nota |
|---|---|---|
| 🟢 **mql5.com** (Market · Blogs · Articles · c.mql5.com) | ✅ **APERTA** | e' **la** fonte di questo dossier: preset, manuali, articoli |
| 🟢 **arxiv.org** | ✅ APERTA (abs + html; il **PDF non e' estraibile**, testo come immagine) | |
| 🟢 **tradingview.com** | ✅ APERTA | non usata oggi: i suoi script erano gia' spremuti nelle cacce 08-09 |
| 🔴 **github.com / raw.githubusercontent.com** | ❌ **403 dal proxy** su repo, ricerca e raw | 🔴 **la fonte "sorgenti con licenza" oggi e' NULLA**: il confronto riga-per-riga con gestori d'uscita open source **non si e' potuto fare** |
| 🔴 **forexfactory.com** | ❌ 403 su tutto il dominio | nessun thread "challenge passed/failed" letto |
| 🔴 **kjtradingsystems.com** (Kevin Davey, 567.000 backtest sulle uscite) | ❌ bloccata | 🔴 **la perdita piu' grave della giornata**: era l'unico studio a campione enorme *sulle uscite* |
| 🔴 **ssrn.com** (Zarattini-Aziz 4416622 e 4729284) | ❌ 403 | i paper ORB restano **solo trovati** |
| 🔴 quantstrategy.io · metriclan.com · edgeflo.com · danfin.net · cxoadvisory.com · paperswithbacktest.com · wealth-lab.com · quantifiedstrategies.com · medium.com · reddit.com · myfxbook.com · investopedia.com · luxalgo.com · quantinsti.com · ftmo.com | ❌ bloccate | |

🔴 **Regola del proxy rispettata**: i 403 sono dinieghi di policy, **non si riprovano e non si aggirano**. Si dichiarano.

---

## 📚 1. LE FONTI **APERTE** — lette davvero, oggi

| # | URL | autore · data | che cosa ci ha dato |
|---|---|---|---|
| A1 | `https://www.mql5.com/en/blogs/post/751385` | **Lee Samson**, 05/01/2023 | metodo di test + Return on Drawdown di 11 preset · "strike rate 20-30% tipici" |
| A2 | `https://c.mql5.com/6/914/ORB_EA_Set_Files.zip` (scaricato e decodificato) | idem | **11 `.set` DAX/NAS/DOW M5** — archiviati in `biblioteca/set/ORBEAv2_*_2026-09-22.set` |
| A3 | `https://www.mql5.com/en/market/product/91232` | Lee Samson · **129 USD** | scheda: DAX/DOW/NAS/S&P500, **M5**, "prop firm accounts" |
| A4 | `https://www.mql5.com/en/blogs/post/762185` | **Lasse Najbjerg Jensen**, 01/05/2025 | manuale US30 Market Maker: **le uscite cambiano per GIORNO DELLA SETTIMANA** |
| A5 | `https://www.mql5.com/en/articles/16991` | **Artyom Trishkin**, 06/10/2025 | 1.722 deal, 9 simboli: classifica di **9 tipi di trailing** |
| A6 | `https://www.mql5.com/en/articles/23716` | **Ushana Kevin Iorkumbul**, 24/08/2026 | scala parziali **1R/50% + 2R/25% + 3R/25%**, BE solo al primo |
| A7 | `https://www.mql5.com/en/articles/19911` | **Chacha Ian Maroa**, 29/10/2025 | default di un trade manager: BE 50 pt · trail start 50 · dist 100 · **parziale a 100 pt / 50%** |
| A8 | `https://www.mql5.com/en/articles/19693` | **Daniel Opoku**, 16/10/2025 | scaletta di RR **1,3 → 1,7** su ordini multipli (non parziali) |
| A9 | `https://www.mql5.com/en/market/product/184556` | Amal Yuldashev · gratuito | conferma che BE+trail+parziale e' il pacchetto standard; **nessun default pubblicato** |
| A10 | `https://arxiv.org/html/2604.27150v1` | **N. Li, A. Laryea, Y. Ihlamur**, 29/04/2026 | griglia 8.960 configurazioni su **>900 trade** |
| A11 | preset gia' in `biblioteca/set/` (URL nel `CATALOGO.md`, cacce 18 e 23/08) | vari | RBDT US30 v3 · ORB Master · US30 Market Maker — **ridecodificati oggi** |

### 🔎 Le fonti **solo TROVATE** (snippet di ricerca, pagina MAI aperta) — non entrano in tabella e non pesano
- **Kevin Davey, 567.000 backtest su 15 uscite / 40 mercati**: lo snippet dice che *Stop&Reverse* batte tutto e che *dollar target* e *breakeven* sono secondi. **Pagina bloccata → [INCERTO], non usato per nessuna proposta.**
- **Zarattini & Aziz, ORB 5' su QQQ 2016-2023**: target **10R** colpito solo nel **2-3%** dei trade, **~75%** esce sullo stop, **~22%** piatto a fine seduta. 🔴 **[NON VERIFICATO]** — SSRN 403. Se fosse vero sarebbe il dato piu' importante del dossier sul target; **per questo non ci costruisco sopra nessuna proposta**, solo un asse di misura.
- Una replica indipendente dello stesso ORB darebbe **Sharpe −0,06 su 2010-2026**. Idem: non aperta.

---

## 📊 2. LA TABELLA DEGLI ESEMPI — valori, con la loro fonte

> Legenda campione: `RoDD` = Return on Drawdown dichiarato dal vendor. **Nessun vendor pubblica il Profit Factor.** Dove non c'e' PF, lo scrivo: la colonna vuota e' un'informazione.

### 2.1 · 🥇 Opening Range Breakout EA V2 — 11 preset, **M5 sugli stessi indici che tocchiamo noi**
Test dichiarati dall'autore: tick Dukascopy 99,9% · **01/04/2021 → 01/04/2022 (1 anno)** · rischio fisso per trade · spread fisso 2 pip · M5.
🔴 **PF: non pubblicato. DD assoluto: non pubblicato.** Solo il rapporto RoDD. *(dichiarato dal vendor, NON verificato)*

| preset | stop | TP | parziale | breakeven | trailing | chiusura oraria | cap giornaliero | RoDD |
|---|---|---|---|---|---|---|---|---:|
| DAX-2 Percent | `OR_stp_pct=110` + `pip_stp=400` | 🔴 **10000 = spento** | ❌ | `use_be=0` | `use_trail=1` · dist **300** · **`trail_start=0`** | `stop_time=11:30` | `close_all=-2500` | 2,76 |
| DAX-3 5&15 TP | 110% + 400 | `_1_tp=50` `_2_tp=1000` `_3_tp=250` | ❌ | 0 | 300 · start 0 | 11:30 | −2500 | **3,00** |
| DAX-5 AM Addon | 110% + 250 | spento | ❌ | **`be_dist=250`** | **1000** · start 0 | 11:30 | −2500 | 2,82 |
| DAX-6 15 Min Pre | 110% (no pip stop) | spento | ❌ | 0 | 450 · start 0 | 11:30 | −2500 | **3,42** |
| DAX-7 5 Min Only | 110% + 500 | spento | ❌ | 0 | 300 · start 0 | 11:30 | −2500 | 2,50 |
| DOW-1 PM Addon | 110% + 250 | spento | ❌ | **500** | 250 · start 0 | `stop_time=18:00` | −2500 | 2,83 |
| NAS-1 PM Addon | 110% + 250 | spento | ❌ | **500** | **1500** · start 0 | 18:00 | −2500 | 4,52 |
| NAS-2 5&15 Tight | 110% + 300 | spento | ❌ | **100** | 400 · start 0 | 18:00 | −2500 | 🥇 **5,11** |
| NAS-3 15 Min Pre | 110% (no pip stop) | spento | ❌ | 0 | 500 · start 0 | 18:00 | −2500 | 2,64 |
| NAS-5 Percent | 110% + 400 | spento | ❌ | 0 | **1000** · start 0 | 18:00 | −2500 | 4,37 |
| NAS-6 5&15 TP | 110% + 400 | `_1_tp=400` `_2_tp=400` | ❌ | 0 | 600 · start 0 | 18:00 | −2500 | 3,41 |

**I cinque fatti [VERIFICATO] da questi 11 file:**
1. 🔴 **Nessun parziale. Il parametro non esiste proprio nell'EA.**
2. 🔴 **Il take profit e' spento in 9 preset su 11** (`10000` = irraggiungibile). L'uscita e': stop, trailing, oppure l'ora.
3. 🔴 **`trail_start = 0` in 11 su 11**: il trailing arma **subito**, come da noi.
4. ⚖️ **Il breakeven e' acceso in 4 su 11**, e le distanze sono incoerenti fra loro (100 / 250 / 500 / 500): **il vendor stesso non sa a che distanza metterlo.**
5. 🧱 **`close_all=-2500` su `st_bal=100000` = cap giornaliero del −2,5%**, identico in tutti e 11. `prof_tgt=108000` (+8%).

⏰ **Orari in ORA SERVER BCM** *(loro broker GMT+2, il nostro e' ora italiana −1 → **−1 ora**)*:
- DAX: il blog dichiara *"Frankfurt Open ... open at 10:00"*, quindi il loro broker e' **GMT+2** (Francoforte apre alle 09:00 CET). `OR1_S=10:00` = 08:00 GMT = **08:00 server BCM** — *esattamente l'apertura che usiamo noi* (`CLAUDE.md`: DAX 09:00 IT = 08:00 server). `stop_time=11:30` = **09:30 server**.
- US: range 16:30-16:35 broker = **14:30-14:35 server** *(l'apertura di New York, la nostra)*; `stop_time=18:00` = **16:00 server**.
👉 **Le loro finestre coincidono con le nostre.** Il confronto e' quindi legittimo: cambia la gestione, non l'ora.

### 2.2 · 🥈 Range Breakout Daytrader — preset ufficiali **US30 v3** (in `biblioteca/set/`, URL in `CATALOGO.md`)

| manopola | LowRisk v3 | MedRisk v3 | che cosa dice |
|---|---|---|---|
| `ClosePartOfProfitTP1..TP4` | `false` × 4 | `false` × 4 | 🔴 **quattro scalini di parziale disponibili, tutti SPENTI dal vendor** |
| `TP1/2/3/4_PriceLevel` (se accesi) | 25 / 50 / 75 / 100 | idem | la scala **esiste** ma non e' usata |
| `PercentageToCloseTP1..4` | 25 / 50 / 75 / 100 | idem | |
| **`RatioTP`** | **4** | **4** | 🎯 **target a 4R** |
| **`_Trailingstart`** | **2,2** | **2,2** | 🔴 **il trailing arma a 2,2R** — l'opposto di ORB EA V2 |
| `ATRmultiplier` / `ATRperiod` | 2,6 / 10 | 2,6 / 10 | distanza del trailing |
| `RatioTrailingstart` | 0,4 | 0,4 | seconda soglia (semantica **[INCERTO]**, manuale non riaperto oggi) |
| `RiskPercentage` / `_MaxLoss` | 4,8 / 4,8 | 10 / 10 | 🔴 **BANDIERA ROSSA: 4,8% e 10% per trade.** Fuori scala rispetto al nostro 0,65%. **I valori di TAGLIA di questo vendor non si copiano.** |
| news | `HighImpactNewsFilter=true`, calendario Forex Factory, `TimeToClose=5` | idem | |
| `InpClosingSession` / `InpSessionEndH` | true / 22 | true / 22 | flat a fine giornata |

### 2.3 · 🥉 The US30 Market Maker v2.3 — il diff **prop ↔ personale** piu' pulito che abbiamo

| manopola | preset "Prop trading" | preset "High risk" | |
|---|---|---|---|
| `StopLossPercentage` | **0,3** | 2,0 | ÷6,7 |
| `StopLossAroundBigNews` | **0,3** | 2,0 | |
| `MaxDDpercentage` | **4** | 0 (spento) | |
| `ATRstop` / `ATRstop2` | **0,9** / **1,5** | identici | |
| `ATRtp` / `ATRtp2` | **1,2** / **3,2** | identici | |
| `TrailingStopLoss` | **false** | false | 🔴 **niente trailing su US30** |
| `NewsFilter` | true | true | |

> ### 🔴 IL RISULTATO NEGATIVO PIU' UTILE DELLA GIORNATA
> Fra il preset **prop** e quello **personale** dello stesso vendor, stessa versione, stesso
> giorno, **le uscite sono IDENTICHE**. Cambiano solo **taglia** (0,3% contro 2,0%) e **cap di
> drawdown** (4% contro spento).
> 👉 **Per la prop non si cambia l'uscita: si cambia la taglia.** Alzare il PF e' un problema
> di **edge**, non di prop — e va affrontato come tale, con l'imbuto, non con un ritocco al preset.

🧩 **E un meccanismo che NON abbiamo**, confermato sul manuale A4 riga per riga:
`"ATR Stop Loss (mon-tues)"` e `"ATR Stop Loss (wed-thurs-fri)"` → **le distanze di stop e
target cambiano per GIORNO DELLA SETTIMANA**. I quattro valori sono 0,9 / 1,5 ATR di stop e
1,2 / 3,2 ATR di target → **1,33R e 2,13R**.
⚠️ **[INCERTO] quale coppia va a quale giorno**: il `.set` non nomina i giorni e il suffisso
`2` e' ambiguo. Il **fatto** della divisione per giorno e' [VERIFICATO]; **l'assegnazione no**.

### 2.4 · Gli articoli — cosa aggiungono e cosa NON aggiungono

| fonte | valore | campione | trasferibile a noi? |
|---|---|---|---|
| **A5** Trishkin | classifica trailing: **DEMA +1.397,1** · TEMA +1.355,1 · FRAMA +1.291,6 · AMA +806,5 · MA +563,1 · PSAR +541,8 · VIDYA −283,3 · **niente trailing −658,0** · 🔴 **trailing a punti fissi −746,1 (PEGGIO del niente)** | **1.722 deal**, 9 simboli (8 forex + XAUUSD), dal 13/09/2024, SL iniziale 100 pt, step 50, start 150 | ⚠️ **forex, non indici M5.** L'ordine puo' ribaltarsi: lo sappiamo per esperienza nostra (FASE I walk-forward, Spearman −0,60 sui TF di trailing). **Vale come IPOTESI, non come valore.** |
| **A6** Iorkumbul | ladder **1R/50% (+BE) · 2R/25% · 3R/25%**, % sul volume **iniziale** | 🔴 **nessun backtest**: l'autore scrive che e' un esempio dimostrativo | 🟡 e' l'unica fonte esterna che nomina "1R / 50%" — ed e' **senza misura**. 👉 **Il nostro 1R/50% non ha nessuna conferma esterna misurata. Nessuna.** |
| **A7** Maroa | BE 50 pt · trail start 50 · trail dist 100 · **parziale a 100 pt, 50%** | nessun backtest formale | 🟡 unico schema ricorrente: **il parziale si prende al doppio della soglia del BE**. Rapporto, non valore. |
| **A8** Opoku | RR **1,3-1,7** su ordini multipli; 43% win rate → 3 ordini danno 61,8% di run profittevoli, DD mediano 17,14% | simulazione, **nessun PF** | ❌ forex, swing, ordini multipli ≠ parziali. Non trasferibile. |
| **A10** Li/Laryea/Ihlamur | vincitore: SL 10% · trailing armato al 3% · distanza 5% · **parziale al 10% chiudendo il 75%** · stop stantio 48h · ATR 1,0 stop / 2,0 TP · taglia ×0,25 dopo **2 perdite** · **Sharpe 0,653 · PF 2,375** | **>900 trade** e 🔴 **8.960 configurazioni al primo passo** | 🔴 **BANDIERA GIALLA GROSSA: 8.960 celle su 900 trade e' una macchina da sovradattamento.** Strumenti non dichiarati, soglie in **% di prezzo** (non R), "stop stantio" in ore → **cripto, quasi certamente**. 👉 Tengo **una** cosa sola, come ipotesi: quando un ottimizzatore e' libero, sceglie **un parziale GRANDE e PRESTO**, non un mezzo-mezzo. E l'altra: la **riduzione di taglia dopo 2 perdite** e' un meccanismo che non abbiamo. |

---

## 🕳️ 3. LA TABELLA DEI BUCHI — cosa c'e' fuori e cosa abbiamo noi

| meccanismo trovato fuori | chi lo usa | noi | verdetto |
|---|---|---|---|
| **Nessun parziale** sugli indici intraday | 28 preset su 28 | 🔴 parziale 50% su **6 sedie su 6** | 🔴 **BUCO #1** — ed e' quello con la misura di casa gia' pronta (R46/R47) |
| **Take profit assente** (uscita = stop/trailing/ora) | 9 preset ORB su 11 | TP a 3R (DAX/Dow), **1,5R (Nasdaq)**, 2R (EMA200), 3R (SuperWave), 4R (MaxMin) | 🟠 **BUCO #2** — il Nasdaq a 1,5R e' il piu' corto della flotta |
| **Trailing armato TARDI** (2,2R) | RBDT US30 | `InpTrailStartR=0` (arma subito) su tutte | 🟡 **asse aperto**: le fonti esterne si **contraddicono** (0 contro 2,2) |
| **Trailing a media mobile adattiva** (DEMA/TEMA/FRAMA) | A5, 1.722 deal | abbiamo **PREVBAR / FIXED / ATR** | 🟡 **BUCO #3** — meccanismo assente nel codice |
| **Uscite diverse per giorno della settimana** | US30 Market Maker | assente | 🟡 **BUCO #4** (con forte sospetto di sovradattamento) |
| **Riduzione taglia dopo N perdite** | A10 (×0,25 dopo 2) | assente negli EA; il **Guardian** ha pausa a 4,0% | 🟡 **BUCO #5** — ma e' gestione del rischio, **non** alza il PF |
| **Cap giornaliero −2,5%** | 11 preset ORB su 11 | Guardian: pausa **4,0%** / emergenza 4,9% | 🟢 **coperto**, e il nostro e' piu' largo del loro: e' una **scelta**, non un buco |
| **Flat orario obbligatorio** | ORB (11/11), RBDT (`SessionEndH=22`) | presente nelle aperture | 🟢 coperto |
| **Filtro news** | RBDT (FF, 5'), ORB Master (NFP 50'/30'), US30MM | `InpNewsBeforeMin` 30 / 60 | 🟢 coperto |
| **Parziale grande e presto (75% al primo scalino)** | A10 | 50% | 🟡 asse, non valore |

---

## 🧰 4. LE PROPOSTE, MAPPATE SULLE NOSTRE MANOPOLE

> 🛑 **Nessuna di queste si applica da sola. Il forward non si tocca.** La challenge e' **viva
> dal 21/09**: ogni modifica passa dall'imbuto, gli `_Ottimizzato` girano **in parallelo**,
> decide Claudio.
>
> 📏 **Il pavimento di rumore, dichiarato prima**: il 22/09 il primo stop vero della challenge
> e' costato **+10,5%** oltre il modello (`report/PRIMO_STOP_FTMO_2026-09-22.md`). **Una
> proposta che prometta meno di ~10% di miglioramento sta dentro il rumore d'esecuzione** e
> non giustifica il rischio di toccare una sedia viva. Sotto lo scrivo per ciascuna.

### 🥇 PROPOSTA 1 — togliere il parziale sulle tre APERTURE

```
PROPOSTA   InpTP1_ClosePct: 50 -> 0   (asse 0 / 25 / 50)
           + InpBEatR: 0 -> 1,0       (OBBLIGATORIO, vedi RISCHIO)
DOVE       770101 DAX_Apertura_EU · 770202 Dow_Apertura_US · 770260 Nasdaq_Apertura_US
           (preset in mql5/Presets/FTMO/) - come round nell'imbuto, NON in campo
FONTE      ESTERNA: 28 preset vendor su indici, 0 con parziale (§2.1, §2.2, §2.3)
           INTERNA: R46 - stesso ingresso, sola uscita diversa, fuori campione:
                    DAX trailing PREVBAR senza parziale PF 1,49 / DD 6,27
                        contro con parziale 50%      PF 1,40 / DD 7,23
           INTERNA: R47 per-trade - expectancy DAX +67 -> +123 (+84%)
                                              DOW +52 ->  +77 (+48%)
COSTO      ~0 ore di sviluppo (manopola gia' esistente). 1 round a 3 simboli x 2
           finestre x 3 valori = 18 corse tick sul PC DI BACKTEST (regola 21/09)
RISCHIO    🔴 IL DIFETTO DA NON MANCARE: con InpTP1_ClosePct=0 il breakeven NON scatta
           piu'. In ABTG_DAX_Apertura_EU.mq5 r.2359 il blocco e' racchiuso in
           `if(!partialDone && InpTP1_ClosePct > 0 && ...)` e InpBreakevenAtTP1 e'
           annidato dentro (r.2391). Il BE indipendente vive altrove (r.2404-2418,
           InpBEatR) ed e' spento (=0) in tutti e tre i preset.
           👉 Chi mette ClosePct=0 senza accendere InpBEatR toglie DUE protezioni
           credendo di toglierne una. Va misurata la COPPIA, mai il singolo.
FALSIFICA  Asse incrociato InpTP1_ClosePct {0;25;50} x InpBEatR {0;0,5;1,0}, IS/OOS,
           selezione al CENTRO dell'altopiano (mai il picco). Si boccia se il DD OOS
           sale oltre il DD promesso dalla cella in campo.
RUMORE     ✅ sopra la soglia sull'EXPECTANCY (+48%/+84%). 🟠 sul solo PF e' +6,4%,
           cioe' AL LIMITE del rumore: il numero che regge e' l'expectancy, e va detto.
```

### 🥈 PROPOSTA 2 — il target del Nasdaq e' il piu' corto della flotta

```
PROPOSTA   InpTP1_R: 0,5 -> asse {0,5 ; 0,75 ; 1,0 ; 1,5}
           (il TP finale vale InpTP1_R x 3: oggi 1,5R, proposto fino a 4,5R)
DOVE       770260 Nasdaq_Apertura_US_RETEST
FONTE      RBDT US30 v3: RatioTP = 4 (target a 4R) - §2.2
           ORB EA V2: TP spento in 9 preset su 11 - §2.1
           [solo TROVATO, non verificato] Zarattini: target 10R colpito nel 2-3%
COSTO      ~0 sviluppo. 4 celle x 2 finestre, tick, PC di backtest
RISCHIO    allungare il target su un motore ad alta percentuale di vincita puo'
           spostare il win rate sotto la soglia psicologica senza alzare il PF:
           e' esattamente il baratto misurato in R47. Da leggere insieme a P1,
           non separatamente (parziale e target si muovono sulla stessa leva).
RUMORE     ✅ ampiamente sopra: si parla di raddoppiare/triplicare la distanza
```

### 🥉 PROPOSTA 3 — l'unico asse dove il web NON sa rispondere: quando arma il trailing

```
PROPOSTA   InpTrailStartR: 0 -> asse {0 ; 0,5 ; 1,0 ; 2,2}
DOVE       tutte e tre le APERTURE (manopola gia' presente, r.334)
FONTE      🔴 LE DUE FONTI ESTERNE SI CONTRADDICONO:
           ORB EA V2 (11 preset su 11, stessi indici, stesso TF): trail_start = 0
           RBDT US30 v3 (8 preset):                               _Trailingstart = 2,2
           Nessuna delle due pubblica un PF. 👉 L'informazione esterna qui vale ZERO,
           e per questo e' l'asse piu' onesto da misurare in casa.
COSTO      ~0 sviluppo. 4 celle x 3 simboli x 2 finestre
RISCHIO    un trailing che arma tardi lascia correre indietro i trade: il DD sale
           prima di scendere. Si giudica sul DD, non sul profitto.
RUMORE     ✅ il 2,2 e' un cambio strutturale, non una rifinitura
```

### 4️⃣ PROPOSTA 4 — trailing a media mobile adattiva (meccanismo NUOVO)

```
PROPOSTA   nuovo valore per ENUM_ABTG_TRAIL: ABTG_TRAIL_MA (DEMA/TEMA/FRAMA)
DOVE       libreria di trailing condivisa dalle tre aperture (oggi: PREVBAR/FIXED/ATR)
FONTE      A5 - Trishkin, 06/10/2025, 1.722 deal, 9 simboli:
           DEMA +1.397,1 · TEMA +1.355,1 · FRAMA +1.291,6 · AMA +806,5 · MA +563,1
           PSAR +541,8 · VIDYA -283,3 · NIENTE trailing -658,0 · punti fissi -746,1
CONTESTO   🔴 FOREX (8 pairs + XAUUSD), NON indici M5. SL iniziale 100 punti,
           trailing step 50, start 150. Il trasferimento agli indici NON e' dimostrato.
COSTO      ~3-4 ore di sviluppo + 1 round. E' l'unica proposta che costa CODICE.
RISCHIO    su H1/H4 una media adattiva e' un filtro; su M5 su un indice puo' diventare
           un generatore di uscite da rumore. Da provare PRIMA sulle sedie H1
           (EMA200, SuperWave), dove il TF e' compatibile con la fonte.
RUMORE     ✅ la forbice della fonte e' enorme (-746 -> +1.397). Ma il contesto e' altro.
PRIORITA'  🟡 dopo P1-P3: costa codice e la fonte e' fuori contesto.
```

### 5️⃣ PROPOSTA 5 — le sedie H1, dove l'uscita non e' MAI stata messa ad asse

```
PROPOSTA   771531 EMA200 Dow:  InpTP1Pct 50 -> asse {0;25;50}
                               InpTP_RR  2,0 -> asse {2,0;3,0;4,0}
           770511 SuperWave:   InpTP1Pct 50 -> asse {0;25;50}
                               InpTrailOnST / InpExitOnFlip -> asse on/off
DOVE       preset FTMO delle due sedie H1
FONTE      stessa logica di P1 (28 preset, 0 parziali) + confronto US30MM:
           SL 0,9-1,5 ATR e TP 1,2-3,2 ATR contro il nostro InpSLatr=1,0 / TP_RR=2,0
           - la nostra geometria sta DENTRO la loro forbice: nessun allarme.
           INTERNA: AUDIT_USCITE_2026-09-09 - InpTrailOnST, InpExitOnFlip e
           InpFirstFraction hanno ZERO occorrenze come asse in tutto il repo.
COSTO      2 round H1 (veloci: pochi trade per corsa)
RISCHIO    campione sottile su H1: il giudizio sul MERITO va sospeso sotto 150 op
           (Emendamento della finestra, punto B). Il RISCHIO si giudica lo stesso.
RUMORE     ✅ e' il buco piu' grande per area non misurata, non per grandezza attesa
```

### 6️⃣ PROPOSTA 6 — MaxMin notte DAX: il nostro trailing e' 3,3 volte quello del preset DAX pubblico

```
PROPOSTA   770411 MaxMinNotte_DAX_Short: InpTrailAtrMult 2,0 -> asse {0,6 ; 1,0 ; 2,0}
DOVE       preset FTMO della sedia
FONTE      biblioteca/set/DaxMorningScalp_v2.31-...-BEstop_cmql5-31-1155_2026-08-23.set
           (DAX M15, Market 102586, NJtrading, 30 USD, catalogato il 23/08):
           SL 1,4 x ATR(5) · TP 2,0 x ATR · TRAILING 0,6 ATR · BE stop attivo
           Noi: SL 2,5 x ATR M15 · TP2 3R · TPfinal 4R · trailing 2,0 ATR
CONTESTO   ⚠️ DAX M15 ma NON la stessa finestra: loro entrano alle 11:20/11:45 broker
           (~10:20/10:45 server BCM), noi siamo il range notturno. Motore diverso.
COSTO      ~0 sviluppo, 3 celle
RISCHIO    un trailing 3x piu' stretto su un motore da notte puo' tagliare tutto
           prima dell'ora buona. Asse, non sostituzione.
RUMORE     🟠 da verificare: se sposta meno del 10% non vale il giro
```

### 7️⃣ PROPOSTA 7 — uscite per giorno della settimana (da segnalare, NON da fare ora)

```
PROPOSTA   moltiplicatore di TP/SL per giorno della settimana su US30
DOVE       770202 Dow_Apertura_US (nuovo input, non esiste)
FONTE      A4 - manuale US30 Market Maker, citazione verbatim:
           "ATR Stop Loss (mon-tues)" / "ATR Stop Loss (wed-thurs-fri)"
           valori nel preset prop: stop 0,9 e 1,5 ATR · TP 1,2 e 3,2 ATR (1,33R e 2,13R)
           ⚠️ [INCERTO] quale coppia a quale giorno: il .set non nomina i giorni
COSTO      ~2 ore sviluppo + 1 round
RISCHIO    🔴 e' il classico parametro che spacca il campione in due e trova
           "il martedi' e' diverso" per caso. Con ~100 trade/anno un giorno della
           settimana ne vede 20: sotto qualunque soglia di campione di casa.
PRIORITA'  🔴 ULTIMA. La segnalo perche' e' un meccanismo che non abbiamo, non
           perche' vada fatta adesso.
```

---

## ❓ 5. COSA NON HO TROVATO — per nome, perche' anche questo e' un dato

1. 🔴 **Nessun before/after pubblicato sul Profit Factor cambiando SOLO la gestione
   dell'uscita, su un indice intraday. Zero.** Ho cercato su MQL5 (blogs, forum, articles,
   Market) e via motore di ricerca. **L'unico esperimento di questo tipo con numeri veri che
   esiste al mondo, per quanto ho potuto vedere oggi, e' il NOSTRO R46/R47.** Non e' una
   battuta: e' il motivo per cui la Proposta 1 si appoggia su una misura di casa e usa
   l'esterno solo come conferma di direzione.
2. 🔴 **Nessuna misura pubblica di "a che R conviene il parziale, e con che percentuale"**,
   con campione e metrica. L'unico schema esterno che nomina 1R/50% (A6) **dichiara lui
   stesso di non avere backtest**. 👉 **Il nostro `InpTP1_R=1,0` + `InpTP1_ClosePct=50` non
   ha nessuna conferma esterna misurata.** E' un'eredita' di progetto, non un valore validato.
3. 🔴 **Nessun Profit Factor pubblicato da nessuno dei quattro vendor su indici.** Solo
   Return on Drawdown (ORB EA V2) o niente. Il PF come metrica **non si usa** nel marketing
   di questi prodotti.
4. 🔴 **Nessuna distribuzione MFE/MAE pubblica** su ORB di indici — che sarebbe il modo
   giusto di rispondere alla domanda del parziale. 🟢 **Ma la macchina ce l'abbiamo in casa**
   (`ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE.mq5`, e MFE/MAE usati in
   `report/ORO_1530_MISURA_GIRATA_2026-09-11.md`): **l'MFE mediano dei trade delle tre
   aperture dice a che R il parziale e' un regalo e a che R e' un furto**, e si misura senza
   chiedere niente al web.
5. 🔴 **Sorgenti open source di gestori d'uscita: NON LETTI.** GitHub e' 403 su tutto.
6. 🔴 **Thread "challenge passed/failed": NON LETTI.** Forex Factory e' 403 su tutto.
7. 🔴 **Lo studio Davey su 567.000 backtest delle uscite: NON LETTO.** Dominio bloccato.
   👉 Se un giorno quel dominio si sblocca, **e' il primo indirizzo da riaprire**: e' l'unica
   fonte nota che misura le uscite su un campione piu' grande del nostro.

---

## 🧭 6. LA COSA DA NON DIMENTICARE

Il diff **prop ↔ personale** del US30 Market Maker (§2.3) dice che i vendor, per la prop,
**non toccano l'uscita: tagliano la taglia**. Quindi la domanda di Claudio — _"alzare il
PF"_ — **non e' una domanda da prop firm: e' una domanda di edge.** La risposta giusta non
e' un preset nuovo sul conto vivo, sono **tre round sul PC di backtest** (P1, P2, P3), tutti
su manopole che **esistono gia'** e che costano **zero righe di codice**.

🟢 **E la buona notizia**: il buco #1 e' quello dove abbiamo gia' la misura in mano dal 14
agosto e non l'abbiamo mai tradotta in una proposta. Il lavoro di oggi non e' stato scoprirlo:
e' stato **verificare su 28 preset di quattro vendor indipendenti che il mondo la pensa come
la nostra R46** — e trasformarlo in una riga che Claudio puo' firmare.
