# Piano Free Trial FTMO con le sedie (30/09/2026)

Stato: SOLA LETTURA e piano. Nessuna riga lanciata, nessun EA/preset/conto/VPS toccato, nessuna spesa, nessuna taglia proposta (il rischio per operazione e' di Claudio).
Etichette: [MISURATO] = letto in un file del repo, con fonte; [INFERITO] = dedotto; [NON MISURATO] = manca il dato, non lo riempio.

## 0. Cosa Claudio ha gia' detto (30/09) e cosa NO
- UNA sola Free Trial, **160.000 EUR, valuta EUR**. Durata, server, login, leva, nomi simboli: li dara' all'apertura. Non li asserisco.
- Precedente, da RILEGGERE e non riusare: il trial del 27/08 era 200.000 USD, HEDGE, server FTMO-Demo, 166 simboli, 14 giorni dalla prima operazione, attivazione entro 7 giorni (`backtest_pipeline/risultati_archivio/PIANO_PROVA_GENERALE_FTMO.md` par. 1.1, [OSSERVATO 27/08]). 160.000 EUR = 200.000 USD al rapporto 0,8 del regolamento (80.000 EUR = 100.000 USD, `docs/REGOLAMENTO_FTMO_2026-09-20.md` par. 3) [INFERITO]. Non so se quel trial fu usato o scadde.
- Le regole DELLA trial (Max Loss, Daily Loss, statico o trailing, Standard o Swing, reset) sono [NON MISURATO]: nel repo ci sono solo quelle del 2-Step. Il 27/08 la pagina Trading Objectives del cruscotto fu la prima fonte aperta a occhio (par. 1.3 dello stesso piano): va rifatto, screenshot a Claudio all'apertura.

## 1. Cosa dipende dal saldo/valuta nei preset FTMO (letto in `mql5/Presets/FTMO/*` e `mql5/Presets/ABTG_Guardian_FTMO_2Step.set`)
Le sette sedie (770101, 770105, 770202, 770260, 771531, 770511, 770411) non hanno NESSUN importo assoluto: `InpRiskPercent=2.00` e' una percentuale e il lotto usa `ACCOUNT_BALANCE` (`ABTG_DAX_Apertura_EU.mq5` r.2254 `CalcLotByRisk`; `ABTG_EMA200.mq5` r.470; `SuperWave` r.526; `MaxMinNotte` r.431). Le soglie in punti (`InpSLFixedPts=3000`, `InpMinStopPts=500`, `InpTrailFixedPts=410`) sono prezzo, non soldi. Quindi a 160.000 EUR i lotti sono circa il DOPPIO di quelli a 80.000 (GER40 770101: 22,25 lotti a 80k per stop 71,9 pt, `QUANTE_SEDIE_CI_STANNO_2026-09-23.md` par. 3.2, -> circa 44,5) [INFERITO, lineare].

**L'unico input in soldi e' nel Guardian**: `InpStartBalance=80000` (ancora di TUTTE le soglie: `ABTG_Guardian.mq5` r.572 e OnTimer `dailyLimit = pct/100*gStart`, `totalDD = gStart - eq`).

| voce (fonte: preset Guardian + regolamento) | a 80.000 (challenge) | a 160.000 EUR (trial) | va riallineata? |
|---|---:|---:|---|
| `InpStartBalance` | 80000 | **160000** | SI, obbligatorio |
| Limite giornaliero ufficiale 5% (muro) | 4.000 | 8.000 | no (regola FTMO, [2-Step; per la trial NON MISURATO]) |
| Muro ufficiale 10% statico -> linea equity | 8.000 -> 72.000 | 16.000 -> 144.000 | idem |
| `InpDailyPausePct` 3,5% (pausa morbida) | 2.800 | 5.600 | scala da sola col valore giusto di StartBalance |
| `InpDailyLossPct` 4,5% (emergenza giorno) | 3.600 | 7.200 | idem |
| `InpTotalDDPct` 9,3% (emergenza totale) -> pavimento | 7.440 -> 72.560 | 14.880 -> **145.120** | idem |
| `InpMaxOpenRiskPct` 4,00 (cap C1) | 3.200 | 6.400 | no: e' % dell'equity, non legge StartBalance |
| `InpDailyResetHour=1` | ora 1 server FTMO = 00:00 CE(S)T | uguale SE il server della trial ha lo stesso orologio | verificare all'apertura (par. 2) |
| `InpRiskPercent` 2,00 (7 sedie) | 1.600 per stop pieno | 3.200 | NON si tocca: e' scelta di Claudio (par. 5) |
| TradeExporter `InpFile=ABTG_Trades_FTMO.csv`, `InpUseCommon=true` | - | **nome da cambiare** | SI: vedi par. 2 |
| Bulge v5.20 `Symbols_List`, `InpMagic=772700` | - | da adattare ai nomi FTMO | par. 3 |

**Guardian a 80000 su un conto di saldo S diverso** (letto nel codice, non supposto): il pavimento totale resta a 72.560 e la soglia giornaliera a 3.600, qualunque sia S.
- **S = 160.000**: il totale scatta solo a equity <= 72.560, cioe' dopo -54,6% del conto: a tutti gli effetti NESSUNA protezione dal muro 10% (che sta a 144.000). Il giornaliero scatterebbe a 3.600 = 2,25% di 160.000 (troppo presto: e' l'unico errore che costa "solo" operativita').
- **S < 72.560** (non e' il caso, ma e' la regola): `breachTotal` al primo giro di timer -> `FlattenAll()` + `GV_FAILED` -> tutti gli ingressi bloccati per 30 giorni (`SetPausa(TimeCurrent()+30*86400)`).
- Le variabili globali del Guardian sono per LOGIN (`ABTG_GUARD_<conto>_START_V2`): sul conto nuovo non ereditano nulla da 541452707. Con `InpStartBalance=0` catturerebbe l'equity al primo avvio (r.573), ma un numero scritto e verificato contro il saldo letto dal PREVOLO e' piu' sicuro.
- Il preset Guardian non ha input di valuta; il 160.000 e' nella valuta del conto. I lotti usano `OrderCalcProfit`/tick value convertiti dal broker (`CalcLotByRisk`): nessun cambio da fare se la valuta e' EUR. [se fosse diversa da EUR: [NON MISURATO]].

