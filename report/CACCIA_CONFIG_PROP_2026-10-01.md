# CACCIA CONFIGURAZIONI PROP, 01/10/2026 (mandato "cercate ovunque parametri vincenti")

Letto tutto OGGI, 01/10/2026. Niente toccato: nessun EA, preset, `.set` in campo, niente comprato. Questo e' un dossier di esempi con valori e fonte: **le decisioni su taglie e rischio sono di Claudio**. Le righe "calcolo sul nostro caso" sono controfattuali di aritmetica, non proposte.

Etichette: **[SORGENTE LETTO]** = scaricato lo zip/aperto il `.mq5` e letto il valore · **[CODICE IN ARTICOLO]** = valore preso dall'HTML grezzo della pagina · **[SET LETTO]** = file `.set` scaricato · **[MANUALE VENDOR]** = pagina del vendor, dichiarato, NON verificato · **[SNIPPET]** = solo riassunto del motore di ricerca · **[CALCOLATO]** = aritmetica mia sui numeri del repo.

## 0. COSA NON HO RAGGIUNTO (in testa, come da mandato)

| fonte | esito oggi | conseguenza |
|---|---|---|
| ftmo.com, academy.ftmo.com, help.ftmo.com (WebFetch) | EGRESS_BLOCKED | **nessuna regola FTMO letta sulla fonte ufficiale**; solo [SNIPPET] del motore di ricerca, che riassume le pagine ufficiali `ftmo.com/en/ftmo-free-trial/`, `/trading-objectives/`, `academy.ftmo.com/lesson/maximum-daily-loss/` |
| propnavi, tradersfundhub, eafunded, fxvps.biz, tradertom (terze) | EGRESS_BLOCKED | niente testo, solo titoli dal motore di ricerca |
| Forex Factory | 403 | thread "challenge passed/failed" e ORB EA **non letti** |
| Reddit (`r/Forexprop`, anche old.) | 000 (bloccato) | **zero** testimonianze dichiarate |
| github.com (ricerca/topics) e api.github.com | 403 | niente caccia GitHub; **solo `raw.githubusercontent.com` risponde ma senza indice** |
| MQL5 (Code Base, articoli, blog, forum, market) | 200 | **fonte unica di questa caccia**: conseguenza, quasi tutti gli esempi sono MQL5 |

Controllo positivo, fatto prima: `mql5.com/en/code/76767` ha dato i 4 input attesi (5.0/10.0/0.5/0) e `c.mql5.com/6/914/ORB_EA_Set_Files.zip` ha dato 200 con 11 `.set` veri. FTMO ufficiale: controllo positivo **fallito** -> fonte NULLA, dichiarato.

Non e' stato letto neppure: il sorgente degli EA a pagamento (non si compra; per i prodotti Market ho usato solo manuali pubblici su blog e pagine Code Base), le pagine prodotto Market di Cross Pair Forge (letto il manuale-blog dell'autore).

## 1. TABELLA DEGLI ESEMPI NUOVI (oltre ai 15 gia' in `CACCIA_CONFIG_PROP_2026-09-13.md`)

Setaccio bandiere rosse (martingala, griglia, no-SL, repaint, DLL, recupero): vedi colonna "bandiere". Nessuna fonte qui sotto e' un EA da comprare: servono come **meccanismi**.