**Lotti grandi, margine, lotto massimo (tutto [INFERITO] salvo dove indicato)**
- Il margine in % del conto NON cambia con il saldo a parita' di r%: sei sedie aperte insieme a 2,00% chiedevano 84.055 EUR = 105,07% del conto a 80k, leva indici 1:50 (`QUANTE_SEDIE_CI_STANNO_2026-09-23.md` par. 3.2-3.3; leva 1:100 di conto e margine indici 1:50 misurati sul conto 541452707 in `PREVOLO_FTMO_specifiche_2026-09-20.csv`). Il sesto ordine non entrava (`not enough money`). A 160k resta ~105% (assoluto ~168.000) SE la leva della trial e' la stessa: **leva della trial [NON MISURATO]**.
- `SYMBOL_VOLUME_MAX` sul conto 541452707: GER40.cash/US30.cash/US100.cash 1000 lotti, XAUUSD 100, USDJPY 50; min/step 0,01 (stesso CSV). A 160k i lotti indice attesi (30-48) sono ben sotto. **Il massimo della trial e' [NON MISURATO]**. Se fosse piu' basso del lotto calcolato, gli EA NON ricevono un rifiuto: `lot = MathMin(maxLot, lot)` (`CalcLotByRisk`; Bulge `CalcLots` r.1241) -> aprono piu' piccolo e il rischio reale scende sotto r% in silenzio. Da leggere nel PREVOLO e da confrontare col primo lotto reale.
- FTMO: "Platform servers have 200 orders at a time and 2000 max positions per day" e 2.000 richieste/giorno tra aperture, modifiche e chiusure (`REGOLAMENTO_FTMO_2026-09-20.md` par. 2) [LETTO-VIA-SEARCH]. Con lotti doppi non cambia il conteggio delle richieste.

## 2. Il pericolo del terminale (C:\FTMO) e come schierare sicuro
Fatti [MISURATI]:
- CODA_01 del 30/09 03:30 (`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260930_033005.log`): `C:\FTMO` (conto 541452707, cartella dati `46C9F8E9FF0C747B2B5E09BCC13D5237`), profilo attivo `Default`, **10 grafici**: le sette sedie (770101, 770105, 770202, 770260, 771531, 770511, 770411) + Guardian 779001 (NZDJPY H1) + TradeExporter (NZDUSD) + SpreadLogger (US500.cash). Gli EA sono i `CLAU12_*` del 20/09.
- CODA_08 (stessa data): **i parametri vivono nei `.chr`**: `InpRiskPercent=2.0` su tutte le sedie, Guardian `InpStartBalance=80000`, TradeExporter `InpFile=ABTG_Trades_FTMO.csv`.
- CODA_03: il giornale di `C:\FTMO` ha come ultimo accesso 541452707 del 26/09; la challenge e' chiusa, conto in sola lettura fino a circa il 05/10 (`report/FTMO_CHALLENGE_CHIUSURA_2026-09-30.md` par. 4.5).
- `SCHIERA_FTMO.ps1` (`backtest_pipeline/righe/SCHIERA_FTMO.ps1`, ultimo commit `c20ebfc9`): SOLO COPIA. Non compila (F7 a mano), non attacca EA, non apre grafici, non scrive `.chr`/profili. Quattro serrature per trovare la cartella dati: non e' una delle 7 note per hash, `origin.txt` senza BCM/Pepperstone/Tickmill/MT5_Backtest/MT5_MANUALE, il giornale (`<dati>\logs`) contiene `-ContoAtteso` E la parola FTMO, una sola candidata. `-Pin` = SHA di 40 caratteri: i preset si prendono dal pin, i `.mq5` hanno ciascuno il suo pin nella tavola. NON contiene ne' 770105 ne' Bulge (0 occorrenze), e non controlla `InpStartBalance`.
- Che cosa succede al login di un conto nuovo dentro `C:\FTMO`: **[NON MISURATO]**. Se MT5 lascia gli EA attaccati e Algo Trading e' verde, partono con 2,00% (lotti doppi) e Guardian a 80000 (protezione totale assente, vedi par. 1). Da conoscenza generale MT5 ha un'opzione per disattivare il trading al cambio di conto (Opzioni, scheda Expert Advisor): stato e default NON sono in nessun file del repo. Non ci si affida.
- `ABTG_TradeExporter` scrive in `Common\Files` (comune a tutti i terminali dello stesso utente Windows) con `FILE_WRITE`, cioe' RISCRIVE il file: una trial con lo stesso nome sul VPS cancellerebbe l'export di 541452707 (2 posizioni il 23/09, `report/IL_PERTRADE_FTMO_ESISTE_2026-09-23.md`; 13 nel cronistorico del 30/09). `pubblica_trades.ps1` r.59 e `IMBUTO_EMA200_FTMO.ps1` r.459 leggono proprio quel nome.