| # | fonte e data | tema | parametro = VALORE | etichetta | bandiere |
|---|---|---|---|---|---|
| **N1** | [Blog 776384, Amul Ravikumar, 26/09/2026](https://www.mql5.com/en/blogs/post/776384) | (2) somma del NUOVO rischio | `allowance = gDayOpenBal*InpDailyLossPct/100 + DayPL() - OpenRiskToStops()`; se `lot*LossPerLot(stop) <= allowance` ok, altrimenti **lotto ridotto** a `LotForRisk(allowance)`, o rifiutato (`"no daily allowance left"` / `"allowance below minimum lot"`). Input: `InpDailyLossPct=4.0` (su muro 5), `InpMaxDDPct=8.0` HWM, `InpRiskPercent=1.0`, `InpMaxPositions=3`, `InpFlattenOnLock=true`, `InpFridayFlat` da 20:00. `OpenRiskToStops` = somma `OrderCalcProfit` dal prezzo CORRENTE allo SL; posizione senza SL = rischio 0 | [CODICE IN ARTICOLO] (HTML grezzo) | nessuna |
| **N2** | [Code Base 76927 Session Range Desk, Erdem Kaynak, 03/09/2026](https://www.mql5.com/en/code/76927) | (1) e (2) | `DoTrade` r.441-456: `if(othersRisk + targetRisk > deskCap) -> non apre`. `MaxDailyRiskPct=2.0` (budget del giorno su tutte le copie), `RiskPercent=0.5`. **Il "committed" = rischio aperto finche' la posizione vive, PERDITA REALIZZATA quando chiude** (r.700-740: `if(realized<0) worst=-realized`), azzerato dal BE (r.617). Una operazione per simbolo per giorno (`tradeOpenedToday`). Filtro range: `Min_ATR_Mult=0.10`, `Max_ATR_Mult=0.40` su ATR(D1,14). `BreakoutMode=BREAKOUT_CLOSE`, `TP_R=2.0`, `BE_Trigger_R=1.0`, `PTP 50% a 2R` | [SORGENTE LETTO] | nessuna ("no grid, no martingale" nella descrizione, e il codice non ne ha) |
| **N3** | [Code Base 71480 ASQ PropFirmShield, 05/04/2026](https://www.mql5.com/en/code/71480) | (2) e (3) | `WouldBreachDailyLimit(loss){ return loss >= dailyLossRemaining; }`, con `dailyLossRemaining = dailyLimit + dailyPnL` (equity - equity di inizio giorno); `GetSafeRiskAmount = min(dailyLeft, ddLeft) * maxRiskPerTradePct/100`, **`maxRiskPerTradePct = 50` nel preset FTMO** (40 in due preset); `ASQ_PF_DANGER_ZONE = 80` (% del limite usato), `emergencyCloseAll` a **>= 90%** del limite | [SORGENTE LETTO] | nessuna |
| **N4** | [Blog 776423 Prop Firm Risk Guardian, Yuki Nakayama, 26/09/2026](https://www.mql5.com/en/blogs/post/776423) (vendor, versione Free/Pro) | (3) frazione della distanza dal limite | `Normal risk per trade (% of balance) = 1.0`; **`Cap: max % of remaining buffer per trade = 0.5`** (meta' del buffer residuo, buffer = min(perdita giornaliera residua, DD residuo)); lotto = minimo dei due; `Hard lot cap = 5.0`; stati: CAUTION a buffer <= **25%** (cioe' 75% usato), barre ambra al 60% e rosse all'80% usato; `Daily reset hour = 0`; ancora giornaliera `ANCH_BALANCE`; DD `DD_TRAILING_HWM` di default | [MANUALE VENDOR], default dichiarati | nessuna (non apre trade da solo) |
| **N5** | [Blog 775481 Cross Pair Forge, Kestutis Balciunas, 08/09/2026](https://www.mql5.com/en/blogs/post/775481) (EA in vendita, manuale pubblico) | (3) taglie, (5) BE | Guardia: `Daily loss and buffer = 5.0 e 0.8` (si ferma a **4,2%**), `Total loss and buffer = 10.0 e 0.8`; reset `Server midnight, 21`; `Max open risk across symbols = 12` (default largo); `Friday flatten 20 GMT`; news `15 prima / 10 dopo`; spread max 12 pip. **Rischio per programma**: due-step fase 1 **1.0-1.5** standard / **0.75** prudente; one-step stretto 0.75 / 0.5; trailing/3-step 0.5 / 0.35; funded 0.5 / 0.25. Uscite: stop 1,6 ATR (min 15 pip), **BE a 1,3R**, **parziale 50% a 1R**, trail 2,6 ATR da 1,5R, cooldown 12 barre. Tabella profili, "FTMO Free Trial: 5% giornaliero, 10% statico, reset mezzanotte CE(S)T, 2 giorni minimi, target 5" (letta 06/09/2026). `Compliant mode` = SL su ogni trade, 1 posizione per simbolo, niente serie; `No size increase after a loss` | [MANUALE VENDOR] (valori dichiarati, mai verificati) | motore = reversal su AUDCAD/NZDCAD, no griglia dichiarata; **bandiera lieve: "fastest 56 giorni, mai un pass in 14 giorni" onesto, ma i numeri sono suoi** |
| **N6** | [Blog 776075 Omega Gold Risk Guard (utility manuale), 19/09/2026](https://www.mql5.com/en/blogs/post/776075) | (1) e (2) | `MaximumTradesPerDay`, `MaximumOpenTrades=3` **con gli ordini pendenti che riservano slot**, `DailyLossLimitPercent` blocca i nuovi ingressi, `IncludeFloatingPLInDailyLimit`. Dichiara il limite: *"RiskPercent applies to the new group, not the combined risk of all open positions ... does not reserve the possible future losses of every open stop"* = **la stessa proprieta' del nostro C1** | [MANUALE VENDOR] | non e' un EA (pannello manuale) |
| **N7** | [Code Base 77047 Exposure Cap, J. Prata Silva Yglesias, 06/09/2026](https://www.mql5.com/en/code/77047) | (1) tetto per sottostante | `ExposureCap::Allowed(symbol, requestedLots, cap)`: somma i lotti aperti sul simbolo **di tutti i magic, manuali inclusi**, e rifiuta l'ordine PRIMA di inviarlo. Nato da 4 EA sullo stesso simbolo arrivati a 22 contratti. Dichiara: *"un check, non un lock"* (due EA nello stesso tick passano entrambi) | [SORGENTE LETTO] | nessuna |
| **N8** | [Code Base 76437 PropFirmEquityProtector, NoeRCz, 21/09/2026](https://www.mql5.com/en/code/76437) | (3) riduzione vicino al muro | `InpMitigationLossPercent=3.5` -> **chiude il 50% della posizione peggiore** (`InpPartialClosePercent=50`, ogni 5 s); `InpMaxDailyLossPercent=4.5` -> chiude tutto. Riferimento: balance di inizio giorno | [SORGENTE LETTO] | nessuna |
| **N9** | [Code Base 77710 PropGuard 1.02, 25/09/2026](https://www.mql5.com/en/code/77710) | (3) buffer, news | `InpDailyLossPct=4.0` ("per un muro 5%") e `InpMaxLossPct=8.0` (per muro 10%) = **buffer 1,0 e 2,0**; `InpMaxLossMode` statico/trailing/EOD-trailing; `InpResetHour=1` (= 00:00 CE(S)T in server +1); `InpMaxRiskPerPos` **stringe lo SL** al rischio massimo; `InpRequireStopLoss` chiude dopo 60 s; news `2 min prima / 2 min dopo` (default); `InpBestDayInfo` logga il rapporto giorno migliore / giorni positivi (regola FTMO 1-Step 50%) | [SORGENTE LETTO] | nessuna |
| **N10** | [Code Base 77591 PropFirm Risk Guardian, R. Sharma, 22/09/2026](https://www.mql5.com/en/code/77591), [77350 Prop-Firm Equity Guard, C. Ciunae, 14/09/2026](https://www.mql5.com/en/code/77350) | (3) buffer | `InpDailyLossPct=5.0`, `InpMaxLossPct=10.0`, **`InpBufferPct=1.0`** in entrambi; `InpSingleTradeLossPct=1.0` (perdita flottante massima per posizione, ferma l'account se la tocca); flag `DDGUARD_HALT` in variabile globale per gli altri EA (architettura gemella del nostro canale GV) | [SORGENTE LETTO] | nessuna |
| **N11** | [Code Base 77156 PropFirm Defense, B. Nunes Myrrha Ribeiro, 09/09/2026 (agg. 01/10)](https://www.mql5.com/en/code/77156) | scala di risposta | 4 direttive in scala: `ADVISORY` < `BLOCK_NEW_ENTRIES` < `FLATTEN` < `LOCKDOWN` (chiude e **spegne Algo Trading**); `safety_buffer_ratio=0.80` (avviso all'80% del limite); `InpPF_ConsistencyMaxShare=0.30`; reset nel fuso DELLA PROP, non del broker | [SORGENTE LETTO] | nessuna |
| **N12** | [Blog 776344 K. Sakamoto, 25/09/2026](https://www.mql5.com/en/blogs/post/776344) | (3) sizing da peggior giornata | peggior giornata (chiuso + flottante al minimo) = 6% con cap 5% -> **meta' lotto = 3%**, poi **margine x2** -> 25% del lotto originale; "il flottante AL RESET conta" | [MANUALE VENDOR/blog] (via riassunto, [NON VERIFICATO sull'HTML]) | dice "griglia/averaging strutturalmente incompatibili" |
| **N13** | [Articolo 21231 Part 4, Solomon A. Sunday, pagina datata 13/09/2026](https://www.mql5.com/en/articles/21231) | (3) throttle dopo drawdown | `EnableAdaptiveRisk=false` di default, **`DDLevel=3.0`** (DD % dal picco equity), **`RiskReductionFactor=0.5`** (rischio dimezzato); base rischio `RISK_BASE_BALANCE` o equity (con equity il lotto successivo si riduce da solo mentre un'altra posizione e' in perdita) | [CODICE IN ARTICOLO] | nessuna |
| **N14** | [Articolo 19655, E. Mmene, 11/12/2025](https://www.mql5.com/en/articles/19655) | (3) throttle, news | rischio base **2,0%** (largo), `DailyDDLimit=2.5`, `OverallDDLimit=5.5`, `NewsPause=15 min`; **riduce dopo perdite e AUMENTA dopo vincite**; flag `DailyDDReached` | [CODICE IN ARTICOLO via riassunto] | rischio 2% e rialzo dopo vincite: lo cito solo come contro-esempio di taglia |
| **N15** | [Code Base 76153 Session ORB EA, 15/08/2026](https://www.mql5.com/en/code/76153) | (4) apertura | range `InpOpeningRangeMinutes=30`, finestra `InpTradingWindowMinutes=120`, **`InpBreakoutBufferPoints=20`**, **`InpStopLossBufferPoints=30`** oltre il lato opposto, `RR=2.0`, **`InpMaxTradesPerSession=1`**, `Risk 1.0%` | [SORGENTE LETTO] | nessuna |
| **N16** | [11 `.set` ORB di Lee Samson (Market 90502/91232), blog 751385, 05/01/2023](https://www.mql5.com/en/blogs/post/751385) | (4) e (5) | `.set` DAX/NAS/DOW **[SET LETTO]**: vedi sezione 5. Rischio $500 su 100k (0,5%), un set NAS a $1000 (1,0%), tre set add-on a $100 (0,1%). **`close_all = -2500` in TUTTI gli 11 = chiusura di tutto a -2,5% di giornata (aperto+chiuso)** | [SET LETTO], rendimenti [MANUALE VENDOR] | **bandiere: modalita' "continuous" (ri-piazza l'ordine dopo lo stop = secondo tentativo), pyramiding "add-on"; set del 2023, MT4, non nostro broker** |
| **N17** | [Blog 776235 "ORB paper replicated on five indices", T. Krueger, 25/09/2026](https://www.mql5.com/en/blogs/post/776235) | (4) evidenza | regola ORB della letteratura (prima candela 5 min, stop all'estremo opposto, target 10R) su NQ/SPX/Dow/DAX/FTSE 2015-06/2026, ~2.900 sessioni: **lordo reale (DAX +0,100 R) ma netto zero o negativo** (DAX -0,038 R, Dow -0,081 R) con costi 2,5 / 4,0 punti; **pavimento: rischio iniziale >= 2x il costo andata/ritorno**; 2015-2017 negativo ovunque | dati dell'autore, [NON VERIFICATO] | contro-evidenza utile, non un setup |
| **N18** | [Code Base 77386 Smart Loss Exit, 16/09/2026](https://www.mql5.com/en/code/77386) | (5) stop ritardato | **`InpGraceMinutes=5`** (nessuna uscita prima di 5 minuti dall'apertura), `InpAtrMultiple=1.5`, `InpMaxMinutes=240` (esce se ancora in perdita), EMA 20/50 | [SORGENTE LETTO] | e' un'uscita a mercato "morbida" sopra lo SL, non lo SL |
| **N19** | [Code Base 76999 Safe Risk Manager, 22/09/2026](https://www.mql5.com/en/code/76999), [77060 SessionReopenEA, 07/09/2026](https://www.mql5.com/en/code/77060) | (5) BE e tempo | BE a 500 punti con offset 20 su SL 500 / TP 1000 (BE a 1R), trail 700/350; SessionReopen: stop `2.0 x` range orario medio, tenuta 2 ore, entrata solo nei primi 10 minuti dall'ora | [SORGENTE LETTO] | nessuna |

Ripetuto dal dossier del 13/09, gia' acquisito: 3,0% di rischio aggregato in tre autori; 80% del limite come pausa (F2, F3); buffer da 0,5 a 1,0 (F1, F13, F14).

## 2. IL "STOP DA UN SOTTOSTANTE": COSA ESISTE FUORI, COSA ABBIAMO NOI

**Tema (1): tetto di perdita giornaliera per sottostante e "dopo uno stop sullo stesso indice niente secondo ingresso".**

- **Non ho trovato nessun guardiano pubblico con un input "perdita massima per sottostante/giorno"**: tutti i guardiani letti sono a livello CONTO (N1, N3, N8, N9, N10, N11). [VERIFICATO sulle fonti sopra; **[INCERTO]** per cio' che sta nei thread Forex Factory/Reddit che non ho potuto aprire].
- Quello che esiste e si avvicina:
  - **N2**: una operazione per simbolo al giorno + **budget di giornata che conta la perdita realizzata** (`othersRisk + targetRisk > deskCap`). E' il modo in cui un secondo ingresso dopo uno stop viene rifiutato **senza una regola sul simbolo**: il budget (2,0% nel default, r.71) e' gia' consumato dallo stop.
  - **N7**: tetto per simbolo su tutti i magic, ma conta solo le posizioni **aperte** (non gli stop gia' presi oggi).
  - **N6/N15/N19-AAPL**: `MaximumTradesPerDay`, `InpMaxTradesPerSession=1`, `MAX_TRADES_PER_DAY=2` (Code Base 76333, **rischio 5% per trade: bandiera rossa, non usato per valori**).
  - **N16**: `close_all=-2500` su 100k = **-2,5% di giornata, aperto+chiuso**, uguale in 11 preset ORB indici.
- **Nostro stato [VERIFICATO nel repo oggi]**: `ABTG_DAX_Apertura_EU.mq5` (r.1194 e altre 6) e `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` (r.245) chiamano `ABTG_GuardiaIngresso(InpUsaGuardian,"nome")` **con i soli due argomenti**: pausa B1 e cap C1, e basta. **P1** (perdite consecutive, `ABTG_TroppePerditeConsecutive`) esiste nell'include ma e' **per magic** (`DEAL_MAGIC==magic`) e a soglia 0 e' spento; **P0** (tetto simbolo+lato) conta aperte+pendenti di tutti i magic ma non la storia di oggi. **Il 01/10 il 770411 (stop 10:06) e il 770105 (ingresso 11:13) sono due magic diversi sullo stesso indice**: nessun meccanismo nostro li lega. `InpOneTradePerDay=true` del 770411 e' per EA.
- Il Bulge ha i suoi (`Max_SL_PerDay=4`, `Max_Consecutive_SL=3`, `Max_Daily_Loss_Pct=2.0`, ABTG_Bulge.mq5 r.394-395), ma sono **per istanza**, e il 01/10 le istanze erano due.

**Calcolo sul nostro caso [CALCOLATO, controfattuale, non proposta]** con i numeri di `TRIAL_GIORNO1_ANALISI_2026-10-01.md`:
- Perdita realizzata alle 11:11 = 3.292,52 + 1.357,14 = **4.649,66 (2,91%)**: sotto la pausa 3,5% (5.600), quindi il secondo DAX (rischio 2% = 3.200) e' passato.
- Con la formula N2 su un budget giornaliero del 4,0% (6.400): `4.649,66 + 3.200 = 7.850 > 6.400` -> **rifiutato**. Con N1 e limite 4,5% (7.200): allowance = 7.200 - 4.649,66 - rischio aperto GBPNZD A+B (1.277+1.596 = 2.873) = **-323** -> rifiutato.

## 3. TEMA (2): SOMMARE IL RISCHIO DELL'INGRESSO NUOVO NEL CAP

**Esempi con valori**: N1 (`EntryFits`: ingresso ridotto o rifiutato se `rischio_nuovo > allowance`), N2 (`othersRisk + targetRisk > deskCap`), N3 (`WouldBreachDailyLimit(loss)`), N5 (`Max open risk across symbols = 12`, **default molto largo, e non dichiara se somma il nuovo**: [INCERTO]), N6 (Omega **non** somma: stessa proprieta' del nostro C1, ma la dichiara in chiaro).

**Nostro stato [VERIFICATO]**: il Guardian scrive la bandiera `ABTG_CAP_RISCHIO` quando `riskPct >= InpMaxOpenRiskPct` (`ABTG_Guardian.mq5` r.789-797); l'EA legge la bandiera in `ABTG_GuardiaIngresso` (`ABTG_PausaGuardian.mqh` r.1722-1727, `ABTG_CapAttivo_Calc` r.336). **Nessun argomento di `ABTG_GuardiaIngresso` porta il rischio dell'ingresso nuovo** (firma a r.1587-1598), e il **valore del cap non e' pubblicato** in nessuna GV (c'e' solo `ABTG_RISCHIO_APERTO`, il rischio aperto in %, usato "per log e pannelli", mqh r.755). Quindi per sommare il nuovo servono: (a) un argomento nuovo `rischio_nuovo_pct` in coda (come gia' fatto per P0/P1/C2, 100 chiamate in 70 EA) e (b) una GV col valore del cap. Documentato in repo: i pendenti non si contano (B6) e il ciclo del Guardian e' a 1 secondo.
- 01/10, 10:00 [CALCOLATO]: rischio aperto prima di B = 3,63% (5.808), B = 1.596 (1,00%) -> 4,62% contro cap 4,00%. Con N1 e limite 4,0% (6.400): allowance = 6.400 - 5.808 = 592 -> B **ridotto a ~37%** del lotto; con limite 4,5% (7.200): allowance 1.392 -> **~87%** (ignoro il flottante, non noto).

## 4. TEMA (3): SIZING PER PROP

| riferimento | valore | fonte |
|---|---|---|
| rischio per trade, prop 2-step fase 1 | **1,0-1,5** standard · **0,75** prudente | N5 [MANUALE VENDOR] |
| rischio, programmi stretti (1-step) | 0,75 / 0,5 | N5 |
| rischio, funded/instant | 0,5 / 0,25 | N5 |
| rischio per trade default dei guardiani | **1,0** | N1, N4, N13, N15 |
| **frazione del buffer residuo per trade** | **0,5 = 50% del residuo** | **N4 (default 0.5) e N3 (`maxRiskPerTradePct=50`)**: due autori indipendenti |
| riduzione del rischio dopo drawdown | a DD **3,0%** dal picco -> rischio **x0,5** | N13 |
| riduzione di posizione vicino al muro | a perdita giornaliera **3,5%** chiude **50%** della peggiore | N8 |
| buffer prima del muro | 0,8 · 1,0 · 2,0 (DD totale in N9) | N5, N10, N9 |
| avviso/pericolo | **80%** del limite usato (N3, N11) · **90%** chiusura totale (N3) · CAUTION a 75% usato (N4) | |
| rischio per trade in set ORB indici | $500/100k = **0,5%** · $1000 = 1,0% · $100 = 0,1% | N16 |
| ORB indici desk | `RiskPercent=0.5`, budget giornata 2,0% | N2 |

**Nostro stato**: 0,65% fisso per sedia sul forex e **2,00% per sedia sugli indici DAX** (preset `ABTG_MaxMinNotte_DAX_Short_770411_FTMO.set`: `InpRiskPercent=2.00`; il Bulge del trial a 0,80% / 1,00%, `Max_Trades=3`). Nel Guardian **non esiste ne' sizing dinamico in funzione del buffer residuo ne' throttle dopo drawdown**: la risposta e' binaria (pausa 3,5% sul preset FTMO, emergenza 4,5%, preset FTMO `InpDailyLossPct=4.5`, `InpTotalDDPct=9.3`: **buffer 0,5 e 0,7, gia' alle cifre di F1**; il buco del 13/09 e' chiuso su questo preset). Il rischio 2,00% per trade sugli indici sta **sopra ogni riferimento esterno letto** (massimo 1,0% nei default, 1,5% il massimo prudente del manuale N5).
- Il numero del buffer 50% sul 01/10 [CALCOLATO]: residuo giornaliero 5% (8.000) - 4.649,66 = 3.350,34 -> 50% = **1.675 (1,05%)** contro i 3.200 (2,00%) del DAX preso alle 11:13: lotto **~6,3 invece di 12,08**; a stop pieno la perdita sarebbe stata ~1.630 invece di 3.110 (flottante ignorato; DD totale non binding).
- Prop **FTMO Free Trial**: [SNIPPET] sulle pagine ufficiali e [MANUALE VENDOR] N5 convergono su **14 giorni, target dimezzato (5%), 5% giornaliero, 10% massimo statico, reset a mezzanotte CE(S)T, 2 giorni minimi** per il 2-Step; un altro riassunto di terze parti cita anche una versione 1-Step con 3% giornaliero e 10% trailing EOD [SNIPPET, non aperta]. **Quale dei due e' il 160K di Claudio NON e' verificato**: lo decide la pagina Trading Objectives del suo cruscotto. Formula giornaliera [SNIPPET dell'academy FTMO]: **limite = saldo a mezzanotte CE(S)T - % del capitale iniziale**, misurato su **equity (flottante, commissioni e swap inclusi)** -> il nostro `InpDailyBaseline=1 (SALDO)` e' la modalita' coerente (il preset FTMO attuale non la valorizza: **da verificare in campo**, [NON VERIFICATO]).

## 5. TEMI (4) e (5): APERTURA CASH E STOP/BE

**Valori dai `.set` di Lee Samson** [SET LETTO] (MT4, 100k, set del 2023: unita' "pip" su broker a 1 cifra, quindi **[INCERTO]** se 400 = 40 punti; DAX apre alle 10:00 di quel broker = 09:00 CET):

| set | rischio | range -> ingressi | stop | TP | trail / BE | chiusura ordini |
|---|---|---|---|---|---|---|
| DAX 2 Percent | $500 | 10:00 -> 10:05, 10:10, 10:15 | 400 | nessuno (10000) | trail 300, BE spento | 11:30 |
| DAX 3 "5 and 15 TP" | $500 | -> 10:05, 10:15 | 400 | 50 / 1000 / 250 | trail 300 | 11:30 |
| DAX 6 "15 Min Pre" | $500 | **09:45 -> 10:00, 10:05** | 250 | 1000 | trail 450 | 11:30 |
| DAX 7 "5 Min Only" | $600 | 10:05, 10:10, 10:15 | 500 | 1000 | trail 300 | 11:30 |
| NAS 2 "5 and 15 Tight" | **$1000** | 16:30 -> 16:35, 16:45 | **300** | nessuno | trail 400, **BE 100** | 18:00 |
| NAS 5 Percent | $500 | -> 16:35 .. 16:45 | 400 | nessuno | trail 1000 | 18:00 |
| tutti e 11 | | `offset=0` (nessun buffer sul livello), `per_bar=1` (BE/trail su chiusura barra), `max_rng=5000`, `min_rng=1`, **`close_all=-2500`** (-2,5% di giornata) | | | | |

Altri valori per ingresso/stop all'apertura: N15 (buffer 20 punti, SL 30 punti oltre il range, 1 trade per sessione), N2 (range accettato solo se tra 0,10 e 0,40 x ATR giornaliero; conferma a CHIUSURA di barra), N17 (pavimento rischio >= 2x costo di round-trip; costo DAX 2,5 punti, Dow 4,0), N18 (grace di 5 minuti prima di qualunque uscita a mercato).

**Quello che NON ho trovato**: nessun esempio pubblico di "attendi X minuti dopo l'apertura cash prima di piazzare" scritto come input con valore, oltre ai `.set` di Samson (ingressi **solo dopo la chiusura delle barre da 5/10/15 minuti**, cioe' mai prima delle 09:05 CET, il ramo "15 Min Pre" ha il range 09:45-10:00 e ingresso a 10:00 sul pre-apertura) e a N2/N15 (range di 15-30 minuti). Un test di "stop in multipli di rumore d'apertura" come input dichiarato: **non trovato**; il piu' vicino e' N2 (filtro di ampiezza del range in multipli di ATR D1) e N15/N16 (SL come % del range: `OR_stp_pct=110` nei `.set`, cioe' 110% dell'ampiezza del range).

**Nostro stato [VERIFICATO]**: `770411` mette l'ordine alle `InpPlaceHour=9, InpPlaceMin=59` (server FTMO = IT+1: 09:59 = **un minuto PRIMA** dell'apertura cash del DAX alle 10:00), `InpBufferPoints=1000.0` (unita' broker BCM), SL = `2.5 x ATR M15`, `InpBreakeven=true`, TP1 1R 50%, TP2 3R, trailing 2 ATR. L'ingresso e' dentro il rumore d'apertura per costruzione (il 01/10: fill a 24.998,25, stop a 25.067,16 dopo 6 minuti e 31). Un buffer-dopo-apertura come input non c'e'. Il Bulge ha `Enable_BE_1R=false`, `BE_At_R=1.0`, `BE_Offset_Points=2` (BE spento di default, gestione "nuda", `ABTG_Bulge.mq5` r.441-443).

**BE tipici trovati**: 1,0R (N2, N19), **1,3R con parziale 50% a 1R e trail da 1,5R** (N5), 1,2R + trail 1,3R / 0,3 ATR (AAPL_Pro, risk 5%: solo per la forma), BE a 100-500 "pip" nei `.set` ORB (N16). Con `Enable_BE_1R=false` noi siamo l'unica gestione "nuda" tra quelle lette.

**Lettura di cautela [N17]**: l'evidenza indipendente trovata sull'ORB indici dice **lordo reale, netto ~zero** sui costi di CFD. Non e' una prova contro i nostri motori (che non sono ORB a candela di 5 minuti), ma e' l'unico numero indipendente trovato su come va la meccanica quando il costo sale: il pavimento "rischio >= 2x costo" va confrontato con la frontiera di casa `stop >= 40 x spread`.

## 6. MAPPA: COSA ABBIAMO, COSA MANCA

| meccanismo | fonte | Guardian / EA nostro | stato |
|---|---|---|---|
| somma del rischio NUOVO nel cap aperto | N1, N2, N3 | C1 e' una bandiera sul gia' aperto (r.789); nessun argomento col rischio nuovo | **MANCA** (misurato 01/10: 4,62% contro 4,00%) |
| budget di giornata = rischio aperto + perdita REALIZZATA | N2, N1 | pausa B1 conta solo il realizzato, C1 solo l'aperto, **mai la somma** | **MANCA** |
| "dopo uno stop sullo stesso indice niente secondo ingresso" tra magic diversi | nessuna fonte esatta; N2/N7 vicini | P0 (aperte+pendenti) e P1 (per magic) esistono, **non chiamati dai due EA DAX** | **MANCA / non adottato** |
| sizing a frazione del buffer residuo (50%) | N3, N4 | non esiste; pausa binaria | **MANCA** |
| throttle dopo DD (x0,5 a 3%) | N13 | non esiste | **MANCA** |
| riduzione parziale vicino al muro (50% della peggiore a 3,5%) | N8 | non esiste (solo chiusura totale) | **MANCA** |
| buffer dal muro 0,5-1,0 | F1, F13, F14, N9, N10, N5 | preset FTMO 4,5 e 9,3 (0,5 / 0,7) | **COPERTO sul preset FTMO** |
| pausa a 80% del limite | F2, F3, N3, N11 | 3,5% su 5% = 70% (pausa) · emergenza 4,5% = 90% | **COPERTO** (3,5 e' piu' prudente di 4,0) |
| baseline giornaliera SALDO per FTMO | [SNIPPET] FTMO, N5 | input esiste (`InpDailyBaseline`), non valorizzato nel preset | **da firmare / verificare** |
| scala ADVISORY/BLOCK/FLATTEN/LOCKDOWN | N11 | pausa + emergenza (chiude) esistono; spegnere Algo Trading no | parziale |
| tetto trade al giorno | N6, N15 | nessuno su EMA200; Bulge `Max_SL_PerDay` per istanza | **MANCA sugli EA DAX** |
| ingresso dopo l'apertura cash (buffer in minuti) | N16 (barre 5/10/15) | `InpPlaceMin=59` = 1 minuto prima | **diverso dal campo** |
| stop in multipli di range/ATR d'apertura | N2, N15, N16 | SL = 2,5 x ATR M15 | parziale (ATR si, range no) |
| BE a 1R / parziale | N2, N5, N19 | DAX: `InpBreakeven=true`, TP1 1R 50%; Bulge: BE spento | DAX coperto, Bulge no |
| grace period prima delle uscite morbide | N18 | non esiste | **MANCA** (solo se mai si aggiungessero uscite morbide) |

## 7. SE DOVESSI ORDINARE PER RESA/COSTO (NESSUNA DECISIONE)

1. **Somma del rischio nuovo nel cap C1** (N1, N2, N3): nuovo argomento in coda a `ABTG_GuardiaIngresso` + GV del cap; ~mezza giornata + autotest sul nucleo + ricompilazione di ogni EA; [FIRMA DI CLAUDIO] perche' tocca il rischio. Misurato 01/10, 4,62% contro 4,00%.
2. **Budget di giornata (aperto + realizzato) con rifiuto o riduzione del lotto** (N1/N2): stesso punto di ingresso, stessa unita' `rischio_nuovo`; **e' la sola regola trovata che avrebbe bloccato il secondo DAX dell'01/10 senza una regola sul simbolo**.
3. **Sizing a frazione del buffer residuo (50%)** (N3, N4): un secondo parametro nello stesso calcolo del lotto; [FIRMA DI CLAUDIO].
4. Adottare P0/P1 gia' scritti negli EA DAX: costo di un parametro e una chiamata, **ma sono tetti di rischio = firma**.
5. Ingresso dopo l'apertura cash: **non c'e' una sorgente pubblica che dia il valore**; sarebbe una misura da fare in casa (cella da testare nel tester su 770411), non una copia.

Cose che NON si copiano: modalita' "continuous" di Samson (ri-piazza l'ordine dopo lo stop: va contro "niente secondo ingresso"), pyramiding "add-on", rischio 2-5% degli esempi didattici (N14, AAPL_Pro).

## 8. PROVENIENZA

Zip e sorgenti scaricati in `scratchpad` (non nel repo): Code Base **77710 · 77591 · 77364 · 77350 · 77156 · 77047 · 76999 · 76518 · 76437 · 76153 · 76333 · 77060 · 76927 · 49713 · 71480 · 77386 · 71479 · 71476** e lo zip `ORB_EA_Set_Files.zip`. Blog/articoli letti grezzi: **776384 · 776423 · 775481 · 776075 · 776235 · 751352 · 751385 · 768834 (marketing, nessun valore) · 21231 · 23732**. Letti via riassunto (meno forti): 776344, 19655, 77156 (pagina), 77591 (pagina). Pagine ufficiali FTMO: solo [SNIPPET].