**Procedimento sicuro (proposta, decide Claudio):**
1. **Terminale NUOVO e dedicato, cartella nuova** (es. `C:\FTMO_TRIAL`, nome senza i nomi vietati dalla serratura 2). MAI login dentro `C:\FTMO`: li' dentro restano i 10 grafici con 2% e 80000. `C:\FTMO` non si tocca.
2. Primo avvio con **Algo Trading SPENTO** e nessun EA sui grafici; login con il conto trial.
3. Lettura delle specifiche con `ABTG_PrevoloFTMO_Specifiche.mq5` (uno script: `InpSelezionaSimboli=true` AGGIUNGE simboli a Market Watch, e' il solo effetto): saldo, valuta, leva, server, `DeltaServerGMT`, `VOLUME_MAX`, margine per lotto, nomi simboli. Sul 541452707 diede leva 1:100, server FTMO-Server4, `+03:00` (`report/PREVOLO_FTMO_2026-09-20.md`). Serve anche a verificare l'orologio: l'ultima misura sulla vecchia trial (28/08, XAUUSD H1 09:00 contro PC 08:39) confermo' FTMO = ora italiana +1. La trial va riverificata, non data per uguale.
4. Riconciliazione PRIMA di scrivere qualsiasi file: saldo = 160000? valuta = EUR? `DeltaServerGMT` = +03:00 (estate)? tutti i simboli presenti? Se una risposta e' no, si ferma e si rifanno i preset interessati.
5. Preset di trial in repo (nuovi file, commit, nuovo pin): Guardian `InpStartBalance=160000`; TradeExporter con `InpFile` proprio (e `pubblica_trades.ps1` che lo legga); SpreadLogger con prefisso proprio; Bulge (par. 3); voci in `SCHIERA_FTMO.ps1` per 770105 (preset `ABTG_DAX_Apertura_EU_770105_SHORT_FTMO.set`) e per `ABTG_Bulge.mq5` (pin del file `c4426c53`, righe/SHA da misurare). Le sette sedie: preset e pin dei `.mq5` INVARIATI.
6. Riga di schieramento = `SCHIERA_FTMO.ps1` modificato, con `-ContoAtteso <login trial> -Pin <SHA 40>`; **passa dal cancello** (`controlla_riga.py` + `controllo-preventivo`) e non esce senza PASS. Il bersaglio in testa: finestra PowerShell sulla macchina che ospita il terminale trial; non tocca 50503392, 50504263, 10105439, 50503635, 50504400, 541452707.
7. F7 e attacco a mano (Claudio), Guardian per primo. Poi i tre controlli del par. 8 PRIMA di premere Algo Trading.

## 3. Hedging fra conti: matrice e Bulge
Regola scritta dal supporto (`docs/RISPOSTA_SUPPORTO_FTMO_2026-09-24.md`, `..._09-25.md`, `..._09-29.md` punto 8): vietate posizioni OPPOSTE fra conti diversi "irrespective of the entity", anche demo, anche strumenti correlati (DAX long contro Dow/Nasdaq short), nessuna soglia, anche se accidentale, vale in tutte le fasi. Nello stesso conto l'hedging e' permesso (punto 6). Copia nello stesso verso: permessa. **Se la Free Trial conti come "conto FTMO" per questa regola: [NON MISURATO]**; la lettera del 25/09 nomina "accounts... FTMO accounts, demo accounts, private accounts", quindi va trattata come SI finche' il supporto non dice altro [INFERITO].

**Matrice strumento x conto (stato osservato; fonti CODA_01/CODA_08 del 30/09 03:30, HANDOFF 29-30/09, `SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`)**
| strumento | FTMO trial (previsto) | piccolo 50503392 | 100k 50504263 | reale 10105439 | manuale 50503635 |
|---|---|---|---|---|---|
| DAX (GER40.cash / D30EUR) | 770101 long, 770105 short, 770411 short | nessuna (15 sedie indice tolte 25/09 13:07) | nessuna (DAX 770101/770411 solo nel profilo `Default` NON attivo) | nessuna (770101 tolto 24/09) | `ScalperDirezionale` D30EUR M1 (779901), nel profilo salvato; se vivo: [NON MISURATO] |
| Dow (US30.cash / U30USD) | 770202 long, 771531 L+S, 770511 L+S | nessuna | nessuna | nessuna | - |
| Nasdaq (US100.cash / NASUSD) | 770260 L+S | nessuna | nessuna (PreOpen tolto 24/09) | nessuna | - |
| Nikkei 225JPY | nessuna | nessuna (tolte 25/09) | 770901 tolto 25/09 13:14:47; salvataggio profilo [NON CONFERMATO] | - | - |
| Oro XAUUSD | nessuna in settembre (770402 non schierata) | PunteLarry 772343 L, MaxMin 770402 L+S, EMA200_Ott 971501 L+S, SupRev_Ott 970901 L+S | - | - | `ScalperDirezionale` XAUUSD M1 (vivo: [NON MISURATO]) |
| Forex (22 cross Bulge) | Bulge (se Claudio lo vuole) | Bulge v5.20 (magic 772700, 29/09 ~22:55) + altre sedie forex | - | ORB EURAUD L (770611) | - |
Altri: Tickmill (Gold_Ichimoku XAUUSD M5, BREAKOUT_EA USDJPY M15) muto dal 20/07; Pepperstone zero sedie. Lo snapshot 30/09 03:30 del piccolo e' PRECEDENTE al Bulge nel profilo salvato (il Bulge e' vivo per le foto di Claudio, non ancora per il `.chr`): si conferma con la sonda CODA_01 della prossima notte. Una sovrapposizione opposta per correlazione e' gia' avvenuta il 22/09 (Dow short FTMO contro DAX long su tre conti BCM, 21 min 44 s, `HEDGING_DEMO_E_CORRELATI_2026-09-25.md`): il rischio non e' teorico.

**Separazione piu' semplice per gli indici**: gli indici stanno SOLO sulla trial (oggi nessun conto automatico li ha). Resta da fare con Claudio: (a) accertare che `ScalperDirezionale` su 50503635 sia staccato o spento finche' la trial e' viva; (b) nessuna operazione MANUALE su indici/oro su nessun conto (vale come le automatiche, `SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`); (c) le 15 sedie indice del piccolo restano tolte.

**Bulge viola sulla trial** (preset `mql5/Presets/sedie_piccolo/ABTG_Bulge_v520_piccolo_SOLO_VIOLA.set`: uguale al preset vivo `ADX_spento` salvo `Use_Blue=false`, commit `a3f358ce`, "in attesa del cancello"; 0,80% x `Max_Trades=4`, kill switch `Max_SL_PerDay=4`, `Max_Consecutive_SL=3`, `Max_Daily_Loss_Pct=2.0`, `InpUsaGuardian=true`). Sette dei 22 cross hanno ANCHE altre sedie sul piccolo: EURUSD, GBPUSD, AUDUSD, USDJPY, GBPJPY, GBPCAD, CHFJPY (BreakingBand, GapFill, PunteLarry GBPUSD solo SHORT, EasyTrend, PTE x2, PostNews, CostToCost GBPCAD, PunteLarry GBPJPY). Sul piccolo il Bulge accumula i suoi conteggi dal 29/09 sera (9 chiuse il 30/09, PF 1,33, campione minuscolo, HANDOFF 30/09).
| opzione | pro | contro |
|---|---|---|
| A. Bulge solo sulla trial, tolto dal piccolo | niente Bulge-contro-Bulge | **NON basta**: le altre sedie del piccolo sui 7 cross comuni possono essere opposte al Bulge della trial (es. PunteLarry GBPUSD short contro Bulge long). Interrompe il conteggio delle operazioni del Bulge sul piccolo |
| B. Bulge solo sul piccolo | zero rischio hedging con la trial; il conteggio continua | la trial non prova l'esecuzione forex su FTMO |
| C. cross divisi in due insiemi disgiunti | nessun cross su due conti | per chiudere il rischio bisogna dare alla trial i 15 cross SENZA altre sedie sul piccolo e lasciare al piccolo solo i 7 comuni; ogni conto ha meta' dei segnali; resta la correlazione fra cross diversi (FTMO non da' lista, [NON MISURATO]) |
| D. entrambi, stessi cross, stesso verso | conferma FTMO = BCM (esecuzione, costi) | stesso EA e stessi segnali: NON sono campioni indipendenti (correlazione ~1, il conteggio per il merito non raddoppia). Residuo di versi opposti: candele H1 leggermente diverse fra i due feed ai bordi di BB/ATR/ADX (Bulge_Multi 1,1, `ATR_Max_Mult` 1,8) possono dare un segnale su un feed e non sull'altro, o un viola in verso contrario un'ora dopo; nessuna soglia di tolleranza (supporto 25/09 punto 6); [NON MISURATO] quanto spesso. MT5 non ha canale fra due conti: non lo controlla nessuno |
Se il trial usa SOLO_VIOLA e il piccolo ADX_spento (blu+viola), i blu del piccolo non hanno controparte sulla trial. Scelta di Claudio; la piu' semplice con zero rischio residuo e' B (Bulge sul piccolo, indici sulla trial), la piu' vicina a quanto chiede e' C.

**Nomi e magic del Bulge sulla trial** (proposte, da verificare): i simboli FTMO dei 22 cross sono [NON MISURATO] (il solo forex letto su FTMO e' USDJPY, plain, nel CSV del 20/09; `Symbols_List` e' letterale, un nome assente fa solo `[BULGE] Simbolo non trovato`, `SymbolSelect` r.601). Magic da usare: diverso da 772700; nel repo `7727xx` compaiono 772700 (vivo), 772701 (preset AMPIO), 772702/772710 (assi dei round): **772720** e' libero nel grep [INFERITO, da confermare], commento `BULGE_V520_FT` (13 caratteri + fino a 10 di suffisso = 23 <= 31; non deve contenere `_BLU_`/`_VIOLA_`/`_ARANCIO_`). Con `Symbols_List` ridotta ai 15 o 22 nomi che la trial conferma.

**Domanda pronta per il supporto FTMO (la invia Claudio):**
> Dear FTMO Support, I am about to use an FTMO Free Trial account to test Expert Advisors, while the same EAs also run on demo accounts at another broker. Could you please confirm in writing: (1) Does a Free Trial account count as an "FTMO account" for the rule that prohibits opening opposite positions across different accounts, including demo accounts at other brokers and my other FTMO account? (2) Are the Forbidden Trading Practices (cross-account hedging, correlated instruments) applied to Free Trial accounts in the same way as to Challenge/Verification? (3) For FX pairs, do you treat correlated pairs (for example EURUSD long on one account and GBPUSD short on another) as correlated instruments for this rule, and is there any threshold? (4) Which rules apply to the Free Trial (Max Daily Loss, Max Loss, Standard or Swing, weekend holding, news trading)? Thank you, Claudio Spadaro.

## 4. Cosa si puo' misurare in ~2 settimane e cosa no (durata che Claudio confermera'; 10 giorni di borsa come ordine di grandezza)
Si misura la MECCANICA: esecuzione e fill sul server FTMO, slippage e spread all'ingresso, commissioni/swap, orari (orologio +1 e reset 00:00 CE(S)T), Algo Trading e connessione, Guardian (righe `[GUARDIAN]`, pausa 3,5%, cap C1, battito), rifiuti (`not enough money`, `invalid stops`: il difetto del trailing PREVBAR sul ramo SELL/RETEST e' gia' descritto in `MODIFY_A_RAFFICA_FTMO_2026-09-25.md`), numero di richieste al server contro il tetto 2.000/giorno, lotto reale contro lotto atteso (par. 1), margine usato.
Si misura la FREQUENZA per sedia contro il contratto. Promessa OOS in posizioni/giorno (`CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` par. 6): 770101 0,699; 770202 0,348; 770260 0,360; 771531 0,931; 770511 ~0,294 (stimata; 0,518 in deal); 770411 0,051; 770105 [NON MISURATO]. In 10 giorni: 7; 3,5; 3,6; 9,3; ~3; 0,5: circa 27 per le sei. Osservato in campo 22-30/09: 11 posizioni in 7 giorni di borsa (1,57/giorno), cioe' ~59% del promesso aggregato delle sei sedie (2,68/giorno; le 11 includono le poche della 770105, nata il 28/09); 770411 fece 3 (contratto ~0,5 in 10 giorni); Dow Apertura, Nasdaq, SuperWave zero (`FTMO_PRIMI_OTTO_GIORNI_2026-09-30.md` par. 1-2).
**NON si misura il merito (PF)**: la soglia di casa e' 20 operazioni per famiglia (firma 18/08); in 10 giorni le Aperture fanno ~14, EMA200 ~9, SuperWave ~3, MaxMin ~0,5. La flotta ne ha fatte 11 in 8 giorni con PF 0,31 (`FTMO_CHALLENGE_CHIUSURA_2026-09-30.md` par. 2): ne' prova ne' smentita. Il Bulge (9 operazioni nel solo 30/09, un solo giorno) potrebbe superare 20 operazioni, ma sulla trial e' lo stesso campione del piccolo.

## 5. "Alzare i lotti": conversione in stop pieni (aritmetica, nessuna raccomandazione)
Uniforme (stessa r% per ogni operazione, scelta di rischio di Claudio) e' una cosa; **aumentare dopo una perdita e' martingala, bandiera rossa di casa** e cade anche sulla regola FTMO "substantially larger position sizes compared to your other trades" (`REGOLAMENTO_FTMO_2026-09-20.md` par. 4). Questa tabella vale solo per r uniforme.
Un stop pieno costa r% del saldo corrente (lotto su `ACCOUNT_BALANCE`). Stop osservati sul conto FTMO: da -0,95 a -1,03 R (n=5), quindi 1 R ~ r%. A 160.000 EUR, dal saldo di partenza, composto:
| r per operazione | EUR per stop pieno | stop al limite 5% del giorno | stop al muro 10% | stop alla pausa Guardian 3,5% | rischio aperto se il Bulge ha 4 posizioni (4 x r) | max posizioni con C1 a 4,00% (se il Guardian gira) |
|---:|---:|---:|---:|---:|---:|---:|
| 0,8% | 1.280 | 7 | 14 | 5 | 3,2% (5.120) | 4 (`Max_Trades`) |
| 1,0% | 1.600 | 6 | 11 | 4 | 4,0% (6.400) | 4 |
| 1,5% | 2.400 | 4 | 7 | 3 | **6,0%** (9.600) > 5% | 3 |
| 2,0% | 3.200 | 3 | 6 | 2 | **8,0%** (12.800) > 5% | 2 |
| 3,0% | 4.800 | 2 | 4 | 2 | **12,0%** (19.200) > 10% | 2 |
Non cambia col saldo del conto: e' indipendente dal 160.000 se r e' fisso. Il cap C1 si legge a ogni secondo di timer: ingressi simultanei nello stesso secondo possono superarlo. Con 4 stop insieme (segnali correlati sui cross) a r >= 1,5% si sfonda il limite del giorno in un colpo; a r = 3,0% il muro intero. I numeri sono di sola ragioneria: senza slippage, gap, commissioni; un gap non passa dal Guardian (`InpAction=0` chiude, ma "nessuno chiude attraverso un gap", preset Guardian).
**Bulge, giorni per consumare il muro 10% contando SOLO gli stop** (ignora le vincite: e' un limite alla velocita', non una stima del tempo a fallire). Base: ~9 operazioni/giorno, misurato su UNA giornata (30/09, 9 chiuse: HANDOFF). r = rischio per trade con fino a 4 aperte insieme.
| win rate | stop/giorno (9 x (1 - w)) | r=0,8% (14 stop) | r=1,0% (11) | r=1,5% (7) | r=2,0% (6) | r=3,0% (4) |
|---:|---:|---:|---:|---:|---:|---:|
| 85% | 1,35 | 10,4 gg | 8,1 | 5,2 | 4,4 | 3,0 |
| 88% | 1,08 | 13,0 | 10,2 | 6,5 | 5,6 | 3,7 |
| 90% | 0,90 | 15,6 | 12,2 | 7,8 | 6,7 | 4,4 |
| 92% | 0,72 | 19,4 | 15,3 | 9,7 | 8,3 | 5,6 |
| 95% | 0,45 | 31,1 | 24,4 | 15,6 | 13,3 | 8,9 |
Win rate vero del Bulge: [NON MISURATO] (la misura e' R92b). Le vincite ridanno qualcosa: il 30/09 i 7 TP fecero +53,17 contro 1 SL pieno -39,86 (0,19 R per vincita); il rapporto SL/TP delle 9 va da 0,7 a 181 (mediana 9,8, cioe' ~0,10 R). Il pareggio e' un win rate di 1/(1+g): **84%** con g = 0,19, **90,9%** con g = 0,10. Quindi 85-90% e' attorno al pareggio e sotto, e 92-95% e' sopra: il numero decide il segno. Kill switch del Bulge: si ferma alla 4a perdita del giorno o a -2% di P/L chiuso del giorno; non chiude le aperte, e conta ore di server BCM/FTMO (mezzanotte server, non 00:00 CE(S)T) [INFERITO da `GetTodayStart`].
**Nota**: la trial e' il posto dove la taglia va PROVATA alla taglia finale, ma un Max Loss violato sulla trial spreca i giorni della trial (durata e rinnovo [NON MISURATO]). Lezione del 30/09: margine 997 EUR contro uno stop da ~1.500 = 0,66 stop; il margine si misura in stop pieni.

## 6. Regole da scrivere PRIMA di partire
1. **Nessun trade manuale sullo stesso conto degli EA** (il 28/09 due manuali sull'oro costarono -2.502,06 e il 30/09 altri tre -999,43 lordi: hanno chiuso la challenge; il Guardian ferma solo gli ingressi degli EA, `FTMO_CHALLENGE_CHIUSURA_2026-09-30.md` par. 5). Nessun trade manuale su indici/oro su NESSUN conto mentre la trial e' viva (hedging, punto 8).
2. **Filtro news/weekend**: in Evaluation non vale (`RISPOSTA_SUPPORTO_FTMO_2026-09-29.md` punti 2-4; che la Free Trial sia Evaluation e' [LETTO-VIA-SEARCH], `RICERCA_REGOLE_FTMO_2026-08-27.md`; per la trial [NON MISURATO]). Alla fase funded servono chiusura del venerdi' e filtro news a livello di conto, oggi assenti (`InpFridayClose=false` su 771531, SuperWave 0-24).
3. **Orologio**: FTMO = ora italiana +1 tutto l'anno, BCM = IT - 1 d'estate e IT d'inverno (`OROLOGIO_BCM_2026-09-24.md`; decisione di Claudio entro il 25/10, settimana 26-30/10 [NON MISURATA]). Se la trial dura oltre il 25/10 va riletto il server; oggi i `.set` FTMO sono rimappati +2 dai valori BCM.
4. **Esportazione giornaliera**: TradeExporter ogni 30 minuti (file proprio) + storico Metrix (xlsx) di Claudio a fine giornata. E prima del 05/10: storico completo finale di 541452707 e ordini pendenti cancellati, poi l'accesso si spegne (CHIUSURA par. 4.2).
5. **Da raccogliere ogni giorno**: log Esperti + Giornale del terminale trial (zip sul Desktop, regola 11/08), righe `[GUARDIAN]`, conteggio rifiuti per codice, posizioni/pendenti per sedia, richieste al server, equity minima del giorno e distanza dalla linea in stop pieni, margin level minimo, lotto reale contro atteso, stato Algo Trading/connessione alle 09:00 IT.

## 7. Checklist di partenza
| # | voce | stato | chi |
|---|---|---|---|
| 1 | Aprire la Free Trial, screenshot Trading Objectives/Metrix | manca | Claudio |
| 2 | Decidere macchina del terminale trial (VPS sempre acceso o PC di backtest) | manca | Claudio |
| 3 | Terminale dedicato, cartella nuova, NON `C:\FTMO` | manca | Claudio (bersaglio dichiarato) |
| 4 | PREVOLO: saldo, valuta, leva, server, orologio, VolMax, simboli | script pronto, non lanciato sulla trial | Claudio lancia, Claude legge |
| 5 | Risposta del supporto sulla Free Trial e l'hedging | manca | Claudio invia (par. 3) |
| 6 | Decisione Bulge (A/B/C/D) e 3 numeri (par. 9) | manca | Claudio |
| 7 | Preset trial: Guardian 160000, Exporter, SpreadLogger, Bulge; voci 770105 e Bulge in `SCHIERA_FTMO.ps1`; pin nuovo | manca | Claude |
| 8 | Cancello sulla riga (`controlla_riga.py` + `controllo-preventivo`) | manca (scatta dopo il punto 7) | Claude |
| 9 | Conferma Bulge nel profilo del piccolo e `ScalperDirezionale` su 50503635 | in corso (sonda CODA_01 di stanotte) | Claude / Claudio |
| 10 | Storico completo 541452707 prima del ~05/10 | manca | Claudio |
| 11 | Riproduzione RFWD nel tester (PC di backtest) | riga pronta, non lanciata | Claudio |
| 12 | `C:\FTMO` non spento in fretta e non usato per la trial | fatto (regola), da mantenere | tutti |

## 8. Sequenza operativa e i tre controlli
1. Claudio apre la trial dal sito FTMO (nessun terminale). 2. Installa il terminale dedicato (par. 2, punto 1). 3. Login, Algo Trading spento, nessun EA. 4. PREVOLO. 5. Riconciliazione (par. 2, punto 4). 6. Preset trial in repo, commit e pin, cancello, riga di schieramento. 7. F7 e attacco a mano, Guardian per primo. 8. Tre controlli, poi Algo Trading.
- **Controllo 1, identita'**: il titolo della finestra e il giornale mostrano il LOGIN della trial e il suo server, non 541452707; la cartella dati e' quella nuova (hash diverso da `46C9F8E9...`).
- **Controllo 2, Guardian**: la riga di avvio stampa `gStart=160000` e i limiti 7.200 / 14.880; le variabili globali (F3) `ABTG_GUARD_<login trial>_START_V2 = 160000`.
- **Controllo 3, ogni sedia**: faccina sul grafico, finestra input con `InpRiskPercent` come scelto da Claudio, magic giusto, `InpUsaGuardian=true`; al primo ingresso il lotto reale e' coerente con saldo x r / stop (e non inferiore per il massimo di lotto).

## 9. Fatti che Claudio deve dare all'apertura, e i tre numeri che restano suoi
Fatti: saldo (conferma 160.000), valuta (EUR), durata e data di scadenza e cosa succede dopo, nome del server, login, leva (forex, indici, oro), nomi dei simboli (22 cross, GER40/US30/US100 e suffissi), finestre orarie e pause di mercato per simbolo (Specifica), Max Daily/Max Loss e tipo (statico/trailing, Standard/Swing) mostrati dalla pagina, commissioni, se il lotto massimo per strumento e' quello letto dal PREVOLO. Inoltre: dove gira il terminale, se i 160K sono solo la Free Trial (spesa zero) o anche una challenge a pagamento (la spesa e' sua; qui non assumo nulla sui termini di una taglia a pagamento).
Tre numeri di Claudio: **(1) rischio per operazione** (par. 5), **(2) quali sedie** (le sette, il Bulge, altro), **(3) margine minimo dal muro espresso in stop pieni** (il 30/09 era 0,66).
